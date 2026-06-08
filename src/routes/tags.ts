import { Router } from "express";
import { z } from "zod";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";
import { slugify } from "../lib/slugify.js";

export const tagsRouter = Router();

tagsRouter.get("/", async (_req, res, next) => {
  try {
    const tags = await prisma.tag.findMany({
      orderBy: { name: "asc" },
      include: { _count: { select: { posts: true } } },
    });
    res.json(tags);
  } catch (err) {
    next(err);
  }
});

tagsRouter.get("/by-slug/:slug", async (req, res, next) => {
  try {
    const tag = await prisma.tag.findUnique({
      where: { slug: req.params.slug },
    });
    if (!tag) return res.status(404).json({ error: "not_found" });
    res.json(tag);
  } catch (err) {
    next(err);
  }
});

const tagSchema = z.object({ name: z.string().min(1).max(255) });

tagsRouter.post("/", requireAuth, async (req, res, next) => {
  try {
    const { name } = tagSchema.parse(req.body);
    const tag = await prisma.tag.create({
      data: { name, slug: slugify(name) },
    });
    res.status(201).json(tag);
  } catch (err) {
    next(err);
  }
});

tagsRouter.put("/:id", requireAuth, async (req, res, next) => {
  try {
    const { name } = tagSchema.parse(req.body);
    const tag = await prisma.tag.update({
      where: { id: Number(req.params.id) },
      data: { name, slug: slugify(name) },
    });
    res.json(tag);
  } catch (err) {
    next(err);
  }
});

tagsRouter.delete("/:id", requireAuth, async (req, res, next) => {
  try {
    await prisma.tag.delete({ where: { id: Number(req.params.id) } });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});
