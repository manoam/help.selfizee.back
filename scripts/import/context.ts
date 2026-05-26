import { PrismaClient } from "@prisma/client";

import type { ExpectedTable } from "./lib/dump-loader.js";

export type Row = Record<string, unknown>;

export type ImportContext = {
  prisma: PrismaClient;
  rows: Map<ExpectedTable, Row[]>;
};

export function connectPrisma() {
  return new PrismaClient();
}

// Helpers de coercion : les valeurs viennent du parser SQL (typage opaque).
export function asNum(v: unknown): number | null {
  if (v == null) return null;
  if (typeof v === "number") return v;
  if (typeof v === "string") {
    const n = Number(v);
    return Number.isFinite(n) ? n : null;
  }
  return null;
}

export function asReqNum(v: unknown, fieldHint = "field"): number {
  const n = asNum(v);
  if (n == null) throw new Error(`Expected number for ${fieldHint}, got ${JSON.stringify(v)}`);
  return n;
}

export function asStr(v: unknown): string | null {
  if (v == null) return null;
  if (typeof v === "string") return v;
  return String(v);
}

export function asReqStr(v: unknown, fieldHint = "field"): string {
  const s = asStr(v);
  if (s == null) throw new Error(`Expected string for ${fieldHint}, got ${JSON.stringify(v)}`);
  return s;
}

export function asBool(v: unknown): boolean {
  if (typeof v === "boolean") return v;
  if (typeof v === "number") return v !== 0;
  if (typeof v === "string") return v === "1" || v.toLowerCase() === "true";
  return false;
}
