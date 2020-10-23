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
-- Name: player_api; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE player_api WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE player_api OWNER TO postgres;

\connect player_api

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
-- Name: application_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_instances (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    application_id uuid NOT NULL,
    display_order real NOT NULL,
    team_id uuid NOT NULL
);


ALTER TABLE public.application_instances OWNER TO postgres;

--
-- Name: application_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_templates (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    embeddable boolean NOT NULL,
    icon text,
    name text,
    url text,
    load_in_background boolean DEFAULT false NOT NULL
);


ALTER TABLE public.application_templates OWNER TO postgres;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    application_template_id uuid,
    embeddable boolean,
    view_id uuid NOT NULL,
    icon text,
    name text,
    url text,
    load_in_background boolean
);


ALTER TABLE public.applications OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    key integer NOT NULL,
    broadcast_time timestamp without time zone NOT NULL,
    from_id uuid NOT NULL,
    from_type integer NOT NULL,
    link text,
    subject text,
    text text,
    to_id uuid NOT NULL,
    to_type integer NOT NULL,
    view_id uuid,
    priority integer DEFAULT 0 NOT NULL,
    from_name text,
    to_name text
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_key_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_key_seq OWNER TO postgres;

--
-- Name: notifications_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_key_seq OWNED BY public.notifications.key;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    key text,
    value text,
    description text,
    read_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: team_memberships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_memberships (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    team_id uuid NOT NULL,
    user_id uuid NOT NULL,
    view_membership_id uuid NOT NULL,
    role_id uuid
);


ALTER TABLE public.team_memberships OWNER TO postgres;

--
-- Name: team_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    team_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.team_permissions OWNER TO postgres;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    view_id uuid NOT NULL,
    name text,
    role_id uuid
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.user_permissions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    key integer NOT NULL,
    id uuid NOT NULL,
    name text,
    role_id uuid
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_key_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_key_seq OWNER TO postgres;

--
-- Name: users_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_key_seq OWNED BY public.users.key;


--
-- Name: view_memberships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_memberships (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    view_id uuid NOT NULL,
    user_id uuid NOT NULL,
    primary_team_membership_id uuid
);


ALTER TABLE public.view_memberships OWNER TO postgres;

--
-- Name: views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.views (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    description text,
    name text,
    status integer NOT NULL
);


ALTER TABLE public.views OWNER TO postgres;

--
-- Name: notifications key; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN key SET DEFAULT nextval('public.notifications_key_seq'::regclass);


--
-- Name: users key; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN key SET DEFAULT nextval('public.users_key_seq'::regclass);


--
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20180409152814_InitialSchema	2.2.6-servicing-10079
20180425120959_notifications	2.2.6-servicing-10079
20180425150608_notification_severity	2.2.6-servicing-10079
20180427174044_addNotificationExerciseId	2.2.6-servicing-10079
20180427195539_addNotificationNames	2.2.6-servicing-10079
20180530153923_Add_ExerciseUser	2.2.6-servicing-10079
20180604144309_Add_LoadInBackground_To_Application	2.2.6-servicing-10079
20180822200200_Added_Permissions	2.2.6-servicing-10079
20180827180826_Added_ReadOnly_To_Permissions	2.2.6-servicing-10079
20180914151120_Fixed_Membership_Relation	2.2.6-servicing-10079
20180918145428_Fixed_UserPermissions	2.2.6-servicing-10079
20200507133304_renamed_exercise_to_view	2.2.6-servicing-10079
20200730203141_Added_Unique_Name_To_Role	2.2.6-servicing-10079
\.


--
-- Data for Name: application_instances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_instances (id, application_id, display_order, team_id) FROM stdin;
bd5f22e8-b78a-4348-bc46-abbcb9dd7eda	195c324c-aafd-4bde-b8e9-1b321ad9901b	0	07704bcb-91d6-42aa-bb26-3046e9cc4cb6
2e78a407-212d-4364-9db7-8b4603a3873b	195c324c-aafd-4bde-b8e9-1b321ad9901b	0	05d43d63-f726-4df2-9bb4-5b9a8d6eecab
1edac733-92c9-4a6d-926d-e952ffe67a7c	3454f6a6-e8a1-431f-8cbe-e2d715c99bf2	0	6e5ad944-ea5b-4a7c-9442-57dc5a2fcd0d
b22a55c0-0e03-4afe-92fa-fd49f6b826f4	3454f6a6-e8a1-431f-8cbe-e2d715c99bf2	0	b5694a2d-d9e3-4ff1-833b-4ee35e72436d
9f891caf-fbff-4b7c-8abc-25491a7abe74	b4d28394-a3ff-4400-8224-d1880e1c881f	1	6e5ad944-ea5b-4a7c-9442-57dc5a2fcd0d
e825b4c0-2a9c-43ee-8657-3e026e2bf159	b4d28394-a3ff-4400-8224-d1880e1c881f	1	b5694a2d-d9e3-4ff1-833b-4ee35e72436d
\.


