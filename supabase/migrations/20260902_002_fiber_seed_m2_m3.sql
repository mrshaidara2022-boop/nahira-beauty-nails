-- Fiber Signature — Seed M2 (6 leçons) + M3 (6 leçons)
-- Project: mxbmjtzrggahbwahxmkp (Nahira Beauty Nails)
-- Médias : blocs placeholder uniquement

DO $seed$
DECLARE
  cid UUID;
  mid UUID;
BEGIN

  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature';

  -- ══════════════════════════════════════════════════════════════════════════
  -- MODULE 2 — Matériel professionnel
  -- ══════════════════════════════════════════════════════════════════════════
  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Matériel professionnel', 2) RETURNING id INTO mid;

  -- ── L 2.1 — Les fibres ────────────────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Les fibres — types, formats et critères de qualité', 0, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La fibre de verre pour onglerie se présente sous plusieurs formats : en bobine (mèche longue à découper à la mesure), en feuille (prédécoupée en bandes ou en carrés), ou en bandes prêtes à l'emploi. Ce ne sont pas des différences cosmétiques — chaque format a ses avantages selon ta façon de travailler.\n\nCe qui compte vraiment, c'est la qualité du tissu lui-même. Une fibre de qualité professionnelle présente des caractéristiques précises."},
    {"type":"material","title":"Critères d'une fibre de qualité professionnelle","items":[
      "Tissu fin et régulier — les filaments sont serrés et uniformes, sans zones grossières ni écarts dans le tissage",
      "Bonne stabilité dimensionnelle — la fibre ne se rétracte pas, ne se déforme pas et reste à plat une fois découpée",
      "Transparence à l'encapsulation — une fois couverte de gel et polymérisée, la fibre devient invisible ou quasi-invisible",
      "Tranchage net — avec des ciseaux adaptés, la coupe est franche, sans filaments qui s'effrangent",
      "Faible absorption d'humidité — une fibre qui absorbe l'humidité avant la pose adhère mal et risque de créer des zones opaques"
    ]},
    {"type":"text","content":"À l'inverse, une fibre de moindre qualité présente des signaux d'alerte : filaments qui s'effrangent à la coupe, zones de tissu irrégulières, blancheur résiduelle après polymérisation, ou tendance à bouger lors de l'application du gel."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Photo : différents formats de fibre (bande, feuille, mèche) sur fond blanc — texture visible, filaments apparents · À ajouter depuis l'Atelier Nahira"},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Exercice d'évaluation — évalue ta fibre sur 4 critères","items":[
      "Regarde-la en lumière directe — le tissu est-il régulier, sans trous ni zones grossières ?",
      "Découpe un petit morceau — les bords sont-ils nets ou les filaments partent-ils dans tous les sens ?",
      "Pose un morceau sur l'ongle à sec — reste-t-il plat ou se rétracte-t-il ?",
      "Encapsule un morceau test sur faux ongle — est-elle transparente après polymérisation ?"
    ]},
    {"type":"warning","content":"Erreur fréquente : utiliser des ciseaux à usage général (couture, bureau, cuisine) pour couper la fibre. Ces ciseaux ont souvent des lames micro-dentelées qui écrasent la fibre plutôt que de la trancher nettement. Résultat : bords effrochés, filaments libres qui ressortent au limage, encapsulation difficile aux extrémités. Un seul bon ciseau fin et dédié vaut mieux qu'une dizaine de paires inadaptées."},
    {"type":"tip","content":"Stocke ta fibre à l'abri de l'humidité et de la lumière directe — une boîte hermétique simple suffit. Une fibre qui a absorbé de l'humidité avant la pose peut présenter des zones d'adhérence insuffisante. Si ta fibre colle sur elle-même ou présente des reflets différents selon les lots, vérifie tes conditions de stockage avant d'incriminer la technique."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"Évalue la qualité de ta fibre sur 4 critères : régularité du tissu, netteté de coupe, tenue à plat, transparence à l'encapsulation.\nDes ciseaux adaptés et dédiés font partie du matériel — pas un luxe.\nLes conditions de stockage impactent la qualité de la fibre — protège-la de l'humidité."}
  ]$cb$::jsonb);

  -- ── L 2.2 — Les gels compatibles ──────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Les gels compatibles avec la fibre — viscosité, formulation, comportement', 1, 12, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Dans la méthode Fiber Signature, le gel n'est pas un simple liant — c'est le système de construction dans lequel la fibre est intégrée. Un gel mal choisi — trop fluide, trop épais, ou incompatible avec ta lampe — compromet l'ensemble de la pose, indépendamment de la qualité de la fibre et de ta technique.\n\nLe gel remplit plusieurs fonctions simultanées dans une pose fibre : adhérer à la plaque naturelle préparée, encapsuler la fibre complètement (aucun filament ne doit rester libre), former la structure de l'ongle, et se polymériser de façon homogène.\n\nLa résistance d'une pose fibre provient de la combinaison du renfort textile (la fibre) et du gel correctement appliqué et polymérisé. Les propriétés du gel — sa formulation, son architecture de couches, la quantité utilisée — contribuent à la tenue globale. Un gel de construction n'est pas solide parce qu'il est épais : c'est sa polymérisation correcte et son architecture maîtrisée qui font la qualité."},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["Viscosité du gel","Comportement observé","Conséquence sur la pose fibre"],"rows":[
      ["Trop fluide","Coule immédiatement, se rétracte vers les bords","Ne couvre pas uniformément la fibre — encapsulation incomplète"],
      ["Fluide à moyenne","S'étale facilement, se nivelle légèrement","Peut convenir pour des couches fines si technique maîtrisée, à surveiller"],
      ["Moyenne (builder)","Reste en place une fois posé, ne coule pas, s'étale au pinceau","Convient bien à la construction fibre — encapsulation contrôlable, position stable"],
      ["Très épaisse","Difficile à étaler finement, peut créer des bulles","Encapsulation délicate, risque de surépaisseur ou de zones mal couvertes"]
    ]},
    {"type":"placeholder","media_type":"image","description":"Photo : 3 pots de gel de viscosités différentes — comparaison visuelle · À ajouter depuis l'Atelier Nahira"},
    {"type":"tip","content":"Rappel fabricant : les temps de polymérisation, puissances requises et protocoles d'application de chaque gel sont définis par son fabricant. Ces informations priment sur toute autre recommandation — consultez toujours les instructions de votre gel spécifique."},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Évaluer ton gel sur faux ongle avant de travailler sur cliente","items":[
      "Applique une couche fine sur faux ongle préparé — reste-t-il en place ou coule-t-il ?",
      "Pose un morceau de fibre et couvre-le de gel — la fibre est-elle entièrement encapsulée ou voit-on des zones sèches ?",
      "Polymérise selon les instructions fabricant — la surface est-elle dure, propre, sans zones molles ?",
      "Lime légèrement — le gel est-il résistant et homogène, ou présente-t-il des zones friables ?"
    ]},
    {"type":"text","content":"Cas pratique — Tu appliques le gel sur la fibre et tu remarques que des zones restent visibles après la couche d'encapsulation — on voit encore la texture de la fibre à travers. Que se passe-t-il et que fais-tu ?"},
    {"type":"info","content":"✓ La fibre n'est pas correctement encapsulée — soit le gel est trop fluide et a coulé en dehors de la zone, soit la couche est trop fine, soit le pinceau n'a pas bien étalé le gel sur l'ensemble de la surface. Avant de polymériser, ajoute une quantité ciblée de gel avec la pointe du pinceau sur les zones non couvertes, et étale avec des gestes courts et contrôlés. Si le gel a déjà partiellement polymérisé, fais une légère polymérisation courte, puis reprends avec une couche supplémentaire ciblée."},
    {"type":"warning","content":"Erreur fréquente : associer automatiquement « gel épais = pose plus solide ». La résistance d'une pose fibre dépend de la qualité de l'encapsulation, de la polymérisation complète et de l'architecture de construction — pas de l'épaisseur brute de gel appliqué. Trop de gel peut créer une pose lourde, difficile à limer, et propice aux tensions aux points de jonction."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"Un gel de viscosité builder moyenne est généralement adapté à la construction fibre — il reste en place et permet une encapsulation contrôlée.\nLa résistance vient de la polymérisation correcte et de l'encapsulation complète, pas de l'épaisseur.\nTeste toujours un nouveau gel sur faux ongle avant de l'utiliser sur cliente.\nRespecte systématiquement les indications fabricant pour la polymérisation."}
  ]$cb$::jsonb);

  -- ── L 2.3 — La rubber base ────────────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'La rubber base — rôle complémentaire et limites', 2, 8, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La rubber base est souvent présentée comme un incontournable de l'onglerie contemporaine. Dans le contexte d'une pose fibre, son usage mérite d'être compris plutôt qu'automatique. Ce n'est pas une règle — c'est un outil avec des conditions d'utilisation précises.\n\nUne rubber base est une base de gel à polymérisation UV/LED formulée pour être flexible. Elle peut offrir plusieurs avantages : adhérence améliorée sur certains types d'ongles naturels, flexibilité qui absorbe une partie des micro-chocs, couverture des légères imperfections de la plaque.\n\nDans une construction fibre, la rubber base peut intervenir comme couche d'adhérence initiale, avant la pose de la fibre. Mais son usage n'est pas systématique et présente des limites à connaître."},
    {"type":"material","title":"Limites à connaître avant utilisation","items":[
      "Une rubber base trop souple sous la fibre peut créer une base instable pour la construction — la pose peut bouger légèrement, ce qui fragilise l'adhérence de la fibre dans le temps",
      "Toutes les rubber bases ne sont pas compatibles avec tous les gels de construction — la compatibilité chimique doit être vérifiée auprès des fabricants respectifs",
      "Sur certains ongles très secs ou très fragilisés, la rubber base peut ne pas apporter d'avantage mesurable par rapport à un primer adapté"
    ]},
    {"type":"tip","content":"Rappel fabricant : la compatibilité entre rubber base et gel de construction dépend des formulations. Ne jamais mélanger des produits de systèmes différents sans avoir vérifié la compatibilité auprès des fabricants concernés. Les instructions de chaque produit priment."},
    {"type":"tip","content":"Astuce Nahira : si tu hésites à utiliser une rubber base sur une nouvelle cliente, fais un test sur une ou deux poses avant de l'intégrer systématiquement. Observe la tenue sur 2–3 semaines. C'est la meilleure façon de valider si ce produit apporte un bénéfice réel dans ta technique et avec tes produits — pas une affirmation générale."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"La rubber base peut être un complément utile à la pose fibre, mais son usage n'est pas systématique.\nElle peut aider à l'adhérence sur certains profils d'ongles — à valider dans ta pratique.\nUne base trop souple sous la fibre peut fragiliser la structure — choisir un produit adapté à la construction.\nVérifier toujours la compatibilité avec ton gel de construction avant utilisation."}
  ]$cb$::jsonb);

  -- ── L 2.4 — Outils essentiels ─────────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Outils essentiels — et outils superflus', 3, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Avant d'acheter du matériel, il est utile de distinguer ce qui est réellement nécessaire de ce qui est du superflu marketing. Un kit bien pensé et de qualité vaut mieux qu'une quantité de produits peu adaptés."},
    {"type":"material","title":"Pour la fibre","items":[
      "Ciseaux fins dédiés — lames droites et très tranchantes, à n'utiliser que pour la fibre. Ne jamais les partager avec d'autres usages (cheveux, papier, emballages) qui émoussent les lames. C'est l'outil le plus important du poste fibre.",
      "Pince fine ou pince de pose — pour tenir et placer la fibre sans la toucher avec les doigts. Le contact des doigts dépose du sébum sur la fibre, ce qui peut altérer son adhérence au gel."
    ]},
    {"type":"material","title":"Pour la construction et la finition","items":[
      "Pinceau gel de construction — taille adaptée à la surface de l'ongle moyen, forme ovale ou ronde légèrement plate. Un pinceau trop petit allonge le temps de pose ; trop grand, il manque de précision sur les zones délicates.",
      "Lime abrasive 100/180 — 100 pour les corrections de structure, 180 pour affiner. Choisir une lime de bonne qualité : une lime qui perd son abrasif rapidement est à éviter.",
      "Buffer doux (220+) — pour unifier la surface avant finition. Ne pas confondre avec une lime : le buffer polit, il ne lime pas.",
      "Lime fine de finition — pour les contours, les bords libres, les zones sous la cuticule."
    ]},
    {"type":"material","title":"Pour la préparation et l'hygiène","items":[
      "Repousse-cuticule (orange stick ou métal) — pour repousser doucement sans agresser le tissu proximal",
      "Brosse de dépoussiérage — douce, propre, réservée à cet usage",
      "Éclairage de travail orientable — indispensable pour voir la fibre correctement pendant la pose. Une lampe de bureau LED orientable est suffisante."
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Flat lay : matériel complet organisé sur fond clair — fibres, ciseaux, pince, pinceaux, limes, buffer · À ajouter depuis l'Atelier Nahira"},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"✓ Outils à investir en priorité","items":[
      "Ciseaux fins dédiés fibre, qualité professionnelle",
      "Pince de pose propre et fine",
      "Éclairage de travail orientable",
      "Limes de bonne qualité (résistantes, abrasif qui tient)",
      "Pinceau gel bien formé, taille adaptée"
    ]},
    {"type":"material","title":"✕ À éviter","items":[
      "Ciseaux multi-usages ou de couture",
      "Acheter 10 limes bas de gamme au lieu de 3 bonnes",
      "Suréquiper avec des outils « spéciaux fibre » non nécessaires",
      "Travailler sans lumière directe sur l'ongle",
      "Pinceaux en mauvais état dont les fibres partent"
    ]},
    {"type":"material","title":"Audit de ton poste de travail","items":[
      "J'ai une paire de ciseaux dédiée à la fibre, tranchante, en bon état",
      "J'ai une pince de pose propre, fine, sans résidu de gel",
      "Mon éclairage est orientable et me permet de voir la fibre sur l'ongle sans ombre portée",
      "J'ai au moins 3 grains de lime différents pour les 3 étapes (structure / affinement / finition)",
      "Mon pinceau gel est propre, sa forme est intacte, ses fibres ne partent pas"
    ]},
    {"type":"warning","content":"Erreur fréquente : travailler sans éclairage dédié sur l'ongle. La fibre de verre est fine et transparente — sans lumière directe et orientée, il est impossible de voir si elle est correctement positionnée, si des zones ne sont pas encapsulées, ou si le bord libre est bien couvert. Un éclairage de bureau orientable peut résoudre ce problème complètement."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"Des ciseaux dédiés et un bon éclairage sont les deux investissements prioritaires pour la pose fibre.\nQualité > quantité — moins d'outils, mieux choisis, toujours en bon état.\nFais l'audit de ton poste avant chaque série de poses."}
  ]$cb$::jsonb);

  -- ── L 2.5 — La lampe UV/LED ───────────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'La lampe UV/LED — polymérisation et compatibilité', 4, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"La lampe n'est pas un accessoire secondaire — c'est un maillon critique de la chaîne. Une polymérisation incorrecte, qu'elle soit insuffisante ou excessive, compromet la tenue, la résistance et le confort de la cliente. Et la polymérisation dépend directement de la compatibilité entre ta lampe et ton gel.\n\nLa polymérisation est une réaction chimique déclenchée par la lumière : les photoinitiateurs présents dans le gel réagissent aux longueurs d'onde UV ou LED spécifiques pour transformer le gel liquide en une structure solide. Cette réaction ne se produit correctement que si : la longueur d'onde émise par la lampe correspond aux photoinitiateurs du gel, la puissance est suffisante pour activer la réaction en profondeur, le temps d'exposition est respecté (trop court = sous-polymérisé ; trop long = surchauffe possible), et la distance entre l'ongle et la source lumineuse est correcte.\n\nLes instructions du fabricant de ton gel définissent ces paramètres pour leur produit. Ces instructions priment sur toute autre recommandation générale."},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["Signe observé","Interprétation probable","Action"],"rows":[
      ["Surface collante après polymérisation (couche d'inhibition)","Normal sur couches intermédiaires de certains gels","Continuer normalement, nettoyer la couche d'inhibition sur la couche finale"],
      ["Gel mou après polymérisation, même une fois nettoyé","Sous-polymérisation — gel non durci en profondeur","Vérifier compatibilité lampe/gel, puissance, temps d'exposition"],
      ["Forte sensation de chaleur ou brûlure pendant la polymérisation","Surchauffe — quantité de gel trop importante ou lampe trop puissante","Réduire la quantité de gel, utiliser le mode chaleur douce si disponible"],
      ["Zones blanches ou opaques après polymérisation","Possible humidité résiduelle, fibre non encapsulée, ou gel incompatible","Revoir la préparation et vérifier la compatibilité produits"],
      ["Gel friable ou se rayant facilement","Sur-polymérisation ou incompatibilité produit","Vérifier le temps d'exposition et la compatibilité"]
    ]},
    {"type":"tip","content":"Rappel fabricant (critique) : les temps de polymérisation, puissances recommandées, longueurs d'onde compatibles et distances de pose sont spécifiés par le fabricant de ton gel. Ces informations priment toujours. Un gel formulé pour une lampe LED à 48W ne réagira pas de la même façon sous une lampe UV à 36W — même si les deux fonctionnent."},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Cas pratique — Tu utilises un nouveau gel de construction et tu remarques que, après polymérisation selon les indications du fabricant, le gel semble légèrement mou par endroits. Ta lampe est une LED 48W que tu utilises depuis 2 ans. Que vérifies-tu en premier ?"},
    {"type":"info","content":"✓ Trois pistes à vérifier dans l'ordre : 1) La compatibilité entre le nouveau gel et ta lampe — tous les gels ne sont pas formulés pour toutes les lampes, même puissantes. Vérifie les indications du fabricant du gel. 2) L'état de tes diodes — après 2 ans d'utilisation intensive, la puissance effective peut diminuer sans que la lampe cesse de fonctionner. 3) La distance et la position de la main dans la lampe — des zones mal positionnées reçoivent moins de lumière. Test simple : polymérise sur faux ongle et vérifie la dureté avec un cure-dent."},
    {"type":"warning","content":"Erreur fréquente : penser qu'une lampe à forte puissance affichée garantit une bonne polymérisation de tous les gels. La puissance n'est qu'un paramètre parmi plusieurs. Un gel formulé pour une certaine longueur d'onde ne polymérisera pas correctement sous une lampe qui n'émet pas dans ce spectre, même si elle est très puissante."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"La polymérisation correcte dépend de la compatibilité lampe/gel, du temps, de la puissance ET de la position.\nLes instructions du fabricant du gel priment toujours — les respecter à la lettre avec un nouveau produit.\nApprendre à lire les signes d'une polymérisation correcte ou incorrecte fait partie de la technique.\nUne lampe qui vieillit peut perdre en efficacité — vérifier périodiquement."}
  ]$cb$::jsonb);

  -- ── L 2.6 — Kit complet ───────────────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Kit complet — organisation et investissement de départ', 5, 8, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Cette leçon synthétise tout le module matériel en une vue d'ensemble pratique. L'objectif n'est pas de te donner une liste de marques à acheter, mais de t'aider à construire un kit professionnel cohérent, évolutif, et adapté à ton contexte."},
    {"type":"material","title":"Les trois catégories de matériel","items":[
      "Essentiel dès le départ — sans ces éléments, la pose fibre ne peut pas être réalisée correctement : fibre de verre professionnelle, gel de construction compatible, lampe UV/LED, ciseaux dédiés, pince de pose, limes 100/180, buffer, outils de préparation et d'hygiène",
      "Utile à court terme — améliore la qualité et la rapidité : top coat, rubber base (selon protocole et compatibilité vérifiée), éclairage orientable de qualité, faux ongles pour s'entraîner",
      "Optionnel ou progressif — à intégrer quand la technique est maîtrisée : outils de construction supplémentaires, systèmes de nail art compatibles, matériel de documentation"
    ]},
    {"type":"text","content":"L'investissement de départ varie selon tes fournisseurs, ta zone géographique et le niveau de qualité choisi. La fiche F1 détaille les estimations par catégorie — ces chiffres sont indicatifs et dépendent de ton contexte d'achat."},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"pdf","description":"Fiche F1 — Liste matériel complète par catégories avec estimations budget · PDF téléchargeable · Références personnelles de Nahira ajoutables depuis l'Atelier Nahira"},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Bilan de ton kit actuel","items":[
      "Prends la liste F1 et compare-la à ce que tu as déjà — note ce qui manque",
      "Pour chaque élément manquant dans la catégorie « Essentiel », planifie son acquisition avant de faire tes premières poses sur cliente",
      "Pour les éléments « Utile » et « Optionnel », priorise selon ton budget et ton niveau actuel"
    ]},
    {"type":"tip","content":"Il vaut mieux démarrer avec un kit réduit mais de bonne qualité et bien maîtrisé, qu'un kit exhaustif dont tu ne connais pas tous les produits. La maîtrise de 5 produits bien choisis vaut davantage que la possession de 20 produits partiellement compris. Fais tes premières poses sur faux ongles, puis sur des proches volontaires, avant de recevoir des clientes."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"je_maitrise","content":"Je suis capable de choisir une fibre selon ses critères de qualité, d'évaluer la viscosité d'un gel par rapport aux besoins de la pose fibre, de vérifier la compatibilité de ma lampe avec mon gel, et d'organiser un poste de travail équipé des outils essentiels — sans avoir besoin d'une liste de marques pour prendre ces décisions."},
    {"type":"info","content":"Un kit progressif bien choisi vaut mieux qu'un kit exhaustif mal maîtrisé.\nLes éléments « essentiels » doivent tous être présents avant les premières poses sur cliente.\nLes références personnelles de Nahira sont disponibles dans la fiche F1, actualisables depuis l'Atelier Nahira."}
  ]$cb$::jsonb);

  -- ══════════════════════════════════════════════════════════════════════════
  -- MODULE 3 — Hygiène, sécurité & responsabilité professionnelle
  -- ══════════════════════════════════════════════════════════════════════════
  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Hygiène, sécurité & responsabilité professionnelle', 3) RETURNING id INTO mid;

  -- ── L 3.1 — Anatomie simplifiée ───────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Anatomie simplifiée de l''ongle — ce qu''il faut vraiment comprendre', 0, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Avant de poser quoi que ce soit sur un ongle, il faut savoir ce qu'est un ongle. Pas en termes académiques — en termes pratiques, pour comprendre pourquoi chaque geste compte et ce qu'on risque si on ne le fait pas correctement."},
    {"type":"material","title":"Les zones clés de l'ongle — ce qui nous concerne","items":[
      "La plaque de l'ongle (plaque unguéale) — la partie visible et dure. C'est sur elle qu'on travaille. Elle est produite par la matrice et pousse vers l'avant. Elle ne se régénère pas si on l'endommage en profondeur.",
      "La matrice — zone cachée sous le repli proximal (peau de la cuticule), à la base de l'ongle. Elle produit les cellules qui forment la plaque. Toute agression mécanique ou chimique sur cette zone peut entraîner une repousse déformée ou irrégulière.",
      "Le lit de l'ongle — la peau rosée visible sous la plaque transparente. Il adhère naturellement à la plaque et la nourrit. Un décollement de la plaque du lit de l'ongle s'appelle une onycholyse — c'est une situation qui nécessite un avis médical, pas une pose.",
      "Le repli proximal et les cuticules — le repli cutané qui couvre la base de la plaque. Repousser les cuticules doucement fait partie de la préparation ; les couper ou les agresser peut créer une voie d'entrée pour des bactéries.",
      "L'hyponychium — junction entre le bord libre de la plaque et la peau sous le bout du doigt. Zone sensible qui peut réagir à certains produits ou à une pression excessive.",
      "Les replis latéraux — peau sur les côtés de l'ongle. Travailler trop près risque d'irriter ou d'endommager cette peau."
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Schéma annoté de l'anatomie de l'ongle — plaque, matrice, lit de l'ongle, cuticule, hyponychium, replis latéraux · Illustration à créer · À ajouter depuis l'Atelier Nahira"},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Relier l'anatomie à la technique","items":[
      "Matrice → toujours protégée du produit chimique et de la pression mécanique → explication de la zone de sécurité à respecter au repli proximal",
      "Lit de l'ongle → une matification trop agressive peut fragiliser la plaque → explication de la matification douce (Module 4)",
      "Hyponychium → le scellement sous le bord libre doit rester propre et sans surplus → explication du double scellement (Module 5)",
      "Cuticules → repoussées, jamais coupées en préparation fibre → explication de la manucure adaptée (Module 4)"
    ]},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"La plaque est dure mais ne se régénère pas si endommagée en profondeur — chaque geste compte.\nLa matrice produit la plaque — toute agression à cet endroit peut affecter la repousse.\nUn décollement de la plaque du lit de l'ongle = situation à ne pas poser, à orienter médicalement.\nComprendre l'anatomie, c'est comprendre pourquoi on prépare l'ongle d'une certaine façon."}
  ]$cb$::jsonb);

  -- ── L 3.2 — Protocole d'hygiène ───────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Protocole d''hygiène de l''espace de travail', 1, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"L'hygiène du poste de travail est une compétence, pas une case à cocher. Un protocole bien intégré se fait automatiquement, sans y penser — et c'est exactement ce qu'on recherche."},
    {"type":"material","title":"Avant chaque cliente","items":[
      "Désinfecter la surface de travail (table, support repose-mains) avec un produit adapté et laisser agir le temps requis",
      "Vérifier que tous les outils réutilisables ont été désinfectés depuis la dernière utilisation",
      "Préparer les consommables à usage unique (lime, buffer, coton, serviette) et ne les sortir qu'au moment de les utiliser",
      "Se laver les mains avec du savon, puis les désinfecter — avant de toucher quoi que ce soit appartenant à la cliente",
      "Vérifier l'état du poste : pas de produit ouvert depuis trop longtemps, pas de résidu de pose précédente, surface propre"
    ]},
    {"type":"material","title":"Pendant la prestation","items":[
      "Ne pas toucher son visage, ses cheveux ou d'autres surfaces pendant la pose sans se réhygiéniser les mains",
      "Jeter immédiatement les éléments à usage unique après chaque utilisation (ne pas les reposer sur la table propre)",
      "En cas de contact avec du sang ou un liquide organique : arrêt de la prestation, nettoyage et désinfection de la zone et des mains",
      "Garder les produits fermés entre chaque utilisation — poussière et contamination croisée sont les ennemis silencieux d'une bonne pose"
    ]},
    {"type":"material","title":"Après chaque cliente","items":[
      "Jeter tous les éléments à usage unique (lime, buffer, coton, serviette)",
      "Désinfecter les outils réutilisables dans un bain désinfectant selon les produits et instruments",
      "Nettoyer et désinfecter la surface de travail",
      "Ranger les produits, fermer les pots et flacons, éviter toute contamination croisée",
      "Aérer l'espace de travail si nécessaire"
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"placeholder","media_type":"image","description":"Photo : table de travail propre et organisée — vue de dessus · À ajouter depuis l'Atelier Nahira"},
    {"type":"placeholder","media_type":"pdf","description":"Fiche F2 — Protocole d'hygiène résumé (format affichage salon) · PDF téléchargeable · À ajouter depuis l'Atelier Nahira"},
    {"type":"tip","content":"Crée un « rituel de départ » et un « rituel de fin » qui ne changent jamais. Toujours les mêmes gestes, dans le même ordre, avant et après chaque cliente. Quand ces rituels deviennent automatiques, tu ne risques plus d'oublier une étape sous la pression du temps ou de la conversation. C'est une habitude de professionnelle, pas un protocole de laboratoire."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"L'hygiène du poste se fait avant, pendant et après — trois moments distincts, trois responsabilités.\nCe qui est à usage unique est à usage unique — ne jamais réutiliser une lime ou un buffer.\nSe laver et désinfecter les mains : avant la cliente, pas seulement après.\nUn rituel fixe empêche les oublis sous pression."}
  ]$cb$::jsonb);

  -- ── L 3.3 — Désinfection des outils ──────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Désinfection des outils — méthodes et fréquence', 2, 8, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"material","title":"Trois niveaux de traitement — les distinguer","items":[
      "Nettoyage — élimination des résidus visibles (poussière de limage, gel). Étape préalable indispensable à toute désinfection : un outil sale ne peut pas être correctement désinfecté.",
      "Désinfection — réduction significative des micro-organismes présents sur la surface d'un outil. Ne détruit pas nécessairement tous les spores. Adapté aux outils en contact avec la peau intacte.",
      "Stérilisation — élimination de toutes les formes vivantes, y compris les spores. Requiert un autoclave ou une méthode validée. Obligatoire pour tout outil ayant été en contact avec du sang ou une plaie."
    ]},
    {"type":"text","content":"Dans un contexte d'onglerie esthétique standard (sans blessure), la désinfection est le niveau requis pour les instruments réutilisables. Si un outil entre en contact avec du sang, il doit être stérilisé ou mis de côté et remplacé si la stérilisation n'est pas disponible."},
    {"type":"section","label":"VOIR"},
    {"type":"table","headers":["Outil","Statut","Traitement requis"],"rows":[
      ["Lime abrasive (papier ou tissu)","Usage unique par cliente","Jeter après chaque cliente"],
      ["Buffer","Usage unique par cliente","Jeter après chaque cliente"],
      ["Ciseaux métalliques","Réutilisable","Nettoyage + désinfection entre chaque cliente"],
      ["Pince de pose (métal)","Réutilisable","Nettoyage + désinfection entre chaque cliente"],
      ["Repousse-cuticule métal","Réutilisable","Nettoyage + désinfection entre chaque cliente"],
      ["Orange stick (bois)","Usage unique","Jeter après chaque cliente"],
      ["Pinceau gel","Réutilisable avec précautions","Nettoyage soigneux au produit adapté, rinçage, séchage"],
      ["Coton, disques, serviettes","Usage unique","Jeter après utilisation"]
    ]},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"La désinfection par trempage — protocole de base","items":[
      "Nettoyer l'outil de tout résidu visible (gel, poussière) avant de le plonger dans le désinfectant",
      "Plonger dans une solution désinfectante adaptée aux instruments métalliques",
      "Respecter le temps de contact indiqué par le fabricant du désinfectant — le contact bref ne désinfecte pas",
      "Sortir, rincer si indiqué par le produit, sécher soigneusement (l'humidité résiduelle peut favoriser la corrosion des outils)",
      "Stocker dans un contenant propre et fermé"
    ]},
    {"type":"warning","content":"Erreur fréquente : pulvériser un désinfectant sur un outil et l'essuyer immédiatement. La désinfection requiert un temps de contact avec la surface — généralement plusieurs minutes selon le produit. Un spray suivi d'un essuyage immédiat n'est pas une désinfection : c'est un nettoyage partiel. Toujours lire et respecter le temps de contact indiqué par le fabricant du désinfectant."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"Nettoyage ≠ désinfection ≠ stérilisation — trois niveaux, trois usages distincts.\nLimes, buffers, orange sticks : toujours à usage unique — jamais réutilisés d'une cliente à l'autre.\nLe temps de contact du désinfectant est critique — ne pas l'abréger.\nTout outil en contact avec du sang sort du protocole standard et nécessite une stérilisation ou un remplacement."}
  ]$cb$::jsonb);

  -- ── L 3.4 — Produits et compatibilités ────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Produits et compatibilités — vigilance chimique', 3, 8, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"En onglerie, on travaille avec des produits chimiques — gels, bases, top coats, primers, dégraissants, désinfectants. Ces produits ne sont pas tous compatibles entre eux, et leur mauvaise association peut provoquer des réactions inattendues, des problèmes de tenue ou, dans les cas les plus graves, des réactions sur la peau de la cliente."},
    {"type":"material","title":"Comprendre les incompatibilités chimiques","items":[
      "Systèmes de gel différents — chaque marque formule ses produits pour fonctionner ensemble. Utiliser le top coat d'une marque avec la base d'une autre, sans avoir vérifié la compatibilité, peut entraîner un manque d'adhérence, un jaunissement, ou une polymérisation incomplète.",
      "Primers et gels — certains primers acides ne sont pas adaptés à tous les gels. L'utilisation d'un primer trop agressif peut fragiliser la plaque ou provoquer une réaction sur certaines clientes.",
      "Produits de nettoyage et de désinfection — certains nettoyants résiduels sur la plaque peuvent interférer avec l'adhérence du gel. Toujours s'assurer que la plaque est propre, sèche et sans résidu avant d'appliquer les produits de construction.",
      "Produits conservés incorrectement — un produit exposé à la lumière UV, à la chaleur ou à l'humidité peut se dégrader et présenter des propriétés différentes de celles attendues, même si sa date de péremption n'est pas dépassée."
    ]},
    {"type":"material","title":"Informer la cliente sur les produits utilisés","items":[
      "Lui permettre de signaler une sensibilité ou une allergie connue à un composant (résine époxy, acrylates, méthacrylates)",
      "Te donner l'information dont tu as besoin pour adapter ou reporter la prestation si nécessaire",
      "Établir une relation de confiance et de transparence professionnelle"
    ]},
    {"type":"text","content":"Si une cliente te signale une allergie, ne pas interpréter toi-même si le produit que tu utilises contient ou non l'allergène. Orienter vers le fabricant du produit ou recommander un test préalable avec un dermatologue."},
    {"type":"section","label":"FAIRE"},
    {"type":"text","content":"Cas pratique — Tu travailles avec le gel de construction de la marque A et le top coat de la marque B. Tu remarques que le top coat jaunit légèrement après quelques jours sur certaines clientes. Quelle est ta première piste d'investigation ?"},
    {"type":"info","content":"✓ Le jaunissement peut avoir plusieurs origines, mais la combinaison de produits de marques différentes est une piste sérieuse. Premièrement, vérifie si le top coat de la marque B est formulé pour être compatible avec des gels d'autres systèmes, ou s'il est conçu pour fonctionner uniquement avec sa propre gamme. Deuxièmement, vérifie les conditions de stockage de tes produits — un top coat exposé à la lumière ou à la chaleur peut se dégrader. Troisièmement, si le problème est récent et que les produits n'ont pas changé, vérifie si ta lampe ou tes temps de polymérisation ont évolué. Un test sur faux ongle dans des conditions contrôlées permet d'isoler la variable."},
    {"type":"warning","content":"Erreur fréquente : mélanger des produits de systèmes différents par défaut, sans vérification. « Ça a marché une fois » n'est pas une validation de compatibilité. Les formulations des produits peuvent changer entre lots, et certains problèmes (décollement, jaunissement, allergies retardées) n'apparaissent qu'après plusieurs utilisations ou sur certains profils de peau."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"info","content":"Vérifier la compatibilité des produits entre eux — ne pas supposer que tout fonctionne ensemble.\nInformer la cliente des types de produits utilisés avant la prestation.\nStorker les produits correctement (abri lumière, température stable, fermés).\nEn cas de doute sur une allergie à un composant — orienter, ne pas interpréter."}
  ]$cb$::jsonb);

  -- ── L 3.5 — Situations de refus ou report ─────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Situations nécessitant un report ou un refus de prestation', 4, 12, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"Refuser ou reporter une prestation est l'un des actes professionnels les plus difficiles à poser — pas techniquement, mais humainement. Pourtant, c'est précisément ce qui distingue une praticienne responsable d'une praticienne qui fait ce que la cliente demande, indépendamment des circonstances.\n\nTon rôle : observer visuellement l'état de l'ongle et de la peau environnante, reconnaître des signes qui sortent du normal, décider de ne pas poser, communiquer à la cliente ce que tu observes, l'orienter vers un professionnel de santé.\n\nCe que tu ne peux pas faire : identifier la cause d'une anomalie, nommer une pathologie, rassurer une cliente sur quelque chose qui sort de l'esthétique, poser sur un ongle présentant des signes inhabituels en espérant que « ça passe ».\n\nLa frontière n'est pas entre « ça a l'air grave » et « ça a l'air bénin ». La frontière est entre ce qui est esthétiquement normal et ce qui ne l'est pas. Quand quelque chose sort de la norme esthétique observable, tu observes, tu arrêtes, et tu orientes."},
    {"type":"section","label":"VOIR"},
    {"type":"material","title":"Signaux qui nécessitent un report ou un refus","items":[
      "Plaie ouverte, coupure ou égratignure dans la zone de travail — reporter jusqu'à cicatrisation complète",
      "Rougeur, gonflement ou chaleur anormale autour d'un ou plusieurs ongles — reporter et orienter",
      "Coloration inhabituelle de la plaque (zones jaunâtres, verdâtres, blanchâtres non liées à un ancien produit) — arrêter, ne pas poser, orienter",
      "Décollement visible de la plaque du lit de l'ongle — ne pas poser sur cet ongle, orienter",
      "Douleur signalée à la pression ou à la palpation légère — ne pas poser, orienter",
      "Peau enflammée, croûtes ou lésions dans la zone de travail — reporter et orienter",
      "Cliente signalant un traitement médical en cours sur les ongles ou la peau des mains — évaluer, et si doute, reporter jusqu'à avis médical"
    ]},
    {"type":"section","label":"FAIRE"},
    {"type":"material","title":"Formulations professionnelles pour communiquer un report ou un refus","items":[
      "« J'observe quelque chose d'inhabituel sur cet ongle — par précaution, je préfère ne pas poser dessus aujourd'hui et te recommande d'en parler à ton médecin. »",
      "« Je vois une petite zone qui me préoccupe — ce n'est peut-être rien, mais je ne suis pas la personne qualifiée pour en juger. Je préfère que tu aies un avis médical avant de poser. »",
      "« Il y a une blessure qui n'est pas encore cicatrisée — on peut reporter cette pose dans quelques jours quand la zone est complètement guérie. »"
    ]},
    {"type":"text","content":"Ne pas commenter l'origine de ce que tu observes. Ne pas rassurer (« c'est probablement rien »). Ne pas poser quand même pour « ne pas décevoir ». Aucune de ces attitudes ne protège ta cliente — ni toi."},
    {"type":"text","content":"Cas pratique — Une cliente régulière arrive pour son entretien mensuel. En observant ses ongles, tu remarques que l'index gauche présente une zone verdâtre sous la plaque, vers le milieu. Ton gel était encore dessus. Elle ne se plaint de rien. Que fais-tu, étape par étape ?"},
    {"type":"info","content":"✓ Étape 1 : Tu ne poses pas sur cet ongle. Une coloration verdâtre sous une pose de gel peut indiquer une contamination qui s'est développée sous la plaque — une situation qui ne se traite pas par une nouvelle pose par-dessus. Étape 2 : Tu retires proprement la pose existante sur cet ongle uniquement. Étape 3 : Tu observes la plaque nue — si la coloration persiste, tu confirmes que tu ne peux pas reposer et tu orientes la cliente vers un médecin. Étape 4 : Tu évalues les autres ongles. Si l'anomalie est isolée à un doigt et qu'aucun autre signe n'est présent, tu peux envisager de travailler sur les autres ongles. En cas de doute, il est préférable de reporter l'ensemble de la prestation. Étape 5 : Tu communiques clairement et calmement : « J'ai retiré ta pose sur cet ongle car j'observais quelque chose d'inhabituel. Je te recommande d'en parler à ton médecin avant qu'on le repose. »"},
    {"type":"warning","content":"Erreur fréquente : poser par-dessus une anomalie « pour voir si ça passe ». Dans la majorité des cas, une anomalie couverte par une pose ne disparaît pas — elle s'aggrave dans un environnement chaud, humide et sans lumière. En plus de ne pas résoudre le problème, cela peut compliquer le diagnostic médical ultérieur et engage ta responsabilité professionnelle."},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"je_maitrise","content":"Je suis capable d'identifier les signaux qui nécessitent un arrêt de la prestation, de prendre cette décision sereinement, et de la communiquer à la cliente avec professionnalisme et bienveillance — sans avoir besoin d'identifier la cause médicale de ce que j'observe."},
    {"type":"info","content":"Observer, reconnaître l'anormal, ne pas poser, orienter — c'est la totalité de ton rôle en cas d'anomalie.\nJamais nommer une pathologie, jamais rassurer sur quelque chose qui sort de l'esthétique normale.\nUn refus professionnel et bienveillant renforce la confiance — il ne la détruit pas.\nEn cas de doute : reporter toute la prestation vaut mieux que prendre un risque partiel."}
  ]$cb$::jsonb);

  -- ── L 3.6 — Accord de prestation ─────────────────────────────────────────
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid, 'Accord de prestation esthétique — information cliente et accord avant pose', 5, 10, $cb$[
    {"type":"section","label":"COMPRENDRE"},
    {"type":"text","content":"L'accord de prestation esthétique n'est pas un document bureaucratique, ni un formulaire médical. C'est un outil de communication professionnelle qui protège à la fois la cliente et la praticienne — à condition de le comprendre et de l'utiliser correctement."},
    {"type":"material","title":"Ce qu'est — et ce que n'est pas — un accord de prestation esthétique","items":[
      "C'est un document d'information sur la prestation : description du service, types de produits utilisés, résultats attendus et limites, instructions d'entretien post-pose, déclaration de la cliente sur l'absence de contre-indications connues de son côté",
      "Ce n'est pas un formulaire médical, un diagnostic, une garantie de résultat, ni un contrat qui te dédouane de ta responsabilité en cas d'erreur technique",
      "Ce n'est pas obligatoire légalement dans tous les contextes — mais c'est une bonne pratique professionnelle qui peut s'avérer précieuse en cas de litige. Son utilité principale est d'instaurer une conversation et de recueillir des informations clés."
    ]},
    {"type":"material","title":"Comment l'utiliser sans le rendre pesant","items":[
      "Présente-le comme une étape normale de l'accueil, pas comme une formalité administrative",
      "Parcours les points principaux avec la cliente oralement — ne la laisse pas seule face à un formulaire à remplir",
      "Profite de ce moment pour poser les questions clés : « Tu as des allergies connues ? Des traitements sur les ongles en ce moment ? »",
      "Garde-le dans un espace sécurisé — la gestion des données personnelles obéit aux règles de protection (RGPD en France et dans l'UE)",
      "Mets-le à jour en cas de changement de situation de la cliente (traitement médical, nouvelle allergie signalée)"
    ]},
    {"type":"section","label":"VOIR"},
    {"type":"material","title":"Ce que contient la fiche F3","items":[
      "Identification de la prestation (type de pose, date)",
      "Information sur les types de produits utilisés (gel UV/LED, fibre de verre, produits de préparation)",
      "Résultats attendus et facteurs qui influencent la tenue",
      "Instructions d'entretien et contre-indications post-pose",
      "Déclaration de la cliente : absence de contre-indication connue au moment de la prestation",
      "Signature et date"
    ]},
    {"type":"placeholder","media_type":"pdf","description":"Fiche F3 — Accord de prestation esthétique (modèle personnalisable) · PDF téléchargeable / imprimable · Formulé comme accord de prestation esthétique (jamais comme document médical) · Contenu entièrement modifiable depuis l'Atelier Nahira"},
    {"type":"warning","content":"Erreur fréquente : faire signer le document de façon précipitée en disant « c'est une formalité ». Ce n'est pas une formalité — c'est une information. Si la cliente a le sentiment de signer quelque chose sans comprendre, l'accord perd sa valeur professionnelle et relationnelle. Prends deux minutes pour en expliquer l'objectif : « C'est pour m'assurer qu'on a bien parlé des produits utilisés et que tu n'as rien à me signaler avant de commencer. »"},
    {"type":"section","label":"VÉRIFIER"},
    {"type":"je_maitrise","content":"Je suis capable d'utiliser l'accord de prestation comme un outil de communication naturel — pas comme une formalité pesante — et je comprends la différence entre ce qu'il protège et ce qu'il ne protège pas."},
    {"type":"info","content":"L'accord de prestation esthétique est un outil de communication, pas un formulaire médical.\nSon utilité principale est de créer une conversation et de recueillir des informations clés.\nIl ne remplace pas ton observation professionnelle et ne te dédouane pas d'une erreur technique.\nÀ utiliser à la première visite, et à mettre à jour si la situation de la cliente change."}
  ]$cb$::jsonb);

END $seed$;
