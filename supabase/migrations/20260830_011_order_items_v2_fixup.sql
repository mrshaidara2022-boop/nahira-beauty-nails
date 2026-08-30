-- M11 : correctif non-destructif order_items pour V2
-- Découvert lors du test de stock : unit_price_cents manquait, size et price_cents bloquaient les inserts V2

-- 1. Ajouter unit_price_cents (snapshot prix V2, nullable pour rétrocompatibilité V1)
ALTER TABLE order_items
  ADD COLUMN IF NOT EXISTS unit_price_cents INTEGER;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'order_items_unit_price_non_negative'
  ) THEN
    ALTER TABLE order_items ADD CONSTRAINT order_items_unit_price_non_negative
      CHECK (unit_price_cents IS NULL OR unit_price_cents >= 0);
  END IF;
END $$;

-- Backfill : copier price_cents dans unit_price_cents pour les lignes V1 existantes
UPDATE order_items
SET unit_price_cents = price_cents
WHERE unit_price_cents IS NULL AND price_cents IS NOT NULL;

-- 2. Rendre price_cents nullable (colonne V1 héritée, remplacée par unit_price_cents en V2)
ALTER TABLE order_items
  ALTER COLUMN price_cents DROP NOT NULL;

-- 3. Rendre size nullable (V2 n'utilise plus les tailles, les lignes V1 conservent leur valeur)
ALTER TABLE order_items
  ALTER COLUMN size DROP NOT NULL;
