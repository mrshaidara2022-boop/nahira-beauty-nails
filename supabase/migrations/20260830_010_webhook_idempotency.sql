-- Idempotency table for Stripe webhooks
-- Prevents double-processing of the same Stripe event
-- Also used for the decrement_stock() function called by the webhook

-- ── processed_stripe_events ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS processed_stripe_events (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stripe_event_id TEXT NOT NULL UNIQUE,
  event_type      TEXT NOT NULL,
  error           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS processed_stripe_events_event_id_idx
  ON processed_stripe_events(stripe_event_id);

ALTER TABLE processed_stripe_events ENABLE ROW LEVEL SECURITY;

-- Only service_role (webhooks) and admins can access
CREATE POLICY "stripe_events_service_role" ON processed_stripe_events
  FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "stripe_events_admin" ON processed_stripe_events
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));

-- ── decrement_stock() — called by webhook after payment confirmed ────────────
-- Decrements physical stock and logs a stock movement.
-- CHECK constraint (stock >= 0) acts as safety net if somehow oversold.
CREATE OR REPLACE FUNCTION decrement_stock(
  p_product_id UUID,
  p_quantity   INTEGER,
  p_order_id   UUID DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  -- Decrement (the CHECK constraint on products.stock will raise if stock < 0)
  UPDATE products
  SET stock = stock - p_quantity
  WHERE id = p_product_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Product not found: %', p_product_id;
  END IF;

  -- Log the movement
  INSERT INTO stock_movements (product_id, quantity_change, reason, order_id)
  VALUES (p_product_id, -p_quantity, 'sale', p_order_id);
END;
$$;
