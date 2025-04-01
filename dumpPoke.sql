--
-- PostgreSQL database dump
--

-- Dumped from database version 17.1 (Debian 17.1-1.pgdg120+1)
-- Dumped by pg_dump version 17.1 (Debian 17.1-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ability (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.ability OWNER TO postgres;

--
-- Name: ability_pokemon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ability_pokemon (
    id_pokemon_fk integer NOT NULL,
    id_ability_fk integer NOT NULL
);


ALTER TABLE public.ability_pokemon OWNER TO postgres;

--
-- Name: contest_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contest_type (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.contest_type OWNER TO postgres;

--
-- Name: evolution_chain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evolution_chain (
    id integer NOT NULL,
    min_affection integer,
    min_beauty integer,
    min_happiness integer,
    min_level integer,
    gender integer,
    time_of_day character varying(5),
    needs_overworld_rain boolean,
    relative_physical_stats integer,
    turn_upside_down boolean,
    id_species_fk integer NOT NULL,
    id_evolution_trigger_fk integer
);


ALTER TABLE public.evolution_chain OWNER TO postgres;

--
-- Name: evolution_trigger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evolution_trigger (
    id integer NOT NULL,
    name character varying(100),
    id_species_fk integer NOT NULL
);


ALTER TABLE public.evolution_trigger OWNER TO postgres;

--
-- Name: generation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.generation (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.generation OWNER TO postgres;

--
-- Name: move_ailment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.move_ailment (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.move_ailment OWNER TO postgres;

--
-- Name: move_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.move_category (
    id integer NOT NULL,
    name character varying(100),
    id_moves_fk integer NOT NULL
);


ALTER TABLE public.move_category OWNER TO postgres;

--
-- Name: move_damage_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.move_damage_classes (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.move_damage_classes OWNER TO postgres;

--
-- Name: move_target; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.move_target (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.move_target OWNER TO postgres;

--
-- Name: moves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moves (
    id integer NOT NULL,
    name character varying(100),
    accuracy integer,
    effect_chance integer,
    pp integer,
    power integer,
    priority integer,
    id_contest_type_fk integer NOT NULL
);


ALTER TABLE public.moves OWNER TO postgres;

--
-- Name: moves_move_ailment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moves_move_ailment (
    id_moves_fk integer NOT NULL,
    id_move_ailment_fk integer NOT NULL
);


ALTER TABLE public.moves_move_ailment OWNER TO postgres;

--
-- Name: moves_move_damage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moves_move_damage (
    id_moves_fk integer NOT NULL,
    id_move_damage_fk integer NOT NULL
);


ALTER TABLE public.moves_move_damage OWNER TO postgres;

--
-- Name: moves_move_target; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moves_move_target (
    id_moves_fk integer NOT NULL,
    id_move_target_fk integer NOT NULL
);


ALTER TABLE public.moves_move_target OWNER TO postgres;

--
-- Name: pokemon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokemon (
    id integer NOT NULL,
    name character varying(100),
    height double precision,
    weight double precision,
    id_species_fk integer NOT NULL
);


ALTER TABLE public.pokemon OWNER TO postgres;

--
-- Name: pokemon_moves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pokemon_moves (
    id_moves_fk integer NOT NULL,
    id_pokemon_fk integer NOT NULL
);


ALTER TABLE public.pokemon_moves OWNER TO postgres;

--
-- Name: shape; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shape (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.shape OWNER TO postgres;

--
-- Name: species; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.species (
    id integer NOT NULL,
    name character varying(100),
    is_baby boolean,
    is_mythical boolean,
    is_legendary boolean,
    id_shape_fk integer NOT NULL,
    id_generation_fk integer NOT NULL
);


ALTER TABLE public.species OWNER TO postgres;

--
-- Name: type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.type OWNER TO postgres;

--
-- Name: type_pokemon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_pokemon (
    id_pokemon_fk integer NOT NULL,
    id_type_fk integer NOT NULL,
    slot integer
);


ALTER TABLE public.type_pokemon OWNER TO postgres;

--
-- Data for Name: ability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ability (id, name) FROM stdin;
22	intimidate
61	shed-skin
127	unnerve
9	static
31	lightning-rod
8	sand-veil
146	sand-rush
38	poison-point
79	rivalry
55	hustle
125	sheer-force
56	cute-charm
98	magic-guard
132	friend-guard
109	unaware
18	flash-fire
70	drought
172	competitive
119	frisk
39	inner-focus
151	infiltrator
34	chlorophyll
50	run-away
1	stench
27	effect-spore
87	dry-skin
6	damp
14	compound-eyes
110	tinted-lens
19	shield-dust
147	wonder-skin
71	arena-trap
159	sand-force
53	pickup
101	technician
7	limber
13	cloud-nine
33	swift-swim
\.


--
-- Data for Name: ability_pokemon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ability_pokemon (id_pokemon_fk, id_ability_fk) FROM stdin;
24	22
24	61
24	127
25	9
25	31
26	9
26	31
27	8
27	146
28	8
28	146
29	38
29	79
29	55
30	38
30	79
30	55
31	38
31	79
31	125
32	38
32	79
32	55
33	38
33	79
33	55
34	38
34	79
34	125
35	56
35	98
35	132
36	56
36	98
36	109
37	18
37	70
38	18
38	70
39	56
39	172
39	132
40	56
40	172
40	119
41	39
41	151
42	39
42	151
43	34
43	50
44	34
44	1
45	34
45	27
46	27
46	87
46	6
47	27
47	87
47	6
48	14
48	110
48	50
49	19
49	110
49	147
50	8
50	71
50	159
51	8
51	71
51	159
52	53
52	101
52	127
53	7
53	101
53	127
54	6
54	13
54	33
\.


--
-- Data for Name: contest_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contest_type (id, name) FROM stdin;
5	tough
4	smart
1	cool
2	beauty
3	cute
\.


--
-- Data for Name: evolution_chain; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evolution_chain (id, min_affection, min_beauty, min_happiness, min_level, gender, time_of_day, needs_overworld_rain, relative_physical_stats, turn_upside_down, id_species_fk, id_evolution_trigger_fk) FROM stdin;
9	\N	\N	\N	22	\N		f	\N	f	24	1
10	\N	\N	220	\N	\N		f	\N	f	25	1
11	\N	\N	\N	22	\N		f	\N	f	27	1
12	\N	\N	\N	16	\N		f	\N	f	29	1
13	\N	\N	\N	16	\N		f	\N	f	32	1
14	\N	\N	160	\N	\N		f	\N	f	35	1
15	\N	\N	\N	\N	\N		f	\N	f	37	3
16	\N	\N	160	\N	\N		f	\N	f	39	1
17	\N	\N	\N	22	\N		f	\N	f	41	1
18	\N	\N	\N	21	\N		f	\N	f	43	1
19	\N	\N	\N	24	\N		f	\N	f	46	1
20	\N	\N	\N	31	\N		f	\N	f	48	1
21	\N	\N	\N	26	\N		f	\N	f	50	1
22	\N	\N	\N	28	\N		f	\N	f	52	1
23	\N	\N	\N	33	\N		f	\N	f	54	1
\.


--
-- Data for Name: evolution_trigger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evolution_trigger (id, name, id_species_fk) FROM stdin;
1	level-up	24
3	use-item	37
\.


--
-- Data for Name: generation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.generation (id, name) FROM stdin;
1	generation-i
\.


--
-- Data for Name: move_ailment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.move_ailment (id, name) FROM stdin;
8	trap
0	none
1	paralysis
4	burn
3	freeze
6	confusion
13	disable
\.


--
-- Data for Name: move_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.move_category (id, name, id_moves_fk) FROM stdin;
4	damage+ailment	20
0	damage	21
2	net-good-stats	14
9	ohko	32
12	force-switch	18
6	damage+lower	51
1	ailment	48
13	unique	50
\.


--
-- Data for Name: move_damage_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.move_damage_classes (id, name) FROM stdin;
2	physical
1	status
3	special
\.


--
-- Data for Name: move_target; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.move_target (id, name) FROM stdin;
10	selected-pokemon
7	user
11	all-opponents
\.


--
-- Data for Name: moves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moves (id, name, accuracy, effect_chance, pp, power, priority, id_contest_type_fk) FROM stdin;
20	bind	85	100	20	15	0	5
21	slam	75	\N	20	80	0	5
29	headbutt	100	30	15	70	0	5
34	body-slam	100	30	15	85	0	5
35	wrap	90	100	20	15	0	5
36	take-down	85	\N	20	90	0	5
5	mega-punch	85	\N	20	80	0	5
6	pay-day	100	\N	20	40	0	4
9	thunder-punch	100	10	15	75	0	1
24	double-kick	100	\N	30	30	0	1
25	mega-kick	75	\N	5	120	0	1
10	scratch	100	\N	35	40	0	5
14	swords-dance	\N	\N	20	\N	0	2
15	cut	95	\N	30	50	0	1
28	sand-attack	100	\N	15	\N	0	3
33	tackle	100	\N	35	40	0	5
32	horn-drill	30	\N	5	\N	0	1
7	fire-punch	100	10	15	75	0	2
8	ice-punch	100	10	15	75	0	2
30	horn-attack	100	\N	25	65	0	1
31	fury-attack	85	\N	20	15	0	1
1	pound	100	\N	35	40	0	5
3	double-slap	85	\N	10	15	0	5
38	double-edge	100	\N	15	120	0	5
39	tail-whip	100	\N	30	\N	0	3
13	razor-wind	100	\N	10	80	0	1
16	gust	100	\N	35	40	0	4
17	wing-attack	100	\N	35	60	0	1
18	whirlwind	\N	\N	20	\N	-6	4
19	fly	95	\N	15	90	0	4
51	acid	100	10	30	40	0	4
48	supersonic	55	\N	20	\N	0	4
50	disable	100	\N	20	\N	0	4
\.


--
-- Data for Name: moves_move_ailment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moves_move_ailment (id_moves_fk, id_move_ailment_fk) FROM stdin;
20	8
21	0
29	0
34	1
35	8
36	0
5	0
6	0
9	1
24	0
25	0
10	0
14	0
15	0
28	0
33	0
32	0
7	4
8	3
30	0
31	0
1	0
3	0
38	0
39	0
13	0
16	0
17	0
18	0
19	0
51	0
48	6
50	13
\.


--
-- Data for Name: moves_move_damage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moves_move_damage (id_moves_fk, id_move_damage_fk) FROM stdin;
20	2
21	2
29	2
34	2
35	2
36	2
5	2
6	2
9	2
24	2
25	2
10	2
14	1
15	2
28	1
33	2
32	2
7	2
8	2
30	2
31	2
1	2
3	2
38	2
39	1
13	3
16	3
17	2
18	1
19	2
51	3
48	1
50	1
\.


--
-- Data for Name: moves_move_target; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moves_move_target (id_moves_fk, id_move_target_fk) FROM stdin;
20	10
21	10
29	10
34	10
35	10
36	10
5	10
6	10
9	10
24	10
25	10
10	10
14	7
15	10
28	10
33	10
32	10
7	10
8	10
30	10
31	10
1	10
3	10
38	10
39	11
13	11
16	10
17	10
18	10
19	10
51	11
48	10
50	10
\.


--
-- Data for Name: pokemon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokemon (id, name, height, weight, id_species_fk) FROM stdin;
24	arbok	35	650	24
25	pikachu	4	60	25
26	raichu	8	300	26
27	sandshrew	6	120	27
28	sandslash	10	295	28
29	nidoran-f	4	70	29
30	nidorina	8	200	30
31	nidoqueen	13	600	31
32	nidoran-m	5	90	32
33	nidorino	9	195	33
34	nidoking	14	620	34
35	clefairy	6	75	35
36	clefable	13	400	36
37	vulpix	6	99	37
38	ninetales	11	199	38
39	jigglypuff	5	55	39
40	wigglytuff	10	120	40
41	zubat	8	75	41
42	golbat	16	550	42
43	oddish	5	54	43
44	gloom	8	86	44
45	vileplume	12	186	45
46	paras	3	54	46
47	parasect	10	295	47
48	venonat	10	300	48
49	venomoth	15	125	49
50	diglett	2	8	50
51	dugtrio	7	333	51
52	meowth	4	42	52
53	persian	10	320	53
54	psyduck	8	196	54
\.


--
-- Data for Name: pokemon_moves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pokemon_moves (id_moves_fk, id_pokemon_fk) FROM stdin;
20	24
21	24
29	24
34	24
35	24
36	24
5	25
6	25
9	25
21	25
24	25
25	25
5	26
6	26
9	26
21	26
25	26
29	26
10	27
14	27
15	27
28	27
29	27
34	27
10	28
14	28
15	28
28	28
29	28
34	28
10	29
15	29
24	29
29	29
33	29
34	29
10	30
15	30
24	30
29	30
32	30
33	30
5	31
6	31
7	31
8	31
9	31
10	31
15	32
24	32
29	32
30	32
31	32
32	32
15	33
24	33
29	33
30	33
31	33
32	33
5	34
6	34
7	34
8	34
9	34
15	34
1	35
3	35
5	35
7	35
8	35
9	35
1	36
3	36
5	36
7	36
8	36
9	36
29	37
33	37
34	37
36	37
38	37
39	37
29	38
33	38
34	38
36	38
38	38
39	38
1	39
3	39
5	39
7	39
8	39
9	39
1	40
3	40
5	40
7	40
8	40
9	40
13	41
16	41
17	41
18	41
19	41
29	41
13	42
16	42
17	42
18	42
19	42
29	42
14	43
15	43
29	43
36	43
38	43
51	43
14	44
15	44
29	44
36	44
38	44
51	44
14	45
15	45
29	45
34	45
36	45
38	45
10	46
14	46
15	46
29	46
34	46
36	46
10	47
14	47
15	47
29	47
34	47
36	47
29	48
33	48
36	48
38	48
48	48
50	48
13	49
16	49
18	49
29	49
33	49
36	49
10	50
14	50
15	50
28	50
29	50
34	50
10	51
14	51
15	51
28	51
29	51
34	51
6	52
10	52
15	52
29	52
34	52
36	52
6	53
10	53
15	53
29	53
34	53
36	53
5	54
6	54
8	54
10	54
25	54
29	54
\.


--
-- Data for Name: shape; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shape (id, name) FROM stdin;
2	squiggle
8	quadruped
6	upright
12	humanoid
9	wings
7	legs
14	armor
13	bug-wings
5	blob
11	heads
\.


--
-- Data for Name: species; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.species (id, name, is_baby, is_mythical, is_legendary, id_shape_fk, id_generation_fk) FROM stdin;
24	arbok	f	f	f	2	1
25	pikachu	f	f	f	8	1
26	raichu	f	f	f	6	1
27	sandshrew	f	f	f	6	1
28	sandslash	f	f	f	6	1
29	nidoran-f	f	f	f	8	1
30	nidorina	f	f	f	8	1
31	nidoqueen	f	f	f	6	1
32	nidoran-m	f	f	f	8	1
33	nidorino	f	f	f	8	1
34	nidoking	f	f	f	6	1
35	clefairy	f	f	f	6	1
36	clefable	f	f	f	6	1
37	vulpix	f	f	f	8	1
38	ninetales	f	f	f	8	1
39	jigglypuff	f	f	f	12	1
40	wigglytuff	f	f	f	12	1
41	zubat	f	f	f	9	1
42	golbat	f	f	f	9	1
43	oddish	f	f	f	7	1
44	gloom	f	f	f	12	1
45	vileplume	f	f	f	12	1
46	paras	f	f	f	14	1
47	parasect	f	f	f	14	1
48	venonat	f	f	f	12	1
49	venomoth	f	f	f	13	1
50	diglett	f	f	f	5	1
51	dugtrio	f	f	f	11	1
52	meowth	f	f	f	8	1
53	persian	f	f	f	8	1
54	psyduck	f	f	f	6	1
\.


--
-- Data for Name: type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type (id, name) FROM stdin;
4	poison
13	electric
5	ground
18	fairy
10	fire
1	normal
3	flying
12	grass
7	bug
11	water
\.


--
-- Data for Name: type_pokemon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_pokemon (id_pokemon_fk, id_type_fk, slot) FROM stdin;
24	4	1
25	13	1
26	13	1
27	5	1
28	5	1
29	4	1
30	4	1
31	4	1
31	5	2
32	4	1
33	4	1
34	4	1
34	5	2
35	18	1
36	18	1
37	10	1
38	10	1
39	1	1
39	18	2
40	1	1
40	18	2
41	4	1
41	3	2
42	4	1
42	3	2
43	12	1
43	4	2
44	12	1
44	4	2
45	12	1
45	4	2
46	7	1
46	12	2
47	7	1
47	12	2
48	7	1
48	4	2
49	7	1
49	4	2
50	5	1
51	5	1
52	1	1
53	1	1
54	11	1
\.


--
-- Name: ability ability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ability
    ADD CONSTRAINT ability_pkey PRIMARY KEY (id);


--
-- Name: ability_pokemon ability_pokemon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ability_pokemon
    ADD CONSTRAINT ability_pokemon_pkey PRIMARY KEY (id_pokemon_fk, id_ability_fk);


--
-- Name: evolution_chain evolution_chain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evolution_chain
    ADD CONSTRAINT evolution_chain_pkey PRIMARY KEY (id);


--
-- Name: evolution_trigger evolution_trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evolution_trigger
    ADD CONSTRAINT evolution_trigger_pkey PRIMARY KEY (id);


--
-- Name: generation generation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generation
    ADD CONSTRAINT generation_pkey PRIMARY KEY (id);


--
-- Name: move_ailment move_ailment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.move_ailment
    ADD CONSTRAINT move_ailment_pkey PRIMARY KEY (id);


--
-- Name: move_category move_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.move_category
    ADD CONSTRAINT move_category_pkey PRIMARY KEY (id);


--
-- Name: contest_type move_contest__type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contest_type
    ADD CONSTRAINT move_contest__type_pkey PRIMARY KEY (id);


--
-- Name: move_damage_classes move_damage_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.move_damage_classes
    ADD CONSTRAINT move_damage_classes_pkey PRIMARY KEY (id);


--
-- Name: move_target move_target_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.move_target
    ADD CONSTRAINT move_target_pkey PRIMARY KEY (id);


--
-- Name: moves_move_ailment moves_move_ailment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_ailment
    ADD CONSTRAINT moves_move_ailment_pkey PRIMARY KEY (id_moves_fk, id_move_ailment_fk);


--
-- Name: moves_move_damage moves_move_damage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_damage
    ADD CONSTRAINT moves_move_damage_pkey PRIMARY KEY (id_moves_fk, id_move_damage_fk);


--
-- Name: moves_move_target moves_move_target_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_target
    ADD CONSTRAINT moves_move_target_pkey PRIMARY KEY (id_moves_fk, id_move_target_fk);


--
-- Name: moves moves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves
    ADD CONSTRAINT moves_pkey PRIMARY KEY (id);


--
-- Name: pokemon_moves pokemon_moves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_moves
    ADD CONSTRAINT pokemon_moves_pkey PRIMARY KEY (id_moves_fk, id_pokemon_fk);


--
-- Name: pokemon pokemon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon
    ADD CONSTRAINT pokemon_pkey PRIMARY KEY (id);


--
-- Name: shape shape_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shape
    ADD CONSTRAINT shape_pkey PRIMARY KEY (id);


--
-- Name: species species_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (id);


--
-- Name: type type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type
    ADD CONSTRAINT type_pkey PRIMARY KEY (id);


--
-- Name: type_pokemon type_pokemon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_pokemon
    ADD CONSTRAINT type_pokemon_pkey PRIMARY KEY (id_pokemon_fk, id_type_fk);


--
-- Name: ability_pokemon ability_pokemon_ability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ability_pokemon
    ADD CONSTRAINT ability_pokemon_ability_id_fkey FOREIGN KEY (id_ability_fk) REFERENCES public.ability(id);


--
-- Name: ability_pokemon ability_pokemon_pokemon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ability_pokemon
    ADD CONSTRAINT ability_pokemon_pokemon_id_fkey FOREIGN KEY (id_pokemon_fk) REFERENCES public.pokemon(id);


--
-- Name: moves contest_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves
    ADD CONSTRAINT contest_type_fk FOREIGN KEY (id_contest_type_fk) REFERENCES public.contest_type(id) NOT VALID;


--
-- Name: evolution_chain evolution_chain_evolution_trigger_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evolution_chain
    ADD CONSTRAINT evolution_chain_evolution_trigger_fk_fkey FOREIGN KEY (id_evolution_trigger_fk) REFERENCES public.evolution_trigger(id);


--
-- Name: evolution_chain evolution_chain_species_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evolution_chain
    ADD CONSTRAINT evolution_chain_species_fk_fkey FOREIGN KEY (id_species_fk) REFERENCES public.species(id);


--
-- Name: evolution_trigger evolution_trigger_species_evolution_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evolution_trigger
    ADD CONSTRAINT evolution_trigger_species_evolution_fkey FOREIGN KEY (id_species_fk) REFERENCES public.species(id);


--
-- Name: species generation_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT generation_fk FOREIGN KEY (id_generation_fk) REFERENCES public.generation(id) NOT VALID;


--
-- Name: move_category move_category_id_moves_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.move_category
    ADD CONSTRAINT move_category_id_moves_fk_fkey FOREIGN KEY (id_moves_fk) REFERENCES public.moves(id);


--
-- Name: moves_move_ailment moves_move_ailment_id_move_ailment_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_ailment
    ADD CONSTRAINT moves_move_ailment_id_move_ailment_fk_fkey FOREIGN KEY (id_move_ailment_fk) REFERENCES public.move_ailment(id);


--
-- Name: moves_move_ailment moves_move_ailment_id_moves_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_ailment
    ADD CONSTRAINT moves_move_ailment_id_moves_fk_fkey FOREIGN KEY (id_moves_fk) REFERENCES public.moves(id);


--
-- Name: moves_move_damage moves_move_damage_id_move_damage_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_damage
    ADD CONSTRAINT moves_move_damage_id_move_damage_fk_fkey FOREIGN KEY (id_move_damage_fk) REFERENCES public.move_damage_classes(id);


--
-- Name: moves_move_damage moves_move_damage_id_moves_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_damage
    ADD CONSTRAINT moves_move_damage_id_moves_fk_fkey FOREIGN KEY (id_moves_fk) REFERENCES public.moves(id);


--
-- Name: moves_move_target moves_move_target_id_move_target_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_target
    ADD CONSTRAINT moves_move_target_id_move_target_fk_fkey FOREIGN KEY (id_move_target_fk) REFERENCES public.move_target(id);


--
-- Name: moves_move_target moves_move_target_id_moves_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moves_move_target
    ADD CONSTRAINT moves_move_target_id_moves_fk_fkey FOREIGN KEY (id_moves_fk) REFERENCES public.moves(id);


--
-- Name: pokemon_moves pokemon_moves_id_moves_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_moves
    ADD CONSTRAINT pokemon_moves_id_moves_fk_fkey FOREIGN KEY (id_moves_fk) REFERENCES public.moves(id);


--
-- Name: pokemon_moves pokemon_moves_id_pokemon_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon_moves
    ADD CONSTRAINT pokemon_moves_id_pokemon_fk_fkey FOREIGN KEY (id_pokemon_fk) REFERENCES public.pokemon(id);


--
-- Name: species shape_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT shape_fk FOREIGN KEY (id_shape_fk) REFERENCES public.shape(id) NOT VALID;


--
-- Name: pokemon species_pokemon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pokemon
    ADD CONSTRAINT species_pokemon FOREIGN KEY (id_species_fk) REFERENCES public.species(id);


--
-- Name: type_pokemon type_pokemon_pokemon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_pokemon
    ADD CONSTRAINT type_pokemon_pokemon_id_fkey FOREIGN KEY (id_pokemon_fk) REFERENCES public.pokemon(id);


--
-- Name: type_pokemon type_pokemon_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_pokemon
    ADD CONSTRAINT type_pokemon_type_id_fkey FOREIGN KEY (id_type_fk) REFERENCES public.type(id);


--
-- PostgreSQL database dump complete
--

