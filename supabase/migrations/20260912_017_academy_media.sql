-- Migration 017 : médiathèque Academy
-- Crée la table academy_media, le bucket academy-media,
-- les politiques RLS, et seed les 45 médias canoniques
-- de la Masterclass Fiber Signature.

-- ══════════════════════════════════════════════════════════════
-- 1. Table academy_media
-- ══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS academy_media (
  id           TEXT PRIMARY KEY,
  course_id    UUID NOT NULL REFERENCES academy_courses(id) ON DELETE CASCADE,
  media_type   TEXT NOT NULL CHECK (media_type IN ('video','image')),
  module_label TEXT,
  lesson_label TEXT,
  storage_path TEXT,
  public_url   TEXT,
  status       TEXT NOT NULL DEFAULT 'placeholder' CHECK (status IN ('placeholder','uploaded')),
  file_name    TEXT,
  file_size    BIGINT,
  uploaded_at  TIMESTAMPTZ,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

DROP TRIGGER IF EXISTS trg_academy_media_updated ON academy_media;
CREATE TRIGGER trg_academy_media_updated
  BEFORE UPDATE ON academy_media
  FOR EACH ROW EXECUTE FUNCTION academy_touch_updated_at();

CREATE INDEX IF NOT EXISTS idx_academy_media_course ON academy_media(course_id);

-- ══════════════════════════════════════════════════════════════
-- 2. RLS
-- ══════════════════════════════════════════════════════════════
ALTER TABLE academy_media ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_academy_media" ON academy_media;
CREATE POLICY "public_read_academy_media"
  ON academy_media FOR SELECT USING (true);

DROP POLICY IF EXISTS "admin_all_academy_media" ON academy_media;
CREATE POLICY "admin_all_academy_media"
  ON academy_media FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ══════════════════════════════════════════════════════════════
-- 3. Bucket Storage academy-media (public, 500 Mo max)
-- ══════════════════════════════════════════════════════════════
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'academy-media',
  'academy-media',
  true,
  524288000,
  ARRAY[
    'image/jpeg','image/png','image/webp','image/gif',
    'video/mp4','video/quicktime','video/webm'
  ]
)
ON CONFLICT (id) DO NOTHING;

-- Policies storage
DROP POLICY IF EXISTS "academy_media_public_read"   ON storage.objects;
CREATE POLICY "academy_media_public_read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'academy-media');

DROP POLICY IF EXISTS "academy_media_admin_insert"  ON storage.objects;
CREATE POLICY "academy_media_admin_insert"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'academy-media' AND is_admin());

DROP POLICY IF EXISTS "academy_media_admin_update"  ON storage.objects;
CREATE POLICY "academy_media_admin_update"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'academy-media' AND is_admin());

DROP POLICY IF EXISTS "academy_media_admin_delete"  ON storage.objects;
CREATE POLICY "academy_media_admin_delete"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'academy-media' AND is_admin());

