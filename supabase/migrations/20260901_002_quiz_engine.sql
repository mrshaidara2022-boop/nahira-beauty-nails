-- Phase 6: Quiz engine additions
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- NEVER modify project tjnldcxidcztwpwhxuuo (Haurana production)

-- ─── 1. correct_index on quiz_questions ───────────────────────────────────────
-- Stores the 0-based index of the correct option; never exposed via client RLS
ALTER TABLE academy_quiz_questions
  ADD COLUMN IF NOT EXISTS correct_index INTEGER NOT NULL DEFAULT 0;

-- ─── 2. score_pct on quiz_attempts (alias of score, rename for clarity) ───────
-- score already exists as INTEGER 0-100; no change needed, just a comment.

-- ─── 3. Make certificates publicly readable by reference (verification URLs) ───
DROP POLICY IF EXISTS "ac_certs_select" ON academy_certificates;
CREATE POLICY "ac_certs_select" ON academy_certificates FOR SELECT
  USING (true);   -- public verification by reference; no PII beyond name shown

GRANT SELECT ON academy_certificates TO anon;
