import { Router } from "express";

import { requireAuth } from "../middleware/auth.js";

export const authRouter = Router();

// Renvoie les infos extraites du token Keycloak.
// Pas de login/logout côté back — le front s'en occupe via OIDC redirect.
authRouter.get("/me", requireAuth, (req, res) => {
  res.json({
    sub: req.user!.sub,
    email: req.user!.email,
    name: req.user!.name,
    preferredUsername: req.user!.preferredUsername,
    roles: req.user!.roles,
  });
});
