import { PrismaClient } from "@prisma/client";

// Évite plusieurs instances en dev avec tsx --watch.
const globalForPrisma = globalThis as unknown as { prisma?: PrismaClient };

// Par défaut, on n'active pas le log "query" même en dev car ça :
//  - ajoute 30-50% de latence à chaque requête,
//  - rend le terminal illisible pendant un import,
//  - ralentit massivement le seed.
// Pour activer ponctuellement : PRISMA_LOG_QUERIES=1 pnpm dev
const logs: ("query" | "error" | "warn")[] = ["error", "warn"];
if (process.env.PRISMA_LOG_QUERIES === "1") logs.unshift("query");

export const prisma = globalForPrisma.prisma ?? new PrismaClient({ log: logs });

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;
