import type { Request, Response, NextFunction } from "express";
import { createRemoteJWKSet, jwtVerify, type JWTPayload } from "jose";

import { env, keycloakIssuer, keycloakJwksUrl } from "../config/env.js";

// JWKS Keycloak — caché en mémoire, refetch automatique sur rotation des clés.
const jwks = createRemoteJWKSet(new URL(keycloakJwksUrl));

export type KcUser = {
  sub: string;            // ID utilisateur stable Keycloak
  email?: string;
  name?: string;
  preferredUsername?: string;
  roles: string[];        // realm + client roles aplatis
  raw: JWTPayload;
};

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      user?: KcUser;
    }
  }
}

function extractRoles(payload: JWTPayload): string[] {
  const roles: string[] = [];
  const realmAccess = payload.realm_access as { roles?: string[] } | undefined;
  if (realmAccess?.roles) roles.push(...realmAccess.roles);
  const resourceAccess = payload.resource_access as
    | Record<string, { roles?: string[] }>
    | undefined;
  if (resourceAccess) {
    for (const client of Object.values(resourceAccess)) {
      if (client?.roles) roles.push(...client.roles);
    }
  }
  return [...new Set(roles)];
}

export async function requireAuth(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  const header = req.headers.authorization;
  if (!header?.startsWith("Bearer ")) {
    return res.status(401).json({ error: "missing_bearer" });
  }
  const token = header.slice("Bearer ".length);

  try {
    const { payload } = await jwtVerify(token, jwks, {
      issuer: keycloakIssuer,
      audience: env.KEYCLOAK_AUDIENCE,
    });

    req.user = {
      sub: String(payload.sub),
      email: payload.email as string | undefined,
      name: payload.name as string | undefined,
      preferredUsername: payload.preferred_username as string | undefined,
      roles: extractRoles(payload),
      raw: payload,
    };
    next();
  } catch (err) {
    if (env.NODE_ENV === "development") {
      console.error("[auth] verify failed:", err);
    }
    return res.status(401).json({ error: "invalid_token" });
  }
}

export function requireRole(...roles: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) return res.status(401).json({ error: "unauthorized" });
    const hasOne = roles.some((r) => req.user!.roles.includes(r));
    if (!hasOne) return res.status(403).json({ error: "forbidden", required: roles });
    next();
  };
}
