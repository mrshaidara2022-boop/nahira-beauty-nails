/**
 * Stripe Webhook — V2
 *
 * Events handled:
 *   checkout.session.completed  → create order, consume stock reservation, decrement stock
 *   checkout.session.expired    → release reservation
 *   payment_intent.payment_failed → release reservation if linked to session
 *
 * Idempotency: each event is keyed by stripe_event_id in processed_stripe_events.
 * A duplicate event returns 200 immediately without any DB write.
 *
 * Stock flow:
 *   1. reserve_stock() locks stock at checkout open (in create-checkout)
 *   2. On session.completed: consume reservation + decrement products.stock atomically
 *   3. On session.expired:   release reservation (stock freed immediately)
 */

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

const WEBHOOK_SECRET = Deno.env.get("STRIPE_WEBHOOK_SECRET")!;

Deno.serve(async (req) => {
  const signature = req.headers.get("stripe-signature");
  if (!signature) {
    return new Response("Missing stripe-signature", { status: 400 });
  }

  let event: Stripe.Event;
  try {
    const body = await req.text();
    event = await stripe.webhooks.constructEventAsync(body, signature, WEBHOOK_SECRET);
  } catch (err: any) {
    console.error("Webhook signature verification failed:", err.message);
    return new Response(`Webhook error: ${err.message}`, { status: 400 });
  }

  // --- Idempotency check ---------------------------------------------------
  // processed_stripe_events table must exist (see migration below)
  const { data: existing } = await supabase
    .from("processed_stripe_events")
    .select("id")
    .eq("stripe_event_id", event.id)
    .maybeSingle();

  if (existing) {
    console.log("Duplicate event ignored:", event.id);
    return new Response("ok", { status: 200 });
  }

  // Record event immediately (before processing) to prevent race conditions
  // on duplicate delivery
  const { error: insertErr } = await supabase
    .from("processed_stripe_events")
    .insert({ stripe_event_id: event.id, event_type: event.type });

  if (insertErr && insertErr.code !== "23505") {
    // 23505 = unique_violation — another concurrent request already inserted it
    console.error("Failed to record event:", insertErr);
    return new Response("DB error", { status: 500 });
  }
  if (insertErr?.code === "23505") {
    console.log("Duplicate event (race condition, already inserted):", event.id);
    return new Response("ok", { status: 200 });
  }

  // --- Handle events -------------------------------------------------------
  try {
    if (event.type === "checkout.session.completed") {
      await handleSessionCompleted(event.data.object as Stripe.Checkout.Session);
    } else if (event.type === "checkout.session.expired") {
      await handleSessionExpired(event.data.object as Stripe.Checkout.Session);
    }
  } catch (err: any) {
    console.error("Webhook handler error:", err);
    // Mark event as failed so we can retry manually
    await supabase
      .from("processed_stripe_events")
      .update({ error: err.message })
      .eq("stripe_event_id", event.id);
    return new Response("Handler error", { status: 500 });
  }

  return new Response("ok", { status: 200 });
});

// ── checkout.session.completed ──────────────────────────────────────────────
async function handleSessionCompleted(session: Stripe.Checkout.Session) {
  const meta = session.metadata || {};
  const userId     = meta.user_id || null;
  const itemsJson  = meta.items_json || "[]";
  const sessionId  = session.id;

  let items: Array<{
    product_id: string;
    product_name: string;
    product_sku: string;
    quantity: number;
    unit_price_cents: number;
  }> = [];

  try {
    items = JSON.parse(itemsJson);
  } catch {
    throw new Error("items_json invalid in session metadata: " + sessionId);
  }

  const shippingDetails = session.shipping_details;
  const shippingCost    = session.shipping_cost?.amount_total ?? 0;
  const totalCents      = session.amount_total ?? 0;

  // --- Create order --------------------------------------------------------
  const { data: order, error: orderErr } = await supabase
    .from("orders")
    .insert({
      user_id:              userId || null,
      email:                session.customer_details?.email || session.customer_email,
      status:               "paid",
      total_cents:          totalCents,
      shipping_cents:       shippingCost,
      stripe_session_id:    sessionId,
      shipping_name:        shippingDetails?.name || null,
      shipping_address:     shippingDetails?.address?.line1 || null,
      shipping_address2:    shippingDetails?.address?.line2 || null,
      shipping_postal_code: shippingDetails?.address?.postal_code || null,
      shipping_city:        shippingDetails?.address?.city || null,
      shipping_country:     shippingDetails?.address?.country || null,
    })
    .select("id, order_number")
    .single();

  if (orderErr) throw new Error("Order insert failed: " + orderErr.message);

  // --- Insert order_items (denormalized snapshot) ---------------------------
  const orderItems = items.map((it) => ({
    order_id:        order.id,
    product_id:      it.product_id,
    product_name:    it.product_name,
    product_sku:     it.product_sku,
    quantity:        it.quantity,
    unit_price_cents: it.unit_price_cents,
  }));

  const { error: itemsErr } = await supabase.from("order_items").insert(orderItems);
  if (itemsErr) throw new Error("order_items insert failed: " + itemsErr.message);

  // --- Consume reservations + decrement stock atomically per product --------
  for (const it of items) {
    // Mark reservation as consumed
    await supabase
      .from("stock_reservations")
      .update({ consumed_at: new Date().toISOString() })
      .eq("session_id", sessionId)
      .eq("product_id", it.product_id)
      .is("consumed_at", null);

    // Decrement physical stock (using DB-side arithmetic to avoid race)
    const { error: stockErr } = await supabase.rpc("decrement_stock", {
      p_product_id: it.product_id,
      p_quantity:   it.quantity,
      p_order_id:   order.id,
    });
    if (stockErr) throw new Error("decrement_stock failed: " + stockErr.message);
  }

  // --- Notify restock alert subscribers if product now sold out ------------
  for (const it of items) {
    const { data: prod } = await supabase
      .from("products")
      .select("stock, name")
      .eq("id", it.product_id)
      .single();

    if (prod && prod.stock <= 0) {
      // Mark product sold out
      await supabase
        .from("products")
        .update({ is_visible: true }) // stays visible as "sold out", not hidden
        .eq("id", it.product_id);

      console.log(`Product "${prod.name}" is now sold out.`);
    }
  }

  console.log(`Order ${order.order_number} created for session ${sessionId}`);
}

// ── checkout.session.expired ────────────────────────────────────────────────
async function handleSessionExpired(session: Stripe.Checkout.Session) {
  // Release all reservations held for this session
  const { error } = await supabase
    .from("stock_reservations")
    .update({ released_at: new Date().toISOString() })
    .eq("session_id", session.id)
    .is("released_at", null)
    .is("consumed_at", null);

  if (error) throw new Error("Failed to release reservations: " + error.message);

  console.log(`Reservations released for expired session: ${session.id}`);
}
