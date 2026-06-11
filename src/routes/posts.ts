import { Router } from "express";
import { z } from "zod";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";
import { slugify } from "../lib/slugify.js";
import { sanitizeHtml } from "../lib/sanitize.js";

const HTML_FIELDS = [
  "descriptionProbleme",
  "question",
  "introClient",
  "noticeClient",
  "problemeClient",
  "introCallCenter",
  "noticeCallCenter",
  "problemeCallCenter",
  "introInterne",
  "problemeInterne",
] as const;

function sanitizeHtmlFields(data: Record<string, unknown>) {
  for (const k of HTML_FIELDS) {
    if (typeof data[k] === "string") {
      data[k] = sanitizeHtml(data[k] as string);
    }
  }
  return data;
}

export const postsRouter = Router();

// ----- Public -----

postsRouter.get("/", async (req, res, next) => {
  try {
    const categoryId = req.query.categoryId
      ? Number(req.query.categoryId)
      : undefined;
    const subCategoryId = req.query.subCategoryId
      ? Number(req.query.subCategoryId)
      : undefined;
    const subSubCategoryId = req.query.subSubCategoryId
      ? Number(req.query.subSubCategoryId)
      : undefined;
    const tagId = req.query.tagId ? Number(req.query.tagId) : undefined;
    const favourite = req.query.favourite === "1";
    // directOnly=1 : posts attachés DIRECTEMENT à categoryId (sans sous-cat).
    // Évite la duplication entre la nav par sous-cat et la liste générale.
    const directOnly = req.query.directOnly === "1";

    const categoryFilter =
      categoryId || subCategoryId || subSubCategoryId
        ? {
            categories: {
              some: {
                ...(categoryId ? { categoryId } : {}),
                ...(subCategoryId ? { subCategoryId } : {}),
                ...(subSubCategoryId ? { subSubCategoryId } : {}),
                ...(directOnly && categoryId
                  ? { subCategoryId: null, subSubCategoryId: null }
                  : {}),
              },
            },
          }
        : {};

    const tagFilter = tagId
      ? { tags: { some: { tagId } } }
      : {};

    const posts = await prisma.post.findMany({
      where: {
        status: "PUBLISHED",
        ...(favourite ? { isFavourite: true } : {}),
        ...categoryFilter,
        ...tagFilter,
      },
      orderBy: [
        { ordre: { sort: "asc", nulls: "last" } },
        { publishedAt: "desc" },
      ],
      take: 200,
      select: {
        id: true,
        titre: true,
        slug: true,
        resume: true,
        status: true,
        isFavourite: true,
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
      // Select restrictif : on n'expose ni authorKcSub (sub Keycloak interne)
      // ni storagePath (chemin disque). modelBornes et typeProfils ne sont pas
      // utilisés par PostPage -> retirés pour la perf.
      select: {
        id: true,
        titre: true,
        slug: true,
        resume: true,
        contenu: true,
        contenuText: true,
        status: true,
        isFavourite: true,
        ordre: true,
        publishedAt: true,
        authorName: true,
        descriptionProbleme: true,
        question: true,
        introClient: true,
        noticeClient: true,
        problemeClient: true,
        introCallCenter: true,
        noticeCallCenter: true,
        problemeCallCenter: true,
        introInterne: true,
        problemeInterne: true,
        categories: {
          select: {
            id: true,
            categoryId: true,
            subCategoryId: true,
            subSubCategoryId: true,
            category: { select: { id: true, nom: true, slug: true } },
            subCategory: { select: { id: true, nom: true, slug: true } },
            subSubCategory: { select: { id: true, nom: true, slug: true } },
          },
        },
        tags: {
          select: {
            tag: { select: { id: true, name: true, slug: true } },
          },
        },
        attachments: {
          select: {
            id: true,
            originalName: true,
            mimeType: true,
            sizeBytes: true,
            label: true,
            description: true,
          },
        },
        relatedTo: {
          select: {
            to: { select: { id: true, titre: true, slug: true } },
          },
        },
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
        isFavourite: true,
        publishedAt: true,
        updatedAt: true,
      },
    });
    res.json(posts);
  } catch (err) {
    next(err);
  }
});

// Recherche compacte pour le picker "articles liés" du formulaire admin.
postsRouter.get("/admin/searchable", requireAuth, async (req, res, next) => {
  try {
    const q = (req.query.q as string | undefined)?.trim();
    const excludeId = req.query.exclude ? Number(req.query.exclude) : undefined;
    const posts = await prisma.post.findMany({
      where: {
        ...(q
          ? { titre: { contains: q, mode: "insensitive" as const } }
          : {}),
        ...(excludeId ? { id: { not: excludeId } } : {}),
      },
      take: 50,
      orderBy: { updatedAt: "desc" },
      select: { id: true, titre: true, slug: true, status: true },
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
        modelBornes: { include: { gammeBorne: true, modelBorne: true } },
        typeProfils: { include: { typeProfil: true } },
        relatedTo: { include: { to: { select: { id: true, titre: true, slug: true } } } },
      },
    });
    if (!post) return res.status(404).json({ error: "not_found" });
    res.json(post);
  } catch (err) {
    next(err);
  }
});

