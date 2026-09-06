-- Migration: ajouter un lien contextuel discret vers la fiche de référence
-- dans chaque leçon où la fiche est réellement utilisée.
-- Chaque UPDATE APPENDE un seul bloc fiche à la fin du contenu existant.
-- M13.L2 reste la bibliothèque centrale complète F1–F12.

-- F1 — Liste de matériel & références Nahira
-- Leçon : "Kit complet — organisation et investissement de départ"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F1","title":"Liste de matériel & références Nahira","filename":"Nahira_Academy_F1_Liste_de_materiel_et_references_Nahira.pdf"}]'::jsonb
WHERE id = '0ca3ff9f-552f-4307-aec2-9021bf21e9e1';

-- F3 — Accord de prestation esthétique
-- Leçon : "Accord de prestation esthétique — information cliente et accord avant pose"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F3","title":"Accord de prestation esthétique","filename":"Nahira_Academy_F3_Accord_de_prestation_esthetique.pdf"}]'::jsonb
WHERE id = '334c3891-a484-452d-a236-35e691253b0e';

-- F4 — Conseils d'entretien à domicile
-- Leçon : "Informer la cliente — fréquences, entretien à domicile & durée de vie de la pose"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F4","title":"Conseils d''entretien à domicile","filename":"Nahira_Academy_F4_Conseils_entretien_a_domicile.pdf"}]'::jsonb
WHERE id = '700959a0-2fda-484c-8651-0fea493d5ab6';

-- F5 — Conseils — finitions & nail art
-- Leçon : "Durabilité du nail art — protection & conseils cliente"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F5","title":"Conseils — finitions & nail art","filename":"Nahira_Academy_F5_Conseils_finitions_et_nail_art.pdf"}]'::jsonb
WHERE id = '52873b8a-b5cf-4698-8201-dc782123f660';

-- F6 — Grille d'observation — signes d'alerte & conduite professionnelle
-- Leçon : "Signes d'alerte unguéaux — observer & décider"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F6","title":"Grille d''observation — signes d''alerte & conduite professionnelle","filename":"Nahira_Academy_F6_Grille_observation_signes_alerte.pdf"}]'::jsonb
WHERE id = '4039edc4-ff55-4794-a14d-cd8cde081cbe';

-- F7 — Protocoles d'urgence en prestation
-- Leçon : "Incidents en cours de prestation — protocoles d'urgence"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F7","title":"Protocoles d''urgence en prestation","filename":"Nahira_Academy_F7_Protocoles_urgence_en_prestation.pdf"}]'::jsonb
WHERE id = '220373c3-acaf-4a45-bc36-a8b9c3061400';

-- F8 — Calculateur de tarif personnalisé
-- Leçon : "Calculer son tarif — méthode par le coût de revient"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F8","title":"Calculateur de tarif personnalisé","filename":"Nahira_Academy_F8_Calculateur_de_tarif_personnalise.pdf"}]'::jsonb
WHERE id = '9f262739-d1ee-46db-a95f-645de302a704';

-- F9 — Grille de prestations & tarifs
-- Leçon : "Structurer son offre de prestations"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F9","title":"Grille de prestations & tarifs","filename":"Nahira_Academy_F9_Grille_de_prestations_et_tarifs.pdf"}]'::jsonb
WHERE id = '7ecfa1d5-40e2-4b7c-8d43-3a4e4d9fb98a';

-- F10 — Modèles de messages de suivi client
-- Leçon : "Fidélisation et suivi client"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F10","title":"Modèles de messages de suivi client","filename":"Nahira_Academy_F10_Modeles_de_messages_de_suivi_client.pdf"}]'::jsonb
WHERE id = 'fd44ad39-7cc3-43f1-9e62-01b89b3add99';

-- F11 — Protocole de rééquilibrage
-- Leçon : "Protocole de rééquilibrage — étape par étape"
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F11","title":"Protocole de rééquilibrage","filename":"Nahira_Academy_F11_Protocole_de_reequilibrage.pdf"}]'::jsonb
WHERE id = '558bd8e3-3ba9-4ba3-a781-49cb8aa348c5';

-- F12 — Check-list qualité finale & clôture de prestation
-- Leçon : "Construction de l'apex, couche de scellement et récapitulatif du protocole"
--         (fin du protocole de pose — moment naturel d'utilisation de F12)
UPDATE academy_lessons
SET content_blocks = content_blocks || '[{"type":"fiche","num":"F12","title":"Check-list qualité finale & clôture de prestation","filename":"Nahira_Academy_F12_Check_list_qualite_finale_et_cloture.pdf"}]'::jsonb
WHERE id = '7b28ffd2-df5d-4533-a642-154a66b42da8';
