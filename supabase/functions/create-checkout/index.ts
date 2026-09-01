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
      .select("id, name, slug, sku, price_cents, is_visible, stock, product_type")
      .in("id", productIds)
      .eq("is_visible", true);

    if (dbErr) return error("Erreur base de données.", 500);

    const productMap = new Map(products!.map((p: any) => [p.id, p]));

    // Build validated items
    const validatedItems: Array<{ product: any; quantity: number }> = [];
    for (const it of items) {
      const product = productMap.get(it.product_id);
      if (!product) {
        return error(`Produit introuvable ou indisponible.`, 400);
      }
      const quantity = parseInt(it.quantity, 10);
      if (!quantity || quantity < 1) {
        return error(`Quantité invalide pour "${product.name}".`, 400);
      }
      // Digital products: quantity always 1
      const finalQty = product.product_type === "digital" ? 1 : Math.min(quantity, 99);
      validatedItems.push({ product, quantity: finalQty });
    }

    // --- Separate by product type --------------------------------------------
    const physicalItems = validatedItems.filter(({ product }) => product.product_type === "physical");
    const digitalItems  = validatedItems.filter(({ product }) => product.product_type === "digital");

    // --- For digital: fetch associated course_id from academy_courses --------
    const courseMap = new Map<string, string>(); // product_id → course_id
    if (digitalItems.length > 0) {
      const digitalProductIds = digitalItems.map(({ product }) => product.id);
      const { data: courses } = await supabase
        .from("academy_courses")
        .select("id, product_id")
        .in("product_id", digitalProductIds);

      for (const c of (courses || [])) {
        courseMap.set(c.product_id, c.id);
      }

      // Validate every digital product has a linked course
      for (const { product } of digitalItems) {
        if (!courseMap.has(product.id)) {
          return error(`Formation introuvable pour "${product.name}".`, 400);
        }
      }

      // If user is logged in, check they're not already enrolled
      if (user_id) {
        const courseIds = [...courseMap.values()];
        const { data: existing } = await supabase
          .from("academy_enrollments")
          .select("course_id")
          .eq("user_id", user_id)
          .in("course_id", courseIds);

        if (existing && existing.length > 0) {
          const alreadyEnrolled = digitalItems.find(({ product }) => {
            const cid = courseMap.get(product.id);
            return existing.some((e: any) => e.course_id === cid);
          });
          if (alreadyEnrolled) {
            return error(
              `Vous êtes déjà inscrit(e) à "${alreadyEnrolled.product.name}".`,
              400
            );
          }
        }
      }
    }

    // --- Stock reservation for physical items only ---------------------------
    let tempSessionId = "";
    if (physicalItems.length > 0) {
      await supabase.rpc("release_expired_reservations");

      tempSessionId = crypto.randomUUID();
      const reservationItems = physicalItems.map(({ product, quantity }) => ({
        product_id: product.id,
        quantity,
      }));

      const { error: reserveErr } = await supabase.rpc("reserve_stock", {
        p_items:       JSON.stringify(reservationItems),
        p_session_id:  tempSessionId,
        p_ttl_minutes: 15,
      });

      if (reserveErr) {
        return error(reserveErr.message, 409);
      }
    }

    // --- Build Stripe line items ----------------------------------------------
    const lineItems = validatedItems.map(({ product, quantity }) => ({
      price_data: {
        currency: "eur",
        unit_amount: product.price_cents,
        product_data: {
          name: product.name,
          metadata: {
            product_id:   product.id,
            sku:          product.sku || "",
            product_type: product.product_type,
          },
        },
      },
      quantity,
    }));

    // --- Fetch shipping settings (only needed for physical items) ------------
    let shippingOptions: any[] = [];
    let shipping_address_collection: any = undefined;

    if (physicalItems.length > 0) {
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
      const physicalSubtotal = physicalItems.reduce(
        (sum, { product, quantity }) => sum + product.price_cents * quantity,
        0
      );
      const freeShipping = physicalSubtotal >= (s.free_shipping_threshold_cents ?? 5000);

      shippingOptions = freeShipping
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

      shipping_address_collection = {
        allowed_countries: ["FR", "BE", "CH", "LU", "GP", "MQ", "GF", "RE", "YT", "PM", "NC", "PF"],
      };
    }

    // --- Create Stripe Checkout session ---------------------------------------
    const sessionParams: Stripe.Checkout.SessionCreateParams = {
      payment_method_types: ["card"],
      mode:                 "payment",
      line_items:           lineItems,
      customer_email:       email || undefined,
      success_url:          success_url || `${Deno.env.get("SITE_URL")}/merci.html`,
      cancel_url:           cancel_url  || `${Deno.env.get("SITE_URL")}/panier.html`,
      metadata: {
        user_id:         user_id || "",
        temp_session_id: tempSessionId,
        items_json:      JSON.stringify(
          validatedItems.map(({ product, quantity }) => ({
            product_id:       product.id,
            product_name:     product.name,
            product_sku:      product.sku || "",
            product_type:     product.product_type,
            course_id:        product.product_type === "digital"
                                ? (courseMap.get(product.id) || null)
                                : null,
            quantity,
            unit_price_cents: product.price_cents,
          }))
        ),
      },
    };

    if (shipping_address_collection) {
      sessionParams.shipping_address_collection = shipping_address_collection;
      sessionParams.shipping_options = shippingOptions;
    }

    const session = await stripe.checkout.sessions.create(sessionParams);

    // --- Update reservation with real Stripe session id ----------------------
    if (tempSessionId) {
      await supabase
        .from("stock_reservations")
        .update({ session_id: session.id })
        .eq("session_id", tempSessionId);
    }

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
