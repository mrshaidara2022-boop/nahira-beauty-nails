-- Migration: ajouter les blocs de téléchargement des fiches F1–F12 dans M13.L2
-- Complète le tableau canonique (migration _012) avec les liens de téléchargement PDF.

UPDATE academy_lessons
SET content_blocks = $cb$[
  {"type":"section","label":"Toutes les fiches de la formation"},
  {"type":"text","content":"Les fiches F1 à F12 sont les documents pratiques de référence de la Masterclass Fiber Signature. Elles sont téléchargeables depuis l'Atelier Nahira en format digital interactif et en format imprimable."},
  {"type":"table","headers":["Fiche","Titre","Description"],"rows":[
    ["F1","Liste de matériel & références Nahira","Inventaire du matériel et des consommables · tableau de références personnelles · investissement indicatif par catégorie"],
    ["F2","Protocole de pose — fibre de verre","Déroulement de la pose étape par étape · paramètres à adapter selon le système fabricant"],
    ["F3","Accord de prestation esthétique","Document d'information et d'accord à compléter avec la cliente · à adapter selon le cadre légal applicable"],
    ["F4","Conseils d'entretien à domicile","Remise cliente après toute pose · gestes quotidiens de protection · points de vigilance à domicile"],
    ["F5","Conseils — finitions & nail art","Remise cliente si finition ou nail art réalisé · entretien des finitions · conseils selon le système et la technique utilisés"],
    ["F6","Grille d'observation — signes d'alerte & conduite professionnelle","Aide-mémoire au poste de travail · signes à observer · conduite professionnelle par situation · principes d'observation et de description"],
    ["F7","Protocoles d'urgence en prestation","Aide-mémoire au poste de travail · conduites immédiates par situation · numéros d'urgence · principe FDS-prioritaire"],
    ["F8","Calculateur de tarif personnalisé","Tableau de calcul de la base tarifaire indicative · 4 composantes · à compléter avec ses propres données"],
    ["F9","Grille de prestations & tarifs","Liste canonique des prestations · durées et tarifs personnalisables · outil de gestion interne"],
    ["F10","Modèles de messages de suivi client","Modèles de messages post-prestation, de rappel de rendez-vous et de réponse aux avis · à adapter à son style"],
    ["F11","Protocole de rééquilibrage","Évaluation de la pose existante · traitement des soulèvements · préparation et repose sur repousse"],
    ["F12","Check-list qualité finale & clôture de prestation","Contrôle qualité technique · transmission des informations à la cliente · clôture administrative et hygiène du poste"]
  ]},
  {"type":"tip","content":"Imprimer ou enregistrer les fiches F1, F2 et F7 dans l'espace de travail, et les fiches F3, F8, F9 dans un dossier administratif accessible rapidement. Les fiches F12 et F5 sont utiles à portée de main lors de la formation continue et des nouvelles situations rencontrées."},
  {"type":"section","label":"Télécharger les fiches"},
  {"type":"fiche","num":"F1","title":"Liste de matériel & références Nahira","filename":"Nahira_Academy_F1_Liste_de_materiel_et_references_Nahira.pdf"},
  {"type":"fiche","num":"F2","title":"Protocole de pose — fibre de verre","filename":"Nahira_Academy_F2_Protocole_de_pose_fibre_de_verre.pdf"},
  {"type":"fiche","num":"F3","title":"Accord de prestation esthétique","filename":"Nahira_Academy_F3_Accord_de_prestation_esthetique.pdf"},
  {"type":"fiche","num":"F4","title":"Conseils d'entretien à domicile","filename":"Nahira_Academy_F4_Conseils_entretien_a_domicile.pdf"},
  {"type":"fiche","num":"F5","title":"Conseils — finitions & nail art","filename":"Nahira_Academy_F5_Conseils_finitions_et_nail_art.pdf"},
  {"type":"fiche","num":"F6","title":"Grille d'observation — signes d'alerte & conduite professionnelle","filename":"Nahira_Academy_F6_Grille_observation_signes_alerte.pdf"},
  {"type":"fiche","num":"F7","title":"Protocoles d'urgence en prestation","filename":"Nahira_Academy_F7_Protocoles_urgence_en_prestation.pdf"},
  {"type":"fiche","num":"F8","title":"Calculateur de tarif personnalisé","filename":"Nahira_Academy_F8_Calculateur_de_tarif_personnalise.pdf"},
  {"type":"fiche","num":"F9","title":"Grille de prestations & tarifs","filename":"Nahira_Academy_F9_Grille_de_prestations_et_tarifs.pdf"},
  {"type":"fiche","num":"F10","title":"Modèles de messages de suivi client","filename":"Nahira_Academy_F10_Modeles_de_messages_de_suivi_client.pdf"},
  {"type":"fiche","num":"F11","title":"Protocole de rééquilibrage","filename":"Nahira_Academy_F11_Protocole_de_reequilibrage.pdf"},
  {"type":"fiche","num":"F12","title":"Check-list qualité finale & clôture de prestation","filename":"Nahira_Academy_F12_Check_list_qualite_finale_et_cloture.pdf"}
]$cb$::jsonb
WHERE title = 'Les fiches pratiques — F1 à F12';
