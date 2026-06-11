import "dotenv/config";

import express from "express";
import cors from "cors";
import helmet from "helmet";
import rateLimit from "express-rate-limit";

import { env } from "./config/env.js";
import { errorHandler } from "./middleware/error-handler.js";
import { authRouter } from "./routes/auth.js";
import { postsRouter } from "./routes/posts.js";
import { categoriesRouter } from "./routes/categories.js";
import { tagsRouter } from "./routes/tags.js";
import { attachmentsRouter } from "./routes/attachments.js";
import { gammesBornesRouter, modelBornesRouter } from "./routes/bornes.js";
import { typeProfilsRouter } from "./routes/type-profils.js";
import { searchRouter } from "./routes/search.js";
import { votesRouter } from "./routes/votes.js";
import { uploadRouter } from "./routes/upload.js";
import { publicAttachmentsRouter } from "./routes/public-attachments.js";

const app = express();

// Si on est derrière un reverse-proxy Coolify, on doit trust pour que
// rate-limit voie la vraie IP du client.
app.set("trust proxy", 1);

// Body limit raisonnable. Routes admin (post create/update) peuvent contenir
// du JSON TipTap + 9 textareas HTML. 2 MB est large.
app.use(express.json({ limit: "2mb" }));

// Helmet : headers de sécurité par défaut (X-Content-Type-Options, X-Frame-Options DENY, etc.).
// CSP désactivée ici car le front Vite a sa propre CSP via meta tag si besoin.
app.use(
  helmet({
    contentSecurityPolicy: false,
    crossOriginEmbedderPolicy: false,
    crossOriginResourcePolicy: { policy: "cross-origin" },
  }),
);

// CORS — autorise les origines listées dans CORS_ORIGINS (CSV).
const allowedOrigins = new Set(env.CORS_ORIGINS);
console.log(
  `[cors] allowed origins: ${[...allowedOrigins].join(", ") || "(none)"}`,
);
app.use(
  cors({
    origin: (origin, callback) => {
      // Pas d'Origin : autorisé uniquement en dev (curl local, etc.).
      if (!origin) {
        return callback(null, env.NODE_ENV !== "production");
      }
      if (allowedOrigins.has(origin)) return callback(null, true);
      console.warn(`[cors] rejected origin: ${origin}`);
      return callback(null, false);
    },
    credentials: true,
    maxAge: 86400,
  }),
);

// Rate limit global : 300 req/min/IP. Suffisant pour usage normal,
// bloque les abus (scan, brute force).
const globalLimiter = rateLimit({
  windowMs: 60 * 1000,
  limit: 300,
  standardHeaders: "draft-7",
  legacyHeaders: false,
});
app.use(globalLimiter);

// Rate limit dédié sur /search (log en DB = surface flood).
const searchLimiter = rateLimit({
  windowMs: 60 * 1000,
  limit: 60,
  standardHeaders: "draft-7",
  legacyHeaders: false,
});

// Rate limit dédié sur /upload (gros volume).
const uploadLimiter = rateLimit({
  windowMs: 60 * 1000,
  limit: 30,
  standardHeaders: "draft-7",
  legacyHeaders: false,
});

app.get("/health", (_req, res) => {
  res.json({ status: "ok", env: env.NODE_ENV });
});

app.use("/auth", authRouter);
app.use("/posts", postsRouter);
app.use("/categories", categoriesRouter);
app.use("/tags", tagsRouter);
app.use("/attachments", attachmentsRouter);
app.use("/public-attachments", publicAttachmentsRouter);
app.use("/gammes-bornes", gammesBornesRouter);
app.use("/model-bornes", modelBornesRouter);
app.use("/type-profils", typeProfilsRouter);
app.use("/search", searchLimiter, searchRouter);
app.use("/votes", votesRouter);
app.use("/upload", uploadLimiter, uploadRouter);

app.use(errorHandler);

app.listen(env.PORT, () => {
  console.log(`API ready on http://localhost:${env.PORT}`);
});
