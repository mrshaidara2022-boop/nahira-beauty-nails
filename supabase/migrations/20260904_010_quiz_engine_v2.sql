-- Phase 10: Quiz engine v2 — server-session architecture
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- NEVER modify project tjnldcxidcztwpwhxuuo (HAURANA production)

-- ─── 1. academy_quiz_attempts — add session tracking columns ─────────────────
ALTER TABLE academy_quiz_attempts
  ADD COLUMN IF NOT EXISTS correct_count   INTEGER,
  ADD COLUMN IF NOT EXISTS total_questions INTEGER,
  ADD COLUMN IF NOT EXISTS started_at      TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS completed_at    TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS status          TEXT NOT NULL DEFAULT 'completed';

-- Index for looking up in-progress sessions
CREATE INDEX IF NOT EXISTS idx_ac_quiz_a_status ON academy_quiz_attempts(status);

-- ─── 2. academy_quiz_attempt_questions — per-session question assignment ─────
CREATE TABLE IF NOT EXISTS academy_quiz_attempt_questions (
  id             UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id     UUID    NOT NULL REFERENCES academy_quiz_attempts(id) ON DELETE CASCADE,
  question_id    UUID    NOT NULL REFERENCES academy_quiz_questions(id),
  selected_index INTEGER,   -- NULL until the user submits
  is_correct     BOOLEAN,   -- NULL until graded
  UNIQUE(attempt_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_ac_quiz_aq_attempt  ON academy_quiz_attempt_questions(attempt_id);

-- RLS
ALTER TABLE academy_quiz_attempt_questions ENABLE ROW LEVEL SECURITY;

-- Users may read their own attempt questions (after submission); no direct write
CREATE POLICY "aqq_select_own" ON academy_quiz_attempt_questions
  FOR SELECT USING (
    attempt_id IN (
      SELECT id FROM academy_quiz_attempts WHERE user_id = auth.uid()
    )
  );

-- ─── 3. academy_certificates — add score tracking + recipient_name ───────────
ALTER TABLE academy_certificates
  ADD COLUMN IF NOT EXISTS score           INTEGER,
  ADD COLUMN IF NOT EXISTS correct_count   INTEGER,
  ADD COLUMN IF NOT EXISTS total_questions INTEGER,
  ADD COLUMN IF NOT EXISTS attempt_id      UUID REFERENCES academy_quiz_attempts(id),
  ADD COLUMN IF NOT EXISTS recipient_name  TEXT NOT NULL DEFAULT '';
