
-- CORRECTION R12 résiduelle — M9.L4 warning block
-- "L'esthéticienne engage sa responsabilité professionnelle."
-- → "La professionnelle de l'ongle reste responsable du respect de son cadre de prestation,
--     de ses protocoles et des limites de son intervention."

UPDATE academy_lessons
SET content_blocks = (
  SELECT jsonb_agg(
    CASE
      WHEN (b->>'type' = 'warning' AND b->>'content' LIKE '%L''esthéticienne engage sa responsabilité professionnelle.%')
      THEN jsonb_set(b, '{content}', to_jsonb(replace(
        b->>'content',
        'L''esthéticienne engage sa responsabilité professionnelle.'::text,
        'La professionnelle de l''ongle reste responsable du respect de son cadre de prestation, de ses protocoles et des limites de son intervention.'::text
      )))
      ELSE b
    END
    ORDER BY ord
  )
  FROM jsonb_array_elements(content_blocks) WITH ORDINALITY AS t(b, ord)
)
WHERE id = '4039edc4-ff55-4794-a14d-cd8cde081cbe';
