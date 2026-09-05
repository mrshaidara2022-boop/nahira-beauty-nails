-- Fiber Signature — Seed M0 (4 leçons) + M1 (5 leçons)
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- Médias : blocs placeholder uniquement (photos/vidéos non produites)
-- Corrections M8.L4 et M9.L4 seront appliquées dans leurs migrations respectives

DO $seed$
DECLARE
  cid UUID;  -- course id
  mid UUID;  -- current module id
BEGIN

  -- ── COURSE ────────────────────────────────────────────────────────────────
  INSERT INTO academy_courses (slug, title, subtitle, level, passing_score, is_published, sort_order)
  VALUES (
    'fiber-signature',
    'Masterclass Fibre de Verre — Fiber Signature',
    'La méthode complète pour maîtriser la pose fibre de verre en onglerie professionnelle',
    'intermediaire', 70, false, 1
  )
  ON CONFLICT (slug) DO UPDATE SET updated_at = now()
  RETURNING id INTO cid;

  IF cid IS NULL THEN
    SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature';
  END IF;

  -- ══════════════════════════════════════════════════════════════════════════
  -- MODULE 0 — Introduction
  -- ══════════════════════════════════════════════════════════════════════════
  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Introduction', 0) RETURNING id INTO mid;

  -- ── L 0.1 — Message de bienvenue ──────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Message de bienvenue', 0, 5, $cb$[
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"video","description":"Vidéo de bienvenue — Nahira · Voix off ou caméra selon préférence · 1–2 minutes · À ajouter depuis l'Atelier Nahira"},
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Bienvenue dans la Masterclass Fiber Signature.\n\nSi tu es là, c'est que tu veux aller plus loin. Plus loin que ce qu'on t'a appris, plus loin que les techniques génériques, plus loin que le « ça tient à peu près ». Tu veux maîtriser une technique de renfort qui respecte vraiment l'ongle naturel — et être capable de l'expliquer à tes clientes avec confiance.\n\nC'est exactement ce que tu vas apprendre ici.\n\nLa fibre de verre n'est pas une technique difficile. Elle est précise. La différence, c'est que la précision s'apprend, étape par étape. Et c'est ce que ce parcours va t'offrir : une progression construite, des démonstrations concrètes, des exercices réels, et une méthode testée.\n\nChaque leçon est conçue pour que tu sortes capable de faire, pas seulement de savoir. La théorie et la pratique vont ensemble — tu n'iras jamais loin dans l'une sans l'autre."},
    {"type":"tip","content":"Ce que tu vas voir dans cette formation, c'est ma méthode de travail. Celle que j'ai construite, testée, affinée sur des centaines de poses. Ce n'est pas la seule façon de faire — c'est celle qui fonctionne pour moi, et qui fonctionne pour les élèves qui la suivent avec sérieux. Tu l'adapteras à ta pratique au fil du temps. Pour l'instant, suis-la telle qu'elle est présentée : la compréhension profonde vient quand les gestes sont acquis."},
    {"type":"info","content":"Cette formation est un parcours pédagogique complet — suis les modules dans l'ordre la première fois.\nChaque leçon t'amène à faire, pas seulement à lire.\nLa maîtrise vient de la répétition — reviens aux leçons aussi souvent que nécessaire."}
  ]$cb$::jsonb);

  -- ── L 0.2 — La philosophie Fiber Signature ────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'La philosophie Fiber Signature', 1, 7, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Avant d'apprendre la technique, il est important de comprendre la logique derrière. La méthode Fiber Signature repose sur trois piliers. Ce ne sont pas des règles abstraites — ce sont des principes qui expliquent chaque geste que tu vas apprendre."},
    {"type":"material","title":"Les 3 piliers de la méthode","items":[
      "Pilier 1 — Respect absolu de la plaque naturelle. Dans la méthode Fiber Signature, la résistance recherchée vient du renfort textile intégré (la fibre encapsulée), et non d'un ajout excessif de gel. L'objectif est une pose aussi légère que possible pour la plaque naturelle, sans sacrifier la tenue. Une pose proportionnée et bien construite vaut mieux qu'une pose épaisse et lourde.",
      "Pilier 2 — Précision avant vitesse. Une pose fibre bien faite prend le temps qu'elle prend. La vitesse vient avec la maîtrise — pas avant. Une pose bâclée coûte plus de temps à corriger qu'à faire correctement dès le départ.",
      "Pilier 3 — Durabilité honnête. On ne promet pas à une cliente ce qu'on ne peut pas garantir. On lui explique ce que la pose peut faire, dans ses conditions réelles. La tenue d'une pose fibre dépend aussi du comportement de la cliente au quotidien — c'est une information à transmettre, pas une excuse."
    ]},
    {"type":"text","content":"Ces trois piliers ne sont pas que philosophiques. Ils vont guider tes choix techniques tout au long de la formation : pourquoi on prépare l'ongle d'une certaine façon, pourquoi on place la fibre là et pas ailleurs, pourquoi on limite le gel, pourquoi on parle à la cliente avant de commencer."},
    {"type":"tip","content":"Quand tu es face à un doute technique pendant une pose — et ça arrivera — pose-toi cette question simple : « Est-ce que ce geste respecte l'ongle naturel ? » Si la réponse est non, ou si tu n'es pas sûre, c'est souvent le signal de ralentir ou de choisir une alternative plus douce."},
    {"type":"info","content":"Respect · Précision · Durabilité honnête : ces trois mots résument la méthode.\nLa technique est au service de l'ongle, pas l'inverse.\nTu adapteras cette méthode à ta pratique — mais comprends-la d'abord entièrement."}
  ]$cb$::jsonb);

  -- ── L 0.3 — Comment utiliser cette formation ──────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Comment utiliser cette formation', 2, 5, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Cette formation est structurée pour que tu progresses naturellement — du plus fondamental au plus avancé. Voici comment en tirer le meilleur."},
    {"type":"material","title":"La structure de la formation","items":[
      "13 modules + cette introduction — chaque module couvre un grand thème (comprendre, préparer, poser, corriger, développer ton activité)",
      "Chaque leçon dure 5 à 15 minutes — lisible en une session, applicable directement",
      "Les modules 11, 12 et 13 sont la partie business — ne les survole pas : ils sont aussi importants que la technique"
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"material","title":"Ce que tu trouveras dans chaque leçon","items":[
      "COMPRENDRE — les explications théoriques, le pourquoi",
      "VOIR — photos, schémas, vidéos de démonstration",
      "FAIRE — exercices pratiques, mini cas, checklists",
      "VÉRIFIER — comment savoir si tu as vraiment compris et assimilé",
      "Encadrés — Astuce Nahira · Erreur fréquente · À retenir · Je maîtrise si..."
    ]},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Conseils d'utilisation","items":[
      "Suis les modules dans l'ordre lors de ton premier parcours — la logique est progressive",
      "Coche chaque leçon terminée — ta progression est sauvegardée automatiquement",
      "Reviens aux leçons qui t'ont posé question, autant de fois que nécessaire",
      "Pratique entre les leçons : la lecture seule ne suffit pas à créer la mémoire gestuelle",
      "Le quiz final se déverrouille une fois tous les modules parcourus"
    ]},
    {"type":"tip","content":"Télécharge la fiche de route ci-dessous et imprime-la (ou garde-la sur ton téléphone). Coche chaque leçon terminée à la main — ça t'aide à visualiser ta progression et à rester motivée."},
    {"type":"placeholder","media_type":"pdf","description":"Fiche de route — parcours complet de la Masterclass · PDF téléchargeable · À ajouter depuis l'Atelier Nahira"}
  ]$cb$::jsonb);

  -- ── L 0.4 — Ce qu'il te faut avant de commencer ──────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Ce qu''il te faut avant de commencer', 3, 8, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Avant de plonger dans la technique, vérifie que tu as le matériel de base. Pas besoin d'avoir tout immédiatement — mais certains éléments sont indispensables pour suivre les leçons pratiques et s'exercer.\n\nCette liste est générique et professionnelle. Les marques et références spécifiques sont disponibles depuis la Fiche F1 téléchargeable dans tes ressources."},
    {"type":"material","title":"Matériel essentiel par catégorie","items":[
      "Fibre de verre pour onglerie — format bande ou feuille, tissage fin professionnel. C'est la base de toute la technique.",
      "Gel de construction — viscosité moyenne (ni trop fluide, ni trop épais), compatible avec ta lampe. Choisir un gel qui tient sans couler, qui ne se nivelle pas tout seul.",
      "Base d'adhérence — primer ou bond selon les recommandations du gel utilisé. Vérifie toujours la compatibilité entre ta base et ton gel.",
      "Top coat gel — brillant ou satiné selon l'effet souhaité, compatible avec la pose fibre.",
      "Ciseaux fins dédiés à la fibre — lames droites, très tranchantes. Des ciseaux de couture classiques compriment la fibre au lieu de la couper nettement.",
      "Pince de pose — pour maintenir la fibre pendant la fixation sans la toucher avec les doigts (qui transmettent du sébum et altèrent l'adhérence).",
      "Limes et buffer — lime 100/180 pour la structure, buffer doux pour la finition, lime fine pour les contours.",
      "Lampe UV/LED — compatible avec le gel utilisé. Les temps de polymérisation, la puissance requise et les compatibilités indiqués par le fabricant du gel priment sur toute autre recommandation. Vérifie systématiquement ces informations avant utilisation.",
      "Produits de préparation — dégraissant ou nettoyant, primer si ton gel le nécessite, brosse de dépoussiérage.",
      "Matériel d'hygiène — désinfectant, serviettes jetables, coton, orange stick ou pousse-cuticules."
    ]},
    {"type":"tip","content":"Commande légèrement plus de fibre que ce que tu penses utiliser. On en consomme toujours plus qu'anticipé, surtout au début — mauvaises découpes, ajustements, leçons pratiques sur faux ongles. Avoir du stock évite les interruptions au mauvais moment."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"pdf","description":"Fiche F1 — Liste matériel complète avec estimations budget · PDF téléchargeable · Références mises à jour par Nahira"},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Organiser ton espace de travail","items":[
      "Dispose ton matériel dans un ordre logique (de gauche à droite si tu es droitière) : préparation → pose → finition",
      "La fibre ne doit jamais traîner à portée de la lampe — la polymérisation accidentelle est fréquente",
      "Prévoie un éclairage suffisant : une lampe de bureau orientable est indispensable pour voir la fibre pendant la pose",
      "Protège ta surface de travail — le gel durci est difficile à retirer de certains matériaux"
    ]},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"je_maitrise","content":"Je dispose de tout le matériel de base, je comprends le rôle de chaque outil, et mon espace de travail est organisé et propre avant chaque prestation."}
  ]$cb$::jsonb);

  -- ══════════════════════════════════════════════════════════════════════════
  -- MODULE 1 — Comprendre la fibre de verre
  -- ══════════════════════════════════════════════════════════════════════════
  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Comprendre la fibre de verre', 1) RETURNING id INTO mid;

  -- ── L 1.1 — Définition & origines ─────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Définition & origines de la fibre de verre en onglerie', 0, 7, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La fibre de verre est un matériau composite constitué de filaments de verre extrêmement fins, tissés en nappe fine et souple. Elle est utilisée depuis des décennies dans l'industrie — aéronautique, construction navale, sport — pour ses propriétés de renfort : légèreté élevée, résistance à la traction, flexibilité contrôlée.\n\nSon adaptation à l'onglerie est venue de cette logique : si la fibre renforce des coques de bateaux ou des cadres de vélo sans les alourdir, pourquoi ne pas l'utiliser pour renforcer un ongle naturel fragilisé, sans le surcharger de matière épaisse ?\n\nCe n'est pas un produit chimiquement actif. La fibre ne colle pas, ne durcit pas, ne réagit à rien. Son rôle est purement mécanique : elle distribue les contraintes physiques sur une surface plus large, empêchant la fracture de se concentrer en un point."},
    {"type":"material","title":"Points clés","items":[
      "Matériau issu de l'industrie, adapté à l'onglerie pour ses propriétés mécaniques",
      "Constitué de filaments de verre tissés en nappe fine",
      "Agit comme un renfort structurel, pas comme un agent chimique",
      "Encapsulée dans un gel, elle forme un composite léger et résistant"
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Photo : fibre de verre en bande sur fond blanc ou ivoire — texture visible, filaments apparents · À ajouter depuis l'Atelier Nahira"},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"La fibre de verre n'est pas une substance chimique active — c'est un support mécanique.\nSon rôle n'est pas de coller, mais de renforcer par sa structure textile.\nC'est la combinaison fibre + gel qui crée la résistance — aucun des deux seul n'est suffisant."}
  ]$cb$::jsonb);

  -- ── L 1.2 — Le principe du renfort ────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Comment fonctionne la fibre — le principe du renfort', 1, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Un ongle naturel est soumis en permanence à des contraintes mécaniques : flexion vers l'arrière quand on ouvre un emballage, torsion quand on coince quelque chose, choc quand on frappe une surface. Sans renfort, ces forces se concentrent sur le point de fragilité naturel de l'ongle — généralement le milieu de la plaque ou le bord libre. C'est là que ça casse.\n\nLa fibre de verre, encapsulée dans le gel, fonctionne comme un filet de distribution des contraintes. Au lieu de se concentrer en un point, les forces sont réparties sur toute la surface où la fibre est présente. Résultat : la plaque naturelle subit beaucoup moins de pression en un seul endroit, et la casse devient nettement moins probable.\n\nImagine une semelle dans une chaussure : sans semelle, tout le poids de ton corps repose sur quelques centimètres carrés. Avec une bonne semelle, ce poids est réparti sur toute la surface du pied. La douleur disparaît. La fibre fonctionne exactement sur ce principe."},
    {"type":"material","title":"Points clés","items":[
      "Sans fibre : les contraintes se concentrent au point de fragilité → casse prévisible",
      "Avec fibre : les contraintes sont distribuées sur toute sa surface → résistance augmentée",
      "Plus la fibre est bien positionnée, plus l'effet est efficace",
      "La fibre distribue les contraintes mécaniques — c'est son positionnement et son encapsulation qui déterminent l'efficacité du renfort, en combinaison avec le gel"
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Schéma : ongle sans fibre (flèche de contrainte concentrée → rupture) vs ongle avec fibre (contraintes réparties → résistance) · Illustration à créer · À ajouter depuis l'Atelier Nahira"},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Réfléchis à cette situation avant de lire la réponse."},
    {"type":"text","content":"Cas pratique — Ta cliente revient régulièrement avec un ongle cassé toujours au même endroit — au milieu de la plaque, côté gauche. Elle dit qu'elle ne fait rien de particulier. Qu'est-ce que ça t'indique sur la prochaine pose ?"},
    {"type":"info","content":"✓ Ce point de casse répétitif indique que la fibre (si elle était posée) n'a pas couvert cette zone, ou qu'elle n'était pas bien encapsulée à cet endroit. Sur la prochaine pose, tu vérifieras particulièrement que la fibre couvre bien le côté gauche de la plaque, que la découpe est adaptée, et que l'encapsulation est complète sur cette zone."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"La fibre distribue les contraintes — c'est la combinaison fibre bien positionnée + gel correctement appliqué qui crée la tenue.\nUn point de casse répétitif = la fibre ne couvre pas bien cette zone.\nL'efficacité du renfort dépend directement du placement et de l'encapsulation de la fibre."}
  ]$cb$::jsonb);

  -- ── L 1.3 — Fibre vs gel classique ────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Fibre de verre vs gel classique — comparaison honnête', 2, 8, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Cette comparaison n'est pas un concours — il n'existe pas de technique universellement supérieure. Chaque approche a sa logique, ses forces, ses limites, et ses cas d'usage. Comprendre ces différences, c'est être capable de choisir la technique adaptée à chaque cliente et de l'expliquer clairement."},
    {"type":"material","title":"Les deux approches","items":[
      "Le gel classique construit sa résistance à travers l'architecture de ses couches, sa formulation chimique, et une épaisseur maîtrisée — ni trop fine, ni excessive. Un gel mal appliqué (trop épais ou trop fin) perd ses propriétés, quelle que soit sa qualité. Il est polyvalent, adapté à une large gamme de poses et de rallongements.",
      "La fibre de verre intègre un renfort textile dans le système de construction gel. Ce renfort distribue les contraintes mécaniques sur une surface plus large. La pose peut être plus légère en quantité de gel, ce qui peut constituer un avantage sur les ongles fragiles ou fins — selon l'état de l'ongle, l'objectif et le protocole suivi."
    ]},
    {"type":"warning","content":"Erreur fréquente : dénigrer le gel classique face à une cliente pour valoriser la fibre. « Le gel c'est lourd et mauvais pour les ongles » — ce n'est ni exact ni professionnel. Les deux techniques ont leur place. La fibre est une compétence supplémentaire dans ton arsenal, pas un jugement sur d'autres méthodes ou d'autres prothésistes."},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["Critère","Gel classique","Fibre de verre"],"rows":[
      ["Principe de renfort","Architecture de couches, formulation, épaisseur maîtrisée","Renfort textile intégré au système de construction gel"],
      ["Poids de la pose","Variable selon protocole","Peut être plus léger (moins de gel nécessaire)"],
      ["Solidité","Très bonne si application maîtrisée","Très bonne si bien positionnée et encapsulée"],
      ["Temps de pose","Relativement rapide","Un peu plus long (précision requise)"],
      ["Difficulté technique","Accessible","Requiert précision et méthode"],
      ["Rallongement possible","Oui, important","Mini rallongement seulement"],
      ["Indication prioritaire","Polyvalent","Ongles fins, cassants, sensibilisés"],
      ["Respect de la plaque","Bon si protocole adapté","Renforcé (moins de matière ajoutée selon protocole)"]
    ]},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"Il n'y a pas de technique universellement supérieure — chacune a sa logique, ses forces et ses indications.\nLe gel construit sa résistance par son architecture de couches et sa formulation ; la fibre y ajoute un renfort textile — deux approches complémentaires.\nTu dois pouvoir expliquer cette différence à une cliente en 30 secondes, objectivement et sans dénigrer."}
  ]$cb$::jsonb);

  -- ── L 1.4 — Choisir la bonne technique ────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Fibre, gel, acrygel, capsules — choisir la bonne technique', 3, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"En onglerie, on ne choisit pas une technique parce qu'on la maîtrise mieux — on la choisit parce qu'elle est adaptée à la cliente qui est en face de soi. Ça prend du temps à intégrer, mais c'est fondamental."},
    {"type":"material","title":"Les quatre techniques et leurs indications","items":[
      "Gel classique — polyvalent, bon pour la majorité des poses standard, rallongements modérés à importants, polyvalent sur tous types d'ongles.",
      "Fibre de verre — intègre un renfort textile au système de construction. Peut constituer une option adaptée pour les ongles naturels fins, cassants ou sensibilisés, ou dans le cadre d'un accompagnement progressif de la repousse. Mini rallongement possible. Quantité de gel généralement plus légère.",
      "Acrygel (gel builder dense) — entre l'acrylique et le gel. Plus structurant, très adapté aux rallongements notables, aux formes travaillées (amande longue, stiletto). Moins léger que la fibre.",
      "Capsules — pose rapide, standardisée. Adapté aux clientes qui souhaitent une prestation rapide et régulière, moins de personnalisation. Pas de travail sur l'ongle naturel lui-même."
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["Situation cliente","Technique recommandée"],"rows":[
      ["Ongle naturel fin ou cassant, sans rallongement","Fibre de verre ✓"],
      ["Ongle rongé, accompagnement progressif de la repousse","Fibre de verre (adaptée selon état) ✓"],
      ["Rallongement important, forme travaillée","Acrygel ou capsules"],
      ["Pose polyvalente standard","Gel classique"],
      ["Prestation rapide, standardisée","Capsules"],
      ["Sensibilité aux odeurs (hors allergie identifiée à un composant)","Fibre + gel UV/LED peut être envisagé — vérifier les composants selon l'allergie déclarée"],
      ["Ongle abîmé par des poses précédentes","Fibre (après observation préalable) ✓"]
    ]},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Cas pratique — Ta cliente a les ongles naturels, assez fins, qui se cassent régulièrement. Elle veut un renfort discret, sans rallongement ni ajout de longueur. Elle mentionne qu'elle est sensible aux odeurs fortes (pas d'allergie identifiée à un composant). Quelle technique peut constituer une option adaptée, et pourquoi ?"},
    {"type":"info","content":"✓ La fibre de verre peut constituer une option bien adaptée à ce profil. Ongles fins et cassants → le renfort textile intégré peut aider à distribuer les contraintes sans alourdir la pose. Pas de rallongement souhaité → la technique convient. Sensibilité aux odeurs (hors allergie déclarée à un composant) → les gels UV/LED ont généralement moins d'odeur que les acryliques, mais cela dépend des produits spécifiques utilisés.\n\nImportant : une sensibilité aux odeurs n'est pas une allergie à un composant — si une allergie à un ingrédient de gel est suspectée, un avis médical s'impose avant toute pose."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"tip","content":"Au début, il est tentant de vouloir faire de la fibre sur toutes les clientes parce qu'on vient de l'apprendre. Résiste à cette tentation. Choisir la bonne technique pour chaque personne, c'est ça qui bâtit une réputation de professionnalisme — pas la technique la plus récente dans ton arsenal."},
    {"type":"info","content":"La fibre peut constituer une option bien adaptée pour les ongles naturels fins, cassants, ou dans le cadre d'un accompagnement progressif de la repousse — selon l'état de l'ongle et l'objectif.\nPour les rallongements importants → orienter vers l'acrygel ou les capsules.\nLe choix de la technique se fait toujours en fonction de la cliente et de la situation, pas de tes préférences du moment."}
  ]$cb$::jsonb);

  -- ── L 1.5 — Quand proposer / refuser la fibre ─────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Quand proposer la fibre — et quand la refuser', 4, 12, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Proposer une technique à la bonne cliente, c'est bien. Savoir la refuser quand ce n'est pas approprié, c'est encore mieux — et c'est ce qui distingue une prothésiste sérieuse d'une prothésiste pressée.\n\nUn refus professionnel n'est jamais une perte de cliente : c'est un acte de confiance. Une cliente à qui tu expliques honnêtement pourquoi tu ne peux pas faire sa pose aujourd'hui reviendra. Une cliente qui repart avec une pose sur un ongle inadapté, et qui en pâtit, ne reviendra peut-être pas."},
    {"type":"section","label":"VOIR"},
    {"type":"material","title":"GO — Fibre indiquée","items":[
      "Ongles naturels fins ou cassants",
      "Ongles rongés (suivi esthétique progressif de la repousse)",
      "Ongles fragilisés par des poses précédentes",
      "Renfort discret avant événement",
      "Clientes sensibles aux produits lourds",
      "Ongles courts à laisser naturels mais renforcés"
    ]},
    {"type":"material","title":"ATTENTION — Observer avant de décider","items":[
      "Ongle très abîmé (évaluer la surface viable)",
      "Couches de VSP existantes difficiles à retirer",
      "Cliente qui ne sait pas si elle est allergique aux gels",
      "Ongle avec une zone sèche ou fragilisée côté cuticule",
      "Cliente qui veut un rallongement important (adapter l'attente)"
    ]},
    {"type":"material","title":"REFUSER / REPORTER — Ne pas poser","items":[
      "Anomalie visible sur l'ongle (coloration inhabituelle, décollement de plaque)",
      "Douleur signalée à la pression ou au toucher",
      "Infection visible ou suspectée dans la zone",
      "Traitement médical en cours sur les ongles ou la peau",
      "Ongle rongé au sang ou avec plaie ouverte"
    ]},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Checklist d'observation préalable — à intégrer à chaque prise en charge","items":[
      "Les ongles sont naturels et propres (pas de résidu de pose précédente gênant)",
      "Pas de coloration inhabituelle sur la plaque (blanc, jaune, vert, brun anormal)",
      "Pas de décollement visible de la plaque de la matrice",
      "Pas de douleur signalée à la pression ou en touchant les ongles",
      "Aucune plaie ouverte ou infection visible dans la zone de travail",
      "La demande de la cliente est compatible avec ce que la technique peut apporter",
      "La cliente a été informée de ce qu'elle peut attendre du résultat"
    ]},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"je_maitrise","content":"Je suis capable d'évaluer rapidement si une cliente est un profil fibre, de m'adapter à sa situation, et d'expliquer ma décision — qu'il s'agisse d'une pose ou d'un refus — avec calme et professionnalisme."},
    {"type":"warning","content":"Ni diagnostic, ni traitement. En cas d'anomalie visible (coloration inhabituelle, décollement de plaque, douleur), la réponse professionnelle est toujours la même : reporter la prestation et orienter vers un médecin ou un dermatologue.\n\nCe n'est pas ton rôle de nommer ce que tu vois, d'en établir la cause, ni de proposer un soin. Ton rôle est de reconnaître qu'il y a quelque chose d'anormal, de ne pas poser, et d'orienter la cliente vers le professionnel compétent. C'est précisément ça, le professionnalisme."},
    {"type":"info","content":"Un refus professionnel et bienveillant construit la confiance — pas la méfiance.\nTon rôle : reconnaître une anomalie visible et orienter. Jamais diagnostiquer ni traiter.\nLa checklist d'observation préalable = ton premier réflexe avant chaque prise en charge."},
    {"type":"text","content":"Cas pratique — Une nouvelle cliente arrive pour une pose fibre. En regardant ses ongles, tu remarques que le pouce gauche a une zone légèrement jaunâtre sous la plaque, vers le bord libre. Elle dit que « c'est comme ça depuis un moment » et ne ressent aucune douleur. Que fais-tu ?"},
    {"type":"info","content":"✓ Tu arrêtes l'observation sur cet ongle et tu ne poses pas dessus. Une coloration inhabituelle sous la plaque peut avoir des origines très diverses. Tu n'as pas à l'identifier : ce n'est pas ton rôle. Tu expliques calmement à la cliente que tu observes quelque chose d'inhabituel sur ce pouce et que tu ne peux pas poser sur cette zone sans avis médical préalable. Tu lui recommandes de consulter un médecin ou un dermatologue.\n\nConcernant les autres ongles : évalue si l'anomalie est isolée ou si elle pourrait être liée à une condition qui touche l'ensemble des ongles. En cas de doute ou de suspicion d'une cause pouvant affecter d'autres zones, il est préférable de reporter l'ensemble de la prestation et d'orienter vers un professionnel de santé. Ce n'est jamais une décision facile à prendre devant une cliente, mais c'est la posture juste — et une cliente qui comprend ta rigueur te fera davantage confiance."}
  ]$cb$::jsonb);

END $seed$;
