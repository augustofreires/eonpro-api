--
-- PostgreSQL database dump
--

\restrict gmeQheKaAaxMnkMHYT8Qpim6aUVzWNrNc9Ga2plc4itvZMnL8idkCC2YDekdpxV

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: BotCategory; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BotCategory" AS ENUM (
    'FREE',
    'PAID',
    'BONUS'
);


--
-- Name: PaymentSource; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PaymentSource" AS ENUM (
    'MANUAL',
    'PERFECTPAY',
    'HOTMART',
    'STRIPE'
);


--
-- Name: Role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Role" AS ENUM (
    'USER',
    'ADMIN',
    'MASTER'
);


--
-- Name: Status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Status" AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'BLOCKED',
    'PENDING'
);


--
-- Name: SubscriptionStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."SubscriptionStatus" AS ENUM (
    'ACTIVE',
    'EXPIRED',
    'CANCELLED'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Bot; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Bot" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    xml_filename text NOT NULL,
    category public."BotCategory" DEFAULT 'PAID'::public."BotCategory" NOT NULL,
    status public."Status" DEFAULT 'ACTIVE'::public."Status" NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    internal_id text
);


--
-- Name: CourseLesson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CourseLesson" (
    id text NOT NULL,
    module_id text NOT NULL,
    title text NOT NULL,
    youtube_url text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    status public."Status" DEFAULT 'ACTIVE'::public."Status" NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    description text
);


--
-- Name: CourseModule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CourseModule" (
    id text NOT NULL,
    title text NOT NULL,
    description text,
    banner_url text,
    "order" integer DEFAULT 0 NOT NULL,
    status public."Status" DEFAULT 'ACTIVE'::public."Status" NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: Plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Plan" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    duration_days integer NOT NULL,
    status public."Status" DEFAULT 'ACTIVE'::public."Status" NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    checkout_url text
);


--
-- Name: PlanBot; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PlanBot" (
    id text NOT NULL,
    plan_id text NOT NULL,
    bot_id text NOT NULL
);


--
-- Name: Setting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Setting" (
    id text NOT NULL,
    key text NOT NULL,
    value text NOT NULL
);


--
-- Name: SmtpConfig; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SmtpConfig" (
    id text NOT NULL,
    host text DEFAULT ''::text NOT NULL,
    port integer DEFAULT 587 NOT NULL,
    "user" text DEFAULT ''::text NOT NULL,
    password text DEFAULT ''::text NOT NULL,
    from_name text DEFAULT 'IAEON'::text NOT NULL,
    from_email text DEFAULT ''::text NOT NULL,
    secure boolean DEFAULT false NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: Subscription; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Subscription" (
    id text NOT NULL,
    user_id text NOT NULL,
    plan_id text NOT NULL,
    started_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp(3) without time zone,
    status public."SubscriptionStatus" DEFAULT 'ACTIVE'::public."SubscriptionStatus" NOT NULL,
    payment_source public."PaymentSource" DEFAULT 'MANUAL'::public."PaymentSource" NOT NULL,
    payment_reference text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    name text NOT NULL,
    role public."Role" DEFAULT 'USER'::public."Role" NOT NULL,
    status public."Status" DEFAULT 'ACTIVE'::public."Status" NOT NULL,
    language text DEFAULT 'pt-br'::text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    last_login timestamp(3) without time zone,
    "resetToken" text,
    "resetTokenExpiry" timestamp(3) without time zone,
    utm_campaign text,
    utm_medium text,
    utm_source text
);


--
-- Name: WebhookLog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."WebhookLog" (
    id text NOT NULL,
    source text NOT NULL,
    payload jsonb NOT NULL,
    status text DEFAULT 'received'::text NOT NULL,
    processed_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email text,
    event_type text
);


