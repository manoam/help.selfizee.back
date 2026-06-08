import { Router } from "express";
import { z } from "zod";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";
import { slugify } from "../lib/slugify.js";

export const categoriesRouter = Router();

// Public — liste plate (utilisée par les selects admin et la nav publique).
// Si ?tree=1, renvoie le sommaire imbriqué (subCategories + subSubCategories).
categoriesRouter.get("/", async (req, res, next) => {
  try {
    if (req.query.tree === "1") {
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
      return res.json(categories);
    }
    const categories = await prisma.category.findMany({
      where: { afficher: true },
      orderBy: { ordre: "asc" },
      select: { id: true, nom: true, slug: true },
    });
    res.json(categories);
  } catch (err) {
    next(err);
  }
});

// Détail d'une catégorie par slug, avec sous-catégories et sous-sous-catégories
// incluses + count des posts par sous-sous-cat (pour la page CategoryPage publique).
categoriesRouter.get("/by-slug/:slug", async (req, res, next) => {
  try {
    const cat = await prisma.category.findUnique({
      where: { slug: req.params.slug },
      include: {
        subCategories: {
          orderBy: { ordre: "asc" },
          include: {
            subSubCategories: {
              orderBy: { ordre: "asc" },
              include: {
                _count: { select: { posts: true } },
              },
            },
            _count: { select: { posts: true } },
          },
        },
      },
    });
    if (!cat) return res.status(404).json({ error: "not_found" });
    res.json(cat);
  } catch (err) {
    next(err);
  }
});

// Sous-catégories à plat, avec leur categoryId — pour cascade côté admin.
categoriesRouter.get("/sub", async (_req, res, next) => {
  try {
    const rows = await prisma.subCategory.findMany({
      orderBy: { ordre: "asc" },
      select: { id: true, nom: true, slug: true, categoryId: true },
    });
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

// Une sous-catégorie par slug (avec sa cat parente pour breadcrumb).
categoriesRouter.get("/sub/by-slug/:slug", async (req, res, next) => {
  try {
    const sub = await prisma.subCategory.findFirst({
      where: { slug: req.params.slug },
      include: { category: { select: { id: true, nom: true, slug: true } } },
    });
    if (!sub) return res.status(404).json({ error: "not_found" });
    res.json(sub);
  } catch (err) {
    next(err);
  }
});

// Une sous-sous-catégorie par slug.
categoriesRouter.get("/sub-sub/by-slug/:slug", async (req, res, next) => {
  try {
    const ssc = await prisma.subSubCategory.findFirst({
      where: { slug: req.params.slug },
      include: {
        subCategory: {
          include: {
            category: { select: { id: true, nom: true, slug: true } },
          },
        },
      },
    });
    if (!ssc) return res.status(404).json({ error: "not_found" });
    res.json(ssc);
  } catch (err) {
    next(err);
  }
});

// Sous-sous-catégories à plat, avec leur subCategoryId.
categoriesRouter.get("/sub-sub", async (_req, res, next) => {
  try {
    const rows = await prisma.subSubCategory.findMany({
      orderBy: { ordre: "asc" },
      select: { id: true, nom: true, slug: true, subCategoryId: true },
    });
    res.json(rows);
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
