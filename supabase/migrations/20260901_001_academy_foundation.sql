-- Phase 1: Nahira Academy — Foundation DB
-- Additive only: adds product_type to products + 10 new academy tables
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- NEVER modify project tjnldcxidcztwpwhxuuo (Haurana production)

-- ─── 1. product_type on products table ────────────────────────────────────────
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS product_type TEXT NOT NULL DEFAULT 'physical';

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'products_product_type_check'
  ) THEN
    ALTER TABLE products ADD CONSTRAINT products_product_type_check
      CHECK (product_type IN ('physical', 'digital'));
  END IF;
END $$;

-- ─── 2. academy_courses ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_courses (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id       UUID REFERENCES products(id) ON DELETE SET NULL,
  slug             TEXT UNIQUE NOT NULL,
  title            TEXT NOT NULL,
  subtitle         TEXT,
  description_long TEXT,
  cover_url        TEXT,
  trailer_url      TEXT,
  level            TEXT CHECK (level IN ('debutant', 'intermediaire', 'avance')),
  duration_minutes INTEGER,
  passing_score    INTEGER NOT NULL DEFAULT 70,
  is_published     BOOLEAN NOT NULL DEFAULT false,
  is_free          BOOLEAN NOT NULL DEFAULT false,
  sort_order       INTEGER NOT NULL DEFAULT 0,
  meta_title       TEXT,
  meta_description TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── 3. academy_modules ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_modules (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id  UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  title      TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── 4. academy_lessons ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_lessons (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id        UUID NOT NULL REFERENCES academy_modules(id) ON DELETE CASCADE,
  course_id        UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  title            TEXT NOT NULL,
  content_blocks   JSONB NOT NULL DEFAULT '[]',
  video_url        TEXT,
  duration_minutes INTEGER,
  sort_order       INTEGER NOT NULL DEFAULT 0,
  is_preview       BOOLEAN NOT NULL DEFAULT false,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── 5. academy_materials ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_materials (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id   UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  lesson_id   UUID REFERENCES academy_lessons(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  description TEXT,
  file_url    TEXT NOT NULL,
  file_type   TEXT,
  sort_order  INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── 6. academy_enrollments ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_enrollments (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  course_id         UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  stripe_session_id TEXT,
  enrolled_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, course_id)
);

-- ─── 7. academy_progress ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_progress (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  lesson_id    UUID NOT NULL REFERENCES academy_lessons(id) ON DELETE CASCADE,
  course_id    UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, lesson_id)
);

-- ─── 8. academy_quiz_questions ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_quiz_questions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id   UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  question    TEXT NOT NULL,
  options     JSONB NOT NULL DEFAULT '[]',
  explanation TEXT,
  sort_order  INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── 9. academy_quiz_attempts ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_quiz_attempts (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  course_id    UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  score        INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
  passed       BOOLEAN NOT NULL,
  answers      JSONB NOT NULL DEFAULT '[]',
  attempted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─── 10. academy_certificates ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS academy_certificates (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id   UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  reference TEXT UNIQUE NOT NULL DEFAULT '',
  issued_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, course_id)
);

-- ─── Certificate reference sequence + trigger ──────────────────────────────────
CREATE SEQUENCE IF NOT EXISTS academy_certificate_seq START 1;

CREATE OR REPLACE FUNCTION generate_certificate_reference()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.reference IS NULL OR NEW.reference = '' THEN
    NEW.reference := 'NAHY-' || TO_CHAR(NOW(), 'YYYY') || '-' ||
      LPAD(nextval('academy_certificate_seq')::TEXT, 6, '0');
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_certificate_reference ON academy_certificates;
CREATE TRIGGER trg_certificate_reference
  BEFORE INSERT ON academy_certificates
  FOR EACH ROW EXECUTE FUNCTION generate_certificate_reference();

-- ─── updated_at triggers ───────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION academy_touch_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_academy_courses_updated ON academy_courses;
CREATE TRIGGER trg_academy_courses_updated
  BEFORE UPDATE ON academy_courses
  FOR EACH ROW EXECUTE FUNCTION academy_touch_updated_at();

DROP TRIGGER IF EXISTS trg_academy_lessons_updated ON academy_lessons;
CREATE TRIGGER trg_academy_lessons_updated
  BEFORE UPDATE ON academy_lessons
  FOR EACH ROW EXECUTE FUNCTION academy_touch_updated_at();

-- ─── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_ac_modules_course   ON academy_modules(course_id);
CREATE INDEX IF NOT EXISTS idx_ac_lessons_module   ON academy_lessons(module_id);
CREATE INDEX IF NOT EXISTS idx_ac_lessons_course   ON academy_lessons(course_id);
CREATE INDEX IF NOT EXISTS idx_ac_materials_course ON academy_materials(course_id);
CREATE INDEX IF NOT EXISTS idx_ac_materials_lesson ON academy_materials(lesson_id);
CREATE INDEX IF NOT EXISTS idx_ac_enroll_user      ON academy_enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_ac_enroll_course    ON academy_enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_ac_progress_user    ON academy_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_ac_progress_course  ON academy_progress(course_id);
CREATE INDEX IF NOT EXISTS idx_ac_quiz_q_course    ON academy_quiz_questions(course_id);
CREATE INDEX IF NOT EXISTS idx_ac_quiz_a_user      ON academy_quiz_attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_ac_quiz_a_course    ON academy_quiz_attempts(course_id);
CREATE INDEX IF NOT EXISTS idx_ac_certs_user       ON academy_certificates(user_id);
CREATE INDEX IF NOT EXISTS idx_ac_certs_ref        ON academy_certificates(reference);

-- ─── Row Level Security ────────────────────────────────────────────────────────
ALTER TABLE academy_courses      ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_modules      ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_lessons      ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_materials    ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_enrollments  ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_progress     ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_quiz_attempts  ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_certificates   ENABLE ROW LEVEL SECURITY;

-- is_admin() helper: checks profiles.role = 'admin' for the current user
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT COALESCE((
    SELECT role = 'admin' FROM profiles WHERE id = auth.uid()
  ), false);
$$;

-- ── academy_courses ──
DROP POLICY IF EXISTS "ac_courses_select" ON academy_courses;
CREATE POLICY "ac_courses_select" ON academy_courses FOR SELECT
  USING (is_published = true OR is_admin());

DROP POLICY IF EXISTS "ac_courses_admin_write" ON academy_courses;
CREATE POLICY "ac_courses_admin_write" ON academy_courses
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ── academy_modules ──
DROP POLICY IF EXISTS "ac_modules_select" ON academy_modules;
CREATE POLICY "ac_modules_select" ON academy_modules FOR SELECT
  USING (
    is_admin() OR
    EXISTS (
      SELECT 1 FROM academy_enrollments e
      WHERE e.user_id = auth.uid() AND e.course_id = academy_modules.course_id
    )
  );

DROP POLICY IF EXISTS "ac_modules_admin_write" ON academy_modules;
CREATE POLICY "ac_modules_admin_write" ON academy_modules
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ── academy_lessons ──
DROP POLICY IF EXISTS "ac_lessons_select" ON academy_lessons;
CREATE POLICY "ac_lessons_select" ON academy_lessons FOR SELECT
  USING (
    is_admin() OR
    is_preview = true OR
    EXISTS (
      SELECT 1 FROM academy_enrollments e
      WHERE e.user_id = auth.uid() AND e.course_id = academy_lessons.course_id
    )
  );

DROP POLICY IF EXISTS "ac_lessons_admin_write" ON academy_lessons;
CREATE POLICY "ac_lessons_admin_write" ON academy_lessons
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ── academy_materials ──
DROP POLICY IF EXISTS "ac_materials_select" ON academy_materials;
CREATE POLICY "ac_materials_select" ON academy_materials FOR SELECT
  USING (
    is_admin() OR
    EXISTS (
      SELECT 1 FROM academy_enrollments e
      WHERE e.user_id = auth.uid() AND e.course_id = academy_materials.course_id
    )
  );

DROP POLICY IF EXISTS "ac_materials_admin_write" ON academy_materials;
CREATE POLICY "ac_materials_admin_write" ON academy_materials
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ── academy_enrollments ──
DROP POLICY IF EXISTS "ac_enroll_select" ON academy_enrollments;
CREATE POLICY "ac_enroll_select" ON academy_enrollments FOR SELECT
  USING (user_id = auth.uid() OR is_admin());

DROP POLICY IF EXISTS "ac_enroll_admin_write" ON academy_enrollments;
CREATE POLICY "ac_enroll_admin_write" ON academy_enrollments
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ── academy_progress ──
DROP POLICY IF EXISTS "ac_progress_own" ON academy_progress;
CREATE POLICY "ac_progress_own" ON academy_progress FOR ALL
  USING (user_id = auth.uid() OR is_admin())
  WITH CHECK (user_id = auth.uid() OR is_admin());

-- ── academy_quiz_questions ──
DROP POLICY IF EXISTS "ac_quiz_q_select" ON academy_quiz_questions;
CREATE POLICY "ac_quiz_q_select" ON academy_quiz_questions FOR SELECT
  USING (
    is_admin() OR
    EXISTS (
      SELECT 1 FROM academy_enrollments e
      WHERE e.user_id = auth.uid() AND e.course_id = academy_quiz_questions.course_id
    )
  );

DROP POLICY IF EXISTS "ac_quiz_q_admin_write" ON academy_quiz_questions;
CREATE POLICY "ac_quiz_q_admin_write" ON academy_quiz_questions
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ── academy_quiz_attempts (append-only for users) ──
DROP POLICY IF EXISTS "ac_quiz_a_select" ON academy_quiz_attempts;
CREATE POLICY "ac_quiz_a_select" ON academy_quiz_attempts FOR SELECT
  USING (user_id = auth.uid() OR is_admin());

DROP POLICY IF EXISTS "ac_quiz_a_insert" ON academy_quiz_attempts;
CREATE POLICY "ac_quiz_a_insert" ON academy_quiz_attempts FOR INSERT
  WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "ac_quiz_a_admin_write" ON academy_quiz_attempts;
CREATE POLICY "ac_quiz_a_admin_write" ON academy_quiz_attempts
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ── academy_certificates ──
DROP POLICY IF EXISTS "ac_certs_select" ON academy_certificates;
CREATE POLICY "ac_certs_select" ON academy_certificates FOR SELECT
  USING (user_id = auth.uid() OR is_admin());

DROP POLICY IF EXISTS "ac_certs_admin_write" ON academy_certificates;
CREATE POLICY "ac_certs_admin_write" ON academy_certificates
  FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ─── API access grants ─────────────────────────────────────────────────────────
-- anon: browse published courses only
GRANT SELECT ON academy_courses TO anon;

-- authenticated: access own content + course material when enrolled
GRANT SELECT ON academy_courses        TO authenticated;
GRANT SELECT ON academy_modules        TO authenticated;
GRANT SELECT ON academy_lessons        TO authenticated;
GRANT SELECT ON academy_materials      TO authenticated;
GRANT SELECT ON academy_enrollments    TO authenticated;
GRANT SELECT, INSERT ON academy_progress       TO authenticated;
GRANT SELECT ON academy_quiz_questions TO authenticated;
GRANT SELECT, INSERT ON academy_quiz_attempts  TO authenticated;
GRANT SELECT ON academy_certificates   TO authenticated;
