-- ══════════════════════════════════════════════════════════════════
-- Fiber Signature — Seed M8 : Finitions & nail art sur fibre
-- ══════════════════════════════════════════════════════════════════
DO $seed$
DECLARE
  cid UUID;
  mid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature' LIMIT 1;

  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Finitions & nail art sur fibre', 8)
  RETURNING id INTO mid;

  -- M8.L1 — Limage de finition & forme définitive (18 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Limage de finition & forme définitive',
    0, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Le limage de finition est l'étape qui donne à la pose sa forme finale et homogène. Elle intervient après polymérisation complète et nettoyage de l'inhibition. C'est une étape distincte du limage de préparation : elle travaille la surface, les côtés et le bord libre — jamais la zone de contact avec la plaque naturelle.\n\nTrois zones à travailler :\n— La surface : homogénéisation, gommage des aspérités, affinage de l'apex si nécessaire\n— Les côtés (side walls) : alignement, effacement des bords fins ou décentrés\n— Le bord libre : épaisseur homogène, forme nette, angle C correct\n\nGrains indicatifs : un grain médium (à titre indicatif : 150–180) pour la mise en forme structurelle, un grain fin (à titre indicatif : 220–240) pour le lissage de surface. Finir au bloc polissant selon le rendu souhaité. Ces valeurs varient selon le matériel utilisé — adapte toujours à ton outillage."},
      {"type":"section","label":"Les formes"},
      {"type":"table","headers":["Forme","Description","Compatibilité fibre"],"rows":[
        ["Ovale","Bords arrondis, bord libre ovalisé — forme universelle","✓ Idéale"],
        ["Amande / Almond","Côtés effilés, pointe douce — allonge la main","✓ Bien adaptée"],
        ["Carrée / Square","Bord libre droit, coins nets","✓ Bien adaptée"],
        ["Squoval","Intermédiaire carré-ovale, coins légèrement arrondis","✓ Idéale"],
        ["Ballerine / Coffin","Côtés effilés, bord libre plat et large","△ Longueur modérée conseillée"],
        ["Stiletto","Très effilée, pointe fine","△ Fragilité en pointe — à évaluer selon la plaque"]
      ]},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Vidéo — Limage de finition","note":"Close-up mains/ongles · Séquence : surface → côtés → bord libre → vérification C-curve — à créer depuis l'Atelier Nahira"},
      {"type":"section","label":"Faire"},
      {"type":"step","number":1,"title":"Choisir une forme cible avant de commencer","content":"Décision esthétique, pas en cours de limage."},
      {"type":"step","number":2,"title":"Limer la surface avec un grain médium","content":"À titre indicatif : 150–180 — mouvements lents, réguliers, en X ou en arc de cercle — jamais en va-et-vient rapide."},
      {"type":"step","number":3,"title":"Travailler les côtés","content":"Angle de la lime à 45° par rapport à la plaque — vérifier la symétrie gauche/droite à chaque ongle."},
      {"type":"step","number":4,"title":"Affiner le bord libre","content":"Vérifier l'épaisseur en lumière naturelle ou avec une lampe latérale."},
      {"type":"step","number":5,"title":"Contrôler la courbe en C à hauteur des yeux","content":"Elle doit être symétrique et régulière."},
      {"type":"step","number":6,"title":"Passer à un grain fin pour lisser la surface","content":"À titre indicatif : 220–240 — lisser sans recréer d'aspérités."},
      {"type":"step","number":7,"title":"Souffler et dépoussiérer avant de passer à l'étape surface","content":""},
      {"type":"warning","content":"Limer trop près de la zone de contact avec la plaque naturelle : risque d'amincissement de la pose et d'irritation du lit. La lime ne doit jamais toucher la peau péri-unguéale en cours de limage."},
      {"type":"tip","content":"Photographier la forme obtenue de face et de profil avant de finaliser : la photo révèle des asymétries invisibles à l'œil nu en situation de travail."},
      {"type":"info","content":"À retenir :\n— Limage de finition = surface + côtés + bord libre, jamais la zone cuticules\n— La forme se décide avant le limage, pas pendant\n— Vérification de la courbe en C à hauteur des yeux\n— Grain croissant (à titre indicatif) : médium (ex. 150–180) → fin (ex. 220–240) → bloc polissant"},
      {"type":"je_maitrise","items":["Je peux obtenir une forme homogène et symétrique sur les 10 ongles","Je connais les grains adaptés à chaque phase du limage de finition","Je sais identifier une courbe en C correcte à l'œil"]}
    ]$cb$
  );

  -- M8.L2 — Surface & brillance (19 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Surface & brillance — mat, satiné, brillant',
    1, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Après limage et mise en forme, la surface de la fibre peut recevoir trois types de finition selon le souhait esthétique de la cliente :\n— Brillant classique : top coat brillant, polymérisation selon instructions fabricant\n— Satiné : top coat satiné ou mat légèrement poli\n— Mat : top coat mat (non poli) ou bloc polissant mat uniquement sans top coat\n\nLe top coat remplit également un rôle de protection de la surface et de scellage du nail art. Son épaisseur et sa formulation influencent la tenue et l'esthétique finale."},
      {"type":"section","label":"Le polish de finition"},
      {"type":"text","content":"Surface avant top coat : la surface doit être propre, dégraissée et exempte de poussières. Appliquer le top coat en couche fine et homogène — déborder légèrement sur le bord libre pour sceller.\n\nPolymérisation : suivre les instructions du fabricant (temps, puissance). Un top coat sous-polymérisé reste collant ou se ternit rapidement. Un top coat sur-polymérisé peut jaunir ou se craqueler sur certaines formulations.\n\nNote fabricant : temps et puissance de polymérisation variables selon le top coat. Toujours vérifier la fiche technique du produit utilisé. Ne pas extrapoler d'un produit à l'autre."},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo comparatif — rendu mat / satiné / brillant sur fibre de verre","note":"Photo à créer depuis l'Atelier Nahira"},
      {"type":"placeholder","label":"Vidéo — Application top coat","note":"Close-up · couche fine, scellage bord libre, entrée en lampe — à créer depuis l'Atelier Nahira"},
      {"type":"section","label":"Faire"},
      {"type":"step","number":1,"title":"Dépoussiérer et dégraisser soigneusement la surface","content":"Lint-free pad + dégraissant."},
      {"type":"step","number":2,"title":"Vérifier l'absence de résidus de limage dans les replis latéraux","content":""},
      {"type":"step","number":3,"title":"Appliquer le top coat en couche fine","content":"Pinceau à plat, pression légère, un passage."},
      {"type":"step","number":4,"title":"Sceller le bord libre","content":"Passer le pinceau sur la tranche."},
      {"type":"step","number":5,"title":"Polymériser selon les instructions du fabricant","content":""},
      {"type":"step","number":6,"title":"Pour finition mat sans top coat","content":"Bloc polissant uniquement — surface homogène, sans couture."},
      {"type":"text","content":"Cas client — Top coat qui se ternit en 48h :\nSituation : la cliente revient 2 jours après la pose, le top coat est terne et se raye facilement.\nAnalyse : polymérisation incomplète (vérifier le temps et la puissance de la lampe) ; surface mal dégraissée avant application ; top coat trop épais ou en double couche non prévue ; exposition prématurée à l'eau ou aux produits nettoyants (< 4h).\nAction : identifier la cause, retouche top coat si la structure est intacte — pas de dépose complète si la pose est saine."},
      {"type":"warning","content":"Appliquer le top coat sans dégraisser : l'inhibition résiduelle ou les huiles de la peau compromettent l'adhérence et la tenue du top coat, même sur une surface visuellement propre."},
      {"type":"tip","content":"Proposer systématiquement le choix brillant/mat en début de prestation — cela évite de devoir refaire le top coat si la cliente change d'avis après polymérisation. Le noter sur la fiche cliente."},
      {"type":"info","content":"À retenir :\n— Dégraisser avant top coat — sans exception\n— Sceller le bord libre pour augmenter la tenue\n— Respecter les instructions fabricant pour la polymérisation\n— Mat sans top coat = bloc polissant mat, surface homogène"},
      {"type":"je_maitrise","items":["Je sais obtenir les trois types de finition (brillant, satiné, mat) avec un résultat homogène","Je comprends pourquoi le dégraissage est indispensable avant top coat","Je peux expliquer à la cliente ce qu'elle doit éviter dans les premières heures"]}
    ]$cb$
  );

  -- M8.L3 — Nail art sur fibre — compatibilités & contraintes (10 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Nail art sur fibre — compatibilités & contraintes',
    2, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La fibre de verre accepte le nail art, mais avec des contraintes liées à sa structure fine. L'objectif est d'intégrer le nail art dans la pose (sous top coat) pour garantir la durabilité, plutôt qu'au-dessus d'un top coat déjà polymérisé.\n\nPrincipe général : appliquer le nail art sur la surface de fibre polymérisée et dégraissée, avant le top coat. Le top coat scelle et protège l'ensemble."},
      {"type":"section","label":"Tableau de compatibilité"},
      {"type":"table","headers":["Technique","Compatibilité fibre","Conditions d'application"],"rows":[
        ["Vernis gel coloré","✓ Compatible","Sur fibre dégraissée, avant top coat · polymériser selon fabricant"],
        ["Poudres chrome / effet miroir","✓ Compatible","Sur couche de finition non polymérisée (couche d'inhibition) · sceller avec top coat"],
        ["Stamping","✓ Compatible","Vernis de stamping sur surface propre · protéger au top coat"],
        ["Foils / feuilles métalliques","✓ Compatible","Sur gel non polymérisé ou colle spéciale foils · sceller impérativement"],
        ["Paillettes / glitter","✓ Compatible","Intégrées avant top coat · ne pas poser en excès (relief = inconfort)"],
        ["Nail stickers autocollants","△ Conditionnelle","Durabilité limitée sous top coat · informer la cliente"],
        ["Pierres / reliefs 3D","△ Conditionnelle","Adhésion au gel UV ou résine · durabilité variable selon position et taille"],
        ["Peinture acrylique nail art","✓ Compatible","Séchage complet avant top coat · veiller à la compatibilité du top coat"]
      ]},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo — Exemples de nail art sur fibre","note":"Chrome, stamping, foils, glitter — rendu final et tenue — à créer depuis l'Atelier Nahira"},
      {"type":"warning","content":"Appliquer la poudre chrome sur une surface déjà entièrement polymérisée et scellée : la poudre n'adhère pas. Le chrome s'applique impérativement sur la couche d'inhibition d'un gel non polymérisé (base mate ou top coat non blanchi), puis on scelle avec le top coat final."},
      {"type":"tip","content":"Tester chaque association (produit de nail art + top coat) sur un patron ou un tips avant de proposer sur cliente : certains top coats réagissent mal avec des peintures acryliques ou des poudres spécifiques. La compatibilité ne se suppose pas."},
      {"type":"info","content":"À retenir :\n— Nail art = sous le top coat pour maximiser la durabilité\n— Chrome = sur couche d'inhibition d'un gel non polymérisé\n— Tester l'association produit + top coat avant pose sur cliente\n— Informer la cliente sur la durabilité attendue selon la technique choisie"},
      {"type":"je_maitrise","items":["Je peux citer les techniques compatibles et leurs conditions d'application sur fibre","Je sais où appliquer la poudre chrome dans la séquence de pose","Je comprends pourquoi tester avant pose sur cliente"]}
    ]$cb$
  );

  -- M8.L4 — Protocole nail art intégré — chrome, foils & stamping (33 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Protocole nail art intégré — chrome, foils & stamping',
    3, 12,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Cette leçon détaille les protocoles des trois techniques les plus fréquemment associées à la fibre de verre en prestation professionnelle : la poudre chrome, les foils et le stamping. Chaque technique a son moment précis dans la séquence de pose."},
      {"type":"section","label":"Poudre chrome (effet miroir)"},
      {"type":"step","number":1,"title":"Poser la fibre et polymériser complètement","content":"Top coat ou base de finition."},
      {"type":"step","number":2,"title":"Ne pas essuyer l'inhibition","content":"C'est sur cette couche que la poudre adhère."},
      {"type":"step","number":3,"title":"Appliquer la poudre chrome","content":"Avec un doigt en silicone ou applicateur spécifique — mouvements circulaires fermes."},
      {"type":"step","number":4,"title":"Brosser l'excédent de poudre","content":"Avec un pinceau souple."},
      {"type":"step","number":5,"title":"Polymériser à nouveau si la formulation le demande","content":"Vérifier avec les instructions du fabricant."},
      {"type":"step","number":6,"title":"Appliquer le top coat","content":"Sans alcool pour préserver le rendu — couche fine et régulière."},
      {"type":"step","number":7,"title":"Polymériser et sceller le bord libre","content":"Selon instructions fabricant."},
      {"type":"info","content":"Note fabricant : certains top coats contenant de l'alcool ternissent la poudre chrome. Utiliser un top coat sans alcool ou formulé no-wipe si la brillance est l'objectif. Vérifier la fiche technique du produit."},
      {"type":"section","label":"Foils (feuilles métalliques)"},
      {"type":"step","number":1,"title":"Appliquer une fine couche de colle à foils","content":"Sur la fibre polymérisée et dégraissée — ou gel non polymérisé en couche fine."},
      {"type":"step","number":2,"title":"Laisser sécher la colle jusqu'à l'état légèrement collant","content":"Ne plus coller au toucher mais encore adhésive (dry-but-tacky)."},
      {"type":"step","number":3,"title":"Poser le foil côté film vers le haut","content":"Appuyer fermement avec un coton ou applicateur."},
      {"type":"step","number":4,"title":"Retirer le film d'un mouvement rapide et sec","content":""},
      {"type":"step","number":5,"title":"Répéter si nécessaire pour couvrir les zones souhaitées","content":""},
      {"type":"step","number":6,"title":"Appliquer le top coat délicatement et polymériser","content":"Ne pas frotter le pinceau."},
      {"type":"section","label":"Stamping"},
      {"type":"step","number":1,"title":"Étaler le vernis de stamping sur la plaque","content":"Sur la fibre polymérisée, dégraissée et idéalement colorée (base visible)."},
      {"type":"step","number":2,"title":"Racler l'excédent avec le racloir","content":"Couche fine et nette."},
      {"type":"step","number":3,"title":"Ramasser le motif avec le tampon","content":"Geste rapide et ferme."},
      {"type":"step","number":4,"title":"Appliquer sur l'ongle en un seul mouvement","content":"Ne pas appuyer ni faire glisser."},
      {"type":"step","number":5,"title":"Laisser sécher quelques secondes","content":""},
      {"type":"step","number":6,"title":"Appliquer le top coat en couche fine","content":"Ne pas frotter pour ne pas déplacer le motif."},
      {"type":"step","number":7,"title":"Polymériser selon instructions fabricant","content":""},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Vidéo — Poudre chrome sur fibre","note":"Séquence complète close-up · application, brossage, top coat — à créer depuis l'Atelier Nahira"},
      {"type":"placeholder","label":"Photos — Résultats foils & stamping sur fibre","note":"À créer depuis l'Atelier Nahira"},
      {"type":"warning","content":"Frotter le pinceau du top coat sur la poudre chrome ou le motif de stamping : le motif se déplace ou la poudre s'étale de manière irrégulière. Appliquer le top coat à plat, pression nulle, un seul passage."},
      {"type":"tip","content":"Pour le stamping, travailler rapidement : le vernis de stamping sèche vite. S'entraîner sur tips avant de proposer sur cliente, jusqu'à maîtriser le geste de raclage et de transfert en moins de 15 secondes."},
      {"type":"info","content":"À retenir :\n— Chrome : sur inhibition, top coat sans alcool pour préserver le rendu\n— Foils : colle légèrement sèche (dry-but-tacky) pour une meilleure adhérence\n— Stamping : geste rapide, top coat sans frotter le motif\n— Toujours sceller le bord libre pour la durabilité du nail art"},
      {"type":"je_maitrise","items":["Je peux appliquer une poudre chrome sans créer de zones ternes ou irrégulières","Je connais le bon moment d'appliquer colle à foils et de transférer le foil","Je sais exécuter un stamping propre et le sceller sans déplacer le motif"]}
    ]$cb$
  );

  -- M8.L5 — Durabilité du nail art — protection & conseils cliente (10 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Durabilité du nail art — protection & conseils cliente',
    4, 8,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La durabilité du nail art dépend de quatre facteurs : la technique utilisée, la qualité du scellage, les habitudes de la cliente, et le type de top coat choisi. Informer la cliente sur ces facteurs, c'est gérer ses attentes et éviter les retours négatifs.\n\nDurabilité estimative par technique (à adapter selon protocole et habitudes de la cliente) :\n— Poudre chrome bien scellée : 2–4 semaines selon le top coat et l'exposition quotidienne\n— Foils : 2–3 semaines en conditions normales\n— Stamping : 2–4 semaines selon l'épaisseur du vernis de stamping et du top coat\n— Paillettes intégrées : durée de vie similaire à la pose\n— Pierres/reliefs : durabilité variable — risque de perte accru avec le quotidien (vaisselle, sacs, claviers)"},
      {"type":"section","label":"Conseils à transmettre à la cliente"},
      {"type":"text","content":"— Éviter les produits nettoyants abrasifs, les solvants (alcool, acétone sur le top coat) — utiliser des gants pour les tâches ménagères\n— Ne pas gratter ou arracher quoi que ce soit sur la surface — signaler tout soulèvement à la prochaine visite\n— Pour le chrome : éviter les huiles et crèmes mains directement sur les ongles (ternissement progressif)\n— Signaler toute perte de pierre ou de foil — une retouche ponctuelle est possible selon l'état de la pose\n\nFiche F5 — Conseils cliente finitions & nail art (téléchargeable · format à remettre en fin de prestation)"},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo — Avant/après durée de port (2 semaines)","note":"Différentes techniques de nail art, état de conservation — à créer depuis l'Atelier Nahira"},
      {"type":"text","content":"Cas client — Perte de pierre après 3 jours :\nSituation : la cliente signale avoir perdu une pierre rhinestone 3 jours après la pose.\nQuestions à poser : quelle activité a précédé la perte ? La pierre a-t-elle été posée avec gel UV polymérisé ou colle uniquement ? Le top coat a-t-il bien été appliqué tout autour de la base de la pierre ?\nAction : retouche ponctuelle si la pose est saine — reposer la pierre avec gel UV + scellage renforcé. Informer la cliente que les reliefs ont une durabilité moindre et conseiller des pierres plus plates pour les clientes actives."},
      {"type":"tip","content":"Intégrer systématiquement les conseils de durabilité dans la conclusion de la prestation (une minute orale + Fiche F5) : la cliente qui comprend les facteurs de durabilité prend soin de sa pose et revient avec des attentes réalistes."},
      {"type":"info","content":"À retenir :\n— La durabilité du nail art dépend du scellage, de la technique et des habitudes de la cliente\n— Informer en fin de prestation — pas en cas de problème après coup\n— Fiche F5 à remettre systématiquement pour les poses avec nail art\n— Les reliefs (pierres, 3D) ont une durabilité intrinsèquement moindre"},
      {"type":"je_maitrise","items":["Je peux expliquer à la cliente les facteurs qui impactent la durabilité de son nail art","Je sais quels conseils donner selon la technique choisie","Je remets la Fiche F5 en fin de prestation nail art"]}
    ]$cb$
  );

