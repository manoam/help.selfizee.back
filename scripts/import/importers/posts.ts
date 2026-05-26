import { asNum, asReqNum, asReqStr, asStr, type ImportContext } from "../context.js";
import { slugify } from "../lib/slugify.js";
import { htmlToTiptapJson } from "../lib/html-to-tiptap.js";
import { mysqlDateToJs } from "../lib/sql-parser.js";

// MySQL `posts` -> Prisma `Post`
// HTML legacy → JSON TipTap via @tiptap/html + jsdom.
export async function importPosts({ rows, prisma }: ImportContext) {
  const data = rows.get("posts")!;
  console.log(`  -> ${data.length} rows from posts`);
  let ok = 0;
  let fallbacks = 0;

  for (const row of data) {
    const legacyId = asReqNum(row.id, "posts.id");
    const titre = asReqStr(row.titre, "posts.titre");
    const contenuHtml = asStr(row.contenu) ?? "";
    const { doc, text, ok: convertOk } = htmlToTiptapJson(contenuHtml);
    if (!convertOk) fallbacks += 1;

    const status = mapStatus(asStr(row.status));
    const created = mysqlDateToJs(row.created);

    await prisma.post.upsert({
      where: { legacyId },
      update: {
        titre,
        contenu: doc,
        contenuText: text,
        status,
      },
      create: {
        titre,
        slug: `${slugify(titre)}-${legacyId}`,
        contenu: doc,
        contenuText: text,
        status,
        legacyId,
        createdAt: created ?? undefined,
        publishedAt: status === "PUBLISHED" ? created ?? new Date() : null,
      },
    });
    ok += 1;
  }
  console.log(`  -> ${ok} posts upserted (${fallbacks} fallback to plain text)`);
  // Silence unused import warning if asNum not consumed elsewhere.
  void asNum;
}

function mapStatus(s: string | null): "DRAFT" | "PUBLISHED" | "ARCHIVED" {
  const v = (s ?? "").toLowerCase();
  if (v.includes("publi") || v === "1") return "PUBLISHED";
  if (v.includes("arch")) return "ARCHIVED";
  return "DRAFT";
}
