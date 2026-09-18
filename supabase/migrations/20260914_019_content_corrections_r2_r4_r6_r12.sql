
-- 6 targeted content corrections — Rules R2, R4, R12
-- M1.L2 (b83e7105), M5.L4 (34236ea9), M9.L3 (aa71bff5), M9.L4 (4039edc4)

-- CORRECTION 1 — M1.L2 — info block (VÉRIFIER) — R2
UPDATE academy_lessons
SET content_blocks = (
  SELECT jsonb_agg(
    CASE
      WHEN (b->>'type' = 'info' AND b->>'content' LIKE '%Un point de casse répétitif = la fibre ne couvre pas bien cette zone.%')
      THEN jsonb_set(b, '{content}', to_jsonb(replace(
        b->>'content',
        'Un point de casse répétitif = la fibre ne couvre pas bien cette zone.'::text,
        'Un point de casse répétitif mérite une observation plus approfondie de la zone et de la construction. Il ne permet pas, à lui seul, d''en déterminer la cause.'::text
      )))
      ELSE b
    END
    ORDER BY ord
  )
  FROM jsonb_array_elements(content_blocks) WITH ORDINALITY AS t(b, ord)
)
WHERE id = 'b83e7105-64e3-4288-997f-2e9c85a1d2f8';

-- CORRECTION 2 — M5.L4 — text block (zone blanche) — R2
UPDATE academy_lessons
SET content_blocks = (
  SELECT jsonb_agg(
    CASE
      WHEN (b->>'type' = 'text' AND b->>'content' LIKE '%Zone blanche ou opaque localisée — air emprisonné sous ou autour de la fibre%')
      THEN jsonb_set(b, '{content}', to_jsonb(replace(
        b->>'content',
        'Zone blanche ou opaque localisée — air emprisonné sous ou autour de la fibre'::text,
        'Zone blanche ou opaque localisée — aspect à observer et à contrôler avant de poursuivre. Plusieurs causes sont possibles et l''aspect visuel seul ne permet pas de les déterminer avec certitude.'::text
      )))
      ELSE b
    END
    ORDER BY ord
  )
  FROM jsonb_array_elements(content_blocks) WITH ORDINALITY AS t(b, ord)
)
WHERE id = '34236ea9-65bf-4d7b-8de8-b43c9a67dcb6';

-- CORRECTION 3 — M5.L4 — tip block — R4 (fabricant-first)
UPDATE academy_lessons
SET content_blocks = (
  SELECT jsonb_agg(
    CASE
      WHEN (b->>'type' = 'tip' AND b->>'content' LIKE '%Utilise un gel de viscosité intermédiaire%')
      THEN jsonb_set(b, '{content}', to_jsonb(
        'Utilise un produit adapté à l''étape d''encapsulation et compatible avec le système enseigné, conformément aux indications du fabricant. Si tu dois prendre en main un nouveau produit, entraîne-toi d''abord sur un support de pratique afin d''observer son comportement.'::text
      ))
      ELSE b
    END
    ORDER BY ord
  )
  FROM jsonb_array_elements(content_blocks) WITH ORDINALITY AS t(b, ord)
)
WHERE id = '34236ea9-65bf-4d7b-8de8-b43c9a67dcb6';

-- CORRECTION 4 — M5.L4 — warning block — R4 (seul moyen)
UPDATE academy_lessons
SET content_blocks = (
  SELECT jsonb_agg(
    CASE
      WHEN (b->>'type' = 'warning' AND b->>'content' LIKE '%La lumière rasante est le seul moyen%')
      THEN jsonb_set(b, '{content}', to_jsonb(replace(
        b->>'content',
        'La lumière rasante est le seul moyen de voir les filaments encore en surface avant qu''il soit trop tard.'::text,
        'Une lumière rasante peut aider à mieux visualiser la surface et à repérer d''éventuels filaments encore visibles avant de poursuivre. Complète toujours par une observation attentive de l''ensemble de la zone.'::text
      )))
      ELSE b
    END
    ORDER BY ord
  )
  FROM jsonb_array_elements(content_blocks) WITH ORDINALITY AS t(b, ord)
)
WHERE id = '34236ea9-65bf-4d7b-8de8-b43c9a67dcb6';

-- CORRECTION 5 — M9.L3 — tip block — R12 (vocabulaire)
UPDATE academy_lessons
SET content_blocks = (
  SELECT jsonb_agg(
    CASE
      WHEN (b->>'type' = 'tip' AND b->>'content' LIKE '%l''esthéticienne%')
      THEN jsonb_set(b, '{content}', to_jsonb(replace(
        b->>'content',
        'l''esthéticienne'::text,
        'la professionnelle de l''ongle'::text
      )))
      ELSE b
    END
    ORDER BY ord
  )
  FROM jsonb_array_elements(content_blocks) WITH ORDINALITY AS t(b, ord)
)
WHERE id = 'aa71bff5-b26c-4b95-9bc3-6b4ca6d4a8c3';

-- CORRECTION 6 — M9.L4 — text block — R12 (vocabulaire)
UPDATE academy_lessons
SET content_blocks = (
  SELECT jsonb_agg(
    CASE
      WHEN (b->>'type' = 'text' AND b->>'content' LIKE '%En tant qu''esthéticienne%')
      THEN jsonb_set(b, '{content}', to_jsonb(replace(
        b->>'content',
        'En tant qu''esthéticienne'::text,
        'En tant que professionnelle de l''ongle'::text
      )))
      ELSE b
    END
    ORDER BY ord
  )
  FROM jsonb_array_elements(content_blocks) WITH ORDINALITY AS t(b, ord)
)
WHERE id = '4039edc4-ff55-4794-a14d-cd8cde081cbe';
