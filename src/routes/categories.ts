import { Router } from "express";
import { z } from "zod";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";
import { slugify } from "../lib/slugify.js";

export const categoriesRouter = Router();

// Public — sommaire avec sous-cat et sous-sous-cat.
categoriesRouter.get("/", async (_req, res, next) => {
  try {
    const categories = await prisma.category.findMany({
      where: { afficher: true },
      orderBy: { ordre: "asc" },
      include: {
        subCategories: {
          orderBy: { ordre: "asc" },
          include: {
            subSubCategories: { orderBy: { ordre: "asc" } },
          },
        },
      },
    });
    res.json(categories);
  } catch (err) {
    next(err);
  }
});

// ----- Admin CRUD -----

const catSchema = z.object({
  nom: z.string().min(1).max(250),
  slug: z.string().optional(),
  description: z.string().optional(),
  afficher: z.boolean().default(true),
  ordre: z.number().default(0),
});

categoriesRouter.post("/", requireAuth, async (req, res, next) => {
  try {
    const data = catSchema.parse(req.body);
    const cat = await prisma.category.create({
      data: { ...data, slug: data.slug ?? slugify(data.nom) },
    });
    res.status(201).json(cat);
  } catch (err) {
    next(err);
  }
});

categoriesRouter.put("/:id", requireAuth, async (req, res, next) => {
  try {
    const data = catSchema.partial().parse(req.body);
    const cat = await prisma.category.update({
      where: { id: Number(req.params.id) },
      data,
    });
    res.json(cat);
  } catch (err) {
    next(err);
  }
});

categoriesRouter.delete("/:id", requireAuth, async (req, res, next) => {
  try {
    await prisma.category.delete({ where: { id: Number(req.params.id) } });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});
