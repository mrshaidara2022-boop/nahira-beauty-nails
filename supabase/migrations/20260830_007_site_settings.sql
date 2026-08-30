-- M10: Create site_settings key-value table
-- Extended to cover all dynamic site content per specifications
-- Admin manages all content from Atelier Nahira — zero HTML edits needed

CREATE TABLE IF NOT EXISTS site_settings (
  key        TEXT PRIMARY KEY,
  value      TEXT,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "site_settings_public_read" ON site_settings
  FOR SELECT USING (true);
CREATE POLICY "site_settings_admin_all" ON site_settings
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));

-- Announcement banner
INSERT INTO site_settings (key, value) VALUES
  ('banner_active',  'false'),
  ('banner_text',    ''),
  ('banner_color',   '#E8C27A'),
  -- Hero section
  ('hero_title',     'Lazy Girl Nails'),
  ('hero_subtitle',  'Des press-on prêts en 5 minutes. Stylés 24/7.'),
  ('hero_image_url', ''),
  ('hero_cta_text',  'Découvrir la collection'),
  ('hero_cta_url',   'collection.html'),
  -- Shipping thresholds
  ('free_shipping_threshold_cents', '5000'),
  ('free_shipping_fr_cents',        '490'),
  ('free_shipping_domtom_cents',    '690'),
  ('free_shipping_eu_cents',        '890'),
  -- Stock alerts
  ('low_stock_threshold_default',   '3'),
  -- SEO
  ('og_description', 'Press-on nails ultra-stylés, prêts en 5 minutes. Fait avec amour en France.')
ON CONFLICT (key) DO NOTHING;

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION touch_site_settings()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER site_settings_touch
  BEFORE UPDATE ON site_settings
  FOR EACH ROW EXECUTE FUNCTION touch_site_settings();