--
-- Data for Name: Bot; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Bot" (id, name, description, xml_filename, category, status, created_at, updated_at, internal_id) FROM stdin;
f27df3a4-7074-4820-883c-d494724efaf8	Eon Even/Odd	Digit Even com Martingale - R_100	eon_even_odd.xml	PAID	ACTIVE	2026-02-26 15:55:40.517	2026-02-26 15:55:40.517	\N
47eec876-5aa2-4368-897a-a97d64565986	Eon Rise/Fall	Rise (Call) com Martingale - R_100	eon_rise_fall.xml	PAID	ACTIVE	2026-02-26 15:55:40.524	2026-02-26 15:55:40.524	\N
0cf11b7d-7ee5-4d3e-a7ab-562b87ea9097	Digit Over 3	Bot de trading baseado em Digit Over 3	Digit Over 3.xml	PAID	ACTIVE	2026-02-08 20:16:05.861	2026-02-08 20:16:05.861	digit_over_3
b250d063-0df5-4a59-98a4-04add4fda117	House Of Rise Fall Auto Bots	Bot de trading baseado em House Of Rise Fall Auto Bots	House of Rise_Fall Auto_Bots.xml	PAID	ACTIVE	2026-02-08 20:16:07.999	2026-02-08 20:16:07.999	house_rise_fall
2dd5c9eb-ca9a-4d4c-8a75-34ce111a59e8	Lastdigit1 Strategy Bot	Bot de trading baseado em Lastdigit1 Strategy Bot	LastDigit1-Strategy-Bot.xml	PAID	ACTIVE	2026-02-08 20:16:08.535	2026-02-08 20:16:08.535	lastdigit1
f4884da9-89fe-49b8-8d0d-90807722ca1c	Mavic Air RF Vix Bot	Bot de trading baseado em Mavic Air RF Vix Bot	Mavic-Air-RF Vix Bot.xml	PAID	ACTIVE	2026-02-08 20:16:09.082	2026-02-08 20:16:09.082	mavic_air_rf
65e0a8bb-4091-4556-825c-a90aed859e02	RF Market Monitor	Bot de trading baseado em RF Market Monitor	RF_Market-Monitor.xml	PAID	ACTIVE	2026-02-08 20:16:10.176	2026-02-08 20:16:10.176	rf_market_monitor
c44f9311-7ef0-4ac6-9e99-e2592d7e1a6e	HARAMI Binary Bot	Bot de trading baseado em HARAMI Binary Bot	HARAMI Binary-Bot.xml	PAID	ACTIVE	2026-02-08 20:16:06.938	2026-02-08 20:16:06.938	harami
e59429dc-ad23-4cb7-9c1a-c8b41eecab0c	Stoch And RSI Bot	Bot de trading baseado em Stoch And RSI Bot	Stoch and RSI Bot.xml	PAID	ACTIVE	2026-02-08 20:16:11.5	2026-02-08 20:16:11.5	stoch_rsi
1942ef29-fdf0-41d3-baf9-b3c2af780dab	Fast Par	Bot rápido de Digit Even (Par) com martingale no Volatility Index 100. Valor de entrada e multiplicador configuráveis.	Fast Par.xml	PAID	ACTIVE	2026-02-17 15:09:31.579	2026-02-17 15:09:31.579	fast_par
3b47b5c7-6f26-4148-ac06-2e31db5050a4	Fabrica 7x2	Bot com estratégia 7x2 Over/Under no Volatility Index 10. Análise estatística, martingale, soros e sistema de garantia percentual.	Fabrica 7x2.xml	PAID	ACTIVE	2026-02-17 16:35:48.909	2026-02-17 16:35:48.909	fabrica_7x2
77b438b0-d4c3-43ba-9ed4-2c167e293965	1 Tick Digit Over 2	Bot de trading baseado em 1 Tick Digit Over 2	1 tick DIgit Over 2.xml	FREE	ACTIVE	2026-02-08 20:16:05.204	2026-02-16 16:13:34.048	1_tick_digit_over_2
38323f34-4dfb-42d7-8b0c-ec2fc74faa6f	Fast Impar	Bot rápido de Digit Odd (Ímpar) com martingale no Volatility Index 100. Valor de entrada e multiplicador configuráveis.	Fast Impar.xml	PAID	ACTIVE	2026-02-16 21:55:25.326	2026-02-16 21:55:25.326	fast_impar
8a8b87a9-b872-4d2f-b5a7-d4d22a962861	Moneybot	Bot de Reset Call no Volatility Index 100 com análise de padrões de dígitos pares/ímpares. Martingale configurável com fator e nível de início.	Moneybot.xml	PAID	ACTIVE	2026-02-17 16:44:14.733	2026-02-17 16:44:14.733	moneybot
be6efbce-c027-4843-bcdc-68fa77babfef	Fabrica Invert	Bot avançado com 10 estratégias invertidas Over/Under no Volatility Index 10. Análise estatística de dígitos, martingale inteligente, soros, stop loss e meta de ganho.	Fabrica Invert.xml	PAID	INACTIVE	2026-02-17 16:22:14.543	2026-02-17 21:09:10.205	fabrica_invert
92ae4a83-8f71-4262-98b0-cce40b5933c1	Exponential Strategy Bot 2.0	Estratégia exponencial com controle de lucro e perda	Exponential Strategy Bot 2.0.xml	PAID	ACTIVE	2026-02-24 21:31:06.726	2026-02-24 21:31:06.726	exponential_strategy
aee57e3f-94b2-4852-b28b-3fd65a91b844	Leo Even Odd Bot	Bot para operações Par/Ímpar com martingale	Leo_Even_Odd.xml	PAID	ACTIVE	2026-02-24 21:31:06.799	2026-02-24 21:31:06.799	leo_even_odd
0eb1f533-55db-4bff-9514-95dae33f05e2	D Alembert Max Stake	D Alembert com stake máximo configurável	dalembert_max-stake.xml	FREE	ACTIVE	2026-02-24 21:31:06.997	2026-02-24 21:31:06.997	dalembert_max_stake
07d172dd-0f8e-4eac-a956-fe54d5e405f1	Martingale Max Stake	Martingale com stake máximo configurável	martingale_max-stake.xml	FREE	ACTIVE	2026-02-24 21:31:07.017	2026-02-24 21:31:07.017	martingale_max_stake
cd620793-c251-45af-9d19-53cde80504d0	Oscars Grind Max Stake	Oscar Grind com stake máximo configurável	oscars_grind_max-stake.xml	FREE	ACTIVE	2026-02-24 21:31:07.03	2026-02-24 21:31:07.03	oscars_grind_max_stake
500873b4-b965-45a4-822f-fcfc6289729c	Reverse D Alembert	Estratégia D Alembert reverso	reverse_dalembert.xml	FREE	ACTIVE	2026-02-24 21:31:07.042	2026-02-24 21:31:07.042	reverse_dalembert
a85ca0a1-cc08-491f-8b6c-e162594f7cb5	Reverse Martingale	Estratégia Martingale reverso	reverse_martingale.xml	FREE	ACTIVE	2026-02-24 21:31:07.059	2026-02-24 21:31:07.059	reverse_martingale
bbe8e581-75b9-4f27-87a8-5fab72675a95	Eon Fibonacci	Even/Odd com Fibonacci Martingale - R_50	eon_fibonacci.xml	PAID	ACTIVE	2026-02-26 19:49:16.164	2026-02-26 19:49:16.164	eon_fibonacci
3bd28b15-e2b1-4168-a32e-a28edea7d245	Eon Paroli	Even/Odd com Anti-Martingale Paroli - R_50	eon_paroli.xml	PAID	ACTIVE	2026-02-26 19:49:16.182	2026-02-26 19:49:16.182	eon_paroli
\.


