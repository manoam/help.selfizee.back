import { asBool, asReqNum, asReqStr, type ImportContext } from "../context.js";
import { slugify } from "../lib/slugify.js";

// MySQL `categories` -> Prisma `Category`
export async function importCategories({ rows, prisma }: ImportContext) {
  const data = rows.get("categories")!;
  console.log(`  -> ${data.length} rows from categories`);
  for (const row of data) {
    const legacyId = asReqNum(row.id, "categories.id");
    const nom = asReqStr(row.nom, "categories.nom");
    await prisma.category.upsert({
      where: { legacyId },
      update: {
        nom,
        afficher: asBool(row.afficher),
        ordre: asReqNum(row.ordre ?? 0),
      },
      create: {
        nom,
        slug: slugify(nom),
        afficher: asBool(row.afficher),
        ordre: asReqNum(row.ordre ?? 0),
        legacyId,
      },
    });
  }
}
