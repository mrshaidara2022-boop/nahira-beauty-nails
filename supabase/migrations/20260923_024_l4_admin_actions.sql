-- ═══════════════════════════════════════════════════════════════════════
-- L4 — Admin actions: schema additions + atomic RPCs
-- ═══════════════════════════════════════════════════════════════════════

-- ── 1. Quiz attempts: invalidation columns ───────────────────────────
ALTER TABLE academy_quiz_attempts
  ADD COLUMN IF NOT EXISTS is_invalidated  BOOLEAN   NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS invalidated_at  TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS invalidated_by  UUID,
  ADD COLUMN IF NOT EXISTS invalidation_reason TEXT;

-- ── 2. Certificates: versioning columns ──────────────────────────────
ALTER TABLE academy_certificates
  ADD COLUMN IF NOT EXISTS is_current    BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS superseded_by UUID,
  ADD COLUMN IF NOT EXISTS supersedes    UUID;

-- ── 3. RPC: admin_reset_progress ─────────────────────────────────────
CREATE OR REPLACE FUNCTION admin_reset_progress(
  p_admin_id      UUID,
  p_user_id       UUID,
  p_course_id     UUID,
  p_enrollment_id UUID,
  p_reason        TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
DECLARE
  v_progress_count INTEGER;
  v_last_visited   UUID;
  v_log_id         UUID;
BEGIN
  PERFORM 1 FROM profiles WHERE id = p_admin_id AND role = 'admin';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Accès refusé — rôle admin requis.';
  END IF;

  SELECT COUNT(*) INTO v_progress_count
  FROM academy_progress
  WHERE user_id = p_user_id AND course_id = p_course_id;

  SELECT last_visited_lesson_id INTO v_last_visited
  FROM academy_enrollments WHERE id = p_enrollment_id;

  DELETE FROM academy_progress
  WHERE user_id = p_user_id AND course_id = p_course_id;

  UPDATE academy_enrollments
  SET last_visited_lesson_id = NULL
  WHERE id = p_enrollment_id;

  INSERT INTO admin_logs (admin_id, action, target_table, target_id,
    target_user_id, target_course_id, details)
  VALUES (p_admin_id, 'reset_progress', 'academy_progress',
    p_enrollment_id::TEXT, p_user_id, p_course_id,
    jsonb_build_object(
      'progress_rows_deleted', v_progress_count,
      'last_visited_lesson_id_before', v_last_visited,
      'reason', p_reason))
  RETURNING id INTO v_log_id;

  RETURN jsonb_build_object('ok', true, 'deleted_rows', v_progress_count, 'log_id', v_log_id);
END;
$$;

REVOKE EXECUTE ON FUNCTION admin_reset_progress(UUID,UUID,UUID,UUID,TEXT) FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION admin_reset_progress(UUID,UUID,UUID,UUID,TEXT) TO service_role;

-- ── 4. RPC: admin_invalidate_quiz ────────────────────────────────────
CREATE OR REPLACE FUNCTION admin_invalidate_quiz(
  p_admin_id   UUID,
  p_attempt_id UUID,
  p_reason     TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
DECLARE
  v_attempt RECORD;
  v_log_id  UUID;
BEGIN
  PERFORM 1 FROM profiles WHERE id = p_admin_id AND role = 'admin';
  IF NOT FOUND THEN RAISE EXCEPTION 'Accès refusé — rôle admin requis.'; END IF;

  SELECT * INTO v_attempt FROM academy_quiz_attempts WHERE id = p_attempt_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Tentative introuvable.'; END IF;
  IF v_attempt.is_invalidated THEN RAISE EXCEPTION 'Tentative déjà invalidée.'; END IF;

  UPDATE academy_quiz_attempts
  SET is_invalidated = true, invalidated_at = NOW(),
      invalidated_by = p_admin_id, invalidation_reason = p_reason
  WHERE id = p_attempt_id;

  INSERT INTO admin_logs (admin_id, action, target_table, target_id,
    target_user_id, target_course_id, details)
  VALUES (p_admin_id, 'invalidate_quiz', 'academy_quiz_attempts',
    p_attempt_id::TEXT, v_attempt.user_id, v_attempt.course_id,
    jsonb_build_object(
      'before', jsonb_build_object(
        'attempt_id', v_attempt.id, 'score', v_attempt.score,
        'passed', v_attempt.passed, 'correct_count', v_attempt.correct_count,
        'total_questions', v_attempt.total_questions,
        'attempted_at', v_attempt.attempted_at, 'status', v_attempt.status),
      'reason', p_reason))
  RETURNING id INTO v_log_id;

  RETURN jsonb_build_object('ok', true, 'log_id', v_log_id);
END;
$$;

REVOKE EXECUTE ON FUNCTION admin_invalidate_quiz(UUID,UUID,TEXT) FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION admin_invalidate_quiz(UUID,UUID,TEXT) TO service_role;

-- ── 5. RPC: admin_regen_certificate ──────────────────────────────────
CREATE OR REPLACE FUNCTION admin_regen_certificate(
  p_admin_id       UUID,
  p_user_id        UUID,
  p_course_id      UUID,
  p_recipient_name TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
DECLARE
  v_old_cert      RECORD;
  v_new_cert_id   UUID;
  v_new_reference TEXT;
  v_log_id        UUID;
  v_seq           INTEGER;
BEGIN
  PERFORM 1 FROM profiles WHERE id = p_admin_id AND role = 'admin';
  IF NOT FOUND THEN RAISE EXCEPTION 'Accès refusé — rôle admin requis.'; END IF;

  SELECT * INTO v_old_cert FROM academy_certificates
  WHERE user_id = p_user_id AND course_id = p_course_id AND is_current = true
  ORDER BY issued_at DESC LIMIT 1;

  SELECT COALESCE(MAX(
    CASE WHEN reference ~ '^NAH-\d{4}-\d+$'
      THEN (regexp_replace(reference, '^NAH-\d{4}-', ''))::INTEGER
      ELSE 0 END), 0) + 1
  INTO v_seq FROM academy_certificates;

  v_new_reference := 'NAH-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD(v_seq::TEXT, 4, '0');

  INSERT INTO academy_certificates (
    user_id, course_id, reference, issued_at, recipient_name,
    score, correct_count, total_questions, attempt_id, is_current, supersedes)
  VALUES (
    p_user_id, p_course_id, v_new_reference, NOW(), p_recipient_name,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.score         ELSE NULL END,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.correct_count ELSE NULL END,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.total_questions ELSE NULL END,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.attempt_id    ELSE NULL END,
    true,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.id            ELSE NULL END)
  RETURNING id INTO v_new_cert_id;

  IF v_old_cert.id IS NOT NULL THEN
    UPDATE academy_certificates
    SET is_current = false, superseded_by = v_new_cert_id
    WHERE id = v_old_cert.id;
  END IF;

  INSERT INTO admin_logs (admin_id, action, target_table, target_id,
    target_user_id, target_course_id, details)
  VALUES (p_admin_id, 'regen_certificate', 'academy_certificates',
    v_new_cert_id::TEXT, p_user_id, p_course_id,
    jsonb_build_object(
      'new_reference', v_new_reference, 'new_cert_id', v_new_cert_id,
      'supersedes_cert_id',   CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.id        ELSE NULL END,
      'supersedes_reference', CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.reference ELSE NULL END))
  RETURNING id INTO v_log_id;

  RETURN jsonb_build_object(
    'ok', true, 'new_cert_id', v_new_cert_id,
    'new_reference', v_new_reference, 'log_id', v_log_id);
END;
$$;

REVOKE EXECUTE ON FUNCTION admin_regen_certificate(UUID,UUID,UUID,TEXT) FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION admin_regen_certificate(UUID,UUID,UUID,TEXT) TO service_role;
