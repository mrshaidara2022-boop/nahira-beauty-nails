-- M06: Create favorites table
-- Non-destructive: new table only

CREATE TABLE IF NOT EXISTS favorites (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, product_id)
);

CREATE INDEX IF NOT EXISTS favorites_user_idx ON favorites(user_id);

ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Each user sees and manages only their own favorites
CREATE POLICY "favorites_own_user" ON favorites
  FOR ALL USING (auth.uid() = user_id);
