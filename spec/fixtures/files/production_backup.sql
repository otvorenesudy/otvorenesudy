--
-- PostgreSQL database cluster dump
--

\restrict 6fQ1W9S0od3ChAIyB3o4FCLQXLejnkmjoea6tnRLkdAgnvQCwn29rfePyomy86C

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE opencourts;
ALTER ROLE opencourts WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:dK4e9Jtrnqi8wPoJt8ApsQ==$L0C/90gbvyfcmXeoruzl1SYLz4nLGsjG2HuOk4FUU4E=:6R/Ze15WuuQ+a+Bn0paDvE2ddYMWdwBBrU/y+svX2qc=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








\unrestrict 6fQ1W9S0od3ChAIyB3o4FCLQXLejnkmjoea6tnRLkdAgnvQCwn29rfePyomy86C

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict Nq43wedIMJSM6midOSZuRsCOqSIkyN75Gal6xyAgsY1JctsrFhSI26W8yFxW8fd

-- Dumped from database version 17.11 (Homebrew)
-- Dumped by pg_dump version 17.11 (Homebrew)

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

--
-- PostgreSQL database dump complete
--

\unrestrict Nq43wedIMJSM6midOSZuRsCOqSIkyN75Gal6xyAgsY1JctsrFhSI26W8yFxW8fd

--
-- Database "opencourts_api" dump
--

--
-- PostgreSQL database dump
--

\restrict g85ohjInRqspJX3rgRBLWmRCaCgPqNWkoD3mNwNhxTDnbPq5swFLHxYwxxIJt6e

-- Dumped from database version 17.11 (Homebrew)
-- Dumped by pg_dump version 17.11 (Homebrew)

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

--
-- Name: opencourts_api; Type: DATABASE; Schema: -; Owner: opencourts
--

CREATE DATABASE opencourts_api WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE opencourts_api OWNER TO opencourts;

\unrestrict g85ohjInRqspJX3rgRBLWmRCaCgPqNWkoD3mNwNhxTDnbPq5swFLHxYwxxIJt6e
\connect opencourts_api
\restrict g85ohjInRqspJX3rgRBLWmRCaCgPqNWkoD3mNwNhxTDnbPq5swFLHxYwxxIJt6e

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
-- Name: api_keys; Type: TABLE; Schema: public; Owner: opencourts
--

CREATE TABLE public.api_keys (
    value text
);


ALTER TABLE public.api_keys OWNER TO opencourts;

--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: opencourts
--

COPY public.api_keys (value) FROM stdin;
key-of-another-app
\.


--
-- PostgreSQL database dump complete
--

\unrestrict g85ohjInRqspJX3rgRBLWmRCaCgPqNWkoD3mNwNhxTDnbPq5swFLHxYwxxIJt6e

--
-- Database "opencourts_production" dump
--

--
-- PostgreSQL database dump
--

\restrict O4v44ktNhJezfzO4Rwu9v0o5Y9KbTrZYyu9JpfGAzvxV0GWeRgP63r7jt3OLjYw

-- Dumped from database version 17.11 (Homebrew)
-- Dumped by pg_dump version 17.11 (Homebrew)

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

--
-- Name: opencourts_production; Type: DATABASE; Schema: -; Owner: opencourts
--

CREATE DATABASE opencourts_production WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE opencourts_production OWNER TO opencourts;

\unrestrict O4v44ktNhJezfzO4Rwu9v0o5Y9KbTrZYyu9JpfGAzvxV0GWeRgP63r7jt3OLjYw
\connect opencourts_production
\restrict O4v44ktNhJezfzO4Rwu9v0o5Y9KbTrZYyu9JpfGAzvxV0GWeRgP63r7jt3OLjYw

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

--
-- Name: courts_id_seq; Type: SEQUENCE; Schema: public; Owner: opencourts
--

CREATE SEQUENCE public.courts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courts_id_seq OWNER TO opencourts;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: courts; Type: TABLE; Schema: public; Owner: opencourts
--

CREATE TABLE public.courts (
    id integer DEFAULT nextval('public.courts_id_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.courts OWNER TO opencourts;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: opencourts
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO opencourts;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: opencourts
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token character varying(255) NOT NULL
);


ALTER TABLE public.subscriptions OWNER TO opencourts;

--
-- Name: users; Type: TABLE; Schema: public; Owner: opencourts
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    confirmed_at timestamp without time zone,
    confirmation_token character varying(255),
    unconfirmed_email character varying(255),
    remember_created_at timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO opencourts;

--
-- Data for Name: courts; Type: TABLE DATA; Schema: public; Owner: opencourts
--

COPY public.courts (id, name) FROM stdin;
1	Okresný súd Žilina
2	Krajský súd\tBratislava
3	Najvyšší súd
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: opencourts
--

COPY public.schema_migrations (version) FROM stdin;
-- Database "opencourts_api" dump
-- PostgreSQL database cluster dump complete
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: opencourts
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: opencourts
--

COPY public.subscriptions (id, user_id, token) FROM stdin;
1	1	token-of-admin
2	2	token-of-reader
3	3	token-of-kept
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: opencourts
--

COPY public.users (id, email, encrypted_password, confirmed_at, confirmation_token, unconfirmed_email, remember_created_at, reset_password_token, reset_password_sent_at, admin) FROM stdin;
1	admin@example.com	$2a$10$adminadminadminadminadminadminadminadminadminadmin	2026-10-14 18:26:09.26233	confirm-admin	\N	\N	\N	\N	t
2	reader@example.com	$2a$10$readerreaderreaderreaderreaderreaderreaderreader	2026-10-14 18:26:09.26233	\N	\N	\N	\N	\N	f
3	kept@example.com	$2a$10$keptkeptkeptkeptkeptkeptkeptkeptkeptkeptkeptkeptk	2026-10-14 18:26:09.26233	\N	\N	\N	\N	\N	t
\.


--
-- Name: courts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: opencourts
--

SELECT pg_catalog.setval('public.courts_id_seq', 3, true);


--
-- Name: courts courts_pkey; Type: CONSTRAINT; Schema: public; Owner: opencourts
--

ALTER TABLE ONLY public.courts
    ADD CONSTRAINT courts_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: opencourts
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: opencourts
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: opencourts
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_courts_on_name; Type: INDEX; Schema: public; Owner: opencourts
--

CREATE INDEX index_courts_on_name ON public.courts USING btree (name);


--
-- Name: index_subscriptions_on_token; Type: INDEX; Schema: public; Owner: opencourts
--

CREATE UNIQUE INDEX index_subscriptions_on_token ON public.subscriptions USING btree (token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: opencourts
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- PostgreSQL database dump complete
--

\unrestrict O4v44ktNhJezfzO4Rwu9v0o5Y9KbTrZYyu9JpfGAzvxV0GWeRgP63r7jt3OLjYw

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict 4Hn3DHUwTtOtw6xRWXLkKwWQ54ltehWxSoPGdIBgxtukUCnZ0fqySqAzieQaAlA

-- Dumped from database version 17.11 (Homebrew)
-- Dumped by pg_dump version 17.11 (Homebrew)

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

--
-- PostgreSQL database dump complete
--

\unrestrict 4Hn3DHUwTtOtw6xRWXLkKwWQ54ltehWxSoPGdIBgxtukUCnZ0fqySqAzieQaAlA

--
-- PostgreSQL database cluster dump complete
--

