# Multi-stage Dockerfile prod pour le back help-selfizee.
# Coolify build cette image; au boot, le conteneur applique les migrations Prisma
# puis lance le serveur Express compilé.

# ---------- Stage 1 : deps + build ----------
FROM node:22-bookworm-slim AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable && corepack prepare pnpm@9.12.0 --activate

WORKDIR /app

# Force NODE_ENV=development pendant l'install pour inclure les devDependencies
# (prisma CLI, tsx, typescript) nécessaires au build. Le stage runtime remet production.
ENV NODE_ENV=development

# Install des dépendances.
# Idéalement --frozen-lockfile pour reproductibilité, mais on tolère un lockfile
# pas à jour (le builder Coolify le régénère). Repasser à --frozen-lockfile dès
# qu'on a régénéré le lockfile en local et committé.
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --no-frozen-lockfile

# Génère le client Prisma + compile TypeScript
COPY prisma ./prisma
COPY tsconfig.json ./
COPY src ./src
RUN pnpm prisma generate
RUN pnpm build

# Prune les devDeps pour ne garder que la prod
RUN pnpm prune --prod

# ---------- Stage 2 : runtime ----------
FROM node:22-bookworm-slim AS runtime

# postgresql-client fournit psql, nécessaire pour injecter seed-prod.sql au 1er boot
# si la DB est vide. Pas de pg_dump/restore — juste psql client.
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl ca-certificates postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable && corepack prepare pnpm@9.12.0 --activate

WORKDIR /app

# Crée un user non-root (sécurité)
RUN groupadd -r app && useradd -r -g app -m -d /home/app app

# Copie les artefacts depuis builder
COPY --from=builder --chown=app:app /app/node_modules ./node_modules
COPY --from=builder --chown=app:app /app/dist ./dist
COPY --from=builder --chown=app:app /app/prisma ./prisma
COPY --from=builder --chown=app:app /app/package.json ./package.json

# Seed de production (généré via pg_dump local après l'import legacy).
# Injecté au boot uniquement si la DB est vide — cf. docker/entrypoint.sh.
COPY --chown=app:app seed-prod.sql ./seed-prod.sql
COPY --chown=app:app docker/entrypoint.sh ./entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Crée le dossier d'uploads avec les bons droits avant de passer en user non-root.
# En prod Coolify, ce chemin sera monté sur un volume persistant.
RUN mkdir -p /app/uploads && chown -R app:app /app/uploads

USER app

ENV NODE_ENV=production
ENV PORT=3001
EXPOSE 3001

CMD ["/app/entrypoint.sh"]
