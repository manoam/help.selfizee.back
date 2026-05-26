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

# Install des dépendances (frozen lockfile pour build reproductible)
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

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

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
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

USER app

ENV NODE_ENV=production
ENV PORT=3001
EXPOSE 3001

# Au boot : applique les migrations puis démarre le serveur
CMD ["sh", "-c", "pnpm prisma migrate deploy && node dist/server.js"]
