-- ═══════════════════════════════════════════════════════════════════════
-- L4 — Fix admin_regen_certificate: deactivate old cert before inserting new
-- ═══════════════════════════════════════════════════════════════════════

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

  -- Step 1: deactivate old cert BEFORE inserting new (avoids partial-unique conflict)
  IF v_old_cert.id IS NOT NULL THEN
    UPDATE academy_certificates
    SET is_current = false
    WHERE id = v_old_cert.id;
  END IF;

  -- Step 2: insert new cert as current
  INSERT INTO academy_certificates (
    user_id, course_id, reference, issued_at, recipient_name,
    score, correct_count, total_questions, attempt_id, is_current, supersedes)
  VALUES (
    p_user_id, p_course_id, v_new_reference, NOW(), p_recipient_name,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.score           ELSE NULL END,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.correct_count   ELSE NULL END,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.total_questions ELSE NULL END,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.attempt_id      ELSE NULL END,
    true,
    CASE WHEN v_old_cert.id IS NOT NULL THEN v_old_cert.id              ELSE NULL END)
  RETURNING id INTO v_new_cert_id;

  -- Step 3: link old cert to new via superseded_by
  IF v_old_cert.id IS NOT NULL THEN
    UPDATE academy_certificates
    SET superseded_by = v_new_cert_id
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