--
-- Data for Name: application_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_templates (id, embeddable, icon, name, url, load_in_background) FROM stdin;
9ce415c0-5eb2-4aa8-8243-b4a0bbf5e332	t	/assets/img/player.png	VMs	https://vm.crucible.ws/views/{viewId}	f
659feff8-f2d4-457a-8916-18d57020ec20	t	/assets/img/SP_Icon_Dashboard.png	Dashboard	https://alloy.crucible.ws/view/{viewId}	f
\.


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applications (id, application_template_id, embeddable, view_id, icon, name, url, load_in_background) FROM stdin;
195c324c-aafd-4bde-b8e9-1b321ad9901b	9ce415c0-5eb2-4aa8-8243-b4a0bbf5e332	\N	6d3f89f6-b757-4c77-9b51-9f33e3326322	\N	\N	\N	\N
3454f6a6-e8a1-431f-8cbe-e2d715c99bf2	9ce415c0-5eb2-4aa8-8243-b4a0bbf5e332	\N	7d28fc1e-b856-4a01-a87b-0e8886c4b7e7	\N	\N	\N	\N
b4d28394-a3ff-4400-8224-d1880e1c881f	659feff8-f2d4-457a-8916-18d57020ec20	\N	7d28fc1e-b856-4a01-a87b-0e8886c4b7e7	\N	\N	\N	\N
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (key, broadcast_time, from_id, from_type, link, subject, text, to_id, to_type, view_id, priority, from_name, to_name) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, key, value, description, read_only) FROM stdin;
b83e008c-f0f3-42a6-97b4-08b43089b8fb	SystemAdmin	true	Can do anything	t
964927a1-e227-4e5a-a06b-feb609a4c0e4	ViewAdmin	true	Can edit an Exercise, Add/Remove Teams/Members, etc	t
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (id, role_id, permission_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name) FROM stdin;
\.


--
-- Data for Name: team_memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_memberships (id, team_id, user_id, view_membership_id, role_id) FROM stdin;
9a8fbc52-850a-4877-9fc9-f805491d5be8	07704bcb-91d6-42aa-bb26-3046e9cc4cb6	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	6659f08c-b8e0-4ca2-8e1a-4d332bfdaadf	\N
0a8f7c59-1fb5-459d-ab97-eacf52f61f30	05d43d63-f726-4df2-9bb4-5b9a8d6eecab	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	6659f08c-b8e0-4ca2-8e1a-4d332bfdaadf	\N
21d871b5-84f1-4c02-9b5d-ea37d590b09a	6e5ad944-ea5b-4a7c-9442-57dc5a2fcd0d	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	d9dde12e-b559-43ca-9b00-fad0ba0e2f1b	\N
3e33627c-7f80-49c0-84c5-eef48b97b6fb	b5694a2d-d9e3-4ff1-833b-4ee35e72436d	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	d9dde12e-b559-43ca-9b00-fad0ba0e2f1b	\N
\.


--
-- Data for Name: team_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_permissions (id, team_id, permission_id) FROM stdin;
8ba13cd2-ce37-4666-b836-0de67c12d955	07704bcb-91d6-42aa-bb26-3046e9cc4cb6	964927a1-e227-4e5a-a06b-feb609a4c0e4
be981357-e957-4340-9360-cfe81fa138dd	6e5ad944-ea5b-4a7c-9442-57dc5a2fcd0d	964927a1-e227-4e5a-a06b-feb609a4c0e4
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (id, view_id, name, role_id) FROM stdin;
07704bcb-91d6-42aa-bb26-3046e9cc4cb6	6d3f89f6-b757-4c77-9b51-9f33e3326322	Admin	\N
05d43d63-f726-4df2-9bb4-5b9a8d6eecab	6d3f89f6-b757-4c77-9b51-9f33e3326322	Blue	\N
6e5ad944-ea5b-4a7c-9442-57dc5a2fcd0d	7d28fc1e-b856-4a01-a87b-0e8886c4b7e7	Admin	\N
b5694a2d-d9e3-4ff1-833b-4ee35e72436d	7d28fc1e-b856-4a01-a87b-0e8886c4b7e7	Blue	\N
\.


