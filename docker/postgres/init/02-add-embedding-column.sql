-- ⚠️ À lancer manuellement APRÈS le premier `prisma migrate dev` (qui crée la table `Post`).
-- L'équipe chatbot peuplera et requêtera cette colonne dans son propre pipeline.
--
-- Exécution :
--   docker compose exec postgres psql -U help -d help_selfizee -f /docker-entrypoint-initdb.d/02-add-embedding-column.sql
--
-- Note : Prisma génère par défaut des tables en PascalCase (table `Post`, pas `posts`).
-- On ajoute donc les colonnes sur "Post" avec guillemets doubles.

ALTER TABLE IF EXISTS "Post"
  ADD COLUMN IF NOT EXISTS embedding vector(1536);

ALTER TABLE IF EXISTS "Post"
  ADD COLUMN IF NOT EXISTS embedding_model text;

ALTER TABLE IF EXISTS "Post"
  ADD COLUMN IF NOT EXISTS embedding_updated_at timestamptz;

CREATE INDEX IF NOT EXISTS post_embedding_ivfflat_idx
  ON "Post" USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);
