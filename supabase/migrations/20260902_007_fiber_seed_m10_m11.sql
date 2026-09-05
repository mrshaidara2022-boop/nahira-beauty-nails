-- ══════════════════════════════════════════════════════════════════
-- Fiber Signature — Seed M10 : Business & tarification
-- ══════════════════════════════════════════════════════════════════
DO $m10$
DECLARE
  cid UUID;
  mid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature' LIMIT 1;

  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Business & tarification', 10)
  RETURNING id INTO mid;

  -- M10.L1 — Structurer son offre de prestations (17 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Structurer son offre de prestations',
    0, 8,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Une offre claire est le premier outil commercial d'une professionnelle de l'ongle. Avant de fixer des tarifs, il faut définir ce qu'on propose — et ce qu'on ne propose pas. Une offre bien structurée facilite la prise de rendez-vous, réduit les malentendus et positionne le niveau de prestation.\n\nLes grandes catégories de prestations en pose fibre de verre :\n— Première pose — durée plus longue, consultation initiale incluse, documentation (fiche F3)\n— Rééquilibrage — entretien régulier, durée variable selon l'état de la pose\n— Dépose simple — sans repose derrière, durée à part entière\n— Dépose + repose — combinaison à proposer en option distincte, pas incluse dans le rééquilibrage\n— Réparation d'ongle — ponctuelle, sur un ou plusieurs ongles, tarif à définir (à l'unité ou forfait)\n— Nail art intégré — supplément ou prestation autonome, selon le niveau de complexité\n— Renforcement sans allongement — prestation adaptée à l'état de la plaque et à la compatibilité avec la technique choisie, à distinguer de la première pose"},
      {"type":"section","label":"Ce qu'on ne propose pas"},
      {"type":"text","content":"Définir ses limites est aussi important que définir son offre. Certaines situations ne relèvent pas de la prestation esthétique : la présence d'un signe d'alerte unguéal, une plaque nécessitant une évaluation par un professionnel de santé, ou une demande incompatible avec le niveau de compétence maîtrisé.\n\nInscrire ces limites dans son offre — et savoir les expliquer — est un marqueur de sérieux professionnel."},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Exemple — Menu de prestations lisible","note":"Présentation claire : nom de la prestation · durée estimée · tarif — Document à créer depuis l'Atelier Nahira · format digital et imprimable"},
      {"type":"section","label":"Faire"},
      {"type":"step","number":1,"title":"Lister toutes les prestations que tu es en mesure de réaliser aujourd'hui","content":"Niveau de compétence acquis."},
      {"type":"step","number":2,"title":"Pour chacune : estimer la durée réelle","content":"Préparation + pose + finitions + nettoyage de poste."},
      {"type":"step","number":3,"title":"Regrouper les prestations par type dans ton menu","content":"Ex. : poses / entretiens / dépose / options."},
      {"type":"step","number":4,"title":"Identifier ce que tu ne proposes pas encore","content":"Le noter clairement pour ne pas le promettre."},
      {"type":"step","number":5,"title":"Compléter la Fiche F9","content":"Ton menu de prestations personnalisé."},
      {"type":"text","content":"📄 Fiche F9 — Modèle de menu de prestations (à personnaliser · format digital et imprimable)"},
      {"type":"warning","content":"Proposer des prestations non encore maîtrisées pour ne pas décevoir une cliente. Le résultat insatisfaisant coûte plus cher — en temps, en réputation, en remboursement — que le refus poli et honnête. L'offre doit refléter le niveau réel, pas le niveau aspiré."},
      {"type":"tip","content":"Afficher les durées estimées à côté de chaque prestation, pas seulement les tarifs : la cliente comprend mieux la valeur de ce qu'elle réserve, et les rendez-vous sont mieux planifiés."},
      {"type":"info","content":"À retenir :\n— Structurer l'offre avant de fixer les tarifs — pas l'inverse\n— Chaque type de prestation a sa propre durée et sa propre complexité\n— Définir ce qu'on ne propose pas est aussi professionnel que définir ce qu'on propose\n— Fiche F9 : menu personnalisé à construire et à tenir à jour"},
      {"type":"je_maitrise","items":["J'ai listé mes prestations avec leur durée estimée","Je sais distinguer rééquilibrage, dépose, réparation et première pose","J'ai complété ma Fiche F9"]}
    ]$cb$
  );

  -- M10.L2 — Calculer son tarif — méthode par le coût de revient (20 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Calculer son tarif — méthode par le coût de revient',
    1, 12,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Un tarif ne se définit pas au feeling ni par comparaison directe avec d'autres professionnelles. Il se calcule à partir de ta réalité : ce que tes matières premières te coûtent, ce que ton activité te coûte à faire tourner, et ce que tu souhaites gagner pour ton temps.\n\nLa méthode présentée ici est une base de calcul accessible. Elle ne remplace pas un accompagnement comptable, mais elle te donne les éléments pour ne pas travailler à perte."},
      {"type":"section","label":"Les 4 composantes du tarif"},
      {"type":"table","headers":["Composante","Ce qu'elle couvre","Comment l'estimer"],"rows":[
        ["Coût matières premières","Consommables utilisés pour cette prestation : gel, fibre, lime, compresses, désinfectants, top coat…","Estimer le coût par prestation : prix du produit ÷ nombre de prestations qu'il couvre"],
        ["Charges fixes proportionnelles","Part de loyer, abonnements (logiciel, téléphone pro), assurance, formation, communication — ramenée à l'heure travaillée","Total charges fixes mensuelles ÷ heures travaillées par mois = charge fixe horaire"],
        ["Rémunération cible","Ce que tu vises à générer par heure de travail — les modalités de calcul (net, brut, cotisations) varient selon ton statut, ton pays et ton régime fiscal ou social","Définir un objectif mensuel, puis le convertir en taux horaire selon ton statut — un expert-comptable peut t'aider à intégrer correctement cotisations et fiscalité"],
        ["Majoration de sécurité","Imprévus, renouvellement matériel, formation continue, variation d'activité. Les cotisations sociales, la fiscalité, les taxes éventuelles et les commissions de paiement sont à intégrer séparément, en dehors de cette majoration, selon le statut et le pays.","Appliquer une majoration sur le total des 3 composantes : à titre indicatif, une majoration de 10 % correspond à multiplier le total par 1,10 ; 20 % par 1,20. Le pourcentage est à adapter selon ta situation."]
      ]},
      {"type":"section","label":"La formule de base — estimation indicative"},
      {"type":"text","content":"(Coût matières + Charges fixes par prestation + Rémunération cible par prestation) × Majoration de sécurité (ex. ×1,10) = Base tarifaire indicative\n\nCette base de calcul pédagogique donne un point de départ — pas un seuil universel. Selon ton statut, ton pays et ton régime, il reste à intégrer les cotisations sociales, la fiscalité, les éventuelles taxes, les commissions de paiement et tout autre prélèvement applicable. Ton tarif réel peut être supérieur à cette base selon ton positionnement, ton expérience et ton marché local."},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Fiche F8 — Calculateur de tarif","note":"Tableau à compléter : matières premières · charges · rémunération cible · base tarifaire indicative calculée — Document à créer depuis l'Atelier Nahira · format digital interactif ou imprimable"},
      {"type":"section","label":"Faire"},
      {"type":"step","number":1,"title":"Lister tous les consommables utilisés pour une prestation type","content":"Première pose, rééquilibrage — estimer leur coût unitaire."},
      {"type":"step","number":2,"title":"Lister tes charges fixes mensuelles","content":"Les diviser par ton nombre d'heures travaillées par mois."},
      {"type":"step","number":3,"title":"Définir ton objectif de rémunération mensuelle et le convertir en taux horaire","content":"La conversion net/brut ou la prise en compte des cotisations dépend de ton statut et de ta situation fiscale."},
      {"type":"step","number":4,"title":"Appliquer la formule sur chacune de tes prestations principales","content":""},
      {"type":"step","number":5,"title":"Compléter la Fiche F8 avec tes chiffres réels","content":""},
      {"type":"text","content":"📄 Fiche F8 — Calculateur de tarif personnalisé (à compléter avec tes propres données)"},
      {"type":"text","content":"Cas client — Tu réalises en complétant la Fiche F8 que ton tarif de rééquilibrage actuel est inférieur à la base tarifaire indicative que tu viens de calculer. Comment réagis-tu ?\nC'est une information précieuse, pas une catastrophe. Plusieurs options existent :\n— Revoir les coûts matières : certains consommables sont-ils surestimés ? Peux-tu optimiser sans réduire la qualité ?\n— Augmenter progressivement le tarif : une hausse annoncée à l'avance, justifiée par l'évolution de l'offre ou le niveau de compétence, est mieux acceptée qu'une hausse surprise\n— Ajuster les durées : si la prestation dure plus longtemps que prévu, c'est peut-être le protocole qu'il faut affiner plutôt que le tarif\nCe qu'on ne fait pas : continuer à proposer un tarif non viable en espérant que ça s'arrange."},
      {"type":"info","content":"Note professionnelle — La méthode présentée est un outil pédagogique de base. Pour une gestion comptable complète, consulte un expert-comptable ou un conseiller en création d'entreprise. Les obligations fiscales et sociales varient selon ton statut juridique (auto-entrepreneur, SARL, EI…) et ton régime."},
      {"type":"warning","content":"Calculer son tarif uniquement à partir de ce que font les autres professionnelles dans sa zone. Le tarif d'une autre ne reflète pas tes charges, tes objectifs ni ton positionnement. S'en inspirer pour se situer sur le marché est utile — le copier sans calcul propre est risqué."},
      {"type":"tip","content":"Refaire le calcul une fois par an — ou à chaque changement important (nouveau fournisseur, hausse de loyer, ajout de matériel). Les coûts évoluent ; le tarif doit suivre."},
      {"type":"info","content":"À retenir :\n— 4 composantes : matières premières + charges fixes + rémunération cible + majoration de sécurité\n— La base tarifaire calculée est indicative — cotisations, fiscalité, taxes et autres prélèvements applicables restent à intégrer selon le statut\n— Chaque professionnelle calcule à partir de sa propre réalité — il n'y a pas de tarif universel\n— Fiche F8 à compléter avec ses propres données et à revoir régulièrement"},
      {"type":"je_maitrise","items":["Je connais les 4 composantes du calcul de tarif et ce qu'elles couvrent","J'ai utilisé la Fiche F8 pour obtenir une base de calcul indicative pour au moins une prestation","Je comprends pourquoi copier le tarif d'une autre professionnelle sans calcul propre est risqué"]}
    ]$cb$
  );

  -- M10.L3 — Afficher et présenter ses tarifs (13 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Afficher et présenter ses tarifs',
    2, 8,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Afficher ses tarifs est une obligation professionnelle dans de nombreux contextes d'exercice — les modalités exactes varient selon ton statut, ton lieu d'exercice et la réglementation applicable dans ton pays. Renseigne-toi sur les obligations d'affichage qui te concernent spécifiquement, en lien avec ta chambre professionnelle ou ton organisme de référence.\n\nAu-delà des obligations légales, l'affichage clair des tarifs est un outil de confiance : la cliente sait à quoi s'attendre avant de prendre rendez-vous."},
      {"type":"section","label":"Information sur les prix : obligations et bonnes pratiques"},
      {"type":"text","content":"Les obligations légales d'information sur les prix varient selon le statut, le lieu d'exercice et la réglementation applicable — vérifier auprès de sa chambre professionnelle ou d'un conseiller juridique ce qui s'impose dans sa situation.\n\nDans tous les cas, le principe directeur est le suivant : lorsque le prix d'une prestation peut être déterminé à l'avance, il doit être clairement communiqué à la cliente avant tout engagement. Lorsqu'il ne peut pas l'être (prestation variable, suppléments possibles), le mode de calcul, les éventuels suppléments et le prix définitif doivent être portés à la connaissance de la cliente avant qu'elle ne s'engage.\n\nBonnes pratiques au-delà des obligations :\n— Afficher la durée estimée — bonne pratique commerciale, non obligation légale universelle ; aide la cliente à planifier et valorise le travail fourni\n— Préciser ce qui est inclus — ex. : \"premier rendez-vous incluant consultation et fiche client\" ou \"nail art : supplément selon la technique\"\n— Mettre à jour régulièrement — un tarif affiché qui ne correspond plus à la réalité fragilise la relation de confiance"},
      {"type":"section","label":"Répondre à 'c'est cher'"},
      {"type":"text","content":"Cette remarque est fréquente et souvent une invitation à expliquer la valeur — pas une attaque. Quelques formulations calmes et professionnelles :\n\nCliente : \"C'est cher pour des ongles…\"\nRéponse professionnelle : \"Ce tarif couvre une prestation complète : consultation, préparation, pose, finitions — environ [durée]. Ce que vous payez, c'est aussi le matériel professionnel, l'hygiène stricte et le suivi à chaque visite.\"\n\nCliente : \"J'ai vu moins cher ailleurs.\"\nRéponse professionnelle : \"Les tarifs varient selon le matériel utilisé, le temps passé et le niveau de formation. Mon tarif reflète ce que je mets en place pour votre sécurité et la qualité du résultat.\"\n\nL'objectif n'est pas de convaincre à tout prix — c'est d'expliquer avec calme. Une cliente qui ne comprend pas la valeur de la prestation n'est pas toujours la bonne cliente pour ton positionnement."},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo — Exemples d'affichage tarifs en salon et en digital","note":"Format mural · format Instagram bio · format site web — Exemples à créer depuis l'Atelier Nahira"},
      {"type":"info","content":"Note professionnelle — Les obligations d'affichage des tarifs (contenu, format, emplacement) sont définies par la réglementation applicable à ton lieu et statut d'exercice. En France, un arrêté réglemente l'affichage des prix dans les établissements de soins esthétiques — vérifie les textes en vigueur ou contacte ta chambre professionnelle pour confirmer ce qui s'applique à ta situation."},
      {"type":"warning","content":"Baisser son tarif face à une remarque de la cliente pour éviter le conflit. Cette décision ponctuelle installe une dynamique difficile à corriger : la cliente s'attend ensuite systématiquement à une remise, et la valeur de la prestation est fragilisée."},
      {"type":"tip","content":"Préparer deux ou trois formulations courtes et calmes pour répondre aux questions de tarif. Les répéter à voix haute avant de les utiliser en situation réelle : elles deviennent automatiques et la réponse sort sans hésitation ni justification excessive."},
      {"type":"info","content":"À retenir :\n— Obligations d'information sur les prix : vérifier les règles applicables selon son statut et son lieu d'exercice\n— Communiquer le prix clairement avant tout engagement ; si le prix varie, expliquer le mode de calcul et les suppléments possibles\n— Répondre aux questions de tarif avec calme, sans se justifier à l'excès\n— Ne pas baisser son tarif sous pression — expliquer la valeur, pas défendre le prix"},
      {"type":"je_maitrise","items":["J'ai affiché mes tarifs de façon lisible (en salon et/ou en ligne)","Je peux répondre calmement à \"c'est cher\" sans me justifier de façon excessive","Je sais quelles obligations d'affichage s'appliquent à ma situation"]}
    ]$cb$
  );

  -- M10.L4 — Gérer son temps — rentabilité et optimisation (14 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Gérer son temps — rentabilité et optimisation',
    3, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Le temps est la ressource principale d'une prestataire de services. Contrairement au matériel, il ne se renouvelle pas — chaque heure passée sur une prestation est une heure qui ne peut pas être utilisée ailleurs. Gérer son temps, c'est gérer directement sa rentabilité.\n\nDeux indicateurs essentiels à connaître :\n— Taux horaire cible — le montant que tu dois générer par heure travaillée pour atteindre ton objectif (calculé avec la Fiche F8)\n— Chiffre d'affaires horaire moyen — le montant généré en moyenne par heure travaillée sur une période donnée (CA ÷ heures réellement travaillées). Ce montant n'est pas un revenu net : charges, cotisations, taxes et autres coûts restent à déduire et varient selon le statut.\n\nUn écart important entre le taux cible et le chiffre d'affaires horaire moyen signale un problème à investiguer : durées sous-estimées, tarif insuffisant, ou trop de temps non facturable (déplacements, annulations, tâches administratives)."},
      {"type":"section","label":"Identifier les pertes de temps non visibles"},
      {"type":"table","headers":["Source de perte de temps","Leviers d'optimisation"],"rows":[
        ["Préparation du poste de travail en cours de prestation","Préparer tout le matériel nécessaire avant que la cliente arrive — routine de setup standardisée"],
        ["Annulations de dernière minute non compensées","Politique d'annulation claire (délai, acompte) — à mentionner à la prise de rendez-vous"],
        ["Durée réelle de la prestation supérieure au temps réservé","Chronométrer régulièrement ses prestations pour ajuster les créneaux proposés"],
        ["Retouches gratuites non anticipées","Distinguer retouche légitime (erreur de pose) et retouche liée aux habitudes de la cliente — politique de retouche à définir"],
        ["Transitions entre clientes trop courtes","Prévoir un tampon de 10–15 min entre deux prestations pour le rangement, la désinfection et la documentation"]
      ]},
      {"type":"section","label":"Faire"},
      {"type":"step","number":1,"title":"Chronométrer tes 5 prochaines prestations","content":"Départ : arrivée de la cliente · fin : poste propre et prêt pour la suivante."},
      {"type":"step","number":2,"title":"Comparer la durée réelle à la durée réservée","content":"Noter l'écart sur chaque type de prestation."},
      {"type":"step","number":3,"title":"Calculer ton chiffre d'affaires horaire moyen sur le mois écoulé","content":"CA ÷ heures réellement travaillées — le comparer à ton taux cible. Ce montant n'est pas ton revenu net ; charges, cotisations et taxes restent à déduire."},
      {"type":"step","number":4,"title":"Identifier la principale source d'écart et définir une action correctrice","content":""},
      {"type":"text","content":"Cas client — Tu réalises que tes rééquilibrages durent en moyenne 2h30 mais que tu n'as réservé que 2h dans ton planning. Tu termines systématiquement en retard, et la cliente suivante attend. Que fais-tu ?\nDeux actions simultanées :\n— Ajuster les créneaux immédiatement — passer les rééquilibrages à 2h30 dans ton planning, quitte à accepter moins de clientes par jour\n— Analyser la durée — les 30 minutes supplémentaires viennent-elles systématiquement du même moment (traitement des soulèvements ? limage de surface ? finitions ?) ? Si oui, c'est un point de protocole à travailler\nCe qu'on ne fait pas : continuer à réserver 2h en espérant aller plus vite. La cliente qui attend n'oublie pas, et la fatigue de finir constamment en retard dégrade la qualité du travail."},
      {"type":"warning","content":"Optimiser la vitesse d'exécution au détriment de la qualité pour \"rentabiliser\" le temps. La pose bâclée génère des retouches, des réclamations et des clientes perdues — ce qui coûte plus que le temps gagné. Optimiser, c'est éliminer les pertes, pas accélérer les étapes indispensables."},
      {"type":"tip","content":"Préparer un setup standardisé par type de prestation (liste du matériel à sortir, ordre de disposition sur le plan de travail) et le respecter à chaque fois. Un poste prêt avant l'arrivée de la cliente, c'est 5 à 10 minutes récupérées par prestation — soit une heure par semaine sur un planning chargé."},
      {"type":"info","content":"À retenir :\n— Taux horaire cible vs chiffre d'affaires horaire moyen : comparer régulièrement pour identifier les écarts\n— Chronométrer ses prestations pour ajuster les créneaux — pas pour aller plus vite\n— Identifier les pertes de temps non facturables et les réduire une par une\n— Politique d'annulation claire : protège le temps et professionnalise la relation"},
      {"type":"je_maitrise","items":["Je peux calculer mon chiffre d'affaires horaire moyen sur une période donnée","J'ai identifié ma principale source de perte de temps non facturable","J'ai chronométré mes prestations et ajusté mes créneaux si nécessaire"]}
    ]$cb$
  );

  -- M10.L5 — Traçabilité et fiche cliente (13 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Traçabilité et fiche cliente',
    4, 8,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La fiche cliente est à la fois un outil professionnel, un outil de suivi technique et un outil de protection. Elle permet de retrouver en un coup d'œil l'historique de chaque cliente, de documenter les décisions prises et les observations faites, et de justifier sa pratique en cas de litige.\n\nCe que doit contenir une fiche cliente complète :\n— Coordonnées de la cliente (nom, prénom, contact)\n— Date de chaque prestation + type de prestation réalisée\n— Produits utilisés (système, marque, références si possible)\n— Observations à chaque visite : état de la pose, des ongles naturels, zones traitées\n— Décisions prises et leur justification (report, adaptation, refus)\n— Informations déclarées par la cliente (sensibilités, antécédents, habitudes)\n— Accord de prestation (Fiche F3) — signé ou validé à la première prestation, et actualisé si les informations changent"},
      {"type":"section","label":"La Fiche F3 — accord de prestation esthétique"},
      {"type":"text","content":"La Fiche F3 est un document d'information et d'accord que Nahira Academy propose dans le cadre de sa démarche de qualité et de sécurité. Elle n'est pas un document à valeur légale universelle — ses effets varient selon le cadre réglementaire de ton pays et de ton statut d'exercice.\n\nSon rôle principal est de s'assurer que la cliente a reçu les informations nécessaires avant la prestation, qu'elle a eu l'occasion de poser des questions, et qu'elle a donné son accord pour la réalisation du service. C'est aussi un outil de communication qui professionnalise le premier contact.\n\nImportant : la Fiche F3 et l'accord de la cliente ne suppriment pas les obligations professionnelles de la prestataire. Ils ne rendent pas acceptable une prestation qui ne le serait pas — notamment en présence d'un signe d'alerte ou d'une incompatibilité avec la technique. L'accord de la cliente n'est pas un blanc-seing : la responsabilité de la décision technique reste celle de la professionnelle."},
      {"type":"text","content":"📄 Fiche F3 — Accord de prestation esthétique (format digital téléchargeable · format imprimable)"},
      {"type":"section","label":"Données personnelles et confidentialité"},
      {"type":"text","content":"Minimisation des données : ne recueillir que les informations strictement nécessaires à la compatibilité avec la technique et au suivi de la prestation. Éviter les renseignements médicaux détaillés qui n'ont pas de lien direct avec la décision professionnelle à prendre. La minimisation des données réduit les risques liés à leur conservation et facilite leur gestion conforme aux obligations applicables.\n\nLa collecte et la conservation de données personnelles (nom, coordonnées, informations déclarées par la cliente) sont soumises à des obligations légales qui varient selon le pays. En France, le RGPD s'applique — informe-toi sur tes obligations de conservation, de sécurisation et de droit à l'effacement des données de tes clientes.\n\nUn engagement de confidentialité envers tes clientes (ne pas partager leurs informations, sécuriser les fiches papier ou numériques) est un minimum à respecter dans tous les cas."},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Fiche F3 — Accord de prestation esthétique","note":"Document complet : informations collectées · accord cliente · espace observations — Document à finaliser depuis l'Atelier Nahira"},
      {"type":"info","content":"Note professionnelle — Les obligations administratives (facturation, déclaration de revenus, conservation des données clients) varient selon ton statut juridique et ton pays d'exercice. Pour une gestion conforme à ta situation, consulte un expert-comptable, un conseiller juridique ou ta chambre professionnelle."},
      {"type":"tip","content":"Prendre 2 minutes en fin de chaque prestation pour compléter la fiche cliente pendant que les observations sont fraîches. Une fiche remplie le soir même ou le lendemain perd en précision. La régularité de la documentation fait la différence lors d'un suivi ou d'une réclamation ultérieure."},
      {"type":"info","content":"À retenir :\n— Fiche cliente = outil de suivi technique + outil de protection professionnelle\n— Documenter à chaque visite : produits, observations, décisions\n— Fiche F3 : document d'information et d'accord, à adapter selon le cadre légal de son exercice\n— Données personnelles : se renseigner sur les obligations de confidentialité applicables"},
      {"type":"je_maitrise","items":["Ma fiche cliente contient toutes les informations listées dans cette leçon","Je complète la fiche à chaque prestation, pas de mémoire après coup","Je comprends le rôle de la Fiche F3 dans ma démarche professionnelle"]}
    ]$cb$
  );

