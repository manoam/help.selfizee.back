/**
 * Parser minimaliste pour dumps mysqldump.
 *
 * Ce qu'il gère :
 *   - INSERT INTO `table` (`col1`, `col2`) VALUES (v1, v2), (v1, v2), ...;
 *   - INSERT INTO `table` VALUES (...), (...);                    (sans colonnes nommées)
 *   - Échappements MySQL dans les strings : \', \", \\, \0, \n, \r, \t, \Z, \b
 *   - Strings multi-lignes (HTML contenant des \n littéraux)
 *   - Types : NULL, nombres, strings, BLOBs hex (0x...), booléens (0/1)
 *   - Détecte le nom de table via CREATE TABLE et via INSERT INTO
 *   - Détecte les colonnes via CREATE TABLE (pour les INSERT sans colonnes nommées)
 *
 * Ce qu'il NE gère PAS (à ajouter si besoin) :
 *   - Triggers, procédures stockées (ignoré silencieusement)
 *   - Comments /\* ... *\/
 *   - LOCK TABLES, SET, ALTER TABLE — ignorés
 *
 * Conventions :
 *   - Dates MySQL "0000-00-00 ..." → null (Postgres refuse, idem pour les datetimes invalides)
 */

export type Row = Record<string, unknown>;

export type ParsedTable = {
  name: string;
  columns: string[];
  rows: Row[];
};

/**
 * Parse un dump SQL et renvoie les tables détectées avec leurs rows.
 * Une table apparaît dans le résultat même si elle n'a aucune row (utile pour vérifier la présence).
 */
export function parseSqlDump(sql: string): ParsedTable[] {
  const tables = new Map<string, ParsedTable>();

  // 1. Trouve les CREATE TABLE pour récupérer les colonnes (utile pour INSERT sans noms).
  for (const create of extractCreateTables(sql)) {
    tables.set(create.name, { name: create.name, columns: create.columns, rows: [] });
  }

  // 2. Parse tous les INSERT INTO.
  let pos = 0;
  while (pos < sql.length) {
    const insertStart = sql.indexOf("INSERT INTO", pos);
    if (insertStart === -1) break;

    const parsed = parseInsert(sql, insertStart);
    if (!parsed) {
      pos = insertStart + 11;
      continue;
    }

    const table = tables.get(parsed.table) ?? {
      name: parsed.table,
      columns: parsed.columns ?? [],
      rows: [],
    };

    const cols = parsed.columns ?? table.columns;
    if (cols.length === 0) {
      throw new Error(
        `INSERT INTO \`${parsed.table}\` sans colonnes et CREATE TABLE introuvable — impossible de mapper les valeurs.`,
      );
    }

    for (const valuesTuple of parsed.values) {
      if (valuesTuple.length !== cols.length) {
        throw new Error(
          `INSERT INTO \`${parsed.table}\` : tuple de ${valuesTuple.length} valeurs ne correspond pas aux ${cols.length} colonnes.`,
        );
      }
      const row: Row = {};
      cols.forEach((c, i) => {
        row[c] = valuesTuple[i];
      });
      table.rows.push(row);
    }

    tables.set(parsed.table, table);
    pos = parsed.endPos;
  }

  return [...tables.values()];
}

// ---------- CREATE TABLE ----------

function* extractCreateTables(sql: string): Generator<{ name: string; columns: string[] }> {
  const re = /CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)`?\s*\(/gi;
  let match: RegExpExecArray | null;
  while ((match = re.exec(sql)) !== null) {
    const name = match[1];
    const bodyStart = match.index + match[0].length;
    const bodyEnd = findMatchingParen(sql, bodyStart - 1);
    if (bodyEnd === -1) continue;
    const body = sql.slice(bodyStart, bodyEnd);
    yield { name, columns: extractColumns(body) };
  }
}

function extractColumns(createBody: string): string[] {
  const columns: string[] = [];
  // Chaque ligne du body : soit une colonne (commence par `name` ou name), soit une contrainte (PRIMARY KEY, KEY, UNIQUE, etc.)
  for (const rawLine of splitTopLevel(createBody, ",")) {
    const line = rawLine.trim();
    if (!line) continue;
    if (/^(PRIMARY\s+KEY|KEY|UNIQUE|CONSTRAINT|FOREIGN\s+KEY|INDEX|FULLTEXT|SPATIAL|CHECK)\b/i.test(line)) {
      continue;
    }
    const m = line.match(/^`?(\w+)`?/);
    if (m) columns.push(m[1]);
  }
  return columns;
}

/** Split sur le séparateur mais en ignorant ceux à l'intérieur de parenthèses imbriquées ou de strings. */
function splitTopLevel(s: string, sep: string): string[] {
  const result: string[] = [];
  let depth = 0;
  let inString: string | null = null;
  let start = 0;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (inString) {
      if (c === "\\") {
        i++;
        continue;
      }
      if (c === inString) inString = null;
      continue;
    }
    if (c === "'" || c === '"' || c === "`") {
      inString = c;
      continue;
    }
    if (c === "(") depth++;
    else if (c === ")") depth--;
    else if (c === sep && depth === 0) {
      result.push(s.slice(start, i));
      start = i + 1;
    }
  }
  result.push(s.slice(start));
  return result;
}

function findMatchingParen(s: string, openIdx: number): number {
  if (s[openIdx] !== "(") return -1;
  let depth = 1;
  let inString: string | null = null;
  for (let i = openIdx + 1; i < s.length; i++) {
    const c = s[i];
    if (inString) {
      if (c === "\\") {
        i++;
        continue;
      }
      if (c === inString) inString = null;
      continue;
    }
    if (c === "'" || c === '"') {
      inString = c;
      continue;
    }
    if (c === "(") depth++;
    else if (c === ")") {
      depth--;
      if (depth === 0) return i;
    }
  }
  return -1;
}

