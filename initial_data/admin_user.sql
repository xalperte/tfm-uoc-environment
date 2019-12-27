--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.15
-- Dumped by pg_dump version 9.6.15

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
-- Data for Name: caravaggio_client; Type: TABLE DATA; Schema: public; Owner: gatherer
--

INSERT INTO tfm_uoc.public.caravaggio_client (id, email, name, is_active, date_joined, date_deactivated) VALUES ('b2f0a4b4-4a8c-490f-b0ef-60d6154c0112', '@TFM_UOC_USER_EMAIL@', 'Test Company Inc.', true, '2019-10-31 23:52:15.698243+00', NULL);


--
-- Data for Name: caravaggio_user; Type: TABLE DATA; Schema: public; Owner: gatherer
--

INSERT INTO tfm_uoc.public.caravaggio_user (password, last_login, is_superuser, first_name, last_name, is_staff, is_active, date_joined, id, username, email, is_client_staff, date_deactivated, client_id) VALUES ('', NULL, true, 'Admin', 'Admin', true, true, '2019-11-13 10:06:39.786882+00', '8c7f226b-1983-4d89-90d4-2bb418160e70', 'b2f0a4b4-4a8c-490f-b0ef-60d6154c0112-@TFM_UOC_USER_EMAIL@', '@TFM_UOC_USER_EMAIL@', true, NULL, 'b2f0a4b4-4a8c-490f-b0ef-60d6154c0112');


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: gatherer
--

INSERT INTO tfm_uoc.public.authtoken_token (key, created, user_id) VALUES ('cb31a1546c70841f43512df1435b24f4ccbcbc67', '2019-11-13 10:06:39.791266+00', '8c7f226b-1983-4d89-90d4-2bb418160e70');


--
-- PostgreSQL database dump complete
--

