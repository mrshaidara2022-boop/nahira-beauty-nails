import Stripe from "https://esm.sh/stripe@14?target=deno";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2?target=deno";

const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY")!, {
  apiVersion: "2024-04-10",
  httpClient: Stripe.createFetchHttpClient(),
});

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body = await req.json();
    const { items, email, user_id, success_url, cancel_url } = body;

    // --- Validate input -------------------------------------------------------
    if (!Array.isArray(items) || items.length === 0) {
      return error("Panier vide.", 400);
    }

    // --- Fetch product data from DB (NEVER trust frontend prices) ------------
    const productIds = items.map((it: { product_id: string }) => it.product_id);
    const { data: products, error: dbErr } = await supabase
      .from("products")
      .select("id, name, slug, sku, price_cents, is_visible, stock")
      .in("id", productIds)
      .eq("is_visible", true);

    if (dbErr) return error("Erreur base de données.", 500);

    const productMap = new Map(products!.map((p: any) => [p.id, p]));

    // Build validated items
    const validatedItems = [];
    for (const it of items) {
      const product = productMap.get(it.product_id);
      if (!product) {
        return error(`Produit introuvable ou indisponible.`, 400);
      }
      const quantity = parseInt(it.quantity, 10);
      if (!quantity || quantity < 1 || quantity > 99) {
        return error(`Quantité invalide pour "${product.name}".`, 400);
      }
      validatedItems.push({ product, quantity });
    }

    // --- Release expired reservations first ----------------------------------
    await supabase.rpc("release_expired_reservations");

    // --- Atomic stock reservation (single transaction, FOR UPDATE lock) ------
    const reservationItems = validatedItems.map(({ product, quantity }) => ({
      product_id: product.id,
      quantity,
    }));

    // Generate a temporary session_id (will be replaced with Stripe session id
    // via webhook once Stripe session is created)
    const tempSessionId = crypto.randomUUID();

    const { error: reserveErr } = await supabase.rpc("reserve_stock", {
      p_items: JSON.stringify(reservationItems),
      p_session_id: tempSessionId,
      p_ttl_minutes: 15,
    });

    if (reserveErr) {
      // Propagate the PostgreSQL error message (e.g. "Stock insuffisant pour...")
      return error(reserveErr.message, 409);
    }

    // --- Build Stripe line items (server-side prices) ------------------------
    const lineItems = validatedItems.map(({ product, quantity }) => ({
      price_data: {
        currency: "eur",
        unit_amount: product.price_cents, // cents integer from DB, never frontend
        product_data: {
          name: product.name,
          metadata: { product_id: product.id, sku: product.sku || "" },
        },
      },
      quantity,
    }));

    // --- Fetch shipping settings from DB ------------------------------------
    const { data: settings } = await supabase
      .from("site_settings")
      .select("key, value")
      .in("key", [
        "free_shipping_threshold_cents",
        "free_shipping_fr_cents",
        "free_shipping_domtom_cents",
        "free_shipping_eu_cents",
      ]);

    const s = Object.fromEntries((settings || []).map((r: any) => [r.key, parseInt(r.value, 10)]));
    const subtotal = validatedItems.reduce(
      (sum, { product, quantity }) => sum + product.price_cents * quantity,
      0
    );
    const freeShipping = subtotal >= (s.free_shipping_threshold_cents ?? 5000);

    const shippingOptions = freeShipping
      ? [
          {
            shipping_rate_data: {
              type: "fixed_amount",
              fixed_amount: { amount: 0, currency: "eur" },
              display_name: "Livraison offerte ✦",
              delivery_estimate: {
                minimum: { unit: "business_day", value: 2 },
                maximum: { unit: "business_day", value: 4 },
              },
            },
          },
        ]
      : [
          {
            shipping_rate_data: {
              type: "fixed_amount",
              fixed_amount: { amount: s.free_shipping_fr_cents ?? 490, currency: "eur" },
              display_name: "France Métropolitaine",
              delivery_estimate: {
                minimum: { unit: "business_day", value: 2 },
                maximum: { unit: "business_day", value: 4 },
              },
            },
          },
          {
            shipping_rate_data: {
              type: "fixed_amount",
              fixed_amount: { amount: s.free_shipping_domtom_cents ?? 690, currency: "eur" },
              display_name: "DOM-TOM",
              delivery_estimate: {
                minimum: { unit: "business_day", value: 5 },
                maximum: { unit: "business_day", value: 10 },
              },
            },
          },
          {
            shipping_rate_data: {
              type: "fixed_amount",
              fixed_amount: { amount: s.free_shipping_eu_cents ?? 890, currency: "eur" },
              display_name: "Belgique / Suisse / Luxembourg",
              delivery_estimate: {
                minimum: { unit: "business_day", value: 3 },
                maximum: { unit: "business_day", value: 7 },
              },
            },
          },
        ];

    // --- Create Stripe Checkout session ------------------------------------
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      mode: "payment",
      line_items: lineItems,
      shipping_address_collection: {
        allowed_countries: ["FR", "BE", "CH", "LU", "GP", "MQ", "GF", "RE", "YT", "PM", "NC", "PF"],
      },
      shipping_options: shippingOptions,
      customer_email: email || undefined,
      success_url: success_url || `${Deno.env.get("SITE_URL")}/merci.html`,
      cancel_url:  cancel_url  || `${Deno.env.get("SITE_URL")}/panier.html`,
      metadata: {
        user_id:        user_id || "",
        temp_session_id: tempSessionId,
        items_json:     JSON.stringify(
          validatedItems.map(({ product, quantity }) => ({
            product_id:      product.id,
            product_name:    product.name,
            product_sku:     product.sku,
            quantity,
            unit_price_cents: product.price_cents,
          }))
        ),
      },
    });

    // --- Update reservation with real Stripe session id -------------------
    await supabase
      .from("stock_reservations")
      .update({ session_id: session.id })
      .eq("session_id", tempSessionId);

    return new Response(JSON.stringify({ url: session.url }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (e: any) {
    console.error("create-checkout error:", e);
    return error(e.message || "Erreur inattendue.", 500);
  }
});

function error(message: string, status: number) {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
  });
}
