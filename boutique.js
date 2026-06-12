/* ============ NAHIRA BEAUTY NAILS — moteur boutique ============ */
/* Nécessite : <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script> */

const NAHIRA = (() => {
  const SUPABASE_URL = "https://mxbmjtzrggahbwahxmkp.supabase.co";
  const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14Ym1qdHpyZ2dhaGJ3YWh4bWtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyMzc5NDQsImV4cCI6MjA5NjgxMzk0NH0.iTibkVCaTZYoMzQO4TQvddlKeZY40vNcfJ-kEgIHXpE";
  const CHECKOUT_URL = SUPABASE_URL + "/functions/v1/create-checkout";
  const CART_KEY = "nahira_cart";

  const sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

  /* ---------- PANIER (stocké dans le navigateur) ---------- */
  function getCart() {
    try { return JSON.parse(localStorage.getItem(CART_KEY) || "[]"); }
    catch { return []; }
  }
  function saveCart(cart) {
    localStorage.setItem(CART_KEY, JSON.stringify(cart));
    updateBadge();
  }
  function addToCart(item) {
    const cart = getCart();
    cart.push(item);
    saveCart(cart);
  }
  function removeFromCart(index) {
    const cart = getCart();
    cart.splice(index, 1);
    saveCart(cart);
  }
  function clearCart() { saveCart([]); }
  function cartCount() { return getCart().length; }
  function cartSubtotal() {
    return getCart().reduce((s, it) => s + (it.price_cents || 0), 0);
  }
  function updateBadge() {
    document.querySelectorAll(".cart-badge").forEach(el => {
      el.textContent = cartCount() > 0 ? cartCount() : "";
    });
  }

  /* ---------- PRODUITS & STOCK ---------- */
  async function getProduct(slug) {
    const { data, error } = await sb.from("products")
      .select("*").eq("slug", slug).eq("active", true).single();
    if (error) return null;
    return data;
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

  /* ---------- HELPERS ---------- */
  const eur = c => (c / 100).toLocaleString("fr-FR", { minimumFractionDigits: 0, maximumFractionDigits: 2 }) + " €";

  document.addEventListener("DOMContentLoaded", updateBadge);

  return {
    sb, getCart, addToCart, removeFromCart, clearCart,
    cartCount, cartSubtotal, updateBadge,
    getProduct, getStock, getAllStock, checkout, eur,
  };
})();
