-- M08+M09: Stock reservations + movements + atomic reserve_stock() RPC
-- Reservation happens at CHECKOUT time only (not add-to-cart)
-- reserve_stock() is a single transaction: lock → check → reserve or fail
-- Non-destructive: new tables and functions only

-- ── stock_reservations ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS stock_reservations (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity    INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
  session_id  TEXT NOT NULL,
  expires_at  TIMESTAMPTZ NOT NULL,
  released_at TIMESTAMPTZ,
  consumed_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS stock_reservations_product_active_idx
  ON stock_reservations(product_id, released_at, consumed_at, expires_at);

ALTER TABLE stock_reservations ENABLE ROW LEVEL SECURITY;

-- Only service_role (Edge Functions) and admins can read/write reservations
CREATE POLICY "stock_reservations_service_role" ON stock_reservations
  FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "stock_reservations_admin" ON stock_reservations
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));

-- ── stock_movements ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS stock_movements (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id      UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity_change INTEGER NOT NULL, -- negative = sale, positive = restock
  reason          TEXT NOT NULL CHECK (reason IN ('sale', 'restock', 'adjustment', 'import', 'return', 'reservation_consumed')),
  order_id        UUID REFERENCES orders(id) ON DELETE SET NULL,
  note            TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS stock_movements_product_idx ON stock_movements(product_id, created_at DESC);

ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "stock_movements_service_role" ON stock_movements
  FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "stock_movements_admin" ON stock_movements
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));

-- ── available_stock() helper ─────────────────────────────────────────────────
-- Returns: physical stock MINUS active non-expired reservations
CREATE OR REPLACE FUNCTION available_stock(p_product_id UUID)
RETURNS INTEGER
LANGUAGE sql STABLE
AS $$
  SELECT p.stock - COALESCE((
    SELECT SUM(r.quantity)
    FROM stock_reservations r
    WHERE r.product_id = p_product_id
      AND r.released_at IS NULL
      AND r.consumed_at IS NULL
      AND r.expires_at > now()
  ), 0)
  FROM products p
  WHERE p.id = p_product_id;
$$;

-- ── reserve_stock() atomic RPC ───────────────────────────────────────────────
-- Called by create-checkout Edge Function BEFORE creating Stripe session
-- Input: items JSON array [{product_id, quantity}], session_id, ttl_minutes
-- Returns: reservation_ids[] on success, raises exception on insufficient stock
-- The FOR UPDATE lock prevents race conditions between concurrent sessions

CREATE OR REPLACE FUNCTION reserve_stock(
  p_items       JSON,
  p_session_id  TEXT,
  p_ttl_minutes INTEGER DEFAULT 15
)
RETURNS SETOF UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_item        JSON;
  v_product_id  UUID;
  v_quantity    INTEGER;
  v_avail       INTEGER;
  v_product_name TEXT;
  v_expires_at  TIMESTAMPTZ;
  v_reservation_id UUID;
BEGIN
  v_expires_at := now() + (p_ttl_minutes || ' minutes')::INTERVAL;

  FOR v_item IN SELECT * FROM json_array_elements(p_items) LOOP
    v_product_id := (v_item->>'product_id')::UUID;
    v_quantity   := (v_item->>'quantity')::INTEGER;

    IF v_quantity <= 0 THEN
      RAISE EXCEPTION 'Quantité invalide pour le produit %', v_product_id;
    END IF;

    -- Lock the product row exclusively to prevent concurrent overselling
    SELECT p.name INTO v_product_name
    FROM products p
    WHERE p.id = v_product_id
    FOR UPDATE;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Produit introuvable : %', v_product_id;
    END IF;

    -- Check available stock (physical - active unexpired reservations)
    v_avail := available_stock(v_product_id);

    IF v_avail < v_quantity THEN
      RAISE EXCEPTION 'Stock insuffisant pour "%" (disponible: %, demandé: %)',
        v_product_name, v_avail, v_quantity;
    END IF;

    -- Create the reservation
    INSERT INTO stock_reservations (product_id, quantity, session_id, expires_at)
    VALUES (v_product_id, v_quantity, p_session_id, v_expires_at)
    RETURNING id INTO v_reservation_id;

    RETURN NEXT v_reservation_id;
  END LOOP;

  RETURN;
END;
$$;

-- ── release_expired_reservations() cleanup ───────────────────────────────────
-- Called periodically or on each checkout attempt to free stale locks
CREATE OR REPLACE FUNCTION release_expired_reservations()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  v_count INTEGER;
BEGIN
  UPDATE stock_reservations
  SET released_at = now()
  WHERE expires_at <= now()
    AND released_at IS NULL
    AND consumed_at IS NULL;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$;
