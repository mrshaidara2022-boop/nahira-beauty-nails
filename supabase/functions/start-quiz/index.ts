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

const QUESTIONS_PER_QUIZ = 20;

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

  // Abort any stale in_progress attempts for this user+course
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);
  await admin.from("academy_quiz_attempts")
    .update({ status: "abandoned" })
    .eq("user_id", user.id)
    .eq("course_id", course_id)
    .eq("status", "in_progress");

  // Draw 20 random questions (no correct_index exposed — admin fetches by sort only)
  const { data: questions, error: qErr } = await admin.from("academy_quiz_questions")
    .select("id, question, options")
    .eq("course_id", course_id)
    .order("sort_order");

  if (qErr || !questions || questions.length === 0)
    return json({ error: "No questions available" }, 500);

  // Fisher-Yates shuffle then take first QUESTIONS_PER_QUIZ
  const pool = [...questions];
  for (let i = pool.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [pool[i], pool[j]] = [pool[j], pool[i]];
  }
  const selected = pool.slice(0, Math.min(QUESTIONS_PER_QUIZ, pool.length));

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

  // Return attempt_id + questions (NO correct_index, NO explanation)
  return json({
    attempt_id: attempt.id,
    questions:  selected.map((q) => ({
      question_id: q.id,
      question:    q.question,
      options:     q.options,
    })),
  });
});
