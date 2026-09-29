-- Bucket Storage pour les images produits (manquait en production)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'products',
  'products',
  true,
  10485760,
  ARRAY['image/jpeg','image/png','image/webp','image/gif']
)
ON CONFLICT (id) DO NOTHING;

-- Lecture publique (images produits visibles par tous)
CREATE POLICY "products_storage_public_read"
ON storage.objects FOR SELECT
USING (bucket_id = 'products');

-- Upload/update/suppression réservés aux admins
CREATE POLICY "products_storage_admin_write"
ON storage.objects FOR INSERT
TO public
WITH CHECK (
  bucket_id = 'products'
  AND EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

CREATE POLICY "products_storage_admin_update"
ON storage.objects FOR UPDATE
TO public
USING (
  bucket_id = 'products'
  AND EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

CREATE POLICY "products_storage_admin_delete"
ON storage.objects FOR DELETE
TO public
USING (
  bucket_id = 'products'
  AND EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);