const categorySchema = z.object({
  categoryId: z.number(),
  subCategoryId: z.number().optional().nullable(),
  subSubCategoryId: z.number().optional().nullable(),
});
const modelBorneSchema = z.object({
  gammeBorneId: z.number(),
  modelBorneId: z.number().optional().nullable(),
});

const postSchema = z.object({
  titre: z.string().min(1),
  slug: z.string().optional(),
  resume: z.string().optional().nullable(),
  contenu: z.any(),
  contenuText: z.string().optional().nullable(),
  status: z.enum(["DRAFT", "PUBLISHED", "ARCHIVED"]).default("DRAFT"),
  isFavourite: z.boolean().optional(),
  ordre: z.number().int().optional().nullable(),

  // Champs CRM hérités (HTML brut).
  descriptionProbleme: z.string().optional().nullable(),
  question: z.string().optional().nullable(),
  introClient: z.string().optional().nullable(),
  noticeClient: z.string().optional().nullable(),
  problemeClient: z.string().optional().nullable(),
  introCallCenter: z.string().optional().nullable(),
  noticeCallCenter: z.string().optional().nullable(),
  problemeCallCenter: z.string().optional().nullable(),
  introInterne: z.string().optional().nullable(),
  problemeInterne: z.string().optional().nullable(),

  // Relations.
  tagIds: z.array(z.number()).optional(),
  categories: z.array(categorySchema).optional(),
  modelBornes: z.array(modelBorneSchema).optional(),
  typeProfilIds: z.array(z.number()).optional(),
  relatedPostIds: z.array(z.number()).optional(),
});

// Construit le bloc `data` Prisma pour create/update, sans toucher aux relations.
function buildScalarData(data: z.infer<typeof postSchema>) {
  return {
    titre: data.titre,
    resume: data.resume ?? undefined,
    contenu: data.contenu,
    contenuText: data.contenuText ?? undefined,
    status: data.status,
    isFavourite: data.isFavourite ?? undefined,
    ordre: data.ordre ?? undefined,
    descriptionProbleme: data.descriptionProbleme ?? undefined,
    question: data.question ?? undefined,
    introClient: data.introClient ?? undefined,
    noticeClient: data.noticeClient ?? undefined,
    problemeClient: data.problemeClient ?? undefined,
    introCallCenter: data.introCallCenter ?? undefined,
    noticeCallCenter: data.noticeCallCenter ?? undefined,
    problemeCallCenter: data.problemeCallCenter ?? undefined,
    introInterne: data.introInterne ?? undefined,
    problemeInterne: data.problemeInterne ?? undefined,
  };
}

