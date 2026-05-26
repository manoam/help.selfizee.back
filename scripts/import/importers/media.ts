import type { ImportContext } from "../context.js";

// MySQL `fichiers` -> Prisma `PostAttachment`
//
// TODO : décider du storage (volume local mount ? S3 ?) et copier les fichiers
// physiques depuis le webroot CRM. Pour l'instant, on lit juste les rows pour
// vérifier qu'il n'y a pas d'erreur de parse, on n'insère rien.
export async function importMedia({ rows }: ImportContext) {
  const data = rows.get("fichiers")!;
  console.log(`  -> ${data.length} rows from fichiers (NOT inserted yet, awaiting storage decision)`);
}
