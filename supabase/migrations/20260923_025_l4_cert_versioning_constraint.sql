-- ═══════════════════════════════════════════════════════════════════════
-- L4 — Certificate versioning: replace full unique with partial unique
-- ═══════════════════════════════════════════════════════════════════════

-- Drop the full unique constraint that blocks multiple versions per user+course
ALTER TABLE academy_certificates
  DROP CONSTRAINT IF EXISTS academy_certificates_user_id_course_id_key;

-- Partial unique: only one current certificate per user+course
CREATE UNIQUE INDEX IF NOT EXISTS uq_academy_certificates_current
  ON academy_certificates (user_id, course_id)
  WHERE is_current = true;