--
-- Data for Name: CourseLesson; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."CourseLesson" (id, module_id, title, youtube_url, "order", status, created_at, updated_at, description) FROM stdin;
d9e8b34a-e5f3-44a8-8cc8-a84464c5a9db	3e02f141-2fc5-429c-bdd2-0236f4355ab1	titulo da aula	https://www.youtube.com/watch?v=zz1h3vx7e0E	0	ACTIVE	2026-02-15 19:59:54.897	2026-02-15 19:59:54.897	\N
602bac57-2f0a-4feb-b668-13c9c541ce58	3e02f141-2fc5-429c-bdd2-0236f4355ab1	aula 2	https://www.youtube.com/watch?v=zz1h3vx7e0E	2	ACTIVE	2026-02-15 20:00:50.213	2026-02-15 20:00:50.213	\N
84cd14b6-5294-4db7-9821-d8cc9d770cb4	20b87496-cbcc-4da8-ae68-76f1e9da144e	aula 1 	https://www.youtube.com/watch?v=HNN-lCCYYNo&list=RDHNN-lCCYYNo&start_radio=1	0	ACTIVE	2026-02-08 23:02:52.241	2026-02-18 19:29:29.206	descriciaja ASJD SAD\nD\nDAS\nD\nASD\nASD\nASD\nAS\nD\nhttps://app.iaeon.site/admin\nS\nDSD\nSDD\nSD\nSD\n\n
\.


