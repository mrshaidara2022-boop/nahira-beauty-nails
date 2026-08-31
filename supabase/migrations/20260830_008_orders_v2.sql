-- M11+M12: Extend orders and order_items for V2
-- Non-destructive: adds columns only — legacy columns (size, custom_measurements, unit_id) kept
-- order_items gets denormalized product history so old orders never change if product renamed/repriced

-- ── orders: add order_number + notes ─────────────────────────────────────────
ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS order_number TEXT,
  ADD COLUMN IF NOT EXISTS notes        TEXT;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'orders_order_number_key'
  ) THEN
    ALTER TABLE orders ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);
  END IF;
END $$;

-- Sequence for NBN-000001 format
CREATE SEQUENCE IF NOT EXISTS order_number_seq START 1;

-- Auto-assign order_number on INSERT
CREATE OR REPLACE FUNCTION set_order_number()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.order_number IS NULL THEN
    NEW.order_number := 'NBN-' || lpad(nextval('order_number_seq')::text, 6, '0');
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS orders_set_number ON orders;
CREATE TRIGGER orders_set_number
  BEFORE INSERT ON orders
  FOR EACH ROW EXECUTE FUNCTION set_order_number();

-- Backfill existing orders without an order_number
DO $$
DECLARE
  r RECORD;
  seq_val BIGINT;
BEGIN
  FOR r IN SELECT id FROM orders WHERE order_number IS NULL ORDER BY created_at LOOP
    seq_val := nextval('order_number_seq');
    UPDATE orders
    SET order_number = 'NBN-' || lpad(seq_val::text, 6, '0')
    WHERE id = r.id;
  END LOOP;
END $$;

-- ── order_items: add quantity + denormalized product snapshot ─────────────────
-- Immutable product history: name/sku/price at time of purchase never changes
ALTER TABLE order_items
  ADD COLUMN IF NOT EXISTS quantity          INTEGER NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS product_name      TEXT,
  ADD COLUMN IF NOT EXISTS product_sku       TEXT,
  ADD COLUMN IF NOT EXISTS unit_price_cents  INTEGER;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'order_items_quantity_positive'
  ) THEN
    ALTER TABLE order_items ADD CONSTRAINT order_items_quantity_positive CHECK (quantity > 0);
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'order_items_unit_price_non_negative'
  ) THEN
    ALTER TABLE order_items ADD CONSTRAINT order_items_unit_price_non_negative
      CHECK (unit_price_cents IS NULL OR unit_price_cents >= 0);
  END IF;
END $$;

-- Backfill product snapshot for existing order_items
UPDATE order_items oi
SET
  product_name     = p.name,
  product_sku      = p.sku,
  unit_price_cents = p.price_cents
FROM products p
WHERE oi.product_id = p.id
  AND oi.product_name IS NULL;

-- Auto-fill product snapshot on future INSERTs
CREATE OR REPLACE FUNCTION fill_order_item_snapshot()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.product_name IS NULL AND NEW.product_id IS NOT NULL THEN
    SELECT name, sku, price_cents
    INTO NEW.product_name, NEW.product_sku, NEW.unit_price_cents
    FROM products
    WHERE id = NEW.product_id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS order_items_snapshot ON order_items;
CREATE TRIGGER order_items_snapshot
  BEFORE INSERT ON order_items
  FOR EACH ROW EXECUTE FUNCTION fill_order_item_snapshot();
