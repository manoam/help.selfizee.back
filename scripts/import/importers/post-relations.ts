import { asReqNum, type ImportContext } from "../context.js";

// MySQL `post_has_posts` -> Prisma `PostRelation`
export async function importPostRelations({ rows, prisma }: ImportContext) {
  const data = rows.get("post_has_posts")!;
  console.log(`  -> ${data.length} rows from post_has_posts`);

  const postByLegacy = new Map<number, number>(
    (
      await prisma.post.findMany({
        where: { legacyId: { not: null } },
        select: { id: true, legacyId: true },
      })
    ).map((r) => [r.legacyId!, r.id]),
  );

  const involvedIds = [
    ...new Set([
      ...data.map((r) => postByLegacy.get(asReqNum(r.parent_id))).filter(Boolean),
      ...data.map((r) => postByLegacy.get(asReqNum(r.child_id))).filter(Boolean),
    ]),
  ] as number[];
  if (involvedIds.length) {
    await prisma.postRelation.deleteMany({
      where: { OR: [{ fromId: { in: involvedIds } }, { toId: { in: involvedIds } }] },
    });
  }

  const seen = new Set<string>();
  let ok = 0;
  let skipped = 0;
  for (const row of data) {
    const fromId = postByLegacy.get(asReqNum(row.parent_id));
    const toId = postByLegacy.get(asReqNum(row.child_id));
    if (!fromId || !toId || fromId === toId) {
      skipped += 1;
      continue;
    }
    const key = `${fromId}:${toId}`;
    if (seen.has(key)) continue;
    seen.add(key);
    await prisma.postRelation.create({ data: { fromId, toId } });
    ok += 1;
  }
  console.log(`  -> ${ok} post-relations linked (${skipped} skipped)`);
}
