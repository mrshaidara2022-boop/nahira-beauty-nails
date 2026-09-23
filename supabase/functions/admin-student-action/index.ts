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
    // --- Extract JWT ---
    const authHeader = req.headers.get("Authorization") || "";
    const jwt = authHeader.replace(/^Bearer\s+/i, "").trim();
    if (!jwt) return error("Authorization manquante.", 401);

    // --- Admin client (service_role) ---
    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
      { auth: { autoRefreshToken: false, persistSession: false } }
    );

    // --- Verify caller identity ---
    const { data: { user }, error: authErr } = await admin.auth.getUser(jwt);
    if (authErr || !user) return error("Token invalide.", 401);

    // --- Verify admin role ---
    const { data: profile } = await admin
      .from("profiles").select("role").eq("id", user.id).single();
    if (profile?.role !== "admin") return error("Accès refusé — rôle admin requis.", 403);

    // --- Parse body ---
    const body = await req.json();
    const { action } = body;

    // ─── enroll ───────────────────────────────────────────────────────────────
    if (action === "enroll") {
      const { course_id, user_email } = body;
      if (!course_id || !user_email) return error("course_id et user_email requis.", 400);

      const { data: targetProfile } = await admin
        .from("profiles").select("id")
        .eq("email", user_email.trim().toLowerCase()).single();
      if (!targetProfile)
        return error(
          "Aucun compte trouvé pour cet e-mail. L'élève doit d'abord créer un compte sur le site.",
          404
        );

      const targetUserId = targetProfile.id;
      const { data: existing } = await admin
        .from("academy_enrollments").select("id")
        .eq("user_id", targetUserId).eq("course_id", course_id).single();
      if (existing) return error("Cet élève est déjà inscrit(e) à cette formation.", 409);

      const { data: enr, error: enrErr } = await admin
        .from("academy_enrollments")
        .insert({ user_id: targetUserId, course_id })
        .select("id").single();
      if (enrErr) return error("Erreur lors de l'inscription : " + enrErr.message, 500);

      await admin.from("admin_logs").insert({
        admin_id: user.id, action: "enroll",
        target_table: "academy_enrollments", target_id: enr.id,
        target_user_id: targetUserId, target_course_id: course_id,
        details: { user_email: user_email.trim().toLowerCase(), enrollment_id: enr.id },
      });
      return new Response(JSON.stringify({ ok: true, enrollment_id: enr.id }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // ─── unenroll ─────────────────────────────────────────────────────────────
    if (action === "unenroll") {
      const { enrollment_id } = body;
      if (!enrollment_id) return error("enrollment_id requis.", 400);

      const { data: enr } = await admin
        .from("academy_enrollments")
        .select("id,user_id,course_id,enrolled_at").eq("id", enrollment_id).single();
      if (!enr) return error("Inscription introuvable.", 404);

      const { error: delErr } = await admin
        .from("academy_enrollments").delete().eq("id", enrollment_id);
      if (delErr) return error("Erreur lors du retrait : " + delErr.message, 500);

      await admin.from("admin_logs").insert({
        admin_id: user.id, action: "unenroll",
        target_table: "academy_enrollments", target_id: enrollment_id,
        target_user_id: enr.user_id, target_course_id: enr.course_id,
        details: {
          before: {
            enrollment_id: enr.id, user_id: enr.user_id,
            course_id: enr.course_id, enrolled_at: enr.enrolled_at,
          },
        },
      });
      return new Response(JSON.stringify({ ok: true }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // ─── reset_progress (atomic via RPC) ─────────────────────────────────────
    if (action === "reset_progress") {
      const { enrollment_id, user_id, course_id, reason } = body;
      if (!enrollment_id || !user_id || !course_id)
        return error("enrollment_id, user_id, course_id requis.", 400);

      const { data, error: rpcErr } = await admin.rpc("admin_reset_progress", {
        p_admin_id:      user.id,
        p_user_id:       user_id,
        p_course_id:     course_id,
        p_enrollment_id: enrollment_id,
        p_reason:        reason || null,
      });
      if (rpcErr) return error("Erreur reset_progress : " + rpcErr.message, 500);
      return new Response(JSON.stringify(data), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // ─── invalidate_quiz (atomic via RPC) ────────────────────────────────────
    if (action === "invalidate_quiz") {
      const { attempt_id, reason } = body;
      if (!attempt_id) return error("attempt_id requis.", 400);

      const { data, error: rpcErr } = await admin.rpc("admin_invalidate_quiz", {
        p_admin_id:   user.id,
        p_attempt_id: attempt_id,
        p_reason:     reason || null,
      });
      if (rpcErr) return error("Erreur invalidate_quiz : " + rpcErr.message, 500);
      return new Response(JSON.stringify(data), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // ─── regen_certificate (atomic via RPC) ──────────────────────────────────
    if (action === "regen_certificate") {
      const { user_id, course_id, recipient_name } = body;
      if (!user_id || !course_id || !recipient_name)
        return error("user_id, course_id, recipient_name requis.", 400);

      const { data, error: rpcErr } = await admin.rpc("admin_regen_certificate", {
        p_admin_id:       user.id,
        p_user_id:        user_id,
        p_course_id:      course_id,
        p_recipient_name: recipient_name,
      });
      if (rpcErr) return error("Erreur regen_certificate : " + rpcErr.message, 500);
      return new Response(JSON.stringify(data), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    return error("Action inconnue : " + String(action), 400);
  } catch (e: any) {
    console.error("admin-student-action error:", e);
    return error(e.message || "Erreur inattendue.", 500);
  }
});
