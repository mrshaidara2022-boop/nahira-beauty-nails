ALTER TABLE academy_lessons ADD COLUMN IF NOT EXISTS draft_content_blocks JSONB DEFAULT NULL;
