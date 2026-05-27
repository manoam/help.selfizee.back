-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "descriptionProbleme" TEXT,
ADD COLUMN     "introCallCenter" TEXT,
ADD COLUMN     "introClient" TEXT,
ADD COLUMN     "introInterne" TEXT,
ADD COLUMN     "isFavourite" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "noticeCallCenter" TEXT,
ADD COLUMN     "noticeClient" TEXT,
ADD COLUMN     "ordre" INTEGER,
ADD COLUMN     "problemeCallCenter" TEXT,
ADD COLUMN     "problemeClient" TEXT,
ADD COLUMN     "problemeInterne" TEXT,
ADD COLUMN     "question" TEXT;

-- AlterTable
ALTER TABLE "PostAttachment" ADD COLUMN     "description" TEXT;

-- CreateTable
CREATE TABLE "GammeBorne" (
    "id" SERIAL NOT NULL,
    "nom" VARCHAR(255) NOT NULL,
    "slug" TEXT NOT NULL,
    "legacyId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "GammeBorne_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ModelBorne" (
    "id" SERIAL NOT NULL,
    "nom" VARCHAR(255) NOT NULL,
    "version" VARCHAR(64),
    "legacyId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "gammeBorneId" INTEGER NOT NULL,

    CONSTRAINT "ModelBorne_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PostModelBorne" (
    "id" SERIAL NOT NULL,
    "postId" INTEGER NOT NULL,
    "gammeBorneId" INTEGER NOT NULL,
    "modelBorneId" INTEGER,

    CONSTRAINT "PostModelBorne_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TypeProfil" (
    "id" SERIAL NOT NULL,
    "nom" VARCHAR(255) NOT NULL,
    "slug" TEXT NOT NULL,
    "legacyId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TypeProfil_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PostTypeProfil" (
    "postId" INTEGER NOT NULL,
    "typeProfilId" INTEGER NOT NULL,

    CONSTRAINT "PostTypeProfil_pkey" PRIMARY KEY ("postId","typeProfilId")
);

-- CreateIndex
CREATE UNIQUE INDEX "GammeBorne_slug_key" ON "GammeBorne"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "GammeBorne_legacyId_key" ON "GammeBorne"("legacyId");

-- CreateIndex
CREATE UNIQUE INDEX "ModelBorne_legacyId_key" ON "ModelBorne"("legacyId");

-- CreateIndex
CREATE INDEX "ModelBorne_gammeBorneId_idx" ON "ModelBorne"("gammeBorneId");

-- CreateIndex
CREATE INDEX "PostModelBorne_postId_idx" ON "PostModelBorne"("postId");

-- CreateIndex
CREATE INDEX "PostModelBorne_gammeBorneId_idx" ON "PostModelBorne"("gammeBorneId");

-- CreateIndex
CREATE UNIQUE INDEX "TypeProfil_slug_key" ON "TypeProfil"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "TypeProfil_legacyId_key" ON "TypeProfil"("legacyId");

-- CreateIndex
CREATE INDEX "Post_isFavourite_idx" ON "Post"("isFavourite");

-- AddForeignKey
ALTER TABLE "ModelBorne" ADD CONSTRAINT "ModelBorne_gammeBorneId_fkey" FOREIGN KEY ("gammeBorneId") REFERENCES "GammeBorne"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostModelBorne" ADD CONSTRAINT "PostModelBorne_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostModelBorne" ADD CONSTRAINT "PostModelBorne_gammeBorneId_fkey" FOREIGN KEY ("gammeBorneId") REFERENCES "GammeBorne"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostModelBorne" ADD CONSTRAINT "PostModelBorne_modelBorneId_fkey" FOREIGN KEY ("modelBorneId") REFERENCES "ModelBorne"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostTypeProfil" ADD CONSTRAINT "PostTypeProfil_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostTypeProfil" ADD CONSTRAINT "PostTypeProfil_typeProfilId_fkey" FOREIGN KEY ("typeProfilId") REFERENCES "TypeProfil"("id") ON DELETE CASCADE ON UPDATE CASCADE;
