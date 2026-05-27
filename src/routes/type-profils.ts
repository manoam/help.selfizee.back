import { Router } from "express";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";

export const typeProfilsRouter = Router();

// Niveaux d'accès — listés pour le multi-select du formulaire admin.
typeProfilsRouter.get("/", requireAuth, async (_req, res, next) => {
  try {
    const rows = await prisma.typeProfil.findMany({
      orderBy: { nom: "asc" },
      select: { id: true, nom: true, slug: true },
    });
    res.json(rows);
  } catch (err) {
    next(err);
  }
});