END;
$m10$;

-- ══════════════════════════════════════════════════════════════════
-- Fiber Signature — Seed M11 : Communication cliente
-- ══════════════════════════════════════════════════════════════════
DO $m11$
DECLARE
  cid UUID;
  mid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature' LIMIT 1;

  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Communication cliente', 11)
  RETURNING id INTO mid;

  -- M11.L1 — La consultation initiale (17 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'La consultation initiale',
    0, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La consultation initiale est le moment qui précède toute première prestation avec une nouvelle cliente. Elle sert à recueillir les informations nécessaires pour adapter le protocole, identifier les éventuels points de vigilance, définir l'objectif esthétique et établir une base de confiance.\n\nUne consultation bien conduite réduit les malentendus, les déceptions et les retours négatifs — et elle donne à la cliente le sentiment d'être véritablement écoutée avant qu'on touche à ses mains.\n\nLes trois piliers de la consultation :\n— Observer — regarder les mains, les ongles, l'état de la peau, la longueur et la forme naturelle des ongles, l'état des cuticules\n— Écouter — laisser la cliente s'exprimer sur son souhait, son expérience passée avec les poses, ses éventuelles contraintes\n— Questionner — poser des questions ouvertes pour obtenir les informations manquantes"},
      {"type":"section","label":"Questions essentielles à la première visite"},
      {"type":"text","content":"— Quel est votre objectif aujourd'hui — allongement, renforcement, esthétique ?\n— Avez-vous déjà porté des poses en gel, acrylique ou fibre de verre ?\n— Avez-vous eu des réactions à un produit utilisé sur vos ongles ou vos mains ?\n— Avez-vous des antécédents de réactions cutanées, de rougeurs persistantes ou de démangeaisons sur la peau ou les ongles ?\n— Y a-t-il une recommandation de votre médecin ou une information médicale concernant les soins esthétiques de vos ongles ou de vos mains que vous souhaitez me communiquer ?\n— Votre activité professionnelle ou quotidienne implique-t-elle un contact fréquent avec l'eau, des produits chimiques ou des équipements de protection (gants) ?\n— Y a-t-il quelque chose de particulier que vous souhaitez que je sache sur vos ongles ou vos mains ?"},
      {"type":"text","content":"📄 Fiche F3 — Accord de prestation esthétique · à compléter avec la cliente à la première visite"},
      {"type":"section","label":"Faire"},
      {"type":"step","number":1,"title":"Accueillir la cliente avant de regarder ses mains","content":"Créer le contact avant l'observation."},
      {"type":"step","number":2,"title":"Observer les mains et les ongles en lumière directe","content":"Avant tout nettoyage ou préparation."},
      {"type":"step","number":3,"title":"Poser les questions essentielles et noter les réponses sur la fiche cliente","content":""},
      {"type":"step","number":4,"title":"Reformuler l'objectif esthétique pour s'assurer qu'il est partagé","content":"Longueur, forme, finition souhaitée."},
      {"type":"step","number":5,"title":"Informer sur le déroulement de la prestation et la durée prévue","content":""},
      {"type":"step","number":6,"title":"Faire signer ou valider la Fiche F3 avant de commencer","content":""},
      {"type":"text","content":"Cas client — Pendant la consultation, tu observes que les ongles de la cliente présentent un aspect que tu n'as pas encore rencontré — tu ne sais pas si tu peux poser. Comment conduis-tu la consultation ?\nTu n'as pas à savoir — tu as à observer et à décider de la conduite professionnelle appropriée.\n— Décrire ce que tu vois (couleur, texture, décollement, épaisseur) sans nommer ni interpréter\n— Demander à la cliente si ce signe est nouveau, récent ou habituel pour elle\n— Si tu n'es pas en mesure de confirmer que la prestation peut être réalisée sans risque : expliquer calmement que tu préfères reporter à une autre date, et recommander une évaluation par un professionnel de santé si le signe est inexpliqué\n— Documenter sur la fiche cliente\nCe que tu ne fais pas : deviner, minimiser, ni commencer la prestation \"pour voir\"."},
      {"type":"warning","content":"Expédier la consultation pour \"passer aux choses sérieuses\". La consultation est une partie sérieuse de la prestation — les informations recueillies orientent toutes les décisions techniques qui suivent. Une consultation bâclée, c'est une prestation conduite sans toutes les données nécessaires."},
      {"type":"tip","content":"Placer la consultation dans un espace de dialogue — pas en regardant les ongles de la cliente de façon muette. Une question, une réponse, un regard : la cliente se sent considérée, pas examinée. Ce ton s'installe dès les premières minutes et tient pour toute la prestation."},
      {"type":"info","content":"À retenir :\n— Observer, écouter, questionner — dans cet ordre et avec attention\n— Reformuler l'objectif esthétique avant de commencer\n— La Fiche F3 complétée à la première visite, actualisée si les informations changent\n— Un signe d'alerte observé pendant la consultation oriente la décision avant même de commencer"},
      {"type":"je_maitrise","items":["Je pose les 7 questions essentielles à chaque première visite","Je sais reformuler l'objectif de la cliente pour m'assurer qu'on est alignées","Je sais conduire une consultation même face à une observation que je ne comprends pas entièrement"]}
    ]$cb$
  );

  -- M11.L2 — Communiquer pendant la prestation (10 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Communiquer pendant la prestation',
    1, 8,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La durée d'une prestation varie selon le type de pose, l'état de la pose à entretenir et le niveau de la professionnelle — elle peut aller de moins d'une heure à plusieurs heures selon les situations. C'est un temps de proximité physique et de concentration des deux côtés — chaque échange pendant ce temps a un impact sur l'expérience globale de la cliente. Communiquer pendant la pose, c'est gérer l'attention, rassurer, informer et maintenir le confort.\n\nTrois types de clientes à adapter :\n— La cliente bavarde — appréciera l'échange ; canaliser doucement la conversation pour ne pas perdre le fil du protocole\n— La cliente silencieuse — n'a pas besoin de remplir le silence ; ne pas forcer l'échange ; signaler les étapes importantes calmement\n— La cliente anxieuse — a besoin d'être informée étape par étape, rassurée par la régularité de ta voix et de tes gestes"},
      {"type":"section","label":"Ce qu'on dit, ce qu'on ne dit pas"},
      {"type":"table","headers":["Situation","Ce qu'on dit","Ce qu'on évite"],"rows":[
        ["Étape qui peut provoquer une légère sensation","\"Je passe à l'étape de la lampe — si tu ressens une chaleur trop forte, dis-le moi.\"","\"Ça peut faire mal\" (anticipe négativement)"],
        ["Changement de plan en cours de prestation","\"Sur cet ongle je vais adapter légèrement le protocole — voilà pourquoi.\"","Ne rien dire et espérer que la cliente ne remarque pas"],
        ["Signe d'alerte observé en cours de pose","\"J'observe quelque chose sur cet ongle qui me demande de m'arrêter un moment.\"","\"Je vois quelque chose de bizarre\" (alarmiste) ou ne rien dire (invisible pour la cliente, pas pour toi)"],
        ["Question technique de la cliente","Réponse simple et honnête — sans sur-expliquer ni minimiser","Jargon professionnel non expliqué, ou fausse certitude"]
      ]},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Vidéo — Consultation et communication en prestation","note":"Exemples de formulations, gestion du silence, annonce des étapes — Vidéo à créer depuis l'Atelier Nahira"},
      {"type":"warning","content":"Combler le silence avec des commentaires sur les ongles de la cliente (\"tes ongles sont vraiment abîmés\", \"tu as beaucoup de soulèvements\"). Ces remarques, même neutres dans l'intention, sont vécues comme un jugement. Formuler uniquement ce qui est utile à la compréhension de la cliente ou à la décision en cours."},
      {"type":"tip","content":"Annoncer les étapes importantes avant de les réaliser : \"Je vais passer les mains à la lampe maintenant\" ou \"Je retire les wraps — dis-moi si tu ressens quoi que ce soit.\" Cette habitude élimine les surprises, réduit l'anxiété et installe une dynamique de confiance."},
      {"type":"info","content":"À retenir :\n— Adapter le mode de communication au profil de la cliente (bavarde, silencieuse, anxieuse)\n— Annoncer les étapes importantes avant de les réaliser\n— Formuler ce qui est utile — pas ce qui comble le silence\n— Face à une observation : décrire calmement ce qu'on voit, pas interpréter"},
      {"type":"je_maitrise","items":["Je sais adapter mon niveau d'échange selon le profil de la cliente","J'annonce les étapes susceptibles de créer une sensation avant de les réaliser","Je formule une observation sans alarmer ni minimiser"]}
    ]$cb$
  );

  -- M11.L3 — Annoncer une observation difficile ou un refus de prestation (12 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Annoncer une observation difficile ou un refus de prestation',
    2, 12,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Annoncer à une cliente qu'on ne peut pas réaliser la prestation — ou qu'on ne peut pas la réaliser dans les conditions souhaitées — est l'un des moments les plus délicats de la relation professionnelle. Bien formulé, ce moment renforce la confiance. Mal formulé, il génère de l'inquiétude, de la déception ou un conflit.\n\nDeux types de situations :\n— Observation qui nécessite une adaptation — la prestation peut se faire, mais différemment de ce qui était prévu (longueur réduite, protocole allégé, un ongle exclu)\n— Observation qui impose un report ou un refus — la prestation ne peut pas être réalisée en l'état, sur un ou plusieurs ongles, ou en totalité"},
      {"type":"section","label":"La formule en 3 temps"},
      {"type":"step","number":1,"title":"Décrire ce qu'on observe","content":"Uniquement les signes visibles, sans nommer ni interpréter : \"J'observe sur cet ongle une modification de couleur et un petit décollement que je n'avais pas noté la dernière fois.\""},
      {"type":"step","number":2,"title":"Expliquer la décision professionnelle","content":"Sans dramatiser ni minimiser : \"Cela me demande de ne pas travailler sur cet ongle aujourd'hui.\""},
      {"type":"step","number":3,"title":"Proposer la suite","content":"Une recommandation claire et une alternative si possible : \"Je te recommande de le faire regarder par un professionnel de santé. On peut tout à fait évaluer si on continue sur les autres ongles selon leur état.\""},
      {"type":"section","label":"Voir — exemples de formulations"},
      {"type":"text","content":"Situation : signe d'alerte sur un ongle\n\"J'observe quelque chose sur ton majeur — une petite zone de couleur différente et un léger espace entre l'ongle et le lit. Je préfère ne pas travailler sur cet ongle aujourd'hui. Je te recommande de le faire regarder par un médecin ou un dermatologiste. Je vais maintenant regarder l'ensemble de tes ongles et évaluer si on peut travailler sur les autres sans risque — je te dis ce que j'observe.\"\n\nSituation : refus de prestation complète\n\"En regardant tes mains, je vois plusieurs ongles qui présentent des signes qui me demandent de reporter la prestation d'aujourd'hui. Ce n'est pas une décision que je prends à la légère — c'est par précaution, parce que la situation nécessite une évaluation avant de poursuivre. Je te recommande de consulter un médecin, et on réévaluera ensemble au rendez-vous suivant.\"\n\nSituation : adaptation du protocole\n\"Tes ongles sont en bon état général, mais je vois que ta plaque est particulièrement fine sur quelques doigts. Je vais adapter ma préparation pour protéger au maximum — la pose sera peut-être un peu différente de ce qu'on avait prévu, mais le résultat sera là.\"\n\nCas client — Tu annonces à la cliente que tu ne peux pas réaliser la prestation sur un ongle. Elle insiste : \"Mais j'ai ça depuis longtemps, c'est normal pour moi.\" Comment tu réponds ?\nLa cliente donne une information sur sa perception — pas sur la compatibilité de la prestation avec la situation de son ongle. Les deux peuvent coexister sans se contredire.\nRéponse : \"Je comprends que ce soit familier pour toi, et c'est une information utile. Cela dit, ma décision de ne pas poser sur cet ongle reste, parce que je ne peux pas évaluer si la situation a évolué depuis la dernière fois. Je préfère être prudente plutôt que de risquer quelque chose que je ne pourrais pas corriger après. Si tu consultes un professionnel de santé et que la situation est évaluée, on verra ensemble au rendez-vous suivant si la prestation est compatible — je réévaluerai à ce moment-là.\"\nCe qu'on ne fait pas : céder parce que la cliente minimise. La décision professionnelle reste la nôtre."},
      {"type":"warning","content":"Surexpliquer ou s'excuser à l'excès lors d'un refus : \"Je suis vraiment désolée, c'est dommage, j'aurais voulu pouvoir le faire…\" Ce niveau d'excuse crée un inconfort, affaiblit la décision professionnelle et peut pousser la cliente à insister davantage. Annoncer calmement, expliquer brièvement, proposer la suite."},
      {"type":"tip","content":"Préparer deux ou trois formulations de refus à l'avance et les pratiquer à voix haute. Dans le moment, la formulation sort naturellement — sans hésitation, sans excuse, sans sur-explication. La cliente perçoit une professionnelle qui sait ce qu'elle fait."},
      {"type":"info","content":"À retenir :\n— 3 temps : décrire ce qu'on observe · expliquer la décision · proposer la suite\n— Décrire uniquement — ne pas nommer ni interpréter le signe observé\n— La décision professionnelle reste la nôtre, même si la cliente minimise\n— Pas d'excuse excessive — expliquer avec calme, pas se justifier indéfiniment"},
      {"type":"je_maitrise","items":["Je peux annoncer un refus ou une adaptation sans alarmer ni minimiser","Je sais maintenir ma décision professionnelle face à une cliente qui insiste","J'ai préparé mes formulations de refus à l'avance"]}
    ]$cb$
  );

  -- M11.L4 — Gérer les retours et les réclamations (16 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Gérer les retours et les réclamations',
    3, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Un retour négatif n'est pas nécessairement une erreur de ta part. Il peut s'agir d'une pose qui a cédé, d'une attente non satisfaite, d'un soulèvement prématuré, ou d'une incompréhension sur ce qui était inclus dans la prestation. Dans tous les cas, la façon dont tu gères le retour compte autant que le retour lui-même.\n\nTrois grandes catégories à distinguer après analyse :\n— Éléments pouvant être liés à la prestation — défaut constaté qui pourrait être lié à un geste, un choix de protocole ou un matériel : à analyser honnêtement, et à corriger si la responsabilité est établie\n— Éléments extérieurs déclarés ou observables — facteur explicitement mentionné par la cliente ou visible à l'observation, sans attribution automatique de cause\n— Origine indéterminée ou multifactorielle — situation où plusieurs facteurs peuvent avoir contribué, sans pouvoir établir de causalité certaine : la transparence sur cette incertitude est une posture professionnelle"},
      {"type":"section","label":"Protocole de gestion d'un retour"},
      {"type":"step","number":1,"title":"Écouter sans interrompre","content":"Laisser la cliente exprimer sa déception ou son insatisfaction complètement avant de répondre."},
      {"type":"step","number":2,"title":"Observer","content":"Regarder l'ongle concerné en lumière directe. Qu'est-ce qui s'est passé exactement ? Où ? Depuis quand ?"},
      {"type":"step","number":3,"title":"Analyser honnêtement","content":"Est-ce un défaut de pose ? Un facteur extérieur ? Une combinaison des deux ? Cette analyse est faite avec la cliente, pas dans ta tête seule."},
      {"type":"step","number":4,"title":"Proposer une solution appropriée","content":"Selon l'analyse, les obligations applicables et la politique que tu as communiquée : correction si le défaut est établi côté prestation ; explication et conseil si un facteur extérieur est clairement en jeu ; geste commercial ou solution intermédiaire si l'origine reste indéterminée."},
      {"type":"step","number":5,"title":"Documenter","content":"Noter sur la fiche cliente ce qui s'est passé, la décision prise et la suite donnée."},
      {"type":"section","label":"Voir — formulations utiles"},
      {"type":"text","content":"Retour de la cliente : \"Mon ongle s'est soulevé au bout de 4 jours, c'est pas normal.\"\nRéponse professionnelle : \"Je comprends, c'est décevant. Est-ce que tu peux me montrer lequel ? Je voudrais voir ce qui s'est passé.\" [observation] \"Je vois un soulèvement sur le bord latéral. Est-ce qu'il y a eu quelque chose de particulier ces 4 derniers jours — un contact avec un produit, quelque chose de particulier à ce doigt ? En fonction de ce que tu me dis et de ce que j'observe, on va voir ensemble ce qu'on peut faire.\""},
      {"type":"section","label":"Retouche : distinguer obligation, geste commercial et politique"},
      {"type":"text","content":"Remédier à un défaut clairement imputable à la prestation relève de l'obligation professionnelle — ce n'est pas un geste commercial, c'est corriger ce qui n'a pas fonctionné du côté de la pose.\n\nLorsque la cause n'est pas établie, proposer une retouche partielle peut être un geste commercial : une décision de ta part, pas une obligation automatique. Ce geste ne vaut pas reconnaissance de responsabilité.\n\nLorsque les éléments disponibles indiquent clairement un facteur déclaré ou observable extérieur à la pose, tu peux ne pas proposer de retouche gratuite — mais cela demande une explication calme, pas un refus abrupt.\n\nSur le délai : un délai long entre la pose et le retour est un élément d'évaluation parmi d'autres — il n'écarte pas automatiquement la responsabilité de la prestation, mais il fait partie du tableau à analyser.\n\nDéfinir une politique de retouche claire (délai, conditions, nombre par prestation) et la communiquer à l'avance évite les situations ambiguës.\n\nCas client — Une cliente revient 10 jours après sa pose en disant que \"tout s'est décollé\". En observant ses ongles, tu constates un soulèvement généralisé mais tu ne sais pas si c'est lié à ta pose ou à autre chose. Comment avances-tu ?\nL'honnêteté est la meilleure stratégie — dans les deux sens.\n— Observer avec la cliente, pas de façon muette. Décrire ce que tu vois : \"Je vois des soulèvements sur plusieurs ongles — principalement sur les côtés. C'est un peu inhabituel à 10 jours.\"\n— Questionner sans orienter : \"Est-ce qu'il y a eu quelque chose de particulier ces 10 derniers jours sur ces ongles ou sur tes mains ?\" — laisser la cliente répondre librement, sans suggérer de cause\n— Si l'origine reste incertaine après discussion : proposer une retouche partielle en geste commercial, en expliquant que tu ne peux pas exclure ta responsabilité sans plus d'information — et noter l'échange sur la fiche cliente\n— Identifier si ta technique ou un produit est peut-être en cause (couche de base trop épaisse ? adhérence insuffisante sur ce type de plaque ?) et noter ce point pour ta propre progression"},
      {"type":"warning","content":"Se défendre avant d'avoir écouté. Quand la cliente exprime une déception, la première réaction défensive (\"j'ai tout fait correctement\", \"c'est forcément toi qui…\") ferme immédiatement le dialogue et installe un rapport de confrontation. Écouter d'abord — analyser ensuite."},
      {"type":"tip","content":"Mettre en place une politique de retouche écrite — délai, conditions, nombre de retouches incluses — et la communiquer à chaque nouvelle cliente. Une politique claire et connue à l'avance réduit les situations ambiguës : la cliente sait ce qui est couvert et ce qui ne l'est pas, et les échanges difficiles partent d'une base partagée."},
      {"type":"info","content":"À retenir :\n— Écouter, observer, analyser — avant de répondre\n— Trois catégories : lié à la prestation / élément extérieur déclaré ou observable / origine indéterminée\n— Obligation de corriger si défaut de pose établi — geste commercial si incertitude — pas de retouche automatique à chaque retour\n— Le délai est un élément d'évaluation, pas une preuve de cause\n— Politique de retouche à définir et à communiquer à l'avance"},
      {"type":"je_maitrise","items":["Je peux gérer un retour en 5 étapes sans me défendre immédiatement","J'ai défini ma politique de retouche et je suis en mesure de l'expliquer","Je sais dire non à une retouche non justifiée, avec calme et explication"]}
    ]$cb$
  );

  -- M11.L5 — Fidélisation et suivi client (14 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Fidélisation et suivi client',
    4, 8,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Une clientèle stable et régulière repose souvent davantage sur la qualité de la relation que sur des actions d'acquisition. La fidélisation ne requiert pas de stratégies marketing complexes — elle repose sur la qualité constante de la prestation, la clarté de la relation, et le soin apporté aux petits moments de contact entre les rendez-vous.\n\nCe qui fidélise vraiment :\n— La régularité du résultat — une cliente qui sait à quoi s'attendre revient\n— Le sentiment d'être reconnue et suivie — se souvenir de ses préférences, de son histoire de pose\n— La communication honnête, même quand c'est difficile (refus, adaptation, retouche refusée)\n— Un suivi simple après la première prestation"},
      {"type":"section","label":"Suivi après la première prestation"},
      {"type":"text","content":"Envoyer un message simple 48–72h après la première prestation d'une nouvelle cliente — pas pour relancer, mais pour s'assurer que la pose est bien supportée et que la cliente n'a pas de question.\n\nExemple de message de suivi (à adapter) : \"Bonjour [prénom], j'espère que tu te plais avec ta nouvelle pose ! N'hésite pas à me contacter si tu as une question ou si quelque chose te paraît inhabituel dans les premiers jours. À bientôt !\"\n\nCe message signale une posture professionnelle et ouvre un canal de communication. Il réduit aussi les retours par surprise en invitant la cliente à s'exprimer tôt si quelque chose ne va pas."},
      {"type":"text","content":"📄 Fiche F10 — Modèles de messages de suivi client (à personnaliser)"},
      {"type":"section","label":"Communication digitale et portfolio"},
      {"type":"text","content":"Publier son travail sur les réseaux sociaux est un outil de visibilité — pas une obligation. Si tu choisis de le faire, quelques principes :\n— Distinguer accord pour photographier et autorisation de publication : ce sont deux consentements distincts. Photographier pour sa fiche cliente ou son suivi interne ne donne pas le droit de publier l'image. L'autorisation de publication ou d'utilisation à des fins de communication doit être obtenue séparément — à l'oral ou par écrit selon le droit applicable. Ne pas l'intégrer automatiquement à la Fiche F3 sans vérifier la validité de ce regroupement dans ton cadre réglementaire.\n— Ne jamais révéler publiquement des informations issues de la fiche cliente ou de l'historique de prestation — même pour répondre à un avis négatif. La réponse publique reste neutre et factuelle.\n— Publier un travail représentatif — pas seulement les meilleures poses. Un portfolio trop parfait crée des attentes difficiles à tenir pour les nouveaux profils de clientes.\n— Décrire honnêtement — la technique utilisée, la durée estimée, les conditions particulières si la pose était atypique\n— Ne pas promettre des résultats — chaque pose dépend de la plaque naturelle de la cliente, de ses habitudes et du suivi. Le même résultat n'est pas garanti pour toutes"},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Exemples de publications professionnelles","note":"Format Instagram · présentation honnête du travail · mention de la technique — Exemples à créer depuis l'Atelier Nahira"},
      {"type":"text","content":"Cas client — Une cliente laisse un avis négatif en ligne après un retour que tu avais géré en proposant une retouche gratuite. Elle dit que \"la pose a tenu 5 jours\". Comment réagis-tu ?\nUn avis public négatif mérite une réponse publique — courte, calme, professionnelle.\nCe qu'on fait :\n— Répondre sans se défendre ni attaquer : \"Merci pour ton retour. Je suis désolée que l'expérience ne t'ait pas satisfaite. Comme tu le sais, j'avais proposé une retouche dès que tu m'as contactée — cette proposition reste ouverte si tu souhaites qu'on trouve une solution.\"\n— Ne pas rentrer dans le détail des faits en public — si une clarification est nécessaire, la proposer en privé\n— Ne pas supprimer l'avis si la plateforme ne le permet pas — une réponse calme et professionnelle dit souvent plus sur ta qualité qu'un avis positif supplémentaire\nCe qu'on ne fait pas : ignorer, se justifier sur 10 lignes, ou demander à des proches de noyer l'avis négatif sous des avis positifs fictifs."},
      {"type":"warning","content":"Promettre à une nouvelle cliente un résultat identique à une photo de portfolio sans avoir évalué sa plaque naturelle. Le résultat dépend de multiples facteurs individuels. Présenter le portfolio comme une source d'inspiration possible — pas comme une garantie de résultat."},
      {"type":"tip","content":"Créer un système simple de rappel de rendez-vous (message automatique ou rappel manuel 48h avant) : il réduit les no-shows, montre que tu es organisée, et donne à la cliente une occasion de décaler si nécessaire — bien mieux qu'une absence non prévenue."},
      {"type":"info","content":"À retenir :\n— Fidélisation = qualité constante + relation honnête + petits moments de contact\n— Message de suivi après la première prestation — simple, ouvert, professionnel\n— Accord pour photographier ≠ autorisation de publier : deux consentements distincts\n— Ne jamais révéler d'informations de la fiche cliente pour répondre à un avis négatif\n— Portfolio digital : représentation honnête, sans promesse de résultat garanti\n— Avis négatif en ligne : réponse courte et calme, proposition de solution en privé"},
      {"type":"je_maitrise","items":["J'envoie un message de suivi après chaque première prestation","Je distingue accord pour photographier et autorisation de publication, et j'obtiens les deux séparément","Je publie mon travail de façon honnête, sans promettre de résultat garanti","Je sais répondre à un avis négatif en ligne de façon professionnelle, sans révéler d'informations issues de la fiche cliente"]}
    ]$cb$
  );

END;
$m11$;
