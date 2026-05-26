--
-- PostgreSQL database dump
--

\restrict mNB4P0r5WcLzEHWG9LhXgGykF4DwTlqkpjAh8NhvfggLyeO6aZdM1He0qlXZhac

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg12+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg12+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public."SubSubCategory" DROP CONSTRAINT IF EXISTS "SubSubCategory_subCategoryId_fkey";
ALTER TABLE IF EXISTS ONLY public."SubCategory" DROP CONSTRAINT IF EXISTS "SubCategory_categoryId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostTag" DROP CONSTRAINT IF EXISTS "PostTag_tagId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostTag" DROP CONSTRAINT IF EXISTS "PostTag_postId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostRelation" DROP CONSTRAINT IF EXISTS "PostRelation_toId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostRelation" DROP CONSTRAINT IF EXISTS "PostRelation_fromId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostCategory" DROP CONSTRAINT IF EXISTS "PostCategory_subSubCategoryId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostCategory" DROP CONSTRAINT IF EXISTS "PostCategory_subCategoryId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostCategory" DROP CONSTRAINT IF EXISTS "PostCategory_postId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostCategory" DROP CONSTRAINT IF EXISTS "PostCategory_categoryId_fkey";
ALTER TABLE IF EXISTS ONLY public."PostAttachment" DROP CONSTRAINT IF EXISTS "PostAttachment_postId_fkey";
DROP INDEX IF EXISTS public."Tag_slug_key";
DROP INDEX IF EXISTS public."Tag_legacyId_key";
DROP INDEX IF EXISTS public."SubSubCategory_subCategoryId_slug_key";
DROP INDEX IF EXISTS public."SubSubCategory_legacyId_key";
DROP INDEX IF EXISTS public."SubCategory_legacyId_key";
DROP INDEX IF EXISTS public."SubCategory_categoryId_slug_key";
DROP INDEX IF EXISTS public."Post_status_idx";
DROP INDEX IF EXISTS public."Post_slug_key";
DROP INDEX IF EXISTS public."Post_publishedAt_idx";
DROP INDEX IF EXISTS public."Post_legacyId_key";
DROP INDEX IF EXISTS public."Post_authorKcSub_idx";
DROP INDEX IF EXISTS public."PostCategory_postId_idx";
DROP INDEX IF EXISTS public."PostCategory_categoryId_idx";
DROP INDEX IF EXISTS public."PostAttachment_postId_idx";
DROP INDEX IF EXISTS public."PostAttachment_legacyId_key";
DROP INDEX IF EXISTS public."Category_slug_key";
DROP INDEX IF EXISTS public."Category_legacyId_key";
ALTER TABLE IF EXISTS ONLY public._prisma_migrations DROP CONSTRAINT IF EXISTS _prisma_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public."Tag" DROP CONSTRAINT IF EXISTS "Tag_pkey";
ALTER TABLE IF EXISTS ONLY public."SubSubCategory" DROP CONSTRAINT IF EXISTS "SubSubCategory_pkey";
ALTER TABLE IF EXISTS ONLY public."SubCategory" DROP CONSTRAINT IF EXISTS "SubCategory_pkey";
ALTER TABLE IF EXISTS ONLY public."Post" DROP CONSTRAINT IF EXISTS "Post_pkey";
ALTER TABLE IF EXISTS ONLY public."PostTag" DROP CONSTRAINT IF EXISTS "PostTag_pkey";
ALTER TABLE IF EXISTS ONLY public."PostRelation" DROP CONSTRAINT IF EXISTS "PostRelation_pkey";
ALTER TABLE IF EXISTS ONLY public."PostCategory" DROP CONSTRAINT IF EXISTS "PostCategory_pkey";
ALTER TABLE IF EXISTS ONLY public."PostAttachment" DROP CONSTRAINT IF EXISTS "PostAttachment_pkey";
ALTER TABLE IF EXISTS ONLY public."Category" DROP CONSTRAINT IF EXISTS "Category_pkey";
ALTER TABLE IF EXISTS public."Tag" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."SubSubCategory" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."SubCategory" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."PostCategory" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."PostAttachment" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."Post" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."Category" ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public._prisma_migrations;
DROP SEQUENCE IF EXISTS public."Tag_id_seq";
DROP TABLE IF EXISTS public."Tag";
DROP SEQUENCE IF EXISTS public."SubSubCategory_id_seq";
DROP TABLE IF EXISTS public."SubSubCategory";
DROP SEQUENCE IF EXISTS public."SubCategory_id_seq";
DROP TABLE IF EXISTS public."SubCategory";
DROP SEQUENCE IF EXISTS public."Post_id_seq";
DROP TABLE IF EXISTS public."PostTag";
DROP TABLE IF EXISTS public."PostRelation";
DROP SEQUENCE IF EXISTS public."PostCategory_id_seq";
DROP TABLE IF EXISTS public."PostCategory";
DROP SEQUENCE IF EXISTS public."PostAttachment_id_seq";
DROP TABLE IF EXISTS public."PostAttachment";
DROP TABLE IF EXISTS public."Post";
DROP SEQUENCE IF EXISTS public."Category_id_seq";
DROP TABLE IF EXISTS public."Category";
DROP TYPE IF EXISTS public."PostStatus";
DROP EXTENSION IF EXISTS vector;
DROP EXTENSION IF EXISTS unaccent;
DROP EXTENSION IF EXISTS pg_trgm;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


--
-- Name: PostStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PostStatus" AS ENUM (
    'DRAFT',
    'PUBLISHED',
    'ARCHIVED'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Category" (
    id integer NOT NULL,
    nom character varying(250) NOT NULL,
    slug text NOT NULL,
    description text,
    afficher boolean DEFAULT true NOT NULL,
    ordre integer DEFAULT 0 NOT NULL,
    "legacyId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Category_id_seq" OWNED BY public."Category".id;


--
-- Name: Post; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Post" (
    id integer NOT NULL,
    titre text NOT NULL,
    slug text NOT NULL,
    resume text,
    contenu jsonb NOT NULL,
    "contenuText" text,
    status public."PostStatus" DEFAULT 'DRAFT'::public."PostStatus" NOT NULL,
    "legacyId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "publishedAt" timestamp(3) without time zone,
    "authorKcSub" text,
    "authorName" text
);


--
-- Name: PostAttachment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PostAttachment" (
    id integer NOT NULL,
    "postId" integer NOT NULL,
    filename text NOT NULL,
    "originalName" text,
    "mimeType" text,
    "sizeBytes" integer,
    "storagePath" text NOT NULL,
    label text,
    "legacyId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: PostAttachment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PostAttachment_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: PostAttachment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PostAttachment_id_seq" OWNED BY public."PostAttachment".id;


--
-- Name: PostCategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PostCategory" (
    id integer NOT NULL,
    "postId" integer NOT NULL,
    "categoryId" integer NOT NULL,
    "subCategoryId" integer,
    "subSubCategoryId" integer
);


--
-- Name: PostCategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PostCategory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: PostCategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PostCategory_id_seq" OWNED BY public."PostCategory".id;


--
-- Name: PostRelation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PostRelation" (
    "fromId" integer NOT NULL,
    "toId" integer NOT NULL
);


--
-- Name: PostTag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PostTag" (
    "postId" integer NOT NULL,
    "tagId" integer NOT NULL
);


--
-- Name: Post_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Post_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Post_id_seq" OWNED BY public."Post".id;


--
-- Name: SubCategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SubCategory" (
    id integer NOT NULL,
    nom character varying(255) NOT NULL,
    slug text NOT NULL,
    ordre integer DEFAULT 0 NOT NULL,
    "legacyId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "categoryId" integer NOT NULL
);


--
-- Name: SubCategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."SubCategory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: SubCategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."SubCategory_id_seq" OWNED BY public."SubCategory".id;


--
-- Name: SubSubCategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SubSubCategory" (
    id integer NOT NULL,
    nom character varying(255) NOT NULL,
    slug text NOT NULL,
    ordre integer DEFAULT 0 NOT NULL,
    "legacyId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "subCategoryId" integer NOT NULL
);


--
-- Name: SubSubCategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."SubSubCategory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: SubSubCategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."SubSubCategory_id_seq" OWNED BY public."SubSubCategory".id;


--
-- Name: Tag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Tag" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug text NOT NULL,
    "legacyId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Tag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Tag_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Tag_id_seq" OWNED BY public."Tag".id;


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: Category id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Category" ALTER COLUMN id SET DEFAULT nextval('public."Category_id_seq"'::regclass);


--
-- Name: Post id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Post" ALTER COLUMN id SET DEFAULT nextval('public."Post_id_seq"'::regclass);


--
-- Name: PostAttachment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostAttachment" ALTER COLUMN id SET DEFAULT nextval('public."PostAttachment_id_seq"'::regclass);


--
-- Name: PostCategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostCategory" ALTER COLUMN id SET DEFAULT nextval('public."PostCategory_id_seq"'::regclass);


--
-- Name: SubCategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SubCategory" ALTER COLUMN id SET DEFAULT nextval('public."SubCategory_id_seq"'::regclass);


--
-- Name: SubSubCategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SubSubCategory" ALTER COLUMN id SET DEFAULT nextval('public."SubSubCategory_id_seq"'::regclass);


--
-- Name: Tag id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Tag" ALTER COLUMN id SET DEFAULT nextval('public."Tag_id_seq"'::regclass);


