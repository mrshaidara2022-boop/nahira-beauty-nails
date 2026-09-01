-- M01: Extend products table for V2
-- Non-destructive: adds columns only, no data removed
-- Constraints: sku UNIQUE, stock >= 0, low_stock_threshold >= 0, nail_count > 0

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS sku                TEXT,
  ADD COLUMN IF NOT EXISTS stock              INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS low_stock_threshold INTEGER NOT NULL DEFAULT 3,
  ADD COLUMN IF NOT EXISTS shape              TEXT,
  ADD COLUMN IF NOT EXISTS length_mm          TEXT,
  ADD COLUMN IF NOT EXISTS primary_color      TEXT,
  ADD COLUMN IF NOT EXISTS style              TEXT,
  ADD COLUMN IF NOT EXISTS finish             TEXT,
  ADD COLUMN IF NOT EXISTS nail_count         INTEGER NOT NULL DEFAULT 24,
  ADD COLUMN IF NOT EXISTS description_short  TEXT,
  -- Single source of truth for visibility: is_visible replaces / aligns with active
  -- is_visible = product shows in catalog; active = legacy flag kept for compatibility
  ADD COLUMN IF NOT EXISTS is_visible         BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS is_new             BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_featured        BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_bestseller      BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_lazy_pick       BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS sort_order         INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS cost_price_cents   INTEGER;

-- Add constraints
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'products_sku_key'
  ) THEN
    ALTER TABLE products ADD CONSTRAINT products_sku_key UNIQUE (sku);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'products_stock_non_negative'
  ) THEN
    ALTER TABLE products ADD CONSTRAINT products_stock_non_negative CHECK (stock >= 0);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'products_low_stock_threshold_non_negative'
  ) THEN
    ALTER TABLE products ADD CONSTRAINT products_low_stock_threshold_non_negative CHECK (low_stock_threshold >= 0);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'products_nail_count_positive'
  ) THEN
    ALTER TABLE products ADD CONSTRAINT products_nail_count_positive CHECK (nail_count > 0);
  END IF;

  -- Ensure slug is unique (should already be, but enforce)
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'products_slug_key'
  ) THEN
    ALTER TABLE products ADD CONSTRAINT products_slug_key UNIQUE (slug);
  END IF;
END $$;

-- Sync is_visible with existing active flag for legacy products
UPDATE products SET is_visible = active WHERE is_visible = true;

-- Generate SKUs for existing products (format: NBN-SLUG)
UPDATE products
SET sku = 'NBN-' || UPPER(REPLACE(slug, '-', ''))
WHERE sku IS NULL;
