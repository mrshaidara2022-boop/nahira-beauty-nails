-- M04+M05: Create collections, moods, and junction tables
-- 100% dynamic — no HTML changes needed to add/edit collections or moods
-- Non-destructive: new tables only

CREATE TABLE IF NOT EXISTS collections (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        TEXT NOT NULL UNIQUE,
  name        TEXT NOT NULL,
  description TEXT,
  cover_url   TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  sort_order  INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS product_collections (
  product_id    UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  PRIMARY KEY (product_id, collection_id)
);

CREATE TABLE IF NOT EXISTS moods (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT NOT NULL UNIQUE,
  emoji      TEXT,
  color      TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS product_moods (
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  mood_id    UUID NOT NULL REFERENCES moods(id) ON DELETE CASCADE,
  PRIMARY KEY (product_id, mood_id)
);

-- RLS: public read, admin write
ALTER TABLE collections         ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE moods               ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_moods       ENABLE ROW LEVEL SECURITY;

CREATE POLICY "collections_public_read"  ON collections         FOR SELECT USING (true);
CREATE POLICY "product_collections_public_read" ON product_collections FOR SELECT USING (true);
CREATE POLICY "moods_public_read"        ON moods               FOR SELECT USING (true);
CREATE POLICY "product_moods_public_read" ON product_moods      FOR SELECT USING (true);

CREATE POLICY "collections_admin_all"  ON collections
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));
CREATE POLICY "product_collections_admin_all" ON product_collections
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));
CREATE POLICY "moods_admin_all"  ON moods
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));
CREATE POLICY "product_moods_admin_all" ON product_moods
  FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));

-- Seed default moods
INSERT INTO moods (name, emoji, color, sort_order) VALUES
  ('Soft & Girly',   '🌸', '#F4C5D8', 10),
  ('Édgy & Dark',    '🖤', '#4A3050', 20),
  ('Clean & Minimal','🤍', '#E8E4E0', 30),
  ('Bridal',         '💍', '#F7F3EC', 40),
  ('Y2K',            '✨', '#B8A0E0', 50),
  ('Glam & Luxe',    '✦',  '#E8C27A', 60),
  ('Nature & Boho',  '🌿', '#8BAF80', 70),
  ('French Girl',    '🇫🇷', '#DCEAF5', 80)
ON CONFLICT (name) DO NOTHING;