--
-- Data for Name: CourseModule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."CourseModule" (id, title, description, banner_url, "order", status, created_at, updated_at) FROM stdin;
20b87496-cbcc-4da8-ae68-76f1e9da144e	Cadastro		\N	0	ACTIVE	2026-02-08 23:02:03.253	2026-02-08 23:02:03.253
3e02f141-2fc5-429c-bdd2-0236f4355ab1	Titulo modulo 2	descricao modulo 2	\N	2	ACTIVE	2026-02-15 19:59:14.318	2026-02-15 19:59:14.318
\.


--
-- Data for Name: Plan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Plan" (id, name, description, price, duration_days, status, created_at, updated_at, is_default, checkout_url) FROM stdin;
8a2564f8-4ab8-4eed-9852-618abdfbe11d	IAeon Start	sspdosd	0.00	0	ACTIVE	2026-02-08 21:03:26.886	2026-02-13 13:42:31.001	t	\N
01ef6e4b-c374-4303-928f-f12d48fb6f14	IAeon Pro	descircoio dsodsd s	127.00	0	ACTIVE	2026-02-08 21:18:58.266	2026-03-10 18:16:15.761	f	https://go.perfectpay.com.br/PPU38COI0IB
\.


--
-- Data for Name: PlanBot; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PlanBot" (id, plan_id, bot_id) FROM stdin;
ae58069a-2748-4df7-a761-fcd7c480d40d	01ef6e4b-c374-4303-928f-f12d48fb6f14	3bd28b15-e2b1-4168-a32e-a28edea7d245
c0acfa21-611f-4ee9-8b52-2cfd4bf92220	01ef6e4b-c374-4303-928f-f12d48fb6f14	bbe8e581-75b9-4f27-87a8-5fab72675a95
e4f29f41-60b9-4bdc-ad14-1afbda1431c8	01ef6e4b-c374-4303-928f-f12d48fb6f14	47eec876-5aa2-4368-897a-a97d64565986
df61109d-37c9-4ab4-8cf2-d9f9a21f30ff	01ef6e4b-c374-4303-928f-f12d48fb6f14	f27df3a4-7074-4820-883c-d494724efaf8
9143a50d-82bd-40ac-ae55-5acadd8d1846	01ef6e4b-c374-4303-928f-f12d48fb6f14	f4884da9-89fe-49b8-8d0d-90807722ca1c
cb1f72f9-f819-48d5-ba92-82ec58d8ac47	8a2564f8-4ab8-4eed-9852-618abdfbe11d	77b438b0-d4c3-43ba-9ed4-2c167e293965
6f8586c6-090b-45db-839f-320614f1f2d9	01ef6e4b-c374-4303-928f-f12d48fb6f14	8a8b87a9-b872-4d2f-b5a7-d4d22a962861
caebdcf0-560a-4bb1-bf52-d84bcf3667ca	01ef6e4b-c374-4303-928f-f12d48fb6f14	3b47b5c7-6f26-4148-ac06-2e31db5050a4
12533c4d-5e82-424a-85ae-caeefdb543a9	01ef6e4b-c374-4303-928f-f12d48fb6f14	be6efbce-c027-4843-bcdc-68fa77babfef
e69fe413-6207-4b23-b514-4116bb6035d4	01ef6e4b-c374-4303-928f-f12d48fb6f14	1942ef29-fdf0-41d3-baf9-b3c2af780dab
3410174e-8d2a-4986-ae29-48c1317eddb8	01ef6e4b-c374-4303-928f-f12d48fb6f14	65e0a8bb-4091-4556-825c-a90aed859e02
f059674c-a624-4513-8d55-59a48699f177	01ef6e4b-c374-4303-928f-f12d48fb6f14	2dd5c9eb-ca9a-4d4c-8a75-34ce111a59e8
17f32760-74ee-40b6-807b-4ab54d9ddd0a	01ef6e4b-c374-4303-928f-f12d48fb6f14	38323f34-4dfb-42d7-8b0c-ec2fc74faa6f
448db6b2-2430-4517-94d2-b275fb839958	01ef6e4b-c374-4303-928f-f12d48fb6f14	e59429dc-ad23-4cb7-9c1a-c8b41eecab0c
4cd03658-8494-4c17-ac74-a510618a736d	01ef6e4b-c374-4303-928f-f12d48fb6f14	b250d063-0df5-4a59-98a4-04add4fda117
e890d81d-186d-4b26-969b-4f66a36fd094	01ef6e4b-c374-4303-928f-f12d48fb6f14	c44f9311-7ef0-4ac6-9e99-e2592d7e1a6e
58753248-c3b0-45b4-9bc4-1ed5c22aeed4	01ef6e4b-c374-4303-928f-f12d48fb6f14	0cf11b7d-7ee5-4d3e-a7ab-562b87ea9097
a1c2ae22-d48f-4c71-9eff-43fd63f50c68	01ef6e4b-c374-4303-928f-f12d48fb6f14	77b438b0-d4c3-43ba-9ed4-2c167e293965
877be454-4967-4d03-ac8f-672bf92a0a76	01ef6e4b-c374-4303-928f-f12d48fb6f14	92ae4a83-8f71-4262-98b0-cce40b5933c1
a649aef2-505f-49bb-b6a7-72f7f4c29059	01ef6e4b-c374-4303-928f-f12d48fb6f14	aee57e3f-94b2-4852-b28b-3fd65a91b844
81cbbf11-ac09-4c70-9bf5-02e64e78a51b	8a2564f8-4ab8-4eed-9852-618abdfbe11d	0eb1f533-55db-4bff-9514-95dae33f05e2
d1ca63dd-f6ba-4fa9-95d4-4808bfeb8e24	01ef6e4b-c374-4303-928f-f12d48fb6f14	0eb1f533-55db-4bff-9514-95dae33f05e2
d01638e0-e7ff-4c3d-ad82-2504f816b39b	8a2564f8-4ab8-4eed-9852-618abdfbe11d	07d172dd-0f8e-4eac-a956-fe54d5e405f1
84af9aa9-e380-4bf9-985a-ec5163be91d3	01ef6e4b-c374-4303-928f-f12d48fb6f14	07d172dd-0f8e-4eac-a956-fe54d5e405f1
65937aa2-9c67-4181-ad79-526f6c2b5838	8a2564f8-4ab8-4eed-9852-618abdfbe11d	cd620793-c251-45af-9d19-53cde80504d0
24c58862-4160-41dc-ab6f-ba0d56476ff7	01ef6e4b-c374-4303-928f-f12d48fb6f14	cd620793-c251-45af-9d19-53cde80504d0
eaac3fc8-b865-4a9a-a657-637d8b30d9ed	8a2564f8-4ab8-4eed-9852-618abdfbe11d	500873b4-b965-45a4-822f-fcfc6289729c
f494171d-08b4-43f1-ad48-e46dadabd4a6	01ef6e4b-c374-4303-928f-f12d48fb6f14	500873b4-b965-45a4-822f-fcfc6289729c
f64b4028-0b5e-47e9-91a6-711552d395eb	8a2564f8-4ab8-4eed-9852-618abdfbe11d	a85ca0a1-cc08-491f-8b6c-e162594f7cb5
8a227df6-5eb6-4582-9057-cce73af8e47a	01ef6e4b-c374-4303-928f-f12d48fb6f14	a85ca0a1-cc08-491f-8b6c-e162594f7cb5
\.


