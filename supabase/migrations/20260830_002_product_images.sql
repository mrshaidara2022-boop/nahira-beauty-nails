-- M03: Create product_images table
-- Non-destructive: new table only

CREATE TABLE IF NOT EXISTS product_images (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  url        TEXT NOT NULL,
  position   INTEGER NOT NULL DEFAULT 0,
  alt_text   TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS product_images_product_position_idx
  ON product_images(product_id, position);

ALTER TABLE product_images ENABLE ROW LEVEL SECURITY;

CREATE POLICY "product_images_public_read" ON product_images
  FOR SELECT USING (true);

CREATE POLICY "product_images_admin_all" ON product_images
  FOR ALL USING (
    EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid())
  );

-- Migrate existing image_url from products as position=0 image
INSERT INTO product_images (product_id, url, position, alt_text)
SELECT id, image_url, 0, name
FROM products
WHERE image_url IS NOT NULL
ON CONFLICT DO NOTHING;
