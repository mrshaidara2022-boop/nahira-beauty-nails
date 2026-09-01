/**
 * Stripe Webhook — V2 + Academy
 *
 * Events handled:
 *   checkout.session.completed  → create order, handle physical stock,
 *                                 grant Academy enrollments for digital courses
 *   checkout.session.expired    → release stock reservations (physical only)
 *
 * Idempotency: each event is keyed by stripe_event_id in processed_stripe_events.
 * Enrollments use ON CONFLICT DO NOTHING — safe to replay.
 *
 * Stock flow (physical items only):
 *   1. reserve_stock() locks stock at checkout open (in create-checkout)
 *   2. On session.completed: consume reservation + decrement products.stock
 *   3. On session.expired:   release reservation (stock freed immediately)
 *
 * Academy flow (digital items):
 *   1. On session.completed: insert into academy_enrollments (idempotent)
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
  const { data: existing } = await supabase
    .from("processed_stripe_events")
    .select("id")
    .eq("stripe_event_id", event.id)
    .maybeSingle();

  if (existing) {
    console.log("Duplicate event ignored:", event.id);
    return new Response("ok", { status: 200 });
  }

  const { error: insertErr } = await supabase
    .from("processed_stripe_events")
    .insert({ stripe_event_id: event.id, event_type: event.type });

  if (insertErr && insertErr.code !== "23505") {
    console.error("Failed to record event:", insertErr);
    return new Response("DB error", { status: 500 });
  }
  if (insertErr?.code === "23505") {
    console.log("Duplicate event (race condition):", event.id);
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
  const meta      = session.metadata || {};
  const userId    = meta.user_id || null;
  const itemsJson = meta.items_json || "[]";
  const sessionId = session.id;

  type CartItem = {
    product_id:       string;
    product_name:     string;
    product_sku:      string;
    product_type:     "physical" | "digital";
    course_id:        string | null;
    quantity:         number;
    unit_price_cents: number;
  };

  let items: CartItem[] = [];
  try {
    items = JSON.parse(itemsJson);
  } catch {
    throw new Error("items_json invalid in session metadata: " + sessionId);
  }

  const physicalItems = items.filter((it) => it.product_type === "physical");
  const digitalItems  = items.filter((it) => it.product_type === "digital");

  const shippingDetails = session.shipping_details;
  const shippingCost    = session.shipping_cost?.amount_total ?? 0;
  const totalCents      = session.amount_total ?? 0;

  // --- Create order (includes all items — physical + digital) ---------------
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

  // --- Insert order_items (all items, physical + digital) -------------------
  const orderItems = items.map((it) => ({
    order_id:         order.id,
    product_id:       it.product_id,
    product_name:     it.product_name,
    product_sku:      it.product_sku,
    quantity:         it.quantity,
    unit_price_cents: it.unit_price_cents,
  }));

  const { error: itemsErr } = await supabase.from("order_items").insert(orderItems);
  if (itemsErr) throw new Error("order_items insert failed: " + itemsErr.message);

  // --- Physical: consume reservations + decrement stock --------------------
  for (const it of physicalItems) {
    await supabase
      .from("stock_reservations")
      .update({ consumed_at: new Date().toISOString() })
      .eq("session_id", sessionId)
      .eq("product_id", it.product_id)
      .is("consumed_at", null);

    const { error: stockErr } = await supabase.rpc("decrement_stock", {
      p_product_id: it.product_id,
      p_quantity:   it.quantity,
      p_order_id:   order.id,
    });
    if (stockErr) throw new Error("decrement_stock failed: " + stockErr.message);
  }

  // --- Physical: check sold-out products -----------------------------------
  for (const it of physicalItems) {
    const { data: prod } = await supabase
      .from("products")
      .select("stock, name")
      .eq("id", it.product_id)
      .single();

    if (prod && prod.stock <= 0) {
      console.log(`Product "${prod.name}" is now sold out.`);
    }
  }

  // --- Digital: grant Academy enrollments (idempotent) ---------------------
  if (digitalItems.length > 0 && userId) {
    const enrollments = digitalItems
      .filter((it) => it.course_id)
      .map((it) => ({
        user_id:           userId,
        course_id:         it.course_id!,
        stripe_session_id: sessionId,
      }));

    if (enrollments.length > 0) {
      const { error: enrollErr } = await supabase
        .from("academy_enrollments")
        .upsert(enrollments, { onConflict: "user_id,course_id", ignoreDuplicates: true });

      if (enrollErr) {
        // Log but don't fail — order already committed above
        console.error("Enrollment insert failed:", enrollErr.message);
      } else {
        console.log(`Enrolled user ${userId} in ${enrollments.length} course(s)`);
      }
    }
  } else if (digitalItems.length > 0 && !userId) {
    // Guest purchase of a digital course — log for manual follow-up
    console.warn(
      `Digital courses purchased without user_id. Session: ${sessionId}. Courses:`,
      digitalItems.map((it) => it.course_id)
    );
  }

  console.log(`Order ${order.order_number} created for session ${sessionId}`);
}

// ── checkout.session.expired ────────────────────────────────────────────────
async function handleSessionExpired(session: Stripe.Checkout.Session) {
  // Release stock reservations for physical items only
  const { error } = await supabase
    .from("stock_reservations")
    .update({ released_at: new Date().toISOString() })
    .eq("session_id", session.id)
    .is("released_at", null)
    .is("consumed_at", null);

  if (error) throw new Error("Failed to release reservations: " + error.message);

  console.log(`Reservations released for expired session: ${session.id}`);
}