--
-- Data for Name: Setting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Setting" (id, key, value) FROM stdin;
d25c7f46-e55b-4a4d-b9d6-eb0e10ba731c	banca_data_0c6eb9a0-c4b3-4214-89b5-2ddb4123a1a1	{"meta_diaria":5,"max_perda":9,"dias":[{"dia":1},{"dia":2},{"dia":3},{"dia":4},{"dia":5},{"dia":6},{"dia":7},{"dia":8},{"dia":9},{"dia":10},{"dia":11},{"dia":12},{"dia":13},{"dia":14},{"dia":15},{"dia":16},{"dia":17},{"dia":18},{"dia":19},{"dia":20},{"dia":21},{"dia":22},{"dia":23},{"dia":24},{"dia":25},{"dia":26},{"dia":27},{"dia":28},{"dia":29},{"dia":30}]}
c5dfe763-e240-4e1c-abb8-08c90ca06db3	deriv_affiliate_token	_EDV-zT4Y2G9MjdsyM5hasGNd7ZgqdRLk
7cf2837b-1296-49e0-b1da-225efe12d049	deriv_signup_url	https://track.deriv.com/_EDV-zT4Y2G9MjdsyM5hasGNd7ZgqdRLk/1/
3b4c2766-2c9f-4129-8919-c21c0358061c	plan_01ef6e4b-c374-4303-928f-f12d48fb6f14_perfectpay_product	
14739481-df9f-45a9-a862-abe187ca33f6	banca_data_cf1b1a02-956c-4579-b524-4872d93c9e7a	{"meta_diaria":5,"max_perda":10,"dias":[{"dia":1,"deposito":100},{"dia":2},{"dia":3},{"dia":4},{"dia":5},{"dia":6},{"dia":7},{"dia":8},{"dia":9},{"dia":10},{"dia":11},{"dia":12},{"dia":13},{"dia":14},{"dia":15},{"dia":16},{"dia":17},{"dia":18},{"dia":19},{"dia":20},{"dia":21},{"dia":22},{"dia":23},{"dia":24},{"dia":25},{"dia":26},{"dia":27},{"dia":28},{"dia":29},{"dia":30}]}
5379b84b-d0f9-4d6d-b59f-aff933aec18d	support_url	
7bbd9ecf-4cc0-4c4a-b8bf-cb3f38cc438a	primary_color	#00d4aa
bbe72abc-35c8-42d1-8f59-7e6324f93309	platform_name	Eon Pro
68155e3d-9eaa-44a3-9b6b-ca8058943630	banca_data_d1bca9f9-a64b-4b3a-a8ef-839b57d01f74	{"meta_diaria":5,"max_perda":9,"dias":[{"dia":1,"deposito":100},{"dia":2,"saldo_final":0},{"dia":3},{"dia":4},{"dia":5},{"dia":6},{"dia":7},{"dia":8},{"dia":9},{"dia":10},{"dia":11},{"dia":12},{"dia":13},{"dia":14},{"dia":15},{"dia":16},{"dia":17},{"dia":18},{"dia":19},{"dia":20},{"dia":21},{"dia":22},{"dia":23},{"dia":24},{"dia":25},{"dia":26},{"dia":27},{"dia":28},{"dia":29},{"dia":30}]}
e00c733e-3e37-4078-b12e-5a9c3748c5cb	checkout_url	https://pay.perfectpay.com.br/SEUCHECKOUT
7009a34d-ef31-4b7b-b494-d375799fb813	telegram_url	
72814194-eb85-43dd-96dc-8111e2a3a591	whatsapp_url	
178b4421-031c-469e-8cb3-f26bdfa7a8e2	useful_links	[{"label":"Whatsapp","url":"https://wa.me/5519988280392","icon":"whatsapp"},{"label":"Canal Telegram","url":"https://augustofreires.com.br/teste/","icon":"telegram"},{"label":"Youtube EonPro","url":"https://augustofreires.com.br/","icon":"youtube"}]
635ce9ea-afe5-47ab-b897-ecf0793c738f	platform_subtitle	plataforma de bots
85c766a4-6ed7-4efc-96dc-0fb1f84e6bc3	meta_pixel_id	
1c9895b7-aa9e-4aa0-acca-9a5cd50a7ba6	banca_data_b62eebd1-cbff-4bca-9722-d82af8803a9c	{"meta_diaria":5,"max_perda":9,"dias":[{"dia":1},{"dia":2},{"dia":3},{"dia":4},{"dia":5},{"dia":6},{"dia":7},{"dia":8},{"dia":9},{"dia":10},{"dia":11},{"dia":12},{"dia":13},{"dia":14},{"dia":15},{"dia":16},{"dia":17},{"dia":18},{"dia":19},{"dia":20},{"dia":21},{"dia":22},{"dia":23},{"dia":24},{"dia":25},{"dia":26},{"dia":27},{"dia":28},{"dia":29},{"dia":30}]}
d88ae19a-8bec-4477-ad22-34877ce401c3	deriv_markup_token	3WtwBJxNPQj380S
eb0240b2-c806-4539-90cd-edba3fce2603	meta_pixel_token	
ea2a229c-7e3f-47ee-aa1f-abe1f6526db5	banca_data_5577146c-94da-4a29-b35a-4d1985f4c4f5	{"meta_diaria":5,"max_perda":9,"dias":[{"dia":1},{"dia":2},{"dia":3},{"dia":4},{"dia":5},{"dia":6},{"dia":7},{"dia":8},{"dia":9},{"dia":10},{"dia":11},{"dia":12},{"dia":13},{"dia":14},{"dia":15},{"dia":16},{"dia":17},{"dia":18},{"dia":19},{"dia":20},{"dia":21},{"dia":22},{"dia":23},{"dia":24},{"dia":25},{"dia":26},{"dia":27},{"dia":28},{"dia":29},{"dia":30}]}
4eabcd4b-383c-4f02-9e72-0b9b1b0a5991	perfectpay_webhook_token	12d52c5cf8c1993fbd5da8252539e645
c8ae449f-2154-459e-a8b4-b0ae96016fc9	banca_data_f954d0ef-17e0-491a-929b-bc48a04efe0e	{"meta_diaria":5,"max_perda":9,"dias":[{"dia":1},{"dia":2},{"dia":3},{"dia":4},{"dia":5},{"dia":6},{"dia":7},{"dia":8},{"dia":9},{"dia":10},{"dia":11},{"dia":12},{"dia":13},{"dia":14},{"dia":15},{"dia":16},{"dia":17},{"dia":18},{"dia":19},{"dia":20},{"dia":21},{"dia":22},{"dia":23},{"dia":24},{"dia":25},{"dia":26},{"dia":27},{"dia":28},{"dia":29},{"dia":30}]}
800ad3eb-bdf6-4d4f-9a0a-e8a2f57dbf01	banca_data_32a229ad-7a9a-465e-9629-5c436a3ad664	{"meta_diaria":5,"max_perda":9,"dias":[{"dia":1},{"dia":2},{"dia":3},{"dia":4},{"dia":5},{"dia":6},{"dia":7},{"dia":8},{"dia":9},{"dia":10},{"dia":11},{"dia":12},{"dia":13},{"dia":14},{"dia":15},{"dia":16},{"dia":17},{"dia":18},{"dia":19},{"dia":20},{"dia":21},{"dia":22},{"dia":23},{"dia":24},{"dia":25},{"dia":26},{"dia":27},{"dia":28},{"dia":29},{"dia":30}]}
5d17f409-5cd4-4e93-82d4-69a5bc201cc8	favicon_url	/faviconeon.png
215a5897-c649-410e-90b4-9bb52a3edecb	dashboard_banners	[{"id": "1", "title": "Operar Bots", "subtitle": "Acesse seus bots e opere", "image_url": "", "gradient": "linear-gradient(135deg, #0a2a1a 0%, #00d4aa 100%)", "link": "/bot", "order": 1, "active": true}, {"id": "2", "title": "Video-Aulas", "subtitle": "Aprenda a operar", "image_url": "", "gradient": "linear-gradient(135deg, #1a0a2e 0%, #6c3ce0 100%)", "link": "/cursos", "order": 2, "active": true}, {"id": "3", "title": "Escolha seu Plano", "subtitle": "Desbloqueie todos os bots", "image_url": "", "gradient": "linear-gradient(135deg, #2a1a0a 0%, #d4a000 100%)", "link": "/planos", "order": 3, "active": true}, {"id": "4", "title": "Links Uteis", "subtitle": "Telegram, WhatsApp e mais", "image_url": "", "gradient": "linear-gradient(135deg, #0a1a2e 0%, #0088d4 100%)", "link": "/links", "order": 4, "active": true}, {"id": "5", "title": "Meu Perfil", "subtitle": "Gerencie sua conta", "image_url": "", "gradient": "linear-gradient(135deg, #1a0a1a 0%, #d400aa 100%)", "link": "/perfil", "order": 5, "active": true}]
b9faf510-8090-40c5-a7f9-fd8e1c2fa9a5	logo_url	/eonlogo.png
\.