--
-- Data for Name: user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_permissions (id, user_id, permission_id) FROM stdin;
231439e2-bbe1-4c50-a87f-67afa7d2b9ca	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	b83e008c-f0f3-42a6-97b4-08b43089b8fb
500e8de8-0845-4ead-ae9e-0c57780009d0	c4c631ca-3dbd-4d99-9c19-a8c3f7e5e493	b83e008c-f0f3-42a6-97b4-08b43089b8fb
bf93adfc-ff6e-459f-b31a-620be561e67c	6b10a070-e807-449b-b8d4-b276ae4c2d42	b83e008c-f0f3-42a6-97b4-08b43089b8fb
2b5b6369-7e0a-49df-a14c-7444948a633c	32c11441-7eec-47eb-a915-607c4f2529f4	b83e008c-f0f3-42a6-97b4-08b43089b8fb
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (key, id, name, role_id) FROM stdin;
1	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	Admin	\N
2	c4c631ca-3dbd-4d99-9c19-a8c3f7e5e493	Caster Admin User	\N
3	6b10a070-e807-449b-b8d4-b276ae4c2d42	Player Vm Admin	\N
4	32c11441-7eec-47eb-a915-607c4f2529f4	Crucible Admin	\N
\.


--
-- Data for Name: view_memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_memberships (id, view_id, user_id, primary_team_membership_id) FROM stdin;
6659f08c-b8e0-4ca2-8e1a-4d332bfdaadf	6d3f89f6-b757-4c77-9b51-9f33e3326322	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	9a8fbc52-850a-4877-9fc9-f805491d5be8
d9dde12e-b559-43ca-9b00-fad0ba0e2f1b	7d28fc1e-b856-4a01-a87b-0e8886c4b7e7	9fd3c38e-58b0-4af1-80d1-1895af91f1f9	21d871b5-84f1-4c02-9b5d-ea37d590b09a
\.


--
-- Data for Name: views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.views (id, description, name, status) FROM stdin;
6d3f89f6-b757-4c77-9b51-9f33e3326322	A example view	Example View	0
7d28fc1e-b856-4a01-a87b-0e8886c4b7e7	A Example Alloy View	Example Alloy View	1
\.


--
-- Name: notifications_key_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_key_seq', 1, false);


--
-- Name: users_key_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_key_seq', 4, true);


--
-- Name: users AK_users_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "AK_users_id" UNIQUE (id);


--
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- Name: application_instances PK_application_instances; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT "PK_application_instances" PRIMARY KEY (id);


--
-- Name: application_templates PK_application_templates; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_templates
    ADD CONSTRAINT "PK_application_templates" PRIMARY KEY (id);


--
-- Name: applications PK_applications; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT "PK_applications" PRIMARY KEY (id);


--
-- Name: view_memberships PK_exercise_memberships; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_memberships
    ADD CONSTRAINT "PK_exercise_memberships" PRIMARY KEY (id);


--
-- Name: views PK_exercises; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.views
    ADD CONSTRAINT "PK_exercises" PRIMARY KEY (id);


--
-- Name: notifications PK_notifications; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "PK_notifications" PRIMARY KEY (key);


--
-- Name: permissions PK_permissions; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT "PK_permissions" PRIMARY KEY (id);


--
-- Name: role_permissions PK_role_permissions; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "PK_role_permissions" PRIMARY KEY (id);


--
-- Name: roles PK_roles; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT "PK_roles" PRIMARY KEY (id);


--
-- Name: team_memberships PK_team_memberships; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT "PK_team_memberships" PRIMARY KEY (id);


--
-- Name: team_permissions PK_team_permissions; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_permissions
    ADD CONSTRAINT "PK_team_permissions" PRIMARY KEY (id);


--
-- Name: teams PK_teams; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT "PK_teams" PRIMARY KEY (id);


--
-- Name: user_permissions PK_user_permissions; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT "PK_user_permissions" PRIMARY KEY (id);


--
-- Name: users PK_users; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_users" PRIMARY KEY (key);


--
-- Name: IX_application_instances_application_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_application_instances_application_id" ON public.application_instances USING btree (application_id);


--
-- Name: IX_application_instances_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_application_instances_team_id" ON public.application_instances USING btree (team_id);


--
-- Name: IX_applications_application_template_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_applications_application_template_id" ON public.applications USING btree (application_template_id);


--
-- Name: IX_applications_view_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_applications_view_id" ON public.applications USING btree (view_id);


--
-- Name: IX_permissions_key_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_permissions_key_value" ON public.permissions USING btree (key, value);


--
-- Name: IX_role_permissions_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_role_permissions_permission_id" ON public.role_permissions USING btree (permission_id);


--
-- Name: IX_role_permissions_role_id_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_role_permissions_role_id_permission_id" ON public.role_permissions USING btree (role_id, permission_id);


--
-- Name: IX_roles_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_roles_name" ON public.roles USING btree (name);


--
-- Name: IX_team_memberships_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_team_memberships_role_id" ON public.team_memberships USING btree (role_id);


