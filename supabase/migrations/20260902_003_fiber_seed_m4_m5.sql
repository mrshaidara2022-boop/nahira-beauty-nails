-- Fiber Signature — Seed M4 (5 leçons) + M5 (5 leçons)
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- Médias : blocs placeholder uniquement

DO $seed$
DECLARE
  cid UUID;
  mid UUID;
BEGIN

  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature';

  -- ══════════════════════════════════════════════════════════════════════════
  -- MODULE 4 — Observation préalable & préparation de l'ongle naturel
  -- ══════════════════════════════════════════════════════════════════════════
  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Observation préalable & préparation de l''ongle naturel', 4) RETURNING id INTO mid;

  -- ── L 4.1 — L'observation préalable ──────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'L''observation préalable — ce que tu regardes avant de toucher', 0, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"L'observation préalable est la première étape de toute prestation. Elle précède la préparation et la pose. Elle dure généralement 2 à 3 minutes et conditionne toutes les décisions techniques qui suivront."},
    {"type":"text","content":"Cette observation n'est pas un diagnostic médical — tu n'es pas professionnelle de santé. C'est une lecture visuelle et tactile de l'état de l'ongle naturel, qui te permet d'évaluer la compatibilité avec le protocole envisagé et d'adapter ton approche si nécessaire."},
    {"type":"text","content":"Une observation sérieuse t'évite de :\n• Poser sur un ongle qui présente une contre-indication à la pose\n• Choisir un protocole inadapté à l'état de la plaque\n• Découvrir trop tard une anomalie qui aurait dû orienter ton choix\n• Te trouver dans une situation délicate que tu ne peux pas gérer en cours de prestation"},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["Zone","Ce que tu regardes","Signaux d'alerte"],"rows":[
      ["La plaque unguéale","Couleur, opacité, brillance naturelle, texture de surface, épaisseur apparente","Coloration inhabituellement blanche, jaune, verte ou brune ; taches isolées ; ongle très fin ou au contraire très épais"],
      ["Le bord libre","Longueur, forme, présence d'un ancien produit, état de la découpe","Produit résiduel décollé ou soulevé ; bord effiloché, cassé, irrégulier"],
      ["Les cuticules et replis","État de la peau, présence d'envies, petites lésions, rougeurs","Coupures fraîches, irritation visible, peau anormalement sèche ou gonflée"],
      ["La peau environnante","Couleur de la peau, aspect des doigts autour de l'ongle","Rougeur diffuse, gonflement, traces d'irritation chronique"]
    ]},
    {"type":"placeholder","media_type":"image","description":"Photo comparative : ongle sain vs. ongle avec signaux d'alerte — à ajouter depuis l'Atelier Nahira"},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Exercice d'observation guidée : Prends ta propre main ou celle d'un proche. Effectue l'observation sur les 10 ongles selon la grille ci-dessous."},
    {"type":"table","headers":["Zone","Observation","Signal identifié"],"rows":[
      ["Plaque","Couleur uniforme ? Texture régulière ?","☐ Aucun / ☐ À noter"],
      ["Bord libre","Ancien produit ? Bord intact ?","☐ Aucun / ☐ À noter"],
      ["Cuticules","Peau saine ? Pas de lésion ?","☐ Aucun / ☐ À noter"],
      ["Peau environnante","Pas de rougeur ni irritation ?","☐ Aucun / ☐ À noter"]
    ]},
    {"type":"text","content":"Note tes observations par ongle. Si tu identifies un signal d'alerte sur un ou plusieurs ongles, réfléchis à comment adapter le protocole — ou si une consultation médicale préalable serait à orienter."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"Réponds à ces questions avant de valider la leçon :\n• Quelles sont les 4 zones à observer systématiquement ?\n• Quelle est la différence entre \"observer\" et \"diagnostiquer\" ?\n• Si tu vois une coloration verte localisée sous la plaque, que fais-tu ?\n• Pourquoi une observation sérieuse protège-t-elle à la fois la cliente et toi ?"},
    {"type":"warning","content":"Erreur fréquente : sauter l'observation pour \"aller plus vite\" — surtout sur les clientes régulières que tu penses bien connaître. L'état de l'ongle peut évoluer d'une session à l'autre. L'observation n'est pas optionnelle : elle fait partie intégrante du protocole professionnel."},
    {"type":"tip","content":"Développe un rituel d'observation systématique au début de chaque prestation : une lumière dédiée, une loupe si besoin, et 2 à 3 minutes réservées dans ton planning. Verbalise ce que tu observes à voix haute avec la cliente — ça la rassure, la valorise, et renforce ta posture professionnelle."},
    {"type":"info","content":"• L'observation précède toujours la préparation et la pose\n• Tu observes 4 zones : plaque, bord libre, cuticules, peau environnante\n• Tu n'es pas là pour diagnostiquer — tu évalues la compatibilité avec le protocole\n• Un signal d'alerte ne signifie pas forcément l'arrêt de la session — mais il oriente toujours ta décision"},
    {"type":"je_maitrise","items":[
      "Je peux citer les 4 zones d'observation sans hésiter",
      "Je sais distinguer une observation professionnelle d'un diagnostic médical",
      "Je sais comment réagir face à un signal d'alerte visible sur un ou plusieurs ongles",
      "J'intègre l'observation comme étape à part entière dans chaque prestation"
    ]}
  ]$cb$::jsonb);

  -- ── L 4.2 — Compatibilité et décision ────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Compatibilité et décision — poser, adapter ou reporter ?', 1, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"À l'issue de l'observation préalable, tu prends une décision. Ce n'est pas toujours binaire : il ne s'agit pas uniquement de \"poser\" ou \"ne pas poser\". Il existe une troisième voie — adapter le protocole — qui est souvent la plus pertinente dans les situations intermédiaires."},
    {"type":"text","content":"Ta grille de décision repose sur 3 niveaux :\n\n🟢 Poser selon le protocole standard — Ongles sains, aucun signal d'alerte, cliente informée et accord donné.\n\n🟠 Adapter le protocole — Situation particulière identifiée (ongle fin, ongles rongés en repousse, restes d'ancien produit à retirer délicatement, etc.) qui nécessite un ajustement technique sans contre-indication formelle.\n\n🔴 Reporter la session ou éviter l'ongle concerné — Signal d'alerte suggérant une anomalie incompatible avec la pose ou nécessitant un avis médical préalable. Une session reportée est une décision professionnelle, pas un refus."},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["Situation observée","Niveau","Orientation"],"rows":[
      ["Plaque saine, cuticules en bon état, aucun signal","🟢","Protocole standard"],
      ["Ongles rongés courts mais épiderme sain","🟠","Adapter : technique adaptée au bord libre court, informer la cliente"],
      ["Ongle très fin ou fragilisé","🟠","Adapter : construction plus douce, moins de limage, gel fluide"],
      ["Restes d'ancien produit non retirés","🟠","Dépose complète d'abord, puis réévaluer"],
      ["Petite coupure fraîche sur un repli latéral","🟠","Éviter le contact produit sur cette zone, reporter si trop proche de la plaque"],
      ["Coloration verte localisée sous la plaque","🔴","Ne pas poser, informer la cliente, orienter vers médecin"],
      ["Décollement important de la plaque","🔴","Reporter la session, orienter vers médecin"],
      ["Inflammation visible des replis","🔴","Reporter la session"]
    ]},
    {"type":"text","content":"Cette grille est un outil d'aide à la décision, non une liste exhaustive. Chaque situation s'évalue dans son contexte global."},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Pour chacune des situations suivantes, indique ta décision (🟢 / 🟠 / 🔴) et explique pourquoi :\n• Ongle légèrement strié en surface, cliente habituée depuis 2 ans, aucun autre signal\n• Ongle présentant une zone blanche mate à l'extrémité (possible traumatisme ancien)\n• Cuticules très sèches avec petites crevasses, sans lésion ouverte\n• Rougeur diffuse autour d'un ongle depuis \"quelques jours\" selon la cliente\n\nCompare tes réponses avec les éléments des leçons M3.L5 et M4.L1."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"• Quels sont les 3 niveaux de décision possibles après observation ?\n• Quelle est la différence entre \"adapter le protocole\" et \"reporter la session\" ?\n• Comment expliques-tu à une cliente que tu préfères ne pas poser sur un ongle aujourd'hui ?"},
    {"type":"warning","content":"Erreur fréquente : laisser la cliente décider à ta place. C'est elle l'experte de sa vie — mais toi l'experte de l'ongle. Si ta décision professionnelle est de ne pas poser, cette décision reste la tienne, quelle que soit la pression de la cliente."},
    {"type":"tip","content":"Pour annoncer un report de session sans créer de tension : \"Je ne veux pas prendre de risque pour toi — je préfère attendre que l'ongle soit dans les meilleures conditions. On se revoit dès que c'est bon.\" Courte, ferme, bienveillante. Pas d'hésitation dans la voix."},
    {"type":"info","content":"• 3 niveaux de décision : poser en standard / adapter le protocole / reporter\n• La décision appartient à la prothésiste, pas à la cliente\n• Un report n'est pas un refus — c'est une décision professionnelle motivée\n• En cas de doute sur la contagiosité d'une anomalie : reporter la session entière"}
  ]$cb$::jsonb);

  -- ── L 4.3 — Préparation de la plaque ─────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Préparation de la plaque unguéale — le protocole étape par étape', 2, 12, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La préparation de la plaque conditionne directement la tenue de la pose. Une mauvaise préparation est l'une des premières causes de décollements prématurés, de soulèvements aux cuticules ou de manque d'adhérence.\n\nL'objectif de la préparation est triple :\n• Nettoyer — éliminer toute trace de gras, d'huile, d'humidité résiduelle et d'ancien produit\n• Texturiser légèrement — créer un support micro-poreux favorable à l'adhésion sans amincir la plaque\n• Délimiter proprement la zone de travail — cuticules et replis latéraux dégagés, sans lésion induite"},
    {"type":"text","content":"La préparation n'est pas une étape agressive. On ne lime pas profondément la plaque pour \"mordre dedans\" — ce type de préparation excessif fragilise la plaque naturelle et n'est pas nécessaire avec les gels actuels."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"video","description":"Vidéo — Protocole de préparation complet : démonstration étape par étape en mains serrées — à ajouter depuis l'Atelier Nahira"},
    {"type":"text","content":"Séquence à observer dans la vidéo :\n• La quantité de lime utilisée sur la plaque\n• La direction du limage (toujours dans un sens, sans va-et-vient agressif)\n• Le positionnement de la lime par rapport aux cuticules\n• La quantité de dégraissant utilisée et le séchage avant dégraissage"},
    {"type":"section","label":"FAIRE"},
    {"type":"step","number":1,"title":"Nettoyer les mains","content":"Cliente et toi. Solution désinfectante ou eau + savon selon ton protocole hygiène (voir M3.L2)."},
    {"type":"step","number":2,"title":"Retirer tout produit résiduel","content":"Si la cliente porte un gel ou vernis semi, déposer proprement avant de commencer (voir Module 7 — Dépose)."},
    {"type":"step","number":3,"title":"Repousser doucement les cuticules","content":"Avec un repousse-cuticules adapté (bâtonnet en bois ou spatule en inox). Pas de découpe sauf si tu es formée à cette technique. Mouvements doux, sans forcer."},
    {"type":"step","number":4,"title":"Limer légèrement la surface","content":"Avec une lime fine (grain 180–220 à titre indicatif, à adapter selon l'état de la plaque et le produit utilisé). Objectif : créer une légère micro-texture sans amincir la plaque. Distance des cuticules : garder une marge suffisante pour éviter tout contact accidentel avec la peau."},
    {"type":"step","number":5,"title":"Ôter la poussière","content":"Avec une brosse propre dédiée ou une bombe d'air comprimé. Ne pas souffler avec la bouche sur l'ongle."},
    {"type":"step","number":6,"title":"Dégraisser la plaque","content":"Avec le dégraissant préconisé par ton fabricant de gel. Appliquer sur une compresse non-tissée. Laisser sécher complètement — ne pas polymériser avant que le dégraissant soit évaporé."},
    {"type":"step","number":7,"title":"Ne pas toucher la plaque après dégraissage","content":"Toute trace de gras ou d'humidité annule le nettoyage. Passe directement à l'application de la base."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"• Quels sont les 3 objectifs de la préparation de la plaque ?\n• Pourquoi ne faut-il pas limer agressivement la plaque ?\n• Que se passe-t-il si tu appliques le gel avant que le dégraissant soit complètement évaporé ?\n• Pourquoi ne faut-il pas souffler sur l'ongle avec la bouche après le limage ?"},
    {"type":"warning","content":"Erreur fréquente : limer en va-et-vient rapide pour \"gagner du temps\". Ce mouvement génère de la chaleur par friction et peut provoquer une sensation de brûlure désagréable — et surtout il fragilise les couches superficielles de la plaque sans améliorer l'adhérence. Un limage précis et orienté dans un sens suffit."},
    {"type":"warning","content":"Erreur fréquente : toucher l'ongle avec les doigts après dégraissage — par habitude, pour vérifier, ou pour remettre en place quelque chose. Ce geste redépose du gras sur la plaque et compromet l'adhérence. Entraîne-toi à ne plus toucher la plaque après cette étape."},
    {"type":"tip","content":"Prépare tes compresses de dégraissage à l'avance, en petites quantités. Utilise une compresse propre à chaque application afin de prévenir toute contamination croisée entre les ongles. La qualité de la préparation se voit dans la durée de tenue."},
    {"type":"info","content":"• 7 étapes dans l'ordre : mains propres → dépose → cuticules → limage léger → poussière → dégraissage → ne plus toucher\n• Pas de va-et-vient : limer dans un sens, à distance des cuticules\n• Le dégraissant doit être sec avant toute application de produit\n• La préparation n'est pas agressive — elle est précise"},
    {"type":"je_maitrise","items":[
      "Je connais les 7 étapes de préparation dans leur ordre exact",
      "Je sais pourquoi le limage doit rester léger",
      "Je comprends pourquoi le dégraissant doit sécher avant toute application",
      "J'identifie les erreurs à éviter et je sais comment les corriger dans ma pratique"
    ]}
  ]$cb$::jsonb);

  -- ── L 4.4 — Préparation des cuticules ────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Préparation des cuticules et des contours — précision et respect du tissu', 3, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Les cuticules et les replis latéraux sont les zones les plus délicates à préparer. Elles constituent une barrière naturelle de protection entre l'ongle et la peau. Une préparation mal exécutée sur ces zones peut provoquer :\n• Des irritations ou micro-lésions qui ouvrent la voie à des infections\n• Des soulèvements aux cuticules liés à du produit posé trop près ou sur la peau\n• Un inconfort ou une douleur pendant ou après la prestation"},
    {"type":"text","content":"L'objectif n'est pas d'éliminer les cuticules — c'est de dégager proprement la plaque pour que le produit n'entre pas en contact avec la peau. Cette marge de sécurité est d'environ 0,5 à 1 mm entre l'application de produit et la cuticule.\n\nDeux zones distinctes :\n• Cuticule proximale (arrière de l'ongle, proche de la lunule) : zone fine et adhérente qu'on repousse doucement — jamais coupée sans formation spécifique\n• Replis latéraux (côtés de l'ongle) : zone de peau encaissée autour de la plaque — à dégager délicatement avec le repousse-cuticules, sans forcer ni blesser"},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Photo : avant / après préparation des cuticules — planche comparative montrant la marge entre produit et cuticule — à ajouter depuis l'Atelier Nahira"},
    {"type":"text","content":"Signaux d'une bonne préparation des contours :\n• La peau autour de l'ongle est intacte — aucune rougeur, aucune micro-lésion\n• La plaque est proprement dégagée au niveau des replis et de la cuticule proximale\n• Aucun lambeau de peau n'est décollé ou irrité\n• La zone est prête à recevoir le produit sans risque de contact avec la peau"},
    {"type":"section","label":"FAIRE"},
    {"type":"step","number":1,"title":"Ramollir les cuticules si nécessaire","content":"Avec un soin ramollissant cuticules compatible avec la suite du protocole. Éviter le trempage à l'eau avant une pose gel : l'humidité résiduelle, même invisible, compromet l'adhérence des produits. Si un soin aqueux est utilisé, sécher la plaque et la peau environnante de façon complète et prolongée avant toute application de produit."},
    {"type":"step","number":2,"title":"Repousser la cuticule proximale","content":"Bâtonnet en bois ou repousse en inox, mouvements circulaires doux. Pas de pression excessive. Si la cuticule résiste, c'est qu'elle n'est pas suffisamment ramollie — ne pas forcer."},
    {"type":"step","number":3,"title":"Dégager les replis latéraux","content":"Avec la pointe du repousse-cuticules, descendre doucement dans le sillon latéral pour dégager la plaque sans blesser la peau."},
    {"type":"step","number":4,"title":"Vérifier visuellement la marge","content":"S'assurer que la plaque est bien dégagée sur tout le pourtour, et que la marge de sécurité (0,5-1 mm) sera respectée lors de l'application du produit."},
    {"type":"step","number":5,"title":"Ôter délicatement les petites peaux détachées","content":"Avec un coupe-cuticules adapté si tu es formée, ou en laissant la cliente les prendre en charge elle-même si tu ne l'es pas. Ne jamais couper ce qui n'est pas clairement détaché."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"• Quelle est la marge de sécurité à respecter entre le produit et la cuticule ?\n• Quelle est la différence entre la cuticule proximale et les replis latéraux ?\n• Que faire si la cuticule résiste lors du repoussage ?\n• Pourquoi doit-on sécher complètement l'ongle après un trempage ou un soin avant d'appliquer le produit ?"},
    {"type":"warning","content":"Erreur fréquente : appliquer le produit trop près de la cuticule pour \"couvrir au maximum la plaque\". Cette pratique provoque des soulèvements aux cuticules dans les jours qui suivent — le produit en contact avec la peau ne tient pas. La marge de 0,5–1 mm est un repère pédagogique : le principe fondamental est l'absence de tout contact entre le produit et la peau, quelle que soit la valeur exacte."},
    {"type":"tip","content":"Un bon éclairage latéral (lampe de travail légèrement inclinée) te permet de voir l'ombre de la cuticule sur la plaque et d'évaluer précisément ta marge avant d'appliquer le gel. Prends l'habitude de changer légèrement l'angle de la lumière lors de cette étape."},
    {"type":"info","content":"• Cuticules et replis latéraux sont à traiter séparément avec des gestes adaptés\n• La marge de sécurité entre produit et peau est de 0,5 à 1 mm\n• On ne coupe pas ce qu'on n'est pas formée à couper\n• L'humidité doit être totalement évaporée avant toute application de produit"}
  ]$cb$::jsonb);

  -- ── L 4.5 — Adapter la préparation ───────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Adapter la préparation à l''état de l''ongle — situations courantes', 4, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Le protocole de préparation standard convient à la majorité des situations — mais il doit pouvoir s'adapter. Chaque cliente arrive avec un historique de ses ongles : habitudes de soin, anciens produits, mode de vie, état de la plaque du moment."},
    {"type":"text","content":"Adapter la préparation ne signifie pas la simplifier — cela signifie choisir les outils, les pressions et les étapes en fonction de ce que tu observes. L'objectif reste identique : surface propre, légèrement texturisée, sèche, dégraissée."},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["État de l'ongle observé","Adaptation de la préparation"],"rows":[
      ["Ongle fin ou fragile","Limage très doux ou supprimé — se concentrer sur le nettoyage et le dégraissage. Si un limage est indispensable, utiliser un grain fin (220 ou plus, à titre indicatif — adapter selon l'état de la plaque). Éviter toute pression sur la plaque."],
      ["Ongle strié (stries longitudinales)","Limage doux dans le sens des stries — ne jamais travailler perpendiculairement aux stries. Préparation douce, hydratation recommandée après la prestation."],
      ["Ongle avec résidus d'ancien gel ou vernis","Dépose complète et soigneuse avant toute repréparation. Ne jamais poser par-dessus un produit résiduel — risque de décollement immédiat."],
      ["Ongle rongé ou très court","Préparer la surface existante selon le protocole standard. Adapter la pose au bord libre disponible (voir M5). Pas de forçage sur des zones trop petites."],
      ["Ongle en repousse active (suivi progressif)","Travailler uniquement sur la zone de plaque existante. Respecter la progression naturelle. Ne pas chercher à \"compenser\" la longueur avec trop de matière."],
      ["Ongle avec texture irrégulière de surface","Limage ciblé sur les zones irrégulières, pas sur la totalité de la plaque. Objectif : surface homogène, non lissée à l'excès."]
    ]},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Pour chacune des situations suivantes, décris l'adaptation que tu appliquerais à la préparation :\n• Ongle naturellement fin avec des stries légères, cliente qui veut une pose douce\n• Ongle ayant porté un gel souple pendant 3 semaines, pas encore complètement décollé\n• Ongle de repousse : la cliente suivait un accompagnement progressif après avoir arrêté de se ronger les ongles"},
    {"type":"warning","content":"Erreur fréquente : appliquer le même protocole de limage à tous les ongles quelle que soit leur état. Une plaque fine et une plaque épaisse ne se préparent pas avec la même pression ni le même grain. Adapter est une compétence — pas une contrainte."},
    {"type":"info","content":"• Le protocole standard s'adapte, il ne s'applique pas mécaniquement\n• L'objectif reste identique : plaque propre, légèrement texturisée, sèche, dégraissée\n• Plus la plaque est fragile, plus la préparation est douce\n• Un résidu d'ancien produit se dépose toujours complètement avant de reposer"},
    {"type":"je_maitrise","items":[
      "Je sais adapter mon limage en fonction de l'épaisseur et de l'état de la plaque",
      "Je connais les situations qui nécessitent une préparation modifiée",
      "Je sais gérer un ongle fragilisé par une dépose maison sans créer plus de dommages",
      "Je comprends que l'adaptation est une compétence professionnelle, pas une exception"
    ]}
  ]$cb$::jsonb);

  -- ══════════════════════════════════════════════════════════════════════════
  -- MODULE 5 — Technique de pose — la méthode Fiber Signature
  -- ══════════════════════════════════════════════════════════════════════════
  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Technique de pose — la méthode Fiber Signature', 5) RETURNING id INTO mid;

  -- ── L 5.1 — Logique de construction ──────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'La logique de construction — comprendre les couches avant de les poser', 0, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La pose fibre de verre n'est pas une accumulation de couches appliquées au hasard. C'est un système de construction structuré, dans lequel chaque couche joue un rôle défini et conditionne la qualité de la suivante."},
    {"type":"text","content":"La méthode Fiber Signature repose sur une logique en 5 niveaux :"},
    {"type":"table","headers":["Niveau","Couche","Rôle principal"],"rows":[
      ["1","Base d'adhésion (rubber base ou primer selon le protocole choisi)","Créer l'ancrage entre la plaque naturelle et le système de construction"],
      ["2","Première couche de gel + positionnement de la fibre","Fixer la fibre, créer la première couche de renfort"],
      ["3","Encapsulation complète de la fibre","Noyer la fibre dans le gel pour l'intégrer au système — aucun filament apparent"],
      ["4","Couche(s) de construction de l'apex","Créer le cambre et l'architecture de l'ongle — épaisseur maîtrisée là où la résistance est nécessaire"],
      ["5","Couche de scellement (top coat ou gel de finition)","Protéger, unifier la surface, préparer aux finitions esthétiques"]
    ]},
    {"type":"text","content":"Cette logique est une structure de référence. Le nombre de couches exactes peut varier selon l'épaisseur de la fibre utilisée, la viscosité du gel, l'état de l'ongle naturel, et l'objectif esthétique. Ce que tu apprends ici est la logique — pas une recette figée à reproduire à l'identique à chaque fois."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Schéma — Coupe transversale d'une pose fibre de verre : représentation en coupe des 5 niveaux de construction — à ajouter depuis l'Atelier Nahira"},
    {"type":"text","content":"Dans le schéma, observe :\n• La position de la fibre par rapport à la plaque naturelle (ni trop haute, ni collée à la plaque)\n• La zone de l'apex — là où la construction est la plus épaisse proportionnellement\n• La progressivité de l'épaisseur : fine aux cuticules, fine au bord libre, plus présente à l'apex"},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"• Quels sont les 5 niveaux de construction de la méthode Fiber Signature ?\n• Quel est le rôle de la base d'adhésion dans la construction ?\n• Pourquoi parle-t-on de \"logique de construction\" plutôt que de \"recette fixe\" ?\n• Où se situe l'apex dans la construction, et pourquoi est-il important ?"},
    {"type":"info","content":"• 5 niveaux de construction : base → première couche + fibre → encapsulation → apex → scellement\n• Chaque couche a un rôle défini — l'ordre n'est pas arbitraire\n• La logique s'adapte — le nombre de couches peut varier selon les matériaux et l'objectif\n• La fibre s'intègre dans le gel — jamais posée directement sur la plaque nue. Le support exact d'application varie selon le système et les instructions du fabricant."}
  ]$cb$::jsonb);

  -- ── L 5.2 — Application de la base d'adhésion ────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Application de la base d''adhésion — ancrer le système', 1, 12, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La base d'adhésion est la première couche appliquée sur la plaque préparée. Elle crée le lien entre la plaque naturelle et le système de gel qui va suivre. Sans une base correctement appliquée et polymérisée, le reste de la construction repose sur une fondation instable."},
    {"type":"text","content":"Deux types de bases sont couramment utilisées dans les systèmes de construction fibre de verre :\n• La rubber base — base caoutchoutée, flexible, qui compense les légères irrégularités de la plaque. Vue en M2.L3. Polymérisée avant application de la fibre.\n• Le primer et gel d'apprêt — dans certains protocoles, une couche d'apprêt très fine est appliquée avant le gel de construction. Son usage dépend du système de gel choisi et des recommandations du fabricant."},
    {"type":"tip","content":"Note fabricant : la nature de la base, son temps de polymérisation et sa compatibilité avec le reste du système dépendent du fabricant de tes produits. Respecte toujours les instructions du fabricant — elles priment sur toute recommandation générique."},
    {"type":"text","content":"L'application de la base suit une logique de couche fine et homogène : trop épaisse, elle peut compromettre la tenue ; trop fine, elle laisse des zones sans adhérence suffisante. Elle doit être appliquée en respectant la marge cuticule vue en M4.L4."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"video","description":"Vidéo — Application de la rubber base / base d'adhésion : démonstration — quantité, geste, marge cuticule, polymérisation — à ajouter depuis l'Atelier Nahira"},
    {"type":"text","content":"Dans la vidéo, observe :\n• La quantité de produit prélevée sur le pinceau\n• Le sens et la fluidité du geste d'application\n• La marge laissée autour des cuticules et des replis latéraux\n• L'aspect de la couche avant et après polymérisation"},
    {"type":"text","content":"Signaux d'une base bien appliquée :\n• Couche fine, homogène, sans bulles ni zone blanche mate\n• Marge respectée : aucun contact avec la peau\n• Après polymérisation : surface légèrement collante (couche inhibée) si préconisé par le fabricant, ou surface sèche selon le produit\n\nSignaux d'alerte :\n• Couche trop épaisse : risque de bulle, de polymérisation incomplète et de tenue compromise\n• Débordement sur la peau : risque de soulèvement aux cuticules dès les premiers jours\n• Zones non couvertes : zone sans adhérence, risque de décollement localisé"},
    {"type":"section","label":"FAIRE"},
    {"type":"step","number":1,"title":"Vérifier que la plaque est parfaitement préparée","content":"Dégraissée, sèche, sans contact des doigts depuis le dégraissage."},
    {"type":"step","number":2,"title":"Prélever la bonne quantité de produit","content":"Selon les instructions de ton fabricant. En règle générale : une petite quantité suffit pour une couche fine. Mieux vaut deux couches fines qu'une couche trop épaisse."},
    {"type":"step","number":3,"title":"Appliquer du centre vers les bords","content":"Ou selon la technique préconisée par ton fabricant. Le geste est fluide, sans va-et-vient excessif qui créerait des bulles d'air."},
    {"type":"step","number":4,"title":"Respecter la marge cuticule (0,5-1 mm)","content":"Et la marge latérale sur les replis. Corriger immédiatement si un débordement se produit."},
    {"type":"step","number":5,"title":"Polymériser selon le temps recommandé","content":"Dans la lampe adaptée à ton produit. Ne pas réduire le temps de polymérisation."},
    {"type":"step","number":6,"title":"Évaluer la couche polymérisée","content":"Uniforme, sans bulles, marge respectée. Si une zone a été oubliée, ajouter une microretouche avant de continuer."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"• Pourquoi la couche de base est-elle critique pour la tenue globale de la pose ?\n• Que se passe-t-il si la base est appliquée trop épaisse ?\n• Que se passe-t-il si elle déborde sur la peau ?\n• Pourquoi les instructions du fabricant priment-elles toujours sur les recommandations génériques ?"},
    {"type":"warning","content":"Erreur fréquente : polymériser trop peu de temps pour \"aller plus vite\". Une polymérisation incomplète de la base compromet toute l'adhérence du système. Respecte le temps indiqué par ton fabricant — même si la lampe t'indique \"terminé\" visuellement, c'est le temps recommandé qui compte, pas ton ressenti."},
    {"type":"tip","content":"Teste l'application de ta base sur un tip ou une fausse capsule avant de travailler sur cliente. Tu peux évaluer la fluidité, la quantité et la marge sans pression. C'est le meilleur moyen de t'approprier un nouveau produit avant de le mettre en pratique."},
    {"type":"info","content":"• La base crée l'ancrage entre la plaque et le système de gel\n• Application fine, homogène, marge cuticule respectée, polymérisation complète\n• Les instructions du fabricant prévalent toujours sur les recommandations génériques\n• Une zone oubliée se corrige avant de continuer — pas après"}
  ]$cb$::jsonb);

  -- ── L 5.3 — Découpe et positionnement de la fibre ────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Découpe et positionnement de la fibre — la précision avant tout', 2, 12, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La fibre de verre est le cœur du système de construction. Sa découpe et son positionnement sont des étapes qui demandent de la précision — une fibre mal découpée ou mal positionnée peut créer des aspérités, des zones de faiblesse, ou compromettre l'esthétique finale."},
    {"type":"text","content":"Deux paramètres fondamentaux à maîtriser :\n• La forme de la découpe — adaptée à la forme de l'ongle, elle doit couvrir la zone de renfort souhaitée sans déborder sur les replis ni sur les cuticules\n• Le positionnement — le support sur lequel la fibre est posée (couche de gel non polymérisée, couche intermédiaire spécifique ou autre) dépend du système de produits utilisé et des instructions du fabricant. Le principe général est que la fibre est intégrée dans le gel — pas posée sur la plaque nue"},
    {"type":"text","content":"La fibre ne s'applique jamais directement sur la plaque naturelle nue. Au-delà de ce principe, les modalités exactes de positionnement varient selon le système et doivent suivre les instructions du fabricant."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"video","description":"Vidéo — Découpe et positionnement de la fibre : démonstration — technique de découpe, positionnement sur l'ongle, ajustement — à ajouter depuis l'Atelier Nahira"},
    {"type":"step","number":1,"title":"Couper avec des ciseaux dédiés fibre","content":"Ciseaux fins, propres, avec une lame nette. Les ciseaux à usage général écrasent les filaments plutôt que de les trancher net."},
    {"type":"step","number":2,"title":"Mesurer sur l'ongle avant de couper","content":"Poser le morceau de fibre sur l'ongle à sec pour évaluer la forme et la taille, avant de couper définitivement."},
    {"type":"step","number":3,"title":"Couper net, en une seule pression","content":"Éviter les découpes en plusieurs petits coups qui effilochent le bord."},
    {"type":"step","number":4,"title":"Vérifier les bords","content":"Pas de filaments dépassants sur les côtés. Si des filaments sont visibles, retailler proprement."},
    {"type":"text","content":"Positionnement :\n• La fibre est positionnée sur la première couche de gel (non polymérisé dans la majorité des protocoles)\n• Elle est centrée sur la plaque, sans toucher les cuticules ni les replis latéraux\n• On la pose délicatement — puis on la presse doucement avec le pinceau ou un outil plat pour l'aplanir sans la déplacer\n• On vérifie à la lumière : la fibre doit être plate, sans plis ni bulles d'air emprisonnées dessous"},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Exercice de découpe à blanc : sans produit, entraîne-toi à découper et à positionner la fibre sur des tips ou des capsules vides.\n• Découper 5 morceaux de fibre de formes légèrement différentes (arrondie, carrée, effilée)\n• Mesurer et ajuster chaque morceau sur un tip de taille différente\n• Vérifier les bords de chaque morceau : pas de filaments effilochés\n• Simuler le positionnement sur les tips à sec — vérifier que la fibre est plane et centrée\n• Observer sous lumière directe : la fibre est-elle sans plis ?\n\nRépète cet exercice jusqu'à ce que la découpe soit régulière et le positionnement naturel."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"• Pourquoi faut-il des ciseaux dédiés pour découper la fibre ?\n• Pourquoi la fibre ne doit-elle pas être posée directement sur la plaque naturelle nue ?\n• Que se passe-t-il si la fibre déborde sur les replis latéraux ou les cuticules ?\n• Comment vérifier qu'aucune bulle d'air n'est emprisonnée sous la fibre ?"},
    {"type":"warning","content":"Erreur fréquente : découper la fibre trop grande et la \"plier\" pour qu'elle entre dans l'espace disponible. Une fibre pliée crée une épaisseur localisée et des filaments mal orientés — le résultat sera visible à la surface de la pose. Toujours mesurer avant de couper, et retailler si nécessaire."},
    {"type":"tip","content":"Prépare les morceaux de fibre pour tous les ongles avant de commencer la pose. Pose-les dans l'ordre sur un support propre (papier calque ou tip retourné). Tu travailles plus vite et plus précisément quand les morceaux sont prêts à l'avance — tu ne te bats pas avec les ciseaux les doigts encombrés de gel."},
    {"type":"info","content":"• Ciseaux dédiés, découpe nette en une seule pression\n• Mesurer sur l'ongle avant de couper définitivement\n• La fibre s'intègre dans le gel — elle n'est pas posée sur la plaque nue\n• Fibre plate, centrée, sans plis ni filaments dépassants après positionnement"}
  ]$cb$::jsonb);

  -- ── L 5.4 — Encapsulation de la fibre ────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Encapsulation de la fibre — noyer le renfort dans le système', 3, 13, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"L'encapsulation est l'étape qui intègre la fibre au système de gel. Sans encapsulation complète, les filaments restent en surface ou partiellement libres — et le résultat final sera soit visible (texture irrégulière), soit fragilisé (la fibre ne remplit pas son rôle de renfort si elle n'est pas solidarisée au gel)."},
    {"type":"text","content":"Encapsuler, c'est recouvrir complètement la fibre d'une couche de gel de manière à ce qu'aucun filament ne soit à l'air libre après polymérisation.\n\nDeux objectifs simultanés :\n• Couvrir tous les filaments — aucun fil ne dépasse\n• Maintenir la finesse de la construction — l'encapsulation n'est pas une couche épaisse, c'est une couche de gel adaptée qui noie la fibre sans créer une surépaisseur"},
    {"type":"text","content":"Une encapsulation incomplète est souvent détectable au toucher (aspérités sur la surface polymérisée) ou visuellement (texture visible sous lumière rasante). Elle doit être corrigée avant de continuer."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"video","description":"Vidéo — Encapsulation de la fibre : démonstration — application du gel d'encapsulation, technique de pinceau, vérification sous lumière — à ajouter depuis l'Atelier Nahira"},
    {"type":"text","content":"Ce qu'une encapsulation réussie ressemble :\n• Après polymérisation : surface homogène, aucune aspérité au toucher\n• Sous lumière directe : aucune zone de texture tissée visible en surface\n• La fibre est \"fondue\" dans le gel — elle renforce le système sans être perceptible\n\nSignaux d'alerte :\n• Filaments visibles en surface après polymérisation — encapsulation incomplète\n• Zone blanche ou opaque localisée — air emprisonné sous ou autour de la fibre\n• Aspérité perceptible au toucher — gel non homogène ou fibre non noyée"},
    {"type":"section","label":"FAIRE"},
    {"type":"step","number":1,"title":"Vérifier que la fibre est bien positionnée","content":"Plate, centrée, sans plis, sans filaments dépassant sur les côtés."},
    {"type":"step","number":2,"title":"Prélever la quantité de gel adaptée","content":"Ni trop, ni trop peu. Le gel doit recouvrir la fibre sans créer une surépaisseur. La viscosité du gel influence la facilité de cette étape (voir M2.L2)."},
    {"type":"step","number":3,"title":"Appliquer le gel en démarrant par le centre de la fibre","content":"Le gel \"tombe\" naturellement de part et d'autre. Guider avec le pinceau vers les bords."},
    {"type":"step","number":4,"title":"Appuyer doucement","content":"Avec le côté plat du pinceau ou une spatule dédiée, pour chasser l'air éventuel sous la fibre et uniformiser la couche."},
    {"type":"step","number":5,"title":"Vérifier sous lumière rasante avant polymérisation","content":"Tous les filaments sont-ils couverts ? Aucune zone sèche ou sans gel ?"},
    {"type":"step","number":6,"title":"Corriger si nécessaire","content":"Ajouter une micro-quantité de gel sur les zones manquantes avant de polymériser."},
    {"type":"step","number":7,"title":"Polymériser selon le temps recommandé","content":"Vérifier l'absence d'aspérités après polymérisation."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"• Qu'est-ce qu'une encapsulation incomplète, et comment la détectes-tu ?\n• Pourquoi l'encapsulation ne doit-elle pas être une couche trop épaisse ?\n• Comment corriger une zone de fibre partiellement non couverte avant polymérisation ?"},
    {"type":"warning","content":"Erreur fréquente : polymériser l'encapsulation sans vérifier sous lumière rasante. La lumière rasante est le seul moyen de voir les filaments encore en surface avant qu'il soit trop tard. Prends cette seconde de vérification — elle évite de devoir tout déposer et recommencer."},
    {"type":"tip","content":"Utilise un gel de viscosité intermédiaire pour l'encapsulation — ni trop fluide (risque de s'écouler sur les côtés avant polymérisation), ni trop épais (difficile à répartir uniformément sur la fibre). Si tu n'es pas sûre de la bonne viscosité pour cette étape, teste sur un tip avant de travailler sur cliente."},
    {"type":"info","content":"• Encapsuler = recouvrir complètement la fibre sans la voir après polymérisation\n• Gel appliqué du centre vers les bords, couche homogène sans surépaisseur\n• Vérification sous lumière rasante avant polymérisation — correction si besoin\n• Une aspérité détectée maintenant se corrige facilement ; ignorée, elle se retrouve dans toutes les couches suivantes"}
  ]$cb$::jsonb);

  -- ── L 5.5 — Apex + scellement + récapitulatif ─────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Construction de l''apex, couche de scellement et récapitulatif du protocole', 4, 15, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"heading","content":"L'apex et le cambre"},
    {"type":"text","content":"L'apex est la zone de l'ongle qui concentre le plus de contraintes mécaniques lors de l'utilisation du doigt. Elle correspond, à titre de repère, à la zone médiane de la plaque — mais sa position exacte et le volume à lui donner dépendent de la longueur, de la forme de l'ongle, de l'architecture souhaitée et du système de gel utilisé."},
    {"type":"text","content":"Construire l'apex, c'est différencier les volumes de façon proportionnée, créant un profil en légère courbe (le cambre) qui répartit les contraintes plutôt que de les concentrer."},
    {"type":"text","content":"L'apex n'est pas une bosse — c'est une épaisseur maîtrisée, proportionnée à l'ongle et à la longueur. Un apex trop épais alourdit l'ongle sans améliorer la résistance. Une construction sans différenciation de volume peut manquer d'équilibre architectural — l'objectif est une répartition proportionnée, pas une épaisseur maximale."},
    {"type":"heading","content":"La couche de scellement"},
    {"type":"text","content":"Une fois l'apex construit et polymérisé, une couche de finition (top coat ou gel de finition selon ton système) unifie l'ensemble de la surface. Elle :\n• Protège les couches sous-jacentes\n• Crée la surface lisse sur laquelle les finitions esthétiques seront appliquées\n• Scelle l'ensemble du système de construction"},
    {"type":"tip","content":"Note fabricant : le gel ou top coat de scellement, son temps de polymérisation, et la nécessité ou non de retirer la couche inhibée dépendent de ton fabricant. Suis toujours les instructions de ton système de produits."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"video","description":"Vidéo — Construction de l'apex + couche de scellement : démonstration — application du gel d'apex, profil du cambre, couche de scellement — à ajouter depuis l'Atelier Nahira"},
    {"type":"text","content":"Profil d'un ongle bien construit vu de côté :\n• Fine à la cuticule (surépaisseur légère)\n• Plus présente à l'apex (zone médiane — épaisseur maîtrisée selon l'ongle)\n• Fine au bord libre (proportionnée à la longueur de l'extension)\n• Profil courbe et harmonieux — pas plat, pas en bosse\n\nCes valeurs sont indicatives — elles varient selon la morphologie de l'ongle, le gel utilisé, et la longueur souhaitée. C'est le rapport entre les zones qui compte : fine/épaisse/fine dans les bonnes proportions."},
    {"type":"section","label":"FAIRE"},
    {"type":"heading","content":"Construction de l'apex"},
    {"type":"step","number":1,"title":"Identifier la zone apex sur l'ongle","content":"À titre de repère : zone médiane, dont la position et le volume s'adaptent à la longueur, à la forme et au système utilisé. La visualiser avant d'appliquer le gel."},
    {"type":"step","number":2,"title":"Déposer le gel en priorité sur la zone apex","content":"Le gel coule naturellement vers les bords. Le guider si nécessaire sans trop travailler."},
    {"type":"step","number":3,"title":"Contrôler le profil latéral","content":"Regarder l'ongle de côté pendant l'application pour évaluer le cambre. Ajouter ou retirer du gel si nécessaire avant polymérisation."},
    {"type":"step","number":4,"title":"Polymériser","content":"Selon le temps recommandé."},
    {"type":"step","number":5,"title":"Limer la surface si nécessaire","content":"Pour corriger une irrégularité localisée, affiner une zone trop épaisse, ou harmoniser le profil. Limage doux, grain à adapter selon le produit utilisé (150–180 à titre indicatif)."},
    {"type":"step","number":6,"title":"Ôter la poussière de limage","content":"Brosse propre, sans souffler avec la bouche."},
    {"type":"heading","content":"Couche de scellement"},
    {"type":"step","number":1,"title":"Dégraisser la surface si ton fabricant le préconise","content":"Pour retirer la couche inhibée après limage."},
    {"type":"step","number":2,"title":"Appliquer le top coat ou gel de finition","content":"Couche fine et homogène sur toute la surface."},
    {"type":"step","number":3,"title":"Polymériser","content":"Selon les instructions fabricant."},
    {"type":"step","number":4,"title":"Retirer la couche inhibée si nécessaire","content":"Selon ton produit."},
    {"type":"divider"},
    {"type":"heading","content":"Récapitulatif du protocole complet — Fiber Signature"},
    {"type":"table","headers":["#","Étape","Objectif","Point de vigilance"],"rows":[
      ["1","Observation préalable","Évaluer l'état de l'ongle et la compatibilité du protocole","Ne pas sauter — même sur cliente régulière"],
      ["2","Décision et accord de prestation","Confirmer le protocole, informer la cliente","Accord de prestation esthétique (selon protocole Nahira)"],
      ["3","Préparation de la plaque","Nettoyer, texturiser légèrement, dégraisser","Dégraissant sec avant toute application"],
      ["4","Préparation des cuticules et contours","Dégager proprement la zone de travail","Marge 0,5-1 mm respectée"],
      ["5","Application de la base d'adhésion","Créer l'ancrage entre plaque et système de gel","Couche fine, polymérisation complète"],
      ["6","Découpe et positionnement de la fibre","Intégrer le renfort textile au bon endroit","Fibre plate, centrée, bords nets"],
      ["7","Encapsulation de la fibre","Noyer la fibre dans le gel — aucun filament libre","Vérification sous lumière rasante avant polymérisation"],
      ["8","Construction de l'apex","Créer le profil de résistance — cambre maîtrisé","Fine-épaisse-fine en proportion, pas de bosse"],
      ["9","Couche de scellement","Unifier et protéger la surface","Instructions fabricant pour top coat"],
      ["10","Finitions esthétiques","Appliquer la couleur, nail art, vernis semi (voir Module 8)","Surface propre et dégraissée avant toute couleur"]
    ]},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"text","content":"Auto-évaluation finale du module 5 — avant de valider ce module, réponds à ces questions :\n• Quels sont les 5 niveaux de construction de la méthode Fiber Signature ?\n• Où se situe l'apex sur l'ongle, et quel est son rôle ?\n• Qu'est-ce qui différencie un apex réussi d'un apex trop épais ?\n• Pourquoi la couche de scellement n'est-elle pas optionnelle ?\n• Cite les 10 étapes du protocole complet dans le bon ordre."},
    {"type":"warning","content":"Erreur fréquente : construire un apex trop prononcé en pensant que \"plus épais = plus résistant\". La résistance vient de la qualité de l'encapsulation, de la fibre bien intégrée, et de la répartition proportionnée des couches — pas de l'épaisseur seule. Un ongle trop épais est inconfortable et moins esthétique, sans être mécaniquement supérieur."},
    {"type":"tip","content":"Contrôle le profil latéral de l'ongle à la lumière en cours de construction, avant de polymériser chaque couche d'apex. C'est le seul moment où tu peux encore retirer ou ajouter facilement du gel pour ajuster le cambre. Après polymérisation, tu corriges — mais c'est plus long."},
    {"type":"info","content":"• L'apex est une zone de différenciation de volume — sa position et son épaisseur s'adaptent à la longueur, à la forme et au système utilisé\n• Le profil idéal vu de côté : fine/épaisse/fine dans les bonnes proportions\n• La couche de scellement unifie et protège — ne pas la sauter\n• Le protocole complet compte 10 étapes dans l'ordre"},
    {"type":"je_maitrise","items":[
      "Je connais les 5 niveaux de construction de la méthode Fiber Signature",
      "Je sais appliquer la base, positionner et encapsuler la fibre, construire l'apex et sceller",
      "Je comprends pourquoi chaque étape a un rôle précis dans le système",
      "Je suis capable de citer les 10 étapes du protocole complet dans le bon ordre",
      "J'identifie les erreurs classiques à chaque étape et sais comment les corriger ou les éviter"
    ]}
  ]$cb$::jsonb);

END;
$seed$;
