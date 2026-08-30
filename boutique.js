/* ============ NAHIRA BEAUTY NAILS — moteur boutique V2 ============ */
/* Nécessite : <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script> */
/* Concept : Lazy Girl Nails — manucure soignée, rapide, sans rendez-vous               */

const NAHIRA = (() => {
  const SUPABASE_URL    = "https://mxbmjtzrggahbwahxmkp.supabase.co";
  const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14Ym1qdHpyZ2dhaGJ3YWh4bWtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyMzc5NDQsImV4cCI6MjA5NjgxMzk0NH0.iTibkVCaTZYoMzQO4TQvddlKeZY40vNcfJ-kEgIHXpE";
  const CHECKOUT_URL    = SUPABASE_URL + "/functions/v1/create-checkout";
  const CART_KEY        = "nahira_cart";

  const sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

  /* ─── PANIER ──────────────────────────────────────────────────────────────
     Format V2 : [{ product_id, slug, name, price_cents, image_url, quantity }]
     Rétrocompatible V1 : si un item a `size`/`custom`, il reste lisible.
  ──────────────────────────────────────────────────────────────────────────── */
  function getCart() {
    try { return JSON.parse(localStorage.getItem(CART_KEY) || "[]"); }
    catch { return []; }
  }
  function saveCart(cart) {
    localStorage.setItem(CART_KEY, JSON.stringify(cart));
    updateBadge();
  }

  function addToCart({ product_id, slug, name, price_cents, image_url, quantity = 1 }) {
    const c = getCart();
    const existing = c.find(it => it.product_id === product_id);
    if (existing) {
      existing.quantity = (existing.quantity || 1) + quantity;
    } else {
      c.push({ product_id, slug, name, price_cents, image_url, quantity });
    }
    saveCart(c);
  }

  function updateCartQuantity(productId, qty) {
    const c = getCart();
    const idx = c.findIndex(it => it.product_id === productId);
    if (idx < 0) return;
    if (qty <= 0) { c.splice(idx, 1); } else { c[idx].quantity = qty; }
    saveCart(c);
  }

  function removeFromCart(productId) {
    saveCart(getCart().filter(it => it.product_id !== productId));
  }

  function clearCart() { saveCart([]); }

  // Nombre total d'articles (somme des quantités)
  function cartCount() {
    return getCart().reduce((s, it) => s + (it.quantity || 1), 0);
  }

  // Sous-total en centimes
  function cartSubtotal() {
    return getCart().reduce((s, it) => s + (it.price_cents || 0) * (it.quantity || 1), 0);
  }

  function updateBadge() {
    const n = cartCount();
    document.querySelectorAll(".cart-badge").forEach(el => {
      el.textContent = n > 0 ? n : "";
    });
  }

  /* ─── STOCK ──────────────────────────────────────────────────────────────
     V2 : products.stock = stock physique (integer)
          available_stock(id) = physique − réservations actives non-expirées
  ──────────────────────────────────────────────────────────────────────────── */

  // Retourne le stock disponible réel (réservations déduites) pour un produit
  async function getAvailableStock(productId) {
    const { data, error } = await sb.rpc("available_stock", { p_product_id: productId });
    if (error || data === null) return 0;
    return Math.max(0, Number(data));
  }

  // Label + classe CSS selon le stock et le seuil low-stock
  function stockLabel(availableStock, lowStockThreshold = 3) {
    if (availableStock <= 0)                  return { text: "Épuisé",          cls: "stock-epuise",  color: "#f0a3a3" };
    if (availableStock === 1)                 return { text: "Dernier ✦",       cls: "stock-dernier", color: "#e8c97a" };
    if (availableStock <= lowStockThreshold)  return { text: "Bientôt épuisé",  cls: "stock-low",     color: "#d4a76a" };
    return                                           { text: "En stock",         cls: "stock-dispo",   color: "#8ac98a" };
  }

  /* ─── PRODUITS ───────────────────────────────────────────────────────────── */

  // Produit unique par slug (supporte ?slug= et ?d= — transition V1→V2)
  async function getProduct(slug) {
    const { data } = await sb.from("products")
      .select(`
        id, name, slug, sku, price_cents, compare_at_cents,
        stock, low_stock_threshold,
        shape, length_mm, finish, nail_count,
        description_short, description,
        is_visible, is_new, is_bestseller, is_lazy_pick, is_featured,
        image_url,
        product_images ( url, position, alt_text )
      `)
      .eq("slug", slug)
      .eq("is_visible", true)
      .maybeSingle();
    if (!data) return null;
    // Normalise la galerie : product_images en priorité, fallback image_url V1
    const imgs = (data.product_images || []).sort((a, b) => a.position - b.position);
    if (imgs.length === 0 && data.image_url) {
      imgs.push({ url: data.image_url, position: 0, alt_text: data.name });
    }
    return { ...data, images: imgs };
  }

  // Catalogue complet avec filtres optionnels
  async function getProducts({ collectionSlug, moodId, shape, finish, limit = 120 } = {}) {
    let query = sb.from("products")
      .select(`
        id, name, slug, sku, price_cents, compare_at_cents,
        stock, low_stock_threshold, shape, length_mm, finish, nail_count,
        description_short, is_new, is_bestseller, is_lazy_pick, is_featured, sort_order,
        image_url,
        product_images ( url, position )
      `)
      .eq("is_visible", true)
      .order("sort_order", { ascending: true, nullsFirst: false })
      .order("created_at", { ascending: false })
      .limit(limit);

    if (shape)  query = query.eq("shape",  shape);
    if (finish) query = query.eq("finish", finish);

    const { data } = await query;
    const products = (data || []).map(p => {
      const imgs = (p.product_images || []).sort((a, b) => a.position - b.position);
      return {
        ...p,
        image_url: imgs[0]?.url || p.image_url || null,
      };
    });

    // Filtre collection ou mood : join en JS (tables de jonction)
    if (collectionSlug) {
      const { data: jct } = await sb.from("product_collections")
        .select("product_id, collections!inner(slug)")
        .eq("collections.slug", collectionSlug);
      const ids = new Set((jct || []).map(r => r.product_id));
      return products.filter(p => ids.has(p.id));
    }
    if (moodId) {
      const { data: jct } = await sb.from("product_moods")
        .select("product_id")
        .eq("mood_id", moodId);
      const ids = new Set((jct || []).map(r => r.product_id));
      return products.filter(p => ids.has(p.id));
    }
    return products;
  }

  // Recommandations « Tu aimeras aussi » (même shape ou finish, hors produit courant)
  async function getRecommendations(productId, limit = 4) {
    const { data: cur } = await sb.from("products")
      .select("shape, finish").eq("id", productId).maybeSingle();
    if (!cur) return [];
    const orClause = [cur.shape && `shape.eq.${cur.shape}`, cur.finish && `finish.eq.${cur.finish}`]
      .filter(Boolean).join(",");
    const { data } = await sb.from("products")
      .select("id, name, slug, price_cents, stock, image_url, product_images(url, position)")
      .eq("is_visible", true)
      .neq("id", productId)
      .or(orClause || "id.neq.00000000-0000-0000-0000-000000000000")
      .limit(limit);
    return (data || []).map(p => {
      const imgs = (p.product_images || []).sort((a, b) => a.position - b.position);
      return { ...p, image_url: imgs[0]?.url || p.image_url || null };
    });
  }

  // Images galerie d'un produit
  async function getProductImages(productId) {
    const { data } = await sb.from("product_images")
      .select("url, position, alt_text")
      .eq("product_id", productId)
      .order("position");
    return data || [];
  }

  // Collections dynamiques
  async function getCollections() {
    const { data } = await sb.from("collections")
      .select("id, slug, name, description, cover_url")
      .eq("is_active", true)
      .order("sort_order");
    return data || [];
  }

  // Moods dynamiques
  async function getMoods() {
    const { data } = await sb.from("moods")
      .select("id, name, emoji, color")
      .order("sort_order");
    return data || [];
  }

  /* ─── FAVORIS ─────────────────────────────────────────────────────────────
     Requiert auth. Si non connecté → retourne { needsAuth: true }.
  ──────────────────────────────────────────────────────────────────────────── */
  async function isFavorite(productId) {
    const { data: { user } } = await sb.auth.getUser();
    if (!user) return false;
    const { data } = await sb.from("favorites")
      .select("id").eq("user_id", user.id).eq("product_id", productId).maybeSingle();
    return !!data;
  }

  async function toggleFavorite(productId) {
    const { data: { user } } = await sb.auth.getUser();
    if (!user) return { needsAuth: true };
    const { data: existing } = await sb.from("favorites")
      .select("id").eq("user_id", user.id).eq("product_id", productId).maybeSingle();
    if (existing) {
      await sb.from("favorites").delete().eq("id", existing.id);
      return { liked: false };
    }
    await sb.from("favorites").insert({ user_id: user.id, product_id: productId });
    return { liked: true };
  }

  /* ─── ALERTES RÉASSORT ───────────────────────────────────────────────────
     Inscription anonyme ou authentifiée. Anti-doublon DB (UNIQUE product+email).
  ──────────────────────────────────────────────────────────────────────────── */
  async function subscribeRestock(productId, email) {
    const { data: { user } } = await sb.auth.getUser();
    const { error } = await sb.from("restock_alerts").insert({
      product_id: productId,
      user_id:    user?.id || null,
      email,
    });
    if (error) {
      if (error.code === "23505") throw new Error("Vous êtes déjà inscrite pour ce produit. ✦");
      if (error.message?.includes("email")) throw new Error("Adresse email invalide.");
      throw new Error("Inscription impossible. Réessayez.");
    }
  }

  /* ─── AVIS ───────────────────────────────────────────────────────────────── */
  async function getReviews(productId) {
    const { data } = await sb.from("reviews")
      .select("author_name, rating, comment, photo_url, video_url, created_at")
      .eq("product_id", productId).eq("status", "approved")
      .order("created_at", { ascending: false });
    return data || [];
  }

  async function uploadMedia(file, kind) {
    if (!file) return null;
    const maxMo = kind === "video" ? 30 : 8;
    if (file.size > maxMo * 1024 * 1024) {
      throw new Error((kind === "video" ? "Vidéo" : "Photo") + " trop lourde (max " + maxMo + " Mo).");
    }
    const ext  = (file.name.split(".").pop() || "bin").toLowerCase();
    const path = kind + "/" + Date.now() + "-" + Math.random().toString(36).slice(2, 8) + "." + ext;
    const { error } = await sb.storage.from("avis").upload(path, file);
    if (error) throw new Error("Envoi du fichier impossible : " + error.message);
    return sb.storage.from("avis").getPublicUrl(path).data.publicUrl;
  }

  async function submitReview({ product_id, author_name, email, rating, comment, photoFile, videoFile }) {
    const photo_url = await uploadMedia(photoFile, "photo");
    const video_url = await uploadMedia(videoFile, "video");
    const { error } = await sb.from("reviews").insert({
      product_id, author_name, email, rating, comment, photo_url, video_url,
    });
    if (error) throw new Error("Dépôt de l'avis impossible. Réessayez.");
  }

  /* ─── PAIEMENT ────────────────────────────────────────────────────────────
     V2 : envoie product_id + quantity (plus de size / custom_measurements).
          Les prix sont entièrement recalculés côté serveur.
  ──────────────────────────────────────────────────────────────────────────── */
  async function checkout() {
    const cart = getCart();
    if (cart.length === 0) throw new Error("Votre panier est vide.");
    const { data: { user } } = await sb.auth.getUser();
    const payload = {
      items: cart.map(it => ({
        product_id: it.product_id,
        quantity:   it.quantity || 1,
      })),
      email:       user?.email || null,
      user_id:     user?.id   || null,
      success_url: location.origin + "/merci.html",
      cancel_url:  location.origin + "/panier.html",
    };
    const res = await fetch(CHECKOUT_URL, {
      method:  "POST",
      headers: { "Content-Type": "application/json" },
      body:    JSON.stringify(payload),
    });
    const data = await res.json();
    if (!res.ok || data.error) throw new Error(data.error || "Erreur de paiement. Réessayez.");
    location.href = data.url;
  }

  /* ─── SITE SETTINGS ──────────────────────────────────────────────────────── */
  let _settingsCache = null;
  async function getSettings(keys = []) {
    if (!_settingsCache) {
      const { data } = await sb.from("site_settings").select("key, value");
      _settingsCache = Object.fromEntries((data || []).map(r => [r.key, r.value]));
    }
    if (keys.length === 0) return _settingsCache;
    return Object.fromEntries(keys.map(k => [k, _settingsCache[k]]));
  }

  /* ─── ADMIN ───────────────────────────────────────────────────────────────── */
  async function isAdmin() {
    const { data: { user } } = await sb.auth.getUser();
    if (!user) return false;
    const { data } = await sb.from("admins").select("user_id").eq("user_id", user.id).maybeSingle();
    return !!data;
  }

  /* ─── VISITES ─────────────────────────────────────────────────────────────── */
  function trackView() {
    try {
      const path = location.pathname + location.search;
      const key  = "nv_" + path;
      if (sessionStorage.getItem(key)) return;
      sessionStorage.setItem(key, "1");
      let done = false;
      const insert = (country) => {
        if (done) return; done = true;
        sb.from("page_views").insert({ path, ref: document.referrer || null, country: country || null }).then(() => {});
      };
      setTimeout(() => insert(null), 2500);
      fetch("https://ipapi.co/country_name/").then(r => r.ok ? r.text() : null).then(c => {
        const v = c && c.trim();
        insert(v && v.length < 60 && !v.includes("{") && !v.includes("<") ? v : null);
      }).catch(() => insert(null));
    } catch (e) {}
  }

  /* ─── HELPERS ─────────────────────────────────────────────────────────────── */
  const eur = c => (c / 100).toLocaleString("fr-FR", { minimumFractionDigits: 0, maximumFractionDigits: 2 }) + " €";
  const etoiles = n => "★".repeat(n) + "☆".repeat(5 - n);

  /* ─── INIT DOM ─────────────────────────────────────────────────────────────── */
  document.addEventListener("DOMContentLoaded", () => {
    updateBadge();
    trackView();

    if ("serviceWorker" in navigator) {
      navigator.serviceWorker.register("./sw.js").catch(() => {});
    }

    if (!document.querySelector('link[rel="manifest"]')) {
      const ml = document.createElement("link");
      ml.rel = "manifest"; ml.href = "manifest.json";
      document.head.appendChild(ml);
    }

    // Bouton retour
    const bPage = document.querySelector(".b-page");
    if (bPage && history.length > 1) {
      const retour = document.createElement("button");
      retour.className = "b-retour";
      retour.textContent = "← Retour";
      retour.onclick = () => history.back();
      bPage.insertBefore(retour, bPage.firstChild);
    }

    // Menu mobile
    const nav = document.querySelector(".b-nav");
    if (nav) {
      const burger = document.createElement("button");
      burger.className = "b-burger";
      burger.setAttribute("aria-label", "Menu");
      burger.textContent = "☰";

      const mobileMenu = document.createElement("div");
      mobileMenu.className = "b-menu-mobile";

      nav.querySelectorAll(".b-links a").forEach(a => mobileMenu.appendChild(a.cloneNode(true)));
      nav.querySelector(".b-nav-inner").appendChild(burger);
      nav.appendChild(mobileMenu);

      burger.addEventListener("click", () => {
        const isOpen = mobileMenu.classList.toggle("ouvert");
        burger.textContent = isOpen ? "✕" : "☰";
      });
      mobileMenu.querySelectorAll("a").forEach(a => {
        a.addEventListener("click", () => {
          mobileMenu.classList.remove("ouvert");
          burger.textContent = "☰";
        });
      });
    }
  });

  /* ─── API publique ──────────────────────────────────────────────────────────
     V1 compat : getStock() et getAllStock() conservés mais redirigés vers
     la logique V2 pour ne pas casser les pages existantes.
  ──────────────────────────────────────────────────────────────────────────── */
  async function getStock(productId) {
    const count = await getAvailableStock(productId);
    return { count, next: null };
  }
  async function getAllStock() {
    const { data } = await sb.from("products").select("id, slug, stock").eq("is_visible", true);
    const map = {};
    (data || []).forEach(p => { map[p.slug] = p.stock; });
    return map;
  }
  // getProduct V1 compat (active → is_visible géré dans getProduct V2)
  async function getProductLegacy(slug) { return getProduct(slug); }

  return {
    sb,
    // Panier
    getCart, saveCart, addToCart, updateCartQuantity, removeFromCart, clearCart,
    cartCount, cartSubtotal, updateBadge,
    // Stock
    getAvailableStock, stockLabel,
    // Produits
    getProduct, getProducts, getRecommendations, getProductImages,
    getCollections, getMoods,
    // Favoris
    isFavorite, toggleFavorite,
    // Alertes réassort
    subscribeRestock,
    // Avis
    getReviews, submitReview,
    // Paiement
    checkout,
    // Settings
    getSettings,
    // Admin / Auth
    isAdmin,
    // Helpers
    eur, etoiles,
    // Rétrocompat V1
    getStock, getAllStock,
  };
})();