--
-- Name: IX_team_memberships_team_id_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_team_memberships_team_id_user_id" ON public.team_memberships USING btree (team_id, user_id);


--
-- Name: IX_team_memberships_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_team_memberships_user_id" ON public.team_memberships USING btree (user_id);


--
-- Name: IX_team_memberships_view_membership_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_team_memberships_view_membership_id" ON public.team_memberships USING btree (view_membership_id);


--
-- Name: IX_team_permissions_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_team_permissions_permission_id" ON public.team_permissions USING btree (permission_id);


--
-- Name: IX_team_permissions_team_id_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_team_permissions_team_id_permission_id" ON public.team_permissions USING btree (team_id, permission_id);


--
-- Name: IX_teams_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_teams_role_id" ON public.teams USING btree (role_id);


--
-- Name: IX_teams_view_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_teams_view_id" ON public.teams USING btree (view_id);


--
-- Name: IX_user_permissions_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_user_permissions_permission_id" ON public.user_permissions USING btree (permission_id);


--
-- Name: IX_user_permissions_user_id_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_user_permissions_user_id_permission_id" ON public.user_permissions USING btree (user_id, permission_id);


--
-- Name: IX_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_users_id" ON public.users USING btree (id);


--
-- Name: IX_users_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_users_role_id" ON public.users USING btree (role_id);


--
-- Name: IX_view_memberships_primary_team_membership_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_view_memberships_primary_team_membership_id" ON public.view_memberships USING btree (primary_team_membership_id);


--
-- Name: IX_view_memberships_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_view_memberships_user_id" ON public.view_memberships USING btree (user_id);


--
-- Name: IX_view_memberships_view_id_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IX_view_memberships_view_id_user_id" ON public.view_memberships USING btree (view_id, user_id);


--
-- Name: application_instances FK_application_instances_applications_application_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT "FK_application_instances_applications_application_id" FOREIGN KEY (application_id) REFERENCES public.applications(id) ON DELETE CASCADE;


--
-- Name: application_instances FK_application_instances_teams_team_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT "FK_application_instances_teams_team_id" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: applications FK_applications_application_templates_application_template_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT "FK_applications_application_templates_application_template_id" FOREIGN KEY (application_template_id) REFERENCES public.application_templates(id) ON DELETE RESTRICT;


--
-- Name: applications FK_applications_views_view_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT "FK_applications_views_view_id" FOREIGN KEY (view_id) REFERENCES public.views(id) ON DELETE CASCADE;


--
-- Name: view_memberships FK_exercise_memberships_exercises_exercise_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_memberships
    ADD CONSTRAINT "FK_exercise_memberships_exercises_exercise_id" FOREIGN KEY (view_id) REFERENCES public.views(id) ON DELETE CASCADE;


--
-- Name: view_memberships FK_exercise_memberships_team_memberships_primary_team_membersh~; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_memberships
    ADD CONSTRAINT "FK_exercise_memberships_team_memberships_primary_team_membersh~" FOREIGN KEY (primary_team_membership_id) REFERENCES public.team_memberships(id) ON DELETE RESTRICT;


--
-- Name: view_memberships FK_exercise_memberships_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_memberships
    ADD CONSTRAINT "FK_exercise_memberships_users_user_id" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: role_permissions FK_role_permissions_permissions_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "FK_role_permissions_permissions_permission_id" FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions FK_role_permissions_roles_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "FK_role_permissions_roles_role_id" FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: team_memberships FK_team_memberships_roles_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT "FK_team_memberships_roles_role_id" FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- Name: team_memberships FK_team_memberships_teams_team_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT "FK_team_memberships_teams_team_id" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: team_memberships FK_team_memberships_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT "FK_team_memberships_users_user_id" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: team_memberships FK_team_memberships_view_memberships_view_membership_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT "FK_team_memberships_view_memberships_view_membership_id" FOREIGN KEY (view_membership_id) REFERENCES public.view_memberships(id) ON DELETE CASCADE;


--
-- Name: team_permissions FK_team_permissions_permissions_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_permissions
    ADD CONSTRAINT "FK_team_permissions_permissions_permission_id" FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: team_permissions FK_team_permissions_teams_team_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_permissions
    ADD CONSTRAINT "FK_team_permissions_teams_team_id" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: teams FK_teams_roles_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT "FK_teams_roles_role_id" FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- Name: teams FK_teams_views_view_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT "FK_teams_views_view_id" FOREIGN KEY (view_id) REFERENCES public.views(id) ON DELETE CASCADE;


--
-- Name: user_permissions FK_user_permissions_permissions_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT "FK_user_permissions_permissions_permission_id" FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: user_permissions FK_user_permissions_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT "FK_user_permissions_users_user_id" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users FK_users_roles_role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_users_roles_role_id" FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