--
-- Data for Name: Subscription; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Subscription" (id, user_id, plan_id, started_at, expires_at, status, payment_source, payment_reference, created_at, updated_at) FROM stdin;
a0f0ec81-86c8-4090-8851-2ec8e89bb09b	cf1b1a02-956c-4579-b524-4872d93c9e7a	01ef6e4b-c374-4303-928f-f12d48fb6f14	2026-02-16 16:51:32.623	\N	ACTIVE	MANUAL	ADMIN-1771260692621	2026-02-16 16:51:32.623	2026-02-16 16:51:32.623
31dd28cc-1304-4f6d-be7e-4c58d0a330f6	3f9062a5-7c15-4fff-8e54-5cacd6594f9c	01ef6e4b-c374-4303-928f-f12d48fb6f14	2026-02-20 14:18:06.95	\N	CANCELLED	PERFECTPAY	PPCPMTB5HBBF0K	2026-02-20 14:18:06.952	2026-02-20 14:30:21.476
\.


--
-- Name: Bot Bot_internal_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Bot"
    ADD CONSTRAINT "Bot_internal_id_key" UNIQUE (internal_id);


--
-- Name: Bot Bot_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Bot"
    ADD CONSTRAINT "Bot_pkey" PRIMARY KEY (id);


--
-- Name: CourseLesson CourseLesson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CourseLesson"
    ADD CONSTRAINT "CourseLesson_pkey" PRIMARY KEY (id);


