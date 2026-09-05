-- ══════════════════════════════════════════════════════════════════
-- Corrections M9.L4 — Signes d'alerte unguéaux
-- ══════════════════════════════════════════════════════════════════
-- Corrections appliquées :
-- 1. Titre : "Pathologies unguéales — reconnaître & décider"
--            → "Signes d'alerte unguéaux — observer & décider"
-- 2. Section label tableau : label complet restauré
-- 3. Fiche F6 : bloc text ajouté après le tableau
-- 4. Placeholder photo : note complète restaurée
-- 5. Cas client : phrase d'observation complète + phrase finale restaurées

DO $fix$
DECLARE
  lid UUID;
BEGIN
  SELECT al.id INTO lid
  FROM academy_modules am
  JOIN academy_lessons al ON al.module_id = am.id
  WHERE am.sort_order = 9 AND al.sort_order = 3
  LIMIT 1;

  UPDATE academy_lessons
  SET
    title = 'Signes d''alerte unguéaux — observer & décider',
    content_blocks = $cb$[
      {"type":"section","label":"Comprendre"},
      {"type":"text","content":"En tant qu'esthéticienne, le rôle n'est pas de diagnostiquer — c'est celui d'un médecin ou d'un dermatologue. Le rôle est de reconnaître les signes qui rendent une prestation impossible ou à risque, et de prendre la décision appropriée : adapter le protocole, travailler uniquement sur les zones non concernées, ou reporter la prestation.\n\nL'objectif de cette leçon est de former à la reconnaissance visuelle des signes d'alerte les plus fréquents — pas à leur traitement."},
      {"type":"section","label":"Tableau des signes d'alerte unguéaux — observation et conduite professionnelle"},
      {"type":"table","headers":["Signe observé","Conduite professionnelle"],"rows":[
        ["Taches blanches ou jaunâtres sous la plaque · décollement partiel · odeur inhabituellement forte ou déplaisante","✗ Ne pas réaliser la prestation sur l'ongle concerné · évaluer l'ensemble des ongles avant toute prestation sur les autres · orienter vers professionnel de santé"],
        ["Plaque très épaissie · couleur altérée (jaunâtre, brunâtre ou verdâtre) · texture friable · déformation progressive","✗ Reporter la prestation complète · orienter vers professionnel de santé"],
        ["Petits puits ou creux dans la surface de la plaque (ponctations) · épaississement · décollement partiel du lit · peau adjacente rougie ou épaissie","△ Évaluer au cas par cas · si plaque stable et peau non lésée → possible avec précautions · si zone rougie, irritée ou douloureuse → reporter et orienter vers professionnel de santé"],
        ["Repli latéral rouge, gonflé ou douloureux · ongle poussant dans la chair au niveau du bord latéral","✗ Ne pas travailler sur la zone concernée · orienter vers médecin ou podologue"],
        ["Bande colorée sombre (noire, brune ou grisâtre) s'étendant dans le sens de la longueur sous la plaque, de la base vers le bord libre","✗ Pigmentation longitudinale nouvelle, inexpliquée ou évolutive : ne pas masquer la zone · recommander une évaluation par un professionnel de santé avant toute prestation sur cet ongle"],
        ["Décollement visible de la plaque sur une zone · espace entre la plaque et le lit de l'ongle","△ Ne pas appliquer de produit sur la zone décollée · évaluer si la prestation peut être réalisée sur les autres ongles sans risque · orienter vers professionnel de santé si le décollement est étendu, inexpliqué ou persistant"],
        ["Petite tache sombre (noire ou brunâtre) localisée sous la plaque ou sur le repli proximal · zone délimitée · ne s'étend pas sur la longueur","✓ Possible si la plaque est intacte et sans signe d'alerte (rougeur, gonflement, douleur ou odeur inhabituelle) · informer la cliente · surveiller l'évolution à la prochaine visite"]
      ]},
      {"type":"text","content":"📄 Fiche F6 — Grille d'observation des signes d'alerte & conduite professionnelle (téléchargeable · plastifiable pour poste de travail)"},
      {"type":"section","label":"Voir"},
      {"type":"placeholder","label":"Photos — Signes visuels à reconnaître","note":"Les 7 signes du tableau : taches/décollement/odeur · plaque épaissie et altérée · ponctations · repli latéral gonflé · bande longitudinale sombre · décollement · tache localisée sombre — photos libres de droits ou illustrations à intégrer depuis l'Atelier Nahira — photos de signes visuels réels à sourcer avec soin"},
      {"type":"text","content":"Cas client — Ongle avec tache blanche et légère odeur :\nSituation : en préparant l'ongle du majeur, tu constates une tache blanche sous la plaque avec un léger décollement et une odeur particulière.\nObservation : tu constates une tache blanche et un léger décollement avec une odeur particulière. Tu ne peux pas déterminer l'origine de ce signe — mais tu peux décrire ce que tu vois et décider de la conduite à tenir.\nAction : ne pas continuer sur cet ongle ; expliquer calmement à la cliente ce que tu observes (décrire uniquement — ne pas nommer, ne pas interpréter) ; évaluer la situation globale — y a-t-il des signes similaires sur d'autres ongles ? Si les autres ongles ne présentent aucun signe d'alerte et que le travail peut être réalisé de façon indépendante sans contact avec l'ongle concerné, la prestation peut être envisagée sur les ongles non touchés en appliquant des mesures d'hygiène strictes entre chaque ongle ; recommander une évaluation par un professionnel de santé pour l'ongle concerné ; documenter sur la fiche cliente avec date et description de l'observation.\nIl est inutile de présenter cela comme une \"mauvaise nouvelle\" : l'objectif est d'orienter la cliente vers une évaluation adaptée, sans créer d'inquiétude inutile."},
      {"type":"warning","content":"Poser sur un ongle présentant un signe d'alerte pour 'voir ce que ça donne' ou pour ne pas décevoir la cliente : masquer un signe d'alerte sous une pose empêche toute observation ultérieure et peut retarder une prise en charge nécessaire. L'esthéticienne engage sa responsabilité professionnelle."},
      {"type":"tip","content":"Préparer une phrase d'explication simple et non alarmiste pour informer la cliente sans nommer ni interpréter : 'J'observe quelque chose sur cet ongle qui me demande de ne pas travailler dessus aujourd'hui — je te recommande de le faire regarder par un professionnel de santé. Selon l'état des autres ongles, on peut évaluer ensemble si on continue sur ceux-là.'"},
      {"type":"info","content":"À retenir :\n— Reconnaître ≠ diagnostiquer — orienter, pas traiter\n— Toute ligne sombre longitudinale → arrêt total, orientation dermatologue immédiate\n— Tache blanche ou jaunâtre, décollement, odeur inhabituelle → pas de pose sur l'ongle concerné · évaluation globale avant toute prestation sur les autres ongles\n— Documenter sur la fiche cliente — date, observation, décision prise"},
      {"type":"je_maitrise","items":["Je peux citer 5 signes d'alerte unguéaux et la décision associée","Je sais expliquer à une cliente pourquoi je ne peux pas réaliser la prestation sur un ongle","Je comprends que masquer un signe d'alerte sous une pose engage ma responsabilité professionnelle"]}
    ]$cb$
  WHERE id = lid;
END;
$fix$;
