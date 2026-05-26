import { asReqNum, asReqStr, type ImportContext } from "../context.js";
import { slugify } from "../lib/slugify.js";

// MySQL `post_has_post_tags` -> Prisma `PostTag`
export async function importPostTagsLink({ rows, prisma }: ImportContext) {
  const data = rows.get("post_has_post_tags")!;
  console.log(`  -> ${data.length} rows from post_has_post_tags`);

  // Les tags ont pu être fusionnés sur slug (cf. importTags). On remappe chaque
  // legacyId tag du dump vers le tag canonique en groupant par slug.
  const tagRows = rows.get("post_tags")!;
  const tagByLegacy = await mapTagByLegacyViaSlug(prisma, tagRows);
  const postByLegacy = await mapPost(prisma);

  const postIds = [
    ...new Set(
      data.map((r) => postByLegacy.get(asReqNum(r.post_id, "post_has_post_tags.post_id"))).filter(Boolean),
    ),
  ] as number[];
  if (postIds.length) {
    await prisma.postTag.deleteMany({ where: { postId: { in: postIds } } });
  }

  const seen = new Set<string>();
  let ok = 0;
  let skipped = 0;
  for (const row of data) {
    const postId = postByLegacy.get(asReqNum(row.post_id));
    const tagId = tagByLegacy.get(asReqNum(row.post_tag_id));
    if (!postId || !tagId) {
      skipped += 1;
      continue;
    }
    const key = `${postId}:${tagId}`;
    if (seen.has(key)) continue;
    seen.add(key);
    await prisma.postTag.create({ data: { postId, tagId } });
    ok += 1;
  }
  console.log(`  -> ${ok} post-tags linked (${skipped} skipped)`);
}

async function mapPost(prisma: ImportContext["prisma"]) {
  const rows = await prisma.post.findMany({
    where: { legacyId: { not: null } },
    select: { id: true, legacyId: true },
  });
  return new Map(rows.map((r) => [r.legacyId!, r.id]));
}
async function mapTagByLegacyViaSlug(
  prisma: ImportContext["prisma"],
  dumpRows: { id: unknown; name: unknown }[],
) {
  const tags = await prisma.tag.findMany({ select: { id: true, slug: true } });
  const tagBySlug = new Map(tags.map((t) => [t.slug, t.id]));
  const out = new Map<number, number>();
  for (const row of dumpRows) {
    const legacyId = asReqNum(row.id, "post_tags.id");
    const slug = slugify(asReqStr(row.name, "post_tags.name"));
    const tagId = tagBySlug.get(slug);
    if (tagId) out.set(legacyId, tagId);
  }
  return out;
}
