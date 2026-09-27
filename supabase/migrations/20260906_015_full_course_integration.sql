-- Migration: intégration complète Masterclass Fiber Signature
-- 1. Publier le cours fiber-signature avec métadonnées complètes
-- 2. Supprimer le doublon vide masterclass-fibre-de-verre
-- 3. Définir les leçons aperçu (is_preview)
-- 4. Ajouter des identifiants aux blocs placeholder (médias à venir)

-- ══════════════════════════════════════════════════════════════
-- 1. PUBLICATION DU COURS
-- ══════════════════════════════════════════════════════════════
UPDATE academy_courses
SET
  is_published    = true,
  subtitle        = 'La méthode complète pour maîtriser la pose fibre de verre en onglerie professionnelle',
  level           = 'intermediaire',
  passing_score   = 70,
  sort_order      = 1,
  duration_minutes = (
    SELECT SUM(al.duration_minutes)
    FROM academy_lessons al
    JOIN academy_modules am ON am.id = al.module_id
    WHERE am.course_id = '438bd375-1e34-4f0d-8b95-39ea2ff883b3'
  ),
  description_long = 'La Masterclass Fiber Signature est une formation professionnelle complète dédiée à la technique de pose de fibre de verre en onglerie. En 14 modules et plus de 60 leçons, vous apprendrez à maîtriser chaque étape — de la sélection du matériel à la clôture de prestation — avec une approche rigoureuse, sécurisée et reproductible. Les fiches pratiques F1 à F12 accompagnent chaque module pour consolider votre pratique au poste de travail.',
  meta_title      = 'Masterclass Fiber Signature — Formation Fibre de Verre · Nahira Academy',
  meta_description = 'Formation complète en 14 modules : pose fibre de verre, protocoles, business, communication cliente. Fiches pratiques F1–F12 incluses. Nahira Academy.',
  cover_url       = 'PHOTO_COVER_MASTERCLASS_FIBER_SIGNATURE',
  trailer_url     = 'VIDEO_TRAILER_MASTERCLASS_FIBER_SIGNATURE',
  updated_at      = now()
WHERE id = '438bd375-1e34-4f0d-8b95-39ea2ff883b3';

-- ══════════════════════════════════════════════════════════════
-- 2. SUPPRESSION DU DOUBLON VIDE
-- ══════════════════════════════════════════════════════════════
DELETE FROM academy_courses
WHERE id = 'd20d56b1-6082-4447-a4dd-84cdd95ef6c8';

-- ══════════════════════════════════════════════════════════════
-- 3. LEÇONS APERÇU (is_preview = true)
-- Accès gratuit pour les non-inscrits sur ces leçons
-- ══════════════════════════════════════════════════════════════
UPDATE academy_lessons SET is_preview = true WHERE id IN (
  'c4fbf284-fa34-42cb-a522-a342e9889b08', -- Message de bienvenue
  'bf66075c-418a-4ffc-87e2-791f8d40fa19', -- La philosophie Fiber Signature
  '7146cbee-a1c8-40f9-bc43-af0233f217c9'  -- Définition & origines de la fibre de verre
);

-- ══════════════════════════════════════════════════════════════
-- 4. IDENTIFIANTS DES BLOCS PLACEHOLDER (médias à venir)
-- Chaque UPDATE remplace placeholder(s) anonymes par un bloc
-- identifié : {"type":"placeholder","id":"VIDEO_MX_SLUG"}
-- ══════════════════════════════════════════════════════════════

-- Helper : pour 1 placeholder dans la leçon
-- ─── M0 — Introduction ────────────────────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M0_BIENVENUE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='c4fbf284-fa34-42cb-a522-a342e9889b08';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M0_UTILISATION"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='13dd930d-de6c-4d96-819b-3d2e871a0ad1';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M0_PREREQUIS"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='b03f82e1-a658-4035-87b2-4c8b8cfbcbd2';

-- ─── M1 — Comprendre la fibre de verre ───────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M1_DEFINITION_FIBRE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='7146cbee-a1c8-40f9-bc43-af0233f217c9';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M1_PRINCIPE_RENFORT"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='b83e7105-64e3-4288-997f-2e9c85a1d2f8';

-- ─── M2 — Matériel professionnel ──────────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"PHOTO_M2_KIT_MATERIEL"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='0ca3ff9f-552f-4307-aec2-9021bf21e9e1';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"PHOTO_M2_FIBRES_TYPES"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='a0b97b11-1247-4218-8c59-0930f831ff68';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"PHOTO_M2_OUTILS_ESSENTIELS"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='ce578745-9877-4898-a471-ee61ba4def28';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M2_GELS_COMPARAISON"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='2608b70c-22a2-4740-be79-783eb38f0edb';

-- ─── M3 — Hygiène, sécurité & responsabilité ──────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M3_ANATOMIE_ONGLE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='dd69bae1-8792-47ce-a08e-5027cad9108e';

