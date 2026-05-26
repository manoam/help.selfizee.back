import { z } from "zod";

const schema = z.object({
  NODE_ENV: z.enum(["development", "production", "test"]).default("development"),
  PORT: z.coerce.number().default(3001),
  DATABASE_URL: z.string().url(),

  // Keycloak — Selfizee plateformdev
  KEYCLOAK_URL: z.string().url(),
  KEYCLOAK_REALM: z.string().min(1),
  KEYCLOAK_AUDIENCE: z.string().min(1),

  CORS_ORIGINS: z
    .string()
    .default("http://localhost:3000")
    .transform((s) => s.split(",").map((o) => o.trim()).filter(Boolean)),
});

export const env = schema.parse(process.env);
export type Env = typeof env;

export const keycloakIssuer = `${env.KEYCLOAK_URL.replace(/\/$/, "")}/realms/${env.KEYCLOAK_REALM}`;
export const keycloakJwksUrl = `${keycloakIssuer}/protocol/openid-connect/certs`;