// ---------- INSERT INTO ----------

type ParsedInsert = {
  table: string;
  columns: string[] | null;
  values: unknown[][];
  endPos: number;
};

function parseInsert(sql: string, start: number): ParsedInsert | null {
  // Doit commencer par "INSERT INTO"
  if (!sql.startsWith("INSERT INTO", start)) return null;

  let i = start + "INSERT INTO".length;
  i = skipWhitespace(sql, i);

  // Nom de table : `name` ou name
  const tableMatch = sql.slice(i).match(/^`?(\w+)`?/);
  if (!tableMatch) return null;
  const table = tableMatch[1];
  i += tableMatch[0].length;
  i = skipWhitespace(sql, i);

  // Colonnes optionnelles : (col1, col2, ...)
  let columns: string[] | null = null;
  if (sql[i] === "(") {
    const closeIdx = findMatchingParen(sql, i);
    if (closeIdx === -1) return null;
    const colsBody = sql.slice(i + 1, closeIdx);
    columns = colsBody.split(",").map((c) => c.trim().replace(/^`|`$/g, ""));
    i = closeIdx + 1;
    i = skipWhitespace(sql, i);
  }

  // VALUES
  if (!/^VALUES/i.test(sql.slice(i))) return null;
  i += "VALUES".length;
  i = skipWhitespace(sql, i);

  // Parse les tuples (v1, v2, ...), (v1, v2, ...), ...
  const allValues: unknown[][] = [];
  while (sql[i] === "(") {
    const tuple = parseTuple(sql, i);
    if (!tuple) return null;
    allValues.push(tuple.values);
    i = tuple.endPos;
    i = skipWhitespace(sql, i);
    if (sql[i] === ",") {
      i++;
      i = skipWhitespace(sql, i);
    } else {
      break;
    }
  }

  // Le statement se termine par `;`
  if (sql[i] === ";") i++;

  return { table, columns, values: allValues, endPos: i };
}

function parseTuple(sql: string, start: number): { values: unknown[]; endPos: number } | null {
  if (sql[start] !== "(") return null;
  const values: unknown[] = [];
  let i = start + 1;

  while (i < sql.length) {
    i = skipWhitespace(sql, i);
    const v = parseValue(sql, i);
    if (!v) return null;
    values.push(v.value);
    i = v.endPos;
    i = skipWhitespace(sql, i);
    if (sql[i] === ",") {
      i++;
      continue;
    }
    if (sql[i] === ")") {
      return { values, endPos: i + 1 };
    }
    return null;
  }
  return null;
}

function parseValue(sql: string, start: number): { value: unknown; endPos: number } | null {
  const c = sql[start];

  // NULL
  if (sql.startsWith("NULL", start) && !/\w/.test(sql[start + 4] ?? "")) {
    return { value: null, endPos: start + 4 };
  }

  // String 'xxx' (avec escapes MySQL)
  if (c === "'") return parseString(sql, start, "'");

  // String "xxx" (mysqldump utilise plutôt ', mais on accepte)
  if (c === '"') return parseString(sql, start, '"');

  // BLOB hexa : 0x...
  if (c === "0" && sql[start + 1] === "x") {
    let end = start + 2;
    while (end < sql.length && /[0-9a-fA-F]/.test(sql[end])) end++;
    const hex = sql.slice(start + 2, end);
    return { value: Buffer.from(hex, "hex"), endPos: end };
  }

  // Nombre (entier, décimal, négatif, exposant)
  const numMatch = sql.slice(start).match(/^-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?/);
  if (numMatch) {
    const raw = numMatch[0];
    const value = raw.includes(".") || raw.match(/[eE]/) ? parseFloat(raw) : parseInt(raw, 10);
    return { value, endPos: start + raw.length };
  }

  return null;
}

function parseString(
  sql: string,
  start: number,
  quote: string,
): { value: string; endPos: number } | null {
  let i = start + 1;
  let out = "";
  while (i < sql.length) {
    const c = sql[i];
    if (c === "\\") {
      const next = sql[i + 1];
      switch (next) {
        case "0":
          out += "\0";
          break;
        case "n":
          out += "\n";
          break;
        case "r":
          out += "\r";
          break;
        case "t":
          out += "\t";
          break;
        case "b":
          out += "\b";
          break;
        case "Z":
          out += "\x1a";
          break;
        case "'":
          out += "'";
          break;
        case '"':
          out += '"';
          break;
        case "\\":
          out += "\\";
          break;
        case "%":
          out += "\\%";
          break;
        case "_":
          out += "\\_";
          break;
        default:
          out += next ?? "";
      }
      i += 2;
      continue;
    }
    // Cas ANSI : '' = escape pour '
    if (c === quote && sql[i + 1] === quote) {
      out += quote;
      i += 2;
      continue;
    }
    if (c === quote) {
      return { value: out, endPos: i + 1 };
    }
    out += c;
    i++;
  }
  return null;
}

function skipWhitespace(sql: string, i: number): number {
  while (i < sql.length && /\s/.test(sql[i])) i++;
  return i;
}

// ---------- Normalisations utiles ----------

/**
 * Convertit une string "YYYY-MM-DD HH:MM:SS" MySQL en Date JS.
 * Renvoie null pour les zéros MySQL (`0000-00-00 ...`) ou les chaînes invalides.
 */
export function mysqlDateToJs(value: unknown): Date | null {
  if (value == null) return null;
  if (value instanceof Date) return value;
  if (typeof value !== "string") return null;
  if (value.startsWith("0000-00-00")) return null;
  const d = new Date(value.replace(" ", "T") + "Z");
  return isNaN(d.getTime()) ? null : d;
}
