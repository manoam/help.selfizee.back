import { Router } from "express";
import { z } from "zod";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";
import { slugify } from "../lib/slugify.js";

export const postsRouter = Router();

// ----- Public -----

postsRouter.get("/", async (_req, res, next) => {
  try {
    const posts = await prisma.post.findMany({
      where: { status: "PUBLISHED" },
      orderBy: { publishedAt: "desc" },
      select: {
        id: true,
        titre: true,
        slug: true,
        resume: true,
        status: true,
        publishedAt: true,
      },
    });
    res.json(posts);
  } catch (err) {
    next(err);
  }
});

postsRouter.get("/:slug", async (req, res, next) => {
  try {
    const post = await prisma.post.findUnique({
      where: { slug: req.params.slug },
      include: {
        categories: {
          include: { category: true, subCategory: true, subSubCategory: true },
        },
        tags: { include: { tag: true } },
        attachments: true,
      },
    });
    if (!post || post.status !== "PUBLISHED") {
      return res.status(404).json({ error: "not_found" });
    }
    res.json(post);
  } catch (err) {
    next(err);
  }
});

// ----- Admin (requireAuth via Keycloak) -----

// Liste tous statuts (drafts inclus).
postsRouter.get("/admin/all", requireAuth, async (_req, res, next) => {
  try {
    const posts = await prisma.post.findMany({
      orderBy: { updatedAt: "desc" },
      select: {
        id: true,
        titre: true,
        slug: true,
        resume: true,
        status: true,
        publishedAt: true,
        updatedAt: true,
      },
    });
    res.json(posts);
  } catch (err) {
    next(err);
  }
});

postsRouter.get("/by-id/:id", requireAuth, async (req, res, next) => {
  try {
    const post = await prisma.post.findUnique({
      where: { id: Number(req.params.id) },
      include: {
        categories: true,
        tags: { include: { tag: true } },
        attachments: true,
      },
    });
    if (!post) return res.status(404).json({ error: "not_found" });
    res.json(post);
  } catch (err) {
    next(err);
  }
});

const postSchema = z.object({
  titre: z.string().min(1),
  slug: z.string().optional(),
  resume: z.string().optional(),
  contenu: z.any(),
  contenuText: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLISHED", "ARCHIVED"]).default("DRAFT"),
  tagIds: z.array(z.number()).optional(),
  categories: z
    .array(
      z.object({
        categoryId: z.number(),
        subCategoryId: z.number().optional(),
        subSubCategoryId: z.number().optional(),
      }),
    )
    .optional(),
});

postsRouter.post("/", requireAuth, async (req, res, next) => {
  try {
    const data = postSchema.parse(req.body);
    const slug = data.slug ?? slugify(data.titre);

    const post = await prisma.post.create({
      data: {
        titre: data.titre,
        slug,
        resume: data.resume,
        contenu: data.contenu,
        contenuText: data.contenuText,
        status: data.status,
        publishedAt: data.status === "PUBLISHED" ? new Date() : null,
        authorKcSub: req.user!.sub,
        authorName: req.user!.name ?? req.user!.preferredUsername ?? null,
        categories: data.categories ? { create: data.categories } : undefined,
        tags: data.tagIds
          ? { create: data.tagIds.map((tagId) => ({ tagId })) }
          : undefined,
      },
    });
    res.status(201).json(post);
  } catch (err) {
    next(err);
  }
});

postsRouter.put("/:id", requireAuth, async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    const data = postSchema.partial().parse(req.body);

    const post = await prisma.$transaction(async (tx) => {
      if (data.categories) {
        await tx.postCategory.deleteMany({ where: { postId: id } });
      }
      if (data.tagIds) {
        await tx.postTag.deleteMany({ where: { postId: id } });
      }
      return tx.post.update({
        where: { id },
        data: {
          titre: data.titre,
          slug: data.slug,
          resume: data.resume,
          contenu: data.contenu,
          contenuText: data.contenuText,
          status: data.status,
          publishedAt:
            data.status === "PUBLISHED" ? new Date() : data.status ? null : undefined,
          categories: data.categories ? { create: data.categories } : undefined,
          tags: data.tagIds
            ? { create: data.tagIds.map((tagId) => ({ tagId })) }
            : undefined,
        },
      });
    });
    res.json(post);
  } catch (err) {
    next(err);
  }
});

postsRouter.delete("/:id", requireAuth, async (req, res, next) => {
  try {
    await prisma.post.delete({ where: { id: Number(req.params.id) } });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});
