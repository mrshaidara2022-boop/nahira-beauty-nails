/**
 * academy-renderer.js — Nahira Academy shared block renderer
 * Source unique pour le rendu des content_blocks.
 * Utilisé par lecon.html (rendu élève) et editeur.html (canvas WYSIWYG).
 */
(function (global) {
  'use strict';

  function esc(s) {
    return String(s || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
  }

  /**
   * Render one block's HTML (no edit wrappers).
   * @param {object} block   - block object from content_blocks
   * @param {number} idx     - index in the array (used for step numbering)
   * @param {object} opts    - { mediaMap:{}, materials:[], studentMode:bool }
   * @returns {string} HTML
   */
  function renderBlock(block, idx, opts) {
    opts = opts || {};
    var mediaMap  = opts.mediaMap  || {};
    var materials = opts.materials || [];

    // Hidden blocks invisible to students
    if (block.hidden && opts.studentMode) return '';

    var c = block.content !== undefined ? block.content : (block.text || '');

    switch (block.type) {

      case 'text':
        return '<div class="block-text">' +
          c.split('\n').map(function (l) { return l ? '<p>' + esc(l) + '</p>' : ''; }).join('') +
          '</div>';

      case 'heading':
        return '<h2 class="block-heading">' + esc(c) + '</h2>';

      case 'section':
        return '<div class="block-section">' + esc(block.label || c) + '</div>';

      case 'divider':
        return '<hr class="block-divider">';

      case 'tip':
        return '<div class="block-tip">' + esc(c).replace(/\n/g, '<br>') + '</div>';

      case 'warning':
        return '<div class="block-warning">' + esc(c).replace(/\n/g, '<br>') + '</div>';

      case 'info':
        return '<div class="block-info">' + esc(c).replace(/\n/g, '<br>') + '</div>';

      case 'step': {
        var stepTitle = block.title
          ? '<strong style="color:var(--texte)">' + esc(block.title) + '</strong><br>'
          : '';
        var n = block.number !== undefined ? block.number : (idx + 1);
        return '<div class="block-step">' +
          '<div class="block-step-num">' + n + '</div>' +
          '<div>' + stepTitle + esc(c) + '</div>' +
          '</div>';
      }

      case 'material': {
        var mItems = Array.isArray(block.items) ? block.items : [];
        return '<div class="block-material">' +
          (block.title ? '<h4>' + esc(block.title) + '</h4>' : '') +
          '<ul>' + mItems.map(function (i) { return '<li>' + esc(i) + '</li>'; }).join('') + '</ul>' +
          '</div>';
      }

      case 'list': {
        var lItems = Array.isArray(block.items)
          ? block.items
          : (c ? c.split('\n').filter(Boolean) : []);
        return '<ul class="block-list">' +
          lItems.map(function (i) { return '<li>' + esc(i) + '</li>'; }).join('') +
          '</ul>';
      }

      case 'gallery': {
        var imgs = Array.isArray(block.images) ? block.images : [];
        if (!imgs.length) return '<div class="block-gallery" style="border:2px dashed var(--ligne);border-radius:10px;padding:24px;text-align:center;color:var(--texte-pale);font-size:.8rem">Galerie vide</div>';
        return '<div class="block-gallery">' +
          imgs.map(function (img) {
            var src = typeof img === 'string' ? img : img.url;
            var alt = typeof img === 'object' ? (img.alt || '') : '';
            return '<img src="' + esc(src) + '" alt="' + esc(alt) + '" loading="lazy">';
          }).join('') +
          '</div>';
      }

      case 'image':
        return '<figure class="block-image">' +
          '<img src="' + esc(block.url || '') + '" alt="' + esc(block.alt || '') + '">' +
          (block.caption ? '<figcaption>' + esc(block.caption) + '</figcaption>' : '') +
          '</figure>';

      case 'video': {
        var vUrl = block.url || '';
        var vHtml = '';
        if (/youtu\.be|youtube\.com/.test(vUrl)) {
          var vid = (vUrl.match(/(?:v=|youtu\.be\/)([^&?]+)/) || [])[1] || '';
          vHtml = '<iframe src="https://www.youtube.com/embed/' + vid + '" allow="autoplay;encrypted-media" allowfullscreen loading="lazy"></iframe>';
        } else if (/vimeo\.com/.test(vUrl)) {
          var vvid = (vUrl.match(/vimeo\.com\/(\d+)/) || [])[1] || '';
          vHtml = '<iframe src="https://player.vimeo.com/video/' + vvid + '" allow="autoplay;fullscreen" allowfullscreen loading="lazy"></iframe>';
        } else if (vUrl) {
          vHtml = '<video src="' + esc(vUrl) + '" controls playsinline></video>';
        } else {
          vHtml = '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:rgba(255,255,255,.4);font-size:.8rem">Aucune vidéo configurée</div>';
        }
        return '<div class="block-video-inline">' + vHtml + '</div>';
      }

      case 'je_maitrise': {
        var jmItems = Array.isArray(block.items) ? block.items : [];
        var jmBody = jmItems.map(function (i) {
          return '<p style="margin:0 0 6px;padding-left:1.2em;text-indent:-1.2em">✓ ' + esc(i) + '</p>';
        }).join('');
        return '<div class="block-je-maitrise">' + jmBody + (c ? esc(c) : '') + '</div>';
      }

      case 'table': {
        var tH = Array.isArray(block.headers) ? block.headers : [];
        var tR = Array.isArray(block.rows)    ? block.rows    : [];
        return '<div class="block-table-wrap"><table class="block-table">' +
          '<thead><tr>' + tH.map(function (h) { return '<th>' + esc(h) + '</th>'; }).join('') + '</tr></thead>' +
          '<tbody>' + tR.map(function (r) {
            return '<tr>' + (Array.isArray(r) ? r : []).map(function (cell) {
              return '<td>' + esc(String(cell === null || cell === undefined ? '' : cell)) + '</td>';
            }).join('') + '</tr>';
          }).join('') + '</tbody>' +
          '</table></div>';
      }

      case 'fiche': {
        // Resolution order:
        // 1. block.material_id → find in materials by id
        // 2. block.num (e.g. 'F6') → find in materials by fiche_num
        // 3. Fallback: use block.num, block.title, block.filename directly (legacy blocks)
        var mat = null;
        if (block.material_id) {
          mat = materials.find(function (m) { return m.id === block.material_id; }) || null;
        }
        if (!mat && block.num) {
          mat = materials.find(function (m) { return m.fiche_num === block.num; }) || null;
        }
        var fNum   = mat ? (mat.fiche_num || '') : (block.num   || '');
        var fTitle = mat ? mat.title             : (block.title || 'Fiche PDF');
        var fHref  = mat ? mat.file_url          : (block.filename ? '/fiches-pdf/' + block.filename : '#');
        var fDown  = block.filename || (fHref !== '#' ? fHref.split('/').pop() : '');
        return '<div class="block-fiche">' +
          '<div class="block-fiche-badge">' + esc(fNum) + '</div>' +
          '<div class="block-fiche-info">' +
            '<div class="block-fiche-label">Fiche de référence</div>' +
            '<div class="block-fiche-title">' + esc(fTitle) + '</div>' +
          '</div>' +
          '<a class="block-fiche-btn" href="' + esc(fHref) + '" download="' + esc(fDown) + '" target="_blank">Télécharger</a>' +
          '</div>';
      }

      case 'placeholder': {
        var pid = block.id || '';
        var resolved = mediaMap[pid];
        if (resolved) {
          var isVid = pid.indexOf('VIDEO_') === 0;
          if (isVid) {
            return '<div class="block-video">' +
              '<video controls preload="metadata" style="width:100%;max-width:100%;border-radius:10px;background:#000;display:block">' +
              '<source src="' + esc(resolved) + '">' +
              '<p style="color:var(--texte-pale);text-align:center;padding:20px;font-family:Montserrat,sans-serif;font-size:.8rem">Votre navigateur ne supporte pas la lecture vidéo.</p>' +
              '</video></div>';
          } else {
            return '<div class="block-image"><img src="' + esc(resolved) + '" alt="" style="max-width:100%;border-radius:10px;display:block"></div>';
          }
        } else {
          var isVidPh = pid.indexOf('VIDEO_') === 0;
          var phIcon  = isVidPh ? '🎬' : '📸';
          var phLabel = isVidPh ? 'Vidéo de démonstration à venir' : 'Photo illustrative à venir';
          return '<div class="block-placeholder">' +
            '<span class="block-placeholder-icon">' + phIcon + '</span>' +
            '<div class="block-placeholder-info">' +
              '<div class="block-placeholder-id">' + esc(pid) + '</div>' +
              '<div class="block-placeholder-label">' + phLabel + '</div>' +
            '</div></div>';
        }
      }

      default:
        return '<div style="padding:12px;border:1px dashed var(--ligne);border-radius:8px;color:var(--texte-pale);font-size:.8rem">Bloc inconnu : ' + esc(block.type) + '</div>';
    }
  }

  /**
   * Render an array of blocks as an HTML string (no edit wrappers).
   * @param {Array}  blocks
   * @param {object} opts   - same as renderBlock opts
   * @returns {string} HTML
   */
  function renderBlocks(blocks, opts) {
    if (!Array.isArray(blocks)) return '';
    return blocks.map(function (b, i) { return renderBlock(b, i, opts); }).join('');
  }

  global.NahiraRenderer = { renderBlock: renderBlock, renderBlocks: renderBlocks };

})(window);
