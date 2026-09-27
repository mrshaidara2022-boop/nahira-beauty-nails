-- Migration 018 : sécurité Storage — architecture deux buckets
-- academy-marketing (public)  : cover + trailer uniquement
-- academy-media (privé)        : contenus pédagogiques (leçons)
-- Les élèves inscrits peuvent générer des URLs signées pour leurs leçons.
-- Les administrateurs ont accès complet.
-- Ajout statut 'review' pour "À remplacer".

-- ══════════════════════════════════════════════════════════════
-- 1. Bucket public pour les médias marketing
-- ══════════════════════════════════════════════════════════════
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'academy-marketing',
  'academy-marketing',
  true,
  104857600,    -- 100 Mo max (covers + trailers)
  ARRAY['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/quicktime','video/webm']
)
ON CONFLICT (id) DO NOTHING;

-- RLS academy-marketing (public : tout le monde peut lire)
DROP POLICY IF EXISTS "academy_marketing_public_read"  ON storage.objects;
CREATE POLICY "academy_marketing_public_read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'academy-marketing');

DROP POLICY IF EXISTS "academy_marketing_admin_insert" ON storage.objects;
CREATE POLICY "academy_marketing_admin_insert"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'academy-marketing' AND is_admin());

DROP POLICY IF EXISTS "academy_marketing_admin_update" ON storage.objects;
CREATE POLICY "academy_marketing_admin_update"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'academy-marketing' AND is_admin());

DROP POLICY IF EXISTS "academy_marketing_admin_delete" ON storage.objects;
CREATE POLICY "academy_marketing_admin_delete"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'academy-marketing' AND is_admin());

-- ══════════════════════════════════════════════════════════════
-- 2. Rendre academy-media privé (contenus pédagogiques payants)
-- ══════════════════════════════════════════════════════════════
UPDATE storage.buckets SET public = false WHERE id = 'academy-media';

-- Supprimer l'ancienne policy publique (migration 017)
DROP POLICY IF EXISTS "academy_media_public_read" ON storage.objects;

-- Seuls les élèves inscrits + admins peuvent générer des URLs signées
DROP POLICY IF EXISTS "academy_media_enrolled_read" ON storage.objects;
CREATE POLICY "academy_media_enrolled_read"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'academy-media'
    AND auth.uid() IS NOT NULL
    AND (
      is_admin()
      OR EXISTS (
        SELECT 1
        FROM academy_enrollments ae
        JOIN academy_media am ON am.course_id = ae.course_id
        WHERE ae.user_id = auth.uid()
          AND am.storage_path = storage.objects.name
      )
    )
  );

-- ══════════════════════════════════════════════════════════════
-- 3. Statut 'review' (À remplacer) dans academy_media
-- ══════════════════════════════════════════════════════════════
ALTER TABLE academy_media DROP CONSTRAINT IF EXISTS academy_media_status_check;
ALTER TABLE academy_media ADD CONSTRAINT academy_media_status_check
  CHECK (status IN ('placeholder', 'uploaded', 'review'));
