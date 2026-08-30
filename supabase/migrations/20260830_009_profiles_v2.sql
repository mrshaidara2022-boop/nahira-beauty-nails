-- M13: Extend profiles for V2
-- Non-destructive: adds display_name only
-- Legacy columns (measurements, preferred_size) retained until V2 fully validated

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS display_name TEXT;

-- NOTE: The following will be run in a FUTURE migration after V2 validation:
-- ALTER TABLE profiles DROP COLUMN IF EXISTS measurements;
-- ALTER TABLE profiles DROP COLUMN IF EXISTS preferred_size;
