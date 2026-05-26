/**
 * Migration MySQL (dump CRM CakePHP "espace_assistance") -> PostgreSQL (back).
 *
 * Lit directement les dumps .sql via un parser maison (pas de MySQL temporaire) :
 *   - Étape 0    : parse les .sql de back/dumps/ et indexe par table
 *   - Étapes 1-9 : upsert dans Prisma, idempotent via `legacyId`
 *
 * Usage :
 *   docker compose exec api pnpm import
 *   docker compose exec api pnpm tsx scripts/import/index.ts --only=posts
 */
import "dotenv/config";

import path from "node:path";

import { loadAllDumps } from "./lib/dump-loader.js";
import { connectPrisma, type ImportContext } from "./context.js";
import { importCategories } from "./importers/categories.js";
import { importSubCategories } from "./importers/sub-categories.js";
import { importSubSubCategories } from "./importers/sub-sub-categories.js";
import { importTags } from "./importers/tags.js";
import { importMedia } from "./importers/media.js";
import { importPosts } from "./importers/posts.js";
import { importPostCategories } from "./importers/post-categories.js";
import { importPostTagsLink } from "./importers/post-tags-link.js";
import { importPostRelations } from "./importers/post-relations.js";

const STEPS = [
  { id: "categories", run: importCategories },
  { id: "sub-categories", run: importSubCategories },
  { id: "sub-sub-categories", run: importSubSubCategories },
  { id: "tags", run: importTags },
  { id: "media", run: importMedia },
  { id: "posts", run: importPosts },
  { id: "post-categories", run: importPostCategories },
  { id: "post-tags-link", run: importPostTagsLink },
  { id: "post-relations", run: importPostRelations },
] as const;

function parseFlags(argv: string[]) {
  const onlyArg = argv.find((a) => a.startsWith("--only="));
  const only = onlyArg ? onlyArg.split("=")[1].split(",") : null;
  const dumpsArg = argv.find((a) => a.startsWith("--dumps="));
  const dumpsDir = dumpsArg ? dumpsArg.split("=")[1] : process.env.DUMPS_DIR ?? "/app/dumps";
  return { only, dumpsDir };
}

async function main() {
  const { only, dumpsDir } = parseFlags(process.argv.slice(2));
  const absDumpsDir = path.resolve(dumpsDir);

  console.log(`-- loading dumps from ${absDumpsDir}`);
  const rows = await loadAllDumps(absDumpsDir);

  const prisma = connectPrisma();
  const ctx: ImportContext = { prisma, rows };

  try {
    for (const step of STEPS) {
      if (only && !only.includes(step.id)) {
        console.log(`-- skip ${step.id}`);
        continue;
      }
      console.log(`-- importing ${step.id}`);
      await step.run(ctx);
    }
    console.log("done.");
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
