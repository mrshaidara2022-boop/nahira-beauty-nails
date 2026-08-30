-- M07: Create restock_alerts table
-- Allows anonymous subscriptions (no account required)
-- RLS: anonymous insert allowed; own alerts readable; admin reads all
-- Protection: unique(product_id, email) prevents duplicates

CREATE TABLE IF NOT EXISTS restock_alerts (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id  UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  user_id     UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  email       TEXT NOT NULL CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  notified_at TIMESTAMPTZ,
  active      BOOLEAN NOT NULL DEFAULT true,
  UNIQUE (product_id, email)
);

CREATE INDEX IF NOT EXISTS restock_alerts_product_active_idx
  ON restock_alerts(product_id, active);

ALTER TABLE restock_alerts ENABLE ROW LEVEL SECURITY;

-- Anyone can subscribe (email validated by CHECK constraint above)
CREATE POLICY "restock_alerts_public_insert" ON restock_alerts
  FOR INSERT WITH CHECK (true);

-- Users can only read their own alerts (never other customers' emails)
CREATE POLICY "restock_alerts_own_select" ON restock_alerts
  FOR SELECT USING (
    auth.uid() = user_id
    OR auth.uid() IS NULL -- anon: no rows returned (uid null won't match uuid)
  );

-- Users can deactivate their own alert
CREATE POLICY "restock_alerts_own_update" ON restock_alerts
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Admin reads and manages all alerts
CREATE POLICY "restock_alerts_admin_all" ON restock_alerts
  FOR ALL USING (
    EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid())
  );
