-- Phase 1 — Action 03 : reprise à la dernière leçon visitée
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- Adds last_visited_lesson_id to academy_enrollments so the learner
-- resumes at the correct lesson across devices and sessions.

ALTER TABLE academy_enrollments
  ADD COLUMN IF NOT EXISTS last_visited_lesson_id UUID
    REFERENCES academy_lessons(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_ac_enroll_last_visited
  ON academy_enrollments(last_visited_lesson_id);

-- Allow enrolled users to update their own last_visited_lesson_id
DROP POLICY IF EXISTS "ac_enroll_update_last_visited" ON academy_enrollments;
CREATE POLICY "ac_enroll_update_last_visited" ON academy_enrollments
  FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

GRANT UPDATE (last_visited_lesson_id) ON academy_enrollments TO authenticated;
