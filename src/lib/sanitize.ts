import DOMPurify from "isomorphic-dompurify";

// Sanitize du HTML legacy CRM avant stockage (defense in depth - sera AUSSI
// sanitize au rendu côté front).
// On autorise les balises usuelles de contenu rédactionnel + médias,
// on bloque scripts/iframes/event handlers.
const ALLOWED_TAGS = [
  "p", "div", "span", "br", "hr",
  "h1", "h2", "h3", "h4", "h5", "h6",
  "ul", "ol", "li", "blockquote",
  "strong", "em", "b", "i", "u", "s", "sub", "sup", "code", "pre",
  "a", "img", "video", "source",
  "table", "thead", "tbody", "tr", "th", "td",
  "figure", "figcaption",
];
const ALLOWED_ATTR = [
  "href", "target", "rel",
  "src", "alt", "title",
  "width", "height", "loading",
  "controls", "type",
  "colspan", "rowspan",
  "class", "id",
  "style",
];

export function sanitizeHtml(html: string | null | undefined): string | null {
  if (html == null) return null;
  if (typeof html !== "string") return null;
  const trimmed = html.trim();
  if (!trimmed) return null;
  return DOMPurify.sanitize(trimmed, {
    ALLOWED_TAGS,
    ALLOWED_ATTR,
    // Strip les liens javascript:, data: URIs sur src/href.
    ALLOWED_URI_REGEXP: /^(?:(?:https?|mailto|tel|ftp):|[^a-z]|[a-z+.-]+(?:[^a-z+.\-:]|$))/i,
  });
}

// Sanitize un objet où certaines clés sont du HTML. Modifie en place pour
// performance, renvoie l'objet pour chaînage.
export function sanitizeFields<T extends Record<string, unknown>>(
  obj: T,
  keys: (keyof T)[],
): T {
  for (const k of keys) {
    const v = obj[k];
    if (typeof v === "string") {
      obj[k] = sanitizeHtml(v) as T[keyof T];
    }
  }
  return obj;
}
