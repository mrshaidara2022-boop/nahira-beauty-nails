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

  let body: { course_id: string };
  try { body = await req.json(); } catch { return json({ error: "Invalid JSON" }, 400); }

  const { course_id } = body;
  if (!course_id) return json({ error: "Missing course_id" }, 400);

  // Verify enrollment
  const { data: enrollment } = await sb.from("academy_enrollments")
    .select("id")
    .eq("user_id", user.id)
    .eq("course_id", course_id)
    .maybeSingle();
  if (!enrollment) return json({ error: "Not enrolled" }, 403);

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

  // Read course config: questions_per_quiz, max_attempts, quiz texts
  const { data: courseConfig } = await admin.from("academy_courses")
    .select("questions_per_quiz, max_attempts, quiz_success_title, quiz_success_message, quiz_failure_title, quiz_failure_message")
    .eq("id", course_id)
    .single();

  const questionsPerQuiz: number  = courseConfig?.questions_per_quiz ?? 20;
  const maxAttempts: number | null = courseConfig?.max_attempts ?? null;

  // P2.1 — Max attempts check (counts only completed, non-invalidated attempts)
  if (maxAttempts !== null) {
    const { count } = await admin.from("academy_quiz_attempts")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .eq("course_id", course_id)
      .eq("status", "completed")
      .eq("is_invalidated", false);

    const used = count ?? 0;
    if (used >= maxAttempts) {
      return json({
        error:          "max_attempts_reached",
        attempts_used:  used,
        max_attempts:   maxAttempts,
      }, 403);
    }
  }

  // Abort any stale in_progress attempts for this user+course
  await admin.from("academy_quiz_attempts")
    .update({ status: "abandoned" })
    .eq("user_id", user.id)
    .eq("course_id", course_id)
    .eq("status", "in_progress");

  // P2.2 — Draw random active questions only (no correct_index exposed)
  const { data: questions, error: qErr } = await admin.from("academy_quiz_questions")
    .select("id, question, options")
    .eq("course_id", course_id)
    .eq("is_active", true)
    .order("sort_order");

  if (qErr || !questions || questions.length === 0)
    return json({ error: "no_active_questions" }, 500);

  // Fisher-Yates shuffle then take min(questionsPerQuiz, available)
  const pool = [...questions];
  for (let i = pool.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [pool[i], pool[j]] = [pool[j], pool[i]];
  }
  const selected = pool.slice(0, Math.min(questionsPerQuiz, pool.length));

  // Compute remaining attempts for the client (null = unlimited)
  let attemptsRemaining: number | null = null;
  if (maxAttempts !== null) {
    const { count: usedSoFar } = await admin.from("academy_quiz_attempts")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .eq("course_id", course_id)
      .eq("status", "completed")
      .eq("is_invalidated", false);
    // +1 because we're about to create one
    attemptsRemaining = maxAttempts - ((usedSoFar ?? 0) + 1);
    if (attemptsRemaining < 0) attemptsRemaining = 0;
  }

  // Create attempt (score=0 placeholder, updated on submit)
  const { data: attempt, error: aErr } = await admin.from("academy_quiz_attempts")
    .insert({
      user_id:         user.id,
      course_id,
      score:           0,
      passed:          false,
      answers:         [],
      total_questions: selected.length,
      started_at:      new Date().toISOString(),
      status:          "in_progress",
    })
    .select("id")
    .single();

  if (aErr || !attempt) return json({ error: "Could not create attempt" }, 500);

  // Assign selected questions to this attempt
  const rows = selected.map((q) => ({
    attempt_id:  attempt.id,
    question_id: q.id,
  }));
  const { error: aqErr } = await admin.from("academy_quiz_attempt_questions").insert(rows);
  if (aqErr) return json({ error: "Could not assign questions" }, 500);

  // P2.3 — Return quiz texts (null means use frontend fallback)
  return json({
    attempt_id:         attempt.id,
    questions:          selected.map((q) => ({
      question_id: q.id,
      question:    q.question,
      options:     q.options,
    })),
    attempts_remaining: attemptsRemaining,
    quiz_success_title:   courseConfig?.quiz_success_title   ?? null,
    quiz_success_message: courseConfig?.quiz_success_message ?? null,
    quiz_failure_title:   courseConfig?.quiz_failure_title   ?? null,
    quiz_failure_message: courseConfig?.quiz_failure_message ?? null,
  });
});
