-- ══════════════════════════════════════════════════════════════════
-- Fiber Signature — Seed M6 : Rééquilibrage & entretien
-- ══════════════════════════════════════════════════════════════════
DO $seed$
DECLARE
  cid UUID;
  mid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature' LIMIT 1;

  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Rééquilibrage & entretien de la pose', 6)
  RETURNING id INTO mid;

  -- M6.L1 — Comprendre le rééquilibrage (9 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Comprendre le rééquilibrage — ce que c''est, ce que ce n''est pas',
    0, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Le rééquilibrage est la session de maintenance qui suit la pose initiale. Son objectif est de corriger le déséquilibre visuel et structurel créé par la repousse de l'ongle naturel : combler la zone de repousse, ajuster la longueur, repositionner l'apex si nécessaire, et traiter les éventuels soulèvements ou zones abîmées.\n\nCe que le rééquilibrage n'est pas :\n— Ce n'est pas automatique : chaque session commence par une évaluation de l'état de la pose. On ne comble pas systématiquement — parfois, la pose nécessite une dépose complète plutôt qu'un rééquilibrage.\n— Ce n'est pas une remise à neuf par-dessus l'existant : rééquilibrer sur des zones décollées ou abîmées aggrave le problème. La règle — on traite ce qui peut l'être, on dépose ce qui doit l'être.\n— Ce n'est pas une rééducation de l'ongle : la fibre accompagne progressivement la repousse. Elle peut constituer un soutien dans le suivi esthétique progressif d'un ongle en repousse, mais elle n'est pas une thérapeutique médicale.\n\nDeux décisions possibles à l'issue de l'évaluation :\n🟢 Rééquilibrage — La pose est en bon état général, les zones décollées sont limitées et localisées, la plaque naturelle est saine sous le produit.\n🟠 Dépose complète + reprise — Soulèvements étendus, humidité emprisonnée, produit trop ancien ou incompatible avec la reprise, anomalie de l'ongle naturel découverte lors de l'évaluation. La dépose est la décision professionnelle, pas un échec."},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photo comparative — avant / après rééquilibrage","note":"Exemple d'un ongle à 3 semaines de pose : zone de repousse visible, apex décalé, bord libre allongé — puis après rééquilibrage — à ajouter depuis l'Atelier Nahira"},
      {"type":"table","headers":["Zone","Ce que tu évalues","Orientation"],"rows":[
        ["Zone de repousse","Taille de l'espace entre cuticule et produit, état de la plaque naturelle dans cette zone","Rééquilibrage si la zone est saine et la plaque adhérente"],
        ["Zones de soulèvement","Ampleur, localisation, présence ou non d'humidité visible (coloration blanche ou verdâtre)","Traiter les zones légères, déposer si soulèvement étendu ou anomalie"],
        ["Apex","Le point le plus épais s'est-il déplacé vers le bord libre ? L'architecture est-elle toujours équilibrée ?","Rééquilibrer l'apex si déplacé — c'est l'objectif central du rééquilibrage"],
        ["Bord libre","Longueur actuelle vs longueur souhaitée, intégrité du bord","Ajuster si besoin lors du rééquilibrage"],
        ["Surface générale","Éraflures, opacité, brillance","Finitions ajustées en fin de rééquilibrage"]
      ]},
      {"type":"section","label":"Vérifier"},
      {"type":"text","content":"Questions de vérification :\n— Quelle est la différence entre rééquilibrage et dépose complète + reprise ?\n— Pourquoi le rééquilibrage n'est-il pas une décision automatique à chaque session ?\n— Pourquoi la fibre de verre n'est-elle pas présentée comme une solution thérapeutique pour l'ongle ?\n— Que signifie « repositionner l'apex » dans le contexte du rééquilibrage ?"},
      {"type":"warning","content":"Erreur fréquente : Rééquilibrer « par habitude » sans évaluer l'état de la pose. Un rééquilibrage sur un soulèvement non traité, ou par-dessus une zone humide, emprisonne un problème qui s'aggrave à chaque session. L'évaluation n'est pas optionnelle — elle conditionne chaque décision."},
      {"type":"info","content":"À retenir :\n— Rééquilibrage = combler la repousse + repositionner l'apex + traiter les zones traitables\n— Toute session de suivi commence par une évaluation — rééquilibrer ou déposer ?\n— La fibre accompagne progressivement la repousse — elle ne rééduque pas l'ongle médicalement\n— Déposer complètement est une décision professionnelle, pas un échec technique"}
    ]$cb$
  );

  -- M6.L2 — Évaluer l'état de la pose (11 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Évaluer l''état de la pose — la grille de décision avant rééquilibrage',
    1, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"L'évaluation préalable au rééquilibrage suit la même logique que l'observation préalable à la pose initiale — mais elle porte sur la pose existante, pas uniquement sur la plaque naturelle. Tu évalues simultanément :\n— L'état du produit en place (adhérence, intégrité de la surface, zones abîmées)\n— L'état de la plaque naturelle accessible (zone de repousse, zones sous éventuels soulèvements)\n— La compatibilité entre l'état observé et un protocole de rééquilibrage\n\nCette évaluation s'effectue en deux temps : d'abord visuellement, ensuite au toucher (la plaque produit résonne-t-elle creux aux zones de soulèvement ?)."},
      {"type":"section","label":"Voir"},
      {"type":"table","headers":["Situation observée","Décision","Pourquoi"],"rows":[
        ["Pose en bon état général, repousse naturelle visible, 1-2 petits soulèvements localisés","🟢 Rééquilibrage","Situation standard attendue après 3-4 semaines. Les soulèvements localisés se traitent lors du rééquilibrage."],
        ["Soulèvements multiples et étendus (plus de 2-3 ongles concernés de façon importante)","🟠 Dépose complète recommandée","Rééquilibrer sur des soulèvements étendus piège de l'humidité et des impuretés — risque accru sur la prochaine session."],
        ["Coloration verdâtre, blanchâtre ou brunâtre sous le produit décollé","🔴 Arrêt immédiat — dépose indiquée, évaluation attentive de la plaque","Signe d'alerte à ne pas ignorer. Observer attentivement la plaque naturelle après dépose. Ne pas reposer avant évaluation complète ; orienter vers un professionnel de santé si le signe persiste, s'étend ou s'accompagne d'autres symptômes."],
        ["Produit très ancien (2 mois +) avec surface dégradée","🟠 Dépose complète","Un produit trop ancien perd ses propriétés. Rééquilibrer par-dessus fragilise la construction."],
        ["Cliente qui a arraché ou cassé un ongle — manque de produit partiel","🟠 Évaluer au cas par cas","Si la plaque naturelle est intacte sous le produit manquant : réparation possible. Si la plaque est abîmée : traiter d'abord, poser après guérison si compatible."],
        ["Repousse régulière, aucun soulèvement, pose en excellent état","🟢 Rééquilibrage simple","Situation idéale — rééquilibrage technique sans complication."]
      ]},
      {"type":"section","label":"Faire"},
      {"type":"text","content":"Pour chaque situation ci-dessous, indique ta décision et explique-la :\n— Cliente à 3 semaines, 2 ongles avec un petit soulèvement aux cuticules, surface générale en bon état\n— Cliente à 6 semaines (retard de session), soulèvements visibles sur 5 ongles, aucun signal de coloration anormale\n— Cliente à 4 semaines, un ongle cassé au niveau du bord libre, plaque naturelle visible et intacte dessous\n— Cliente à 3 semaines, un soulèvement sous lequel tu vois une zone légèrement plus foncée que les autres"},
      {"type":"text","content":"Cas pratique : Une cliente revient après 5 semaines. Tu notes des soulèvements aux cuticules sur 4 ongles sur 10. En soulevant légèrement le produit décollé sur un des ongles, tu aperçois une zone blanche mate. La cliente dit que c'est « normal, ça fait toujours ça avec elle ». Que décides-tu ?"},
      {"type":"info","content":"Réponse : La zone blanche mate peut avoir plusieurs origines — humidité emprisonnée, zone de plaque déshydratée, ou dans certains cas début de contamination. Tu ne peux pas trancher visuellement avec certitude.\n\nCe que tu ne fais pas : rééquilibrer par-dessus. Ce que tu ne fais pas non plus : te laisser rassurer par « c'est normal pour moi » — même si la cliente est sincère, tu restes responsable de ta décision professionnelle.\n\nLa décision la plus sécurisante : dépose complète sur les ongles concernés par les soulèvements (les 4 ongles), évaluation de la plaque naturelle sous chaque zone soulevée, reprise uniquement sur les ongles dont la plaque est saine après inspection. Anomalie inexpliquée → observation pendant une à deux semaines avant de reposer.\n\nTu expliques à la cliente que la dépose est une décision prudente — non une sanction."},
      {"type":"warning","content":"Erreur fréquente : Décider de rééquilibrer ou de déposer selon le temps disponible dans le planning, plutôt que selon l'état de la pose. La décision technique doit primer sur la contrainte horaire. Prévoir des créneaux plus longs pour les sessions de suivi lorsque la pose est à risque de nécessiter une dépose complète."},
      {"type":"tip","content":"Astuce : Photographie systématiquement les poses à chaque session — avant et après. Ces photos permettent de suivre l'évolution de chaque cliente, de comparer l'état à 3 semaines vs 5 semaines, et de détecter des patterns récurrents (tenue courte sur un ongle en particulier, soulèvements toujours au même endroit). C'est aussi une protection professionnelle en cas de désaccord sur l'état de la pose."},
      {"type":"info","content":"À retenir :\n— L'évaluation se fait en deux temps : visuel + toucher\n— Coloration anormale sous soulèvement = dépose + évaluation de la plaque naturelle\n— La décision dépend de l'état de la pose, pas du temps disponible\n— Photographie avant/après à chaque session — suivi et protection professionnelle"}
    ]$cb$
  );

  -- M6.L3 — Protocole de rééquilibrage (22 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Protocole de rééquilibrage — étape par étape',
    2, 13,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Le rééquilibrage suit une logique précise : on intervient d'abord sur les zones abîmées ou soulevées, puis on prépare la zone de repousse, puis on reconstitue l'architecture (apex), puis on finit la surface. On ne commence pas par le centre de l'ongle sans avoir traité les zones problématiques.\n\nL'objectif final d'un rééquilibrage réussi :\n— Zone de repousse comblée proprement — transition invisible entre plaque naturelle et produit existant\n— Apex repositionné au bon endroit — pas à mi-chemin entre la cuticule et le bord libre selon la nouvelle longueur\n— Surface unifiée — aucune démarcation visible entre l'ancien et le nouveau produit\n— Bord libre ajusté à la longueur convenue"},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Vidéo — Protocole de rééquilibrage complet","note":"Démonstration étape par étape sur un ongle à 3-4 semaines de pose — à ajouter depuis l'Atelier Nahira"},
      {"type":"text","content":"Points clés à observer dans la vidéo :\n— Comment est traitée la zone de soulèvement aux cuticules (retrait du produit décollé, nettoyage de la zone)\n— La technique de limage pour créer la transition entre la zone de repousse et le produit existant\n— L'application du nouveau gel uniquement dans la zone de repousse, puis l'unification de surface\n— Le repositionnement de l'apex sur le nouvel équilibre de l'ongle"},
      {"type":"section","label":"Protocole"},
      {"type":"step","number":1,"title":"Observation et décision","content":"Selon la grille de M6.L2. Si rééquilibrage confirmé : noter les zones à traiter en priorité."},
      {"type":"step","number":2,"title":"Ajuster la longueur du bord libre","content":"Avant tout limage de surface, couper ou limer le bord libre à la longueur souhaitée. Plus facile à faire avant que la zone de repousse ne soit traitée."},
      {"type":"step","number":3,"title":"Retirer délicatement le produit décollé","content":"Avec un repousse-cuticules ou une spatule fine. Ne pas forcer : retirer uniquement ce qui est clairement décollé. Nettoyer la zone exposée."},
      {"type":"step","number":4,"title":"Limer la surface du produit existant","content":"Légèrement, pour ôter la brillance et créer l'adhérence pour le nouveau gel. Un grain médium (à titre indicatif : 150-180) est généralement adapté ; selon ton matériel et ton système, ajuste au besoin. Attention à ne pas limer la zone de repousse (plaque naturelle) avec le même grain que le produit."},
      {"type":"step","number":5,"title":"Préparer la zone de repousse","content":"Cuticules repoussées, limage léger sur la plaque naturelle (à titre indicatif : grain 220 ou plus doux), dégraissage de la zone de repousse uniquement."},
      {"type":"step","number":6,"title":"Appliquer la base sur la zone de repousse","content":"Respecter la marge cuticule. Polymériser."},
      {"type":"step","number":7,"title":"Combler la zone de repousse avec du gel","content":"Créer la transition entre la plaque naturelle et le produit existant. L'objectif est une surface continue sans démarcation visible."},
      {"type":"step","number":8,"title":"Repositionner et reconstruire l'apex","content":"Évaluer où se trouve l'apex actuel et où il devrait être sur le nouvel équilibre. Ajouter du gel sur la zone apex si nécessaire, en tenant compte de la nouvelle longueur totale."},
      {"type":"step","number":9,"title":"Unifier la surface","content":"Une couche fine de gel sur toute la surface pour effacer les jonctions entre ancien et nouveau produit."},
      {"type":"step","number":10,"title":"Couche de scellement + finitions","content":"Selon le protocole habituel."},
      {"type":"section","label":"Vérifier"},
      {"type":"text","content":"Questions de vérification :\n— Pourquoi ajuster le bord libre en premier, avant le limage de surface ?\n— Quelle est la différence entre limer la surface du produit existant et préparer la zone de repousse ?\n— Qu'est-ce qu'une « transition invisible » entre zone de repousse et produit existant ?\n— Pourquoi faut-il reconsidérer la position de l'apex lors du rééquilibrage ?"},
      {"type":"warning","content":"Erreur fréquente : Appliquer du gel uniquement dans la zone de repousse sans unifier ensuite la surface. Résultat : une démarcation visible entre l'ancien et le nouveau produit — une ligne au niveau de la jonction qui se voit sous certaines lumières ou une fois la couleur appliquée. L'étape d'unification de surface n'est pas accessoire."},
      {"type":"tip","content":"Astuce : Pour la jonction entre zone de repousse et produit existant, travaille avec un gel légèrement plus fluide pour cette étape spécifique. Il se fond mieux à la surface existante et crée une transition plus naturelle qu'un gel épais qui crée une marche. Polymériser séparément chaque couche — ne jamais empiler du gel non polymérisé sur du gel non polymérisé."},
      {"type":"info","content":"À retenir :\n— Ordre : longueur → zones soulevées → limage surface → préparation repousse → base → combler → apex → unifier → sceller\n— La zone de repousse et la surface du produit existant ne se préparent pas avec le même grain\n— L'apex doit être repositionné sur le nouvel équilibre, pas laissé à son ancienne position\n— L'unification de surface efface la jonction ancien/nouveau produit"},
      {"type":"je_maitrise","items":["Je connais les 10 étapes du protocole de rééquilibrage dans l'ordre","Je sais pourquoi et comment repositionner l'apex lors du rééquilibrage","Je maîtrise la technique de jonction entre zone de repousse et produit existant","J'identifie les erreurs classiques du rééquilibrage et sais les corriger ou les prévenir"]}
    ]$cb$
  );

  -- M6.L4 — Suivi esthétique progressif de la repousse (11 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Suivi esthétique progressif de la repousse — accompagner les ongles en évolution',
    3, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Certaines clientes viennent avec des ongles en cours de repousse après une période où elles se rongeaient les ongles, suite à un traitement médical, ou après une période de fragilité. La fibre de verre peut, dans certains cas, constituer un soutien dans ce suivi esthétique progressif de la repousse.\n\nCe que ce suivi est :\n— Un accompagnement technique session après session, adapté à la longueur et à l'état de l'ongle à chaque visite\n— Une approche progressive — on ne cherche pas à forcer une longueur irréaliste au vu de la plaque disponible\n— Un suivi qui inclut la communication avec la cliente sur ses attentes, les délais réalistes, et les soins à domicile recommandés\n\nCe que ce suivi n'est pas :\n— Une promesse de résultats — la repousse dépend de facteurs individuels (génétique, hygiène de vie, alimentation, santé générale) que la pose ne peut pas modifier\n— Une thérapeutique médicale — si l'ongle présente une anomalie de repousse d'origine médicale, orienter vers un médecin\n— Un protocole universel — chaque cliente évolue différemment ; le protocole s'adapte à chaque session"},
      {"type":"section","label":"Voir"},
      {"type":"table","headers":["Profil de la cliente","Approche adaptée","Points de vigilance"],"rows":[
        ["Ongles rongés courts, plaque fine mais saine","Pose légère et courte selon la plaque disponible. Pas d'extension forcée. Suivi toutes les 3 semaines. Objectif : longueur progressive sur plusieurs sessions.","Ne pas poser si la plaque est trop courte pour garantir la tenue. Ne pas promettre une longueur précise à une date donnée."],
        ["Ongles fragilisés après traitement ou maladie","Construction la plus fine et la plus douce possible. Évaluer à chaque session la résistance de la plaque naturelle. Dégraisser délicatement.","La fragilité de la plaque peut contre-indiquer la pose. Évaluer session par session. Ne pas imposer un produit si l'ongle naturel n'est pas compatible."],
        ["Repousse progressive après une chute d'ongle","Attendre que la plaque soit suffisamment développée pour une pose viable. Évaluer visuellement et au toucher à chaque visite.","Ne pas poser sur une plaque trop courte ou sur un hyponychium encore adhérent à la plaque en cours de regrowth. Risque de douleur et de dommage."]
      ]},
      {"type":"placeholder","label":"Photo — progression d'une repousse sur 3 sessions","note":"Exemple visuel de l'évolution d'un ongle rongé sur 8-12 semaines de suivi esthétique progressif — à ajouter depuis l'Atelier Nahira"},
      {"type":"section","label":"Faire"},
      {"type":"text","content":"Réfléchis à la situation suivante et décris ton approche session par session : Une cliente de 24 ans veut arrêter de se ronger les ongles. Elle a des ongles très courts, la plaque est fine mais saine. Elle veut des ongles comme ceux qu'on voit sur Instagram dans 2 semaines.\n— Comment gères-tu ses attentes dès la première consultation ?\n— Que poses-tu (ou ne poses-tu pas) lors de la première session ?\n— Comment structures-tu le suivi sur les 3 prochaines sessions ?\n— Que lui conseilles-tu de faire entre les sessions ?"},
      {"type":"text","content":"Cas pratique : Une cliente arrive avec des ongles très courts et dit avoir essayé plein de techniques sans résultat. Elle espère que la fibre de verre va enfin régler son problème. Comment abordes-tu la conversation ?"},
      {"type":"info","content":"Réponse : Tu l'accueilles avec bienveillance — l'habitude de se ronger les ongles peut être liée au stress, à l'anxiété, à une habitude profondément ancrée. Tu n'es pas là pour la juger, mais pour l'aider à trouver une approche réaliste.\n\nTu expliques clairement : « La fibre de verre peut t'aider à avoir des ongles plus longs en protégeant la plaque au fur et à mesure de la repousse. Mais elle n'empêche pas de se ronger les ongles — si tu continues, le produit partira aussi. Ce qui fait la différence, c'est la repousse naturelle de ton ongle, que je vais pouvoir suivre et soutenir session après session. »\n\nTu ne promets pas de résultat chiffré ni de délai précis. Tu proposes un suivi esthétique progressif avec des sessions régulières (toutes les 3 semaines environ). Ta responsabilité est de poser correctement et d'accompagner techniquement — pas de guérir une habitude. Si la situation relève d'un trouble compulsif important, tu peux orienter vers un professionnel de santé, sans insister."},
      {"type":"warning","content":"Erreur fréquente : Promettre à une cliente que « la fibre va l'empêcher de se ronger les ongles » ou que « ses ongles seront beaux dans un mois ». Ces promesses sont irréalistes, non garantissables, et créent des attentes déçues qui endommagent la relation professionnelle. La transparence dès la première consultation est toujours plus efficace qu'une promesse non tenue."},
      {"type":"info","content":"À retenir :\n— Suivi esthétique progressif ≠ rééducation médicale — la fibre accompagne la repousse, elle ne la génère pas\n— Aucune promesse de résultat ou de délai — chaque ongle évolue à son rythme\n— Adapter le protocole à chaque session selon l'état de la plaque disponible\n— Orienter vers un médecin si une anomalie de repousse semble d'origine médicale"}
    ]$cb$
  );

  -- M6.L5 — Informer la cliente (10 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Informer la cliente — fréquences, entretien à domicile & durée de vie de la pose',
    4, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La durée de vie d'une pose fibre de verre dépend de nombreux facteurs — certains liés à ton travail (qualité de la préparation, qualité de l'encapsulation, choix des produits), d'autres liés à la cliente (hygiène à domicile, activités, mode de vie, chimie corporelle).\n\nInformer la cliente dès la première session, puis régulièrement, est une partie intégrante du service professionnel. Une cliente bien informée :\n— Revient au bon moment (ni trop tôt, ni trop tard)\n— Adopte les bons gestes à domicile\n— Comprend pourquoi une pose peut tenir moins longtemps dans certains contextes\n— Ne cherche pas à arranger elle-même une zone soulevée\n\nLa fréquence de rééquilibrage recommandée est généralement de 3 à 4 semaines — mais c'est un repère, pas une règle absolue. Certaines clientes nécessitent un rééquilibrage à 2,5 semaines (repousse rapide), d'autres peuvent attendre 5 semaines si la pose est en excellent état."},
      {"type":"section","label":"Voir"},
      {"type":"table","headers":["Information","Ce que tu dis"],"rows":[
        ["Fréquence de retour","Je te recommande de revenir dans 3 à 4 semaines. Si tu remarques un soulèvement ou une casse avant, n'hésite pas à me contacter — on peut souvent éviter une dépose complète si on intervient tôt."],
        ["Soin des cuticules à domicile","Applique une huile à cuticules chaque jour ou tous les deux jours — cela entretient la peau autour de l'ongle et favorise une belle repousse."],
        ["Gestes à éviter","Évite d'utiliser tes ongles comme outil (ouvrir des boîtes, gratter des étiquettes). Utilise des gants pour les produits ménagers — surtout les produits acides ou détergents forts."],
        ["En cas de soulèvement","Si un bord se soulève, ne tire pas dessus et ne tente pas de le recoller toi-même. Contacte-moi — une petite réparation rapide vaut mieux qu'un arrachement qui abîme la plaque naturelle."],
        ["Durée de tenue","La tenue varie selon ton mode de vie, ta chimie corporelle et tes activités. Je ne peux pas garantir une durée exacte — mais je ferai mon mieux pour optimiser la tenue avec la bonne technique et les bons produits."]
      ]},
      {"type":"text","content":"Référence : Fiche F4 — Conseils d'entretien à domicile (fiche remise à la cliente après chaque pose — format numérique imprimable, personnalisable)."},
      {"type":"section","label":"Faire"},
      {"type":"text","content":"Entraîne-toi à formuler oralement les 5 informations du tableau ci-dessus — en 2-3 phrases maximum chacune. L'objectif : transmettre l'information de façon claire, simple, sans jargon technique, et sans que la cliente se sente submergée.\n\nTeste avec un proche qui joue le rôle de la cliente. Demande-lui si les consignes lui semblent claires et mémorisables."},
      {"type":"warning","content":"Erreur fréquente : Donner toutes les consignes d'entretien à la fin de la session, quand la cliente est déjà en train de partir. Elle n'aura retenu qu'une partie. Intègre ces informations naturellement en cours de session et remet la fiche F4 qu'elle pourra relire chez elle."},
      {"type":"tip","content":"Astuce : La fiche F4 d'entretien à domicile est aussi un excellent outil de fidélisation — une cliente qui se souvient de comment prendre soin de ses ongles entre les sessions revient avec une pose en meilleur état, ce qui facilite ton travail. Personnalise-la selon son mode de vie (cliente sportive, cliente qui travaille avec ses mains, etc.)."},
      {"type":"info","content":"À retenir :\n— Fréquence recommandée : 3 à 4 semaines — à ajuster selon la cliente et l'état de la pose\n— 5 informations à transmettre : fréquence / huile cuticules / gestes à éviter / que faire si soulèvement / durée de tenue\n— Ne jamais garantir une durée de tenue précise — trop de facteurs en dehors de ton contrôle\n— La fiche F4 complète et formalise les consignes orales"}
    ]$cb$
  );

