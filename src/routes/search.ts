import { Router } from "express";

import { prisma } from "../lib/prisma.js";

export const searchRouter = Router();

// Recherche full-text simple sur les posts publiés.
// Scope : titre, resume, descriptionProbleme, question, noticeClient, noticeCallCenter, contenuText.
// Si le query est vide, retourne []. Log la recherche dans AssistanceRecherche.
searchRouter.get("/", async (req, res, next) => {
  try {
    const q = (req.query.q as string | undefined)?.trim();
    if (!q || q.length < 2) return res.json([]);

    // Log async (fire-and-forget) — pas critique si ça plante.
    prisma.assistanceRecherche
      .create({ data: { text: q } })
      .catch((err) => console.warn("[search] log failed:", err));

    const posts = await prisma.post.findMany({
      where: {
        status: "PUBLISHED",
        OR: [
          { titre: { contains: q, mode: "insensitive" } },
          { resume: { contains: q, mode: "insensitive" } },
          { descriptionProbleme: { contains: q, mode: "insensitive" } },
          { question: { contains: q, mode: "insensitive" } },
          { noticeClient: { contains: q, mode: "insensitive" } },
          { noticeCallCenter: { contains: q, mode: "insensitive" } },
          { contenuText: { contains: q, mode: "insensitive" } },
        ],
      },
      orderBy: { publishedAt: "desc" },
      take: 50,
      select: {
        id: true,
        titre: true,
        slug: true,
        resume: true,
        isFavourite: true,
        publishedAt: true,
      },
    });
    res.json(posts);
  } catch (err) {
    next(err);
  }
});
