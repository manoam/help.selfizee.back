-- Index composé pour groupBy(value) where postId : permet index-only scan.
CREATE INDEX IF NOT EXISTS "Vote_postId_value_idx" ON "Vote"("postId", "value");

-- Index explicite sur tagId (la PK (postId, tagId) ne l'utilise pas efficacement
-- pour les filtres "posts d'un tag").
CREATE INDEX IF NOT EXISTS "PostTag_tagId_idx" ON "PostTag"("tagId");

-- Index sur le typeProfilId (idem).
CREATE INDEX IF NOT EXISTS "PostTypeProfil_typeProfilId_idx" ON "PostTypeProfil"("typeProfilId");

-- Index sur PostRelation.toId pour les requêtes "qui pointe vers X".
CREATE INDEX IF NOT EXISTS "PostRelation_toId_idx" ON "PostRelation"("toId");

-- Index trigramme pour la recherche full-text (pg_trgm activé dans schema).
-- Permet `ILIKE '%mot%'` indexé. Énormément plus rapide que seq scan à 10k+ posts.
CREATE INDEX IF NOT EXISTS "Post_titre_trgm_idx" ON "Post" USING gin (titre gin_trgm_ops);
CREATE INDEX IF NOT EXISTS "Post_resume_trgm_idx" ON "Post" USING gin (resume gin_trgm_ops);
CREATE INDEX IF NOT EXISTS "Post_contenuText_trgm_idx" ON "Post" USING gin ("contenuText" gin_trgm_ops);
