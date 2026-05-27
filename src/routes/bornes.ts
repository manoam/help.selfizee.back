import { Router } from "express";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";

export const gammesBornesRouter = Router();
export const modelBornesRouter = Router();

// Gammes de bornes — listées pour le select du formulaire admin.
gammesBornesRouter.get("/", requireAuth, async (_req, res, next) => {
  try {
    const rows = await prisma.gammeBorne.findMany({
      orderBy: { nom: "asc" },
      select: { id: true, nom: true, slug: true },
    });
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

// Modèles d'une gamme. Si gammeId query param fourni, filtre.
modelBornesRouter.get("/", requireAuth, async (req, res, next) => {
  try {
    const gammeId = req.query.gammeId ? Number(req.query.gammeId) : undefined;
    const rows = await prisma.modelBorne.findMany({
      where: gammeId ? { gammeBorneId: gammeId } : undefined,
      orderBy: { nom: "asc" },
      select: {
        id: true,
        nom: true,
        version: true,
        gammeBorneId: true,
      },
    });
    res.json(rows);
  } catch (err) {
    next(err);
  }
});
