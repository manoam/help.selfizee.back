import "dotenv/config";

import express from "express";
import cors from "cors";

import { env } from "./config/env.js";
import { errorHandler } from "./middleware/error-handler.js";
import { authRouter } from "./routes/auth.js";
import { postsRouter } from "./routes/posts.js";
import { categoriesRouter } from "./routes/categories.js";
import { tagsRouter } from "./routes/tags.js";
import { attachmentsRouter } from "./routes/attachments.js";
import { gammesBornesRouter, modelBornesRouter } from "./routes/bornes.js";
import { typeProfilsRouter } from "./routes/type-profils.js";

const app = express();

app.use(express.json({ limit: "10mb" }));

// CORS — autorise les origines listées dans CORS_ORIGINS (CSV).
// On utilise une fonction callback pour logguer les rejets, ce qui aide à
// debugger les soucis de whitelist en prod (slash final, schéma, etc.).
const allowedOrigins = new Set(env.CORS_ORIGINS);
console.log(`[cors] allowed origins: ${[...allowedOrigins].join(", ") || "(none)"}`);
app.use(
  cors({
    origin: (origin, callback) => {
      // Requêtes sans Origin (curl, server-to-server) -> autorisées.
      if (!origin) return callback(null, true);
      if (allowedOrigins.has(origin)) return callback(null, true);
      console.warn(`[cors] rejected origin: ${origin}`);
      return callback(null, false);
    },
    credentials: true,
  }),
);

app.get("/health", (_req, res) => {
  res.json({ status: "ok", env: env.NODE_ENV });
});

app.use("/auth", authRouter);
app.use("/posts", postsRouter);
app.use("/categories", categoriesRouter);
app.use("/tags", tagsRouter);
app.use("/attachments", attachmentsRouter);
app.use("/gammes-bornes", gammesBornesRouter);
app.use("/model-bornes", modelBornesRouter);
app.use("/type-profils", typeProfilsRouter);

app.use(errorHandler);

app.listen(env.PORT, () => {
  console.log(`API ready on http://localhost:${env.PORT}`);
});
