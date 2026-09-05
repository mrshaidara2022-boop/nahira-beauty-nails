-- Phase 9: Seed academy_quiz_questions — 41 questions for fiber-signature
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- NEVER modify project tjnldcxidcztwpwhxuuo (HAURANA production)
-- correct_index is 0-based (A=0, B=1, C=2, D=3); NEVER exposed via client RLS.
-- Source: validated pedagogical content from Fiber Signature formation HTML.

DO $seed$
DECLARE
  cid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature' LIMIT 1;
  IF cid IS NULL THEN RAISE EXCEPTION 'Course fiber-signature not found'; END IF;

  IF EXISTS (SELECT 1 FROM academy_quiz_questions WHERE course_id = cid LIMIT 1) THEN
    RAISE NOTICE 'Quiz questions already seeded — skipping';
    RETURN;
  END IF;

  INSERT INTO academy_quiz_questions
    (course_id, question, options, correct_index, explanation, sort_order)
  VALUES

  (cid,
   'Les temps de polymérisation indiqués dans cette formation sont :',
   jsonb_build_array(
     'Valables pour tous les systèmes de gel',
     'À titre indicatif — ils dépendent du système et des instructions fabricant',
     'Fixés à 60 secondes par couche pour la fibre de verre',
     'Définis de façon universelle par la technique Fiber Signature'),
   1,
   'Règle permanente : les instructions du fabricant sont prioritaires sur toute recommandation générale. Les valeurs de la formation sont indicatives. (Module 4)',
   1),

  (cid,
   'Avant d''appliquer une couche de gel, la règle fondamentale est :',
   jsonb_build_array(
     'Laisser exactement 1 mm entre le gel et la cuticule',
     'Appliquer un primer avant chaque couche',
     'S''assurer qu''aucun produit n''entre en contact avec la peau',
     'Polymériser la couche précédente 90 secondes'),
   2,
   'La marge de 0,5–1 mm est une référence pédagogique. Le principe fondamental est l''absence totale de contact entre le produit et la peau. (Module 4)',
   2),

  (cid,
   'Tu observes une tache verdâtre sous une pose. La conduite appropriée est :',
   jsonb_build_array(
     'Identifier une infection bactérienne et conseiller un traitement',
     'Décrire le signe observé, ne pas poser sur cet ongle, orienter vers un professionnel de santé et évaluer l''ensemble des ongles',
     'Nettoyer l''ongle avec de l''alcool et continuer la pose',
     'Poser dessus car la cliente est régulière et le signe est habituel pour elle'),
   1,
   'Observer sans diagnostiquer. Le signe est décrit (coloration), la conduite est professionnelle (report, orientation). L''ensemble des ongles est évalué avant toute décision. (Module 9)',
   3),

  (cid,
   'Peut-on systématiquement réaliser la prestation sur les autres ongles si l''un présente un signe d''alerte ?',
   jsonb_build_array(
     'Oui, si les autres ongles semblent visuellement normaux',
     'Non — l''ensemble de la situation et le risque de contamination croisée doivent être évalués avant toute décision',
     'Oui, la cliente a signé la Fiche F3',
     'Oui, si la cliente le demande expressément'),
   1,
   'Aucune décision automatique. L''évaluation globale et le risque de contamination croisée sont pris en compte avant de poursuivre. (Module 9 & Règle permanente 6)',
   4),

  (cid,
   'La position de l''apex dans une pose fibre de verre est :',
   jsonb_build_array(
     'Toujours au tiers médian vers le bord libre',
     'Toujours au centre géométrique de l''ongle',
     'Variable selon la longueur, la forme, l''architecture de l''ongle et le système utilisé',
     'Définie uniquement par la marque de gel utilisée'),
   2,
   'La zone et le volume de l''apex dépendent de plusieurs facteurs — longueur, forme, architecture, système. Aucune position n''est universellement fixe. (Règle permanente 11)',
   5),

  (cid,
   'Les grains de lime utilisés dans la formation sont présentés comme :',
   jsonb_build_array(
     'Des valeurs universelles applicables à toutes les plaques et tous les matériels',
     'Des valeurs à titre indicatif, à adapter selon le matériel et les recommandations fabricant',
     'Des grains réglementaires imposés par les normes d''hygiène',
     'Des valeurs identiques quelle que soit l''étape de la pose'),
   1,
   'Les grains sont indicatifs et s''adaptent au matériel utilisé et aux instructions fabricant. (Règle permanente 8 — Module 6)',
   6),

  (cid,
   'La Fiche F3 est :',
   jsonb_build_array(
     'Une obligation légale universelle dans tous les pays',
     'Un document d''information et d''accord proposé par Nahira Academy — ses effets varient selon le cadre réglementaire applicable',
     'Un certificat médical requis avant toute pose',
     'Un document qui supprime la responsabilité professionnelle de la prestataire'),
   1,
   'La Fiche F3 est un outil de la démarche Nahira Academy, non une obligation légale universelle. Elle ne supprime pas les obligations professionnelles de la prestataire. (Règle permanente 13 — Module 10)',
   7),

  (cid,
   'Faire tremper les cuticules dans l''eau avant une pose en gel :',
   jsonb_build_array(
     'Est recommandé pour assouplir les cuticules et faciliter la préparation',
     'Le trempage à l''eau n''est pas retenu comme protocole standard avant la pose — la plaque doit être correctement préparée et sèche selon le système utilisé et les instructions fabricant',
     'Est obligatoire pour préparer la plaque correctement',
     'Est recommandé uniquement pour les clientes ayant des cuticules très sèches'),
   1,
   'Le trempage à l''eau n''est pas un protocole standard avant la pose en gel. La plaque doit être préparée et sèche conformément au système utilisé et aux instructions fabricant. (Règle permanente 7)',
   8),

  (cid,
   'La base tarifaire calculée avec la méthode de la formation est :',
   jsonb_build_array(
     'Le tarif minimum universel sous lequel on travaille toujours à perte',
     'Une base indicative de calcul — cotisations, taxes et prélèvements applicables restent à intégrer séparément selon le statut',
     'Le tarif définitif à appliquer pour toutes les prestations',
     'Identique pour toutes les professionnelles à niveau de compétence égal'),
   1,
   'La méthode donne une base pédagogique. Cotisations sociales, fiscalité, taxes et commissions sont à intégrer séparément selon le statut et le pays. (Module 10)',
   9),

  (cid,
   'Les instructions du fabricant sont-elles prioritaires sur les recommandations générales de la formation ?',
   jsonb_build_array(
     'Non — la formation Fiber Signature prévaut sur tout autre protocole',
     'Oui — notamment pour les temps de polymérisation, les compatibilités et les protocoles d''application',
     'Cela dépend de la marque et de l''année du produit',
     'Non — les instructions fabricant sont indicatives comme celles de la formation'),
   1,
   'Règle permanente fondamentale : les instructions du fabricant sont prioritaires sur toute recommandation générale. (Règle permanente 3)',
   10),

  (cid,
   'Lors de la consultation initiale, comment formuler la question sur les médicaments ou traitements ?',
   jsonb_build_array(
     '"Prenez-vous des médicaments photosensibilisants ?"',
     '"Avez-vous des traitements en cours ?" et analyser la réponse pour identifier les risques',
     '"Y a-t-il une recommandation médicale ou une information de votre médecin sur les soins esthétiques de vos ongles que vous souhaitez me communiquer ?"',
     'Ne pas aborder le sujet médical lors de la consultation'),
   2,
   'La prestataire ne doit pas interpréter des traitements médicaux. La question ouverte invite la cliente à communiquer une recommandation de son médecin. (Module 11)',
   11),

  (cid,
   'Un retour négatif d''une cliente après une pose doit être traité :',
   jsonb_build_array(
     'Comme une erreur nécessairement imputable à la prestataire',
     'Comme une faute de la cliente liée à ses habitudes',
     'En distinguant les éléments pouvant être liés à la prestation, les facteurs extérieurs déclarés, et l''origine indéterminée ou multifactorielle',
     'Par une retouche gratuite systématique pour éviter le conflit'),
   2,
   'Trois catégories à distinguer : lié à la prestation / extérieur déclaré ou observable / origine indéterminée. Aucune attribution automatique de cause. (Module 11)',
   12),

  (cid,
   'La formule d''annonce d''un refus de prestation se fait en :',
   jsonb_build_array(
     '1 temps : annoncer le refus directement et sans détail',
     '3 temps : décrire ce qu''on observe · expliquer la décision · proposer la suite',
     '2 temps : annoncer le refus et s''excuser',
     '4 temps : observer · nommer le signe · décider · orienter'),
   1,
   'La formule en 3 temps permet d''annoncer calmement, sans alarmer ni minimiser, et de proposer une suite concrète. (Module 11)',
   13),

  (cid,
   'La "majoration de sécurité" dans le calcul de tarif couvre :',
   jsonb_build_array(
     'Les cotisations sociales, la fiscalité et les taxes éventuelles',
     'Les imprévus, le renouvellement matériel, la formation continue et la variation d''activité',
     'L''ensemble des prélèvements obligatoires liés à l''activité',
     'Le bénéfice net de l''activité'),
   1,
   'Les cotisations, taxes et commissions sont à intégrer séparément selon le statut et le pays — elles ne font pas partie de la majoration de sécurité. (Module 10)',
   14),

  (cid,
   'Quand une retouche est-elle une obligation professionnelle plutôt qu''un geste commercial ?',
   jsonb_build_array(
     'À chaque retour d''une cliente dans les 15 jours suivant la pose',
     'Lorsqu''un défaut clairement imputable à la prestation est établi',
     'Dès que la cliente exprime une insatisfaction',
     'Après chaque première pose, indépendamment du résultat'),
   1,
   'Corriger un défaut établi côté prestation est une obligation — pas un geste commercial. Le geste commercial s''applique lorsque l''origine est incertaine. (Module 11)',
   15),

  (cid,
   'Le top coat et la couche de scellement :',
   jsonb_build_array(
     'Sont toujours interchangeables dans tous les systèmes',
     'Ont toujours des rôles strictement différents selon une règle universelle',
     'Ont des rôles qui dépendent du système utilisé — consulter les instructions fabricant',
     'Servent uniquement à la finition esthétique, sans rôle structurel'),
   2,
   'Leur rôle (construction, finition, protection) varie selon le système. Les instructions fabricant précisent lequel utiliser à quelle étape. (Règle permanente 14)',
   16),

  (cid,
   'Face à un avis négatif en ligne, la conduite professionnelle est de :',
   jsonb_build_array(
     'Répondre en détaillant les raisons médicales du refus de prestation effectué',
     'Répondre brièvement et calmement, sans révéler d''informations issues de la fiche cliente, et proposer une solution en privé',
     'Ignorer l''avis pour ne pas lui donner de visibilité',
     'Demander à des proches de publier des avis positifs pour compenser'),
   1,
   'La confidentialité des données de la fiche cliente s''applique aussi en ligne. La réponse est calme, factuelle, sans détail personnel. (Module 11)',
   17),

  (cid,
   'L''accord de la cliente pour photographier une pose et l''autorisation de publier l''image sont :',
   jsonb_build_array(
     'Identiques — l''un inclut automatiquement l''autre',
     'Deux consentements distincts à obtenir séparément selon le droit applicable',
     'Couverts dans tous les cas par la signature de la Fiche F3',
     'Non nécessaires si la cliente est satisfaite du résultat'),
   1,
   'Photographier pour la fiche cliente ne donne pas le droit de publier. Ces deux consentements sont distincts et doivent être obtenus séparément. (Module 11)',
   18),

  (cid,
   'Le "chiffre d''affaires horaire moyen" (CA ÷ heures travaillées) :',
   jsonb_build_array(
     'Est équivalent au revenu net horaire de la prestataire',
     'Mesure le CA généré par heure — les charges, cotisations et taxes restent à déduire pour obtenir un revenu net',
     'Suffit seul à évaluer la rentabilité de l''activité',
     'Est le bénéfice avant impôts'),
   1,
   'Ce ratio mesure le CA horaire moyen — il ne reflète pas le revenu net. Les charges et prélèvements applicables restent à déduire. (Module 10)',
   19),

  (cid,
   'Un consommable (compresse, applicateur) utilisé sur un ongle peut-il servir sur un autre ?',
   jsonb_build_array(
     'Oui, s''il est désinfecté à l''alcool entre les deux',
     'Non pour les consommables à usage unique — principe de prévention de la contamination croisée',
     'Oui si la cliente est régulière et ne présente pas de signe d''alerte',
     'Oui si la prestation se déroule sans incident'),
   1,
   'La prévention de la contamination croisée impose l''usage unique pour les consommables concernés. (Module 3 — Règle permanente 10)',
   20),

  (cid,
   'La durée d''une prestation en pose fibre de verre est :',
   jsonb_build_array(
     'Toujours comprise entre 1h30 et 2h30',
     'Variable selon le type de pose, l''état de la pose existante et le niveau de la professionnelle',
     'Fixée à 2h pour un rééquilibrage, quelle que soit la situation',
     'La même pour toutes les professionnelles certifiées Fiber Signature'),
   1,
   'La durée varie selon plusieurs facteurs. Chronométrer ses propres prestations est la méthode pour ajuster le planning. (Module 10 & 11)',
   21),

  (cid,
   'La consultation initiale sert principalement à :',
   jsonb_build_array(
     'Choisir la couleur et la forme de la pose le plus vite possible',
     'Recueillir les informations nécessaires, identifier les points de vigilance, définir l''objectif esthétique et établir la confiance',
     'Remplir la Fiche F3 en moins de 5 minutes avant de commencer',
     'Convaincre la cliente de choisir la prestation la plus complète'),
   1,
   'La consultation est un moment structurant : elle oriente toutes les décisions techniques qui suivent. (Module 11)',
   22),

  (cid,
   'La marge de 0,5 à 1 mm entre le gel et la peau est présentée comme :',
   jsonb_build_array(
     'Une garantie absolue d''adhérence et de tenue de la pose',
     'Une référence pédagogique — le principe fondamental reste l''absence totale de contact produit/peau',
     'La distance réglementaire imposée par les normes d''hygiène',
     'Une marge universelle valable pour tous les systèmes de gel'),
   1,
   'La marge est une référence pédagogique. L''absence de contact entre le produit et la peau est le principe fondamental, indépendamment de la distance. (Règle permanente 9)',
   23),

  (cid,
   'Face à une cliente qui minimise un signe d''alerte ("j''ai toujours eu ça"), on :',
   jsonb_build_array(
     'Accepte sa perception et réalise la prestation pour ne pas la décevoir',
     'Maintient sa décision professionnelle — la cliente informe de sa perception, mais l''évaluation reste la responsabilité de la prestataire',
     'Consulte une autre professionnelle présente pour se rassurer',
     'Documente le refus de la cliente et réalise la prestation sous sa propre responsabilité'),
   1,
   'L''information de la cliente est utile mais ne se substitue pas à l''évaluation technique. La décision professionnelle reste celle de la prestataire. (Module 11)',
   24),

  (cid,
   'Le traitement de la couche inhibée après polymérisation dépend :',
   jsonb_build_array(
     'Toujours d''un essuyage avec un gel cleanser avant toute couche suivante',
     'Toujours de la laisser telle quelle car elle favorise l''adhérence',
     'Du système utilisé — consulter les instructions fabricant pour savoir comment la traiter',
     'De la marque de lampe utilisée pour la polymérisation'),
   2,
   'Le traitement de la couche inhibée varie selon le système. Les instructions fabricant indiquent si elle doit être essuyée ou non avant la couche suivante. (Module 4)',
   25),

  (cid,
   'Une politique de retouche écrite et communiquée à l''avance :',
   jsonb_build_array(
     'Garantit que la cliente ne pourra jamais réclamer de retouche gratuite',
     'Écarte automatiquement la responsabilité de la prestataire pour tout soulèvement',
     'Réduit les situations ambiguës en établissant à l''avance ce qui est couvert',
     'Est une obligation légale dans tous les pays pour les prestations esthétiques'),
   2,
   'La politique de retouche réduit les ambiguïtés — elle ne supprime pas les obligations en cas de défaut de pose établi. (Module 11)',
   26),

  (cid,
   'Le principe de minimisation des données personnelles signifie :',
   jsonb_build_array(
     'Ne jamais collecter d''informations sur les clientes',
     'Ne collecter que les informations strictement nécessaires à la compatibilité avec la technique et au suivi de la prestation',
     'Réduire la durée de la fiche cliente à une seule page',
     'Ne pas enregistrer les observations négatives sur la plaque naturelle'),
   1,
   'Minimiser les données réduit les risques liés à leur conservation et facilite la gestion conforme. Cela n''empêche pas de documenter les observations utiles. (Module 10)',
   27),

  (cid,
   'Lors d''un retour lié à un soulèvement, les questions posées à la cliente doivent :',
   jsonb_build_array(
     'Suggérer des causes possibles pour guider sa réponse',
     'Être ouvertes et ne pas orienter la réponse de la cliente',
     'Confirmer que la cause est extérieure à la prestation',
     'Être posées après avoir établi la cause par l''observation seule'),
   1,
   'Les questions ouvertes permettent à la cliente de répondre librement, sans orienter sa réponse vers une cause présupposée. (Module 11)',
   28),

  (cid,
   'Documenter les observations et décisions sur la fiche cliente après chaque prestation :',
   jsonb_build_array(
     'N''est utile qu''en cas de litige ou de réclamation ultérieure',
     'Protège automatiquement la prestataire contre toute réclamation',
     'Permet le suivi technique et la traçabilité professionnelle à chaque visite',
     'Est uniquement une obligation administrative sans valeur professionnelle'),
   2,
   'La documentation régulière assure la traçabilité professionnelle et permet d''adapter les décisions à l''historique de la cliente — au-delà du seul cas de litige. (Module 10)',
   29),

  (cid,
   'Le délai entre une pose et un retour cliente :',
   jsonb_build_array(
     'Détermine automatiquement si la prestataire est responsable ou non',
     'Écarte automatiquement la responsabilité de la prestataire si le délai est long',
     'Est un élément d''évaluation parmi d''autres — il ne détermine pas seul la cause du problème',
     'Prouve que la pose était de mauvaise qualité si le retour survient rapidement'),
   2,
   'Le délai est un élément d''évaluation, pas une preuve de cause. L''analyse honnête prend en compte l''ensemble du tableau. (Module 11)',
   30),

  (cid,
   'Les obligations d''affichage des tarifs :',
   jsonb_build_array(
     'Sont identiques dans tous les pays et pour tous les statuts',
     'Imposent toujours d''afficher un tarif fixe et unique sans fourchette possible',
     'Varient selon le statut, le lieu d''exercice et la réglementation applicable — à vérifier selon sa situation',
     'Ne s''appliquent qu''aux salons de beauté disposant d''une enseigne commerciale'),
   2,
   'Les obligations varient selon le statut et le pays. La bonne pratique est de communiquer le prix clairement avant tout engagement. (Module 10)',
   31),

  (cid,
   'Pour une prestation sur une plaque présentant des particularités observées, la conduite est :',
   jsonb_build_array(
     'Refuser systématiquement toute pose sur cette plaque',
     'Évaluer la compatibilité avec la technique, adapter le protocole si possible, ou reporter si nécessaire',
     'Réaliser la pose standard en informant la cliente des risques par écrit',
     'Appliquer une couche de primer supplémentaire pour compenser'),
   1,
   'L''évaluation de la compatibilité précède la décision. Selon l''état de la plaque, la prestation peut être adaptée, reportée ou refusée. (Module 9)',
   32),

  (cid,
   '"Renforcement sans allongement" est une prestation :',
   jsonb_build_array(
     'Identique à une première pose en termes de protocole',
     'Adaptée à l''état de la plaque et à la compatibilité avec la technique choisie — à distinguer de la première pose',
     'Réservée aux clientes ayant des ongles médicalement fragiles',
     'Toujours réalisable sur toutes les plaques sans adaptation particulière'),
   1,
   'Cette prestation est définie par l''état observé de la plaque et la compatibilité avec la technique — pas par un critère médical. (Module 10)',
   33),

  (cid,
   'Un gel rubber base et un primer :',
   jsonb_build_array(
     'Ont le même rôle et sont interchangeables dans tous les systèmes',
     'Sont deux noms commerciaux différents pour le même produit',
     'Ont des rôles et des protocoles d''application distincts qui varient selon les systèmes — suivre les instructions fabricant',
     'Servent uniquement à préparer la plaque naturelle avant le gel de construction'),
   2,
   'Leurs rôles, compatibilités et protocoles varient selon les systèmes. Les instructions fabricant sont la référence. (Module 2)',
   34),

  (cid,
   'Lors d''une réclamation, la première étape du protocole est :',
   jsonb_build_array(
     'Observer l''ongle pour identifier la cause avant toute conversation',
     'Expliquer à la cliente ce qui s''est probablement passé',
     'Écouter sans interrompre — laisser la cliente s''exprimer complètement avant de répondre',
     'Proposer une retouche immédiate pour désamorcer le conflit'),
   2,
   'Écouter d''abord — avant d''observer, analyser ou proposer. La cliente doit pouvoir s''exprimer complètement. (Module 11)',
   35),

  (cid,
   'L''accord de la cliente (Fiche F3 ou accord verbal) :',
   jsonb_build_array(
     'Supprime les obligations professionnelles de la prestataire',
     'Autorise à réaliser une prestation qui présente un signe d''alerte si la cliente accepte le risque',
     'Ne supprime pas les obligations professionnelles — la décision technique reste la responsabilité de la prestataire',
     'Remplace l''évaluation clinique préalable à la pose'),
   2,
   'L''accord de la cliente n''est pas un blanc-seing. La décision de réaliser ou non la prestation reste celle de la prestataire, indépendamment de l''accord signé. (Module 10)',
   36),

  (cid,
   'La construction de l''apex dans une pose fibre de verre :',
   jsonb_build_array(
     'Suit la règle universelle : plus d''apex = plus de résistance',
     'Doit être proportionnelle à la longueur de l''ongle, à son architecture et au système utilisé',
     'Est fixée à un volume standard quelle que soit la longueur',
     'Ne joue aucun rôle dans la durabilité de la pose'),
   1,
   'L''architecture de l''apex doit être proportionnelle à la situation — un apex excessif peut fragiliser plutôt que renforcer. (Règle permanente 12)',
   37),

  (cid,
   'Le placement de la fibre de verre pendant la pose dépend :',
   jsonb_build_array(
     'D''une règle universelle fixée par la formation Fiber Signature',
     'Uniquement de la longueur d''ongle souhaitée',
     'Du système utilisé et des instructions fabricant — le protocole exact varie',
     'De la préférence de chaque professionnelle sans contrainte particulière'),
   2,
   'La couche sur laquelle la fibre est posée, son imprégnation et sa découpe dépendent du système utilisé. (Règle permanente 2)',
   38),

  (cid,
   'La fidélisation d''une clientèle stable repose principalement sur :',
   jsonb_build_array(
     'Des remises régulières et des programmes de fidélité commerciaux',
     'La qualité constante de la prestation, la clarté de la relation et le soin apporté aux moments de contact',
     'Une présence quotidienne sur les réseaux sociaux',
     'L''offre du tarif le plus compétitif de la zone'),
   1,
   'La relation régulière, honnête et de qualité constante est ce qui stabilise une clientèle — au-delà des outils marketing. (Module 11)',
   39),

  (cid,
   'Lors d''une observation en cours de prestation, la formulation correcte est :',
   jsonb_build_array(
     '"Tu as une infection sur cet ongle."',
     '"Je vois ce qui ressemble à quelque chose de grave."',
     '"J''observe un décollement localisé et une modification de couleur sur cet ongle — je préfère m''arrêter ici."',
     '"Ton ongle est abîmé — tu as dû le traumatiser."'),
   2,
   'Décrire uniquement ce qui est visible, sans nommer ni interpréter. La formulation est calme et descriptive. (Règle permanente 4 & 5)',
   40),

  (cid,
   'La conversion de l''objectif de rémunération mensuelle en taux horaire dépend :',
   jsonb_build_array(
     'D''une formule universelle valable pour tous les statuts',
     'Du statut juridique, du régime fiscal et des cotisations applicables — à adapter selon sa situation',
     'Uniquement du nombre d''heures travaillées par semaine',
     'Du tarif moyen du marché local'),
   1,
   'La conversion net/brut ou la prise en compte des cotisations varie selon le statut et le pays — un accompagnement comptable est recommandé pour l''intégrer correctement. (Module 10)',
   41);

  RAISE NOTICE 'Seeded 41 quiz questions for fiber-signature.';
END;
$seed$;
