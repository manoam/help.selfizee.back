import { Router } from "express";
import multer from "multer";
import path from "node:path";
import fs from "node:fs";
import fsp from "node:fs/promises";
import { randomUUID } from "node:crypto";

import { prisma } from "../lib/prisma.js";
import { requireAuth } from "../middleware/auth.js";

// Dossier d'upload. En dev local, monté dans /app/uploads via docker-compose ;
// en prod Coolify, à mapper sur un volume persistant.
const UPLOAD_DIR = process.env.UPLOAD_DIR || "/app/uploads";

// Création synchrone au load (rapide, pas de top-level await qui bloque
// l'évaluation du module ESM).
try {
  fs.mkdirSync(UPLOAD_DIR, { recursive: true });
} catch (err) {
  console.warn(`[attachments] cannot create ${UPLOAD_DIR}:`, err);
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, UPLOAD_DIR),
  filename: (_req, file, cb) => {
    // path.basename pour défense en profondeur (sanitize CR/LF dans le nom).
    const safeName = path.basename(file.originalname);
    const ext = path.extname(safeName).toLowerCase();
    cb(null, `${randomUUID()}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 50 * 1024 * 1024 }, // 50 MB max par fichier
});

function parseId(raw: unknown): number | null {
  const n = Number(raw);
  return Number.isFinite(n) && n > 0 ? n : null;
}

export const attachmentsRouter = Router();

// Upload un fichier attaché à un post. Multipart form-data, champ "file".
// Champs optionnels : label, description.
attachmentsRouter.post(
  "/:postId",
  requireAuth,
  upload.single("file"),
  async (req, res, next) => {
    try {
      const postId = parseId(req.params.postId);
      if (postId == null) return res.status(400).json({ error: "bad_id" });
      if (!req.file) {
        return res.status(400).json({ error: "no_file" });
      }
      const attachment = await prisma.postAttachment.create({
        data: {
          postId,
          filename: req.file.filename,
          originalName: req.file.originalname,
          mimeType: req.file.mimetype,
          sizeBytes: req.file.size,
          storagePath: path.join(UPLOAD_DIR, req.file.filename),
          label: (req.body.label as string) || null,
          description: (req.body.description as string) || null,
        },
      });
      res.status(201).json(attachment);
    } catch (err) {
      next(err);
    }
  },
);

// Liste les attachments d'un post (route légère, sans charger tout le post).
attachmentsRouter.get("/by-post/:postId", requireAuth, async (req, res, next) => {
  try {
    const postId = parseId(req.params.postId);
    if (postId == null) return res.status(400).json({ error: "bad_id" });
    const rows = await prisma.postAttachment.findMany({
      where: { postId },
      orderBy: { createdAt: "asc" },
      select: {
        id: true,
        filename: true,
        originalName: true,
        mimeType: true,
        sizeBytes: true,
        label: true,
        description: true,
      },
    });
    res.json(rows);
  } catch (err) {
    next(err);
  }
});

// Update meta (label, description) d'un attachment sans re-uploader.
attachmentsRouter.put("/:id", requireAuth, async (req, res, next) => {
  try {
    const id = parseId(req.params.id);
    if (id == null) return res.status(400).json({ error: "bad_id" });
    const attachment = await prisma.postAttachment.update({
      where: { id },
      data: {
        label: req.body.label ?? undefined,
        description: req.body.description ?? undefined,
      },
    });
    res.json(attachment);
  } catch (err) {
    next(err);
  }
});

// Stream le fichier (authentifié — pour le download public utiliser /public-attachments).
attachmentsRouter.get("/:id/download", requireAuth, async (req, res, next) => {
  try {
    const id = parseId(req.params.id);
    if (id == null) return res.status(400).json({ error: "bad_id" });
    const att = await prisma.postAttachment.findUnique({ where: { id } });
    if (!att) return res.status(404).json({ error: "not_found" });
    res.download(
      att.storagePath,
      path.basename(att.originalName ?? att.filename),
    );
  } catch (err) {
    next(err);
  }
});

attachmentsRouter.delete("/:id", requireAuth, async (req, res, next) => {
  try {
    const id = parseId(req.params.id);
    if (id == null) return res.status(400).json({ error: "bad_id" });
    const att = await prisma.postAttachment.findUnique({ where: { id } });
    if (!att) return res.status(404).json({ error: "not_found" });
    await prisma.postAttachment.delete({ where: { id } });
    // Best-effort sur le file system : si le fichier est déjà absent, on ignore.
    try {
      await fsp.unlink(att.storagePath);
    } catch {
      // ignore
    }
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});
