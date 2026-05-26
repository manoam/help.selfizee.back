/**
 * Seed minimal — 1 catégorie + 1 sous-cat + 1 tag + 1 post publié.
 * Pas de user : l'auth passe par Keycloak (réalm konitys / client helpselfizee).
 */
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const category = await prisma.category.upsert({
    where: { slug: "general" },
    update: {},
    create: {
      nom: "Général",
      slug: "general",
      description: "Catégorie par défaut",
    },
  });

  const subCategory = await prisma.subCategory.upsert({
    where: { categoryId_slug: { categoryId: category.id, slug: "demarrage" } },
    update: {},
    create: { nom: "Démarrage", slug: "demarrage", categoryId: category.id },
  });

  const tag = await prisma.tag.upsert({
    where: { slug: "demo" },
    update: {},
    create: { name: "demo", slug: "demo" },
  });

  const samplePost = await prisma.post.upsert({
    where: { slug: "bienvenue" },
    update: {},
    create: {
      titre: "Bienvenue dans la base de connaissance Selfizee",
      slug: "bienvenue",
      resume: "Premier article de démonstration.",
      contenu: {
        type: "doc",
        content: [
          {
            type: "paragraph",
            content: [
              { type: "text", text: "Ceci est un post de démonstration. Édite-le depuis l'admin." },
            ],
          },
        ],
      },
      contenuText: "Ceci est un post de démonstration. Édite-le depuis l'admin.",
      status: "PUBLISHED",
      publishedAt: new Date(),
      categories: {
        create: { categoryId: category.id, subCategoryId: subCategory.id },
      },
      tags: { create: { tagId: tag.id } },
    },
  });

  console.log(`✓ seeded: category=${category.slug}, post=${samplePost.slug}`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