--
-- Name: CourseModule CourseModule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CourseModule"
    ADD CONSTRAINT "CourseModule_pkey" PRIMARY KEY (id);


--
-- Name: PlanBot PlanBot_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlanBot"
    ADD CONSTRAINT "PlanBot_pkey" PRIMARY KEY (id);


--
-- Name: Plan Plan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Plan"
    ADD CONSTRAINT "Plan_pkey" PRIMARY KEY (id);


--
-- Name: Setting Setting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Setting"
    ADD CONSTRAINT "Setting_pkey" PRIMARY KEY (id);


--
-- Name: SmtpConfig SmtpConfig_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SmtpConfig"
    ADD CONSTRAINT "SmtpConfig_pkey" PRIMARY KEY (id);


--
-- Name: Subscription Subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subscription"
    ADD CONSTRAINT "Subscription_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: WebhookLog WebhookLog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WebhookLog"
    ADD CONSTRAINT "WebhookLog_pkey" PRIMARY KEY (id);


--
-- Name: PlanBot_plan_id_bot_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "PlanBot_plan_id_bot_id_key" ON public."PlanBot" USING btree (plan_id, bot_id);


--
-- Name: Setting_key_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Setting_key_key" ON public."Setting" USING btree (key);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: CourseLesson CourseLesson_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CourseLesson"
    ADD CONSTRAINT "CourseLesson_module_id_fkey" FOREIGN KEY (module_id) REFERENCES public."CourseModule"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PlanBot PlanBot_bot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlanBot"
    ADD CONSTRAINT "PlanBot_bot_id_fkey" FOREIGN KEY (bot_id) REFERENCES public."Bot"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PlanBot PlanBot_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PlanBot"
    ADD CONSTRAINT "PlanBot_plan_id_fkey" FOREIGN KEY (plan_id) REFERENCES public."Plan"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Subscription Subscription_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subscription"
    ADD CONSTRAINT "Subscription_plan_id_fkey" FOREIGN KEY (plan_id) REFERENCES public."Plan"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Subscription Subscription_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Subscription"
    ADD CONSTRAINT "Subscription_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict gmeQheKaAaxMnkMHYT8Qpim6aUVzWNrNc9Ga2plc4itvZMnL8idkCC2YDekdpxV

