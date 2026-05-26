import { z } from "zod";

const boolEnv = z
  .string()
  .optional()
  .transform((v) => v === "true" || v === "1");

const schema = z.object({
  NODE_ENV: z.enum(["development", "production", "test"]).default("development"),
  PORT: z.coerce.number().default(3001),
  DATABASE_URL: z.string().url(),

  // Bypass auth pendant la phase pré-prod (NDD HTTPS pas encore prêt pour Keycloak).
  // Mettre AUTH_DISABLED=true rend toutes les routes "admin" publiques et injecte un user fictif.
  AUTH_DISABLED: boolEnv,

  // Keycloak — Selfizee plateformdev. Optionnels si AUTH_DISABLED=true.
  KEYCLOAK_URL: z.string().url().optional(),
  KEYCLOAK_REALM: z.string().min(1).optional(),
  KEYCLOAK_AUDIENCE: z.string().min(1).optional(),

  CORS_ORIGINS: z
    .string()
    .default("http://localhost:3000")
    .transform((s) => s.split(",").map((o) => o.trim()).filter(Boolean)),
});

const parsed = schema.parse(process.env);
if (!parsed.AUTH_DISABLED) {
  if (!parsed.KEYCLOAK_URL || !parsed.KEYCLOAK_REALM || !parsed.KEYCLOAK_AUDIENCE) {
    throw new Error(
      "Missing KEYCLOAK_URL / KEYCLOAK_REALM / KEYCLOAK_AUDIENCE (set AUTH_DISABLED=true to bypass).",
    );
  }
}

export const env = parsed;
export type Env = typeof env;

export const keycloakIssuer = env.KEYCLOAK_URL
  ? `${env.KEYCLOAK_URL.replace(/\/$/, "")}/realms/${env.KEYCLOAK_REALM}`
  : "";
export const keycloakJwksUrl = keycloakIssuer
  ? `${keycloakIssuer}/protocol/openid-connect/certs`
  : "";