--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Category" (id, nom, slug, description, afficher, ordre, "legacyId", "createdAt", "updatedAt") FROM stdin;
1	Général	general	Catégorie par défaut	t	0	\N	2026-05-26 04:10:17.548	2026-05-26 04:10:17.548
2	Photobooth Spherik	photobooth-spherik	\N	t	2	12	2026-05-26 07:46:24.352	2026-05-26 07:57:01.412
3	Photobooth Classik	photobooth-classik	\N	t	1	13	2026-05-26 07:46:24.396	2026-05-26 07:57:01.478
4	Logiciel et personnalisation de l'animation	logiciel-et-personnalisation-de-l-animation	\N	f	0	14	2026-05-26 07:46:24.42	2026-05-26 07:57:01.502
5	Questions générales et conseils d'utilisation	questions-generales-et-conseils-d-utilisation	\N	f	0	15	2026-05-26 07:46:24.469	2026-05-26 07:57:01.533
6	Konitys	konitys	\N	f	0	16	2026-05-26 07:46:24.505	2026-05-26 07:57:01.558
7	Manuel Utilisateur	manuel-utilisateur	\N	f	0	17	2026-05-26 07:46:24.541	2026-05-26 07:57:01.633
8	Intervenant Externe	intervenant-externe	\N	f	0	18	2026-05-26 07:46:24.572	2026-05-26 07:57:01.657
9	Imprimante	imprimante	\N	f	0	19	2026-05-26 07:46:24.638	2026-05-26 07:57:01.688
10	Option spécifique	option-specifique	\N	f	0	20	2026-05-26 07:46:24.675	2026-05-26 07:57:01.713
11	Photobooth Prestige	photobooth-prestige	\N	t	3	21	2026-05-26 07:46:24.705	2026-05-26 07:57:01.744
12	Koncept/option	koncept-option	\N	t	4	22	2026-05-26 07:46:24.741	2026-05-26 07:57:01.812
\.


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Post" (id, titre, slug, resume, contenu, "contenuText", status, "legacyId", "createdAt", "updatedAt", "publishedAt", "authorKcSub", "authorName") FROM stdin;
1	Bienvenue dans la base de connaissance Selfizee	bienvenue	Premier article de démonstration.	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "Ceci est un post de démonstration. Édite-le depuis l'admin.", "type": "text"}]}]}	Ceci est un post de démonstration. Édite-le depuis l'admin.	PUBLISHED	\N	2026-05-26 04:10:17.761	2026-05-26 04:10:17.761	2026-05-26 04:10:17.759	\N	\N
2	✅ Allumer la lumière sur le photobooth Classik	allumer-la-lumiere-sur-le-photobooth-classik-7	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	7	2022-01-10 09:26:26	2026-05-26 07:57:09.119	2022-01-10 09:26:26	\N	\N
3	✅ Allumer ou régler l'intensité de la lumière sur le photobooth Spherik	allumer-ou-regler-l-intensite-de-la-lumiere-sur-le-photobooth-spherik-8	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	8	2022-01-10 09:27:15	2026-05-26 07:57:09.153	2022-01-10 09:27:15	\N	\N
4	Installation et paramétrage de Nextcloud	installation-et-parametrage-de-nextcloud-22	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "1 - Installation de l’application :  \\n \\nCliquer une fois sur l’installateur Nextcloud  \\n \\nAppuyer sur « Next » \\n \\nAppuyer sur « Next »  \\n \\nAppuyer sur « Install » \\n \\nIl faut patienter quelques instants \\n \\nAppuyer sur « oui » pour autoriser l’élévation de droit \\n \\nIl se peut que Nextcloud soit déjà en cours d’exécution sur la borne. L’installateur demande donc de forcer la fermeture de cette application. Il faut appuyer sur « Ok » pour accepter.  \\nUne autre fenêtre peut s’afficher pour la fermeture d’autre applications qui interagissent avec Nextcloud. Il faudra également valider par « Ok » \\n \\nCliquer sur Finish pour terminer l’installation \\n \\nCliquer sur Yes pour redémarrer la borne \\n\\n2 - Configuration Nextcloud  \\nPour configurer Nextcloud il faut avoir démarré une fois le logiciel Selfizee. Sans cela on ne peut pas paramétrer les dossiers à synchroniser \\n\\nUne fois installé, on retrouvera Nextcloud dans la barre des taches à côté de l’heure.  \\nIl est ici représenté par le rond vert.  \\nIl faut cliquer une fois sur l’icône pour rentrer dans le logicel Nextcloud \\n \\nAppuyer sur la flèche à droite du nom du compte connecté sur Nextcloud  \\n \\nPuis appuyer sur « Paramètres » \\n \\nPuis sur « Paramètres » situé en haut à doite de la fenêtre \\n \\nAppuyer sur « Modifier les fichiers exclus » \\nLe but est d’interdire la synchronisation de certains fichiers vers nos serveur pour éviter la saturation de celui-ci avec des fichiers qui ne nous seraient pas utiles \\n \\nAppuyer sur Ajouter  \\n \\nAjouter dans les exclusions les termes ci-dessous, il faut appuyer sur « Ajouter » pour chaque nouveau terme à exclure. Et valider cet ajout avec le bouton « OK » \\nAssets  \\nAssets/* \\nLocal \\nLocal/* \\nOriginal \\nOriginal/* \\n \\nDans le bas de la liste on retrouve les termes ajoutés aux exclusions. Il faut valider la liste par le bouton « OK » \\n \\nUne fois la modification des exclusions terminée, il faut appuyer sur l’identifiant du compte Nextcloud pour afficher le/les dossier(s) synchronisé(s) \\n \\nDans le cas de cette borne il y a déjà une synchronisation de dossier de configurée. Le dossier Events correspond au dossier utilisé par Socialbooth et le TojoBooth que l’on retrouve sur les bornes Carmila \\nCliquer sur Ajouter une « synchronisation de dossier » \\n \\n Voici le chemin qui peut être copié-collé c:\\\\programdata\\\\konitys\\\\Selfizee\\\\Events\\\\ \\n \\nUne fois le chemin renseigné, appuyer sur « Suivant » \\n \\nCliquer sur le dossier Nextcloud puis cliquer sur « Suivant »  \\n \\nCliquer sur ajouter la synchronisation  \\n \\nNous avons maintenant 2 dossiers de synchronisés par Nextcloud \\nLa configuration de Nextcloud est terminée.  \\nUn redémarrage de la borne permettra de finaliser la configuration de Nextcloud et de vérifier que c’est bien l’application Selfizee qui démarre avec la borne ", "type": "text"}]}]}	1 - Installation de l&rsquo;application : Cliquer une fois sur l&rsquo;installateur Nextcloud Appuyer sur &laquo; Next &raquo; Appuyer sur &laquo; Next &raquo; Appuyer sur &laquo; Install &raquo; Il faut patienter quelques instants Appuyer sur &laquo; oui &raquo; pour autoriser l&rsquo;&eacute;l&eacute;vation de droit Il se peut que Nextcloud soit d&eacute;j&agrave; en cours d&rsquo;ex&eacute;cution sur la borne. L&rsquo;installateur demande donc de forcer la fermeture de cette application. Il faut appuyer sur &laquo; Ok &raquo; pour accepter. Une autre fen&ecirc;tre peut s&rsquo;afficher pour la fermeture d&rsquo;autre applications qui interagissent avec Nextcloud. Il faudra &eacute;galement valider par &laquo; Ok &raquo; Cliquer sur Finish pour terminer l&rsquo;installation Cliquer sur Yes pour red&eacute;marrer la borne 2 - Configuration Nextcloud Pour configurer Nextcloud il faut avoir d&eacute;marr&eacute; une fois le logiciel Selfizee. Sans cela on ne peut pas param&eacute;trer les dossiers &agrave; synchroniser Une fois install&eacute;, on retrouvera Nextcloud dans la barre des taches &agrave; c&ocirc;t&eacute; de l&rsquo;heure. Il est ici repr&eacute;sent&eacute; par le rond vert. Il faut cliquer une fois sur l&rsquo;ic&ocirc;ne pour rentrer dans le logicel Nextcloud Appuyer sur la fl&egrave;che &agrave; droite du nom du compte connect&eacute; sur Nextcloud Puis appuyer sur &laquo; Param&egrave;tres &raquo; Puis sur &laquo; Param&egrave;tres &raquo; situ&eacute; en haut &agrave; doite de la fen&ecirc;tre Appuyer sur &laquo; Modifier les fichiers exclus &raquo; Le but est d&rsquo;interdire la synchronisation de certains fichiers vers nos serveur pour &eacute;viter la saturation de celui-ci avec des fichiers qui ne nous seraient pas utiles Appuyer sur Ajouter Ajouter dans les exclusions les termes ci-dessous, il faut appuyer sur &laquo; Ajouter &raquo; pour chaque nouveau terme &agrave; exclure. Et valider cet ajout avec le bouton &laquo; OK &raquo; Assets Assets/* Local Local/* Original Original/* Dans le bas de la liste on retrouve les termes ajout&eacute;s aux exclusions. Il faut valider la liste par le bouton &laquo; OK &raquo; Une fois la modification des exclusions termin&eacute;e, il faut appuyer sur l&rsquo;identifiant du compte Nextcloud pour afficher le/les dossier(s) synchronis&eacute;(s) Dans le cas de cette borne il y a d&eacute;j&agrave; une synchronisation de dossier de configur&eacute;e. Le dossier Events correspond au dossier utilis&eacute; par Socialbooth et le TojoBooth que l&rsquo;on retrouve sur les bornes Carmila Cliquer sur Ajouter une &laquo; synchronisation de dossier &raquo; Voici le chemin qui peut &ecirc;tre copi&eacute;-coll&eacute; c:\\programdata\\konitys\\Selfizee\\Events\\ Une fois le chemin renseign&eacute;, appuyer sur &laquo; Suivant &raquo; Cliquer sur le dossier Nextcloud puis cliquer sur &laquo; Suivant &raquo; Cliquer sur ajouter la synchronisation Nous avons maintenant 2 dossiers de synchronis&eacute;s par Nextcloud La configuration de Nextcloud est termin&eacute;e. Un red&eacute;marrage de la borne permettra de finaliser la configuration de Nextcloud et de v&eacute;rifier que c&rsquo;est bien l&rsquo;application Selfizee qui d&eacute;marre avec la borne	PUBLISHED	22	2022-01-18 14:35:48	2026-05-26 07:57:09.203	2022-01-18 14:35:48	\N	\N
5	Télécharger un événement	telecharger-un-evenement-24	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la Borne.\\nSélectionnez 2 secondes l'angle en haut à gauche de l'écran ou appuyer la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe !\\"<>':;/? à l'aide du clavier tactile.\\n\\nAppuyez sur l'icone \\"TELECHARGER UN EVENEMENT\\".\\n\\nAppuyez sur le premier X pour rentrer le code de l'événement, à l'aide du clavier tactile.\\nLe code est fourni lors de la configuration de l'événement, vous pouvez le retrouver dans le Back Office.\\n\\n\\nAppuyez sur \\"LANCER IMMEDIATEMENT L'EVENEMENT\\" pour démmarrer directement la prise de photo pour votre événement.\\nAppuyez sur \\"REVENIR A LA LISTE DES EVENEMENTS\\" pour retourner à la liste des configurations disponible.\\nAppuyez sur \\"TELECHARGER UN NOUVEL EVENEMENT\\" pour retourner à l'image précédente et à nouveau rentrer le code d'un nouvel événement.\\n\\nSi le téléchargement n'a pas fonctionné ,vous devez consulter la fiche connexion wifi si vous n'avez pas connecté la borne sur Internet.\\nSi la borne est bien connecté et que ça ne fonctionne toujours pas aller voir la fiche télécharger un événement manuellement.", "type": "text"}]}]}	Allez sur l'&eacute;cran de la Borne. S&eacute;lectionnez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe !"<>':;/? &agrave; l'aide du clavier tactile. Appuyez sur l'icone "TELECHARGER UN EVENEMENT". Appuyez sur le premier X pour rentrer le code de l'&eacute;v&eacute;nement, &agrave; l'aide du clavier tactile. Le code est fourni lors de la configuration de l'&eacute;v&eacute;nement, vous pouvez le retrouver dans le Back Office. Appuyez sur "LANCER IMMEDIATEMENT L'EVENEMENT" pour d&eacute;mmarrer directement la prise de photo pour votre &eacute;v&eacute;nement. Appuyez sur "REVENIR A LA LISTE DES EVENEMENTS" pour retourner &agrave; la liste des configurations disponible. Appuyez sur "TELECHARGER UN NOUVEL EVENEMENT" pour retourner &agrave; l'image pr&eacute;c&eacute;dente et &agrave; nouveau rentrer le code d'un nouvel &eacute;v&eacute;nement. Si le t&eacute;l&eacute;chargement n'a pas fonctionn&eacute; ,vous devez consulter la fiche connexion wifi si vous n'avez pas connect&eacute; la borne sur Internet. Si la borne est bien connect&eacute; et que &ccedil;a ne fonctionne toujours pas aller voir la fiche t&eacute;l&eacute;charger un &eacute;v&eacute;nement manuellement.	PUBLISHED	24	2022-01-20 16:40:08	2026-05-26 07:57:09.268	2022-01-20 16:40:08	\N	\N
6	Importer manuellement un événement	importer-manuellement-un-evenement-27	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\n\\nSélectionner votre événement.\\n\\nSélectionnez \\"Configuration\\" puis \\"Télécharger le fichier d'installation manuel\\".\\nUne fois téléchargé, vous pouvez transférer le fichier ZIP sur votre clef USB ou Disque Dur Externe.\\nRécupérer la clef et l'insérer dans la borne.\\n\\nSi vous utilisé Teamviewer fair le transfert de fichier.\\nAllez sur Fichiers & Suppléments.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "\\nSéléctionnez Ouvrir le transfert de fichier.\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Séléctionnez le dossier ZIP puis Envoyer, une fois fini Fermer.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Sinon connéctez votre clef USB ou disque dur externe.\\nAller sur l'écran de la borne.\\nSélectionnez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe !\\"<>':;/? à l'aide du clavier tactile.\\n\\nAppuyez sur l'icone \\"TELECHARGER UN EVENEMENT\\"\\n\\nAppuyez sur l'icone \\"IMPORT MANUEL\\"\\n\\nSélectionnez le fichier ZIP sur la clef USB, le Disque Dur Externe ou sur le bureau aprés transfert par Teamviewer.\\nAppuyer sur \\"LANCER IMMEDIATEMENT L'EVENEMENT\\" pour démarrer directement la prise photo pour votre événement.\\nAppuyer sur \\"REVENIR A LA LISTE DES EVENEMENTS\\" pour retourner à la liste des configurations disponible.\\nAppuyer sur \\"TELECHARGER UN NOUVEL EVENEMENT\\" pour retourner à l'image précédente et à nouveau rentrer le code d'un nouvel événement ou faire un nouvel import manuel.\\n", "type": "text"}]}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr S&eacute;lectionner votre &eacute;v&eacute;nement. S&eacute;lectionnez "Configuration" puis "T&eacute;l&eacute;charger le fichier d'installation manuel". Une fois t&eacute;l&eacute;charg&eacute;, vous pouvez transf&eacute;rer le fichier ZIP sur votre clef USB ou Disque Dur Externe. R&eacute;cup&eacute;rer la clef et l'ins&eacute;rer dans la borne. Si vous utilis&eacute; Teamviewer fair le transfert de fichier. Allez sur Fichiers & Suppl&eacute;ments. S&eacute;l&eacute;ctionnez Ouvrir le transfert de fichier. S&eacute;l&eacute;ctionnez le dossier ZIP puis Envoyer, une fois fini Fermer. Sinon conn&eacute;ctez votre clef USB ou disque dur externe. Aller sur l'&eacute;cran de la borne. S&eacute;lectionnez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe !"<>':;/? &agrave; l'aide du clavier tactile. Appuyez sur l'icone "TELECHARGER UN EVENEMENT" Appuyez sur l'icone "IMPORT MANUEL" S&eacute;lectionnez le fichier ZIP sur la clef USB, le Disque Dur Externe ou sur le bureau apr&eacute;s transfert par Teamviewer. Appuyer sur "LANCER IMMEDIATEMENT L'EVENEMENT" pour d&eacute;marrer directement la prise photo pour votre &eacute;v&eacute;nement. Appuyer sur "REVENIR A LA LISTE DES EVENEMENTS" pour retourner &agrave; la liste des configurations disponible. Appuyer sur "TELECHARGER UN NOUVEL EVENEMENT" pour retourner &agrave; l'image pr&eacute;c&eacute;dente et &agrave; nouveau rentrer le code d'un nouvel &eacute;v&eacute;nement ou faire un nouvel import manuel.	PUBLISHED	27	2022-01-25 15:15:30	2026-05-26 07:57:09.298	2022-01-25 15:15:30	\N	\N
7	Modifier la taille de la police dans l'application "" borne ""	modifier-la-taille-de-la-police-dans-l-application-borne-28	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icône en bas à droite.\\n\\nAppuyez sur l'icône \\"APPLICATION\\".\\nAppuyez le signe \\"+\\" ou sur le signe \\"-\\" selon la taille de la police voulu.\\n\\nAppuyez sur l'icône en haut a gauche.\\n\\nAppuyez sur l'icône en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'ic&ocirc;ne en bas &agrave; droite. Appuyez sur l'ic&ocirc;ne "APPLICATION". Appuyez le signe "+" ou sur le signe "-" selon la taille de la police voulu. Appuyez sur l'ic&ocirc;ne en haut a gauche. Appuyez sur l'ic&ocirc;ne en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	28	2022-01-25 19:31:29	2026-05-26 07:57:09.333	2022-01-25 19:31:29	\N	\N
86	✅ Connecter électriquement et correctement le photobooth	connecter-electriquement-et-correctement-le-photobooth-152	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	152	2022-05-04 08:29:48	2026-05-26 07:57:11.995	2022-05-04 08:29:48	\N	\N
87	Manuel utilisateur imprimante Spherik	manuel-utilisateur-imprimante-spherik-153	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	153	2022-05-04 09:44:52	2026-05-26 07:57:12.021	2022-05-04 09:44:52	\N	\N
88	Manuel utilisateur imprimante Classik	manuel-utilisateur-imprimante-classik-155	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	155	2022-05-04 09:55:20	2026-05-26 07:57:12.05	2022-05-04 09:55:20	\N	\N
8	Modifier la durée du flash dans l'application "" borne ""	modifier-la-duree-du-flash-dans-l-application-borne-30	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icone en bas à droite.\\n\\nAppuyez sur l'icone \\"APPLICATION\\".\\nAppuyez le signe \\"+\\" ou sur le signe \\"-\\" selon la durée du flash voulu.\\n\\nAppuyez sur l'icone en haut a gauche.\\n\\nAppuyez sur l'icone en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'icone en bas &agrave; droite. Appuyez sur l'icone "APPLICATION". Appuyez le signe "+" ou sur le signe "-" selon la dur&eacute;e du flash voulu. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	30	2022-01-26 11:42:07	2026-05-26 07:57:09.389	2022-01-26 11:42:07	\N	\N
9	Modifier la durée entre le flash et la prise de photo dans l'application "" borne ""	modifier-la-duree-entre-le-flash-et-la-prise-de-photo-dans-l-application-borne-31	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icône en bas à droite.\\n\\nAppuyez sur l'icône \\"APPLICATION\\".\\nAppuyez le signe \\"+\\" ou sur le signe \\"-\\" selon la durée entre le flash et la prise de photo voulu.\\n\\nAppuyez sur l'icône en haut a gauche.\\n\\nAppuyez sur l'icône en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'ic&ocirc;ne en bas &agrave; droite. Appuyez sur l'ic&ocirc;ne "APPLICATION". Appuyez le signe "+" ou sur le signe "-" selon la dur&eacute;e entre le flash et la prise de photo voulu. Appuyez sur l'ic&ocirc;ne en haut a gauche. Appuyez sur l'ic&ocirc;ne en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	31	2022-01-26 17:24:34	2026-05-26 07:57:09.418	2022-01-26 17:24:34	\N	\N
10	Modifier le mot de passe administrateur dans l'application "" borne ""	modifier-le-mot-de-passe-administrateur-dans-l-application-borne-32	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icone en bas à droite.\\n\\nAppuyez sur l'icone \\"APPLICATION\\".\\nAppuyez sur l'icone \\"...\\" .\\n\\nAppuyez sur nouveau mot de passe pour afficher le clavier tactile", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Mettez le nouveau mot de passe et appuyez sur \\"ok\\"", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "\\nAppuyez sur l'icone en haut a gauche.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "\\nAppuyez sur l'icone en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'icone en bas &agrave; droite. Appuyez sur l'icone "APPLICATION". Appuyez sur l'icone "..." . Appuyez sur nouveau mot de passe pour afficher le clavier tactile Mettez le nouveau mot de passe et appuyez sur "ok" Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	32	2022-01-26 17:41:15	2026-05-26 07:57:09.444	2022-01-26 17:41:15	\N	\N
11	Modifier la langue dans l'application "" borne ""	modifier-la-langue-dans-l-application-borne-33	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icône en bas à droite.\\n\\nAppuyez sur l'icône \\"APPLICATION\\".\\nAppuyez \\"FRANCAIS\\".\\n\\nAppuyer sur la langue voulu : English, Français, Italiano, Portugues ,Espanol\\n\\nAppuyez sur l'icône en haut a gauche.\\n\\nAppuyez sur l'icône en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'ic&ocirc;ne en bas &agrave; droite. Appuyez sur l'ic&ocirc;ne "APPLICATION". Appuyez "FRANCAIS". Appuyer sur la langue voulu : English, Fran&ccedil;ais, Italiano, Portugues ,Espanol Appuyez sur l'ic&ocirc;ne en haut a gauche. Appuyez sur l'ic&ocirc;ne en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	33	2022-01-26 19:13:53	2026-05-26 07:57:09.473	2022-01-26 19:13:53	\N	\N
35	La publication automatique Facebook ne fonctionne pas ?	la-publication-automatique-facebook-ne-fonctionne-pas-77	\N	{"type": "doc", "content": [{"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph"}]}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "La publication automatique Facebook ne fonctionne pas ? ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Les photos remontent t-elles sur le backoffice ?", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Non -> il faut vérifier la synchronisation Nextcloud ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "https://1drv.ms/w/s!AgsDMn3gmvVRgiAa-DHqhKs9toMw?e=KTHYuB et/ou https://selfizee-my.sharepoint.com/:w:/g/personal/l_coignet_konitys_fr/ESBnm4_pWXZGph8UaHWm2qsB1Lv5Ti4_uWNeKGi5HzjyHg?e=fyFRmj", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Le compte konitys Guyon est-il administrateur de votre page ?  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Non -> il faut ajouter ce compte comme administrateur, sans cela nous outils ne sont pas autorisés à publier sur la page voulue ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "https://www.facebook.com/help/187316341316631 ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "L’option de publication a-t-elle était activée sur le backoffice ?  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Non ->  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Se connecter sur le back office et entrer dans la configuration de l’événement", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Puis appuyer sur configurer :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Puis cliquer sur l’onglet Envoi ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Descendre en bas de la page et vérifier que l’option « Publier automatiquement sur une page FaceBook » est activée ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}]}	La publication automatique Facebook ne fonctionne pas ? Les photos remontent t-elles sur le backoffice ? Non -> il faut v&eacute;rifier la synchronisation Nextcloud https://1drv.ms/w/s!AgsDMn3gmvVRgiAa-DHqhKs9toMw?e=KTHYuB et/ou https://selfizee-my.sharepoint.com/:w:/g/personal/l_coignet_konitys_fr/ESBnm4_pWXZGph8UaHWm2qsB1Lv5Ti4_uWNeKGi5HzjyHg?e=fyFRmj Le compte konitys Guyon est-il administrateur de votre page ? Non -> il faut ajouter ce compte comme administrateur, sans cela nous outils ne sont pas autoris&eacute;s &agrave; publier sur la page voulue https://www.facebook.com/help/187316341316631 L&rsquo;option de publication a-t-elle &eacute;tait activ&eacute;e sur le backoffice ? Non -> Se connecter sur le back office et entrer dans la configuration de l&rsquo;&eacute;v&eacute;nement Puis appuyer sur configurer : Puis cliquer sur l&rsquo;onglet Envoi Descendre en bas de la page et v&eacute;rifier que l&rsquo;option &laquo; Publier automatiquement sur une page FaceBook &raquo; est activ&eacute;e	PUBLISHED	77	2022-02-22 14:52:43	2026-05-26 07:57:10.252	2022-02-22 14:52:43	\N	\N
36	Mosaique	mosaique-78	\N	{"type": "doc", "content": [{"type": "heading", "attrs": {"level": 4}, "content": [{"text": "1 - Logiciel photo", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Aprés l'instalation du logiciel photo mettre en place l'événement.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Allez sur l'écran de la Borne.", "type": "text"}, {"type": "hardBreak"}, {"text": "Sélectionnez 2 secondes l'angle en haut à gauche de l'écran ou appuyer la touche F2 de votre clavier.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Vous allez arriver sur l'espace administrateur.", "type": "text"}, {"type": "hardBreak"}, {"text": "Appuyez sur la touche \\"&123\\"", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Saisissez le mot de passe !\\"<>':;/? à l'aide du clavier tactile.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Appuyez sur l'icone \\"TELECHARGER UN EVENEMENT\\".", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Appuyez sur le premier X pour rentrer le code de l'événement, à l'aide du clavier tactile.", "type": "text"}, {"type": "hardBreak"}, {"text": "Le code est fourni lors de la configuration de l'événement, vous pouvez le retrouver dans le Back Office.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Appuyez sur \\"LANCER IMMEDIATEMENT L'EVENEMENT\\" pour démmarrer directement la prise de photo pour votre événement.", "type": "text"}, {"type": "hardBreak"}, {"text": "Appuyez sur \\"REVENIR A LA LISTE DES EVENEMENTS\\" pour retourner à la liste des configurations disponible.", "type": "text"}, {"type": "hardBreak"}, {"text": "Appuyez sur \\"TELECHARGER UN NOUVEL EVENEMENT\\" pour retourner à l'image précédente et à nouveau rentrer le code d'un nouvel événement.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Si le téléchargement n'a pas fonctionné ,vous devez consulter la fiche connexion wifi si vous n'avez pas connecté la borne sur Internet.", "type": "text"}, {"type": "hardBreak"}, {"text": "Si la borne est bien connecté et que ça ne fonctionne toujours pas aller voir la fiche télécharger un événement manuellement.", "type": "text"}]}, {"type": "heading", "attrs": {"level": 4}, "content": [{"text": "2 - Reaconvert", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Par la suite installer le logiciel reaconvert et le paramétrer.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Allez sur edit images puis sur add action et séléctionnez enfin Crop pour définir le recadrage.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Modifiez Crop from center (Recadrer à partir du centre) en 1100 / 1100", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Sélectionnez add action puis Save action to files as...", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Enregistrez dans un fichier préalablement créé au nom de l'événement.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Dans la section Saving Option", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "1 - Sélectionnez Saving options (Options d’enregistrement)", "type": "text"}, {"type": "hardBreak"}, {"text": "2 - indiquer le chemin ou nous avons enregistré la précédente modification ici, le fichier crop (dossier suivant)", "type": "text"}, {"type": "hardBreak"}, {"text": "3 - Sélectionnez Save as... (enregistrer sous)", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Sélectionnez menu, watch folders (dossiers de surveillance) puis Settings... (Paramètres).", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Sélectionnez le PLUS.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Dans la section General.", "type": "text"}, {"type": "hardBreak"}, {"text": "1 - Dans Folder (dossier) indiquer le chemin des photos original enregistré par le logiciel de prise d'image ATTENTION PAS DE COPIER COLLER BIEN ECRIRE LE TEXTE", "type": "text"}, {"type": "hardBreak"}, {"text": "2 - Décocher Read subfolders (Lire les sous-dossiers)", "type": "text"}, {"type": "hardBreak"}, {"text": "3 - Mettre le chemin du fichier .cfg précédemment enregistré sur le bureau ATTENTION PAS DE COPIER COLLER BIEN ECRIRE LE TEXTE", "type": "text"}, {"type": "hardBreak"}, {"text": "4 - Mettre le chemin du fichier .act précédemment enregistré sur le bureau ATTENTION PAS DE COPIER COLLER BIEN ECRIRE LE TEXTE", "type": "text"}, {"type": "hardBreak"}, {"text": "5 - Sélectionnez OK pour valider et enregistrer les modifications.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Sélectionnez OK pour valider et enregistrer les modifications.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Sélectionnez menu, watch folders (dossiers de surveillance) puis ON. Pour activer les modifications.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Le paramétrage de Reaconverter est terminé.   ", "type": "text"}, {"type": "hardBreak"}, {"text": "ATTENTION Lors de tests, si on supprime des fichiers images pendant le traitement Reaconverter présentent des disfonctionnements. Il faudra donc repasser la surveillance du répertoire en OFF puis ON.", "type": "text"}]}, {"type": "heading", "attrs": {"level": 4}, "content": [{"text": "3 - BYO", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Par la suite installer le logiciel BYO et le paramétrer.", "type": "text"}, {"type": "hardBreak"}, {"text": "Sélectionnez la touche F1 de votre clavier pour accéder au paramétrage.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Dans la section General.", "type": "text"}, {"type": "hardBreak"}, {"text": "1 - Indiquer le nom de votre événement", "type": "text"}, {"type": "hardBreak"}, {"text": "2 - Chemin de fichier ou sera enregistré la mosaic", "type": "text"}, {"type": "hardBreak"}, {"text": "3 - Décocher les réseaus sociaux", "type": "text"}, {"type": "hardBreak"}, {"text": "4 - Chemin de fichier où se trouvent les photos modifiées par le logiciel reaconverter", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Dans la section Display.", "type": "text"}, {"type": "hardBreak"}, {"text": "1 - Sélectionnez l'image de lancement de la mosaic sur l'écran secondaire", "type": "text"}, {"type": "hardBreak"}, {"text": "2 - Cochez l'option mosaic", "type": "text"}, {"type": "hardBreak"}, {"text": "3 - Sélectionnez l'image qui sera reconstituée par la mosaic sur l'écran secondaire", "type": "text"}, {"type": "hardBreak"}, {"text": "4 - Choix de la taille d’une tuile en fonction du tableau ci-dessous.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "5 - Paramétrage de l’opacité des photos qui vont reconstituer la mosaic", "type": "text"}, {"type": "hardBreak"}, {"text": "6 - Cocher l’option Custom pour l’écran d’instruction. C’est l’écran qui sera affiché tant qu’aucune photo n’aura été intégrée à la mosaïque", "type": "text"}, {"type": "hardBreak"}, {"text": "7 - Sélectionner l’image d’instruction. Par défaut, nous utilisons le Logo Selfizee au format 1920*1080.", "type": "text"}, {"type": "hardBreak"}, {"text": "8 - Sélectionner pour sauvegarder et lancer la mosaic", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Une fois le tout installé. ", "type": "text"}, {"type": "hardBreak"}, {"text": "Redémarrer l'ordinateur pour vérifier que les trois logiciels sont démarrer correctement démarrer.", "type": "text"}, {"type": "hardBreak"}, {"text": "Utiliser les touches Alt et Tabulation pour sélectionner la fenêtre BYO.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Utiliser les touches Windows Maj et la flèche directionnel droite pour basculer le logiciel BYO sur l'écran numéro deux. Attention, il doit être en résolution 1920 / 1080.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Retourner sur le logiciel de prise de photo et en prendre une.", "type": "text"}, {"type": "hardBreak"}, {"text": "Vérifier que cette image est bien affichée sur le logiciel BYO.", "type": "text"}, {"type": "hardBreak"}, {"text": "ATTENTION si la première image sur BYO s'ouvre dans l'angle en haut à gauche vous devez relancer le logiciel pour cela, aller sur le logiciel BYO.", "type": "text"}, {"type": "hardBreak"}, {"text": "Sélectionnez la touche F1 de votre clavier pour accéder au paramétrage.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Sélectionnez Quit.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Relancer le logiciel BYO et réitérer la manipulation.", "type": "text"}]}, {"type": "paragraph", "content": [{"type": "hardBreak"}, {"type": "hardBreak"}]}]}	1 - Logiciel photo Apr&eacute;s l'instalation du logiciel photo mettre en place l'&eacute;v&eacute;nement. Allez sur l'&eacute;cran de la Borne. S&eacute;lectionnez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe !"<>':;/? &agrave; l'aide du clavier tactile. Appuyez sur l'icone "TELECHARGER UN EVENEMENT". Appuyez sur le premier X pour rentrer le code de l'&eacute;v&eacute;nement, &agrave; l'aide du clavier tactile. Le code est fourni lors de la configuration de l'&eacute;v&eacute;nement, vous pouvez le retrouver dans le Back Office. Appuyez sur "LANCER IMMEDIATEMENT L'EVENEMENT" pour d&eacute;mmarrer directement la prise de photo pour votre &eacute;v&eacute;nement. Appuyez sur "REVENIR A LA LISTE DES EVENEMENTS" pour retourner &agrave; la liste des configurations disponible. Appuyez sur "TELECHARGER UN NOUVEL EVENEMENT" pour retourner &agrave; l'image pr&eacute;c&eacute;dente et &agrave; nouveau rentrer le code d'un nouvel &eacute;v&eacute;nement. Si le t&eacute;l&eacute;chargement n'a pas fonctionn&eacute; ,vous devez consulter la fiche connexion wifi si vous n'avez pas connect&eacute; la borne sur Internet. Si la borne est bien connect&eacute; et que &ccedil;a ne fonctionne toujours pas aller voir la fiche t&eacute;l&eacute;charger un &eacute;v&eacute;nement manuellement. 2 - Reaconvert Par la suite installer le logiciel reaconvert et le param&eacute;trer. Allez sur edit images puis sur add action et s&eacute;l&eacute;ctionnez enfin Crop pour d&eacute;finir le recadrage. Modifiez Crop from center (Recadrer &agrave; partir du centre) en 1100 / 1100 S&eacute;lectionnez add action puis Save action to files as... Enregistrez dans un fichier pr&eacute;alablement cr&eacute;&eacute; au nom de l'&eacute;v&eacute;nement. Dans la section Saving Option 1 - S&eacute;lectionnez Saving options (Options d&rsquo;enregistrement) 2 - indiquer le chemin ou nous avons enregistr&eacute; la pr&eacute;c&eacute;dente modification ici, le fichier crop (dossier suivant) 3 - S&eacute;lectionnez Save as... (enregistrer sous) S&eacute;lectionnez menu, watch folders (dossiers de surveillance) puis Settings... (Param&egrave;tres). S&eacute;lectionnez le PLUS. Dans la section General. 1 - Dans Folder (dossier) indiquer le chemin des photos original enregistr&eacute; par le logiciel de prise d'image ATTENTION PAS DE COPIER COLLER BIEN ECRIRE LE TEXTE 2 - D&eacute;cocher Read subfolders (Lire les sous-dossiers) 3 - Mettre le chemin du fichier .cfg pr&eacute;c&eacute;demment enregistr&eacute; sur le bureau ATTENTION PAS DE COPIER COLLER BIEN ECRIRE LE TEXTE 4 - Mettre le chemin du fichier .act pr&eacute;c&eacute;demment enregistr&eacute; sur le bureau ATTENTION PAS DE COPIER COLLER BIEN ECRIRE LE TEXTE 5 - S&eacute;lectionnez OK pour valider et enregistrer les modifications. S&eacute;lectionnez OK pour valider et enregistrer les modifications. S&eacute;lectionnez menu, watch folders (dossiers de surveillance) puis ON. Pour activer les modifications. Le param&eacute;trage de Reaconverter est termin&eacute;. ATTENTION Lors de tests, si on supprime des fichiers images pendant le traitement Reaconverter pr&eacute;sentent des disfonctionnements. Il faudra donc repasser la surveillance du r&eacute;pertoire en OFF puis ON. 3 - BYO Par la suite installer le logiciel BYO et le param&eacute;trer. S&eacute;lectionnez la touche F1 de votre clavier pour acc&eacute;der au param&eacute;trage. Dans la section General. 1 - Indiquer le nom de votre &eacute;v&eacute;nement 2 - Chemin de fichier ou sera enregistr&eacute; la mosaic 3 - D&eacute;cocher les r&eacute;seaus sociaux 4 - Chemin de fichier o&ugrave; se trouvent les photos modifi&eacute;es par le logiciel reaconverter Dans la section Display. 1 - S&eacute;lectionnez l'image de lancement de la mosaic sur l'&eacute;cran secondaire 2 - Cochez l'option mosaic 3 - S&eacute;lectionnez l'image qui sera reconstitu&eacute;e par la mosaic sur l'&eacute;cran secondaire 4 - Choix de la taille d&rsquo;une tuile en fonction du tableau ci-dessous. 5 - Param&eacute;trage de l&rsquo;opacit&eacute; des photos qui vont reconstituer la mosaic 6 - Cocher l&rsquo;option Custom pour l&rsquo;&eacute;cran d&rsquo;instruction. C&rsquo;est l&rsquo;&eacute;cran qui sera affich&eacute; tant qu&rsquo;aucune photo n&rsquo;aura &eacute;t&eacute; int&eacute;gr&eacute;e &agrave; la mosa&iuml;que 7 - S&eacute;lectionner l&rsquo;image d&rsquo;instruction. Par d&eacute;faut, nous utilisons le Logo Selfizee au format 1920*1080. 8 - S&eacute;lectionner pour sauvegarder et lancer la mosaic Une fois le tout install&eacute;. Red&eacute;marrer l'ordinateur pour v&eacute;rifier que les trois logiciels sont d&eacute;marrer correctement d&eacute;marrer. Utiliser les touches Alt et Tabulation pour s&eacute;lectionner la fen&ecirc;tre BYO. Utiliser les touches Windows Maj et la fl&egrave;che directionnel droite pour basculer le logiciel BYO sur l'&eacute;cran num&eacute;ro deux. Attention, il doit &ecirc;tre en r&eacute;solution 1920 / 1080 . Retourner sur le logiciel de prise de photo et en prendre une. V&eacute;rifier que cette image est bien affich&eacute;e sur le logiciel BYO . ATTENTION si la premi&egrave;re image sur BYO s'ouvre dans l'angle en haut &agrave; gauche vous devez relancer le logiciel pour cela, aller sur le logiciel BYO . S&eacute;lectionnez la touche F1 de votre clavier pour acc&eacute;der au param&eacute;trage. S&eacute;lectionnez Quit . Relancer le logiciel BYO et r&eacute;it&eacute;rer la manipulation.	PUBLISHED	78	2022-02-23 10:27:47	2026-05-26 07:57:10.323	2022-02-23 10:27:47	\N	\N
37	Installer Office	installer-office-79	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	79	2022-02-23 22:05:11	2026-05-26 07:57:10.366	\N	\N	\N
12	Modifier l'effet miroir dans l'application "" borne ""	modifier-l-effet-miroir-dans-l-application-borne-34	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icone en bas à droite.\\n\\nAppuyez sur l'icone \\"IMAGE\\".\\nAppuyez sur l'icone \\"REGLAGE DE L'IMAGE\\".\\nAppuyez sur l'icone \\"REGLAGE DE L'IMAGE\\".\\n\\nAppuyez sur le bouton Miroir pour activer ou désactiver l'effet.\\n\\nAppuyez sur l'icone en haut a gauche.\\n\\nAppuyez sur l'icone en haut a gauche.\\n\\nAppuyez sur l'icone en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'icone en bas &agrave; droite. Appuyez sur l'icone "IMAGE". Appuyez sur l'icone "REGLAGE DE L'IMAGE". Appuyez sur l'icone "REGLAGE DE L'IMAGE". Appuyez sur le bouton Miroir pour activer ou d&eacute;sactiver l'effet. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	34	2022-01-27 14:25:01	2026-05-26 07:57:09.498	2022-01-27 14:25:01	\N	\N
13	Modifier la caméra dans l'application "" borne ""	modifier-la-camera-dans-l-application-borne-35	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icône en bas à droite.\\n\\nAppuyez sur l'icône \\"PERIPHERIQUES\\".\\n\\nAppuyez sur le bouton \\"...\\"\\n\\nVous pouvez appuyer sur la caméra voulue.\\n\\nAppuyez sur l'icône en haut a gauche.\\n\\nAppuyez sur l'icône en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Allez sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'ic&ocirc;ne en bas &agrave; droite. Appuyez sur l'ic&ocirc;ne "PERIPHERIQUES". Appuyez sur le bouton "..." Vous pouvez appuyer sur la cam&eacute;ra voulue. Appuyez sur l'ic&ocirc;ne en haut a gauche. Appuyez sur l'ic&ocirc;ne en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	35	2022-01-27 14:56:57	2026-05-26 07:57:09.527	2022-01-27 14:56:57	\N	\N
14	Modifier l'imprimante dans l'application "" borne ""	modifier-l-imprimante-dans-l-application-borne-36	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icône en bas à droite.\\n\\nAppuyez sur l'icône \\"PERIPHERIQUES\\".\\n\\nAppuyez sur le bouton \\"...\\"\\n\\nVous pouvez appuyer sur l'imprimante voulue.\\n\\nAppuyez sur l'icône en haut a gauche.\\n\\nAppuyez sur l'icône en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Allez sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'ic&ocirc;ne en bas &agrave; droite. Appuyez sur l'ic&ocirc;ne "PERIPHERIQUES". Appuyez sur le bouton "..." Vous pouvez appuyer sur l'imprimante voulue. Appuyez sur l'ic&ocirc;ne en haut a gauche. Appuyez sur l'ic&ocirc;ne en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	36	2022-01-27 14:57:23	2026-05-26 07:57:09.554	2022-01-27 14:57:23	\N	\N
15	Modifier les réglages de la caméra dans l'application "" borne ""	modifier-les-reglages-de-la-camera-dans-l-application-borne-37	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icône en bas à droite.\\n\\nAppuyez sur l'icône \\"PERIPHERIQUES\\".\\n\\nAppuyez sur le bouton \\"REGLAGES\\"\\n\\nVous êtes sur les réglages de la caméra.\\nAppyuez sur \\"VIDEO\\" ou \\"PHOTO\\" pour pouvoir modifier.\\nBien faire attention en cas de modifications faites.\\nAppuyez sur l'icône \\"SAUVEGARDER\\".\\nAppuyez sur l'icône en haut a gauche pour quitter.\\n\\n\\nAppuyez sur l'icône en haut a gauche.\\n\\nAppuyez sur l'icône en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Allez sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'ic&ocirc;ne en bas &agrave; droite. Appuyez sur l'ic&ocirc;ne "PERIPHERIQUES". Appuyez sur le bouton "REGLAGES" Vous &ecirc;tes sur les r&eacute;glages de la cam&eacute;ra. Appyuez sur "VIDEO" ou "PHOTO" pour pouvoir modifier. Bien faire attention en cas de modifications faites. Appuyez sur l'ic&ocirc;ne "SAUVEGARDER". Appuyez sur l'ic&ocirc;ne en haut a gauche pour quitter. Appuyez sur l'ic&ocirc;ne en haut a gauche. Appuyez sur l'ic&ocirc;ne en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	37	2022-01-27 14:58:04	2026-05-26 07:57:09.584	2022-01-27 14:58:04	\N	\N
38	Installer Teamviewer	installer-teamviewer-80	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Se connecter sur le site https://www.teamviewer.com/fr/telecharger/windows/\\nTélécharger la version 64 bits\\n\\nInstaller le logiciel.\\nDemander le compte et le mot de passe a un responsable\\n\\n", "type": "text"}]}]}	Se connecter sur le site https://www.teamviewer.com/fr/telecharger/windows/ T&eacute;l&eacute;charger la version 64 bits Installer le logiciel. Demander le compte et le mot de passe a un responsable	PUBLISHED	80	2022-02-23 22:05:25	2026-05-26 07:57:10.403	2022-02-23 22:05:25	\N	\N
89	✅ Connexion à Internet ou partage de connexion	connexion-a-internet-ou-partage-de-connexion-164	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	164	2022-05-04 10:56:47	2026-05-26 07:57:12.077	2022-05-04 10:56:47	\N	\N
100	✅ L'écran de la tablette ne s'allume pas / écran noir éteint	l-ecran-de-la-tablette-ne-s-allume-pas-ecran-noir-eteint-202	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	202	2022-05-19 15:58:59	2026-05-26 07:57:12.382	2022-05-19 15:58:59	\N	\N
16	Modifier les réglages de l'imprimante dans l'application "" borne ""	modifier-les-reglages-de-l-imprimante-dans-l-application-borne-38	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icône en bas à droite.\\n\\nAppuyez sur l'icône \\"PERIPHERIQUES\\".\\n\\nAppuyez sur le bouton \\"REGLAGES\\"\\n\\nVous êtes sur les réglages de l'imprimante.\\nBien faire attention en cas de modifications faites.\\nAppuyez sur l'icône \\"SAUVEGARDER\\".\\nAppuyez sur l'icône en haut a gauche pour quitter.\\n\\nAppuyez sur l'icône en haut a gauche.\\n\\nAppuyez sur l'icône en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Allez sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'ic&ocirc;ne en bas &agrave; droite. Appuyez sur l'ic&ocirc;ne "PERIPHERIQUES". Appuyez sur le bouton "REGLAGES" Vous &ecirc;tes sur les r&eacute;glages de l'imprimante. Bien faire attention en cas de modifications faites. Appuyez sur l'ic&ocirc;ne "SAUVEGARDER". Appuyez sur l'ic&ocirc;ne en haut a gauche pour quitter. Appuyez sur l'ic&ocirc;ne en haut a gauche. Appuyez sur l'ic&ocirc;ne en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	38	2022-01-27 14:58:28	2026-05-26 07:57:09.609	2022-01-27 14:58:28	\N	\N
17	Modifier le microphone dans l'application "" borne ""	modifier-le-microphone-dans-l-application-borne-39	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icone en bas à droite.\\n\\nAppuyez sur l'icone \\"PERIPHERIQUES\\".\\n\\nAppuyez sur le bouton \\"...\\"\\n\\nVous pouvez appuyer sur le microphone voulu.\\n\\nAppuyez sur l'icone en haut a gauche.\\n\\nAppuyez sur l'icone en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Allez sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'icone en bas &agrave; droite. Appuyez sur l'icone "PERIPHERIQUES". Appuyez sur le bouton "..." Vous pouvez appuyer sur le microphone voulu. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	39	2022-01-27 16:00:47	2026-05-26 07:57:09.653	2022-01-27 16:00:47	\N	\N
18	Modifier les réglages du microphone dans l'application "" borne ""	modifier-les-reglages-du-microphone-dans-l-application-borne-40	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icone en bas à droite.\\n\\nAppuyez sur l'icone \\"PERIPHERIQUES\\".\\n\\nAppuyez sur le bouton \\"REGLAGES\\"\\n\\nVous êtes sur les réglages du microphone.\\nBien faire attention en cas de modifications faites.\\nAppuyez sur l'icone en haut a gauche pour quitter.\\n\\nAppuyez sur l'icone en haut a gauche.\\n\\nAppuyez sur l'icone en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Allez sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'icone en bas &agrave; droite. Appuyez sur l'icone "PERIPHERIQUES". Appuyez sur le bouton "REGLAGES" Vous &ecirc;tes sur les r&eacute;glages du microphone. Bien faire attention en cas de modifications faites. Appuyez sur l'icone en haut a gauche pour quitter. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	40	2022-01-27 16:01:15	2026-05-26 07:57:09.684	2022-01-27 16:01:15	\N	\N
19	✅ Regarder combien de tirages photos il reste	regarder-combien-de-tirages-photos-il-reste-46	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	46	2022-02-03 13:22:32	2026-05-26 07:57:09.707	2022-02-03 13:22:32	\N	\N
20	Comment zoomer et dézoomer la photo?	comment-zoomer-et-dezoomer-la-photo-49	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Allez sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icone en bas à droite.\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Appuyez sur l'icone \\"PERIPHERIQUES\\".", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": " ", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Appuyez sur le bouton \\"REGLAGES\\"", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous êtes sur les réglages de la caméra.\\nAppyuez sur \\"VIDEO\\" ou \\"PHOTO\\" pour pouvoir modifier.\\nModifiez la valeur du zoom, mais attention plus vous zoomez plus la netteté de votre photo baissera en qualité.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Bien faire attention en cas de modifications faites.\\nAppuyez sur l'icone \\"SAUVEGARDER\\".\\nAppuyez sur l'icone en haut a gauche pour quitter.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "\\n\\nAppuyez sur l'icone en haut a gauche.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "\\nAppuyez sur l'icone en haut a gauche pour revenir sur votre événement.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}]}	Allez sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'icone en bas &agrave; droite. Appuyez sur l'icone "PERIPHERIQUES". Appuyez sur le bouton "REGLAGES" Vous &ecirc;tes sur les r&eacute;glages de la cam&eacute;ra. Appyuez sur "VIDEO" ou "PHOTO" pour pouvoir modifier. Modifiez la valeur du zoom, mais attention plus vous zoomez plus la nettet&eacute; de votre photo baissera en qualit&eacute;. Bien faire attention en cas de modifications faites. Appuyez sur l'icone "SAUVEGARDER". Appuyez sur l'icone en haut a gauche pour quitter. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	49	2022-02-03 15:07:51	2026-05-26 07:57:09.739	2022-02-03 15:07:51	\N	\N
21	✅ L’appareil photo prend des photos floues	l-appareil-photo-prend-des-photos-floues-52	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	52	2022-02-03 17:00:16	2026-05-26 07:57:09.762	2022-02-03 17:00:16	\N	\N
54	Ce n’est pas le format de cadre ou image que j’ai demandé.	ce-n-est-pas-le-format-de-cadre-ou-image-que-j-ai-demande-105	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	105	2022-03-07 11:08:23	2026-05-26 07:57:10.987	\N	\N	\N
55	Il manque des bobines.	il-manque-des-bobines-106	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	106	2022-03-07 11:08:59	2026-05-26 07:57:11.014	\N	\N	\N
22	Créer un événement dans l'application "" booth ""	creer-un-evenement-dans-l-application-booth-54	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\nEntrez votre nom d'utilisateur et votre mot de passe puis séléctionner l'icone \\"Se Connecter\\"\\n\\n\\nSélectionnez l'icône \\"Ajouter un événement.\\"\\n\\nRenseignez le nom de l'événement, la date, le lieu ainsi que l'E-mail ou la réception du lien de la galerie.\\nSélectionnez l'icône \\"ENREGISTRER\\".\\n\\nSélectionnez \\"CONFIGURATION\\" puis l'icône \\" CONFIGURER\\".\\n\\nVous aurez plusieurs méthode de création, la première en séléctionnant \\"AFFICHER LE CATALOGUE\\"\\n\\nSélectionnez le cadre voulut.\\n\\nSuivez le guide qui vous expliquera comment ajouter une image ou changer le texte.\\nPour finir, sélectionnez l'icône \\"ENREGISTRER\\" et enfin sélectionner \\"ENREGISTRER ET RESTER\\" pour créer un nouveau cadre ou \\"ENREGISTRER ET RETOURNER A L'EVENEMENT\\" pour finaliser le paramétrage de celui-ci.\\n\\nLa deuxième solution en séléctionnant \\"AFFICHER LES MODELES VIERGES\\"\\n\\nSélectionnez le cadre voulut.\\n\\nSuivez le guide qui vous expliquera comment ajouter une image ou changer le texte.\\nPour finir, sélectionnez l'icône \\"ENREGISTRER\\" et enfin sélectionner \\"ENREGISTRER ET RESTER\\" pour créer un nouveau cadre ou \\"ENREGISTRER ET RETOURNER A L'EVENEMENT\\" pour finaliser le paramétrage de celui-ci.\\n\\nSélectionnez l'icône \\"CONTINUER ET PASSER A LA CONFIGURATION\\".\\n\\nPour configurer un événement sélectionner les fiche de configuration dans l'application \\"\\" booth \\"\\".", "type": "text"}]}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr Entrez votre nom d'utilisateur et votre mot de passe puis s&eacute;l&eacute;ctionner l'icone "Se Connecter" S&eacute;lectionnez l'ic&ocirc;ne "Ajouter un &eacute;v&eacute;nement. " Renseignez le nom de l'&eacute;v&eacute;nement, la date, le lieu ainsi que l'E-mail ou la r&eacute;ception du lien de la galerie. S&eacute;lectionnez l'ic&ocirc;ne " ENREGISTRER ". S&eacute;lectionnez " CONFIGURATION " puis l'ic&ocirc;ne " CONFIGURER". Vous aurez plusieurs m&eacute;thode de cr&eacute;ation, la premi&egrave;re en s&eacute;l&eacute;ctionnant "AFFICHER LE CATALOGUE" S&eacute;lectionnez le cadre voulut. Suivez le guide qui vous expliquera comment ajouter une image ou changer le texte. Pour finir, s&eacute;lectionnez l'ic&ocirc;ne "ENREGISTRER" et enfin s&eacute;lectionner "ENREGISTRER ET RESTER" pour cr&eacute;er un nouveau cadre ou "ENREGISTRER ET RETOURNER A L'EVENEMENT" pour finaliser le param&eacute;trage de celui-ci. La deuxi&egrave;me solution en s&eacute;l&eacute;ctionnant "AFFICHER LES MODELES VIERGES" S&eacute;lectionnez le cadre voulut. Suivez le guide qui vous expliquera comment ajouter une image ou changer le texte. Pour finir, s&eacute;lectionnez l'ic&ocirc;ne "ENREGISTRER" et enfin s&eacute;lectionner "ENREGISTRER ET RESTER" pour cr&eacute;er un nouveau cadre ou "ENREGISTRER ET RETOURNER A L'EVENEMENT" pour finaliser le param&eacute;trage de celui-ci. S&eacute;lectionnez l'ic&ocirc;ne "CONTINUER ET PASSER A LA CONFIGURATION". Pour configurer un &eacute;v&eacute;nement s&eacute;lectionner les fiche de configuration dans l'application "" booth "".	PUBLISHED	54	2022-02-04 10:16:10	2026-05-26 07:57:09.795	2022-02-04 10:16:10	\N	\N
23	Configurer la page souvenir dans l'application "" booth ""	configurer-la-page-souvenir-dans-l-application-booth-56	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\nEntrez votre nom d'utilisateur et votre mot de passe puis séléctionner l'icone \\"Se Connecter\\"\\n\\n\\nSélectionnez l'icône le nom de votre événement.\\n\\nAu niveau de la page souvenir sélectionnez l'icône \\"PERSONNALISER\\".\\n\\n1: Glissez déposez une image ou cliquer pour télécharger une image pour modifier la bannière de la page souvenir.\\n2: Glissez déposez une image ou cliquer pour télécharger une image pour modifier la bandeau bas de la page souvenir.\\n3: Cochez ou décochez pour activer un lien vers un site exterieur, pour afficher votre page souvenir.\\n4: Ecrivez l'adresse du lien vers un site exterieur, pour afficher votre page souvenir.\\n5: Sélectionnez et choisissez la couleur de fond de votre page souvenir.\\n6: Sélectionnez et choisissez la couleur du bouton de téléchargement de votre page souvenir.\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "1: Ecrivez une déscription Facebook pour l'affichage de votre page souvenir lors d'un partage.\\n2: Ecrivez une déscription Twitter pour l'affichage de votre page souvenir lors d'un partage.\\n3: Cochez ou décochez pour activer le module vidéo publicitaire pour l'afficher sur votre page souvenir.\\n4: Ecrivez l'adresse du lien de votre vidéo publicitaire pour l'afficher sur votre page souvenir.\\n5: Cochez ou décochez pour activer le module de saisie de formulaire avant le téléchargement des photo pour récupérer les informations utilisateur.\\n6: Texte d'accueil au formulaire.\\n7: Sélectionnez l'icône \\"ENREGISTRER\\" pour valider vos changements", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr Entrez votre nom d'utilisateur et votre mot de passe puis s&eacute;l&eacute;ctionner l'icone "Se Connecter" S&eacute;lectionnez l'ic&ocirc;ne le nom de votre &eacute;v&eacute;nement. Au niveau de la page souvenir s &eacute;lectionnez l'ic&ocirc;ne "PERSONNALISER". 1: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour modifier la banni&egrave;re de la page souvenir. 2: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour modifier la bandeau bas de la page souvenir. 3: Cochez ou d&eacute;cochez pour activer un lien vers un site exterieur, pour afficher votre page souvenir. 4: Ecrivez l'adresse du lien vers un site exterieur, pour afficher votre page souvenir. 5: S&eacute;lectionnez et choisissez la couleur de fond de votre page souvenir. 6: S&eacute;lectionnez et choisissez la couleur du bouton de t&eacute;l&eacute;chargement de votre page souvenir. 1: Ecrivez une d&eacute;scription Facebook pour l'affichage de votre page souvenir lors d'un partage. 2: Ecrivez une d&eacute;scription Twitter pour l'affichage de votre page souvenir lors d'un partage. 3: Cochez ou d&eacute;cochez pour activer le module vid&eacute;o publicitaire pour l'afficher sur votre page souvenir. 4: Ecrivez l'adresse du lien de votre vid&eacute;o publicitaire pour l'afficher sur votre page souvenir. 5: Cochez ou d&eacute;cochez pour activer le module de saisie de formulaire avant le t&eacute;l&eacute;chargement des photo pour r&eacute;cup&eacute;rer les informations utilisateur. 6: Texte d'accueil au formulaire. 7: S&eacute;lectionnez l'ic&ocirc;ne "ENREGISTRER" pour valider vos changements	PUBLISHED	56	2022-02-04 14:58:35	2026-05-26 07:57:09.82	2022-02-04 14:58:35	\N	\N
24	Modifier l'écran de navigation dans l'application "" booth ""	modifier-l-ecran-de-navigation-dans-l-application-booth-57	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\nEntrez votre nom d'utilisateur et votre mot de passe puis séléctionner l'icone \\"Se Connecter\\"\\n\\n\\nSélectionnez l'icône le nom de votre événement.\\n\\nAu niveau du paramétrage borne sélectionnez l'icône \\"CONFIGURER\\".\\n\\nSélectionnez \\"ECRANS\\".\\n\\nIl existe de posivbilitées nous allons vous montrer les deux.\\n1.Sélectionnez \\"CHOISIR DANS LE CATALOGUE\\". pour modifier la mise en page avec des modèles existant.\\n\\nSélectionnez une sous-catégorie ici \\"ANNIVERSAIRES ET EVENEMENTS PRIVES\\".\\n\\n\\nSélectionnez une sous-catégorie ici \\"ANNIVERSAIRES ET EVENEMENTS PRIVES\\".\\n\\n\\n2.Sélectionnez \\"IMPORTER MES PROPRES FICHIERS\\" pour modifier la mise en page avec des modèles existant.\\n\\n1: Glissez déposez une image ou cliquer pour télécharger une image pour modifier la page d'accueil.\\n2: Activez ou désactivez l'effet couleur d'oppacité en choisissant le pourcentage d'opacité, ainsi que la couleur et l'animation du bouton.\\n\\n\\n1: Glissez déposez une image ou cliquer pour télécharger une image pour modifier la page de prise de photo.\\n2: Activez ou désactivez l'effet couleur d'oppacité en choisissant le pourcentage d'opacité, ainsi que la couleur.\\n3: Glissez déposez une image ou cliquer pour télécharger une image pour modifier la page de visualisation de photo.\\n4: Activez ou désactivez l'effet couleur d'oppacité en choisissant le pourcentage d'opacité, ainsi que la couleur.\\n5: Cochez ou décochez pour activer le module de saisie de formulaire avant le téléchargement des photo pour récupérer les informations utilisateur.\\n\\n1: Glissez déposez une image ou cliquer pour télécharger une image pour modifier la page filtre.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "2: Activez ou désactivez l'effet couleur d'oppacité en choisissant le pourcentage d'opacité, ainsi que la couleur.\\n3: Glissez déposez une image ou cliquer pour télécharger une image pour modifier la page de remerciement.\\n4: Activez ou désactivez l'effet couleur d'oppacité en choisissant le pourcentage d'opacité, ainsi que la couleur.\\n5: Sélectionnez l'icône \\"ENREGISTRER\\" pour valider vos changements", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr Entrez votre nom d'utilisateur et votre mot de passe puis s&eacute;l&eacute;ctionner l'icone "Se Connecter" S&eacute;lectionnez l'ic&ocirc;ne le nom de votre &eacute;v&eacute;nement. Au niveau du param&eacute;trage borne s &eacute;lectionnez l'ic&ocirc;ne "CONFIGURER". S &eacute;lectionnez "ECRANS". Il existe de posivbilit&eacute;es nous allons vous montrer les deux. 1.S &eacute;lectionnez "CHOISIR DANS LE CATALOGUE". pour modifier la mise en page avec des mod&egrave;les existant. S &eacute;lectionnez une sous-cat&eacute;gorie ici "ANNIVERSAIRES ET EVENEMENTS PRIVES". S &eacute;lectionnez une sous-cat&eacute;gorie ici "ANNIVERSAIRES ET EVENEMENTS PRIVES". 2.S &eacute;lectionnez "IMPORTER MES PROPRES FICHIERS" pour modifier la mise en page avec des mod&egrave;les existant. 1: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour modifier la page d'accueil. 2: Activez ou d&eacute;sactivez l'effet couleur d'oppacit&eacute; en choisissant le pourcentage d'opacit&eacute;, ainsi que la couleur et l'animation du bouton. 1: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour modifier la page de prise de photo. 2: Activez ou d&eacute;sactivez l'effet couleur d'oppacit&eacute; en choisissant le pourcentage d'opacit&eacute;, ainsi que la couleur. 3: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour modifier la page de visualisation de photo. 4: Activez ou d&eacute;sactivez l'effet couleur d'oppacit&eacute; en choisissant le pourcentage d'opacit&eacute;, ainsi que la couleur. 5: Cochez ou d&eacute;cochez pour activer le module de saisie de formulaire avant le t&eacute;l&eacute;chargement des photo pour r&eacute;cup&eacute;rer les informations utilisateur. 1: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour modifier la page filtre. 2: Activez ou d&eacute;sactivez l'effet couleur d'oppacit&eacute; en choisissant le pourcentage d'opacit&eacute;, ainsi que la couleur. 3: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour modifier la page de remerciement. 4: Activez ou d&eacute;sactivez l'effet couleur d'oppacit&eacute; en choisissant le pourcentage d'opacit&eacute;, ainsi que la couleur. 5: S&eacute;lectionnez l'ic&ocirc;ne "ENREGISTRER" pour valider vos changements	PUBLISHED	57	2022-02-04 14:59:27	2026-05-26 07:57:09.851	2022-02-04 14:59:27	\N	\N
25	Configurer l'impression dans l'application "" booth ""	configurer-l-impression-dans-l-application-booth-58	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\nEntrez votre nom d'utilisateur et votre mot de passe puis séléctionner l'icone \\"Se Connecter\\"\\n\\n\\nSélectionnez l'icône le nom de votre événement.\\n\\nAu niveau du paramétrage borne sélectionnez l'icône \\"CONFIGURER\\".\\n\\nSélectionnez \\"IMPRESSION\\".\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "1: Activez ou désactivez pour autoriser limpression sur l'événemnt.\\n2: Activez ou désactivez le fait de pouvoir imprimer plusieur fois la même photo, indiquer le nombre de photo maximum.\\n3: Activez ou désactivez la limitation du nombre d'impression sur l'événement, indiquer le nombre de photo maximum.\\n4: Indiquez le nombre de seconde voulut avant la remise en place de l'écran principale de l'animation.\\n5: Indiquez le texte voulut à l'affichage lors de l'impression de la photo.\\n6: Sélectionnez l'icône \\"ENREGISTRER\\" pour valider vos changements", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr Entrez votre nom d'utilisateur et votre mot de passe puis s&eacute;l&eacute;ctionner l'icone "Se Connecter" S&eacute;lectionnez l'ic&ocirc;ne le nom de votre &eacute;v&eacute;nement. Au niveau du param&eacute;trage borne s &eacute;lectionnez l'ic&ocirc;ne "CONFIGURER". S &eacute;lectionnez "IMPRESSION". 1: Activez ou d&eacute;sactivez pour autoriser limpression sur l'&eacute;v&eacute;nemnt. 2: Activez ou d&eacute;sactivez le fait de pouvoir imprimer plusieur fois la m&ecirc;me photo, indiquer le nombre de photo maximum. 3: Activez ou d&eacute;sactivez la limitation du nombre d'impression sur l'&eacute;v&eacute;nement, indiquer le nombre de photo maximum. 4: Indiquez le nombre de seconde voulut avant la remise en place de l'&eacute;cran principale de l'animation. 5: Indiquez le texte voulut &agrave; l'affichage lors de l'impression de la photo. 6: S&eacute;lectionnez l'ic&ocirc;ne "ENREGISTRER" pour valider vos changements	PUBLISHED	58	2022-02-04 15:00:14	2026-05-26 07:57:09.877	2022-02-04 15:00:14	\N	\N
56	Il manque un câble pour brancher la Spherik.	il-manque-un-cable-pour-brancher-la-spherik-107	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	107	2022-03-07 11:12:43	2026-05-26 07:57:11.044	\N	\N	\N
57	Je n’ai pas le consommable.	je-n-ai-pas-le-consommable-109	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	109	2022-03-07 11:13:15	2026-05-26 07:57:11.069	\N	\N	\N
58	Je n’ai pas tout le matériel pour monter la borne. Il manque des éléments 	je-n-ai-pas-tout-le-materiel-pour-monter-la-borne-il-manque-des-elements-110	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	110	2022-03-07 11:13:36	2026-05-26 07:57:11.098	\N	\N	\N
59	L’installateur n’est pas arrivé.	l-installateur-n-est-pas-arrive-111	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	111	2022-03-07 11:13:54	2026-05-26 07:57:11.124	\N	\N	\N
60	Je n'ai pas de papier dans les cartons, 	je-n-ai-pas-de-papier-dans-les-cartons-112	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	112	2022-03-07 11:14:32	2026-05-26 07:57:11.153	\N	\N	\N
26	Configurer la collecte de données dans l'application "" booth ""	configurer-la-collecte-de-donnees-dans-l-application-booth-59	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\nEntrez votre nom d'utilisateur et votre mot de passe puis séléctionner l'icone \\"Se Connecter\\"\\n\\n\\nSélectionnez l'icône le nom de votre événement.\\n\\nAu niveau du paramétrage borne sélectionnez l'icône \\"CONFIGURER\\".\\n\\nSélectionnez \\"COLLECTE\\".\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Activez ou désactivez la prise de coordonnées.\\nSélectionnez Ajouter un champ.\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Sélectionnez le type de donnée voulus.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Activez ou désactivez l'obligation d'indiquer les inforlmation demandé lors de l'événement.\\nValidez en séléctionnant \\"AJOUTER\\".\\n\\nSélectionnez ajouter un champ pour ajouter une nouvelle donnée ou quittez en séléctionnant \\"ENREGISTRER\\".\\n", "type": "text"}]}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr Entrez votre nom d'utilisateur et votre mot de passe puis s&eacute;l&eacute;ctionner l'icone "Se Connecter" S&eacute;lectionnez l'ic&ocirc;ne le nom de votre &eacute;v&eacute;nement. Au niveau du param&eacute;trage borne s &eacute;lectionnez l'ic&ocirc;ne "CONFIGURER". S &eacute;lectionnez "COLLECTE". Activez ou d&eacute;sactivez la prise de coordonn&eacute;es. S&eacute;lectionnez Ajouter un champ. S&eacute;lectionnez le type de donn&eacute;e voulus. Activez ou d&eacute;sactivez l'obligation d'indiquer les inforlmation demand&eacute; lors de l'&eacute;v&eacute;nement. Validez en s&eacute;l&eacute;ctionnant "AJOUTER". S &eacute;lectionnez ajouter un champ pour ajouter une nouvelle donn&eacute;e ou quittez en s&eacute;l&eacute;ctionnant "ENREGISTRER".	PUBLISHED	59	2022-02-04 15:02:06	2026-05-26 07:57:09.906	2022-02-04 15:02:06	\N	\N
27	Configurer l'écran vert dans l'application "" booth ""	configurer-l-ecran-vert-dans-l-application-booth-60	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\nEntrez votre nom d'utilisateur et votre mot de passe puis séléctionner l'icone \\"Se Connecter\\"\\n\\n\\nSélectionnez l'icône le nom de votre événement.\\n\\nAu niveau du paramétrage borne sélectionnez l'icône \\"CONFIGURER\\".\\n\\nSélectionnez \\"IMPRESSION\\".\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "1: Activez ou désactivez l'incrustation fond vert.\\n2: Glissez déposez une image ou cliquer pour télécharger une image pour importer votre visuel de fond vert.\\n3: Sélectionnez l'icône \\"ENREGISTRER\\" pour valider vos changements", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr Entrez votre nom d'utilisateur et votre mot de passe puis s&eacute;l&eacute;ctionner l'icone "Se Connecter" S&eacute;lectionnez l'ic&ocirc;ne le nom de votre &eacute;v&eacute;nement. Au niveau du param&eacute;trage borne s &eacute;lectionnez l'ic&ocirc;ne "CONFIGURER". S &eacute;lectionnez "IMPRESSION". 1: Activez ou d&eacute;sactivez l'incrustation fond vert. 2: Glissez d&eacute;posez une image ou cliquer pour t&eacute;l&eacute;charger une image pour importer votre visuel de fond vert. 3: S&eacute;lectionnez l'ic&ocirc;ne "ENREGISTRER" pour valider vos changements	PUBLISHED	60	2022-02-04 15:02:48	2026-05-26 07:57:09.93	2022-02-04 15:02:48	\N	\N
28	✅ Configurer les réglages de l'appareil photo	configurer-les-reglages-de-l-appareil-photo-62	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	62	2022-02-16 10:15:29	2026-05-26 07:57:09.958	2022-02-16 10:15:29	\N	\N
29	✅ Installer le consommable dans l'imprimante DNP QW410	installer-le-consommable-dans-l-imprimante-dnp-qw410-65	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	65	2022-02-16 14:32:20	2026-05-26 07:57:09.984	2022-02-16 14:32:20	\N	\N
30	✅ Changer le consommable dans l'imprimante DNP DS620	changer-le-consommable-dans-l-imprimante-dnp-ds620-66	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	66	2022-02-16 14:32:47	2026-05-26 07:57:10.013	2022-02-16 14:32:47	\N	\N
31	✅ Problème avec l'imprimante DNP QW410	probleme-avec-l-imprimante-dnp-qw410-71	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	71	2022-02-18 10:12:38	2026-05-26 07:57:10.039	2022-02-18 10:12:38	\N	\N
32	✅ Problème avec l'imprimante DNP DS620	probleme-avec-l-imprimante-dnp-ds620-72	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Affichage d’erreur\\n\\nLe papier est coincé dans l’imprimante\\nÉliminez le bourrage.Rembobinez le papier sur la bobine de papier en tournant la bobine dans la direction opposée du chemin du papier (voir Fig. A), puis retirez délicatement le papier de l’imprimante en le tirant vers l’avant, en dehors de l’imprimante (voir Fig. B).\\nAppliquez une pression légère uniquement pour ne pas endommager les composants de l’imprimante.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Si la méthode ci-dessus ne permet pas d’éliminer le bourrage facilement, découpez la partie endommagée du bord du papier, retirez et placez le rouleau de papier sur le côté. (Fig. C) Retirez ensuite le papier restant dans le chemin d’alimentation. Si une partie du papier reste dans l’imprimante, accédez délicatement à l’imprimante et retirez le papier du chemin de papier en le tirant vers l’avant (la direction indiquée dans la Fig. D).", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Coupez la partie problématique, telle qu’une zone froissée ou partiellement imprimée, avec des ciseaux. Si des zones froissées ou partiellement imprimées sont toujours présentes, le papier pourrait se coincer de nouveau. De plus, si le papier n’est pas coupé uniformément, l’imprimante ne fonctionne pas correctement.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Le ruban est coincé dans l’imprimante\\nTirez sur le ruban.\\nCoupez le ruban.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Retirez le ruban qui se trouve dans l’imprimante avec précaution.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Réparez le ruban avec de l’adhésif ou une matière similaire.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Tournez le rouleau de réception jusqu’à ce que la partie réparée avec de l’adhésif ne soit plus visible.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Après avoir mis le commutateur ON/Standby de l’imprimante sur ON, placez de nouveau le papier. Une fois le mécanisme fermé, l’initialisation du papier s’effectuera (tout matériel imprimé quel qu’il soit sera éjecté en cas d’erreur). Tant que l’initialisation est en exécution, les erreurs ne peuvent pas être supprimées.", "type": "text"}]}]}	Affichage d&rsquo;erreur Le papier est coinc&eacute; dans l&rsquo;imprimante &Eacute;liminez le bourrage.Rembobinez le papier sur la bobine de papier en tournant la bobine dans la direction oppos&eacute;e du chemin du papier (voir Fig. A), puis retirez d&eacute;licatement le papier de l&rsquo;imprimante en le tirant vers l&rsquo;avant, en dehors de l&rsquo;imprimante (voir Fig. B). Appliquez une pression l&eacute;g&egrave;re uniquement pour ne pas endommager les composants de l&rsquo;imprimante. Si la m&eacute;thode ci-dessus ne permet pas d&rsquo;&eacute;liminer le bourrage facilement, d&eacute;coupez la partie endommag&eacute;e du bord du papier, retirez et placez le rouleau de papier sur le c&ocirc;t&eacute;. (Fig. C) Retirez ensuite le papier restant dans le chemin d&rsquo;alimentation. Si une partie du papier reste dans l&rsquo;imprimante, acc&eacute;dez d&eacute;licatement &agrave; l&rsquo;imprimante et retirez le papier du chemin de papier en le tirant vers l&rsquo;avant (la direction indiqu&eacute;e dans la Fig. D). Coupez la partie probl&eacute;matique, telle qu&rsquo;une zone froiss&eacute;e ou partiellement imprim&eacute;e, avec des ciseaux. Si des zones froiss&eacute;es ou partiellement imprim&eacute;es sont toujours pr&eacute;sentes, le papier pourrait se coincer de nouveau. De plus, si le papier n&rsquo;est pas coup&eacute; uniform&eacute;ment, l&rsquo;imprimante ne fonctionne pas correctement. Le ruban est coinc&eacute; dans l&rsquo;imprimante Tirez sur le ruban. Coupez le ruban. Retirez le ruban qui se trouve dans l&rsquo;imprimante avec pr&eacute;caution. R&eacute;parez le ruban avec de l&rsquo;adh&eacute;sif ou une mati&egrave;re similaire. Tournez le rouleau de r&eacute;ception jusqu&rsquo;&agrave; ce que la partie r&eacute;par&eacute;e avec de l&rsquo;adh&eacute;sif ne soit plus visible. Apr&egrave;s avoir mis le commutateur ON/Standby de l&rsquo;imprimante sur ON, placez de nouveau le papier. Une fois le m&eacute;canisme ferm&eacute;, l&rsquo;initialisation du papier s&rsquo;effectuera (tout mat&eacute;riel imprim&eacute; quel qu&rsquo;il soit sera &eacute;ject&eacute; en cas d&rsquo;erreur). Tant que l&rsquo;initialisation est en ex&eacute;cution, les erreurs ne peuvent pas &ecirc;tre supprim&eacute;es.	PUBLISHED	72	2022-02-18 10:12:41	2026-05-26 07:57:10.103	2022-02-18 10:12:41	\N	\N
33	Le message à l’écran est « Borne Hors Service » ? 	le-message-a-l-ecran-est-borne-hors-service-74	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Ce message apparait lorsqu’un des prérequis suivants n’est pas disponible au démarrage du logiciel : ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Caméra non configurée / non disponible ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Evènement non configuré / altéré ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Un message dans le coin inférieur droit donne généralement une indication sur la nature du dysfonctionnement. ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Message indicatif : ", "type": "text"}]}]}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si la nature du problème concerne l’appareil photo ou la caméra, se référer à la fiche « mon appareil ou caméra ne s’initialise pas »", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si la nature du problème concerne l’évènement vérifier les points suivants :  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Accéder à la page de réglages administrateur ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Vérifier si l’évènement est présent dans la liste de ceux disponibles ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si oui -> cliquer sur le bouton « LANCER ». ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si non -> Vérifier si l’évènement n’est pas présent dans la liste des évènements archivés. ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si l’évènement est présent dans la liste d’archivage, le désarchiver à l’aide du menu et le lancer depuis la liste. ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si l’évènement n’est plus présent ou marqué « invalide », le retélécharger en récupérant son code depuis le backoffice. ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Le lancer. ", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": " ", "type": "text"}]}]}	Ce message apparait lorsqu&rsquo;un des pr&eacute;requis suivants n&rsquo;est pas disponible au d&eacute;marrage du logiciel : Cam&eacute;ra non configur&eacute;e / non disponible Ev&egrave;nement non configur&eacute; / alt&eacute;r&eacute; Un message dans le coin inf&eacute;rieur droit donne g&eacute;n&eacute;ralement une indication sur la nature du dysfonctionnement. Message indicatif : Si la nature du probl&egrave;me concerne l&rsquo;appareil photo ou la cam&eacute;ra, se r&eacute;f&eacute;rer &agrave; la fiche &laquo; mon appareil ou cam&eacute;ra ne s&rsquo;initialise pas &raquo; Si la nature du probl&egrave;me concerne l&rsquo;&eacute;v&egrave;nement v&eacute;rifier les points suivants : Acc&eacute;der &agrave; la page de r&eacute;glages administrateur V&eacute;rifier si l&rsquo;&eacute;v&egrave;nement est pr&eacute;sent dans la liste de ceux disponibles Si oui -> cliquer sur le bouton &laquo; LANCER &raquo;. Si non -> V&eacute;rifier si l&rsquo;&eacute;v&egrave;nement n&rsquo;est pas pr&eacute;sent dans la liste des &eacute;v&egrave;nements archiv&eacute;s. Si l&rsquo;&eacute;v&egrave;nement est pr&eacute;sent dans la liste d&rsquo;archivage, le d&eacute;sarchiver &agrave; l&rsquo;aide du menu et le lancer depuis la liste. Si l&rsquo;&eacute;v&egrave;nement n&rsquo;est plus pr&eacute;sent ou marqu&eacute; &laquo; invalide &raquo;, le ret&eacute;l&eacute;charger en r&eacute;cup&eacute;rant son code depuis le backoffice. Le lancer.	PUBLISHED	74	2022-02-22 14:40:41	2026-05-26 07:57:10.157	2022-02-22 14:40:41	\N	\N
34	Les photos ne synchronisent pas ? Nextcloud ?	les-photos-ne-synchronisent-pas-nextcloud-75	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "Vérification de la connexion de Nextcloud  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Appuyer sur la touche Windows au clavier pour faire apparaitre la barre des taches :  ", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "En bas, à droite, à côté de l’heure, appuyer sur la flèche pour afficher les icones cachée", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Ici l’icone de nextcloud. En gris cela signifie que Nextcloud n’est pas connecté  ", "type": "text"}]}]}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Cliquer sur l’icône Nextcloud, nextcloud s’affiche en grand ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Cliquer sur la flèche à coté du numéro de la borne (c’est le compte nextcloud configuré sur la borne)  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Cliquer sur les 3 petits points", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Cliquer sur se connecter ", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Au moment de la rédaction de la procédure nous avons une erreur de certificat qui est à l’origine de cette absence de connexion.", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Il faut cocher la case devant « Faire confiance à ce certificat malgré tout » et cliquer sur ok en bas de la fenêtre ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Ce symbole vert signifie que les synchronisations sont ok pour Nextcloud  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "En réaffichant les icones cachées dans la barre des tâches, l’icône Nextcloud a changée ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si malgrés ce symbole Nextcloud vert, les photos ne remontent pas sur le backoffice il faut verifier d’autre paramêtres Nextcloud.  ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Vérification des paramêtres de synchronisation des dossiers ", "type": "text"}]}]}	V&eacute;rification de la connexion de Nextcloud Appuyer sur la touche Windows au clavier pour faire apparaitre la barre des taches : En bas, &agrave; droite, &agrave; c&ocirc;t&eacute; de l&rsquo;heure, appuyer sur la fl&egrave;che pour afficher les icones cach&eacute;e Ici l&rsquo;icone de nextcloud. En gris cela signifie que Nextcloud n&rsquo;est pas connect&eacute; Cliquer sur l&rsquo;ic&ocirc;ne Nextcloud, nextcloud s&rsquo;affiche en grand Cliquer sur la fl&egrave;che &agrave; cot&eacute; du num&eacute;ro de la borne (c&rsquo;est le compte nextcloud configur&eacute; sur la borne) Cliquer sur les 3 petits points Cliquer sur se connecter Au moment de la r&eacute;daction de la proc&eacute;dure nous avons une erreur de certificat qui est &agrave; l&rsquo;origine de cette absence de connexion. Il faut cocher la case devant &laquo; Faire confiance &agrave; ce certificat malgr&eacute; tout &raquo; et cliquer sur ok en bas de la fen&ecirc;tre Ce symbole vert signifie que les synchronisations sont ok pour Nextcloud En r&eacute;affichant les icones cach&eacute;es dans la barre des t&acirc;ches, l&rsquo;ic&ocirc;ne Nextcloud a chang&eacute;e Si malgr&eacute;s ce symbole Nextcloud vert, les photos ne remontent pas sur le backoffice il faut verifier d&rsquo;autre param&ecirc;tres Nextcloud. V&eacute;rification des param&ecirc;tres de synchronisation des dossiers	PUBLISHED	75	2022-02-22 14:49:01	2026-05-26 07:57:10.198	2022-02-22 14:49:01	\N	\N
61	Le compteur de photos restantes n’est pas bon ça ne m’indique pas le nombre que j’ai commandé 	le-compteur-de-photos-restantes-n-est-pas-bon-ca-ne-m-indique-pas-le-nombre-que--113	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	113	2022-03-07 11:14:49	2026-05-26 07:57:11.18	\N	\N	\N
39	Trello	trello-83	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "https://trello.com/invite/b/Ju9ZkxCQ/9b6d0f39cbfdc210278d0373cffd4211/animations-particuliers", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "https://trello.com/invite/b/Ju9ZkxCQ/9b6d0f39cbfdc210278d0373cffd4211/animations-particuliers", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "https://trello.com/invite/b/iCoOzPsV/749213144db6683b3db7f2219a753a46/bornes-vendues", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "https://trello.com/invite/b/jdFVZEYy/c170e629f6e1971210b6c33f96d74ae5/installateur-selfizee", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}]}	https://trello.com/invite/b/Ju9ZkxCQ/9b6d0f39cbfdc210278d0373cffd4211/animations-particuliers https://trello.com/invite/b/Ju9ZkxCQ/9b6d0f39cbfdc210278d0373cffd4211/animations-particuliers https://trello.com/invite/b/iCoOzPsV/749213144db6683b3db7f2219a753a46/bornes-vendues https://trello.com/invite/b/jdFVZEYy/c170e629f6e1971210b6c33f96d74ae5/installateur-selfizee	PUBLISHED	83	2022-02-23 22:09:01	2026-05-26 07:57:10.429	2022-02-23 22:09:01	\N	\N
40	adresse Serveur NAS	adresse-serveur-nas-84	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "adresse du Nas 192.168.1.13", "type": "text"}]}]}	adresse du Nas 192.168.1.13	PUBLISHED	84	2022-02-23 22:09:41	2026-05-26 07:57:10.549	2022-02-23 22:09:41	\N	\N
41	Comment je récupère les données à la fin de mon événement?	comment-je-recupere-les-donnees-a-la-fin-de-mon-evenement-85	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vous devez vous connécter sur https://booth.selfizee.fr\\nEntrez votre nom d'utilisateur et votre mot de passe puis séléctionner l'icone \\"Se Connecter\\"\\n\\n\\nSélectionnez l'icône le nom de votre événement.", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Sélectionnez l'icône configuration puis envoyer le lien de la galerie par mail.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Indiquez le mail du client et séléctionnez envoyer", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Le client reçoit le mail suivant avec le numéro de l'événement et le lien de leur événement :", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Bonjour,\\nToute l'équipe SELFIZEE vous félicite pour votre événement.\\nNous sommes fiers d'avoir pu vous accompagner pour votre animation et nous vous remercions de votre confiance.\\nNous vous communiquons le lien pour accéder à votre galerie: https://myevent.selfizee.fr\\nVotre identifiant personnalisé : 4F2F214GF216\\nVous accédez ensuite à votre galerie avec l'ensemble de vos photos. Vous pouvez ensuite les télécharger et/ou les partager avec vos invités ou sur les réseaux sociaux.\\nNous restons à votre disposition pour tout renseignement.\\nMerci et à bientôt.\\nL'équipe SELFIZEE", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Si le client ne le trouve pas le faire chercher dans les spams ou lui fournir le liens https://myevent.selfizee.fr sur InternetIl devra indiquer le numéro de son événement et sélectionner la flèche pour valider.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Télécharger les médias ou en cliquant sur une des images de la gallerie avoir différents choix.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "1 - Télécharger l'image.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "2 - Partager sur les réseaux sociaux.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "3 - Lancer le diaporama comprenant toutes les images de la gallerie.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "4 - Ajouter un commentaire à l'image.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "5 - Indiquer votre nom.6 - Valider le commentaire précédent.", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}]}	Vous devez vous conn&eacute;cter sur https://booth.selfizee.fr Entrez votre nom d'utilisateur et votre mot de passe puis s&eacute;l&eacute;ctionner l'icone "Se Connecter" S&eacute;lectionnez l'ic&ocirc;ne le nom de votre &eacute;v&eacute;nement. S&eacute;lectionnez l'ic&ocirc;ne configuration puis envoyer le lien de la galerie par mail. Indiquez le mail du client et s&eacute;l&eacute;ctionnez envoyer Le client re&ccedil;oit le mail suivant avec le num&eacute;ro de l'&eacute;v&eacute;nement et le lien de leur &eacute;v&eacute;nement : Bonjour, Toute l'&eacute;quipe SELFIZEE vous f&eacute;licite pour votre &eacute;v&eacute;nement. Nous sommes fiers d'avoir pu vous accompagner pour votre animation et nous vous remercions de votre confiance. Nous vous communiquons le lien pour acc&eacute;der &agrave; votre galerie: https://myevent . selfizee.fr Votre identifiant personnalis&eacute; : 4F2F214GF216 Vous acc&eacute;dez ensuite &agrave; votre galerie avec l'ensemble de vos photos. Vous pouvez ensuite les t&eacute;l&eacute;charger et/ou les partager avec vos invit&eacute;s ou sur les r&eacute;seaux sociaux. Nous restons &agrave; votre disposition pour tout renseignement. Merci et &agrave; bient&ocirc;t. L'&eacute;quipe SELFIZEE Si le client ne le trouve pas le faire chercher dans les spams ou lui fournir le liens https://myevent . selfizee.fr sur Internet Il devra indiquer le num&eacute;ro de son &eacute;v&eacute;nement et s&eacute;lectionner la fl&egrave;che pour valider. T&eacute;l&eacute;charger les m&eacute;dias ou en cliquant sur une des images de la gallerie avoir diff&eacute;rents choix. 1 - T&eacute;l&eacute;charger l'image. 2 - Partager sur les r&eacute;seaux sociaux. 3 - Lancer le diaporama comprenant toutes les images de la gallerie . 4 - Ajouter un commentaire &agrave; l'image. 5 - Indiquer votre nom. 6 - Valider le commentaire pr&eacute;c&eacute;dent.	PUBLISHED	85	2022-03-02 08:21:10	2026-05-26 07:57:10.619	2022-03-02 08:21:10	\N	\N
42	Avertissement sur le conditionnement de la borne Spherik	avertissement-sur-le-conditionnement-de-la-borne-spherik-86	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "AVERTISSEMENT Éléments de votre borne\\nAfin de réduire les risques d’incendie ou d’électrocution, ne pas\\nexposer cet appareil à la pluie ou à l’humidité. Afin d’écarter tout\\nrisque d’électrocution, garder le coffret fermé. Ne confier\\nl’entretien de l’appareil qu’à un personnel qualifié.\\nCet appareil doit être relié à la terre.\\nPour les appareils raccordés, la prise de courant est installée près\\nde l'équipement et doit être facilement accessible.\\nPour déconnecter l'alimentation principale, débranchez le\\nconnecteur AC IN.\\nCet appareil ne possède pas d’interrupteur d’alimentation.\\nLors de l’installation de l’appareil, incorporer un dispositif de\\ncoupure dans le câblage fixe ou brancher la fiche d’alimentation\\ndans une prise murale facilement accessible proche de\\nl’appareil. En cas de problème lors du fonctionnement de\\nl’appareil débrancher la fiche d’alimentation.\\n\\nLa borne Selfizee SPHERIK est conçue pour une utilisation\\nintérieure ou couverte exclusivement. Il est interdit d’utiliser\\nl’ensemble en extérieur sans structure protectrice. Quelque soit\\nl’environnement il est obligatoire d’éviter une exposition directe et\\nprolongée au soleil sous peine d’endommager le matériel.\\n\\nAssurez-vous d’installer l’ensemble sur une surface dure et plane.\\n", "type": "text"}]}]}	AVERTISSEMENT &Eacute;l&eacute;ments de votre borne Afin de r&eacute;duire les risques d&rsquo;incendie ou d&rsquo;&eacute;lectrocution, ne pas exposer cet appareil &agrave; la pluie ou &agrave; l&rsquo;humidit&eacute;. Afin d&rsquo;&eacute;carter tout risque d&rsquo;&eacute;lectrocution, garder le coffret ferm&eacute;. Ne confier l&rsquo;entretien de l&rsquo;appareil qu&rsquo;&agrave; un personnel qualifi&eacute;. Cet appareil doit &ecirc;tre reli&eacute; &agrave; la terre. Pour les appareils raccord&eacute;s, la prise de courant est install&eacute;e pr&egrave;s de l'&eacute;quipement et doit &ecirc;tre facilement accessible. Pour d&eacute;connecter l'alimentation principale, d&eacute;branchez le connecteur AC IN. Cet appareil ne poss&egrave;de pas d&rsquo;interrupteur d&rsquo;alimentation. Lors de l&rsquo;installation de l&rsquo;appareil, incorporer un dispositif de coupure dans le c&acirc;blage fixe ou brancher la fiche d&rsquo;alimentation dans une prise murale facilement accessible proche de l&rsquo;appareil. En cas de probl&egrave;me lors du fonctionnement de l&rsquo;appareil d&eacute;brancher la fiche d&rsquo;alimentation. La borne Selfizee SPHERIK est con&ccedil;ue pour une utilisation int&eacute;rieure ou couverte exclusivement. Il est interdit d&rsquo;utiliser l&rsquo;ensemble en ext&eacute;rieur sans structure protectrice. Quelque soit l&rsquo;environnement il est obligatoire d&rsquo;&eacute;viter une exposition directe et prolong&eacute;e au soleil sous peine d&rsquo;endommager le mat&eacute;riel. Assurez-vous d&rsquo;installer l&rsquo;ensemble sur une surface dure et plane.	PUBLISHED	86	2022-03-02 08:22:39	2026-05-26 07:57:10.646	2022-03-02 08:22:39	\N	\N
43	Avertissement sur le conditionnement de la borne Classik	avertissement-sur-le-conditionnement-de-la-borne-classik-87	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "AVERTISSEMENT Éléments de votre borne\\nAfin de réduire les risques d’incendie ou d’électrocution, ne pas\\nexposer cet appareil à la pluie ou à l’humidité. Afin d’écarter tout\\nrisque d’électrocution, garder le coffret fermé. Ne confier\\nl’entretien de l’appareil qu’à un personnel qualifié.\\nCet appareil doit être relié à la terre.\\nPour les appareils raccordés, la prise de courant est installée près\\nde l'équipement et doit être facilement accessible.\\nPour déconnecter l'alimentation principale, débranchez le\\nconnecteur AC IN.\\nCet appareil ne possède pas d’interrupteur d’alimentation.\\nLors de l’installation de l’appareil, incorporer un dispositif de\\ncoupure dans le câblage fixe ou brancher la fiche d’alimentation\\ndans une prise murale facilement accessible proche de\\nl’appareil. En cas de problème lors du fonctionnement de\\nl’appareil débrancher la fiche d’alimentation.\\n\\nLa borne Selfizee SPHERIK est conçue pour une utilisation\\nintérieure ou couverte exclusivement. Il est interdit d’utiliser\\nl’ensemble en extérieur sans structure protectrice. Quelque soit\\nl’environnement il est obligatoire d’éviter une exposition directe et\\nprolongée au soleil sous peine d’endommager le matériel.\\n\\nAssurez-vous d’installer l’ensemble sur une surface dure et plane.", "type": "text"}]}]}	AVERTISSEMENT &Eacute;l&eacute;ments de votre borne Afin de r&eacute;duire les risques d&rsquo;incendie ou d&rsquo;&eacute;lectrocution, ne pas exposer cet appareil &agrave; la pluie ou &agrave; l&rsquo;humidit&eacute;. Afin d&rsquo;&eacute;carter tout risque d&rsquo;&eacute;lectrocution, garder le coffret ferm&eacute;. Ne confier l&rsquo;entretien de l&rsquo;appareil qu&rsquo;&agrave; un personnel qualifi&eacute;. Cet appareil doit &ecirc;tre reli&eacute; &agrave; la terre. Pour les appareils raccord&eacute;s, la prise de courant est install&eacute;e pr&egrave;s de l'&eacute;quipement et doit &ecirc;tre facilement accessible. Pour d&eacute;connecter l'alimentation principale, d&eacute;branchez le connecteur AC IN. Cet appareil ne poss&egrave;de pas d&rsquo;interrupteur d&rsquo;alimentation. Lors de l&rsquo;installation de l&rsquo;appareil, incorporer un dispositif de coupure dans le c&acirc;blage fixe ou brancher la fiche d&rsquo;alimentation dans une prise murale facilement accessible proche de l&rsquo;appareil. En cas de probl&egrave;me lors du fonctionnement de l&rsquo;appareil d&eacute;brancher la fiche d&rsquo;alimentation. La borne Selfizee SPHERIK est con&ccedil;ue pour une utilisation int&eacute;rieure ou couverte exclusivement. Il est interdit d&rsquo;utiliser l&rsquo;ensemble en ext&eacute;rieur sans structure protectrice. Quelque soit l&rsquo;environnement il est obligatoire d&rsquo;&eacute;viter une exposition directe et prolong&eacute;e au soleil sous peine d&rsquo;endommager le mat&eacute;riel. Assurez-vous d&rsquo;installer l&rsquo;ensemble sur une surface dure et plane.	PUBLISHED	87	2022-03-02 08:22:55	2026-05-26 07:57:10.672	2022-03-02 08:22:55	\N	\N
44	J’ai une erreur sur mon design de cadre photo 	j-ai-une-erreur-sur-mon-design-de-cadre-photo-88	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	88	2022-03-02 08:23:56	2026-05-26 07:57:10.699	2022-03-02 08:23:56	\N	\N
45	Je ne reçois pas la photo par email 	je-ne-recois-pas-la-photo-par-email-89	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "En premier lieu, nous allons devoir sortir du logiciel.\\nPour cela brancher le clavier et sélectionnez en même temps la touche Alt et la touche F4 pour sortir du logiciel.\\nSélectionnez l'icône WIFI.\\n\\nSélectionnez Afficher, les réseaux disponibles\\n\\nSélectionnez votre réseau wifi et indiquez le mot de passe a l'aide du clavier précédemment connecté à la borne.\\nVérifiez si votre borne est bien connectée en wifi sur Internet.\\nVous allez redémarrer la borne, pour cela :\\n1 - sélectionner le bouton Windows\\n2 - sélectionner le bouton Marche/Arrêt\\n3 - sélectionner le bouton Redémarrer\\n\\nUne fois la Borne redémarrée prendre une photo et vérifier si votre photo arrive dans les 5 minutes.\\n\\nSi le problème n'est pas résolu merci de vérifier si le logicielNextcloudest bienconnecté.\\nPour cela sélectionner la touche Windows de votre clavier puis taper sur votre clavier nextcloud et cliquer sur l'icône.", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Vérifie si la dernière mise à jour est bien à la même heure que la prise de photo.\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "\\nSi le problème n'est pas résolu merci de supprimer le chemin de sauvegarde dans nextcloud.\\n\\nPour cela faire un clique de droit sur le chemin et supprimer la synchronisation des fichiers.\\nPuis recommencer la synchronisation.\\n \\n\\n\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Dans le cas de cette borne il y a déjà une synchronisation de dossier de configurée. Le dossier Events correspond au dossier utilisé par Socialbooth et le TojoBooth que l’on retrouve sur les bornes Carmila \\nCliquer sur Ajouter une « synchronisation de dossier » \\n \\n Voici le chemin qui peut être copié-collé c:\\\\programdata\\\\konitys\\\\Selfizee\\\\Events\\\\ \\n \\nUne fois le chemin renseigné, appuyer sur « Suivant » \\n \\nCliquer sur le dossier Nextcloud puis cliquer sur « Suivant »  \\n \\nCliquer sur ajouter la synchronisation  \\n \\nLa configuration de Nextcloud est terminée.  \\nUn redémarrage de la borne permettra de finaliser la configuration de Nextcloud et de vérifier que c’est bien l’application Selfizee qui démarre avec la borne ", "type": "text"}]}]}	En premier lieu, nous allons devoir sortir du logiciel. Pour cela brancher le clavier et s&eacute;lectionnez en m&ecirc;me temps la touche Alt et la touche F4 pour sortir du logiciel. S&eacute;lectionnez l'ic&ocirc;ne WIFI. S&eacute;lectionnez Afficher, les r&eacute;seaux disponibles S&eacute;lectionnez votre r&eacute;seau wifi et indiquez le mot de passe a l'aide du clavier pr&eacute;c&eacute;demment connect&eacute; &agrave; la borne. V&eacute;rifiez si votre borne est bien connect&eacute;e en wifi sur Internet. Vous allez red&eacute;marrer la borne, pour cela : 1 - s&eacute;lectionner le bouton Windows 2 - s&eacute;lectionner le bouton Marche/Arr&ecirc;t 3 - s&eacute;lectionner le bouton Red&eacute;marrer Une fois la Borne red&eacute;marr&eacute;e prendre une photo et v&eacute;rifier si votre photo arrive dans les 5 minutes. Si le probl&egrave;me n'est pas r&eacute;solu merci de v&eacute;rifier si le logiciel Nextcloud est bienconnect&eacute;. Pour cela s &eacute;lectionner la touche Windows de votre clavier puis taper sur votre clavier nextcloud et cliquer sur l'ic&ocirc;ne. V&eacute;rifie si la derni&egrave;re mise &agrave; jour est bien &agrave; la m&ecirc;me heure que la prise de photo. Si le probl&egrave;me n'est pas r&eacute;solu merci de supprimer le chemin de sauvegarde dans nextcloud . Pour cela faire un clique de droit sur le chemin et supprimer la synchronisation des fichiers. Puis recommencer la synchronisation. Dans le cas de cette borne il y a d&eacute;j&agrave; une synchronisation de dossier de configur&eacute;e. Le dossier Events correspond au dossier utilis&eacute; par Socialbooth et le TojoBooth que l&rsquo;on retrouve sur les bornes Carmila Cliquer sur Ajouter une &laquo; synchronisation de dossier &raquo; Voici le chemin qui peut &ecirc;tre copi&eacute;-coll&eacute; c:\\programdata\\konitys\\Selfizee\\Events\\ Une fois le chemin renseign&eacute;, appuyer sur &laquo; Suivant &raquo; Cliquer sur le dossier Nextcloud puis cliquer sur &laquo; Suivant &raquo; Cliquer sur ajouter la synchronisation La configuration de Nextcloud est termin&eacute;e. Un red&eacute;marrage de la borne permettra de finaliser la configuration de Nextcloud et de v&eacute;rifier que c&rsquo;est bien l&rsquo;application Selfizee qui d&eacute;marre avec la borne	PUBLISHED	89	2022-03-02 08:29:35	2026-05-26 07:57:10.73	2022-03-02 08:29:35	\N	\N
46	Une fenêtre de MAJ apparaît sur l’écran.	une-fenetre-de-maj-apparait-sur-l-ecran-91	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "⚠️ Si vous rencontrez ce type d'écran sur votre borne ne surtout rien faire, il faut juste attendre.\\nUne mise à jour est en train de se faire sur la borne, si vous la redémarrez, vous risqué de ne plus pouvoir accéder à votre événement.\\n\\n", "type": "text"}]}]}	⚠️ Si vous rencontrez ce type d'&eacute;cran sur votre borne ne surtout rien faire, il faut juste attendre. Une mise &agrave; jour est en train de se faire sur la borne, si vous la red&eacute;marrez, vous risqu&eacute; de ne plus pouvoir acc&eacute;der &agrave; votre &eacute;v&eacute;nement.	PUBLISHED	91	2022-03-02 08:44:30	2026-05-26 07:57:10.756	2022-03-02 08:44:30	\N	\N
84	Comment monter le trépied?	comment-monter-le-trepied-147	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "15 cm =TAILLE ENFANT\\n30 cm = TAILLE ADULTE\\n\\n", "type": "text"}]}]}	15 cm =TAILLE ENFANT 30 cm = TAILLE ADULTE	PUBLISHED	147	2022-05-03 15:35:37	2026-05-26 07:57:11.874	2022-05-03 15:35:37	\N	\N
47	Le logiciel ne démarre pas 	le-logiciel-ne-demarre-pas-92	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Appuyer deux fois sur l'icône de l'application \\"\\" borne \\"\\".\\n\\nSi le logiciel n'est toujours pas lancé.\\nVous allez redémarrer la borne, pour cela :\\n1 - sélectionner le bouton Windows\\n2 - sélectionner le bouton Marche /Arrêt\\n3 - sélectionner le bouton Redémarré\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Attendre que la borne redémarre.\\nLorsque la borne est redémarrée si le logiciel ne se lance pas automatiquement, appuyer deux fois sur l'icône de l'application \\"\\" borne \\"\\".", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}]}	Appuyer deux fois sur l'ic&ocirc;ne de l'application "" borne "". Si le logiciel n'est toujours pas lanc&eacute;. Vous allez red&eacute;marrer la borne, pour cela : 1 - s&eacute;lectionner le bouton Windows 2 - s&eacute;lectionner le bouton Marche /Arr&ecirc;t 3 - s&eacute;lectionner le bouton Red&eacute;marr&eacute; Attendre que la borne red&eacute;marre. Lorsque la borne est red&eacute;marr&eacute;e si le logiciel ne se lance pas automatiquement, appuyer deux fois sur l'ic&ocirc;ne de l'application "" borne "".	PUBLISHED	92	2022-03-02 08:49:14	2026-05-26 07:57:10.783	2022-03-02 08:49:14	\N	\N
48	Comment nettoyer les anciens événements?	comment-nettoyer-les-anciens-evenements-97	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nSélectionnez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe !\\"<>':;/? à l'aide du clavier tactile.\\n\\nSélectionnez l'icône de fermeture en haut à droite.\\n\\nSélectionnez l'icône Assistance en haut à droite.\\n\\nAllez dans la barre et notter %programdata%\\\\konitys\\\\selfizee\\\\events\\n\\nSélectionnez un des anciens fichier en faisant un clique de droit puis supprimer.\\nQuitter la fenêtre.\\n\\nRelancez le logiciel \\"\\"borne\\"\\"\\n", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. S&eacute;lectionnez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe !"<>':;/? &agrave; l'aide du clavier tactile. S&eacute;lectionnez l'ic&ocirc;ne de fermeture en haut &agrave; droite. S&eacute;lectionnez l'ic&ocirc;ne Assistance en haut &agrave; droite. Allez dans la barre et notter %programdata%\\konitys\\selfizee\\events S&eacute;lectionnez un des anciens fichier en faisant un clique de droit puis supprimer. Quitter la fen&ecirc;tre. Relancez le logiciel ""borne""	PUBLISHED	97	2022-03-04 08:54:57	2026-05-26 07:57:10.812	2022-03-04 08:54:57	\N	\N
49	Expédition d’un colis en France	expedition-d-un-colis-en-france-99	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Accès au compte et contact\\nLien de connexion : UPS (https://www.ups.com/fr/fr/Home.page?)\\nIdentifiant : logistique@konitys.fr\\nMot de passe : logi222Kys!\\nContact : Cécile Gautier 06 60 92 45 06\\nConditions d’expédition\\nDélais de livraison\\nRéception en J+1 avant 12h possible\\nPoids et dimensions\\n", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Tarifs", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "04/06/2020 Expédition d’un colis en France – Espace privatif 2/3 Commentaires Coût enlèvement Frais de manutention pour colis de + 30 Kg Taxe carburant non comprise Expédition sans délai garanti Accès au compte et contact Lien de connexion : https://www.colissimo.entreprise.laposte.fr/fr Identifiant : 322638 Mot de passe : logi222Kys Conditions d’expédition Délais de livraison A prioriser si envoi non urgent (moins onéreux) Réception en 48h Minimum 04/06/2020 Expédition d’un colis en France – Espace privatif 3/3 Poids et dimensions 30 kgs maximum La somme de la largeur, de la longueur et de la hauteur ne doit pas dépasser 150 cm. La longueur ne doit pas excéder 100 cm. Tarifs", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Autre solution d’expédition Accès au compte et contact Lien de connexion : https://www.chronopost.fr/ Identifiant : KONITYS Mot de passe : K@221870 Conditions d’expédition Tarifs", "type": "text"}]}, {"type": "codeBlock", "attrs": {"language": null}}, {"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Commentaires + cher que UPS Délais 24h pas toujours respecté hors bretagne", "type": "text"}]}]}	Acc&egrave;s au compte et contact Lien de connexion : UPS (https://www.ups.com/fr/fr/Home.page?) Identifiant : logistique@konitys.fr Mot de passe : logi222Kys! Contact : C&eacute;cile Gautier 06 60 92 45 06 Conditions d&rsquo;exp&eacute;dition D&eacute;lais de livraison R&eacute;ception en J+1 avant 12h possible Poids et dimensions Tarifs 04/06/2020 Exp&eacute;dition d&rsquo;un colis en France &ndash; Espace privatif 2/3 Commentaires Co&ucirc;t enl&egrave;vement Frais de manutention pour colis de + 30 Kg Taxe carburant non comprise Exp&eacute;dition sans d&eacute;lai garanti Acc&egrave;s au compte et contact Lien de connexion : https://www.colissimo.entreprise.laposte.fr/fr Identifiant : 322638 Mot de passe : logi222Kys Conditions d&rsquo;exp&eacute;dition D&eacute;lais de livraison A prioriser si envoi non urgent (moins on&eacute;reux) R&eacute;ception en 48h Minimum 04/06/2020 Exp&eacute;dition d&rsquo;un colis en France &ndash; Espace privatif 3/3 Poids et dimensions 30 kgs maximum La somme de la largeur, de la longueur et de la hauteur ne doit pas d&eacute;passer 150 cm. La longueur ne doit pas exc&eacute;der 100 cm. Tarifs Autre solution d&rsquo;exp&eacute;dition Acc&egrave;s au compte et contact Lien de connexion : https://www.chronopost.fr/ Identifiant : KONITYS Mot de passe : K@221870 Conditions d&rsquo;exp&eacute;dition Tarifs Commentaires + cher que UPS D&eacute;lais 24h pas toujours respect&eacute; hors bretagne	PUBLISHED	99	2022-03-04 09:06:55	2026-05-26 07:57:10.838	2022-03-04 09:06:55	\N	\N
50	configuration event CA	configuration-event-ca-101	\N	{"type": "doc", "content": [{"type": "heading", "attrs": {"level": 4}, "content": [{"text": "1 - Partie Social Booth", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Onglet Général :", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Onglet Display :", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Texte à mettre dans display message :", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Onglet Display – Option Layout", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Onglet Templates :", "type": "text"}]}, {"type": "paragraph", "content": [{"type": "hardBreak"}]}, {"type": "paragraph", "content": [{"text": "Onglet Filtres :", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": "Onglet Printing :", "type": "text"}]}, {"type": "paragraph", "content": [{"type": "hardBreak"}]}, {"type": "heading", "attrs": {"level": 4}, "content": [{"text": "2 - Partie reaconverter", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph"}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": " Il faut créer un watch folder pour chaque event et enregistrer une configuration pour chaque event car le dossier scanné n’est pas le même.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Planificateur de taches :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "heading", "attrs": {"level": 4}, "content": [{"text": "3 - Partie Ordinateur", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Pour automatiser certain traitement on va utiliser le planificateur de tache :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Démarrage de reaconverter :", "type": "text"}]}, {"type": "paragraph"}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"type": "hardBreak"}]}, {"type": "paragraph", "content": [{"text": "Extinction automatique du pc :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"type": "hardBreak"}, {"type": "hardBreak"}]}, {"type": "paragraph", "content": [{"text": " Modification du Bios pour que le PC démarre automatiquement", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"type": "hardBreak"}, {"type": "hardBreak"}]}]}	1 - Partie Social Booth Onglet G&eacute;n&eacute;ral : Onglet Display : Texte &agrave; mettre dans display message : Onglet Display &ndash; Option Layout Onglet Templates : Onglet Filtres : Onglet Printing : 2 - Partie reaconverter Il faut cr&eacute;er un watch folder pour chaque event et enregistrer une configuration pour chaque event car le dossier scann&eacute; n&rsquo;est pas le m&ecirc;me. Planificateur de taches : 3 - Partie Ordinateur Pour automatiser certain traitement on va utiliser le planificateur de tache : D&eacute;marrage de reaconverter : Extinction automatique du pc : Modification du Bios pour que le PC d&eacute;marre automatiquement	PUBLISHED	101	2022-03-04 09:38:13	2026-05-26 07:57:10.871	2022-03-04 09:38:13	\N	\N
51	À combien de distance de la borne Spherik, il faut se positionner pour prendre les photos ?	a-combien-de-distance-de-la-borne-spherik-il-faut-se-positionner-pour-prendre-le-102	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "Il vous faudra entre 2 et 3 mètres de recul pour prendre une photo optimale.", "type": "text"}]}, {"type": "paragraph"}]}	Il vous faudra entre 2 et 3 m&egrave;tres de recul pour prendre une photo optimale.	PUBLISHED	102	2022-03-07 11:06:23	2026-05-26 07:57:10.905	2022-03-07 11:06:23	\N	\N
52	À combien de distance de la borne Classik, il faut se positionner pour prendre les photos ?	a-combien-de-distance-de-la-borne-classik-il-faut-se-positionner-pour-prendre-le-103	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Il vous faudra entre 2 et 3 mètres de recul pour prendre une photo optimale.\\n", "type": "text"}]}]}	Il vous faudra entre 2 et 3 m&egrave;tres de recul pour prendre une photo optimale.	PUBLISHED	103	2022-03-07 11:07:09	2026-05-26 07:57:10.934	2022-03-07 11:07:09	\N	\N
53	A combien de personnes ont peut-être sur la photo?	a-combien-de-personnes-ont-peut-etre-sur-la-photo-104	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Tout dépendra de la distance de la borne à laquelle vous vous tenez, mais aussi du type de photo et de cadre que vous aurez sur votre événement.\\nUne photo paysage pourras accepter plus de personnes qu'une photo en mode portrait.", "type": "text"}]}]}	Tout d&eacute;pendra de la distance de la borne &agrave; laquelle vous vous tenez, mais aussi du type de photo et de cadre que vous aurez sur votre &eacute;v&eacute;nement. Une photo paysage pourras accepter plus de personnes qu'une photo en mode portrait.	PUBLISHED	104	2022-03-07 11:07:46	2026-05-26 07:57:10.96	2022-03-07 11:07:46	\N	\N
134	✅ Éteindre le photobooth	eteindre-le-photobooth-249	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	249	2023-10-23 14:47:28	2026-05-26 07:57:13.455	2023-10-23 14:47:28	\N	\N
62	Caution et annulation	caution-et-annulation-117	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "Le Client s’engage à verser une caution de 500 € par chèque au même moment que l’acompte prévu au contrat ou bon de commande, à savoir au plus tard 72h avant la date convenue pour la livraison, le retrait ou l’installation de la borne SELFIZEE. Aucune remise de la borne ou du matériel annexe ne pourra intervenir avant le versement de la totalité de la somme due et de la caution. Cette caution pourra être encaissée à tout moment par KONITYS si la borne SELFIZEE n’est pas retournée au jour et à l’heure prévue. La caution sera remboursée au Client après vérification que la borne et le matériel loués soient restitués dans l’état où ils se trouvaient lors de la remise du matériel. En cas de retard de réexpédition, de non-restitution, vol, perte ou détérioration de la borne SELFIZEE, du matériel ou du consommable, KONITYS est en droit de conserver définitivement l’intégralité de la caution sans préjudice de son droit à des dommages et intérêts complémentaires si le montant de son dommage est supérieur à la somme de la caution versée.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Ce dommage pourra, sans que cette liste soit limitative, comprendre les frais de réparations, le cas échéant le prix du rachat d’une borne et du matériel abimé à neuf ainsi que le manque à gagner de KONITYS résultant de l’impossibilité de relouer la borne SELFIZEE et le matériel à d’autres clients pendant le délai de réparation ou de remplacement de la borne SELFIZEE et du matériel.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Le Client peut annuler le contrat de location sans frais de gestion jusqu’à 30 jours avant la date convenue pour la livraison, l’installation ou le retrait de la borne SELFIZEE. Si des travaux ont été réalisés par KONITYS avant ce délai de J-30, l’acompte sera conservé par KONITYS. Celui-ci sera défalqué d’une prochaine réservation par le même Client.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Passé ce délai, le Client sera redevable d’une indemnité calculée comme suit :", "type": "text"}, {"type": "hardBreak"}, {"text": "- Entre 30 jours et 3 jours avant la date prévue de livraison, installation ou de retrait, 50% du montant total de la location sera dû à KONITYS.", "type": "text"}, {"type": "hardBreak"}, {"text": "- Entre J-3 et pendant la date ou période de location, 100% du montant sera dû à KONITYS.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "L’annulation du Client devra impérativement être effectuée par écrit par email à : contact@konitys.fr. La date d’envoi de l’email sera prise en compte pour le calcul de l’éventuelle indemnité au titre de l’annulation.", "type": "text"}]}]}	Le Client s&rsquo;engage à verser une caution de 500 &euro; par chèque au même moment que l&rsquo;acompte prévu au contrat ou bon de commande, à savoir au plus tard 72h avant la date convenue pour la livraison, le retrait ou l&rsquo;installation de la borne SELFIZEE. Aucune remise de la borne ou du matériel annexe ne pourra intervenir avant le versement de la totalité de la somme due et de la caution. Cette caution pourra être encaissée à tout moment par KONITYS si la borne SELFIZEE n&rsquo;est pas retournée au jour et à l&rsquo;heure prévue. La caution sera remboursée au Client après vérification que la borne et le matériel loués soient restitués dans l&rsquo;état où ils se trouvaient lors de la remise du matériel. En cas de retard de réexpédition, de non-restitution, vol, perte ou détérioration de la borne SELFIZEE, du matériel ou du consommable, KONITYS est en droit de conserver définitivement l&rsquo;intégralité de la caution sans préjudice de son droit à des dommages et intérêts complémentaires si le montant de son dommage est supérieur à la somme de la caution versée. Ce dommage pourra, sans que cette liste soit limitative, comprendre les frais de réparations, le cas échéant le prix du rachat d&rsquo;une borne et du matériel abimé à neuf ainsi que le manque à gagner de KONITYS résultant de l&rsquo;impossibilité de relouer la borne SELFIZEE et le matériel à d&rsquo;autres clients pendant le délai de réparation ou de remplacement de la borne SELFIZEE et du matériel. Le Client peut annuler le contrat de location sans frais de gestion jusqu&rsquo;à 30 jours avant la date convenue pour la livraison, l&rsquo;installation ou le retrait de la borne SELFIZEE. Si des travaux ont été réalisés par KONITYS avant ce délai de J-30, l&rsquo;acompte sera conservé par KONITYS. Celui-ci sera défalqué d&rsquo;une prochaine réservation par le même Client. Passé ce délai, le Client sera redevable d&rsquo;une indemnité calculée comme suit : - Entre 30 jours et 3 jours avant la date prévue de livraison, installation ou de retrait, 50% du montant total de la location sera dû à KONITYS. - Entre J-3 et pendant la date ou période de location, 100% du montant sera dû à KONITYS. L&rsquo;annulation du Client devra impérativement être effectuée par écrit par email à : contact@konitys.fr. La date d&rsquo;envoi de l&rsquo;email sera prise en compte pour le calcul de l&rsquo;éventuelle indemnité au titre de l&rsquo;annulation.	PUBLISHED	117	2022-03-07 11:17:20	2026-05-26 07:57:11.212	2022-03-07 11:17:20	\N	\N
63	J’ai reçu la borne mais elle est abimée 	j-ai-recu-la-borne-mais-elle-est-abimee-118	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": " Réception de toute marchandise, vous devez :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Contrôler vos produits au moment de leur livraison.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Si un emballage présente un défaut, un examen du contenu en présence du point de réception est nécessaire pour identifier une éventuelle anomalie et préserver votre retour.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Formulez les réserves par écrit au moment de la livraison.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Pour être recevables, les réserves doivent être écrites, précises, complètes, avec des prises de photos proche et éloigné et confirmées si nécessaire.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Elles doivent concerner la marchandise.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Indiquez le nombre, la référence et le nom de la pièce endommagé.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Précisez si le colis a été ouvert ou re scotché.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Décrivez au mieux le dommage subi.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Lors de la réception d’un colis paraissant ou étant endommagé, il est impératif que vous émettiez des réserves sur le bordereau de livraison pour être recevables, les réserves doivent être :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Écrites : formulées au moment de la livraison", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Précises : décrivant les anomalies de livraison et les dommages subis par la marchandise (et non exclusivement par l’emballage) avec la référence ou le nom des pièces concernées", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Complètes : seuls les dommages mentionnés dans les réserves seront retenus comme existants au moment de la livraison confirmée par écrit.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "En cas de doute, refusez le colis en précisant le refus de vous laisser contrôler la marchandise.", "type": "text"}]}]}	R&eacute;ception de toute marchandise, vous devez : &ndash; Contr&ocirc;ler vos produits au moment de leur livraison. &ndash; Si un emballage pr&eacute;sente un d&eacute;faut, un examen du contenu en pr&eacute;sence du point de r&eacute;ception est n&eacute;cessaire pour identifier une &eacute;ventuelle anomalie et pr&eacute;server votre retour. &ndash; Formulez les r&eacute;serves par &eacute;crit au moment de la livraison. &ndash; Pour &ecirc;tre recevables, les r&eacute;serves doivent &ecirc;tre &eacute;crites, pr&eacute;cises, compl&egrave;tes, avec des prises de photos proche et &eacute;loign&eacute; et confirm&eacute;es si n&eacute;cessaire. &ndash; Elles doivent concerner la marchandise. Indiquez le nombre, la r&eacute;f&eacute;rence et le nom de la pi&egrave;ce endommag&eacute;. Pr&eacute;cisez si le colis a &eacute;t&eacute; ouvert ou re scotch&eacute;. D&eacute;crivez au mieux le dommage subi. Lors de la r&eacute;ception d&rsquo;un colis paraissant ou &eacute;tant endommag&eacute;, il est imp&eacute;ratif que vous &eacute;mettiez des r&eacute;serves sur le bordereau de livraison pour &ecirc;tre recevables, les r&eacute;serves doivent &ecirc;tre : &Eacute;crites : formul&eacute;es au moment de la livraison Pr&eacute;cises : d&eacute;crivant les anomalies de livraison et les dommages subis par la marchandise (et non exclusivement par l&rsquo;emballage) avec la r&eacute;f&eacute;rence ou le nom des pi&egrave;ces concern&eacute;es Compl&egrave;tes : seuls les dommages mentionn&eacute;s dans les r&eacute;serves seront retenus comme existants au moment de la livraison confirm&eacute;e par &eacute;crit. En cas de doute, refusez le colis en pr&eacute;cisant le refus de vous laisser contr&ocirc;ler la marchandise.	PUBLISHED	118	2022-03-07 11:17:37	2026-05-26 07:57:11.238	2022-03-07 11:17:37	\N	\N
64	J’ai reçu le carton mais il est complétement déchiré. Je dois l’accepter ?	j-ai-recu-le-carton-mais-il-est-completement-dechire-je-dois-l-accepter-119	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": " Réception de toute marchandise, vous devez :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Contrôler vos produits au moment de leur livraison.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Si un emballage présente un défaut, un examen du contenu en présence du point de réception est nécessaire pour identifier une éventuelle anomalie et préserver votre retour.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Formulez les réserves par écrit au moment de la livraison.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Pour être recevables, les réserves doivent être écrites, précises, complètes, avec des prises de photos proche et éloigné et confirmées si nécessaire.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "– Elles doivent concerner la marchandise.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Indiquez le nombre, la référence et le nom de la pièce endommagé.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Précisez si le colis a été ouvert ou re scotché.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Décrivez au mieux le dommage subi.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Lors de la réception d’un colis paraissant ou étant endommagé, il est impératif que vous émettiez des réserves sur le bordereau de livraison pour être recevables, les réserves doivent être :", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Écrites : formulées au moment de la livraison", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Précises : décrivant les anomalies de livraison et les dommages subis par la marchandise (et non exclusivement par l’emballage) avec la référence ou le nom des pièces concernées", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Complètes : seuls les dommages mentionnés dans les réserves seront retenus comme existants au moment de la livraison confirmée par écrit.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "En cas de doute, refusez le colis en précisant le refus de vous laisser contrôler la marchandise.", "type": "text"}]}]}	R&eacute;ception de toute marchandise, vous devez : &ndash; Contr&ocirc;ler vos produits au moment de leur livraison. &ndash; Si un emballage pr&eacute;sente un d&eacute;faut, un examen du contenu en pr&eacute;sence du point de r&eacute;ception est n&eacute;cessaire pour identifier une &eacute;ventuelle anomalie et pr&eacute;server votre retour. &ndash; Formulez les r&eacute;serves par &eacute;crit au moment de la livraison. &ndash; Pour &ecirc;tre recevables, les r&eacute;serves doivent &ecirc;tre &eacute;crites, pr&eacute;cises, compl&egrave;tes, avec des prises de photos proche et &eacute;loign&eacute; et confirm&eacute;es si n&eacute;cessaire. &ndash; Elles doivent concerner la marchandise. Indiquez le nombre, la r&eacute;f&eacute;rence et le nom de la pi&egrave;ce endommag&eacute;. Pr&eacute;cisez si le colis a &eacute;t&eacute; ouvert ou re scotch&eacute;. D&eacute;crivez au mieux le dommage subi. Lors de la r&eacute;ception d&rsquo;un colis paraissant ou &eacute;tant endommag&eacute;, il est imp&eacute;ratif que vous &eacute;mettiez des r&eacute;serves sur le bordereau de livraison pour &ecirc;tre recevables, les r&eacute;serves doivent &ecirc;tre : &Eacute;crites : formul&eacute;es au moment de la livraison Pr&eacute;cises : d&eacute;crivant les anomalies de livraison et les dommages subis par la marchandise (et non exclusivement par l&rsquo;emballage) avec la r&eacute;f&eacute;rence ou le nom des pi&egrave;ces concern&eacute;es Compl&egrave;tes : seuls les dommages mentionn&eacute;s dans les r&eacute;serves seront retenus comme existants au moment de la livraison confirm&eacute;e par &eacute;crit. En cas de doute, refusez le colis en pr&eacute;cisant le refus de vous laisser contr&ocirc;ler la marchandise.	PUBLISHED	119	2022-03-07 11:17:55	2026-05-26 07:57:11.266	2022-03-07 11:17:55	\N	\N
65	Je n’ai pas l’étiquette de retour de la borne 	je-n-ai-pas-l-etiquette-de-retour-de-la-borne-120	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "Merci de regarder à l'intérieur des cartons. Vous allez y retrouver les deux étiquettes dans une pochette plastique.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Garder les étiquettes retour et les coller sur les 2 colis Scotché enfin d’événement.", "type": "text"}]}]}	Merci de regarder &agrave; l'int&eacute;rieur des cartons. Vous allez y retrouver les deux &eacute;tiquettes dans une pochette plastique. Garder les &eacute;tiquettes retour et les c oller sur les 2 colis Scotch&eacute; enfin d &rsquo;&eacute;v&eacute;nement.	PUBLISHED	120	2022-03-07 11:18:10	2026-05-26 07:57:11.292	2022-03-07 11:18:10	\N	\N
66	Je n’ai plus le carton ou la mousse pour faire le retour 	je-n-ai-plus-le-carton-ou-la-mousse-pour-faire-le-retour-122	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	122	2022-03-07 11:18:39	2026-05-26 07:57:11.32	\N	\N	\N
67	Je ne pourrai pas rapporter renvoyer la jour initialement prévu .	je-ne-pourrai-pas-rapporter-renvoyer-la-jour-initialement-prevu-123	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	123	2022-03-07 11:18:58	2026-05-26 07:57:11.346	\N	\N	\N
68	Je ne rendrai pas la borne tant que je n’ai pas le geste commercial 	je-ne-rendrai-pas-la-borne-tant-que-je-n-ai-pas-le-geste-commercial-124	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	124	2022-03-07 11:21:23	2026-05-26 07:57:11.376	\N	\N	\N
69	Je veux un geste commercial.  Je veux parler à votre responsable.	je-veux-un-geste-commercial-je-veux-parler-a-votre-responsable-125	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	125	2022-03-07 11:21:45	2026-05-26 07:57:11.401	\N	\N	\N
70	L’antenne n’est pas à l’heure au rendez-vous!	l-antenne-n-est-pas-a-l-heure-au-rendez-vous-126	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	126	2022-03-07 11:22:01	2026-05-26 07:57:11.43	\N	\N	\N
71	L’hôtesse n’est pas arrivée.	l-hotesse-n-est-pas-arrivee-127	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	127	2022-03-07 11:22:16	2026-05-26 07:57:11.457	\N	\N	\N
72	Le transporteur UPS vient chercher la borne chez moi?	le-transporteur-ups-vient-chercher-la-borne-chez-moi-128	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Pour le retour : Vous déposerez la borne photo, divisez en deux colis, (avec les étiquettes aller préalablement enlever et les étiquettes de retour collé sur les cartons) dès le lundi au même endroit ou dans une des adresses de cette même liste\\nhttps://www.ups.com/dropoff/?loc=fr_FR", "type": "text"}]}]}	Pour le retour : Vous d&eacute;poserez la borne photo, divisez en deux colis, (avec les &eacute;tiquettes aller pr&eacute;alablement enlever et les &eacute;tiquettes de retour coll&eacute; sur les cartons) d&egrave;s le lundi au m&ecirc;me endroit ou dans une des adresses de cette m&ecirc;me liste https://www.ups.com/dropoff/?loc=fr_FR	PUBLISHED	128	2022-03-07 11:22:39	2026-05-26 07:57:11.487	2022-03-07 11:22:39	\N	\N
85	Le trépied n'est pas stable.	le-trepied-n-est-pas-stable-148	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Assurez-vous que les 3 pieds ont une extension identique.\\nUn repère à bulle sur la partie supérieure du trépied permet de visualiser que l’ensemble est correctement de niveau\\n", "type": "text"}]}]}	Assurez-vous que les 3 pieds ont une extension identique. Un rep&egrave;re &agrave; bulle sur la partie sup&eacute;rieure du tr&eacute;pied permet de visualiser que l&rsquo;ensemble est correctement de niveau	PUBLISHED	148	2022-05-03 15:51:57	2026-05-26 07:57:11.918	2022-05-03 15:51:57	\N	\N
73	Les coûts en cas de casse pour ma caution?	les-couts-en-cas-de-casse-pour-ma-caution-129	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Services :\\n- Reprise des fichiers sources du Client pour modification par KONITYS (3 échanges) >>>> 60€\\n- Retard de livraison ou d’installation de plus de 30 minutes du fait du Client (par heure commencée) >>>> 60€\\n- Retard de retour ou de désinstallation de plus de 30 minutes du fait du Client (par heure commencée) >>>> 60€\\n- Relivraison de colis ou palette du fait du Client >>>> Sur devis\\n- Enlèvement supplémentaire du fait du Client >>>> Sur devis\\n- Dépannage sur place du fait du Client >>>> Sur devis avec un minimum forfaitaire de 150€\\n- Remplacement de la borne du fait du Client >>>> Sur devis\\n- Retard du retour de la borne >>>> 300€/jour\\n- Heure de main d’œuvre incompressible >>>> 60€\\n\\nMatériel de la borne Spherik :\\n- Bloc carré en mousse polyéthylène du petit carton >>>> 180€\\n- Couvercle carré en mousse polyéthylène du petit carton >>>> 75€\\n- Bloc rectangulaire en mousse polyéthylène du grand carton >>>> 240€\\n- Couvercle rectangulaire en mousse polyéthylène du grand carton >>>> 55€\\n- Réparation d’une rayure apparente sur la borne (tarif par rayure) >>>> 60€\\n- Remise en peinture d’une partie de la borne >>>> 250€\\n- Remise en peinture totale de la borne >>>> 600€\\n- Réparation d’un choc sur la structure de la borne >>>> Sur devis\\n- Réparation d’une imprimante endommagée >>>> Sur devis avec un minimum forfaitaire de 300€\\n- Remplacement d’une imprimante endommagée et non réparable ou manquante >>>> 590€\\n- Réparation d’un écran endommagé >>>> Sur devis avec un minimum forfaitaire de 400€\\n- Remplacement d’un écran endommagé et non réparable >>>> 850€\\n- Réparation d’un trépied endommagé >>>> Sur devis avec un minimum forfaitaire de 200€\\n- Remplacement d’un trépied endommagé et non réparable ou manquant >>>> 450€\\n- Tout autre dommage sur la borne >>>> Sur devis\\n- Remplacement du halo LED >>>> 180€\\n- Plaque pour l’imprimante >>>> 70€\\n- Écrou et Vis de la plaque imprimante (unitaire) >>>> 10€\\n- Flasques en plastique (2 embouts de la bobine papier) >>>> 120€\\n- Réceptacle en plastique pour la sortie des photos >>>> 50€\\n- Corbeille en plastique pour les petits bandes de coupures >>>> 50€\\n- Rallonge d’alimentation de 3m >>>> 20€\\n- Bloc d’alimentation de la tête >>>> 100€\\n- Câble d’alimentation de l’imprimante >>>> 15€\\n- Câble USB pour l’imprimante >>>> 15€\\n- Clavier >>>> 30€\\n- Autre matériel annexe manquant >>>> Sur devis\\n\\nMatériel de la borne Classik :\\n- Réparation ou remplacement d’une housse de transport >>>> Sur devis\\n- Réparation d’une rayure apparente sur la borne (tarif par rayure) >>>> 100€\\n- Remise en peinture d’une partie de la borne >>>> 250€\\n- Remise en peinture totale de la borne >>>> 750€\\n- Réparation d’un choc sur la structure de la borne >>>> Sur devis\\n- Réparation d’une imprimante endommagée >>>> Sur devis avec un minimum forfaitaire de 500€\\n- Remplacement d’une imprimante endommagée et non réparable >>>> 1050€\\n- Réparation d’un écran endommagé >>>> Sur devis avec un minimum forfaitaire de 400€\\n- Remplacement d’une imprimante endommagée et non réparable >>>> 900€\\n- Réparation d’un appareil photo endommagé >>>> Sur devis avec un minimum forfaitaire de 200€\\n- Remplacement d’un appareil photo endommagé et non réparable >>>> 450€\\n- Réparation d’un PC endommagé >>>> Sur devis avec un minimum forfaitaire de 300€\\n- Remplacement d’un PC endommagé et non réparable >>>> 600€\\n- Tout autre dommage sur la borne >>>> Sur devis\\n- Domino 4g >>>> 280€\\n- Clé et Vis de montage du pied de la borne >>>> 10€\\n- Flasques en plastique (2 embouts de la bobine papier) >>>> 120€\\n- Corbeille en plastique pour les petits bandes de coupures >>>> 50€\\n- Rallonge d’alimentation de 3m >>>> 20€\\n- Bloc d’alimentation de la tête >>>> 30€\\n- Câble d’alimentation de l’imprimante >>>> 15€\\n- Câble USB pour l’imprimante >>>> 15€\\n- Clavier >>>> 30€\\n- Autre matériel annexe manquant >>>> Sur devis", "type": "text"}]}]}	Services : - Reprise des fichiers sources du Client pour modification par KONITYS (3 &eacute;changes) >>>> 60&euro; - Retard de livraison ou d&rsquo;installation de plus de 30 minutes du fait du Client (par heure commenc&eacute;e) >>>> 60&euro; - Retard de retour ou de d&eacute;sinstallation de plus de 30 minutes du fait du Client (par heure commenc&eacute;e) >>>> 60&euro; - Relivraison de colis ou palette du fait du Client >>>> Sur devis - Enl&egrave;vement suppl&eacute;mentaire du fait du Client >>>> Sur devis - D&eacute;pannage sur place du fait du Client >>>> Sur devis avec un minimum forfaitaire de 150&euro; - Remplacement de la borne du fait du Client >>>> Sur devis - Retard du retour de la borne >>>> 300&euro;/jour - Heure de main d&rsquo;&oelig;uvre incompressible >>>> 60&euro; Mat&eacute;riel de la borne Spherik : - Bloc carr&eacute; en mousse poly&eacute;thyl&egrave;ne du petit carton >>>> 180&euro; - Couvercle carr&eacute; en mousse poly&eacute;thyl&egrave;ne du petit carton >>>> 75&euro; - Bloc rectangulaire en mousse poly&eacute;thyl&egrave;ne du grand carton >>>> 240&euro; - Couvercle rectangulaire en mousse poly&eacute;thyl&egrave;ne du grand carton >>>> 55&euro; - R&eacute;paration d&rsquo;une rayure apparente sur la borne (tarif par rayure) >>>> 60&euro; - Remise en peinture d&rsquo;une partie de la borne >>>> 250&euro; - Remise en peinture totale de la borne >>>> 600&euro; - R&eacute;paration d&rsquo;un choc sur la structure de la borne >>>> Sur devis - R&eacute;paration d&rsquo;une imprimante endommag&eacute;e >>>> Sur devis avec un minimum forfaitaire de 300&euro; - Remplacement d&rsquo;une imprimante endommag&eacute;e et non r&eacute;parable ou manquante >>>> 590&euro; - R&eacute;paration d&rsquo;un &eacute;cran endommag&eacute; >>>> Sur devis avec un minimum forfaitaire de 400&euro; - Remplacement d&rsquo;un &eacute;cran endommag&eacute; et non r&eacute;parable >>>> 850&euro; - R&eacute;paration d&rsquo;un tr&eacute;pied endommag&eacute; >>>> Sur devis avec un minimum forfaitaire de 200&euro; - Remplacement d&rsquo;un tr&eacute;pied endommag&eacute; et non r&eacute;parable ou manquant >>>> 450&euro; - Tout autre dommage sur la borne >>>> Sur devis - Remplacement du halo LED >>>> 180&euro; - Plaque pour l&rsquo;imprimante >>>> 70&euro; - &Eacute;crou et Vis de la plaque imprimante (unitaire) >>>> 10&euro; - Flasques en plastique (2 embouts de la bobine papier) >>>> 120&euro; - R&eacute;ceptacle en plastique pour la sortie des photos >>>> 50&euro; - Corbeille en plastique pour les petits bandes de coupures >>>> 50&euro; - Rallonge d&rsquo;alimentation de 3m >>>> 20&euro; - Bloc d&rsquo;alimentation de la t&ecirc;te >>>> 100&euro; - C&acirc;ble d&rsquo;alimentation de l&rsquo;imprimante >>>> 15&euro; - C&acirc;ble USB pour l&rsquo;imprimante >>>> 15&euro; - Clavier >>>> 30&euro; - Autre mat&eacute;riel annexe manquant >>>> Sur devis Mat&eacute;riel de la borne Classik : - R&eacute;paration ou remplacement d&rsquo;une housse de transport >>>> Sur devis - R&eacute;paration d&rsquo;une rayure apparente sur la borne (tarif par rayure) >>>> 100&euro; - Remise en peinture d&rsquo;une partie de la borne >>>> 250&euro; - Remise en peinture totale de la borne >>>> 750&euro; - R&eacute;paration d&rsquo;un choc sur la structure de la borne >>>> Sur devis - R&eacute;paration d&rsquo;une imprimante endommag&eacute;e >>>> Sur devis avec un minimum forfaitaire de 500&euro; - Remplacement d&rsquo;une imprimante endommag&eacute;e et non r&eacute;parable >>>> 1050&euro; - R&eacute;paration d&rsquo;un &eacute;cran endommag&eacute; >>>> Sur devis avec un minimum forfaitaire de 400&euro; - Remplacement d&rsquo;une imprimante endommag&eacute;e et non r&eacute;parable >>>> 900&euro; - R&eacute;paration d&rsquo;un appareil photo endommag&eacute; >>>> Sur devis avec un minimum forfaitaire de 200&euro; - Remplacement d&rsquo;un appareil photo endommag&eacute; et non r&eacute;parable >>>> 450&euro; - R&eacute;paration d&rsquo;un PC endommag&eacute; >>>> Sur devis avec un minimum forfaitaire de 300&euro; - Remplacement d&rsquo;un PC endommag&eacute; et non r&eacute;parable >>>> 600&euro; - Tout autre dommage sur la borne >>>> Sur devis - Domino 4g >>>> 280&euro; - Cl&eacute; et Vis de montage du pied de la borne >>>> 10&euro; - Flasques en plastique (2 embouts de la bobine papier) >>>> 120&euro; - Corbeille en plastique pour les petits bandes de coupures >>>> 50&euro; - Rallonge d&rsquo;alimentation de 3m >>>> 20&euro; - Bloc d&rsquo;alimentation de la t&ecirc;te >>>> 30&euro; - C&acirc;ble d&rsquo;alimentation de l&rsquo;imprimante >>>> 15&euro; - C&acirc;ble USB pour l&rsquo;imprimante >>>> 15&euro; - Clavier >>>> 30&euro; - Autre mat&eacute;riel annexe manquant >>>> Sur devis	PUBLISHED	129	2022-03-07 11:23:09	2026-05-26 07:57:11.515	2022-03-07 11:23:09	\N	\N
74	Où et quand je dois redéposer la borne ?	ou-et-quand-je-dois-redeposer-la-borne-130	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Pour le retour : Vous déposerez la borne photo, divisez en deux colis, (avec les étiquettes aller préalablement enlever et les étiquettes de retour collé sur les cartons) dès le lundi au même endroit ou dans une des adresses de cette même liste \\nhttps://www.ups.com/dropoff/?loc=fr_FR", "type": "text"}]}]}	Pour le retour : Vous d&eacute;poserez la borne photo, divisez en deux colis, (avec les &eacute;tiquettes aller pr&eacute;alablement enlever et les &eacute;tiquettes de retour coll&eacute; sur les cartons) d&egrave;s le lundi au m&ecirc;me endroit ou dans une des adresses de cette m&ecirc;me liste https://www.ups.com/dropoff/?loc=fr_FR	PUBLISHED	130	2022-03-07 11:23:31	2026-05-26 07:57:11.542	2022-03-07 11:23:31	\N	\N
75	Où sont mes colis? Avez-vous un suivi des colis?	ou-sont-mes-colis-avez-vous-un-suivi-des-colis-131	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "ATTENTION ! : LA BORNE EST ENVOYEE EN DEUX CARTONS, VOUS AVEZ DONC DEUX COLIS A RECUPERER AU POINT RELAIS.\\nPour la livraison : La borne, divisez en deux colis, vous sera livrée à l’adresse de votre choix sélectionnée dans la liste des points relais UPS que vous trouverez sur ce lien: \\nhttps://www.ups.com/dropoff/?loc=fr_FR", "type": "text"}]}]}	ATTENTION ! : LA BORNE EST ENVOYEE EN DEUX CARTONS, VOUS AVEZ DONC DEUX COLIS A RECUPERER AU POINT RELAIS. Pour la livraison : La borne, divisez en deux colis, vous sera livr&eacute;e &agrave; l&rsquo;adresse de votre choix s&eacute;lectionn&eacute;e dans la liste des points relais UPS que vous trouverez sur ce lien: https://www.ups.com/dropoff/?loc=fr_FR	PUBLISHED	131	2022-03-07 11:23:51	2026-05-26 07:57:11.569	2022-03-07 11:23:51	\N	\N
76	Peut-on enlever le logo Selfizee ?	peut-on-enlever-le-logo-selfizee-132	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	132	2022-03-07 11:24:11	2026-05-26 07:57:11.596	\N	\N	\N
77	Achat pour la Borne Classik	achat-pour-la-borne-classik-133	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "Borne:", "type": "text"}]}, {"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Base:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Pied:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Tête:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Boulon:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Housse:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Carton:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Serflex", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": " ", "type": "text"}]}]}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Informatique:", "type": "text"}]}, {"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Ordinateur:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Ecran:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Clavier:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Hub ou multiprise USB:", "type": "text"}]}]}]}, {"type": "paragraph", "content": [{"text": "Appareil Photo:", "type": "text"}]}, {"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Cable USB Appareil Photo:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Boitier Appareil Photo:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Alimentation Appareil Photo:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Fausse batterie Appareil Photo", "type": "text"}]}]}]}, {"type": "paragraph", "content": [{"text": "Imprimante:", "type": "text"}]}, {"type": "bulletList", "content": [{"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Cable USB Imprimante:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Imprimante:", "type": "text"}]}]}, {"type": "listItem", "content": [{"type": "paragraph", "content": [{"text": "Cable éléctrique:", "type": "text"}]}]}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Electricité", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Bandeau éléctrique:", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Cable éléctrique:", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Lumière:", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}]}	Borne: Base: Pied: T&ecirc;te: Boulon: Housse: Carton: Serflex Informatique: Ordinateur: Ecran: Clavier: Hub ou multiprise USB: Appareil Photo: Cable USB Appareil Photo: Boitier Appareil Photo: Alimentation Appareil Photo: Fausse batterie Appareil Photo Imprimante: Cable USB Imprimante: Imprimante: Cable &eacute;l&eacute;ctrique: Electricit&eacute; Bandeau &eacute;l&eacute;ctrique: Cable &eacute;l&eacute;ctrique: Lumi&egrave;re:	DRAFT	133	2022-03-25 10:27:37	2026-05-26 07:57:11.627	\N	\N	\N
78	✅ Imprimante DNP QW410 : voyant POWER clignote en vert 	imprimante-dnp-qw410-voyant-power-clignote-en-vert-134	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	134	2022-05-02 12:34:47	2026-05-26 07:57:11.663	2022-05-02 12:34:47	\N	\N
79	✅ Changer le consommable dans l'imprimante DNP QW410	changer-le-consommable-dans-l-imprimante-dnp-qw410-139	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	139	2022-05-02 14:19:07	2026-05-26 07:57:11.689	\N	\N	\N
80	Mise à jour du logiciel requise!	mise-a-jour-du-logiciel-requise-140	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Si vous rencontrez le message \\"version logicielle obsolète\\".\\nNous vous conseillions de faire la mise à jour du logiciel.\\nPour cela sélectionner l'ongle OK.\\n\\nSélectionner METTRE A JOUR.\\nAttendre la fin du téléchargement.\\n\\nSélectionner METTRE A JOUR.\\n\\nLe logiciel va se couper se mettre à jour tout seul et redémarrer.", "type": "text"}]}]}	Si vous rencontrez le message "version logicielle obsol&egrave;te". Nous vous conseillions de faire la mise &agrave; jour du logiciel. Pour cela s&eacute;lectionner l'ongle OK. S&eacute;lectionner METTRE A JOUR. Attendre la fin du t&eacute;l&eacute;chargement. S&eacute;lectionner METTRE A JOUR. Le logiciel va se couper se mettre &agrave; jour tout seul et red&eacute;marrer.	PUBLISHED	140	2022-05-03 12:48:14	2026-05-26 07:57:11.719	2022-05-03 12:48:14	\N	\N
81	Mise à jour du logiciel "" borne ""	mise-a-jour-du-logiciel-borne-141	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Sélectionner METTRE A JOUR.\\nAttendre la fin du téléchargement.\\n\\nSélectionner METTRE A JOUR.\\n\\nLe logiciel va se couper se mettre à jour tout seul et redémarrer.", "type": "text"}]}]}	S&eacute;lectionner METTRE A JOUR. Attendre la fin du t&eacute;l&eacute;chargement. S&eacute;lectionner METTRE A JOUR. Le logiciel va se couper se mettre &agrave; jour tout seul et red&eacute;marrer.	PUBLISHED	141	2022-05-03 12:58:19	2026-05-26 07:57:11.746	2022-05-03 12:58:19	\N	\N
82	✅ L'ecran est bloqué	l-ecran-est-bloque-145	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	145	2022-05-03 15:21:34	2026-05-26 07:57:11.773	2022-05-03 15:21:34	\N	\N
83	Comment ajuster la taille du pied?	comment-ajuster-la-taille-du-pied-146	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "15 cm =TAILLE ENFANT\\n30 cm = TAILLE ADULTE\\n\\n", "type": "text"}]}]}	15 cm =TAILLE ENFANT 30 cm = TAILLE ADULTE	PUBLISHED	146	2022-05-03 15:33:30	2026-05-26 07:57:11.801	2022-05-03 15:33:30	\N	\N
90	✅ Connecter le clavier au photobooth	connecter-le-clavier-au-photobooth-175	\N	{"type": "doc", "content": [{"type": "paragraph", "content": [{"text": "Vous pouvez brancher votre clavier sur l'usb au niveau de la partie arrière gauche de la borne.", "type": "text"}]}]}	Vous pouvez brancher votre clavier sur l' usb au niveau de la partie arri&egrave;re gauche de la borne.	DRAFT	175	2022-05-04 13:05:25	2026-05-26 07:57:12.107	\N	\N	\N
91	⌛ Suivre l'envoi du photobooth	suivre-l-envoi-du-photobooth-177	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "ATTENTION ! : LA BORNE EST ENVOYEE EN DEUX CARTONS, VOUS AVEZ DONC DEUX COLIS A RECUPERER AU POINT RELAIS.\\nPour la livraison : La borne, divisez en deux colis, vous sera livrée à l’adresse de votre choix sélectionnée dans la liste des points relais UPS que vous trouverez sur ce lien: \\nhttps://www.ups.com/dropoff/?loc=fr_FR\\n\\n", "type": "text"}]}]}	ATTENTION ! : LA BORNE EST ENVOYEE EN DEUX CARTONS, VOUS AVEZ DONC DEUX COLIS A RECUPERER AU POINT RELAIS. Pour la livraison : La borne, divisez en deux colis, vous sera livr&eacute;e &agrave; l&rsquo;adresse de votre choix s&eacute;lectionn&eacute;e dans la liste des points relais UPS que vous trouverez sur ce lien: https://www.ups.com/dropoff/?loc=fr_FR	PUBLISHED	177	2022-05-04 15:01:51	2026-05-26 07:57:12.134	2022-05-04 15:01:51	\N	\N
92	Il faut une connexion internet?	il-faut-une-connexion-internet-179	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "La connexion internet (wifi ou 4g) n’est pas obligatoire pour le bon déroulement de l’animation. Les données sont stockées dans la borne. ", "type": "text"}]}]}	La connexion internet (wifi ou 4g ) n&rsquo;est pas obligatoire pour le bon d&eacute;roulement de l&rsquo;animation. Les donn&eacute;es sont stock&eacute;es dans la borne.	PUBLISHED	179	2022-05-04 15:23:46	2026-05-26 07:57:12.162	2022-05-04 15:23:46	\N	\N
93	Lorem ipsum	lorem-ipsum-180	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	180	2022-05-05 18:59:17	2026-05-26 07:57:12.188	\N	\N	\N
94	✅ Bourrage papier / papier coincé dans l'imprimante DNP QW410	bourrage-papier-papier-coince-dans-l-imprimante-dnp-qw410-181	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	181	2022-05-09 14:03:14	2026-05-26 07:57:12.216	2022-05-09 14:03:14	\N	\N
95	✅ Bourrage papier / papier coincé dans l'imprimante DNP DS620	bourrage-papier-papier-coince-dans-l-imprimante-dnp-ds620-182	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	182	2022-05-09 14:06:44	2026-05-26 07:57:12.243	2022-05-09 14:06:44	\N	\N
96	État du matériel.	etat-du-materiel-190	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Tout matériel mis à disposition au Client par KONITYS est réputé en bon état de fonctionnement, de\\nprésentation et d’entretien. Il est accompagné de la documentation technique nécessaire à sa bonne utilisation\\net à son entretien. Au moment de la mise à disposition de la borne SELFIZEE ou matériel annexe, le Client signe\\nla feuille de réception attestant de la réception du matériel et de son parfait état. Il appartient au Client de faire\\ntoute réserve qu’il estimerait nécessaire et notamment de reporter les éventuels défauts d’apparence ou les\\néléments manquants relatifs à sa commande. S’il n’a pas la feuille de mise à disposition, le Client doit écrire ses\\nremarques et éventuelles réclamations à l’adresse email : contact@konitys.fr. A défaut de réserve sur la feuille de\\nréception ou sur le bon d’enlèvement et de retour ou par email avant le début de l’animation, la borne SELFIZEE\\nsera réputée mise à disposition en parfait état d’apparence et de fonctionnement. En signant la feuille de\\nréception, le Client reconnaît qu’il sait parfaitement utiliser la borne SELFIZEE et qu’il a de fait lu la\\ndocumentation jointe (guide et conseils d’utilisation, d’installation et désinstallation)\\nCe bon de retrait, d’enlèvement et de retour sera à nouveau signé par les Parties lors du retour ou de\\nl’enlèvement de la borne SELFIZEE. En cas d’enlèvement ou de désinstallation par KONITYS et dans le cas d’une\\nnon-présence du Client à ce moment-là, les éléments reportés par KONITYS ou son sous-traitant seront\\nobligatoirement pris en compte car jugés de bonne foi. Il incombe au Client de faire le nécessaire pour être\\nprésent lors du retrait, de la livraison, de l’installation ou de l’enlèvement. KONITYS ne saura être tenu\\nresponsable de sa non-présence.", "type": "text"}]}]}	Tout mat&eacute;riel mis &agrave; disposition au Client par KONITYS est r&eacute;put&eacute; en bon &eacute;tat de fonctionnement, de pr&eacute;sentation et d&rsquo;entretien. Il est accompagn&eacute; de la documentation technique n&eacute;cessaire &agrave; sa bonne utilisation et &agrave; son entretien. Au moment de la mise &agrave; disposition de la borne SELFIZEE ou mat&eacute;riel annexe, le Client signe la feuille de r&eacute;ception attestant de la r&eacute;ception du mat&eacute;riel et de son parfait &eacute;tat. Il appartient au Client de faire toute r&eacute;serve qu&rsquo;il estimerait n&eacute;cessaire et notamment de reporter les &eacute;ventuels d&eacute;fauts d&rsquo;apparence ou les &eacute;l&eacute;ments manquants relatifs &agrave; sa commande. S&rsquo;il n&rsquo;a pas la feuille de mise &agrave; disposition, le Client doit &eacute;crire ses remarques et &eacute;ventuelles r&eacute;clamations &agrave; l&rsquo;adresse email : contact@konitys.fr. A d&eacute;faut de r&eacute;serve sur la feuille de r&eacute;ception ou sur le bon d&rsquo;enl&egrave;vement et de retour ou par email avant le d&eacute;but de l&rsquo;animation, la borne SELFIZEE sera r&eacute;put&eacute;e mise &agrave; disposition en parfait &eacute;tat d&rsquo;apparence et de fonctionnement. En signant la feuille de r&eacute;ception, le Client reconna&icirc;t qu&rsquo;il sait parfaitement utiliser la borne SELFIZEE et qu&rsquo;il a de fait lu la documentation jointe (guide et conseils d&rsquo;utilisation, d&rsquo;installation et d&eacute;sinstallation) Ce bon de retrait, d&rsquo;enl&egrave;vement et de retour sera &agrave; nouveau sign&eacute; par les Parties lors du retour ou de l&rsquo;enl&egrave;vement de la borne SELFIZEE. En cas d&rsquo;enl&egrave;vement ou de d&eacute;sinstallation par KONITYS et dans le cas d&rsquo;une non-pr&eacute;sence du Client &agrave; ce moment-l&agrave;, les &eacute;l&eacute;ments report&eacute;s par KONITYS ou son sous-traitant seront obligatoirement pris en compte car jug&eacute;s de bonne foi. Il incombe au Client de faire le n&eacute;cessaire pour &ecirc;tre pr&eacute;sent lors du retrait, de la livraison, de l&rsquo;installation ou de l&rsquo;enl&egrave;vement. KONITYS ne saura &ecirc;tre tenu responsable de sa non-pr&eacute;sence.	PUBLISHED	190	2022-05-13 07:56:41	2026-05-26 07:57:12.273	2022-05-13 07:56:41	\N	\N
97	MAIL	mail-191	\N	{"type": "doc", "content": [{"type": "heading", "attrs": {"level": 4}, "content": [{"text": "1 - Démarrer le logiciel Outlook", "type": "text"}]}, {"type": "heading", "attrs": {"level": 4}, "content": [{"text": "2 - Paramétrage de compte", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Sélectionner Fichier", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Paramètres de compte et encore Paramètres de compte", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Nouveau", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "IMAP", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Indiquer l'adresse mail puis sélectionner l'option avancées et cocher configurer mon compte manuellement. Puis sélectionner Connexion.", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Faire le paramétrage comme limage ci-dessous.", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Courier entrant", "type": "text"}, {"type": "hardBreak"}, {"text": "Serveur: mail.gandi.net ", "type": "text"}, {"type": "hardBreak"}, {"text": "Port: 143", "type": "text"}, {"type": "hardBreak"}, {"text": "Méthode de chiffrement: Aucun", "type": "text"}]}, {"type": "paragraph", "content": [{"text": "Courier sortant", "type": "text"}, {"type": "hardBreak"}, {"text": "Serveur: mail.gandi.net", "type": "text"}, {"type": "hardBreak"}, {"text": "Port: 25", "type": "text"}, {"type": "hardBreak"}, {"text": "Méthode de chiffrement: Aucun", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}, {"type": "paragraph", "content": [{"text": " et valider par suivant", "type": "text"}, {"type": "hardBreak"}, {"type": "hardBreak"}, {"text": "Indiquer le mot de passe fournis ", "type": "text"}, {"type": "hardBreak"}, {"text": "Sélectionner l'œil pour être sur d'avoir noté le bon mot de passe.", "type": "text"}, {"type": "hardBreak"}, {"text": "Valider par connexion et finir le paramétrage de votre boite mail.", "type": "text"}, {"type": "hardBreak"}]}, {"type": "paragraph", "content": [{"text": " ", "type": "text"}]}]}	1 - D&eacute;marrer le logiciel Outlook 2 - Param&eacute;trage de compte S&eacute;lectionner Fichier Param&egrave;tres de compte et encore Param&egrave;tres de compte Nouveau IMAP Indiquer l'adresse mail puis s&eacute;lectionner l'option avanc&eacute;es et cocher configurer mon compte manuellement. Puis s&eacute;lectionner Connexion. Faire le param&eacute;trage comme limage ci-dessous. Courier entrant Serveur: mail.gandi.net Port: 143 M&eacute;thode de chiffrement: Aucun Courier sortant Serveur: mail.gandi.net Port: 25 M&eacute;thode de chiffrement: Aucun et valider par suivant Indiquer le mot de passe fournis S&eacute;lectionner l'&oelig;il pour &ecirc;tre sur d'avoir not&eacute; le bon mot de passe. Valider par connexion et finir le param&eacute;trage de votre boite mail.	PUBLISHED	191	2022-05-13 09:50:58	2026-05-26 07:57:12.302	2022-05-13 09:50:58	\N	\N
98	Faire une rotation logicielle de l'image dans l'application "" borne ""	faire-une-rotation-logicielle-de-l-image-dans-l-application-borne-195	\N	{"type": "doc", "content": [{"type": "codeBlock", "attrs": {"language": null}, "content": [{"text": "Aller sur l'écran de la borne.\\nAppuyez 2 secondes l'angle en haut à gauche de l'écran ou appuyer sur la touche F2 de votre clavier.\\n\\nVous allez arriver sur l'espace administrateur.\\nAppuyez sur la touche \\"&123\\"\\n\\nSaisissez le mot de passe qui ne doit pas être fournis au client !\\"<>':;/? à l'aide du clavier.\\n\\n\\nAppuyez sur l'icone en bas à droite.\\n\\nAppuyez sur l'icone \\"IMAGE\\".\\nAppuyez sur l'icone \\"REGLAGE DE L'IMAGE\\".\\nAppuyez sur l'icone \\"REGLAGE DE L'IMAGE\\".\\n\\nAppuyez sur le bouton -90° 0° 90° pour changer la rotation de l'image.\\n\\nAppuyez sur l'icone en haut a gauche.\\n\\nAppuyez sur l'icone en haut a gauche.\\n\\nAppuyez sur l'icone en haut a gauche pour revenir sur votre événement.\\n", "type": "text"}]}]}	Aller sur l'&eacute;cran de la borne. Appuyez 2 secondes l'angle en haut &agrave; gauche de l'&eacute;cran ou appuyer sur la touche F2 de votre clavier. Vous allez arriver sur l'espace administrateur. Appuyez sur la touche "&123" Saisissez le mot de passe qui ne doit pas &ecirc;tre fournis au client !"<>':;/? &agrave; l'aide du clavier. Appuyez sur l'icone en bas &agrave; droite. Appuyez sur l'icone "IMAGE". Appuyez sur l'icone "REGLAGE DE L'IMAGE". Appuyez sur l'icone "REGLAGE DE L'IMAGE". Appuyez sur le bouton -90&deg; 0&deg; 90&deg; pour changer la rotation de l'image. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche. Appuyez sur l'icone en haut a gauche pour revenir sur votre &eacute;v&eacute;nement.	PUBLISHED	195	2022-05-18 07:31:51	2026-05-26 07:57:12.329	2022-05-18 07:31:51	\N	\N
99	✅ La lumière ou l'écran ne s'allume pas 	la-lumiere-ou-l-ecran-ne-s-allume-pas-201	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	201	2022-05-18 15:48:04	2026-05-26 07:57:12.354	2022-05-18 15:48:04	\N	\N
101	Comment ouvrir le capot arrière de la borne Classik ?	comment-ouvrir-le-capot-arriere-de-la-borne-classik-203	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	203	2022-05-20 08:20:33	2026-05-26 07:57:12.409	2022-05-20 08:20:33	\N	\N
102	✅ Problème avec l'impression : l'imprimante DNP QW410 est "hors connexion"	probleme-avec-l-impression-l-imprimante-dnp-qw410-est-hors-connexion-208	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	208	2023-06-30 13:55:50	2026-05-26 07:57:12.438	2023-06-30 13:55:50	\N	\N
103	✅ Le ruban d'encre est déchiré / coupé en deux	le-ruban-d-encre-est-dechire-coupe-en-deux-209	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	209	2023-06-30 13:58:08	2026-05-26 07:57:12.464	2023-06-30 13:58:08	\N	\N
104	⌛ Mes photos et/ou vidéos n'apparaissent pas sur ma galerie en ligne	mes-photos-et-ou-videos-n-apparaissent-pas-sur-ma-galerie-en-ligne-211	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	211	2023-07-24 10:27:15	2026-05-26 07:57:12.52	2023-07-24 10:27:15	\N	\N
105	⌛ Je ne reçois pas mes photos par mail	je-ne-recois-pas-mes-photos-par-mail-213	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	213	2023-07-24 10:28:01	2026-05-26 07:57:12.548	2023-07-24 10:28:01	\N	\N
106	⌛ Un élément est apparent sur mon cadre photo	un-element-est-apparent-sur-mon-cadre-photo-214	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	214	2023-07-24 10:28:38	2026-05-26 07:57:12.575	2023-07-24 10:28:38	\N	\N
107	⌛ Mon cadre photo n'est pas le même que celui que j'ai configuré	mon-cadre-photo-n-est-pas-le-meme-que-celui-que-j-ai-configure-218	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	218	2023-07-24 10:37:25	2026-05-26 07:57:12.603	2023-07-24 10:37:25	\N	\N
108	⌛ Installation Pickloud	installation-pickloud-219	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	219	2023-07-24 12:26:08	2026-05-26 07:57:12.63	2023-07-24 12:26:08	\N	\N
109	✅ Le ruban d'encre est coincé dans l'imprimante DNP QW410	le-ruban-d-encre-est-coince-dans-l-imprimante-dnp-qw410-220	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	220	2023-07-24 12:39:21	2026-05-26 07:57:12.659	2023-07-24 12:39:21	\N	\N
110	✅ Le ruban d'encre est coincé dans l'imprimante DNP DS620	le-ruban-d-encre-est-coince-dans-l-imprimante-dnp-ds620-221	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	221	2023-07-24 12:39:48	2026-05-26 07:57:12.686	2023-07-24 12:39:48	\N	\N
111	✅ La borne n'imprime pas 	la-borne-n-imprime-pas-223	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	223	2023-08-30 14:00:34	2026-05-26 07:57:12.714	2023-08-30 14:00:34	\N	\N
112	✅ Allumer l'écran du photobooth	allumer-l-ecran-du-photobooth-225	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	225	2023-08-30 14:05:06	2026-05-26 07:57:12.752	2023-08-30 14:05:06	\N	\N
113	✅ Éteindre l'écran du photobooth	eteindre-l-ecran-du-photobooth-226	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	226	2023-08-30 14:05:26	2026-05-26 07:57:12.78	2023-08-30 14:05:26	\N	\N
114	✅ Le logiciel apparaît dans une fenêtre réduite	le-logiciel-apparait-dans-une-fenetre-reduite-227	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	227	2023-08-30 14:07:03	2026-05-26 07:57:12.807	2023-08-30 14:07:03	\N	\N
115	✅ Installer le photobooth Spherik Original	installer-le-photobooth-spherik-original-228	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	228	2023-08-30 14:08:17	2026-05-26 07:57:12.835	2023-08-30 14:08:17	\N	\N
116	✅ Désinstaller le photobooth	desinstaller-le-photobooth-229	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	229	2023-08-30 14:14:14	2026-05-26 07:57:12.863	2023-08-30 14:14:14	\N	\N
117	✅ L'ecran est bloqué	l-ecran-est-bloque-231	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	231	2023-08-31 07:43:00	2026-05-26 07:57:12.891	2023-08-31 07:43:00	\N	\N
118	✅ Connecter électriquement la tête du photobooth	connecter-electriquement-la-tete-du-photobooth-232	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	232	2023-08-31 12:51:10	2026-05-26 07:57:12.918	2023-08-31 12:51:10	\N	\N
119	✅ Connecter électriquement l'imprimante DNP QW410	connecter-electriquement-l-imprimante-dnp-qw410-233	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	233	2023-08-31 12:51:51	2026-05-26 07:57:12.946	2023-08-31 12:51:51	\N	\N
120	⌛ 	-234	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	234	2023-09-18 10:08:30	2026-05-26 07:57:12.99	\N	\N	\N
121	✅  Les photos sont sombres	les-photos-sont-sombres-235	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	235	2023-09-18 10:09:22	2026-05-26 07:57:13.046	2023-09-18 10:09:22	\N	\N
122	✅ La prise photo est mal réglé	la-prise-photo-est-mal-regle-236	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	236	2023-09-18 10:10:32	2026-05-26 07:57:13.084	2023-09-18 10:10:32	\N	\N
123	✅  L'angle de la prise photo est mal réglé	l-angle-de-la-prise-photo-est-mal-regle-237	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	237	2023-09-18 10:11:21	2026-05-26 07:57:13.113	2023-09-18 10:11:21	\N	\N
124	✅ Changer la nappe de l'imprimante DNP QW410	changer-la-nappe-de-l-imprimante-dnp-qw410-238	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	238	2023-09-18 15:03:03	2026-05-26 07:57:13.14	2023-09-18 15:03:03	\N	\N
125	✅ Imprimante DNP QW410 : voyant POWER allumé en vert et ERROR clignote en rouge	imprimante-dnp-qw410-voyant-power-allume-en-vert-et-error-clignote-en-rouge-239	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	239	2023-09-19 08:10:07	2026-05-26 07:57:13.168	2023-09-19 08:10:07	\N	\N
126	✅ Imprimante DNP QW410 : voyant POWER allumé en vert et ERROR clignote en orange	imprimante-dnp-qw410-voyant-power-allume-en-vert-et-error-clignote-en-orange-240	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	240	2023-09-19 10:14:01	2026-05-26 07:57:13.229	2023-09-19 10:14:01	\N	\N
127	✅ Imprimante DNP QW410 : voyant POWER allumé en vert et ERROR clignote en rouge et orange	imprimante-dnp-qw410-voyant-power-allume-en-vert-et-error-clignote-en-rouge-et-o-241	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	241	2023-09-19 10:15:38	2026-05-26 07:57:13.262	2023-09-19 10:15:38	\N	\N
128	✅ Imprimante DNP QW410 : voyant POWER allumé en vert et ERROR allumé en rouge	imprimante-dnp-qw410-voyant-power-allume-en-vert-et-error-allume-en-rouge-242	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	242	2023-09-19 10:16:26	2026-05-26 07:57:13.289	2023-09-19 10:16:26	\N	\N
129	⌛ L'écran du photobooth se met en veille	l-ecran-du-photobooth-se-met-en-veille-243	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	243	2023-09-19 10:51:55	2026-05-26 07:57:13.317	2023-09-19 10:51:55	\N	\N
130	✅ Préparer les colis pour le retour du photobooth	preparer-les-colis-pour-le-retour-du-photobooth-244	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	244	2023-09-19 13:50:39	2026-05-26 07:57:13.345	2023-09-19 13:50:39	\N	\N
131	✅ Démonter les éléments du photobooth	demonter-les-elements-du-photobooth-245	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	245	2023-09-20 07:45:18	2026-05-26 07:57:13.372	2023-09-20 07:45:18	\N	\N
132	✅ Connecter le clavier au photobooth	connecter-le-clavier-au-photobooth-247	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	247	2023-10-23 14:45:07	2026-05-26 07:57:13.4	2023-10-23 14:45:07	\N	\N
133	✅ Allumer le photobooth	allumer-le-photobooth-248	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	248	2023-10-23 14:47:03	2026-05-26 07:57:13.428	2023-10-23 14:47:03	\N	\N
135	✅Allumer le PC manuellement	allumer-le-pc-manuellement-251	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	251	2023-10-23 14:50:59	2026-05-26 07:57:13.483	2023-10-23 14:50:59	\N	\N
136	✅ Installer le consommable dans l'imprimante DNP DS620	installer-le-consommable-dans-l-imprimante-dnp-ds620-252	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	252	2023-10-23 14:53:56	2026-05-26 07:57:13.511	2023-10-23 14:53:56	\N	\N
137	✅Problème avec l'impression : l'imprimante DNP DS620 est "hors connexion"	probleme-avec-l-impression-l-imprimante-dnp-ds620-est-hors-connexion-253	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	253	2023-10-23 14:57:24	2026-05-26 07:57:13.538	2023-10-23 14:57:24	\N	\N
138	✅ Le ruban d'encre est déchiré / coupé en deux	le-ruban-d-encre-est-dechire-coupe-en-deux-254	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	254	2023-10-23 14:58:49	2026-05-26 07:57:13.566	2023-10-23 14:58:49	\N	\N
139	✅ Imprimante DNP DS620 : voyant POWER allumé en vert et PAPER clignote en orange	imprimante-dnp-ds620-voyant-power-allume-en-vert-et-paper-clignote-en-orange-255	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	255	2023-10-23 15:01:41	2026-05-26 07:57:13.594	2023-10-23 15:01:41	\N	\N
140	✅ Imprimante DNP DS620 : voyant POWER allumé en vert et RIBBON clignote en orange	imprimante-dnp-ds620-voyant-power-allume-en-vert-et-ribbon-clignote-en-orange-256	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	256	2023-10-23 15:02:30	2026-05-26 07:57:13.621	2023-10-23 15:02:30	\N	\N
141	✅ Imprimante DNP DS620 : voyant POWER allumé en vert, PAPER clignote en orange et ERROR clignote en rouge	imprimante-dnp-ds620-voyant-power-allume-en-vert-paper-clignote-en-orange-et-err-257	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	257	2023-10-23 15:03:42	2026-05-26 07:57:13.649	2023-10-23 15:03:42	\N	\N
142	✅ Imprimante DNP DS620 : voyant POWER allumé en vert et ERROR clignote en rouge	imprimante-dnp-ds620-voyant-power-allume-en-vert-et-error-clignote-en-rouge-258	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	258	2023-10-23 15:04:29	2026-05-26 07:57:13.677	2023-10-23 15:04:29	\N	\N
143	✅ Imprimante DNP DS620 : voyant POWER allumé en vert, PAPER allumé en orange et ERROR allumé en rouge	imprimante-dnp-ds620-voyant-power-allume-en-vert-paper-allume-en-orange-et-error-259	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	259	2023-10-23 15:06:43	2026-05-26 07:57:13.704	2023-10-23 15:06:43	\N	\N
144	✅ Imprimante DNP DS620 : voyant POWER allumé en vert, RIBBON allumé en orange et ERROR allumé en rouge	imprimante-dnp-ds620-voyant-power-allume-en-vert-ribbon-allume-en-orange-et-erro-260	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	260	2023-10-23 15:07:14	2026-05-26 07:57:13.778	2023-10-23 15:07:14	\N	\N
145	✅ Imprimante DNP DS620 : voyant POWER allumé en vert, RIBBON clignote en orange et PAPER clignote en orange	imprimante-dnp-ds620-voyant-power-allume-en-vert-ribbon-clignote-en-orange-et-pa-261	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	261	2023-10-23 15:08:26	2026-05-26 07:57:13.821	2023-10-23 15:08:26	\N	\N
146	✅ Imprimante DNP DS620 : voyant POWER allumé en vert et ERROR allumé en rouge	imprimante-dnp-ds620-voyant-power-allume-en-vert-et-error-allume-en-rouge-262	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	262	2023-10-23 15:09:03	2026-05-26 07:57:13.854	2023-10-23 15:09:03	\N	\N
147	✅ Imprimante DNP DS620 : voyant POWER clignote en vert	imprimante-dnp-ds620-voyant-power-clignote-en-vert-263	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	263	2023-10-23 15:10:42	2026-05-26 07:57:13.887	2023-10-23 15:10:42	\N	\N
148	✅ Installer le photobooth	installer-le-photobooth-264	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	264	2023-10-26 14:27:33	2026-05-26 07:57:13.92	2023-10-26 14:27:33	\N	\N
149	✅ Désinstaller le photobooth	desinstaller-le-photobooth-265	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	265	2023-10-26 14:27:58	2026-05-26 07:57:13.954	2023-10-26 14:27:58	\N	\N
150	✅ Installer le photobooth Spherik Prestige 410+	installer-le-photobooth-spherik-prestige-410-266	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	266	2023-10-27 07:48:24	2026-05-26 07:57:13.987	2023-10-27 07:48:24	\N	\N
151	✅ Installer le photobooth Spherik Prestige 620+	installer-le-photobooth-spherik-prestige-620-267	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	267	2023-10-27 07:55:52	2026-05-26 07:57:14.02	2023-10-27 07:55:52	\N	\N
152	✅ Configurer l'appareil photo sur le logiciel Selfizee	configurer-l-appareil-photo-sur-le-logiciel-selfizee-269	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	269	2023-10-27 14:06:54	2026-05-26 07:57:14.053	2023-10-27 14:06:54	\N	\N
153	✅ L'écran du photobooth affiche "BORNE HORS SERVICE"	l-ecran-du-photobooth-affiche-borne-hors-service-270	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	270	2023-10-30 08:12:48	2026-05-26 07:57:14.086	2023-10-30 08:12:48	\N	\N
154	✅ Démonter les éléments du photobooth	demonter-les-elements-du-photobooth-271	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	271	2023-10-30 15:01:09	2026-05-26 07:57:14.12	2023-10-30 15:01:09	\N	\N
155	✅ Le clavier tactile n'apparaît pas sur l'écran	le-clavier-tactile-n-apparait-pas-sur-l-ecran-272	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	272	2023-10-30 15:48:29	2026-05-26 07:57:14.153	2023-10-30 15:48:29	\N	\N
156	✅Purger une imprimante	purger-une-imprimante-273	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	273	2024-11-18 15:49:42	2026-05-26 07:57:14.186	2024-11-18 15:49:42	\N	\N
157	✅ Inversion des fils 	inversion-des-fils-274	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	274	2024-12-23 14:48:32	2026-05-26 07:57:14.219	2024-12-23 14:48:32	\N	\N
158	✅ Installer votre réceptacle	installer-votre-receptacle-275	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	275	2024-12-24 10:21:11	2026-05-26 07:57:14.252	2024-12-24 10:21:11	\N	\N
159	✅ Le logiciel crash/plante 	le-logiciel-crash-plante-276	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	276	2024-12-24 15:05:53	2026-05-26 07:57:14.286	2024-12-24 15:05:53	\N	\N
160	✅ Programmer une tablette	programmer-une-tablette-277	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	277	2024-12-30 15:59:57	2026-05-26 07:57:14.319	2024-12-30 15:59:57	\N	\N
161	✅Régler la hauteur du trépied	regler-la-hauteur-du-trepied-278	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	278	2024-12-31 09:37:04	2026-05-26 07:57:14.352	2024-12-31 09:37:04	\N	\N
162	✅L'imprimante n'est pas reconnue	l-imprimante-n-est-pas-reconnue-279	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	279	2024-12-31 09:59:00	2026-05-26 07:57:14.385	2024-12-31 09:59:00	\N	\N
163	⌛Comment activer/désactiver les filtres photo ? 	comment-activer-desactiver-les-filtres-photo-280	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	280	2024-12-31 11:19:34	2026-05-26 07:57:14.419	\N	\N	\N
164	⌛Configuration d'une Mosaïk	configuration-d-une-mosaik-281	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	281	2024-12-31 15:02:29	2026-05-26 07:57:14.452	\N	\N	\N
165	✅ Tous les paramètres ont sauté 	tous-les-parametres-ont-saute-282	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	282	2025-01-02 09:14:24	2026-05-26 07:57:14.485	2025-01-02 09:14:24	\N	\N
166	Comment récupérer les photos originales ?	comment-recuperer-les-photos-originales-283	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	283	2025-01-02 09:55:49	2026-05-26 07:57:14.518	\N	\N	\N
167	⌛Comment récupérer les photos originales d'une galerie ? 	comment-recuperer-les-photos-originales-d-une-galerie-284	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	284	2025-01-02 10:37:50	2026-05-26 07:57:14.563	\N	\N	\N
168	Comment récupérer les photos originales d'une galerie ? 	comment-recuperer-les-photos-originales-d-une-galerie-285	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	285	2025-01-02 11:06:02	2026-05-26 07:57:14.596	\N	\N	\N
169	test	test-286	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	286	2025-01-02 11:16:16	2026-05-26 07:57:14.629	\N	\N	\N
170	⏳Comment récupérer les photos originales ? 	comment-recuperer-les-photos-originales-287	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	287	2025-01-02 11:24:20	2026-05-26 07:57:14.673	\N	\N	\N
171	⏳Comment mettre un nouveau cadre sur des photos vierges ?	comment-mettre-un-nouveau-cadre-sur-des-photos-vierges-288	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	288	2025-01-02 14:14:15	2026-05-26 07:57:14.707	\N	\N	\N
172	⏳Comment mettre à jour mon événement ?	comment-mettre-a-jour-mon-evenement-289	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	289	2025-01-06 12:02:06	2026-05-26 07:57:14.74	\N	\N	\N
173	⏳Comment régler le décompte photo ?	comment-regler-le-decompte-photo-290	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	290	2025-01-06 13:16:28	2026-05-26 07:57:14.773	\N	\N	\N
174	⌛Comment activer/désactiver l'impression et l'impression multiple ?	comment-activer-desactiver-l-impression-et-l-impression-multiple-291	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	291	2025-01-06 14:40:11	2026-05-26 07:57:14.806	\N	\N	\N
175	⌛Comment activer/désactiver l'effet miroir ?	comment-activer-desactiver-l-effet-miroir-292	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	292	2025-01-06 15:04:35	2026-05-26 07:57:14.84	\N	\N	\N
176	⏳Comment activer/désactiver l'effet miroir ? 	comment-activer-desactiver-l-effet-miroir-293	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	293	2025-01-06 15:25:44	2026-05-26 07:57:14.872	\N	\N	\N
177	✅ Régler le décompte photo	regler-le-decompte-photo-294	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	294	2025-01-06 15:43:52	2026-05-26 07:57:14.906	2025-01-06 15:43:52	\N	\N
178	✅ Modifier les filtres de couleurs	modifier-les-filtres-de-couleurs-295	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	295	2025-01-07 10:06:46	2026-05-26 07:57:14.939	2025-01-07 10:06:46	\N	\N
179	✅ Activer/désactiver l'effet miroir	activer-desactiver-l-effet-miroir-296	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	296	2025-01-07 10:20:26	2026-05-26 07:57:14.972	2025-01-07 10:20:26	\N	\N
180	✅ Activer/désactiver l'impression et l'impression multiple	activer-desactiver-l-impression-et-l-impression-multiple-297	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	297	2025-01-07 11:13:04	2026-05-26 07:57:15.005	2025-01-07 11:13:04	\N	\N
181	⌛Comment activer/désactiver les filtres ?	comment-activer-desactiver-les-filtres-298	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	298	2025-01-07 11:50:57	2026-05-26 07:57:15.039	\N	\N	\N
182	✅ Mettre à jour mon événement	mettre-a-jour-mon-evenement-299	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	299	2025-01-07 14:25:57	2026-05-26 07:57:15.072	2025-01-07 14:25:57	\N	\N
183	✅ Les paramètres ont sauté	les-parametres-ont-saute-300	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	300	2025-01-07 14:42:56	2026-05-26 07:57:15.105	2025-01-07 14:42:56	\N	\N
184	⏳ Le logiciel crache 	le-logiciel-crache-301	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	301	2025-01-07 14:53:02	2026-05-26 07:57:15.138	\N	\N	\N
185	⌛Le téléchargement de l'événement ne fonctionne pas	le-telechargement-de-l-evenement-ne-fonctionne-pas-302	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	302	2025-01-07 16:22:04	2026-05-26 07:57:15.172	\N	\N	\N
186	✅ Le téléchargement de l'événement ne fonctionne pas	le-telechargement-de-l-evenement-ne-fonctionne-pas-303	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	303	2025-01-08 09:10:54	2026-05-26 07:57:15.205	2025-01-08 09:10:54	\N	\N
187	✅ Les photos sont trop claires/lumineuses 	les-photos-sont-trop-claires-lumineuses-304	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	304	2025-01-08 10:23:34	2026-05-26 07:57:15.238	2025-01-08 10:23:34	\N	\N
188	Accédez à l'espace administration	accedez-a-l-espace-administration-305	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	305	2025-01-09 14:58:59	2026-05-26 07:57:15.271	\N	\N	\N
189	⏳un doute sur les différents formats ? 	un-doute-sur-les-differents-formats-306	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	306	2025-01-16 13:53:46	2026-05-26 07:57:15.305	\N	\N	\N
190	✅ Démonter et remonter la tête de borne 	demonter-et-remonter-la-tete-de-borne-307	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	307	2025-01-20 11:18:42	2026-05-26 07:57:15.337	2025-01-20 11:18:42	\N	\N
191	✅Purger l'imprimante	purger-l-imprimante-308	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	308	2025-01-20 13:21:32	2026-05-26 07:57:15.371	2025-01-20 13:21:32	\N	\N
192	⌛ Plusieurs photos s'impriment sans s'arrêter	plusieurs-photos-s-impriment-sans-s-arreter-309	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	309	2025-01-20 13:41:11	2026-05-26 07:57:15.404	\N	\N	\N
193	⏳ La tablette s'allume mais pas la lumière ? 	la-tablette-s-allume-mais-pas-la-lumiere-310	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	310	2025-01-21 10:45:09	2026-05-26 07:57:15.438	\N	\N	\N
194	✅ Changer la palette de couleur pour les imprimantes QW410	changer-la-palette-de-couleur-pour-les-imprimantes-qw410-311	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	311	2025-08-07 07:50:15	2026-05-26 07:57:15.492	2025-08-07 07:50:15	\N	\N
195	✅Changer la palette de couleur pour les imprimantes DS620	changer-la-palette-de-couleur-pour-les-imprimantes-ds620-312	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	312	2025-08-07 08:16:58	2026-05-26 07:57:15.526	2025-08-07 08:16:58	\N	\N
196	✅Bourrage papier ++ / papier coincé dans l'imprimante DNP DS620	bourrage-papier-papier-coince-dans-l-imprimante-dnp-ds620-313	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	313	2025-08-07 09:27:39	2026-05-26 07:57:15.559	2025-08-07 09:27:39	\N	\N
197	✅Modifier l'ouverture de la focale de l'appareil photo	modifier-l-ouverture-de-la-focale-de-l-appareil-photo-314	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	314	2025-08-07 09:38:51	2026-05-26 07:57:15.592	2025-08-07 09:38:51	\N	\N
198	✅ Les photos sont floues	les-photos-sont-floues-315	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	315	2025-08-07 12:22:44	2026-05-26 07:57:15.625	2025-08-07 12:22:44	\N	\N
199	✅ Paramétrer un appareil photo M200	parametrer-un-appareil-photo-m200-316	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	316	2025-08-07 13:05:01	2026-05-26 07:57:15.659	2025-08-07 13:05:01	\N	\N
200	✅ Brancher la borne photo	brancher-la-borne-photo-317	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	317	2025-09-22 14:09:39	2026-05-26 07:57:15.692	2025-09-22 14:09:39	\N	\N
201	✅ Papier coincé dans l'imprimante DNP DS620	papier-coince-dans-l-imprimante-dnp-ds620-318	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	318	2026-01-12 11:05:02	2026-05-26 07:57:15.736	2026-01-12 11:05:02	\N	\N
202	✅ Nettoyer une imprimante QW410	nettoyer-une-imprimante-qw410-319	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	319	2026-01-19 17:02:58	2026-05-26 07:57:15.769	2026-01-19 17:02:58	\N	\N
203	✅ Installer la borne photo Glenao	installer-la-borne-photo-glenao-320	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	320	2026-01-21 14:16:03	2026-05-26 07:57:15.803	2026-01-21 14:16:03	\N	\N
204	✅Vider les événements passés	vider-les-evenements-passes-321	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	321	2026-02-02 14:11:13	2026-05-26 07:57:15.836	2026-02-02 14:11:13	\N	\N
205	Autoriser une application bloquée dans sécurité Windows 10 et 11	autoriser-une-application-bloquee-dans-securite-windows-10-et-11-322	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	322	2026-03-02 14:06:29	2026-05-26 07:57:15.869	2026-03-02 14:06:29	\N	\N
206	⌛Quel est le format de l'écran d'accueil ? 	quel-est-le-format-de-l-ecran-d-accueil-323	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		DRAFT	323	2026-04-16 13:44:35	2026-05-26 07:57:15.902	\N	\N	\N
207	✅ Faire les mises à jour Windows 	faire-les-mises-a-jour-windows-324	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	324	2026-04-21 08:05:43	2026-05-26 07:57:15.993	2026-04-21 08:05:43	\N	\N
208	✅ Supprimer des événements de la borne photo	supprimer-des-evenements-de-la-borne-photo-325	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	325	2026-04-21 09:08:22	2026-05-26 07:57:16.024	2026-04-21 09:08:22	\N	\N
209	✅ Gabarit pour l'écran d'accueil 	gabarit-pour-l-ecran-d-accueil-326	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	326	2026-04-21 09:45:32	2026-05-26 07:57:16.058	2026-04-21 09:45:32	\N	\N
210	✅ Gabarits magnets 	gabarits-magnets-327	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	327	2026-04-21 09:58:23	2026-05-26 07:57:16.09	2026-04-21 09:58:23	\N	\N
211	✅ Nettoyer une imprimante DS620	nettoyer-une-imprimante-ds620-328	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	328	2026-05-06 08:59:21	2026-05-26 07:57:16.124	2026-05-06 08:59:21	\N	\N
212	✅ Gabarit pour l'écran d'accueil 	gabarit-pour-l-ecran-d-accueil-329	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	329	2026-05-06 09:32:15	2026-05-26 07:57:16.157	2026-05-06 09:32:15	\N	\N
213	✅ Gabarits magnets 	gabarits-magnets-330	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	330	2026-05-06 09:35:54	2026-05-26 07:57:16.19	2026-05-06 09:35:54	\N	\N
214	✅Ajouter l'option TPA sur le manager	ajouter-l-option-tpa-sur-le-manager-331	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	331	2026-05-06 10:12:00	2026-05-26 07:57:16.223	2026-05-06 10:12:00	\N	\N
215	✅Accès aux paiements TPE	acces-aux-paiements-tpe-332	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	332	2026-05-06 10:44:05	2026-05-26 07:57:16.257	2026-05-06 10:44:05	\N	\N
216	✅Créer un accès	creer-un-acces-333	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	333	2026-05-06 12:17:00	2026-05-26 07:57:16.29	2026-05-06 12:17:00	\N	\N
217	✅Créer un événement 	creer-un-evenement-334	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	334	2026-05-06 12:39:59	2026-05-26 07:57:16.323	2026-05-06 12:39:59	\N	\N
218	✅Réinstallez le logiciel Selfizee	reinstallez-le-logiciel-selfizee-335	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	335	2026-05-06 13:19:12	2026-05-26 07:57:16.356	2026-05-06 13:19:12	\N	\N
219	✅Récupérer les photos HD sans cadre 	recuperer-les-photos-hd-sans-cadre-336	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	336	2026-05-06 14:06:05	2026-05-26 07:57:16.39	2026-05-06 14:06:05	\N	\N
220	✅Fixer le support mural	fixer-le-support-mural-337	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	337	2026-05-07 08:16:48	2026-05-26 07:57:16.423	2026-05-07 08:16:48	\N	\N
221	✅ Parcours client Eclipso	parcours-client-eclipso-338	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	338	2026-05-07 08:37:05	2026-05-26 07:57:16.456	2026-05-07 08:37:05	\N	\N
222	✅ Changer le consommable dans l'imprimante DNP DS620 - ECLIPSO	changer-le-consommable-dans-l-imprimante-dnp-ds620-eclipso-339	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	339	2026-05-07 08:49:37	2026-05-26 07:57:16.489	2026-05-07 08:49:37	\N	\N
223	✅Bourrage papier - ECLIPSO	bourrage-papier-eclipso-340	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	340	2026-05-07 12:27:12	2026-05-26 07:57:16.522	2026-05-07 12:27:12	\N	\N
224	✅ Réseau indisponible sur le Kiosk 	reseau-indisponible-sur-le-kiosk-341	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	341	2026-05-07 13:06:35	2026-05-26 07:57:16.555	2026-05-07 13:06:35	\N	\N
225	✅ Installation du kiosk	installation-du-kiosk-342	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	342	2026-05-07 13:23:50	2026-05-26 07:57:16.589	2026-05-07 13:23:50	\N	\N
226	✅ Installation de labo d'impression 	installation-de-labo-d-impression-343	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	343	2026-05-07 13:49:31	2026-05-26 07:57:16.622	2026-05-07 13:49:31	\N	\N
227	✅ Allumer ou régler l'intensité de la lumière sur le photobooth Spherik - ECLIPSO	allumer-ou-regler-l-intensite-de-la-lumiere-sur-le-photobooth-spherik-eclipso-344	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	344	2026-05-07 14:34:42	2026-05-26 07:57:16.655	2026-05-07 14:34:42	\N	\N
228	✅ Personnaliser un cadre photo	personnaliser-un-cadre-photo-345	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	345	2026-05-12 13:55:42	2026-05-26 07:57:16.688	2026-05-12 13:55:42	\N	\N
229	✅Créer un instant gagnant	creer-un-instant-gagnant-346	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	346	2026-05-13 09:31:09	2026-05-26 07:57:16.722	2026-05-13 09:31:09	\N	\N
230	✅ Activer l'option code d'impression 	activer-l-option-code-d-impression-347	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	347	2026-05-13 13:02:45	2026-05-26 07:57:16.755	2026-05-13 13:02:45	\N	\N
231	✅ Activer des suggestions de noms de domaines e-mail 	activer-des-suggestions-de-noms-de-domaines-e-mail-348	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	348	2026-05-13 14:56:24	2026-05-26 07:57:16.788	2026-05-13 14:56:24	\N	\N
232	✅ Envoyer la galerie photo au client	envoyer-la-galerie-photo-au-client-349	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	349	2026-05-18 10:37:03	2026-05-26 07:57:16.821	2026-05-18 10:37:03	\N	\N
233	✅ Activer la collecte de donnée	activer-la-collecte-de-donnee-350	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	350	2026-05-18 12:22:21	2026-05-26 07:57:16.855	2026-05-18 12:22:21	\N	\N
234	✅ Activer la création de scénario "langues"	activer-la-creation-de-scenario-langues-351	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	351	2026-05-18 13:35:42	2026-05-26 07:57:16.888	2026-05-18 13:35:42	\N	\N
235	✅ Mise en palette	mise-en-palette-352	\N	{"type": "doc", "content": [{"type": "paragraph"}]}		PUBLISHED	352	2026-05-19 12:38:42	2026-05-26 07:57:16.921	2026-05-19 12:38:42	\N	\N
\.


--
-- Data for Name: PostAttachment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PostAttachment" (id, "postId", filename, "originalName", "mimeType", "sizeBytes", "storagePath", label, "legacyId", "createdAt") FROM stdin;
\.


--
-- Data for Name: PostCategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PostCategory" (id, "postId", "categoryId", "subCategoryId", "subSubCategoryId") FROM stdin;
1	1	1	1	\N
2	4	4	10	\N
3	5	4	8	\N
4	6	4	8	\N
5	7	4	8	\N
6	8	4	8	\N
7	9	4	8	\N
8	10	4	8	\N
9	11	4	8	\N
10	12	4	8	\N
11	13	4	8	\N
12	14	4	8	\N
13	15	4	8	\N
14	16	4	8	\N
15	17	4	8	\N
16	18	4	8	\N
17	19	2	2	7
18	20	4	8	\N
19	21	3	3	2
20	22	4	11	\N
21	23	4	11	\N
22	24	4	11	\N
23	25	4	11	\N
24	26	4	11	\N
25	27	4	11	\N
26	28	3	3	2
27	29	2	2	7
28	30	3	3	8
29	31	2	2	7
30	32	3	3	8
31	3	2	2	9
32	2	3	3	10
33	33	4	8	\N
34	34	4	10	\N
35	35	4	11	\N
36	36	6	12	\N
37	37	6	12	\N
38	38	6	12	\N
39	39	6	12	\N
40	40	6	13	\N
41	41	4	11	\N
42	42	2	2	\N
43	43	3	3	\N
44	44	4	11	\N
45	45	4	8	\N
46	46	4	\N	\N
47	47	4	8	\N
48	48	4	8	\N
49	49	6	\N	\N
50	50	6	12	\N
51	51	2	\N	\N
52	52	3	\N	\N
53	53	5	25	\N
54	54	4	11	\N
55	55	5	22	\N
56	56	2	2	\N
57	57	5	22	\N
58	58	5	22	\N
59	59	5	25	\N
60	60	5	22	\N
61	61	5	22	\N
62	62	5	24	\N
63	63	5	22	\N
64	64	5	26	\N
65	65	5	\N	\N
66	66	5	\N	\N
67	67	5	26	\N
68	68	5	24	\N
69	69	5	24	\N
70	70	5	25	\N
71	71	5	25	\N
72	72	5	26	\N
73	73	5	24	\N
74	74	5	26	\N
75	75	5	26	\N
76	76	4	11	\N
77	78	2	2	7
78	80	4	8	\N
79	81	4	8	\N
80	82	3	3	4
81	83	2	2	\N
82	84	2	4	\N
83	85	2	2	\N
84	86	3	3	6
85	87	7	21	\N
86	88	7	21	\N
87	89	2	2	3
88	92	5	23	\N
89	93	7	21	\N
90	94	2	2	7
91	95	3	3	8
92	88	9	28	\N
93	87	9	27	\N
94	31	9	27	\N
95	30	9	28	\N
96	29	9	27	\N
97	96	5	22	\N
98	97	6	13	\N
99	98	4	8	\N
100	99	2	2	9
101	100	2	2	3
102	19	3	3	8
103	101	3	3	\N
104	78	9	\N	\N
105	102	2	2	7
106	103	2	2	7
107	104	4	11	\N
108	105	4	8	\N
109	106	4	11	\N
110	107	4	11	\N
111	108	4	8	\N
112	109	2	2	7
113	110	3	3	8
114	111	2	2	5
115	113	2	2	3
116	114	2	2	3
117	115	2	4	13
118	116	2	4	15
119	117	2	2	3
120	118	2	2	5
121	119	2	2	5
122	121	3	3	2
123	122	2	2	1
124	123	3	3	2
125	124	2	2	7
126	125	2	2	7
127	126	2	2	7
128	127	2	2	7
129	128	2	2	7
130	129	2	2	\N
131	130	2	6	21
132	131	2	4	15
133	89	3	3	4
134	132	3	3	12
135	133	3	3	6
136	134	3	3	6
137	135	3	3	4
138	136	3	3	8
139	137	3	3	8
140	138	3	3	8
141	139	3	3	8
142	140	3	3	8
143	141	3	3	8
144	142	3	3	8
145	143	3	3	8
146	144	3	3	8
147	145	3	3	8
148	146	3	3	8
149	147	3	3	8
150	148	3	5	14
151	149	3	5	16
152	151	2	4	13
153	152	3	3	2
154	153	3	3	8
155	154	3	5	16
156	155	2	2	3
157	155	3	3	4
158	156	2	2	7
159	157	2	4	13
160	158	2	4	13
161	159	2	2	3
162	160	2	2	3
163	161	2	4	13
164	162	2	2	7
165	164	4	33	\N
166	165	3	3	4
167	166	5	23	\N
168	167	5	23	\N
169	168	5	23	\N
170	169	5	23	\N
171	170	2	4	17
172	171	2	4	17
173	177	2	2	3
174	178	2	2	3
175	179	2	2	3
176	180	2	2	3
177	182	2	2	3
178	183	2	2	3
179	186	2	2	3
180	187	3	3	2
181	188	4	11	\N
182	186	3	3	4
183	159	3	3	4
184	178	3	3	4
185	179	3	3	4
186	180	3	3	4
187	182	3	3	4
188	177	3	3	4
189	162	3	3	8
190	189	4	34	\N
191	190	2	4	13
192	191	3	3	8
193	194	2	2	7
194	195	3	3	8
195	196	3	3	8
196	197	3	3	2
197	198	2	2	1
198	199	3	3	2
199	200	2	4	13
200	201	3	3	8
201	202	2	2	7
202	203	2	4	13
203	205	5	23	\N
204	206	2	4	17
205	183	3	3	4
206	207	2	2	3
207	207	3	3	4
208	208	2	2	3
209	208	3	3	4
210	211	3	3	8
211	218	3	3	4
212	218	2	2	3
213	218	11	\N	\N
214	219	3	3	4
215	219	2	2	3
216	219	11	\N	\N
217	150	2	4	13
218	220	2	4	13
219	221	2	4	17
220	222	3	3	8
221	223	3	3	8
222	224	2	4	17
223	225	2	4	13
224	226	3	3	8
225	227	2	2	9
226	235	3	7	22
\.


--
-- Data for Name: PostRelation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PostRelation" ("fromId", "toId") FROM stdin;
78	31
\.


--
-- Data for Name: PostTag; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PostTag" ("postId", "tagId") FROM stdin;
1	1
16	2
3	3
3	4
99	3
99	4
99	6
3	6
100	3
100	5
100	6
19	2
78	2
78	7
29	2
29	8
79	2
79	3
94	2
94	3
94	6
94	7
102	2
102	6
102	7
102	8
109	2
109	6
109	7
109	3
103	2
103	3
103	6
103	7
82	5
82	6
82	7
82	8
86	8
30	2
30	8
95	2
95	6
95	7
95	8
117	3
117	5
117	6
117	7
112	3
112	5
118	3
118	5
119	2
119	3
115	2
115	3
121	6
122	3
122	6
123	6
123	8
124	2
124	3
124	6
124	7
31	2
31	3
31	6
31	7
78	3
78	6
125	2
125	3
125	6
125	7
126	2
126	3
126	6
126	7
127	2
127	3
127	6
127	7
128	2
128	3
128	6
128	7
90	3
129	3
129	5
129	6
130	3
91	3
131	3
116	3
19	3
111	3
111	6
111	7
89	3
89	5
19	8
89	8
132	8
133	8
134	8
135	6
135	7
135	8
136	2
136	8
32	2
32	6
32	7
32	8
137	2
137	6
137	7
138	2
138	6
138	7
138	8
139	2
139	6
139	7
139	8
140	2
140	6
140	7
140	8
141	2
141	6
141	7
141	8
142	2
142	6
142	7
142	8
143	2
143	6
143	7
143	8
144	2
144	6
144	7
144	8
145	2
145	6
145	7
145	8
146	2
146	6
146	7
146	8
147	2
147	6
147	7
147	8
110	2
110	6
110	7
110	8
148	8
149	8
137	8
150	3
151	3
28	8
21	8
152	8
153	2
153	6
153	7
153	8
154	8
155	3
155	5
155	6
155	7
155	8
135	5
100	9
113	3
113	5
113	10
113	11
114	3
114	5
114	11
114	12
114	13
111	14
29	15
29	16
29	17
89	18
89	19
89	20
89	21
161	3
161	6
161	22
161	23
161	24
161	25
162	2
162	3
162	27
163	3
163	8
163	11
163	28
163	29
164	3
164	5
164	8
164	11
164	30
164	31
164	32
165	3
165	21
165	26
165	5
165	65
165	66
167	3
167	6
167	8
167	30
167	67
167	68
167	69
170	3
170	6
170	8
170	11
170	30
170	68
171	3
171	6
171	8
171	11
171	30
171	70
171	71
172	5
172	8
172	67
172	72
172	73
173	5
173	6
173	8
173	30
173	74
173	75
173	76
174	6
174	8
174	76
174	77
174	78
174	79
174	80
175	6
175	8
175	79
175	81
175	82
175	83
175	84
176	5
176	6
176	8
176	79
176	81
176	82
176	83
176	84
177	3
177	74
177	5
159	3
159	5
159	87
159	88
159	89
159	6
178	3
178	5
178	6
178	76
178	90
178	91
178	92
179	5
179	6
179	79
179	81
179	83
179	3
179	82
180	5
180	6
180	11
180	76
180	78
180	79
180	3
181	5
181	6
181	8
181	28
181	76
181	92
181	91
182	3
182	5
182	6
182	72
182	67
182	73
183	2
183	3
183	5
183	93
183	95
183	96
184	5
184	6
184	8
184	87
184	88
184	97
184	98
185	5
185	8
185	72
185	99
185	100
185	101
185	102
185	103
186	3
186	5
186	72
186	99
186	101
186	102
186	103
187	8
187	26
187	30
187	104
187	105
187	107
177	73
177	76
177	77
160	3
160	5
160	76
160	96
183	65
135	108
135	109
135	110
187	111
162	8
162	112
162	113
157	2
157	113
157	114
157	115
157	116
190	3
190	109
190	117
190	118
190	119
123	26
123	120
122	66
122	120
122	121
196	2
196	17
196	122
196	123
211	2
211	8
211	124
211	125
215	126
215	127
215	128
214	126
214	128
214	127
214	129
216	70
216	126
216	130
217	99
217	126
217	131
218	87
218	98
218	132
218	133
219	132
219	133
219	68
219	30
220	3
220	117
220	134
220	135
221	11
221	136
221	137
221	138
221	139
221	140
221	141
222	2
222	16
222	17
222	124
222	136
224	7
224	140
224	142
224	143
224	144
225	109
225	140
225	144
225	145
226	2
226	124
226	146
226	147
227	3
227	4
227	117
227	148
227	149
227	150
228	30
228	126
228	151
228	152
228	153
229	126
229	133
229	154
229	155
229	156
230	78
230	126
230	133
230	157
231	158
231	159
231	160
231	161
231	162
232	11
232	30
232	126
232	163
233	126
233	158
233	162
233	164
234	126
234	159
234	165
234	166
235	8
235	167
235	168
\.


--
-- Data for Name: SubCategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SubCategory" (id, nom, slug, ordre, "legacyId", "createdAt", "updatedAt", "categoryId") FROM stdin;
1	Démarrage	demarrage	0	\N	2026-05-26 04:10:17.64	2026-05-26 04:10:17.64	1
2	Matériel	materiel	0	11	2026-05-26 07:46:24.775	2026-05-26 07:57:01.847	2
3	Matériel	materiel	0	12	2026-05-26 07:46:24.82	2026-05-26 07:57:01.881	3
4	Mise en place	mise-en-place	0	13	2026-05-26 07:46:24.85	2026-05-26 07:57:01.911	2
5	Mise en place	mise-en-place	0	14	2026-05-26 07:46:24.886	2026-05-26 07:57:01.935	3
6	Livraison et retour	livraison-et-retour	0	15	2026-05-26 07:46:24.917	2026-05-26 07:57:01.966	2
7	Livraison et retour	livraison-et-retour	0	16	2026-05-26 07:46:24.952	2026-05-26 07:57:01.991	3
8	Application "" borne ""	application-borne	0	17	2026-05-26 07:46:24.983	2026-05-26 07:57:02.022	4
9	TeamViewer	teamviewer	0	18	2026-05-26 07:46:25.018	2026-05-26 07:57:02.046	4
10	Nextcloud	nextcloud	0	19	2026-05-26 07:46:25.049	2026-05-26 07:57:02.077	4
11	Application "" booth ""	application-booth	0	20	2026-05-26 07:46:25.085	2026-05-26 07:57:02.101	4
12	Logiciel	logiciel	0	21	2026-05-26 07:46:25.116	2026-05-26 07:57:02.132	6
13	Matériel	materiel	0	22	2026-05-26 07:46:25.152	2026-05-26 07:57:02.157	6
14	Achat	achat	0	23	2026-05-26 07:46:25.182	2026-05-26 07:57:02.188	6
15	Installateur	installateur	0	24	2026-05-26 07:46:25.218	2026-05-26 07:57:02.212	8
16	Antenne	antenne	0	25	2026-05-26 07:46:25.248	2026-05-26 07:57:02.243	8
17	Photographe	photographe	0	26	2026-05-26 07:46:25.284	2026-05-26 07:57:02.268	8
18	Hôtesse	hotesse	0	27	2026-05-26 07:46:25.315	2026-05-26 07:57:02.434	8
19	Borne Spherik	borne-spherik	0	28	2026-05-26 07:46:25.351	2026-05-26 07:57:02.463	7
20	Borne Classik	borne-classik	0	29	2026-05-26 07:46:25.395	2026-05-26 07:57:02.489	7
21	Imprimante	imprimante	0	30	2026-05-26 07:46:25.473	2026-05-26 07:57:02.519	7
22	Matériel	materiel	0	31	2026-05-26 07:46:25.503	2026-05-26 07:57:02.544	5
23	Logiciel	logiciel	0	32	2026-05-26 07:46:25.539	2026-05-26 07:57:02.574	5
24	Contrat	contrat	0	33	2026-05-26 07:46:25.581	2026-05-26 07:57:02.6	5
25	?		0	34	2026-05-26 07:46:25.616	2026-05-26 07:57:02.63	5
26	Transport	transport	0	35	2026-05-26 07:46:25.647	2026-05-26 07:57:02.655	5
27	Spherik	spherik	0	36	2026-05-26 07:46:25.683	2026-05-26 07:57:02.685	9
28	Classik	classik	0	37	2026-05-26 07:46:25.713	2026-05-26 07:57:02.711	9
29	Flash déporté	flash-deporte	0	38	2026-05-26 07:46:25.749	2026-05-26 07:57:02.8	10
30	Incrustation d'image	incrustation-d-image	0	39	2026-05-26 07:46:25.78	2026-05-26 07:57:02.832	10
31	DNP QW410	dnp-qw410	0	40	2026-05-26 07:46:25.816	2026-05-26 07:57:02.874	9
32	DNP DS620	dnp-ds620	0	41	2026-05-26 07:46:25.846	2026-05-26 07:57:02.94	9
33	Pik mosaic	pik-mosaic	0	42	2026-05-26 07:46:25.882	2026-05-26 07:57:02.995	4
34	Formats	formats	0	43	2026-05-26 07:46:25.913	2026-05-26 07:57:03.02	4
35	Matériel	materiel	0	44	2026-05-26 07:46:25.949	2026-05-26 07:57:03.051	11
36	Mise en place	mise-en-place	0	45	2026-05-26 07:46:25.979	2026-05-26 07:57:03.076	11
37	Livraison et retour	livraison-et-retour	0	46	2026-05-26 07:46:26.035	2026-05-26 07:57:03.106	11
38	PHOTOGRAPHE DÉPORTÉ	photographe-deporte	0	47	2026-05-26 07:46:26.059	2026-05-26 07:57:03.164	12
39	IA IMMERSIVE	ia-immersive	0	48	2026-05-26 07:46:26.09	2026-05-26 07:57:03.195	11
40	MOSAÏK	mosaik	0	49	2026-05-26 07:46:26.115	2026-05-26 07:57:03.22	12
41	DIAPORAMA	diaporama	0	50	2026-05-26 07:46:26.146	2026-05-26 07:57:03.275	12
42	INSTANT GAGNANT	instant-gagnant	0	51	2026-05-26 07:46:26.17	2026-05-26 07:57:03.305	12
43	CODE D’IMPRESSION	code-d-impression	0	52	2026-05-26 07:46:26.201	2026-05-26 07:57:03.33	12
44	FOND VERT MAGIQUE	fond-vert-magique	0	53	2026-05-26 07:46:26.225	2026-05-26 07:57:03.36	12
45	SCÉNARIO	scenario	0	54	2026-05-26 07:46:26.257	2026-05-26 07:57:03.386	12
46	MAGNETS	magnets	0	55	2026-05-26 07:46:26.281	2026-05-26 07:57:03.416	12
47	DISPOSITIF ECLIPSO	dispositif-eclipso	0	56	2026-05-26 07:46:26.312	2026-05-26 07:57:03.441	12
\.


--
-- Data for Name: SubSubCategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SubSubCategory" (id, nom, slug, ordre, "legacyId", "createdAt", "updatedAt", "subCategoryId") FROM stdin;
1	Appareil photo	appareil-photo	0	1	2026-05-26 07:46:26.337	2026-05-26 07:57:03.473	2
2	Appareil photo	appareil-photo	0	2	2026-05-26 07:46:26.368	2026-05-26 07:57:03.497	3
3	Ecran	ecran	0	3	2026-05-26 07:46:26.393	2026-05-26 07:57:03.527	2
4	Ecran	ecran	0	4	2026-05-26 07:46:26.423	2026-05-26 07:57:03.552	3
5	Electrique	electrique	0	5	2026-05-26 07:46:26.447	2026-05-26 07:57:03.582	2
6	Electrique	electrique	0	6	2026-05-26 07:46:26.478	2026-05-26 07:57:03.607	3
7	Imprimante	imprimante	0	7	2026-05-26 07:46:26.503	2026-05-26 07:57:03.639	2
8	Imprimante	imprimante	0	8	2026-05-26 07:46:26.534	2026-05-26 07:57:03.921	3
9	Lumière	lumiere	0	9	2026-05-26 07:46:26.558	2026-05-26 07:57:04.039	2
10	Lumière	lumiere	0	10	2026-05-26 07:46:26.589	2026-05-26 07:57:04.113	3
11	Ordinateur	ordinateur	0	11	2026-05-26 07:46:26.624	2026-05-26 07:57:04.138	2
12	Ordinateur	ordinateur	0	12	2026-05-26 07:46:26.679	2026-05-26 07:57:04.168	3
13	Installation	installation	0	13	2026-05-26 07:46:26.711	2026-05-26 07:57:04.194	4
14	Installation	installation	0	14	2026-05-26 07:46:26.735	2026-05-26 07:57:04.224	5
15	Désinstallation	desinstallation	0	15	2026-05-26 07:46:26.766	2026-05-26 07:57:04.249	4
16	Désinstallation	desinstallation	0	16	2026-05-26 07:46:26.79	2026-05-26 07:57:04.279	5
17	Conseils d'utilisation	conseils-d-utilisation	0	17	2026-05-26 07:46:26.821	2026-05-26 07:57:04.305	4
18	Conseils d'utilisation	conseils-d-utilisation	0	18	2026-05-26 07:46:26.845	2026-05-26 07:57:04.334	5
19	Réception	reception	0	19	2026-05-26 07:46:26.877	2026-05-26 07:57:04.36	6
20	Réception	reception	0	20	2026-05-26 07:46:26.901	2026-05-26 07:57:04.39	7
21	Retour	retour	0	21	2026-05-26 07:46:26.943	2026-05-26 07:57:04.415	6
22	Retour	retour	0	22	2026-05-26 07:46:26.978	2026-05-26 07:57:04.445	7
23	Classik	classik	0	23	2026-05-26 07:46:27.009	2026-05-26 07:57:04.47	14
24	Sphérik	spherik	0	24	2026-05-26 07:46:27.034	2026-05-26 07:57:04.5	14
25	Notice d'utilisation 	notice-d-utilisation	0	25	2026-05-26 07:46:27.064	2026-05-26 07:57:04.526	5
26	Conseil d’utilisation	conseil-d-utilisation	0	26	2026-05-26 07:46:27.089	2026-05-26 07:57:04.556	4
27	Appareil photo	appareil-photo	0	27	2026-05-26 07:46:27.12	2026-05-26 07:57:04.581	35
28	Écran	ecran	0	28	2026-05-26 07:46:27.144	2026-05-26 07:57:04.611	35
29	Électrique	electrique	0	29	2026-05-26 07:46:27.175	2026-05-26 07:57:04.637	35
30	Imprimante	imprimante	0	30	2026-05-26 07:46:27.2	2026-05-26 07:57:04.667	35
31	Lumière	lumiere	0	31	2026-05-26 07:46:27.231	2026-05-26 07:57:04.692	35
32	Ordinateur	ordinateur	0	32	2026-05-26 07:46:27.255	2026-05-26 07:57:04.722	35
33	Installation	installation	0	33	2026-05-26 07:46:27.286	2026-05-26 07:57:04.747	36
34	Désinstallation	desinstallation	0	34	2026-05-26 07:46:27.31	2026-05-26 07:57:04.777	36
35	Conseil d’utilisation	conseil-d-utilisation	0	35	2026-05-26 07:46:27.341	2026-05-26 07:57:04.803	36
36	Notice d’utilisation	notice-d-utilisation	0	36	2026-05-26 07:46:27.366	2026-05-26 07:57:04.833	36
37	Réception	reception	0	37	2026-05-26 07:46:27.397	2026-05-26 07:57:04.858	37
38	Retour	retour	0	38	2026-05-26 07:46:27.421	2026-05-26 07:57:04.888	37
39	Gabarits	gabarits	0	39	2026-05-26 07:46:27.452	2026-05-26 07:57:04.913	46
40	Général	general	0	40	2026-05-26 07:46:27.476	2026-05-26 07:57:04.943	47
41	Borne photo	borne-photo	0	41	2026-05-26 07:46:27.508	2026-05-26 07:57:04.969	47
42	Kiosk de commande	kiosk-de-commande	0	42	2026-05-26 07:46:27.532	2026-05-26 07:57:04.999	47
43	Labo d’impression	labo-d-impression	0	43	2026-05-26 07:46:27.563	2026-05-26 07:57:05.058	47
\.


--
-- Data for Name: Tag; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Tag" (id, name, slug, "legacyId", "createdAt") FROM stdin;
1	demo	demo	\N	2026-05-26 04:10:17.718
2	imprimante	imprimante	12	2026-05-26 07:46:27.586
3	spherik	spherik	13	2026-05-26 07:46:27.617
4	lumière	lumiere	14	2026-05-26 07:46:27.641
5	écran	ecran	15	2026-05-26 07:46:27.672
6	problème	probleme	16	2026-05-26 07:46:27.697
7	erreur	erreur	17	2026-05-26 07:46:27.727
8	classik	classik	18	2026-05-26 07:46:27.752
9	éteint	eteint	19	2026-05-26 07:46:27.783
10	éteindre	eteindre	20	2026-05-26 07:46:27.807
11	photobooth	photobooth	21	2026-05-26 07:46:27.838
12	fenêtre	fenetre	22	2026-05-26 07:46:27.863
13	bureau	bureau	23	2026-05-26 07:46:27.894
14	ne démarre pas	ne-demarre-pas	24	2026-05-26 07:46:27.918
15	consommable	consommable	25	2026-05-26 07:46:27.949
16	encre	encre	26	2026-05-26 07:46:27.973
17	papier	papier	27	2026-05-26 07:46:28.004
18	WIFI	wifi	28	2026-05-26 07:46:28.029
19	connexion	connexion	29	2026-05-26 07:46:28.06
20	partage	partage	30	2026-05-26 07:46:28.084
21	paramètre	parametre	31	2026-05-26 07:46:28.115
22	taille	taille	32	2026-05-26 07:46:28.139
23	hauteur	hauteur	33	2026-05-26 07:46:28.17
24	grand	grand	34	2026-05-26 07:46:28.195
25	petit	petit	35	2026-05-26 07:46:28.226
26	appareil photo	appareil-photo	36	2026-05-26 07:46:28.25
27	périphérique	peripherique	37	2026-05-26 07:46:28.281
28	filtres	filtres	38	2026-05-26 07:46:28.32
29	couleurs	couleurs	39	2026-05-26 07:46:28.35
30	photos	photos	40	2026-05-26 07:46:28.38
31	mosaik	mosaik	41	2026-05-26 07:46:28.405
32	télé	tele	42	2026-05-26 07:46:28.436
65	hors service	hors-service	44	2026-05-26 07:57:06.019
66	caméra	camera	45	2026-05-26 07:57:06.05
67	cadre	cadre	46	2026-05-26 07:57:06.075
68	originales	originales	47	2026-05-26 07:57:06.105
69	dossier	dossier	48	2026-05-26 07:57:06.13
70	cadres	cadres	49	2026-05-26 07:57:06.161
71	photoshop	photoshop	50	2026-05-26 07:57:06.185
72	mise à jour	mise-a-jour	51	2026-05-26 07:57:06.216
73	modification	modification	52	2026-05-26 07:57:06.241
74	décompte	decompte	53	2026-05-26 07:57:06.271
75	temps	temps	54	2026-05-26 07:57:06.296
76	configuration	configuration	55	2026-05-26 07:57:06.327
77	photo	photo	56	2026-05-26 07:57:06.352
78	multi-impression	multi-impression	57	2026-05-26 07:57:06.415
79	activer	activer	58	2026-05-26 07:57:06.44
80	sans impression	sans-impression	59	2026-05-26 07:57:06.473
81	miroir	miroir	60	2026-05-26 07:57:06.495
82	effet	effet	61	2026-05-26 07:57:06.526
83	à l'envers	a-l-envers	62	2026-05-26 07:57:06.551
84	désactiver	desactiver	63	2026-05-26 07:57:06.581
85	Réduire	reduire	67	2026-05-26 07:57:06.606
86	Augmenter	augmenter	68	2026-05-26 07:57:06.636
87	Logiciel	logiciel	72	2026-05-26 07:57:06.661
88	Crache	crache	73	2026-05-26 07:57:06.692
89	Plante	plante	74	2026-05-26 07:57:06.717
90	filtre	filtre	76	2026-05-26 07:57:06.747
91	noir et blanc	noir-et-blanc	77	2026-05-26 07:57:06.794
92	sepia	sepia	78	2026-05-26 07:57:06.883
93	Paramètres	parametres	85	2026-05-26 07:57:06.913
94	Problèmes	problemes	86	2026-05-26 07:57:06.938
95	micro	micro	87	2026-05-26 07:57:06.968
96	tablette	tablette	88	2026-05-26 07:57:06.994
97	relancer	relancer	91	2026-05-26 07:57:07.023
98	Selfizee	selfizee	92	2026-05-26 07:57:07.049
99	événement	evenement	93	2026-05-26 07:57:07.079
100	heure	heure	94	2026-05-26 07:57:07.104
101	téléchargement	telechargement	95	2026-05-26 07:57:07.134
102	échec	echec	96	2026-05-26 07:57:07.16
103	manuel	manuel	97	2026-05-26 07:57:07.189
104	réglage	reglage	98	2026-05-26 07:57:07.215
105	claires	claires	99	2026-05-26 07:57:07.245
106	lumineuses	lumineuses	100	2026-05-26 07:57:07.27
107	image	image	101	2026-05-26 07:57:07.3
108	noir	noir	104	2026-05-26 07:57:07.326
109	montage	montage	105	2026-05-26 07:57:07.355
110	branchement	branchement	106	2026-05-26 07:57:07.381
111	luminosité	luminosite	107	2026-05-26 07:57:07.411
112	redémarrer	redemarrer	108	2026-05-26 07:57:07.436
113	USB	usb	109	2026-05-26 07:57:07.466
114	fils	fils	110	2026-05-26 07:57:07.492
115	inversé	inverse	111	2026-05-26 07:57:07.522
116	hors connexion	hors-connexion	112	2026-05-26 07:57:07.547
117	tête	tete	113	2026-05-26 07:57:07.577
118	vis	vis	114	2026-05-26 07:57:07.603
119	démontage	demontage	115	2026-05-26 07:57:07.632
120	angle	angle	116	2026-05-26 07:57:07.658
121	réglages	reglages	117	2026-05-26 07:57:07.688
122	bourrage	bourrage	118	2026-05-26 07:57:07.713
123	coincé	coince	119	2026-05-26 07:57:07.754
124	DS620	ds620	120	2026-05-26 07:57:07.78
125	nettoyage	nettoyage	121	2026-05-26 07:57:07.809
126	manager	manager	122	2026-05-26 07:57:07.835
127	paiement	paiement	123	2026-05-26 07:57:07.865
128	TPE	tpe	124	2026-05-26 07:57:07.89
129	option	option	128	2026-05-26 07:57:07.931
130	personnalisation	personnalisation	129	2026-05-26 07:57:07.998
131	création	creation	130	2026-05-26 07:57:08.023
132	TeamViewer	teamviewer	131	2026-05-26 07:57:08.053
133	Borne	borne	132	2026-05-26 07:57:08.079
134	support	support	136	2026-05-26 07:57:08.109
135	mural	mural	137	2026-05-26 07:57:08.134
136	eclipso	eclipso	138	2026-05-26 07:57:08.164
137	parcours	parcours	139	2026-05-26 07:57:08.19
138	client	client	140	2026-05-26 07:57:08.219
139	prestige	prestige	141	2026-05-26 07:57:08.245
140	kiosk	kiosk	142	2026-05-26 07:57:08.274
141	impression	impression	143	2026-05-26 07:57:08.3
142	internet	internet	144	2026-05-26 07:57:08.33
143	ethernet	ethernet	145	2026-05-26 07:57:08.355
144	branchements	branchements	146	2026-05-26 07:57:08.385
145	installation	installation	147	2026-05-26 07:57:08.411
146	labo	labo	148	2026-05-26 07:57:08.441
147	PC	pc	149	2026-05-26 07:57:08.466
148	intensité	intensite	150	2026-05-26 07:57:08.496
149	ring light	ring-light	151	2026-05-26 07:57:08.521
150	potentiomètre	potentiometre	152	2026-05-26 07:57:08.551
151	animation	animation	153	2026-05-26 07:57:08.609
152	enregistrer	enregistrer	154	2026-05-26 07:57:08.632
153	catalogue	catalogue	155	2026-05-26 07:57:08.662
154	instant gagnant	instant-gagnant	156	2026-05-26 07:57:08.688
155	gain	gain	157	2026-05-26 07:57:08.718
156	lots	lots	158	2026-05-26 07:57:08.743
157	codes	codes	159	2026-05-26 07:57:08.773
158	collecte	collecte	160	2026-05-26 07:57:08.798
159	mail	mail	161	2026-05-26 07:57:08.829
160	nom de domaine	nom-de-domaine	162	2026-05-26 07:57:08.865
161	opt-in	opt-in	163	2026-05-26 07:57:08.895
162	donnée	donnee	164	2026-05-26 07:57:08.92
163	galerie	galerie	165	2026-05-26 07:57:08.95
164	RGPD	rgpd	166	2026-05-26 07:57:08.975
165	scénario	scenario	167	2026-05-26 07:57:09.006
166	langue	langue	168	2026-05-26 07:57:09.031
167	envoi	envoi	169	2026-05-26 07:57:09.061
168	palette	palette	170	2026-05-26 07:57:09.086
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
836aa4d0-3fb7-4771-98fb-9501d6526643	8fe6be529457f0d2fc3d429c228bc6485ba35e95167b6b54a44a35e9ee1d8301	2026-05-26 04:10:12.767357+00	20260526041009_init	\N	\N	2026-05-26 04:10:09.286413+00	1
\.


--
-- Name: Category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Category_id_seq"', 23, true);


--
-- Name: PostAttachment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PostAttachment_id_seq"', 1, false);


--
-- Name: PostCategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PostCategory_id_seq"', 226, true);


--
-- Name: Post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Post_id_seq"', 235, true);


--
-- Name: SubCategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."SubCategory_id_seq"', 93, true);


--
-- Name: SubSubCategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."SubSubCategory_id_seq"', 86, true);


--
-- Name: Tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Tag_id_seq"', 168, true);


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: PostAttachment PostAttachment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostAttachment"
    ADD CONSTRAINT "PostAttachment_pkey" PRIMARY KEY (id);


--
-- Name: PostCategory PostCategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostCategory"
    ADD CONSTRAINT "PostCategory_pkey" PRIMARY KEY (id);


--
-- Name: PostRelation PostRelation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostRelation"
    ADD CONSTRAINT "PostRelation_pkey" PRIMARY KEY ("fromId", "toId");


--
-- Name: PostTag PostTag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostTag"
    ADD CONSTRAINT "PostTag_pkey" PRIMARY KEY ("postId", "tagId");


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id);


--
-- Name: SubCategory SubCategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SubCategory"
    ADD CONSTRAINT "SubCategory_pkey" PRIMARY KEY (id);


--
-- Name: SubSubCategory SubSubCategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SubSubCategory"
    ADD CONSTRAINT "SubSubCategory_pkey" PRIMARY KEY (id);


--
-- Name: Tag Tag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Category_legacyId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Category_legacyId_key" ON public."Category" USING btree ("legacyId");


--
-- Name: Category_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Category_slug_key" ON public."Category" USING btree (slug);


--
-- Name: PostAttachment_legacyId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "PostAttachment_legacyId_key" ON public."PostAttachment" USING btree ("legacyId");


--
-- Name: PostAttachment_postId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PostAttachment_postId_idx" ON public."PostAttachment" USING btree ("postId");


--
-- Name: PostCategory_categoryId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PostCategory_categoryId_idx" ON public."PostCategory" USING btree ("categoryId");


--
-- Name: PostCategory_postId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PostCategory_postId_idx" ON public."PostCategory" USING btree ("postId");


--
-- Name: Post_authorKcSub_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Post_authorKcSub_idx" ON public."Post" USING btree ("authorKcSub");


--
-- Name: Post_legacyId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Post_legacyId_key" ON public."Post" USING btree ("legacyId");


--
-- Name: Post_publishedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Post_publishedAt_idx" ON public."Post" USING btree ("publishedAt");


--
-- Name: Post_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Post_slug_key" ON public."Post" USING btree (slug);


--
-- Name: Post_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Post_status_idx" ON public."Post" USING btree (status);


--
-- Name: SubCategory_categoryId_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "SubCategory_categoryId_slug_key" ON public."SubCategory" USING btree ("categoryId", slug);


--
-- Name: SubCategory_legacyId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "SubCategory_legacyId_key" ON public."SubCategory" USING btree ("legacyId");


--
-- Name: SubSubCategory_legacyId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "SubSubCategory_legacyId_key" ON public."SubSubCategory" USING btree ("legacyId");


--
-- Name: SubSubCategory_subCategoryId_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "SubSubCategory_subCategoryId_slug_key" ON public."SubSubCategory" USING btree ("subCategoryId", slug);


--
-- Name: Tag_legacyId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Tag_legacyId_key" ON public."Tag" USING btree ("legacyId");


--
-- Name: Tag_slug_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Tag_slug_key" ON public."Tag" USING btree (slug);


--
-- Name: PostAttachment PostAttachment_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostAttachment"
    ADD CONSTRAINT "PostAttachment_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PostCategory PostCategory_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostCategory"
    ADD CONSTRAINT "PostCategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: PostCategory PostCategory_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostCategory"
    ADD CONSTRAINT "PostCategory_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PostCategory PostCategory_subCategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostCategory"
    ADD CONSTRAINT "PostCategory_subCategoryId_fkey" FOREIGN KEY ("subCategoryId") REFERENCES public."SubCategory"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: PostCategory PostCategory_subSubCategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostCategory"
    ADD CONSTRAINT "PostCategory_subSubCategoryId_fkey" FOREIGN KEY ("subSubCategoryId") REFERENCES public."SubSubCategory"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: PostRelation PostRelation_fromId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostRelation"
    ADD CONSTRAINT "PostRelation_fromId_fkey" FOREIGN KEY ("fromId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PostRelation PostRelation_toId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostRelation"
    ADD CONSTRAINT "PostRelation_toId_fkey" FOREIGN KEY ("toId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PostTag PostTag_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostTag"
    ADD CONSTRAINT "PostTag_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Post"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PostTag PostTag_tagId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PostTag"
    ADD CONSTRAINT "PostTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES public."Tag"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SubCategory SubCategory_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SubCategory"
    ADD CONSTRAINT "SubCategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SubSubCategory SubSubCategory_subCategoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SubSubCategory"
    ADD CONSTRAINT "SubSubCategory_subCategoryId_fkey" FOREIGN KEY ("subCategoryId") REFERENCES public."SubCategory"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict mNB4P0r5WcLzEHWG9LhXgGykF4DwTlqkpjAh8NhvfggLyeO6aZdM1He0qlXZhac

