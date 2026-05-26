import { asReqNum, asReqStr, type ImportContext } from "../context.js";
import { slugify } from "../lib/slugify.js";

// MySQL `sous_categories` -> Prisma `SubCategory`
export async function importSubCategories({ rows, prisma }: ImportContext) {
  const data = rows.get("sous_categories")!;
  console.log(`  -> ${data.length} rows from sous_categories`);
  let skipped = 0;
  for (const row of data) {
    const parent = await prisma.category.findUnique({
      where: { legacyId: asReqNum(row.categorie_id, "sous_categories.categorie_id") },
    });
    if (!parent) {
      skipped += 1;
      continue;
    }
    const legacyId = asReqNum(row.id, "sous_categories.id");
    const nom = asReqStr(row.name, "sous_categories.name");
    await prisma.subCategory.upsert({
      where: { legacyId },
      update: { nom, categoryId: parent.id },
      create: { nom, slug: slugify(nom), categoryId: parent.id, legacyId },
    });
  }
  if (skipped) console.warn(`  ! ${skipped} sub-categories skipped (parent missing)`);
}
