#!/bin/sh
set -e

# Entrypoint du back en prod (Coolify).
# Séquence :
#   1) applique les migrations Prisma (idempotent).
#   2) si la DB est vide (aucun Post en base), injecte seed-prod.sql.
#   3) lance le serveur Express.
#
# Le seed n'est exécuté qu'une fois car au 2e boot, la table "Post" contiendra
# des lignes -> count > 0 -> on skip.

echo "[entrypoint] applying Prisma migrations..."
pnpm prisma migrate deploy

echo "[entrypoint] checking if DB is empty..."
# psql renvoie un nombre (count) sans header grâce à -tA. On trim les espaces.
POST_COUNT=$(psql "$DATABASE_URL" -tA -c 'SELECT COUNT(*) FROM "Post";' 2>/dev/null || echo "0")
POST_COUNT=$(echo "$POST_COUNT" | tr -d '[:space:]')

if [ "$POST_COUNT" = "0" ]; then
  echo "[entrypoint] DB is empty -> injecting seed-prod.sql"
  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f /app/seed-prod.sql
  echo "[entrypoint] seed done."
else
  echo "[entrypoint] DB already has $POST_COUNT posts -> skipping seed."
fi

echo "[entrypoint] starting server..."
exec node dist/server.js
