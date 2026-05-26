import { readdir, readFile } from "node:fs/promises";
import path from "node:path";

import { parseSqlDump, type ParsedTable } from "./sql-parser.js";

// Tables attendues — l'import s'arrête si l'une manque.
export const EXPECTED_TABLES = [
  "categories",
  "sous_categories",
  "sous_sous_categories",
  "post_tags",
  "posts",
  "post_categories",
  "post_has_post_tags",
  "post_has_posts",
  "fichiers",
] as const;
export type ExpectedTable = (typeof EXPECTED_TABLES)[number];

/**
 * Charge tous les .sql d'un dossier, les parse, et renvoie une map { table -> rows }.
 * Pour chaque fichier, détecte les tables qu'il contient (peut en avoir plusieurs).
 * L'ordre des fichiers n'a aucune importance — c'est la map qui sera consommée.
 */
export async function loadAllDumps(
  dumpsDir: string,
): Promise<Map<ExpectedTable, Record<string, unknown>[]>> {
  let files: string[];
  try {
    files = (await readdir(dumpsDir)).filter((f) => f.toLowerCase().endsWith(".sql"));
  } catch {
    throw new Error(
      `dumps/ introuvable (${dumpsDir}). Place tes exports SQL du CRM dans ce dossier.`,
    );
  }

  if (files.length === 0) {
    throw new Error(
      `Aucun .sql dans ${dumpsDir}. Place tes exports CRM (un ou plusieurs fichiers) dedans.`,
    );
  }

  console.log(`  -> ${files.length} dump file(s) detected in ${dumpsDir}`);

  // Map table -> rows (consolidée à travers tous les fichiers)
  const byTable = new Map<string, Record<string, unknown>[]>();

  for (const file of files) {
    const fullPath = path.join(dumpsDir, file);
    const sql = await readFile(fullPath, "utf8");
    let tables: ParsedTable[];
    try {
      tables = parseSqlDump(sql);
    } catch (err) {
      throw new Error(`Échec du parse de ${file} : ${(err as Error).message}`);
    }

    for (const t of tables) {
      const existing = byTable.get(t.name) ?? [];
      existing.push(...t.rows);
      byTable.set(t.name, existing);
      if (t.rows.length > 0) {
        console.log(`     ${file}: ${t.name} +${t.rows.length} rows`);
      }
    }
  }

  // Vérifie qu'on a bien les 9 tables (au moins déclarées, vides ou non).
  const missing = EXPECTED_TABLES.filter((t) => !byTable.has(t));
  if (missing.length) {
    throw new Error(
      `Tables manquantes dans les dumps : ${missing.join(", ")}. ` +
        `Détecté : ${[...byTable.keys()].join(", ") || "(rien)"}`,
    );
  }

  // Map filtrée sur EXPECTED_TABLES (types corrects).
  const result = new Map<ExpectedTable, Record<string, unknown>[]>();
  for (const t of EXPECTED_TABLES) {
    result.set(t, byTable.get(t) ?? []);
  }
  return result;
}
