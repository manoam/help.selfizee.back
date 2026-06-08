import { Router } from "express";
import multer from "multer";
import path from "node:path";
import fs from "node:fs/promises";
import { randomUUID } from "node:crypto";

import { requireAuth } from "../middleware/auth.js";

// Stockage des images uploadées (richtext, etc.). Sépare des attachments.
const IMAGE_DIR = process.env.UPLOAD_IMAGE_DIR || "/app/uploads/images";

try {
  await fs.mkdir(IMAGE_DIR, { recursive: true });
} catch (err) {
  console.warn(`[upload] cannot create ${IMAGE_DIR}:`, err);
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, IMAGE_DIR),
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    cb(null, `${randomUUID()}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB max
  fileFilter: (_req, file, cb) => {
    if (!file.mimetype.startsWith("image/")) {
      return cb(new Error("only_images_allowed"));
    }
    cb(null, true);
  },
});

export const uploadRouter = Router();

// Upload image pour l'éditeur richtext. Renvoie { url } compatible TipTap/TinyMCE.
uploadRouter.post(
  "/image",
  requireAuth,
  upload.single("file"),
  (req, res) => {
    if (!req.file) {
      return res.status(400).json({ error: "no_file" });
    }
    // URL relative servie via /uploads/images/* (à monter en static côté server.ts).
    res.json({
      url: `/uploads/images/${req.file.filename}`,
      filename: req.file.filename,
      originalName: req.file.originalname,
      sizeBytes: req.file.size,
    });
  },
);
