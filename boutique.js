/* ============ NAHIRA BEAUTY NAILS — moteur boutique ============ */
/* Nécessite : <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script> */

const NAHIRA = (() => {
  const SUPABASE_URL = "https://mxbmjtzrggahbwahxmkp.supabase.co";
  const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14Ym1qdHpyZ2dhaGJ3YWh4bWtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyMzc5NDQsImV4cCI6MjA5NjgxMzk0NH0.iTibkVCaTZYoMzQO4TQvddlKeZY40vNcfJ-kEgIHXpE";
  const CHECKOUT_URL = SUPABASE_URL + "/functions/v1/create-checkout";
  const CART_KEY = "nahira_cart";

  const sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

  /* ---------- PANIER ---------- */
  function getCart() {
    try { return JSON.parse(localStorage.getItem(CART_KEY) || "[]"); }
    catch { return []; }
  }
  function saveCart(cart) {
    localStorage.setItem(CART_KEY, JSON.stringify(cart));
    updateBadge();
  }
  function addToCart(item) { const c = getCart(); c.push(item); saveCart(c); }
  function removeFromCart(i) { const c = getCart(); c.splice(i, 1); saveCart(c); }
  function clearCart() { saveCart([]); }
  function cartCount() { return getCart().length; }
  function cartSubtotal() { return getCart().reduce((s, it) => s + (it.price_cents || 0), 0); }
  function updateBadge() {
    document.querySelectorAll(".cart-badge").forEach(el => {
      el.textContent = cartCount() > 0 ? cartCount() : "";
    });
  }

  /* ---------- PRODUITS & STOCK ---------- */
  async function getProduct(slug) {
    const { data, error } = await sb.from("products")
      .select("*").eq("slug", slug).eq("active", true).single();
    return error ? null : data;
  }
  async function getProducts() {
    const { data } = await sb.from("products")
      .select("*, product_units(status)").eq("active", true)
      .order("price_cents");
    return (data || []).map(p => ({
      ...p,
      stock: (p.product_units || []).filter(u => u.status === "available").length,
    }));
  }
  async function getStock(productId) {
    const { data, error } = await sb.from("product_units")
      .select("serial_number").eq("product_id", productId)
      .eq("status", "available").order("serial_number");
    if (error || !data) return { count: 0, next: null };
    return { count: data.length, next: data.length ? data[0].serial_number : null };
  }
  async function getAllStock() {
    const { data } = await sb.from("products").select("id, slug, product_units(status)");
    const map = {};
    (data || []).forEach(p => {
      map[p.slug] = (p.product_units || []).filter(u => u.status === "available").length;
    });
    return map;
  }

  /* ---------- AVIS ---------- */
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
    const ext = (file.name.split(".").pop() || "bin").toLowerCase();
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

  /* ---------- PAIEMENT ---------- */
  async function checkout() {
    const cart = getCart();
    if (cart.length === 0) throw new Error("Votre panier est vide.");
    const { data: { user } } = await sb.auth.getUser();
    const payload = {
      items: cart.map(it => ({
        product_id: it.product_id,
        size: it.size,
        custom_measurements: it.custom || null,
      })),
      email: user?.email || null,
      user_id: user?.id || null,
      success_url: location.origin + "/merci.html",
      cancel_url: location.origin + "/panier.html",
    };
    const res = await fetch(CHECKOUT_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    const data = await res.json();
    if (!res.ok || data.error) throw new Error(data.error || "Erreur de paiement. Réessayez.");
    location.href = data.url;
  }

  /* ---------- ADMIN ---------- */
  async function isAdmin() {
    const { data: { user } } = await sb.auth.getUser();
    if (!user) return false;
    const { data } = await sb.from("admins").select("user_id").eq("user_id", user.id).maybeSingle();
    return !!data;
  }

  /* ---------- VISITES (anonyme, RGPD-friendly) ---------- */
  function trackView() {
    try {
      const path = location.pathname + location.search;
      const key = "nv_" + path;
      if (sessionStorage.getItem(key)) return;
      sessionStorage.setItem(key, "1");
      sb.from("page_views").insert({ path, ref: document.referrer || null }).then(() => {});
    } catch (e) {}
  }

  /* ---------- HELPERS ---------- */
  const eur = c => (c / 100).toLocaleString("fr-FR", { minimumFractionDigits: 0, maximumFractionDigits: 2 }) + " €";
  const etoiles = n => "★".repeat(n) + "☆".repeat(5 - n);

  document.addEventListener("DOMContentLoaded", () => {
    updateBadge();
    trackView();

    // Service worker (PWA)
    if ("serviceWorker" in navigator) {
      navigator.serviceWorker.register("./sw.js").catch(() => {});
    }

    // Manifest link (injecté si absent)
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

    // Menu mobile (hamburger)
    const nav = document.querySelector(".b-nav");
    if (nav) {
      const burger = document.createElement("button");
      burger.className = "b-burger";
      burger.setAttribute("aria-label", "Menu");
      burger.textContent = "☰";

      const mobileMenu = document.createElement("div");
      mobileMenu.className = "b-menu-mobile";

      nav.querySelectorAll(".b-links a").forEach(a => {
        const link = a.cloneNode(true);
        mobileMenu.appendChild(link);
      });

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

  return {
    sb, getCart, addToCart, removeFromCart, clearCart,
    cartCount, cartSubtotal, updateBadge,
    getProduct, getProducts, getStock, getAllStock,
    getReviews, submitReview, checkout, isAdmin, eur, etoiles,
  };
})();
