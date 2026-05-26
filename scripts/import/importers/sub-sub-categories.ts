import { asReqNum, asReqStr, type ImportContext } from "../context.js";
import { slugify } from "../lib/slugify.js";

// MySQL `sous_sous_categories` -> Prisma `SubSubCategory`
export async function importSubSubCategories({ rows, prisma }: ImportContext) {
  const data = rows.get("sous_sous_categories")!;
  console.log(`  -> ${data.length} rows from sous_sous_categories`);
  let skipped = 0;
  for (const row of data) {
    const parent = await prisma.subCategory.findUnique({
      where: { legacyId: asReqNum(row.sous_category_id, "sous_sous_categories.sous_category_id") },
    });
    if (!parent) {
      skipped += 1;
      continue;
    }
    const legacyId = asReqNum(row.id, "sous_sous_categories.id");
    const nom = asReqStr(row.name, "sous_sous_categories.name");
    await prisma.subSubCategory.upsert({
      where: { legacyId },
      update: { nom, subCategoryId: parent.id },
      create: { nom, slug: slugify(nom), subCategoryId: parent.id, legacyId },
    });
  }
  if (skipped) console.warn(`  ! ${skipped} sub-sub-categories skipped (parent missing)`);
}
