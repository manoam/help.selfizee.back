import { asReqNum, asReqStr, type ImportContext } from "../context.js";
import { slugify } from "../lib/slugify.js";

// MySQL `post_tags` -> Prisma `Tag`
// Plusieurs rows legacy peuvent produire le même slug (ex: "Écran" + "écran").
// On fusionne : le 1er legacyId rencontré pour un slug devient le tag canonique,
// les suivants sont ignorés ici — leurs liens seront remappés par importPostTagsLink.
export async function importTags({ rows, prisma }: ImportContext) {
  const data = rows.get("post_tags")!;
  console.log(`  -> ${data.length} rows from post_tags`);
  const seenSlugs = new Set<string>();
  let created = 0;
  let merged = 0;
  for (const row of data) {
    const legacyId = asReqNum(row.id, "post_tags.id");
    const name = asReqStr(row.name, "post_tags.name");
    const slug = slugify(name);
    if (seenSlugs.has(slug)) {
      merged += 1;
      continue;
    }
    seenSlugs.add(slug);
    await prisma.tag.upsert({
      where: { legacyId },
      update: { name },
      create: { name, slug, legacyId },
    });
    created += 1;
  }
  console.log(`  -> ${created} tags upserted, ${merged} duplicates merged by slug`);
}