-- 2 placeholders : VIDEO_M3_HYGIENE_PROTOCOLE + PHOTO_M3_POSTE_TRAVAIL
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(
    CASE
      WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M3_HYGIENE_PROTOCOLE"}'::jsonb
      WHEN b->>'type'='placeholder' AND n=2 THEN '{"type":"placeholder","id":"PHOTO_M3_POSTE_TRAVAIL"}'::jsonb
      ELSE b
    END ORDER BY i)
  FROM b) WHERE id='f957692b-7531-4782-a7ab-778b42be50b8';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M3_ACCORD_CONSULTATION"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='334c3891-a484-452d-a236-35e691253b0e';

-- ─── M4 — Observation préalable & préparation ─────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M4_OBSERVATION_PREALABLE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='f14339fc-1665-4747-af23-56046349f121';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M4_PREPARATION_PLAQUE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='93fccdd9-61cd-424f-bbbc-2ee6c23abc23';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M4_CUTICULES_CONTOURS"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='c41dab05-7f44-4931-9b31-0390efa7bc39';

-- ─── M5 — Technique de pose ───────────────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M5_LOGIQUE_CONSTRUCTION"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='6a032139-fdb5-4967-be22-2bbfe4e0d046';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M5_DECOUPE_FIBRE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='9f81376e-9844-49fd-be44-7500373acfe9';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M5_BASE_ADHESION"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='fa961b86-eae6-4045-bb76-6ffd42e3690c';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M5_ENCAPSULATION_FIBRE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='34236ea9-65bf-4d7b-8de8-b43c9a67dcb6';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M5_APEX_SCELLEMENT"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='7b28ffd2-df5d-4533-a642-154a66b42da8';

-- ─── M6 — Finitions & nail art ────────────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M6_LIMAGE_FINITION"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='8e7342ba-900e-47eb-a3d2-c3863235a1a0';

-- 2 placeholders : VIDEO_M6_SURFACE_MAT + VIDEO_M6_SURFACE_BRILLANT
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(
    CASE
      WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M6_SURFACE_MAT"}'::jsonb
      WHEN b->>'type'='placeholder' AND n=2 THEN '{"type":"placeholder","id":"VIDEO_M6_SURFACE_BRILLANT"}'::jsonb
      ELSE b
    END ORDER BY i)
  FROM b) WHERE id='90dc63f5-210d-46cb-8dc3-652d26426e6a';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M6_NAIL_ART_COMPATIBILITES"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='99e35ce2-6ec3-4d74-bda7-39126ade2376';

-- 2 placeholders : VIDEO_M6_CHROME_FOILS + VIDEO_M6_STAMPING
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(
    CASE
      WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M6_CHROME_FOILS"}'::jsonb
      WHEN b->>'type'='placeholder' AND n=2 THEN '{"type":"placeholder","id":"VIDEO_M6_STAMPING"}'::jsonb
      ELSE b
    END ORDER BY i)
  FROM b) WHERE id='8bcac6b8-c959-44d0-a67a-ed9c41811d75';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M6_DURABILITE_NAIL_ART"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='52873b8a-b5cf-4698-8201-dc782123f660';

-- ─── M7 — Dépose ──────────────────────────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M7_DEPOSE_LIMAGE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='c4a6a43d-3477-42b3-9d86-004c0b4ec2f2';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M7_SOIN_PLAQUE_NATURELLE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='a900dc57-3e16-4eb9-ad20-624d4ff2dde5';

-- ─── M8 — Situations particulières ────────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M8_SIGNES_ALERTE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='4039edc4-ff55-4794-a14d-cd8cde081cbe';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M8_ALLERGIES_PROTOCOLE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='aa71bff5-b26c-4b95-9bc3-6b4ca6d4a8c3';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M8_ONGLES_FRAGILES"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='baa245cb-3824-4aa1-909f-43082d0055b1';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M8_ONGLES_COURTS"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='dd09b0bb-21ef-4cf6-a19b-801e59d2a45f';

-- ─── M9 — Rééquilibrage & entretien ───────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M9_REEQUILIBRAGE_PRINCIPE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='15b2e94c-0de3-4f2e-9f1d-f94650172676';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M9_REEQUILIBRAGE_PROTOCOLE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='558bd8e3-3ba9-4ba3-a781-49cb8aa348c5';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M9_SUIVI_REPOUSSE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='81ed5fad-316f-44ac-93f1-204d1c84951a';

-- ─── M10 — Business & tarification ───────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M10_AFFICHER_TARIFS"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='0c8b09d9-4f41-47f3-afcb-192bb5d3e8cf';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M10_OFFRE_PRESTATIONS"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='7ecfa1d5-40e2-4b7c-8d43-3a4e4d9fb98a';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M10_FICHE_CLIENTE"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='e22e1f43-8ed0-45f0-8ec2-decf0a4feae0';

-- ─── M11 — Communication cliente ──────────────────────────────
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M11_COMMUNICATION_PRESTATION"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='7d61471c-251c-44d9-8231-735c91b47698';

UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i, SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END) OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(CASE WHEN b->>'type'='placeholder' AND n=1 THEN '{"type":"placeholder","id":"VIDEO_M11_SUIVI_CLIENT"}'::jsonb ELSE b END ORDER BY i)
  FROM b) WHERE id='fd44ad39-7cc3-43f1-9e62-01b89b3add99';