postsRouter.post("/", requireAuth, async (req, res, next) => {
  try {
    const data = postSchema.parse(req.body);
    sanitizeHtmlFields(data as Record<string, unknown>);
    const slug = data.slug ?? slugify(data.titre);

    const post = await prisma.post.create({
      data: {
        ...buildScalarData(data),
        slug,
        publishedAt: data.status === "PUBLISHED" ? new Date() : null,
        authorKcSub: req.user!.sub,
        authorName: req.user!.name ?? req.user!.preferredUsername ?? null,
        categories: data.categories?.length ? { create: data.categories } : undefined,
        tags: data.tagIds?.length
          ? { create: data.tagIds.map((tagId) => ({ tagId })) }
          : undefined,
        modelBornes: data.modelBornes?.length
          ? { create: data.modelBornes }
          : undefined,
        typeProfils: data.typeProfilIds?.length
          ? { create: data.typeProfilIds.map((typeProfilId) => ({ typeProfilId })) }
          : undefined,
        relatedTo: data.relatedPostIds?.length
          ? { create: data.relatedPostIds.map((toId) => ({ toId })) }
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
    if (!Number.isFinite(id) || id <= 0) {
      return res.status(400).json({ error: "bad_id" });
    }
    const data = postSchema.partial().parse(req.body);
    sanitizeHtmlFields(data as Record<string, unknown>);

    // Pour ne pas écraser publishedAt à chaque save, on lit l'état actuel
    // et on ne set publishedAt = now() qu'au moment d'une transition réelle
    // DRAFT/ARCHIVED -> PUBLISHED.
    const current =
      data.status !== undefined
        ? await prisma.post.findUnique({
            where: { id },
            select: { status: true, publishedAt: true },
          })
        : null;
    let publishedAtUpdate: Date | null | undefined;
    if (data.status === "PUBLISHED") {
      publishedAtUpdate =
        current && current.status !== "PUBLISHED" ? new Date() : undefined;
    } else if (data.status === "DRAFT" || data.status === "ARCHIVED") {
      publishedAtUpdate = null;
    } else {
      publishedAtUpdate = undefined;
    }

    const post = await prisma.$transaction(async (tx) => {
      if (data.categories) {
        await tx.postCategory.deleteMany({ where: { postId: id } });
      }
      if (data.tagIds) {
        await tx.postTag.deleteMany({ where: { postId: id } });
      }
      if (data.modelBornes) {
        await tx.postModelBorne.deleteMany({ where: { postId: id } });
      }
      if (data.typeProfilIds) {
        await tx.postTypeProfil.deleteMany({ where: { postId: id } });
      }
      if (data.relatedPostIds) {
        await tx.postRelation.deleteMany({ where: { fromId: id } });
      }
      return tx.post.update({
        where: { id },
        data: {
          ...(data.titre !== undefined ? { titre: data.titre } : {}),
          ...(data.slug !== undefined ? { slug: data.slug } : {}),
          ...(data.resume !== undefined ? { resume: data.resume } : {}),
          ...(data.contenu !== undefined ? { contenu: data.contenu } : {}),
          ...(data.contenuText !== undefined ? { contenuText: data.contenuText } : {}),
          ...(data.status !== undefined ? { status: data.status } : {}),
          ...(data.isFavourite !== undefined ? { isFavourite: data.isFavourite } : {}),
          ...(data.ordre !== undefined ? { ordre: data.ordre } : {}),
          ...(data.descriptionProbleme !== undefined
            ? { descriptionProbleme: data.descriptionProbleme }
            : {}),
          ...(data.question !== undefined ? { question: data.question } : {}),
          ...(data.introClient !== undefined ? { introClient: data.introClient } : {}),
          ...(data.noticeClient !== undefined ? { noticeClient: data.noticeClient } : {}),
          ...(data.problemeClient !== undefined
            ? { problemeClient: data.problemeClient }
            : {}),
          ...(data.introCallCenter !== undefined
            ? { introCallCenter: data.introCallCenter }
            : {}),
          ...(data.noticeCallCenter !== undefined
            ? { noticeCallCenter: data.noticeCallCenter }
            : {}),
          ...(data.problemeCallCenter !== undefined
            ? { problemeCallCenter: data.problemeCallCenter }
            : {}),
          ...(data.introInterne !== undefined ? { introInterne: data.introInterne } : {}),
          ...(data.problemeInterne !== undefined
            ? { problemeInterne: data.problemeInterne }
            : {}),
          publishedAt: publishedAtUpdate,
          categories: data.categories?.length
            ? { create: data.categories }
            : undefined,
          tags: data.tagIds?.length
            ? { create: data.tagIds.map((tagId) => ({ tagId })) }
            : undefined,
          modelBornes: data.modelBornes?.length
            ? { create: data.modelBornes }
            : undefined,
          typeProfils: data.typeProfilIds?.length
            ? { create: data.typeProfilIds.map((typeProfilId) => ({ typeProfilId })) }
            : undefined,
          relatedTo: data.relatedPostIds?.length
            ? { create: data.relatedPostIds.map((toId) => ({ toId })) }
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

// Réordonne une liste de posts (drag-drop côté admin).
// Payload : { ids: [1, 5, 3, ...] } → applique ordre 0..N-1 en UN SEUL UPDATE.
// Beaucoup plus rapide que N updates en transaction (O(1) round-trip vs O(N)).
const reorderSchema = z.object({
  ids: z.array(z.number().int().positive()).min(1).max(2000),
});

postsRouter.post("/reorder", requireAuth, async (req, res, next) => {
  try {
    const { ids } = reorderSchema.parse(req.body);
    // UPDATE en 1 seul round-trip avec UNNEST. Bien plus rapide que
    // N updates en transaction Prisma (O(1) vs O(N) round-trips réseau).
    const ords = ids.map((_, i) => i);
    await prisma.$executeRawUnsafe(
      `UPDATE "Post"
       SET ordre = c.ord
       FROM (SELECT * FROM UNNEST($1::int[], $2::int[]) AS t(id, ord)) AS c
       WHERE "Post".id = c.id`,
      ids,
      ords,
    );
    res.json({ updated: ids.length });
  } catch (err) {
    next(err);
  }
});