END;
$seed$;

-- ══════════════════════════════════════════════════════════════════
-- Fiber Signature — Seed M7 : Dépose
-- ══════════════════════════════════════════════════════════════════
DO $seed$
DECLARE
  cid UUID;
  mid UUID;
BEGIN
  SELECT id INTO cid FROM academy_courses WHERE slug = 'fiber-signature' LIMIT 1;

  INSERT INTO academy_modules (course_id, title, sort_order)
  VALUES (cid, 'Dépose — méthodes, protocoles & soin de la plaque naturelle', 7)
  RETURNING id INTO mid;

  -- M7.L1 — Quand et pourquoi déposer (7 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Quand et pourquoi déposer — indications et contre-indications du rééquilibrage',
    0, 8,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La décision de déposer est une décision technique — pas une sanction, pas un constat d'échec. Elle s'impose dans des situations où rééquilibrer aggraverait la situation plutôt que de la résoudre.\n\nOn distingue deux types de dépose :\n— Dépose programmée : décidée à l'avance (fin d'une saison de ongles, volonté de la cliente de faire une pause, changement de système de produits)\n— Dépose non planifiée : nécessitée par l'état de la pose lors de l'évaluation (soulèvements étendus, anomalie de la plaque naturelle, produit trop ancien, incident)\n\nDans les deux cas, la dépose se fait avec méthode — pas en arrachant, pas en forçant, pas en improvisant."},
      {"type":"section","label":"Voir"},
      {"type":"table","headers":["Situation","Décision"],"rows":[
        ["Soulèvements étendus (plus de la moitié de la surface d'un ongle)","Dépose fortement indiquée sur cet ongle — rééquilibrage déconseillé dans cette situation"],
        ["Coloration anormale (verdâtre, blanchâtre, brunâtre) sous le produit","Dépose indiquée — observer attentivement la plaque sans attribuer de cause ; orienter vers professionnel de santé si le signe persiste ou s'aggrave"],
        ["Pose très ancienne (2 mois et plus)","Dépose recommandée — la dégradation du produit compromet l'adhérence de tout nouveau gel"],
        ["Changement de système de produits","Dépose complète recommandée — incompatibilités possibles entre systèmes différents"],
        ["Plaque naturelle très fine ou fragilisée sous le produit","Dépose + pause ou suivi très léger — laisser la plaque respirer"],
        ["Demande de la cliente (arrêt volontaire, pause)","Dépose propre et soignée — même sans indication technique urgente"],
        ["Incident (arrachement partiel, blessure)","Évaluer l'état de la plaque naturelle avant tout — dépose de ce qui reste si nécessaire pour accéder à la zone et évaluer"]
      ]},
      {"type":"section","label":"Vérifier"},
      {"type":"text","content":"Questions de vérification :\n— Quels sont les deux types de dépose et qu'est-ce qui les distingue ?\n— Pourquoi rééquilibrer sur un soulèvement étendu est-il contre-indiqué ?\n— Que fais-tu si tu découvres une coloration anormale sous le produit lors de la dépose ?"},
      {"type":"info","content":"À retenir :\n— Dépose = décision professionnelle motivée, pas un constat d'échec\n— Deux types : programmée (prévisible) / non planifiée (nécessitée par l'état de la pose)\n— Une coloration anormale découverte pendant la dépose s'évalue avant toute reprise de pose"}
    ]$cb$
  );

  -- M7.L2 — Les deux méthodes de dépose (8 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Les deux méthodes de dépose — limage et trempage',
    1, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Il existe deux méthodes principales de dépose, chacune adaptée à des situations et à des types de produits différents :\n— La dépose par limage (mécanique) : on retire le produit couche par couche avec une lime électrique ou une lime manuelle de grain adapté. Efficace pour les gels durs non solubilisables, et plus précise car tu contrôles visuellement la quantité de matière retirée.\n— La dépose par trempage (chimique) : on ramollit le produit avec un solvant (acétone) pour le retirer ensuite sans effort. Adaptée aux produits formulés pour être déposés chimiquement, moins adaptée aux gels durs ou aux gels fibre encapsulés qui ne se dissolvent généralement pas facilement."},
      {"type":"info","content":"Note fabricant : La méthode de dépose recommandée dépend du gel utilisé. Consulte toujours les instructions de ton fabricant pour connaître la méthode adaptée à ton système de produits. Certains gels ne sont pas solubles à l'acétone — une dépose par trempage sera inefficace et perdra du temps. D'autres sont formulés pour être retirés chimiquement — un limage excessif serait inutilement long et agressif."},
      {"type":"section","label":"Voir"},
      {"type":"table","headers":["","Dépose par limage","Dépose par trempage"],"rows":[
        ["Principe","Retrait mécanique couche par couche","Ramollissement chimique + retrait"],
        ["Produits adaptés","Gels durs, gels construction, gels non solubles à l'acétone","Produits formulés solubles (vérifier avec le fabricant)"],
        ["Durée","Variable selon l'épaisseur — généralement 10 à 20 min par ongle si manuel","Variable selon le produit — trempage de 10 à 30 min selon la formulation"],
        ["Contrôle","Visuel et précis — tu vois ce que tu retires en temps réel","Moins de contrôle direct pendant le trempage"],
        ["Risque principal","Limage excessif de la plaque naturelle si on ne s'arrête pas au bon moment","Déshydratation de la plaque et de la peau si temps de contact trop long"],
        ["Signal d'arrêt","Changement de couleur de la poudre sous la lime (on passe du blanc-mat au rosé translucide de la plaque naturelle)","Produit mou et détachable sans effort — ne jamais forcer"]
      ]},
      {"type":"section","label":"Vérifier"},
      {"type":"text","content":"Questions de vérification :\n— Quelles sont les deux méthodes de dépose et leur principe respectif ?\n— Pourquoi les instructions du fabricant sont-elles indispensables pour choisir la méthode de dépose ?\n— Quel est le risque principal de la dépose par limage, et comment l'éviter ?\n— Quel est le risque principal de la dépose par trempage, et comment l'éviter ?"},
      {"type":"info","content":"À retenir :\n— Deux méthodes : limage (mécanique) et trempage (chimique)\n— Le choix dépend du produit utilisé — toujours vérifier avec les instructions du fabricant\n— Dépose par limage : arrêter au changement de couleur sous la lime\n— Dépose par trempage : jamais forcer — si ça résiste, le produit n'est pas suffisamment ramolli"}
    ]$cb$
  );

  -- M7.L3 — Protocole de dépose par limage (20 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Protocole de dépose par limage — précision et respect de la plaque naturelle',
    2, 12,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La dépose par limage est la méthode la plus précise — et aussi la plus exigeante en attention. L'erreur la plus grave est de limer la plaque naturelle en croyant encore limer le produit. Ce risque existe parce que la transition entre produit et plaque naturelle n'est pas toujours visuellement évidente lors du limage.\n\nLe signal clé : le changement de couleur des résidus sous la lime. Tant que tu vois de la poudre blanche ou légèrement colorée selon le gel, tu es encore dans le produit. Quand la poudre devient rosée, translucide, ou quasi-absente, tu arrives sur la plaque naturelle. Tu t'arrêtes.\n\nUn autre signal : la sensation sous la lime. Le produit durci résiste différemment de la plaque naturelle — plus souple, moins croquante. Ce signal demande de la pratique pour être perçu avec précision."},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Vidéo — Dépose par limage couche par couche","note":"Démonstration : grains utilisés, sens de limage, lecture des signaux d'arrêt — à ajouter depuis l'Atelier Nahira"},
      {"type":"text","content":"Dans la vidéo, observe :\n— Le grain de lime utilisé au début (plus grossier pour retirer rapidement le volume) vs à la fin (plus fin pour approcher la plaque)\n— Le moment où la couleur des résidus change\n— Le geste d'arrêt et la vérification visuelle de la plaque restante"},
      {"type":"section","label":"Protocole"},
      {"type":"step","number":1,"title":"Raccourcir le bord libre au maximum","content":"Avec une pince ou un coupe-ongles adapté. Moins il y a de volume à retirer, plus la dépose est rapide et précise."},
      {"type":"step","number":2,"title":"Limer le volume principal avec un grain grossier","content":"À titre indicatif : 80-100, sur la surface du produit, dans un seul sens. Objectif : retirer le volume rapidement. Arrêter quand la surface est aplanie et qu'il reste environ 1-2 mm de produit apparent. Adapte le grain à ton matériel."},
      {"type":"step","number":3,"title":"Passer à un grain plus fin pour approcher la plaque naturelle","content":"À titre indicatif : 150-180 — travailler plus lentement, en couches très fines. Observer la couleur des résidus à chaque passage."},
      {"type":"step","number":4,"title":"S'arrêter dès le changement de couleur des résidus","content":"Poudre rosée ou translucide = tu arrives sur la plaque naturelle. Arrêter immédiatement."},
      {"type":"step","number":5,"title":"Vérifier visuellement la plaque restante","content":"Y a-t-il encore du produit résiduel ? La plaque est-elle intacte ? Passer un buffer doux sur les zones restantes si nécessaire."},
      {"type":"step","number":6,"title":"Finir avec un buffer très doux","content":"À titre indicatif : 220 ou plus doux — pour ôter les légères irrégularités de surface sans retirer de matière de la plaque naturelle."},
      {"type":"step","number":7,"title":"Ôter toute la poussière","content":"Brosse propre, puis passer à l'évaluation de la plaque naturelle (voir M7.L5)."},
      {"type":"section","label":"Vérifier"},
      {"type":"text","content":"Questions de vérification :\n— Quel est le signal principal qui t'indique que tu arrives sur la plaque naturelle ?\n— Pourquoi commencer avec un grain grossier puis finir avec un grain fin ?\n— Que fais-tu si tu as limé la plaque naturelle par erreur (sensation de chaleur, plaque trop fine) ?"},
      {"type":"text","content":"Cas pratique : En cours de dépose par limage, tu réalises que sur un doigt, la plaque naturelle est devenue visible très vite — beaucoup plus tôt que sur les autres ongles. La surface est légèrement translucide. La cliente ne dit rien. Que fais-tu ?"},
      {"type":"info","content":"Réponse : Tu t'arrêtes immédiatement sur cet ongle. Tu évalues : la plaque est-elle intacte ? Y a-t-il une sensation de chaleur ou d'inconfort pour la cliente ?\n\nSi la plaque est intacte et la cliente ne ressent rien de particulier : tu as simplement atteint la plaque naturelle plus vite — ce qui peut arriver si la pose était plus fine sur ce doigt, ou si l'ongle naturel est naturellement plus fin. Tu passes au buffer doux pour régulariser la surface sans retirer davantage.\n\nSi la plaque semble légèrement amincie (aspect très translucide, légère sensibilité) : tu notes l'information, tu informes la cliente calmement, et tu hydrates bien la plaque après la dépose. Pour la prochaine pose sur cet ongle : préparation encore plus douce.\n\nDans tous les cas : ne pas paniquer, ne pas sur-expliquer, ne pas mentir. Informer calmement et adapter ton geste."},
      {"type":"warning","content":"Erreur fréquente : Limer en va-et-vient rapide sur toute la surface pour aller vite. Ce mouvement génère de la chaleur, rend difficile la lecture des signaux de couleur, et augmente le risque de dépasser la plaque naturelle sur les zones déjà plus fines. Limer avec méthode — dans un sens, par sections — est toujours plus sûr et souvent plus rapide."},
      {"type":"tip","content":"Astuce : Si tu utilises une lime électrique, réduis la vitesse quand tu approches de la plaque naturelle. Haute vitesse pour le volume, basse vitesse pour la précision. Le contrôle du signal de couleur est plus facile à basse vitesse — tu vois ce que tu fais."},
      {"type":"info","content":"À retenir :\n— 7 étapes : raccourcir → grain grossier (ex. 80-100, indicatif) → grain fin d'approche (ex. 150-180, indicatif) → arrêter au changement de couleur → vérifier → buffer très doux (ex. 220+, indicatif) → dépoussiérer\n— Signal d'arrêt : couleur des résidus rosée ou translucide = plaque naturelle atteinte\n— Grain grossier pour le volume, grain fin pour l'approche — jamais l'inverse\n— Une lime électrique : basse vitesse pour la phase finale"}
    ]$cb$
  );

  -- M7.L4 — Protocole de dépose par trempage (18 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Protocole de dépose par trempage — méthode douce et limites',
    3, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"La dépose par trempage repose sur l'action d'un solvant (généralement l'acétone) pour ramollir le produit et le décoller de la plaque naturelle sans effort mécanique. Son efficacité dépend entièrement de la formulation du produit — certains gels de construction fibre de verre sont formulés pour ne pas se dissoudre à l'acétone, rendant cette méthode peu ou pas adaptée.\n\nAvant d'utiliser la dépose par trempage : vérifier avec les instructions de ton fabricant que ton gel est soluble à l'acétone. Si ce n'est pas spécifié, tester sur un tip avant de l'appliquer sur cliente.\n\nDeux variantes de la méthode :\n— Trempage direct : immersion des doigts dans un bol d'acétone (moins précis, déshydrate davantage la peau)\n— Wraps (méthode recommandée) : compresses imbibées d'acétone maintenues sur chaque ongle avec du papier aluminium ou des clips dédiés — limitent le contact de l'acétone avec la peau environnante"},
      {"type":"section","label":"Protocole"},
      {"type":"step","number":1,"title":"Raccourcir le bord libre","content":"Couper à la pince ou coupe-ongles avant tout trempage. Moins de volume = trempage plus rapide."},
      {"type":"step","number":2,"title":"Limer légèrement la surface","content":"Avec un grain médium (à titre indicatif : 150-180), pour briser le scellement superficiel du gel et permettre à l'acétone de pénétrer. Ce limage est léger — quelques passages, pas une dépose mécanique complète. Adapte le grain à ton matériel et aux recommandations de ton fabricant."},
      {"type":"step","number":3,"title":"Protéger la peau autour de l'ongle","content":"Appliquer de la crème ou de l'huile sur les cuticules et la peau environnante pour limiter la déshydratation due à l'acétone."},
      {"type":"step","number":4,"title":"Préparer les wraps","content":"Compresses non-tissées coupées à la taille de l'ongle, généreusement imbibées d'acétone. Les placer sur chaque ongle et maintenir avec du papier aluminium ou des clips."},
      {"type":"step","number":5,"title":"Laisser agir selon le temps recommandé par le fabricant","content":"Généralement 10 à 20 minutes. Ne pas raccourcir le temps si le produit est encore résistant."},
      {"type":"step","number":6,"title":"Vérifier l'état du produit","content":"Retirer un wrap, tester avec un repousse-cuticules ou une spatule : le produit doit se décoller facilement, sans effort. Si ce n'est pas le cas, prolonger de 5 minutes et retester."},
      {"type":"step","number":7,"title":"Retirer le produit ramolli doucement","content":"Avec un repousse-cuticules ou une spatule plate. Jamais forcer — si ça résiste, remettre le wrap et prolonger."},
      {"type":"step","number":8,"title":"Finir avec un buffer doux","content":"Pour uniformiser la surface de la plaque naturelle."},
      {"type":"step","number":9,"title":"Hydrater immédiatement","content":"Huile ou crème cuticules sur toute la zone. L'acétone déshydrate — ne pas laisser les ongles sans soin après la dépose."},
      {"type":"info","content":"Note fabricant : Le temps de trempage, la concentration d'acétone et la compatibilité du gel sont définis par ton fabricant. Ces indications priment sur toute recommandation générique."},
      {"type":"section","label":"Vérifier"},
      {"type":"text","content":"Questions de vérification :\n— Pourquoi la dépose par trempage ne convient pas à tous les gels ?\n— Quelle est la différence entre trempage direct et méthode wraps ?\n— Que fais-tu si le produit résiste après le temps de trempage initial ?\n— Pourquoi est-il important d'hydrater immédiatement après la dépose par trempage ?"},
      {"type":"warning","content":"Erreur fréquente : Forcer le produit à se retirer parce que le temps de trempage est écoulé. Le temps indiqué est indicatif — la vraie indication est l'état du produit. Si ça résiste encore, ce n'est pas que la méthode a échoué — c'est que le gel a besoin de plus de temps (ou qu'il n'est pas soluble à l'acétone). Forcer abîme la plaque naturelle."},
      {"type":"tip","content":"Astuce : Utilise des clips de dépose plutôt que du papier aluminium — ils sont réutilisables, maintiennent mieux la compresse en contact avec l'ongle, et libèrent tes deux mains pendant le temps de trempage. Investissement simple qui améliore le confort de la prestation."},
      {"type":"info","content":"À retenir :\n— Trempage = uniquement si le gel du fabricant est formulé pour l'acétone\n— Méthode wraps recommandée — moins agressive pour la peau que le trempage direct\n— Ne jamais forcer le produit qui résiste — prolonger le temps ou changer de méthode\n— Hydrater immédiatement après toute dépose à l'acétone"}
    ]$cb$
  );

  -- M7.L5 — Évaluation & soin de la plaque naturelle après dépose (17 blocs)
  INSERT INTO academy_lessons (module_id, course_id, title, sort_order, duration_minutes, content_blocks)
  VALUES (mid, cid,
    'Évaluation & soin de la plaque naturelle après dépose',
    4, 10,
    $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"Après toute dépose, la plaque naturelle est accessible. C'est le moment d'effectuer une observation complète — dans les mêmes termes que l'observation préalable à la pose initiale (M4.L1) — et de décider de la suite :\n— Reposer immédiatement : si la plaque est en bon état et la cliente souhaite continuer\n— Proposer une pause : si la plaque est fine ou fragilisée. La pose peut reprendre après quelques semaines de soin intensif à domicile\n— Orienter vers un médecin : si une anomalie est découverte (coloration anormale persistante, texture suspecte, décollement)\n\nLa dépose est aussi l'occasion d'évaluer si ton protocole de pose est adapté à cette cliente : la plaque est-elle plus fine qu'avant le début des poses ? Y a-t-il des stries récentes ? Des zones de fragilité localisées ? Ces informations guident le protocole de la prochaine pose si elle reprend."},
      {"type":"section","label":"Voir"},
      {"type":"table","headers":["État de la plaque après dépose","Orientation"],"rows":[
        ["Plaque saine, épaisseur normale, couleur régulière","Reprise de pose possible selon les souhaits de la cliente, après soin d'hydratation"],
        ["Plaque légèrement amincie ou striée","Reprise possible avec protocole allégé — limage minimal, construction très douce. Proposer une ou deux semaines de soin si la cliente peut attendre."],
        ["Plaque très fine, transparente, sensible","Pause recommandée — soin intensif à domicile sur 2 à 4 semaines avant de reprendre. Éviter toute pose en attendant."],
        ["Coloration anormale persistante sur la plaque naturelle","Ne pas reposer — orienter vers médecin pour évaluation. La coloration peut disparaître avec le temps ou signaler une anomalie à traiter."],
        ["Plaque en excellent état","Reprise immédiate possible si souhaitée — protocole standard."]
      ]},
      {"type":"placeholder","label":"Photo — plaque naturelle après dépose propre vs dépose trop agressive","note":"Comparatif visuel : plaque intacte vs plaque légèrement amincie — à ajouter depuis l'Atelier Nahira"},
      {"type":"section","label":"Protocole de soin immédiat"},
      {"type":"step","number":1,"title":"Observation complète de la plaque naturelle","content":"Couleur, épaisseur, texture, cuticules, peau environnante. Appliquer la grille d'observation de M4.L1."},
      {"type":"step","number":2,"title":"Tamponner doucement avec une compresse sèche","content":"Pour ôter les résidus d'acétone ou de poussière de limage."},
      {"type":"step","number":3,"title":"Appliquer généreusement une huile cuticules ou une crème nourrissante","content":"Masser doucement autour de chaque ongle. Laisser absorber quelques minutes."},
      {"type":"step","number":4,"title":"Évaluer la décision","content":"Reposer, pause, ou orientation médicale selon l'état observé."},
      {"type":"step","number":5,"title":"Informer la cliente","content":"Lui expliquer l'état de sa plaque, ta recommandation, et les soins à faire à domicile dans les jours qui suivent (huile quotidienne, éviter le contact agressif avec les produits ménagers, laisser respirer)."},
      {"type":"text","content":"Cas pratique : Après une dépose par limage, tu remarques que la plaque d'un ongle est nettement plus fine que les autres — presque transparente. La cliente n'a rien senti pendant la dépose. Comment gères-tu la situation et la conversation avec la cliente ?"},
      {"type":"info","content":"Réponse : Tu évalues d'abord : s'agit-il d'un ongle qui a toujours été plus fin (certaines personnes ont naturellement un ongle plus fin sur un doigt particulier), ou y a-t-il eu un limage excessif lors de cette dépose ou des déposées précédentes ?\n\nQuelle que soit la cause, tu informes la cliente de façon transparente et calme : « Je vois que cet ongle est plus fin que les autres aujourd'hui — je vais en tenir compte pour la suite. » Tu n'amplifies pas, tu ne dramatises pas, mais tu n'esquives pas non plus.\n\nSi l'ongle est très fin : tu recommandes une pause sur cet ongle en particulier — pas de reprise immédiate. Tu proposes de reposer sur les 9 autres et de laisser celui-ci sans produit le temps qu'il reprenne un peu d'épaisseur. Conseils à domicile : huile cuticules quotidienne, pas d'exposition aux solvants.\n\nTu notes dans ton suivi client l'état de cet ongle — pour adapter ton protocole de dépose et de pose à la prochaine session."},
      {"type":"warning","content":"Erreur fréquente : Reposer immédiatement sur une plaque fragilisée parce que la cliente ne veut pas rester sans ongles. La pose sur une plaque trop fine aggrave la fragilité et raccourcit la tenue de la prochaine pose. Prendre le temps d'expliquer et de proposer une pause courte est un service, pas un refus."},
      {"type":"tip","content":"Astuce : Après une dépose par acétone, propose à la cliente de laisser ses ongles respirer pendant la durée de la session (sans eau ni produit ménager) avant de reposer. Même 20 à 30 minutes d'hydratation à l'huile avant la repréparation améliorent l'état de départ de la plaque."},
      {"type":"info","content":"À retenir :\n— Après toute dépose : observation complète de la plaque naturelle avant toute décision\n— 3 issues possibles : reposer / pause / orientation médicale — selon l'état observé\n— Informer la cliente de l'état de sa plaque et des soins à domicile recommandés\n— Ne jamais reposer sur une plaque fragilisée sous pression"},
      {"type":"je_maitrise","items":["Je sais quand déposer et pourquoi — et je peux l'expliquer à une cliente sans créer d'inquiétude inutile","Je connais les deux méthodes de dépose et sais choisir la bonne selon le produit utilisé","Je maîtrise le protocole de dépose par limage et sais reconnaître le signal d'arrêt","Je maîtrise le protocole de dépose par trempage (wraps) et sais adapter le temps selon la réaction du produit","J'évalue systématiquement la plaque naturelle après dépose avant de décider de la suite"]}
    ]$cb$
  );

END;
$seed$;
