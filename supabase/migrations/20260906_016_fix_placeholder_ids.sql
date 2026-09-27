-- Migration: corriger les identifiants de blocs placeholder
-- Les IDs M6/M8/M9 étaient inversés par rapport à l'ordre réel des modules en base.
-- Ordre canonique vérifié : M6=Rééquilibrage, M7=Dépose, M8=Finitions, M9=Situations.
-- Correction par replace() text→jsonb (sans toucher au contenu pédagogique).
-- + Nommer le placeholder null oublié en M10 (Calculer son tarif).

-- ══════════════════════════════════════════════════════════════
-- M6 — Rééquilibrage & entretien (sort_order=6)
-- IDs étaient M9_* → corriger en M6_*
-- ══════════════════════════════════════════════════════════════
UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M9_REEQUILIBRAGE_PRINCIPE', 'VIDEO_M6_REEQUILIBRAGE_PRINCIPE')::jsonb
WHERE id = '15b2e94c-0de3-4f2e-9f1d-f94650172676';

UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M9_REEQUILIBRAGE_PROTOCOLE', 'VIDEO_M6_REEQUILIBRAGE_PROTOCOLE')::jsonb
WHERE id = '558bd8e3-3ba9-4ba3-a781-49cb8aa348c5';

UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M9_SUIVI_REPOUSSE', 'VIDEO_M6_SUIVI_REPOUSSE')::jsonb
WHERE id = '81ed5fad-316f-44ac-93f1-204d1c84951a';

-- ══════════════════════════════════════════════════════════════
-- M8 — Finitions & nail art (sort_order=8)
-- IDs étaient M6_* → corriger en M8_*
-- ══════════════════════════════════════════════════════════════
UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M6_LIMAGE_FINITION', 'VIDEO_M8_LIMAGE_FINITION')::jsonb
WHERE id = '8e7342ba-900e-47eb-a3d2-c3863235a1a0';

-- 2 placeholders dans cette leçon (replace opère sur tout le texte)
UPDATE academy_lessons
SET content_blocks = replace(replace(content_blocks::text,
  'VIDEO_M6_SURFACE_MAT',     'VIDEO_M8_SURFACE_MAT'),
  'VIDEO_M6_SURFACE_BRILLANT','VIDEO_M8_SURFACE_BRILLANT')::jsonb
WHERE id = '90dc63f5-210d-46cb-8dc3-652d26426e6a';

UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M6_NAIL_ART_COMPATIBILITES', 'VIDEO_M8_NAIL_ART_COMPATIBILITES')::jsonb
WHERE id = '99e35ce2-6ec3-4d74-bda7-39126ade2376';

-- 2 placeholders dans cette leçon
UPDATE academy_lessons
SET content_blocks = replace(replace(content_blocks::text,
  'VIDEO_M6_CHROME_FOILS','VIDEO_M8_CHROME_FOILS'),
  'VIDEO_M6_STAMPING',    'VIDEO_M8_STAMPING')::jsonb
WHERE id = '8bcac6b8-c959-44d0-a67a-ed9c41811d75';

UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M6_DURABILITE_NAIL_ART', 'VIDEO_M8_DURABILITE_NAIL_ART')::jsonb
WHERE id = '52873b8a-b5cf-4698-8201-dc782123f660';

-- ══════════════════════════════════════════════════════════════
-- M9 — Situations particulières & cas clients (sort_order=9)
-- IDs étaient M8_* → corriger en M9_*
-- ══════════════════════════════════════════════════════════════
UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M8_SIGNES_ALERTE', 'VIDEO_M9_SIGNES_ALERTE')::jsonb
WHERE id = '4039edc4-ff55-4794-a14d-cd8cde081cbe';

UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M8_ALLERGIES_PROTOCOLE', 'VIDEO_M9_ALLERGIES_PROTOCOLE')::jsonb
WHERE id = 'aa71bff5-b26c-4b95-9bc3-6b4ca6d4a8c3';

UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M8_ONGLES_FRAGILES', 'VIDEO_M9_ONGLES_FRAGILES')::jsonb
WHERE id = 'baa245cb-3824-4aa1-909f-43082d0055b1';

UPDATE academy_lessons
SET content_blocks = replace(content_blocks::text,
  'VIDEO_M8_ONGLES_COURTS', 'VIDEO_M9_ONGLES_COURTS')::jsonb
WHERE id = 'dd09b0bb-21ef-4cf6-a19b-801e59d2a45f';

-- ══════════════════════════════════════════════════════════════
-- M10 — Placeholder null oublié (Calculer son tarif)
-- ══════════════════════════════════════════════════════════════
UPDATE academy_lessons SET content_blocks = (
  WITH b AS (SELECT b, idx::int i,
    SUM(CASE WHEN b->>'type'='placeholder' THEN 1 ELSE 0 END)
    OVER (ORDER BY idx ROWS UNBOUNDED PRECEDING) n
    FROM jsonb_array_elements(content_blocks) WITH ORDINALITY t(b,idx))
  SELECT jsonb_agg(
    CASE WHEN b->>'type'='placeholder' AND n=1
      THEN '{"type":"placeholder","id":"VIDEO_M10_CALCUL_TARIF"}'::jsonb
      ELSE b END ORDER BY i)
  FROM b)
WHERE id = '9f262739-d1ee-46db-a95f-645de302a704';
