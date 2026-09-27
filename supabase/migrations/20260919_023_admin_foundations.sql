
-- ══════════════════════════════════════════════════════════════════
-- 20260919_023_admin_foundations
-- Livraison 1 — Fondations gestion élèves
--
--   1. Table admin_logs   — journal immuable des actions admin
--   2. Trigger sync_auth_user_to_profile — email + noms initiaux
--   3. Backfill emails manquants dans profiles
--
-- Garanties :
--   - display_name / full_name existants JAMAIS écrasés
--   - Aucun enrollment, progress, quiz, certificat modifié
--   - Trigger non-bloquant (EXCEPTION attrapée)
-- ══════════════════════════════════════════════════════════════════


-- ─── 1. TABLE admin_logs ──────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.admin_logs (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  -- ON DELETE SET NULL : le log persiste même si l'admin est supprimé
  admin_id         UUID        REFERENCES auth.users(id) ON DELETE SET NULL,
  action           TEXT        NOT NULL,
  target_table     TEXT,
  target_id        TEXT,       -- UUID en TEXT pour couvrir n'importe quelle PK
  target_user_id   UUID,       -- élève concerné
  target_course_id UUID,       -- formation concernée
  details          JSONB       NOT NULL DEFAULT '{}',
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE  public.admin_logs IS
  'Journal immuable des actions admin — append-only, aucune UPDATE ni DELETE';
COMMENT ON COLUMN public.admin_logs.action IS
  'Valeurs : enroll, unenroll, reset_progress, invalidate_quiz, '
  'regen_certificate, manual_edit';
COMMENT ON COLUMN public.admin_logs.details IS
  'Snapshot contextuel : données avant/après, raison, champs pertinents';
COMMENT ON COLUMN public.admin_logs.admin_id IS
  'SET NULL à la suppression : le log reste lisible même sans admin actif';

CREATE INDEX IF NOT EXISTS idx_admin_logs_admin_id      ON public.admin_logs (admin_id);
CREATE INDEX IF NOT EXISTS idx_admin_logs_target_user   ON public.admin_logs (target_user_id);
CREATE INDEX IF NOT EXISTS idx_admin_logs_target_course ON public.admin_logs (target_course_id);
CREATE INDEX IF NOT EXISTS idx_admin_logs_action        ON public.admin_logs (action);
CREATE INDEX IF NOT EXISTS idx_admin_logs_created_at    ON public.admin_logs (created_at DESC);

ALTER TABLE public.admin_logs ENABLE ROW LEVEL SECURITY;

-- Lecture réservée aux admins
CREATE POLICY "admin_logs_select"
  ON public.admin_logs FOR SELECT
  USING (is_admin());

-- Insertion : admins frontend + service_role (Edge Functions bypass RLS)
CREATE POLICY "admin_logs_insert"
  ON public.admin_logs FOR INSERT
  WITH CHECK (is_admin());

-- Aucune UPDATE ni DELETE : les logs sont immuables
GRANT SELECT, INSERT ON public.admin_logs TO authenticated;


-- ─── 2. FONCTION + TRIGGER sync_auth_user_to_profile ─────────────

CREATE OR REPLACE FUNCTION public.sync_auth_user_to_profile()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_meta_name TEXT;
BEGIN
  -- Extraire full_name depuis les métadonnées Auth
  -- (inscrit par signUp({ options: { data: { full_name: '...' } } }))
  -- NULLIF(..., '') : traiter la chaîne vide comme NULL
  v_meta_name := NULLIF(
    TRIM(COALESCE(NEW.raw_user_meta_data->>'full_name', '')),
    ''
  );

  INSERT INTO public.profiles (id, email, display_name, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    v_meta_name,
    v_meta_name
  )
  ON CONFLICT (id) DO UPDATE SET

    -- EMAIL : toujours synchronisé avec auth.users
    email = EXCLUDED.email,

    -- DISPLAY_NAME : initialisé depuis les métadonnées uniquement si
    -- la valeur actuelle est null ou vide.
    -- Ne JAMAIS écraser une valeur renseignée par l'élève ou l'admin.
    display_name = CASE
      WHEN TRIM(COALESCE(public.profiles.display_name, '')) = ''
           AND EXCLUDED.display_name IS NOT NULL
      THEN EXCLUDED.display_name
      ELSE public.profiles.display_name
    END,

    -- FULL_NAME : même logique — utilisé par la Edge Function certificat
    -- pour remplir recipient_name. Ne jamais écraser.
    full_name = CASE
      WHEN TRIM(COALESCE(public.profiles.full_name, '')) = ''
           AND EXCLUDED.full_name IS NOT NULL
      THEN EXCLUDED.full_name
      ELSE public.profiles.full_name
    END;

  RETURN NEW;

EXCEPTION WHEN OTHERS THEN
  -- Le trigger NE DOIT PAS faire échouer une opération sur auth.users.
  -- On log un WARNING visible dans les logs Supabase et on retourne NEW.
  RAISE WARNING 'sync_auth_user_to_profile: uid=% — %: %',
    NEW.id, SQLSTATE, SQLERRM;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.sync_auth_user_to_profile() IS
  'Maintient profiles.email en sync avec auth.users.email. '
  'Initialise display_name et full_name depuis raw_user_meta_data.full_name '
  'uniquement si ces champs sont vides/null — ne les écrase JAMAIS. '
  'SECURITY DEFINER + search_path=public pour accès sécurisé à profiles.';

DROP TRIGGER IF EXISTS trg_sync_profile_on_auth_user ON auth.users;

CREATE TRIGGER trg_sync_profile_on_auth_user
  AFTER INSERT OR UPDATE OF email, raw_user_meta_data
  ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.sync_auth_user_to_profile();


-- ─── 3. BACKFILL — emails manquants ──────────────────────────────

DO $$
DECLARE
  v_count INTEGER;
BEGIN
  UPDATE public.profiles p
  SET    email = u.email
  FROM   auth.users u
  WHERE  u.id  = p.id
    AND  u.email IS NOT NULL
    AND  (p.email IS NULL OR TRIM(p.email) = '');

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RAISE NOTICE 'Backfill email : % profil(s) mis à jour', v_count;
END;
$$;
