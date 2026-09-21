import { createClient } from "https://esm.sh/@supabase/supabase-js@2?target=deno";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function error(message: string, status: number) {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // --- Extract JWT from Authorization header ---
    const authHeader = req.headers.get("Authorization") || "";
    const jwt = authHeader.replace(/^Bearer\s+/i, "").trim();
    if (!jwt) return error("Authorization manquante.", 401);

    // --- Admin client (service_role — bypasses RLS for admin ops) ---
    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
      { auth: { autoRefreshToken: false, persistSession: false } }
    );

    // --- Verify calling user identity via their JWT ---
    const { data: { user }, error: authErr } = await admin.auth.getUser(jwt);
    if (authErr || !user) return error("Token invalide.", 401);

    // --- Verify admin role in profiles ---
    const { data: profile } = await admin
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();
    if (profile?.role !== "admin") return error("Accès refusé — rôle admin requis.", 403);

    // --- Parse body ---
    const body = await req.json();
    const { action } = body;

    // ─── ACTION: enroll ───────────────────────────────────────────────────────
    if (action === "enroll") {
      const { course_id, user_email } = body;
      if (!course_id || !user_email) return error("course_id et user_email requis.", 400);

      // Lookup student by email in profiles (synced by trigger)
      const { data: targetProfile } = await admin
        .from("profiles")
        .select("id")
        .eq("email", user_email.trim().toLowerCase())
        .single();

      if (!targetProfile) {
        return error(
          "Aucun compte trouvé pour cet e-mail. L'élève doit d'abord créer un compte sur le site.",
          404
        );
      }

      const targetUserId = targetProfile.id;

      // Guard: already enrolled?
      const { data: existing } = await admin
        .from("academy_enrollments")
        .select("id")
        .eq("user_id", targetUserId)
        .eq("course_id", course_id)
        .single();

      if (existing) {
        return error("Cet élève est déjà inscrit(e) à cette formation.", 409);
      }

      // Insert enrollment
      const { data: enr, error: enrErr } = await admin
        .from("academy_enrollments")
        .insert({ user_id: targetUserId, course_id })
        .select("id")
        .single();

      if (enrErr) return error("Erreur lors de l'inscription : " + enrErr.message, 500);

      // Log
      await admin.from("admin_logs").insert({
        admin_id: user.id,
        action: "enroll",
        target_table: "academy_enrollments",
        target_id: enr.id,
        target_user_id: targetUserId,
        target_course_id: course_id,
        details: { user_email: user_email.trim().toLowerCase(), enrollment_id: enr.id },
      });

      return new Response(JSON.stringify({ ok: true, enrollment_id: enr.id }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // ─── ACTION: unenroll ─────────────────────────────────────────────────────
    if (action === "unenroll") {
      const { enrollment_id } = body;
      if (!enrollment_id) return error("enrollment_id requis.", 400);

      // Snapshot enrollment data before deletion
      const { data: enr } = await admin
        .from("academy_enrollments")
        .select("id,user_id,course_id,enrolled_at")
        .eq("id", enrollment_id)
        .single();

      if (!enr) return error("Inscription introuvable.", 404);

      // Delete ONLY the enrollment row — progress, quiz, certificates untouched
      const { error: delErr } = await admin
        .from("academy_enrollments")
        .delete()
        .eq("id", enrollment_id);

      if (delErr) return error("Erreur lors du retrait : " + delErr.message, 500);

      // Log with full before-snapshot
      await admin.from("admin_logs").insert({
        admin_id: user.id,
        action: "unenroll",
        target_table: "academy_enrollments",
        target_id: enrollment_id,
        target_user_id: enr.user_id,
        target_course_id: enr.course_id,
        details: {
          before: {
            enrollment_id: enr.id,
            user_id: enr.user_id,
            course_id: enr.course_id,
            enrolled_at: enr.enrolled_at,
          },
        },
      });

      return new Response(JSON.stringify({ ok: true }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    return error("Action inconnue : " + String(action), 400);
  } catch (e: any) {
    console.error("admin-student-action error:", e);
    return error(e.message || "Erreur inattendue.", 500);
  }
});
