-- Phase 11: Fix M12.L1 content_blocks — remove Bonne réponse column
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- NEVER modify project tjnldcxidcztwpwhxuuo (HAURANA production)
--
-- The 41-question table with "Bonne réponse" column was pedagogically correct
-- for the formation source material but must not appear in the lesson renderer,
-- which now drives the quiz interactively from academy_quiz_questions.
-- We replace the table block with a concise intro that matches the seeded quiz.

DO $fix$
DECLARE
  lid UUID;
BEGIN
  -- Find M12.L1 by matching its known title
  SELECT l.id INTO lid
  FROM   academy_lessons l
  JOIN   academy_modules m ON m.id = l.module_id
  JOIN   academy_courses c ON c.id = m.course_id
  WHERE  c.slug        = 'fiber-signature'
  AND    m.sort_order  = 12
  AND    l.sort_order  = 1
  LIMIT  1;

  IF lid IS NULL THEN
    RAISE NOTICE 'M12.L1 not found — skipping';
    RETURN;
  END IF;

  UPDATE academy_lessons
  SET    content_blocks = $json$[
    {
      "type": "text",
      "content": "Comment ça fonctionne : 20 questions sont tirées aléatoirement parmi 41. Sélectionne ta réponse pour chaque question, puis valide pour voir ton score et les explications détaillées. Tu peux relancer un nouveau tirage à tout moment — les tentatives sont illimitées.\n\nSeuil de validation du parcours pédagogique : 14 / 20 minimum. Ce seuil est un critère interne Nahira Academy — il ne constitue ni un diplôme, ni une certification professionnelle reconnue par une autorité publique."
    },
    {
      "type": "info",
      "content": "Barème de validation du parcours pédagogique Nahira Academy (seuil minimum : 14 / 20) :\n— 18–20 : excellente maîtrise de l'ensemble des notions\n— 14–17 : parcours pédagogique validé — quelques points à consolider\n— 10–13 : révision recommandée — parcours non encore validé\n— 0–9 : bases à retravailler — parcours non encore validé\n\nCe seuil est un critère pédagogique interne — il ne constitue ni un diplôme, ni une certification professionnelle reconnue par une autorité publique. Les explications de chaque question indiquent quel module approfondir. Les tentatives sont illimitées."
    }
  ]$json$::jsonb
  WHERE  id = lid;

  RAISE NOTICE 'M12.L1 content_blocks updated — Bonne réponse column removed.';
END;
$fix$;
