import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL         = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_ANON_KEY    = Deno.env.get("SUPABASE_ANON_KEY")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...CORS },
  });
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });
  if (req.method !== "POST")    return json({ error: "Method not allowed" }, 405);

  const authHeader = req.headers.get("Authorization");
  if (!authHeader) return json({ error: "Unauthorized" }, 401);

  const sb = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: authHeader } },
  });

  const { data: { user }, error: uErr } = await sb.auth.getUser();
  if (uErr || !user) return json({ error: "Unauthorized" }, 401);

  let body: { attempt_id: string; answers: { question_id: string; selected_index: number }[] };
  try { body = await req.json(); } catch { return json({ error: "Invalid JSON" }, 400); }

  const { attempt_id, answers } = body;
  if (!attempt_id || !Array.isArray(answers)) return json({ error: "Missing attempt_id or answers" }, 400);

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

  // Verify attempt belongs to this user and is still in_progress
  const { data: attempt, error: atErr } = await admin.from("academy_quiz_attempts")
    .select("id, user_id, course_id, status")
    .eq("id", attempt_id)
    .single();

  if (atErr || !attempt)                    return json({ error: "Attempt not found" }, 404);
  if (attempt.user_id !== user.id)          return json({ error: "Forbidden" }, 403);
  if (attempt.status !== "in_progress")     return json({ error: "Attempt already completed" }, 409);

  const course_id = attempt.course_id;

  // Fetch the exact 20 question IDs assigned to this attempt
  const { data: assignedRows, error: aqErr } = await admin.from("academy_quiz_attempt_questions")
    .select("question_id")
    .eq("attempt_id", attempt_id);

  if (aqErr || !assignedRows) return json({ error: "Could not load session questions" }, 500);

  const assignedIds = new Set(assignedRows.map((r) => r.question_id));
  const total_questions = assignedIds.size;

  // Validate: answers must cover exactly the assigned questions, no more, no less
  if (answers.length !== total_questions) return json({ error: "Answer count mismatch" }, 400);

  const submittedIds = new Set(answers.map((a) => a.question_id));
  for (const id of submittedIds) {
    if (!assignedIds.has(id)) return json({ error: "Answer references unknown question" }, 400);
  }
  if (submittedIds.size !== answers.length) return json({ error: "Duplicate question answers" }, 400);

  // Fetch correct_index for assigned questions via service-role (never exposed to client)
  const { data: correctData, error: cErr } = await admin.from("academy_quiz_questions")
    .select("id, correct_index, explanation")
    .in("id", [...assignedIds]);

  if (cErr || !correctData) return json({ error: "Could not load correct answers" }, 500);

  const correctMap = new Map(correctData.map((q) => [q.id, { correct_index: q.correct_index, explanation: q.explanation }]));

  // Grade
  let correct_count = 0;
  const results: { question_id: string; selected_index: number; is_correct: boolean; correct_index: number; explanation: string | null }[] = [];

  for (const answer of answers) {
    const qData = correctMap.get(answer.question_id);
    const is_correct = qData ? answer.selected_index === qData.correct_index : false;
    if (is_correct) correct_count++;
    results.push({
      question_id:    answer.question_id,
      selected_index: answer.selected_index,
      is_correct,
      correct_index:  qData?.correct_index ?? -1,
      explanation:    qData?.explanation ?? null,
    });
  }

  // Passing threshold from course
  const { data: course } = await admin.from("academy_courses")
    .select("passing_score")
    .eq("id", course_id)
    .single();
  const passing_score = course?.passing_score ?? 70;

  const score  = total_questions > 0 ? Math.round((correct_count / total_questions) * 100) : 0;
  const passed = score >= passing_score;

  const now = new Date().toISOString();

  // Update attempt
  await admin.from("academy_quiz_attempts").update({
    score,
    passed,
    correct_count,
    total_questions,
    completed_at: now,
    status:       "completed",
    answers,
  }).eq("id", attempt_id);

  // Update per-question result rows
  const updateRows = answers.map((a) => ({
    attempt_id,
    question_id:    a.question_id,
    selected_index: a.selected_index,
    is_correct:     results.find((r) => r.question_id === a.question_id)?.is_correct ?? false,
  }));

  for (const row of updateRows) {
    await admin.from("academy_quiz_attempt_questions")
      .update({ selected_index: row.selected_index, is_correct: row.is_correct })
      .eq("attempt_id", row.attempt_id)
      .eq("question_id", row.question_id);
  }

  // Certificate (only on pass)
  let certificate_reference: string | null = null;
  if (passed) {
    const { data: existing } = await admin.from("academy_certificates")
      .select("reference")
      .eq("user_id", user.id)
      .eq("course_id", course_id)
      .maybeSingle();

    if (existing) {
      certificate_reference = existing.reference;
    } else {
      const { data: profile } = await admin.from("profiles")
        .select("full_name")
        .eq("id", user.id)
        .maybeSingle();
      const recipient_name = profile?.full_name || user.email?.split("@")[0] || "Participante";

      const { data: cert } = await admin.from("academy_certificates")
        .insert({
          user_id:         user.id,
          course_id,
          recipient_name,
          score,
          correct_count,
          total_questions,
          attempt_id,
        })
        .select("reference")
        .single();
      certificate_reference = cert?.reference ?? null;
    }
  }

  return json({ passed, score, total_questions, correct_count, certificate_reference, results });
});
