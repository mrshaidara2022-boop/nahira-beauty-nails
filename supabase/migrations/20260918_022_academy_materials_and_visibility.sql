-- ─── 1. fiche_num column + unique constraint ──────────────────────────────────
ALTER TABLE academy_materials ADD COLUMN IF NOT EXISTS fiche_num TEXT;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'academy_materials_course_fiche_num_key'
  ) THEN
    ALTER TABLE academy_materials
      ADD CONSTRAINT academy_materials_course_fiche_num_key UNIQUE (course_id, fiche_num);
  END IF;
END $$;

-- ─── 2. is_hidden columns ─────────────────────────────────────────────────────
ALTER TABLE academy_modules ADD COLUMN IF NOT EXISTS is_hidden BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE academy_lessons ADD COLUMN IF NOT EXISTS is_hidden BOOLEAN NOT NULL DEFAULT false;

-- ─── 3. Seed F1–F12 ───────────────────────────────────────────────────────────
INSERT INTO academy_materials (course_id, title, file_url, file_type, fiche_num, sort_order) VALUES
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Liste de matériel & références Nahira','/fiches-pdf/Nahira_Academy_F1_Liste_de_materiel_et_references_Nahira.pdf','pdf','F1',1),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Protocole de pose — fibre de verre','/fiches-pdf/Nahira_Academy_F2_Protocole_de_pose_fibre_de_verre.pdf','pdf','F2',2),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Accord de prestation esthétique','/fiches-pdf/Nahira_Academy_F3_Accord_de_prestation_esthetique.pdf','pdf','F3',3),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Conseils d''entretien à domicile','/fiches-pdf/Nahira_Academy_F4_Conseils_entretien_a_domicile.pdf','pdf','F4',4),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Conseils — finitions & nail art','/fiches-pdf/Nahira_Academy_F5_Conseils_finitions_et_nail_art.pdf','pdf','F5',5),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Grille d''observation — signes d''alerte & conduite professionnelle','/fiches-pdf/Nahira_Academy_F6_Grille_observation_signes_alerte.pdf','pdf','F6',6),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Protocoles d''urgence en prestation','/fiches-pdf/Nahira_Academy_F7_Protocoles_urgence_en_prestation.pdf','pdf','F7',7),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Calculateur de tarif personnalisé','/fiches-pdf/Nahira_Academy_F8_Calculateur_de_tarif_personnalise.pdf','pdf','F8',8),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Grille de prestations & tarifs','/fiches-pdf/Nahira_Academy_F9_Grille_de_prestations_et_tarifs.pdf','pdf','F9',9),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Modèles de messages de suivi client','/fiches-pdf/Nahira_Academy_F10_Modeles_de_messages_de_suivi_client.pdf','pdf','F10',10),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Protocole de rééquilibrage','/fiches-pdf/Nahira_Academy_F11_Protocole_de_reequilibrage.pdf','pdf','F11',11),
  ('438bd375-1e34-4f0d-8b95-39ea2ff883b3','Check-list qualité finale & clôture de prestation','/fiches-pdf/Nahira_Academy_F12_Check_list_qualite_finale_et_cloture.pdf','pdf','F12',12)
ON CONFLICT (course_id, fiche_num) DO NOTHING;

-- ─── 4. Grants ────────────────────────────────────────────────────────────────
GRANT INSERT, UPDATE, DELETE ON academy_materials TO authenticated;

-- ─── 5. RLS: filter is_hidden ────────────────────────────────────────────────
DROP POLICY IF EXISTS "ac_modules_select" ON academy_modules;
CREATE POLICY "ac_modules_select" ON academy_modules FOR SELECT
  USING (
    is_admin() OR
    (is_hidden = false AND EXISTS (
      SELECT 1 FROM academy_enrollments e
      WHERE e.user_id = auth.uid() AND e.course_id = academy_modules.course_id
    ))
  );

DROP POLICY IF EXISTS "ac_lessons_select" ON academy_lessons;
CREATE POLICY "ac_lessons_select" ON academy_lessons FOR SELECT
  USING (
    is_admin() OR
    is_preview = true OR
    (is_hidden = false AND EXISTS (
      SELECT 1 FROM academy_enrollments e
      WHERE e.user_id = auth.uid() AND e.course_id = academy_lessons.course_id
    ))
  );
