import { asBool, asNum, asReqNum, asReqStr, asStr, type ImportContext } from "../context.js";
import { slugify } from "../lib/slugify.js";
import { htmlToTiptapJson } from "../lib/html-to-tiptap.js";
import { mysqlDateToJs } from "../lib/sql-parser.js";

// MySQL `posts` -> Prisma `Post`
// `contenu` (HTML legacy) → JSON TipTap. Les autres textareas (intro_*, notice_*,
// probleme_*, description_probleme, question) restent en HTML brut côté Postgres,
// converties en JSON TipTap à la volée à l'affichage si besoin.
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

    const scalars = {
      titre,
      contenu: doc,
      contenuText: text,
      status,
      isFavourite: asBool(row.is_favourite),
      ordre: asNum(row.ordre),
      descriptionProbleme: asStr(row.description_probleme),
      question: asStr(row.question),
      introClient: asStr(row.intro_client),
      noticeClient: asStr(row.notice_client),
      problemeClient: asStr(row.probleme_client),
      introCallCenter: asStr(row.intro_call_center),
      noticeCallCenter: asStr(row.notice_call_center),
      problemeCallCenter: asStr(row.probleme_call_center),
      introInterne: asStr(row.intro_interne),
      problemeInterne: asStr(row.probleme_interne),
    };

    await prisma.post.upsert({
      where: { legacyId },
      update: scalars,
      create: {
        ...scalars,
        slug: `${slugify(titre)}-${legacyId}`,
        legacyId,
        createdAt: created ?? undefined,
        publishedAt: status === "PUBLISHED" ? created ?? new Date() : null,
      },
    });
    ok += 1;
  }
  console.log(`  -> ${ok} posts upserted (${fallbacks} fallback to plain text)`);
}

function mapStatus(s: string | null): "DRAFT" | "PUBLISHED" | "ARCHIVED" {
  const v = (s ?? "").toLowerCase();
  if (v.includes("publi") || v === "1") return "PUBLISHED";
  if (v.includes("arch")) return "ARCHIVED";
  return "DRAFT";
}
