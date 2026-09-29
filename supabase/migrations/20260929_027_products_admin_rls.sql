-- Fix critical: add admin write policy on products table
-- (pattern identical to product_images, collections, product_collections)
CREATE POLICY "products_admin_all" ON public.products
  FOR ALL
  TO public
  USING (EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid()));
