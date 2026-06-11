import { Router } from "express";
import multer from "multer";
import path from "node:path";
import fs from "node:fs";
import { randomUUID } from "node:crypto";

import { requireAuth } from "../middleware/auth.js";

// Stockage des images uploadées (richtext, etc.). Sépare des attachments.
const IMAGE_DIR = process.env.UPLOAD_IMAGE_DIR || "/app/uploads/images";

// Création synchrone au load (pas de top-level await ESM bloquant).
try {
  fs.mkdirSync(IMAGE_DIR, { recursive: true });
} catch (err) {
  console.warn(`[upload] cannot create ${IMAGE_DIR}:`, err);
}

// Whitelist stricte d'extensions images. Pas de SVG (peut contenir du JS).
const ALLOWED_EXT = new Set([".jpg", ".jpeg", ".png", ".gif", ".webp"]);

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, IMAGE_DIR),
  filename: (_req, file, cb) => {
    const safeName = path.basename(file.originalname);
    const ext = path.extname(safeName).toLowerCase();
    cb(null, `${randomUUID()}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB max
  fileFilter: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    if (!ALLOWED_EXT.has(ext)) {
      return cb(null, false);
    }
    if (!file.mimetype.startsWith("image/")) {
      return cb(null, false);
    }
    cb(null, true);
  },
});

export const uploadRouter = Router();

// Upload image pour l'éditeur richtext. Stocke en DB pour pouvoir servir le
// fichier de manière authentifiée OU publique via un endpoint dédié.
uploadRouter.post(
  "/image",
  requireAuth,
  upload.single("file"),
  async (req, res, next) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "no_file_or_bad_type" });
      }
      // On crée un PostAttachment "orphelin" (postId à -1 = pas de post) ?
      // Non — pour simplicité, on retourne juste l'URL publique vers l'image
      // servie par un endpoint dédié /upload/image/:filename qui re-lit le fichier.
      res.json({
        url: `/upload/image/${req.file.filename}`,
        filename: req.file.filename,
        originalName: req.file.originalname,
        sizeBytes: req.file.size,
      });
    } catch (err) {
      next(err);
    }
  },
);

// Sert l'image uploadée. Lecture publique (utilisé dans les posts publiés).
// On valide que le filename est un UUID + extension whitelist pour empêcher
// le path traversal (../../etc/passwd).
const FILENAME_RE = /^[a-f0-9-]{36}\.(jpg|jpeg|png|gif|webp)$/i;
uploadRouter.get("/image/:filename", (req, res) => {
  const fn = req.params.filename;
  if (!FILENAME_RE.test(fn)) {
    return res.status(400).json({ error: "bad_filename" });
  }
  const fullPath = path.join(IMAGE_DIR, fn);
  // Cache HTTP 1h pour les images (immuables grâce à l'UUID).
  res.setHeader("Cache-Control", "public, max-age=3600");
  res.sendFile(fullPath, (err) => {
    if (err) {
      const status = (err as { status?: number }).status ?? 500;
      if (!res.headersSent) res.status(status).end();
    }
  });
});