END;
$seed$;

-- ══════════════════════════════════════════════════════════════════
-- Fiber Signature — Seed M9 : Situations particulières & cas clients
-- ══════════════════════════════════════════════════════════════════
DO $seed$
DECLARE
  cid UUID;
  mid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature' LIMIT 1;

  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Situations particulières & cas clients', 9)
  RETURNING id INTO mid;

  -- M9.L1 — Ongles courts & onychophagie (11 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Ongles courts & onychophagie — adapter le protocole',
    0, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"L'ongle court ou rongé (onychophagie) présente des contraintes spécifiques : surface de contact réduite, bord libre inexistant ou très court, replis latéraux parfois épaissis, lit de l'ongle parfois exposé ou sensible.\n\nLa fibre de verre peut constituer une option adaptée dans ces situations — sa légèreté et son application sans pression excessive la rendent compatible avec des plaques courtes — mais l'adaptation du protocole est indispensable.\n\nCe que la fibre permet sur ongle court :\n— Prolongement de la longueur avec tip ou technique dual form\n— Renforcement d'une plaque fragilisée par les habitudes de rongeage\n— Couverture protectrice favorisant la repousse naturelle\n\nCe qu'elle ne fait pas : elle n'accélère pas médicalement la repousse — elle peut constituer un soutien esthétique qui facilite l'abandon progressif du rongeage, selon la motivation de la cliente."},
      {"type":"section","label":"Adaptations du protocole"},
      {"type":"table","headers":["Situation","Adaptation"],"rows":[
        ["Bord libre absent ou très court","Utiliser une tip ou dual form pour créer le bord libre avant la pose de fibre · ajuster la longueur avec la cliente en amont"],
        ["Surface de contact réduite","Appliquer le gel de base en couche plus fine · veiller à ne pas déborder sur la peau"],
        ["Replis latéraux épaissis","Préparation plus minutieuse · ne pas tirer sur les cuticules · travailler avec un outil fin et doux"],
        ["Lit de l'ongle sensible ou exposé","Ne pas appliquer de primer sur la zone exposée · vérifier l'absence de plaie ou de saignement avant de commencer"],
        ["Plaque déformée par le rongeage","Évaluer la possibilité de réaliser une pose correcte · en cas de déformation importante, informer la cliente d'une durabilité moindre"]
      ]},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo — Avant/après pose sur ongle court / rongé","note":"Préparation, placement tip, résultat final — à créer depuis l'Atelier Nahira"},
      {"type":"text","content":"Cas client — Onychophagie sévère, une main très irrégulière :\nSituation : la cliente ronge ses ongles depuis l'enfance. Les 10 ongles sont courts, mais 3 sont beaucoup plus courts avec replis latéraux épaissis.\nÉvaluation : absence de plaie ou de saignement actif → pose possible ; les 3 ongles très courts nécessitent une tip adaptée ou une limitation de longueur ; informer la cliente que le résultat sera harmonieux mais que la tenue peut différer selon les ongles.\nAction : réaliser la pose sur les ongles compatibles avec les tips, longueur modérée. Évaluer globalement l'état des 10 ongles pour s'assurer qu'il n'y a pas d'autres signes à prendre en compte. Documenter le résultat en photo et fixer le suivi à 3 semaines."},
      {"type":"warning","content":"Promettre une 'rééducation' ou un arrêt garanti du rongeage grâce à la pose : c'est une décision de la cliente, pas un résultat garanti par la prestation. La pose peut soutenir le processus, pas le déclencher à la place de la cliente."},
      {"type":"tip","content":"Photographier systématiquement les ongles avant la pose sur onychophagie : les photos permettent de suivre l'évolution, de montrer les progrès à la cliente et de documenter l'état initial en cas de question sur la durabilité."},
      {"type":"info","content":"À retenir :\n— Fibre = option adaptable sur ongle court — pas systématiquement contre-indiquée\n— Le protocole s'adapte à la plaque, pas l'inverse\n— Pas de pose sur plaie ou saignement actif\n— Ne pas promettre d'arrêt du rongeage — informer, pas promettre"},
      {"type":"je_maitrise","items":["Je sais adapter mon protocole à un ongle court ou rongé","Je peux expliquer à la cliente ce que la pose peut et ne peut pas faire dans sa situation","Je sais quand refuser de poser (plaie, saignement, état incompatible)"]}
    ]$cb$
  );

  -- M9.L2 — Ongles fins & fragilisés (11 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Ongles fins & fragilisés — précautions & protocole adapté',
    1, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Un ongle fin ou fragilisé présente une plaque dont l'épaisseur ou la résistance est réduite — que ce soit par nature, par des poses précédentes mal retirées, par une carence nutritionnelle, ou par un surlimage antérieur. La fibre de verre peut constituer une option de renforcement dans ce contexte, selon l'objectif et l'état de la plaque.\n\nDistinguer :\n— Ongle naturellement fin : constitution de la cliente, plaque d'apparence normale sans signe d'alerte visible\n— Ongle fragilisé par des poses précédentes : surface irrégulière, zones pelliculaires, translucidité excessive\n— Ongle fragilisé par un surlimage : plaque amincie de manière uniforme, sensibilité à la pression\n\nCes trois situations se manifestent différemment et appellent des adaptations différentes du protocole."},
      {"type":"section","label":"Précautions spécifiques"},
      {"type":"text","content":"— Préparation : limiter ou éviter le limage de préparation sur une plaque déjà mince — utiliser un buffer doux ou uniquement le dégraissage sur les zones les plus fines\n— Primer : appliquer avec parcimonie — sur les zones de contact uniquement, pas sur les zones pelliculaires\n— Gel de base : couche fine — l'objectif est le renforcement, pas l'épaississement\n— Pression : éviter toute pression sur la plaque pendant la pose — ne pas appuyer sur les mèches lors du lissage\n— Information cliente : expliquer que la durabilité peut être moindre sur une plaque fragilisée et que la repousse saine prend du temps"},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo — Ongle fragilisé avant pose / résultat après renforcement fibre","note":"À créer depuis l'Atelier Nahira"},
      {"type":"text","content":"Cas client — Ongles pelliculaires après pose acrylique :\nSituation : la cliente a porté de l'acrylique pendant 2 ans. Depuis la dépose, ses ongles sont pelliculaires et se dédoublent facilement. Elle souhaite une pose légère pour protéger la repousse.\nÉvaluation : plaque d'apparence normale (couleur uniforme, pas de soulèvement, pas d'odeur particulière) → situation compatible avec une pose de renforcement ; éviter tout limage de préparation agressif → buffer doux uniquement ; informer la cliente que l'objectif est le renforcement progressif, pas une pose esthétique de longue durée immédiatement.\nAction : pose de fibre légère en renforcement, longueur naturelle, suivi à 3 semaines. Évaluer la tenue avant de proposer un allongement."},
      {"type":"warning","content":"Limer la préparation normalement sur un ongle fragilisé par surlimage antérieur : on retire encore de la matière sur une plaque déjà trop mince. Sur ces plaques, la préparation se limite au nettoyage et dégraissage — pas de limage."},
      {"type":"tip","content":"Sur un ongle fragilisé, proposer une première prestation de renforcement sans longueur ajoutée : cela permet d'évaluer la réponse de la plaque avant d'augmenter les contraintes. La cliente qui voit ses ongles se stabiliser devient une cliente fidèle."},
      {"type":"info","content":"À retenir :\n— Distinguer ongle fin par nature / fragilisé par poses / fragilisé par surlimage\n— Préparation minimale sur plaque fine — buffer doux voire aucun limage\n— Pose légère en priorité — renforcement avant allongement\n— Informer la cliente sur le suivi progressif de la repousse"},
      {"type":"je_maitrise","items":["Je sais adapter la préparation à un ongle fragilisé","Je peux expliquer à la cliente la différence entre renforcement et allongement","Je comprends quand proposer une prestation de renforcement avant une pose esthétique complète"]}
    ]$cb$
  );

  -- M9.L3 — Sensibilités & allergies (13 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Sensibilités & allergies — identifier, adapter, refuser',
    2, 12,
    $cb$[
      {"type":"section","label":"Comprendre — Distinguer sensibilité et allergie"},
      {"type":"text","content":"La confusion entre sensibilité à une odeur et allergie à un composant est fréquente — et lourde de conséquences si elle oriente mal la décision de réaliser ou non la prestation.\n\nSensibilité à l'odeur : inconfort olfactif lié aux solvants ou résines — ne reflète pas nécessairement une réaction allergique. Une bonne ventilation peut suffire.\n\nSensibilité cutanée : peau réactive, rougeurs fréquentes, antécédents de réactions aux cosmétiques — nécessite prudence et test, pas forcément contre-indication absolue.\n\nAllergie avérée à un composant : réaction déjà documentée (rougeur, démangeaison intense, œdème, éruption) à un produit contenant une résine, un acrylate ou un autre composant présent dans les produits utilisés. Dans ce cas, la prestation ne peut pas être réalisée avec les produits concernés."},
      {"type":"section","label":"Questions à poser avant la prestation"},
      {"type":"text","content":"— Avez-vous déjà eu une réaction à un produit utilisé sur vos ongles, vos mains, votre peau ?\n— Portez-vous des prothèses, des appareils dentaires, ou avez-vous une allergie au nickel ou aux métaux ?\n— Prenez-vous des médicaments pouvant augmenter la photosensibilité (isotrétinoïne, certains antibiotiques) ?\n— Avez-vous des antécédents de réactions cutanées, de plaques ou de rougeurs persistantes, de démangeaisons chroniques sur la peau ou les ongles ?\n\nFiche F3 — Accord de prestation esthétique (à faire signer avant chaque nouvelle prestation)"},
      {"type":"section","label":"Décisions selon la situation"},
      {"type":"table","headers":["Situation","Action"],"rows":[
        ["Sensibilité à l'odeur uniquement","Ventiler l'espace · proposition de masque · poser si la cliente est consentante et à l'aise"],
        ["Peau sensible, pas d'allergie documentée","Limiter la surface de contact des produits avec la peau · éviter le primer sur les bords · observer pendant la pose"],
        ["Allergie documentée à un composant du protocole","Ne pas réaliser la prestation avec ce composant · informer la cliente qu'aucune substitution ne peut être garantie sans connaître la composition exacte du déclencheur"],
        ["Réaction en cours de prestation (rougeur, démangeaison, sensation de brûlure)","Arrêter immédiatement · retirer le produit en cause · ne pas continuer · documenter l'incident"]
      ]},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo — Exemples de réactions cutanées périunguéales","note":"Érythème léger / eczéma de contact / zone de rougeur — illustration à créer depuis l'Atelier Nahira"},
      {"type":"text","content":"Cas client — Rougeur apparaissant après application du primer :\nSituation : après l'application du primer acide sur 3 ongles, la cliente signale une légère brûlure et une rougeur apparaît sur le repli proximal d'un ongle.\nAction immédiate : rincer doucement avec de l'eau — ne pas frotter ; arrêter l'application du primer sur tous les ongles restants ; évaluer la réaction — si légère rougeur sans progression : noter, continuer éventuellement sans primer sur les zones sensibles (accord de la cliente) ; si démangeaison ou progression : arrêter la prestation, ne pas appliquer d'autres produits, conseiller une consultation médicale si la réaction persiste.\nÀ noter : ne pas continuer 'quand même' si la cliente dit que c'est normal pour elle. Documenter sur la fiche cliente et ne plus utiliser ce primer à l'avenir."},
      {"type":"warning","content":"Confondre 'je suis sensible aux odeurs' avec 'je suis allergique aux produits' — ou inversement, ignorer une vraie réaction sous prétexte que la cliente 'dit souvent ça'. Les deux erreurs conduisent à des décisions inadaptées. Écouter, questionner, observer."},
      {"type":"tip","content":"Conserver sur la fiche cliente toutes les informations sur les sensibilités déclarées, les produits utilisés et les réactions observées — même légères. Ces notes sont précieuses pour les prochaines prestations et protègent aussi l'esthéticienne en cas de litige."},
      {"type":"info","content":"À retenir :\n— Distinguer : odeur / sensibilité cutanée / allergie documentée\n— Questions systématiques avant la première prestation → Fiche F3\n— Réaction en cours = arrêt immédiat, jamais 'continuer quand même'\n— Documenter sur la fiche cliente — toute réaction même mineure"},
      {"type":"je_maitrise","items":["Je peux distinguer sensibilité à l'odeur, sensibilité cutanée et allergie","Je sais quelles questions poser avant la prestation","Je sais prendre la décision d'arrêter une prestation et l'expliquer à la cliente"]}
    ]$cb$
  );

  -- M9.L4 — Pathologies unguéales — reconnaître & décider (11 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Pathologies unguéales — reconnaître & décider',
    3, 12,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"En tant qu'esthéticienne, le rôle n'est pas de diagnostiquer — c'est celui d'un médecin ou d'un dermatologue. Le rôle est de reconnaître les signes qui rendent une prestation impossible ou à risque, et de prendre la décision appropriée : adapter le protocole, travailler uniquement sur les zones non concernées, ou reporter la prestation.\n\nL'objectif de cette leçon est de former à la reconnaissance visuelle des signes d'alerte les plus fréquents — pas à leur traitement."},
      {"type":"section","label":"Tableau des signes d'alerte unguéaux"},
      {"type":"table","headers":["Signe observé","Conduite professionnelle"],"rows":[
        ["Taches blanches ou jaunâtres sous la plaque · décollement partiel · odeur inhabituellement forte ou déplaisante","✗ Ne pas réaliser la prestation sur l'ongle concerné · évaluer l'ensemble des ongles avant toute prestation sur les autres · orienter vers professionnel de santé"],
        ["Plaque très épaissie · couleur altérée (jaunâtre, brunâtre ou verdâtre) · texture friable · déformation progressive","✗ Reporter la prestation complète · orienter vers professionnel de santé"],
        ["Petits puits ou creux dans la surface de la plaque (ponctations) · épaississement · décollement partiel du lit · peau adjacente rougie ou épaissie","△ Évaluer au cas par cas · si plaque stable et peau non lésée → possible avec précautions · si zone rougie, irritée ou douloureuse → reporter et orienter vers professionnel de santé"],
        ["Repli latéral rouge, gonflé ou douloureux · ongle poussant dans la chair au niveau du bord latéral","✗ Ne pas travailler sur la zone concernée · orienter vers médecin ou podologue"],
        ["Bande colorée sombre (noire, brune ou grisâtre) s'étendant dans le sens de la longueur sous la plaque, de la base vers le bord libre","✗ Pigmentation longitudinale nouvelle, inexpliquée ou évolutive : ne pas masquer la zone · recommander une évaluation par un professionnel de santé avant toute prestation sur cet ongle"],
        ["Décollement visible de la plaque sur une zone · espace entre la plaque et le lit de l'ongle","△ Ne pas appliquer de produit sur la zone décollée · évaluer si la prestation peut être réalisée sur les autres ongles sans risque · orienter vers professionnel de santé si le décollement est étendu, inexpliqué ou persistant"],
        ["Petite tache sombre (noire ou brunâtre) localisée sous la plaque ou sur le repli proximal · zone délimitée · ne s'étend pas sur la longueur","✓ Possible si la plaque est intacte et sans signe d'alerte (rougeur, gonflement, douleur ou odeur inhabituelle) · informer la cliente · surveiller l'évolution à la prochaine visite"]
      ]},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photos — Signes visuels à reconnaître","note":"Les 7 signes du tableau : taches/décollement/odeur · plaque épaissie et altérée · ponctations · repli latéral gonflé · bande longitudinale sombre · décollement · tache localisée sombre — photos libres de droits ou illustrations à intégrer depuis l'Atelier Nahira"},
      {"type":"text","content":"Cas client — Ongle avec tache blanche et légère odeur :\nSituation : en préparant l'ongle du majeur, tu constates une tache blanche sous la plaque avec un léger décollement et une odeur particulière.\nObservation : tu ne peux pas déterminer l'origine de ce signe — mais tu peux décrire ce que tu vois et décider de la conduite à tenir.\nAction : ne pas continuer sur cet ongle ; expliquer calmement à la cliente ce que tu observes (décrire uniquement — ne pas nommer, ne pas interpréter) ; évaluer la situation globale — y a-t-il des signes similaires sur d'autres ongles ? Si les autres ongles ne présentent aucun signe d'alerte et que le travail peut être réalisé de façon indépendante sans contact avec l'ongle concerné, la prestation peut être envisagée sur les ongles non touchés en appliquant des mesures d'hygiène strictes entre chaque ongle ; recommander une évaluation par un professionnel de santé pour l'ongle concerné ; documenter sur la fiche cliente avec date et description de l'observation."},
      {"type":"warning","content":"Poser sur un ongle présentant un signe d'alerte pour 'voir ce que ça donne' ou pour ne pas décevoir la cliente : masquer un signe d'alerte sous une pose empêche toute observation ultérieure et peut retarder une prise en charge nécessaire. L'esthéticienne engage sa responsabilité professionnelle."},
      {"type":"tip","content":"Préparer une phrase d'explication simple et non alarmiste pour informer la cliente sans nommer ni interpréter : 'J'observe quelque chose sur cet ongle qui me demande de ne pas travailler dessus aujourd'hui — je te recommande de le faire regarder par un professionnel de santé. Selon l'état des autres ongles, on peut évaluer ensemble si on continue sur ceux-là.'"},
      {"type":"info","content":"À retenir :\n— Reconnaître ≠ diagnostiquer — orienter, pas traiter\n— Toute ligne sombre longitudinale → arrêt total, orientation dermatologue immédiate\n— Tache blanche ou jaunâtre, décollement, odeur inhabituelle → pas de pose sur l'ongle concerné · évaluation globale avant toute prestation sur les autres ongles\n— Documenter sur la fiche cliente — date, observation, décision prise"},
      {"type":"je_maitrise","items":["Je peux citer 5 signes d'alerte unguéaux et la décision associée","Je sais expliquer à une cliente pourquoi je ne peux pas réaliser la prestation sur un ongle","Je comprends que masquer un signe d'alerte sous une pose engage ma responsabilité professionnelle"]}
    ]$cb$
  );

  -- M9.L5 — Incidents en cours de prestation (33 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Incidents en cours de prestation — protocoles d''urgence',
    4, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Même avec un protocole rigoureux, des incidents peuvent survenir en cours de prestation. Les anticiper et connaître la réponse appropriée permet d'agir calmement, de protéger la cliente, et de gérer la situation de manière professionnelle.\n\nLes incidents les plus fréquents :\n— Saignement (cuticule coupée, repli lésé)\n— Réaction cutanée en cours de pose (rougeur, démangeaison, sensation de brûlure)\n— Inconfort douloureux de la cliente (pression, chaleur de polymérisation)\n— Produit dans les yeux ou sur une muqueuse\n— Malaise de la cliente (vapeurs, position, stress)"},
      {"type":"section","label":"Protocoles par incident"},
      {"type":"text","content":"Saignement"},
      {"type":"step","number":1,"title":"Arrêter immédiatement le travail sur la zone concernée","content":""},
      {"type":"step","number":2,"title":"Comprimer légèrement avec une compresse stérile","content":"Ne pas souffler dessus."},
      {"type":"step","number":3,"title":"Attendre l'arrêt complet du saignement avant de reprendre","content":""},
      {"type":"step","number":4,"title":"Désinfecter avec un antiseptique adapté à la peau péri-unguéale","content":""},
      {"type":"step","number":5,"title":"Ne pas poser de produit sur la zone lésée","content":"Éviter tout contact avec les résines."},
      {"type":"step","number":6,"title":"Documenter l'incident sur la fiche cliente","content":""},
      {"type":"text","content":"Réaction cutanée (rougeur, démangeaison, brûlure)"},
      {"type":"step","number":1,"title":"Arrêter l'application du produit en cause","content":""},
      {"type":"step","number":2,"title":"Rincer doucement à l'eau","content":"Ne pas frotter."},
      {"type":"step","number":3,"title":"Évaluer la progression de la réaction (moins de 2 minutes)","content":"Si elle régresse : noter, adapter le protocole. Si elle progresse : arrêter la prestation complète."},
      {"type":"step","number":4,"title":"Ne pas appliquer d'autre produit sur la zone réactionnelle","content":""},
      {"type":"step","number":5,"title":"Conseiller une consultation médicale si la réaction persiste après rinçage","content":""},
      {"type":"text","content":"Chaleur excessive lors de la polymérisation"},
      {"type":"step","number":1,"title":"Demander à la cliente de retirer la main de la lampe immédiatement","content":""},
      {"type":"step","number":2,"title":"Ne pas forcer","content":"La sensation de brûlure peut survenir même avec des lampes conformes si les couches sont trop épaisses."},
      {"type":"step","number":3,"title":"Laisser refroidir complètement","content":"30 secondes à 1 minute."},
      {"type":"step","number":4,"title":"Évaluer","content":"Si la sensation a cessé : vérifier l'épaisseur du gel appliqué · reprendre en couche plus fine."},
      {"type":"step","number":5,"title":"Si la cliente est très sensible à la chaleur : pulser la polymérisation","content":"Interruptions courtes pendant l'exposition à la lampe."},
      {"type":"info","content":"Note fabricant : certaines lampes disposent d'un mode 'low heat' (basse intensité initiale) pour les peaux sensibles. Consulter les spécifications de la lampe utilisée.\n\nFiche F7 — Protocoles d'urgence en prestation (format affichage salon — plastifiable · à garder visible au poste de travail, pas dans un tiroir)"},
      {"type":"text","content":"Produit dans les yeux"},
      {"type":"step","number":1,"title":"Rincer abondamment à l'eau claire","content":"Au moins 15 minutes."},
      {"type":"step","number":2,"title":"Ne pas frotter les yeux","content":""},
      {"type":"step","number":3,"title":"Consulter un médecin ou contacter le SAMU (15) si irritation persistante","content":""},
      {"type":"step","number":4,"title":"Conserver l'emballage du produit","content":"Pour le transmettre aux secours si besoin."},
      {"type":"text","content":"Cas client — Malaise vagal pendant la prestation :\nSituation : la cliente pâlit, se plaint de vertiges et de nausées en cours de pose. Elle dit 'ne pas aimer l'odeur' depuis le début.\nAction : arrêter la prestation immédiatement ; installer la cliente en position allongée ou tête entre les genoux ; aérer la pièce (fenêtre ouverte) ; proposer de l'eau (pas à avaler si très nauséeuse) ; si amélioration rapide (1–2 min) → attendre complet rétablissement avant de décider de reprendre ou non ; si pas d'amélioration ou aggravation → appeler le 15. Ne pas reprendre la prestation sous pression de la cliente si elle n'est pas pleinement rétablie."},
      {"type":"warning","content":"Minimiser la plainte de la cliente ('c'est normal, ça passe') ou continuer malgré une réaction en cours : chaque minute supplémentaire d'exposition augmente le risque. L'arrêt est toujours la décision la plus professionnelle dans le doute."},
      {"type":"tip","content":"Afficher la Fiche F7 à proximité immédiate du poste de travail, pas dans un tiroir. En cas d'incident, le stress cognitif rend difficile de se souvenir des étapes — la fiche visuelle visible en un coup d'œil est le meilleur outil dans ces moments."},
      {"type":"info","content":"À retenir :\n— Saignement → arrêt, compression, antiseptique, pas de produit sur la zone\n— Réaction cutanée → rinçage, évaluation, arrêt si progression\n— Chaleur excessive → retirer de la lampe immédiatement, reprendre en couche plus fine\n— Produit dans les yeux → rinçage 15 min, consultation médicale si persistance\n— Fiche F7 visible au poste de travail — pas dans un tiroir"},
      {"type":"je_maitrise","items":["Je peux décrire les étapes du protocole pour chaque type d'incident","Je sais quand arrêter une prestation sans hésitation","J'ai la Fiche F7 affichée et accessible à mon poste de travail"]}
    ]$cb$
  );

END;
$seed$;
