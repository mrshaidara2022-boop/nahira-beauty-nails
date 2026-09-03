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

  // User-scoped client (respects RLS)
  const sb = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: authHeader } },
  });

  const { data: { user }, error: uErr } = await sb.auth.getUser();
  if (uErr || !user) return json({ error: "Unauthorized" }, 401);

  let body: { course_id: string; answers: { question_id: string; selected_index: number }[] };
  try { body = await req.json(); } catch { return json({ error: "Invalid JSON" }, 400); }

  const { course_id, answers } = body;
  if (!course_id || !Array.isArray(answers)) return json({ error: "Missing course_id or answers" }, 400);

  // Verify enrollment
  const { data: enrollment } = await sb.from("academy_enrollments")
    .select("id")
    .eq("user_id", user.id)
    .eq("course_id", course_id)
    .maybeSingle();
  if (!enrollment) return json({ error: "Not enrolled" }, 403);

  // Service-role client for reading correct answers
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

  const { data: questions, error: qErr } = await admin.from("academy_quiz_questions")
    .select("id, correct_index")
    .eq("course_id", course_id);
  if (qErr || !questions) return json({ error: "Could not load questions" }, 500);

  // Score calculation
  const total   = questions.length;
  let   correct = 0;
  for (const q of questions) {
    const a = answers.find((x) => x.question_id === q.id);
    if (a && a.selected_index === q.correct_index) correct++;
  }
  const score = total > 0 ? Math.round((correct / total) * 100) : 0;

  // Passing threshold from course
  const { data: course } = await admin.from("academy_courses")
    .select("passing_score")
    .eq("id", course_id)
    .single();
  const passed = score >= (course?.passing_score ?? 70);

  // Save attempt
  await sb.from("academy_quiz_attempts").insert({
    user_id:  user.id,
    course_id,
    score,
    passed,
    answers,
  });

  // Generate certificate if passed
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
      // Fetch recipient name from profiles (service role bypasses RLS)
      const { data: profile } = await admin.from("profiles")
        .select("full_name")
        .eq("id", user.id)
        .maybeSingle();
      const recipient_name = profile?.full_name || user.email?.split("@")[0] || "Participante";

      const { data: cert } = await admin.from("academy_certificates")
        .insert({ user_id: user.id, course_id })
        .select("reference")
        .single();
      certificate_reference = cert?.reference ?? null;
    }
  }

  return json({ passed, score, total, correct, certificate_reference });
});
