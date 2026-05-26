import { JSDOM } from "jsdom";
import { generateJSON } from "@tiptap/html";
import StarterKit from "@tiptap/starter-kit";

// JSDOM fournit `document`/`Element` globaux dont @tiptap/html a besoin côté Node.
const dom = new JSDOM("<!doctype html><html><body></body></html>");
const { window } = dom;

// @ts-expect-error globals
globalThis.window ||= window;
// @ts-expect-error globals
globalThis.document ||= window.document;
// @ts-expect-error globals
globalThis.Element ||= window.Element;
// @ts-expect-error globals
globalThis.Node ||= window.Node;
// @ts-expect-error globals
globalThis.DocumentFragment ||= window.DocumentFragment;

const EXTENSIONS = [StarterKit];

/**
 * Convertit du HTML legacy (CakePHP) en doc JSON TipTap.
 * En cas d'échec, fallback sur un doc avec le texte brut.
 */
export function htmlToTiptapJson(html: string): {
  doc: object;
  text: string;
  ok: boolean;
} {
  const cleanHtml = (html ?? "").trim();
  const text = stripHtml(cleanHtml);

  if (!cleanHtml) {
    return { doc: emptyDoc(""), text: "", ok: true };
  }

  try {
    const doc = generateJSON(cleanHtml, EXTENSIONS);
    return { doc, text, ok: true };
  } catch (err) {
    console.warn("  ! html→tiptap failed, fallback plain text:", (err as Error).message);
    return { doc: emptyDoc(text), text, ok: false };
  }
}

function emptyDoc(text: string) {
  return {
    type: "doc",
    content: text
      ? [{ type: "paragraph", content: [{ type: "text", text }] }]
      : [{ type: "paragraph" }],
  };
}

function stripHtml(html: string): string {
  return html
    .replace(/<style[\s\S]*?<\/style>/gi, " ")
    .replace(/<script[\s\S]*?<\/script>/gi, " ")
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/\s+/g, " ")
    .trim();
}
