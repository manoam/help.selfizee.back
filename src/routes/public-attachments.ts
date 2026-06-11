import { Router } from "express";

import { prisma } from "../lib/prisma.js";

export const publicAttachmentsRouter = Router();

// Download d'un attachment via son ID, accessible PUBLIQUEMENT uniquement si
// son post parent a status=PUBLISHED. Pour les drafts/archived on renvoie 404.
//
// Note : remplace l'ancien `app.use("/uploads", express.static(...))` qui
// servait tous les fichiers sans auth.
publicAttachmentsRouter.get("/:id/download", async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isFinite(id) || id <= 0) {
      return res.status(400).json({ error: "bad_id" });
    }
    const att = await prisma.postAttachment.findUnique({
      where: { id },
      include: { post: { select: { status: true } } },
    });
    if (!att || att.post.status !== "PUBLISHED") {
      return res.status(404).json({ error: "not_found" });
    }
    res.download(att.storagePath, att.originalName ?? att.filename);
  } catch (err) {
    next(err);
  }
});
