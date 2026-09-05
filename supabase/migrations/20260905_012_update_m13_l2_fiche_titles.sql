-- Migration: mettre à jour les titres canoniques des fiches F1–F12 dans M13.L2
-- Les intitulés validés remplacent les anciennes descriptions obsolètes.

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
  {"type":"tip","content":"Imprimer ou enregistrer les fiches F1, F2 et F7 dans l'espace de travail, et les fiches F3, F8, F9 dans un dossier administratif accessible rapidement. Les fiches F12 et F5 sont utiles à portée de main lors de la formation continue et des nouvelles situations rencontrées."}
]$cb$::jsonb
WHERE title = 'Les fiches pratiques — F1 à F12';
