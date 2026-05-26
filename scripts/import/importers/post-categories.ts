import { asNum, asReqNum, type ImportContext } from "../context.js";

// MySQL `post_categories` -> Prisma `PostCategory`
// Wipe + re-create par post pour idempotence.
export async function importPostCategories({ rows, prisma }: ImportContext) {
  const data = rows.get("post_categories")!;
  console.log(`  -> ${data.length} rows from post_categories`);

  const [postByLegacy, catByLegacy, subByLegacy, subSubByLegacy] = await Promise.all([
    mapLegacy(prisma, "post"),
    mapLegacy(prisma, "category"),
    mapLegacy(prisma, "subCategory"),
    mapLegacy(prisma, "subSubCategory"),
  ]);

  const postIds = [
    ...new Set(
      data.map((r) => postByLegacy.get(asReqNum(r.post_id, "post_categories.post_id"))).filter(Boolean),
    ),
  ] as number[];
  if (postIds.length) {
    await prisma.postCategory.deleteMany({ where: { postId: { in: postIds } } });
  }

  let ok = 0;
  let skipped = 0;
  for (const row of data) {
    const postId = postByLegacy.get(asReqNum(row.post_id));
    const categoryId = catByLegacy.get(asReqNum(row.categorie_id));
    if (!postId || !categoryId) {
      skipped += 1;
      continue;
    }
    const subId = asNum(row.sous_category_id);
    const subSubId = asNum(row.sous_sous_category_id);
    await prisma.postCategory.create({
      data: {
        postId,
        categoryId,
        subCategoryId: subId != null ? subByLegacy.get(subId) ?? null : null,
        subSubCategoryId: subSubId != null ? subSubByLegacy.get(subSubId) ?? null : null,
      },
    });
    ok += 1;
  }
  console.log(`  -> ${ok} post-categories linked (${skipped} skipped)`);
}

async function mapLegacy<K extends "post" | "category" | "subCategory" | "subSubCategory">(
  prisma: ImportContext["prisma"],
  model: K,
): Promise<Map<number, number>> {
  const rows = await (prisma[model] as any).findMany({
    where: { legacyId: { not: null } },
    select: { id: true, legacyId: true },
  });
  return new Map(rows.map((r: any) => [r.legacyId as number, r.id as number]));
}