-- ══════════════════════════════════════════════════════════════
-- 4. Seed 45 médias canoniques — Masterclass Fiber Signature
-- ══════════════════════════════════════════════════════════════
DO $$
DECLARE cid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature';
  IF cid IS NULL THEN
    RAISE EXCEPTION 'Course fiber-signature introuvable — migration 017 annulée';
  END IF;

  INSERT INTO academy_media (id, course_id, media_type, module_label, lesson_label) VALUES

    -- ── Cover & Trailer (module_label NULL = niveau formation) ──────────────
    ('PHOTO_COVER_MASTERCLASS_FIBER_SIGNATURE',   cid, 'image', NULL, NULL),
    ('VIDEO_TRAILER_MASTERCLASS_FIBER_SIGNATURE', cid, 'video', NULL, NULL),

    -- ── M0 — Introduction ──────────────────────────────────────────────────
    ('VIDEO_M0_BIENVENUE',   cid, 'video', 'Introduction', 'Message de bienvenue'),
    ('VIDEO_M0_UTILISATION', cid, 'video', 'Introduction', 'Utilisation de la formation'),
    ('VIDEO_M0_PREREQUIS',   cid, 'video', 'Introduction', 'Prérequis'),

    -- ── M1 — Comprendre la fibre de verre ─────────────────────────────────
    ('VIDEO_M1_DEFINITION_FIBRE', cid, 'video', 'Comprendre la fibre de verre', 'Définition & origines'),
    ('VIDEO_M1_PRINCIPE_RENFORT', cid, 'video', 'Comprendre la fibre de verre', 'Principe du renfort'),

    -- ── M2 — Matériel professionnel ────────────────────────────────────────
    ('VIDEO_M2_GELS_COMPARAISON',  cid, 'video', 'Matériel professionnel', 'Comparatif des gels'),
    ('PHOTO_M2_FIBRES_TYPES',      cid, 'image', 'Matériel professionnel', 'Types de fibres'),
    ('PHOTO_M2_KIT_MATERIEL',      cid, 'image', 'Matériel professionnel', 'Kit matériel'),
    ('PHOTO_M2_OUTILS_ESSENTIELS', cid, 'image', 'Matériel professionnel', 'Outils essentiels'),

    -- ── M3 — Hygiène, sécurité & responsabilité ───────────────────────────
    ('VIDEO_M3_ACCORD_CONSULTATION', cid, 'video', 'Hygiène, sécurité & responsabilité', 'Accord consultation'),
    ('VIDEO_M3_ANATOMIE_ONGLE',      cid, 'video', 'Hygiène, sécurité & responsabilité', 'Anatomie de l''ongle'),
    ('VIDEO_M3_HYGIENE_PROTOCOLE',   cid, 'video', 'Hygiène, sécurité & responsabilité', 'Protocole d''hygiène'),
    ('PHOTO_M3_POSTE_TRAVAIL',       cid, 'image', 'Hygiène, sécurité & responsabilité', 'Poste de travail'),

    -- ── M4 — Observation préalable & préparation ──────────────────────────
    ('VIDEO_M4_CUTICULES_CONTOURS',    cid, 'video', 'Observation préalable & préparation', 'Cuticules & contours'),
    ('VIDEO_M4_OBSERVATION_PREALABLE', cid, 'video', 'Observation préalable & préparation', 'Observation préalable'),
    ('VIDEO_M4_PREPARATION_PLAQUE',    cid, 'video', 'Observation préalable & préparation', 'Préparation de la plaque'),

    -- ── M5 — Technique de pose ────────────────────────────────────────────
    ('VIDEO_M5_APEX_SCELLEMENT',      cid, 'video', 'Technique de pose', 'Apex & scellement'),
    ('VIDEO_M5_BASE_ADHESION',        cid, 'video', 'Technique de pose', 'Base & adhésion'),
    ('VIDEO_M5_DECOUPE_FIBRE',        cid, 'video', 'Technique de pose', 'Découpe de la fibre'),
    ('VIDEO_M5_ENCAPSULATION_FIBRE',  cid, 'video', 'Technique de pose', 'Encapsulation de la fibre'),
    ('VIDEO_M5_LOGIQUE_CONSTRUCTION', cid, 'video', 'Technique de pose', 'Logique de construction'),

    -- ── M6 — Rééquilibrage & entretien ────────────────────────────────────
    ('VIDEO_M6_REEQUILIBRAGE_PRINCIPE',  cid, 'video', 'Rééquilibrage & entretien', 'Principe du rééquilibrage'),
    ('VIDEO_M6_REEQUILIBRAGE_PROTOCOLE', cid, 'video', 'Rééquilibrage & entretien', 'Protocole de rééquilibrage'),
    ('VIDEO_M6_SUIVI_REPOUSSE',          cid, 'video', 'Rééquilibrage & entretien', 'Suivi de la repousse'),

    -- ── M7 — Dépose ───────────────────────────────────────────────────────
    ('VIDEO_M7_DEPOSE_LIMAGE',         cid, 'video', 'Dépose', 'Dépose par limage'),
    ('VIDEO_M7_SOIN_PLAQUE_NATURELLE', cid, 'video', 'Dépose', 'Soin de la plaque naturelle'),

    -- ── M8 — Finitions & nail art ─────────────────────────────────────────
    ('VIDEO_M8_LIMAGE_FINITION',         cid, 'video', 'Finitions & nail art', 'Limage & finition'),
    ('VIDEO_M8_SURFACE_MAT',             cid, 'video', 'Finitions & nail art', 'Surface mate'),
    ('VIDEO_M8_SURFACE_BRILLANT',        cid, 'video', 'Finitions & nail art', 'Surface brillante'),
    ('VIDEO_M8_NAIL_ART_COMPATIBILITES', cid, 'video', 'Finitions & nail art', 'Compatibilités nail art'),
    ('VIDEO_M8_CHROME_FOILS',            cid, 'video', 'Finitions & nail art', 'Chrome & foils'),
    ('VIDEO_M8_STAMPING',                cid, 'video', 'Finitions & nail art', 'Stamping'),
    ('VIDEO_M8_DURABILITE_NAIL_ART',     cid, 'video', 'Finitions & nail art', 'Durabilité du nail art'),

    -- ── M9 — Situations particulières & cas clients ───────────────────────
    ('VIDEO_M9_SIGNES_ALERTE',       cid, 'video', 'Situations particulières & cas clients', 'Signes d''alerte'),
    ('VIDEO_M9_ALLERGIES_PROTOCOLE', cid, 'video', 'Situations particulières & cas clients', 'Protocole allergies'),
    ('VIDEO_M9_ONGLES_FRAGILES',     cid, 'video', 'Situations particulières & cas clients', 'Ongles fragiles'),
    ('VIDEO_M9_ONGLES_COURTS',       cid, 'video', 'Situations particulières & cas clients', 'Ongles courts'),

    -- ── M10 — Business & tarification ────────────────────────────────────
    ('VIDEO_M10_CALCUL_TARIF',      cid, 'video', 'Business & tarification', 'Calculer son tarif'),
    ('VIDEO_M10_AFFICHER_TARIFS',   cid, 'video', 'Business & tarification', 'Afficher ses tarifs'),
    ('VIDEO_M10_FICHE_CLIENTE',     cid, 'video', 'Business & tarification', 'Fiche cliente'),
    ('VIDEO_M10_OFFRE_PRESTATIONS', cid, 'video', 'Business & tarification', 'Offre de prestations'),

    -- ── M11 — Communication cliente ───────────────────────────────────────
    ('VIDEO_M11_COMMUNICATION_PRESTATION', cid, 'video', 'Communication cliente', 'Communication prestation'),
    ('VIDEO_M11_SUIVI_CLIENT',             cid, 'video', 'Communication cliente', 'Suivi client')

  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE 'academy_media : 45 médias canoniques seedés pour fiber-signature (id=%).', cid;
END $$;
