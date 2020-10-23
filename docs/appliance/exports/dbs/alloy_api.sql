--
-- PostgreSQL database dump
--

-- Dumped from database version 11.9 (Debian 11.9-1.pgdg90+1)
-- Dumped by pg_dump version 13.0

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
-- Name: alloy_api; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE alloy_api WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE alloy_api OWNER TO postgres;

\connect alloy_api

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

--
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);


ALTER TABLE public."__EFMigrationsHistory" OWNER TO postgres;

--
-- Name: event_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_templates (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    date_created timestamp without time zone NOT NULL,
    date_modified timestamp without time zone,
    created_by uuid NOT NULL,
    modified_by uuid,
    view_id uuid,
    directory_id uuid,
    scenario_template_id uuid,
    name text,
    description text,
    duration_hours integer NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    use_dynamic_host boolean DEFAULT false NOT NULL
);


ALTER TABLE public.event_templates OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    date_created timestamp without time zone NOT NULL,
    date_modified timestamp without time zone,
    created_by uuid NOT NULL,
    modified_by uuid,
    user_id uuid NOT NULL,
    username text,
    event_template_id uuid,
    view_id uuid,
    workspace_id uuid,
    run_id uuid,
    scenario_id uuid,
    name text,
    description text,
    status integer NOT NULL,
    launch_date timestamp without time zone,
    end_date timestamp without time zone,
    expiration_date timestamp without time zone,
    internal_status integer DEFAULT 0 NOT NULL,
    status_date timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone NOT NULL,
    failure_count integer DEFAULT 0 NOT NULL,
    last_end_internal_status integer DEFAULT 0 NOT NULL,
    last_end_status integer DEFAULT 0 NOT NULL,
    last_launch_internal_status integer DEFAULT 0 NOT NULL,
    last_launch_status integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20190719183445_Initial_Migration	3.1.0
20190813175524_internalStatus	3.1.0
20200317180127_definitionFlags	3.1.0
20200409191451_FailureCount	3.1.0
20200507204242_nounChange	3.1.0
20200511160116_NewNouns	3.1.0
20200514151407_renameIndexes	3.1.0
\.


--
-- Data for Name: event_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_templates (id, date_created, date_modified, created_by, modified_by, view_id, directory_id, scenario_template_id, name, description, duration_hours, is_published, use_dynamic_host) FROM stdin;
24f79a80-d38e-481a-987a-022b01c63cc5	2020-10-09 14:26:43.377726	2020-10-09 14:28:27.173853	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	7d28fc1e-b856-4a01-a87b-0e8886c4b7e7	4f45e422-088e-42a0-bbfa-3b9dfc1cc98e	9188d171-d6c1-4308-969c-5df7926f96ac	Example Event	A Example Event	4	t	f
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, date_created, date_modified, created_by, modified_by, user_id, username, event_template_id, view_id, workspace_id, run_id, scenario_id, name, description, status, launch_date, end_date, expiration_date, internal_status, status_date, failure_count, last_end_internal_status, last_end_status, last_launch_internal_status, last_launch_status) FROM stdin;
\.


--
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- Name: event_templates PK_event_templates; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_templates
    ADD CONSTRAINT "PK_event_templates" PRIMARY KEY (id);


--
-- Name: events PK_events; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT "PK_events" PRIMARY KEY (id);


--
-- Name: IX_events_event_template_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_events_event_template_id" ON public.events USING btree (event_template_id);


--
-- Name: events FK_events_event_templates_event_template_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT "FK_events_event_templates_event_template_id" FOREIGN KEY (event_template_id) REFERENCES public.event_templates(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

