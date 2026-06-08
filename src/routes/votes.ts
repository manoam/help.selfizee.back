import { Router } from "express";
import { z } from "zod";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";

export const votesRouter = Router();

const voteSchema = z.object({
  value: z.enum(["SAD", "NEUTRAL", "HAPPY"]),
});

// Récupère les compteurs de votes pour un post + le vote du user courant.
votesRouter.get("/by-post/:postId", requireAuth, async (req, res, next) => {
  try {
    const postId = Number(req.params.postId);
    const [counts, myVote] = await Promise.all([
      prisma.vote.groupBy({
        by: ["value"],
        where: { postId },
        _count: true,
      }),
      prisma.vote.findUnique({
        where: {
          postId_voterKcSub: { postId, voterKcSub: req.user!.sub },
        },
      }),
    ]);
    const tally = { SAD: 0, NEUTRAL: 0, HAPPY: 0 };
    for (const c of counts) tally[c.value] = c._count;
    res.json({ tally, myVote: myVote?.value ?? null });
  } catch (err) {
    next(err);
  }
});

// Upsert le vote du user pour un post (1 seul vote par user, peut être changé).
votesRouter.put("/by-post/:postId", requireAuth, async (req, res, next) => {
  try {
    const postId = Number(req.params.postId);
    const { value } = voteSchema.parse(req.body);
    const vote = await prisma.vote.upsert({
      where: {
        postId_voterKcSub: { postId, voterKcSub: req.user!.sub },
      },
      update: { value },
      create: { postId, voterKcSub: req.user!.sub, value },
    });
    res.json(vote);
  } catch (err) {
    next(err);
  }
});

// Retire le vote du user pour un post.
votesRouter.delete("/by-post/:postId", requireAuth, async (req, res, next) => {
  try {
    const postId = Number(req.params.postId);
    await prisma.vote.delete({
      where: {
        postId_voterKcSub: { postId, voterKcSub: req.user!.sub },
      },
    });
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});
