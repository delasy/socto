--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Ubuntu 12.4-1.pgdg16.04+1)
-- Dumped by pg_dump version 12.4

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
-- Name: enum_projects_cdn_provider; Type: TYPE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TYPE public.enum_projects_cdn_provider AS ENUM (
    'CLOUDFLARE'
);


ALTER TYPE public.enum_projects_cdn_provider OWNER TO doakqfghcpmcoq;

--
-- Name: enum_projects_provider; Type: TYPE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TYPE public.enum_projects_provider AS ENUM (
    'AWS'
);


ALTER TYPE public.enum_projects_provider OWNER TO doakqfghcpmcoq;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.assets (
    id uuid NOT NULL,
    project_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    folder character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL,
    mime_type character varying(255) NOT NULL,
    cache_ttl integer NOT NULL
);


ALTER TABLE public.assets OWNER TO doakqfghcpmcoq;

--
-- Name: file_variables; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.file_variables (
    id uuid NOT NULL,
    file_id uuid NOT NULL,
    variable_id uuid NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.file_variables OWNER TO doakqfghcpmcoq;

--
-- Name: files; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.files (
    id uuid NOT NULL,
    project_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    folder character varying(255) NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL,
    mime_type character varying(255) NOT NULL,
    cache_ttl integer NOT NULL
);


ALTER TABLE public.files OWNER TO doakqfghcpmcoq;

--
-- Name: icons; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.icons (
    id uuid NOT NULL,
    project_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    content text NOT NULL,
    variable_name character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.icons OWNER TO doakqfghcpmcoq;

--
-- Name: layout_variables; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.layout_variables (
    id uuid NOT NULL,
    layout_id uuid NOT NULL,
    variable_id uuid NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.layout_variables OWNER TO doakqfghcpmcoq;

--
-- Name: layouts; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.layouts (
    id uuid NOT NULL,
    project_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    body_code text NOT NULL,
    head_code text NOT NULL,
    scripts text NOT NULL,
    styles text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.layouts OWNER TO doakqfghcpmcoq;

--
-- Name: page_variables; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.page_variables (
    id uuid NOT NULL,
    page_id uuid NOT NULL,
    variable_id uuid NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.page_variables OWNER TO doakqfghcpmcoq;

--
-- Name: pages; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.pages (
    id uuid NOT NULL,
    layout_id uuid NOT NULL,
    project_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    folder character varying(255) NOT NULL,
    body_code text NOT NULL,
    head_code text NOT NULL,
    scripts text NOT NULL,
    styles text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL,
    published_at timestamp with time zone
);


ALTER TABLE public.pages OWNER TO doakqfghcpmcoq;

--
-- Name: project_variables; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.project_variables (
    id uuid NOT NULL,
    project_id uuid NOT NULL,
    variable_id uuid NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.project_variables OWNER TO doakqfghcpmcoq;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.projects (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    public_url character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL,
    bucket_provider public.enum_projects_provider NOT NULL,
    bucket_config_aws jsonb,
    global_body_code text NOT NULL,
    global_head_code text NOT NULL,
    global_scripts text NOT NULL,
    global_styles text NOT NULL,
    description character varying(255) NOT NULL,
    cdn_provider public.enum_projects_cdn_provider,
    cdn_config_cloudflare jsonb
);


ALTER TABLE public.projects OWNER TO doakqfghcpmcoq;

--
-- Name: sequelize_migrations; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.sequelize_migrations (
    name character varying(255) NOT NULL
);


ALTER TABLE public.sequelize_migrations OWNER TO doakqfghcpmcoq;

--
-- Name: users; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(60) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO doakqfghcpmcoq;

--
-- Name: variables; Type: TABLE; Schema: public; Owner: doakqfghcpmcoq
--

CREATE TABLE public.variables (
    id uuid NOT NULL,
    project_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.variables OWNER TO doakqfghcpmcoq;

--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('e373c160-f813-42e1-83e1-6283975a426d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon.svg', '', '2020-08-20 15:34:10.066+00', NULL, '2020-08-20 15:34:10.066+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('4c6beb3c-966e-448f-8893-174c0d1a8223', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-16x16.png', '', '2020-08-20 15:34:56.437+00', NULL, '2020-08-20 15:34:56.437+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('ff201959-b6e6-4eee-98a9-5d237bfdedf3', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-32x32.png', '', '2020-08-20 15:35:11.408+00', NULL, '2020-08-20 15:35:11.408+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('75d2436e-6e66-4814-b88d-e4d59de3bd8e', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-36x36.png', '', '2020-08-20 15:36:07.235+00', NULL, '2020-08-20 15:36:07.235+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('20bbcbc3-198f-48a2-b8da-0661d94e0987', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-48x48.png', '', '2020-08-20 15:36:23.011+00', NULL, '2020-08-20 15:36:23.011+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('339f52f0-9dd3-48b0-aa60-feb54e0f09ad', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-57x57.png', '', '2020-08-20 15:36:45.892+00', NULL, '2020-08-20 15:36:45.892+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('8698c7e4-1fc8-4273-8102-1dd72b1e7641', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-60x60.png', '', '2020-08-20 15:36:55.405+00', NULL, '2020-08-20 15:36:55.405+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('8248aacb-3ce4-4a50-b31f-983e5b8d3412', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-70x70.png', '', '2020-08-20 15:37:05.5+00', NULL, '2020-08-20 15:37:05.5+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('967c8296-2c0f-45d5-9382-8abad3ae0e86', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-72x72.png', '', '2020-08-20 15:37:14.071+00', NULL, '2020-08-20 15:37:14.071+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('485df3cf-8e24-46c1-b4da-c7b88a33ca45', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-76x76.png', '', '2020-08-20 15:37:22.744+00', NULL, '2020-08-20 15:37:22.744+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('88c3eb61-79e4-4762-8163-e017a31d41b9', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-96x96.png', '', '2020-08-20 15:37:32.869+00', NULL, '2020-08-20 15:37:32.869+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('6dfc9025-6350-4888-8455-9bcbeed73f17', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-114x114.png', '', '2020-08-20 15:37:40.312+00', NULL, '2020-08-20 15:37:40.312+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('d58c3616-cd00-4988-9932-dff7a983f592', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-120x120.png', '', '2020-08-20 15:37:52.826+00', NULL, '2020-08-20 15:37:52.826+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('5ab9c6fd-5fb6-47e5-9fd0-1ac22b48e3c4', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-144x144.png', '', '2020-08-20 15:38:02.411+00', NULL, '2020-08-20 15:38:02.411+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('111f1b0f-4b79-4f57-afbf-868035290b3c', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-150x150.png', '', '2020-08-20 15:38:10.73+00', NULL, '2020-08-20 15:38:10.73+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('ff8bab0a-5fb9-486e-b150-173a0e665df6', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-152x152.png', '', '2020-08-20 15:42:43.567+00', NULL, '2020-08-20 15:42:43.567+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('a6959c91-2890-4701-b750-c35fdf8d5c61', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-192x192.png', '', '2020-08-20 15:45:00.315+00', NULL, '2020-08-20 15:45:00.315+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('319c5092-ebd4-4787-841b-770906db973a', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-310x310.png', '', '2020-08-20 15:45:16.417+00', NULL, '2020-08-20 15:45:16.417+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('2a3cd281-dd90-4979-ab1f-f328ff73c6a4', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'dollar-over-euro.jpg', 'img/', '2020-08-20 15:46:54.482+00', NULL, '2020-08-20 15:46:54.482+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('e92bb1c2-8eba-42f8-a1ac-65d3d8d8e639', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-180x180.png', '', '2020-08-20 15:44:21.911+00', NULL, '2020-08-27 14:54:13.81+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('cb4a57ef-8a60-4577-82ed-b3c7acfc2bf5', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon-512x512.png', '', '2020-08-20 15:45:36.083+00', NULL, '2020-08-27 15:18:27.094+00', '', 31536000);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('734a62b7-d4d3-47ad-89ff-f7f2868e4d82', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'favicon.ico', '', '2020-08-20 15:33:39.332+00', NULL, '2020-08-27 21:40:31.599+00', '', 691200);
INSERT INTO public.assets (id, project_id, name, folder, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('b4690a11-ebeb-48a5-8273-7fc774926627', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'og.jpg', '', '2020-08-20 15:46:30.709+00', NULL, '2020-08-28 16:59:58.53+00', '', 31536000);


--
-- Data for Name: file_variables; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--



--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.files (id, project_id, name, folder, content, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('ec2b593c-1ccf-4a37-8622-d99e4a46e34a', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'manifest.json', '', '{
  "short_name": "{{ PROJECT_NAME }}",
  "name": "Aaron Delasy Official Website",
  "description": "{{ PROJECT_DESCRIPTION }}",
  "start_url": "/",
  "background_color": "#000000",
  "display": "standalone",
  "lang": "en",
  "prefer_related_applications": false,
  "scope": "/",
  "theme_color": "#000000",
  "icons": [
    {
      "src": "{{ PUBLIC_URL }}/favicon-36x36.png",
      "sizes": "36x36",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-48x48.png",
      "sizes": "48x48",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-72x72.png",
      "sizes": "72x72",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-76x76.png",
      "sizes": "76x76",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-96x96.png",
      "sizes": "96x96",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-120x120.png",
      "sizes": "120x120",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-144x144.png",
      "sizes": "144x144",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-152x152.png",
      "sizes": "152x152",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-180x180.png",
      "sizes": "180x180",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "{{ PUBLIC_URL }}/favicon-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any maskable"
    }
  ]
}', '2020-08-20 15:25:14.439+00', NULL, '2020-08-27 21:43:57.415+00', '', 0);
INSERT INTO public.files (id, project_id, name, folder, content, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('53de98a5-3031-4c78-a9fa-3dd80468373a', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'robots.txt', '', 'User-agent: *
Allow: /', '2020-08-20 15:22:37.745+00', NULL, '2020-08-27 21:44:03.598+00', '', 0);
INSERT INTO public.files (id, project_id, name, folder, content, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('634d4aef-d5a4-4a8a-95e8-03a816df4eb9', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'browserconfig.xml', '', '<?xml version="1.0" encoding="utf-8"?>
<browserconfig>
  <msapplication>
    <tile>
      <square70x70logo src="{{ PUBLIC_URL }}/favicon-70x70.png" />
      <square150x150logo src="{{ PUBLIC_URL }}/favicon-150x150.png" />
      <square310x310logo src="{{ PUBLIC_URL }}/favicon-310x310.png" />
      <TileColor>#000000</TileColor>
    </tile>
  </msapplication>
</browserconfig>', '2020-08-20 15:21:42.713+00', NULL, '2020-08-27 21:44:09.483+00', '', 0);
INSERT INTO public.files (id, project_id, name, folder, content, created_at, deleted_at, updated_at, mime_type, cache_ttl) VALUES ('80b5e935-72be-4e98-88f7-1d3c7886a6ee', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'sw.js', '', 'var version = ''1.0.0''
var cacheName = ''www.delasy.com-v'' + version

self.addEventListener(''install'', function (event) {
  event.waitUntil(
    caches.open(cacheName).then(function (cache) {
      return cache.addAll([''/'', ''/index'', ''/_offline''])
    })
  )
})

self.addEventListener(''activate'', function (event) {
  event.waitUntil(
    caches.keys().then(function (keyList) {
      return Promise.all(
        keyList
          .filter(function (key) {
            return key !== cacheName
          })
          .map(function (key) {
            return caches.delete(key)
          })
      )
    })
  )
})

self.addEventListener(''fetch'', function (event) {
  var isSameOrigin = new URL(event.request.url).origin === ''{{ PUBLIC_URL }}''

  event.respondWith(
    caches.open(cacheName).then(function (cache) {
      return cache.match(event.request)
        .then(function (response) {
          return response || fetch(event.request).then(function (response) {
            if (!isSameOrigin) {
              return response
            }

            return cache.put(event.request, response.clone()).then(function () {
              return response
            })
          })
        })
        .catch(function (err) {
          if (isSameOrigin) {
            return cache.match(''/_offline'')
          } else {
            throw err
          }
        })
    })
  )
})', '2020-08-20 15:30:23.602+00', NULL, '2020-08-28 15:18:21.733+00', '', 0);


--
-- Data for Name: icons; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('36699507-c5ac-4010-83b3-108373901bb8', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Amazon Music', '<svg viewBox="0 0 240 141" xmlns="http://www.w3.org/2000/svg">
  <path d="M2.06399295,90.8599973 C2.60399293,90.8599973 3.14265959,91.1306639 3.68265957,91.3999973 C37.3839921,111.08133 79.1746577,122.94533 122.31199,122.94533 C151.430656,122.94533 183.514655,116.743997 212.902654,104.34133 C217.486654,102.45333 221.261321,107.306664 216.677321,110.542664 C190.525322,129.954663 152.509323,140.199996 119.61599,140.199996 C73.7826578,140.199996 32.2613255,123.214663 0.985326309,94.9053305 C-0.901340311,93.0173306 0.177326329,90.8599973 2.06399295,90.8599973 Z M223.147987,86.2773307 C231.237321,86.2773307 237.707987,87.894664 239.055987,89.5119973 C242.02132,93.2866639 238.246654,117.82133 224.226654,129.68533 C221.799987,131.302663 219.913321,130.49333 220.722654,128.066663 C223.957321,120.247996 230.966654,102.45333 227.731987,98.1399971 C224.226654,93.8266639 205.354655,95.9826638 196.995988,97.0613305 C194.569321,97.3306638 194.030655,95.1733305 196.457321,93.5559972 C204.275988,88.1639973 214.521321,86.2773307 223.147987,86.2773307 Z M154.126656,18.7759978 C158.171989,18.7759978 162.215989,19.5839978 166.259989,20.9319978 C167.067989,21.2026648 167.607989,21.4719978 167.877322,22.0106648 C168.146655,22.5506648 168.417322,23.0893318 168.417322,23.8986648 L168.417322,23.8986648 L168.417322,26.5946648 C168.417322,27.6733308 167.877322,28.2119978 167.067989,28.2119978 C166.798655,28.2119978 165.990656,27.9426648 164.911989,27.6733308 C161.675989,26.5946648 158.171989,26.0546648 154.666656,26.0546648 C148.465323,26.0546648 145.499989,28.2119978 145.499989,32.2559978 C145.499989,34.1439978 146.038656,35.2213308 147.117323,36.2999978 C147.926656,37.3786648 150.082656,38.4573308 153.047989,39.5359978 L153.047989,39.5359978 L160.597322,42.5013306 C164.371989,43.8493306 167.069322,45.7373305 168.686655,47.6239972 C170.303989,49.7813304 171.113322,52.2079971 171.113322,55.443997 C171.113322,60.0266635 169.494655,63.5319968 165.990656,66.2279967 C162.485322,68.9239966 158.171989,70.2719966 152.509323,70.2719966 C147.117323,70.2719966 142.263989,69.4626633 137.950656,67.5759967 C137.141323,67.3066633 136.602656,66.7666634 136.33199,66.49733 C136.062656,65.95733 135.793323,65.4186634 135.793323,64.6106634 L135.793323,64.6106634 L135.793323,61.9133301 C135.793323,60.8359968 136.062656,60.2959968 136.87199,60.2959968 C137.410656,60.2959968 138.21999,60.5653302 139.298656,60.8359968 C143.611989,62.1839968 147.926656,62.7226635 152.509323,62.7226635 C155.475989,62.7226635 157.902656,61.9133301 159.518656,60.8359968 C161.137322,59.7573302 161.945322,57.8693302 161.945322,55.711997 C161.945322,54.095997 161.675989,53.0173304 160.597322,51.9386637 C159.518656,50.8599971 157.901322,50.0506638 155.205322,48.9719971 L155.205322,48.9719971 L147.117323,46.0066639 C140.106656,43.3106639 136.602656,38.7266648 136.602656,32.5253308 C136.602656,28.4813308 138.21999,24.9773318 141.454656,22.5506648 C144.690656,20.1239978 149.005323,18.7759978 154.126656,18.7759978 Z M222.339987,19.2359978 C225.170321,19.2359978 228.207883,19.8556434 231.271349,20.5518516 L232.585321,20.8533308 C233.123987,21.1226638 233.662654,21.6626638 233.93332,21.9319978 C234.202654,22.2013308 234.471987,23.0106638 234.471987,23.8199978 L234.471987,23.8199978 L234.471987,26.5159978 C234.471987,27.8639968 233.93332,28.4026638 233.123987,28.4026638 C232.585321,28.4026638 232.315987,28.4026638 231.506654,28.1333308 C229.079987,27.3239978 226.383987,27.0546638 223.687987,27.0546638 C218.294654,27.0546638 214.521321,28.4026638 212.094654,31.0986638 C209.667988,33.7946638 208.589321,38.1093308 208.319988,44.0399966 L208.319988,44.0399966 L208.319988,45.3893299 C208.319988,51.0506631 209.398654,55.3639963 211.825321,58.0599962 C214.251988,60.7559962 218.026654,62.1039961 223.147987,62.1039961 C225.845321,62.1039961 228.810654,61.5653295 231.775987,60.7559962 C232.315987,60.4866628 232.854654,60.4866628 233.123987,60.4866628 C233.93332,60.4866628 234.471987,61.0253295 234.471987,62.3746628 L234.471987,62.3746628 L234.471987,65.2569015 C234.470393,65.9999803 234.451269,66.708714 234.202654,66.9573294 C233.93332,67.4973293 233.394654,67.7666627 232.585321,68.035996 C229.619987,69.383996 225.845321,69.9226626 221.799987,69.9226626 C214.250654,69.9226626 208.589321,67.7666627 204.545321,63.4533294 C200.501321,59.1386629 198.614655,52.9373297 198.614655,44.8493299 C198.614655,36.7613308 200.770655,30.2906638 204.814655,25.9759978 C209.127988,21.3933308 214.790654,19.2359978 222.339987,19.2359978 Z M93.1946573,19.5066645 C94.5426573,19.5066645 95.081324,20.0453315 95.081324,21.3933315 L95.081324,21.3933315 L95.081324,51.8599971 C95.081324,55.3653303 95.6213239,57.7919969 96.9693239,59.4093302 C98.3173239,61.0266635 100.473324,61.8359968 103.43999,61.8359968 C108.022657,61.8359968 112.606657,60.2186635 117.190657,57.2519969 L117.190657,57.2519969 L117.190657,21.3933315 C117.190657,20.3146645 117.729323,19.5066645 119.346657,19.5066645 L119.346657,19.5066645 L125.009323,19.5066645 C126.357323,19.5066645 126.89599,20.0453315 126.89599,21.3933315 L126.89599,21.3933315 L126.89599,65.8799967 C126.89599,67.2279967 126.357323,67.7679967 125.009323,67.7679967 L125.009323,67.7679967 L120.750303,67.7677933 C120.060265,67.7657598 119.592717,67.7433906 119.346657,67.49733 C118.80799,67.2279967 118.538657,66.9586634 118.538657,66.1493301 L118.538657,66.1493301 L117.998657,62.9146635 C112.06799,67.2279967 105.866657,69.38533 99.6653238,69.38533 C95.081324,69.38533 91.577324,68.03733 89.1506574,65.6106634 C86.7239908,63.1839968 85.6453242,59.4093302 85.6453242,54.8266637 L85.6453242,54.8266637 L85.6453242,21.3933315 C85.6453242,20.0453315 86.1839908,19.5066645 87.5319908,19.5066645 L87.5319908,19.5066645 L93.1946573,19.5066645 Z M186.750655,20.1586645 C188.098655,20.1586645 188.637322,20.9666645 188.637322,22.0453315 L188.637322,22.0453315 L188.637322,66.8013301 C188.637322,68.14933 188.098655,68.68933 186.750655,68.68933 L186.750655,68.68933 L181.087988,68.68933 C179.739989,68.68933 179.201322,68.14933 179.201322,66.8013301 L179.201322,66.8013301 L179.201322,22.0453315 C179.201322,20.6973315 179.739989,20.1586645 181.087988,20.1586645 L181.087988,20.1586645 L186.750655,20.1586645 Z M59.7613248,18.4279978 C64.3453247,18.4279978 67.5813246,19.7759978 70.0066579,22.2026648 C72.4333245,24.6293318 73.5119912,28.1333308 73.5119912,32.7173308 L73.5119912,32.7173308 L73.5119912,66.4186634 C73.5119912,67.7666633 72.9733245,68.3066633 71.6253245,68.3066633 L71.6253245,68.3066633 L65.9639914,68.3066633 C64.6146581,68.3066633 64.0759914,67.7666633 64.0759914,66.4186634 L64.0759914,66.4186634 L64.0759914,35.4133308 C64.0759914,32.1786648 63.2666581,30.0213308 62.1879914,28.4039978 C61.1093248,26.7853318 59.2226582,25.9773318 56.5266583,25.9773318 C51.9426584,25.9773318 47.3599918,27.3253308 42.5066586,30.2906648 L42.5066586,30.2906648 L42.5066586,66.4186634 C42.5066586,67.7666633 41.967992,68.3066633 40.619992,68.3066633 L40.619992,68.3066633 L34.9573255,68.3066633 C33.6093255,68.3066633 33.0706588,67.7666633 33.0706588,66.4186634 L33.0706588,66.4186634 L33.0706588,35.4133308 C33.0706588,32.1773308 32.2613255,30.0213308 31.1826589,28.4039978 C30.1053256,26.7853318 28.2173256,25.9759978 25.5213257,25.9759978 C20.6679925,25.9759978 16.0839926,27.5946648 11.501326,30.2906648 L11.501326,30.2906648 L11.501326,66.6879967 C11.501326,68.03733 10.9613261,68.5759966 9.61465943,68.5759966 L9.61465943,68.5759966 L3.9519929,68.5759966 C2.60399293,68.5759966 2.06399295,68.03733 2.06399295,66.6879967 L2.06399295,66.6879967 L2.06399295,21.9333318 C2.06399295,20.5839978 2.60399293,20.0453318 3.9519929,20.0453318 L3.9519929,20.0453318 L8.42701812,20.0456008 C8.91036611,20.0480248 9.3709261,20.0722648 9.61332609,20.3146648 C10.1533261,20.5839978 10.4226594,20.8546648 10.4226594,21.6626648 L10.4226594,21.6626648 L10.9613261,24.6293318 C16.8933259,20.5839978 22.8253258,18.4279978 28.7573256,18.4279978 C34.6879921,18.4279978 38.731992,20.5839978 40.8893253,25.1679978 C47.0906585,20.5839978 53.561325,18.4279978 59.7613248,18.4279978 Z M183.785322,0 C185.671988,0 187.289322,0.54 188.367988,1.617333 C189.446655,2.426666 189.717322,4.044 189.717322,5.661333 C189.717322,7.28 189.177322,8.628 188.098655,9.706666 C187.019988,10.785333 185.671988,11.324 183.785322,11.324 C181.897322,11.324 180.549322,10.785333 179.470655,9.706666 C178.393322,8.897333 177.853322,7.28 177.853322,5.661333 C177.853322,4.044 178.393322,2.697333 179.470655,1.617333 C180.549322,0.54 181.897322,0 183.785322,0 Z" fill="currentColor"></path>
</svg>', 'AMAZON_MUSIC', '2020-08-20 15:10:44.862+00', NULL, '2020-08-20 15:10:44.862+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('31bdf76e-9b6b-43db-9906-75d40def0459', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Apple Music', '<svg viewBox="0 0 440 440" xmlns="http://www.w3.org/2000/svg">
  <path d="M348.439024,41.4366587 C447.073244,112.393187 469.52867,249.86168 398.598668,348.483512 C327.663463,447.100164 190.199831,469.522978 91.5593663,398.563341 C-7.07485363,327.603705 -29.5292382,190.135212 41.4049266,91.5164876 C112.334928,-7.10016384 249.802723,-29.5229779 348.439024,41.4366587 Z M220.5,13 C105.900914,13 13,105.900914 13,220.5 C13,335.099086 105.900914,428 220.5,428 C335.099086,428 428,335.099086 428,220.5 C428,105.900914 335.099086,13 220.5,13 Z M315.968,72.2499854 C317.898,72.247 319.601,72.707 321.018,73.58 C321.981,74.62 322.717,75.936 323.181,77.505 C323.622,78.985 323.729,106.101 323.618,185.494 L323.618,185.494 L323.468,291.509 L322.327,295.461 C318.46,308.908 309.01,318.428 295.626,322.353 C286.168,325.129 272.348,326.158 265.558,324.595 C261.056,323.558 257.475,321.921 253.964,319.206 C253.328,318.654 252.698,318.067 252.055,317.436 C245.085,310.585 241.994,303.588 241.98,294.629 C241.973,289.621 242.88,285.849 245.309,280.816 C248.744,273.702 253.189,269.419 261.192,265.508 C267.603,262.381 273.33,260.758 290.067,257.341 C301.068,255.097 303.744,254.132 305.89,251.643 C308.839,248.219 308.772,249.491 308.622,195.244 C308.491,148.113 308.438,145.525 307.559,144.216 C307.074,143.486 306.382,142.893 305.562,142.453 C304.18,140.751 301.65,139.888 298.97,140.26 C295.923,140.687 187.694,162.085 184.993,162.794 C181.996,163.585 179.821,165.914 179.123,169.096 C178.712,170.971 178.611,319.834 175.393,328.192 C174.472,330.579 172.828,333.863 171.732,335.496 C168.968,339.619 163.653,344.631 159.521,347.022 C149.641,352.737 130.314,355.677 119.991,353.034 C115.322,351.836 111.169,349.818 107.651,347.107 C103.781,343.649 100.821,339.254 98.982,334.108 C97.227,329.187 96.815,321.095 98.047,315.687 C99.335,310.03 102.315,304.638 106.339,300.689 C113.424,293.733 121.799,290.5 144.351,286.012 C149.223,285.044 154.242,283.918 155.512,283.509 C158.192,282.65 161.099,279.953 162.408,277.106 C163.25178,275.2734 163.805519,115.64612 163.827331,109.261761 L163.828,109.065 L165.011,106.719 C166.407,103.95 169.349,101.341 172.319,100.243 C174.239,99.533 286.638,77.147 305.707,73.675 C310.017,72.891 314.638,72.2499854 315.968,72.2499854 Z" fill="currentColor"></path>
</svg>', 'APPLE_MUSIC', '2020-08-20 15:11:08.273+00', NULL, '2020-08-20 15:11:08.273+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('96ec137a-297c-4b0d-9b61-86fae52a193c', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Bars', '<svg viewBox="0 0 448 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M442 114H6a6 6 0 0 1-6-6V84a6 6 0 0 1 6-6h436a6 6 0 0 1 6 6v24a6 6 0 0 1-6 6zm0 160H6a6 6 0 0 1-6-6v-24a6 6 0 0 1 6-6h436a6 6 0 0 1 6 6v24a6 6 0 0 1-6 6zm0 160H6a6 6 0 0 1-6-6v-24a6 6 0 0 1 6-6h436a6 6 0 0 1 6 6v24a6 6 0 0 1-6 6z" fill="currentColor"></path>
</svg>', 'BARS', '2020-08-20 15:11:23.295+00', NULL, '2020-08-20 15:11:23.295+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('4110975a-b214-48f5-8a2c-2c896340c61e', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Explicit', '<svg viewBox="0 0 384 384" xmlns="http://www.w3.org/2000/svg">
  <path d="M341.333,0H42.667C19.093,0,0,19.093,0,42.667v298.667C0,364.907,19.093,384,42.667,384h298.667 C364.907,384,384,364.907,384,341.333V42.667C384,19.093,364.907,0,341.333,0z M256,128h-85.333v42.667H256v42.667h-85.333V256 H256v42.667H128V85.333h128V128z" fill="#FFFFFF" />
</svg>', 'EXPLICIT', '2020-08-20 15:11:41.474+00', NULL, '2020-08-20 15:11:41.474+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('427f0dd7-0099-46d2-a916-9e4c366ffc8f', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Facebook', '<svg viewBox="0 0 448 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M400 32H48A48 48 0 0 0 0 80v352a48 48 0 0 0 48 48h137.25V327.69h-63V256h63v-54.64c0-62.15 37-96.48 93.67-96.48 27.14 0 55.52 4.84 55.52 4.84v61h-31.27c-30.81 0-40.42 19.12-40.42 38.73V256h68.78l-11 71.69h-57.78V480H400a48 48 0 0 0 48-48V80a48 48 0 0 0-48-48z" fill="currentColor"></path>
</svg>', 'FACEBOOK', '2020-08-20 15:11:56.232+00', NULL, '2020-08-20 15:11:56.232+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('974668f8-e7ec-4675-bf26-e2e2bb6d098a', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Genius', '<svg viewBox="0 0 821 723" xmlns="http://www.w3.org/2000/svg">
  <path d="M637.7,70.1 C640.6,68.1 644.3,68.4 647.2,71.4 C651.9,76.2 656.4,81.1 660.7,86.2 C702.4,135.5 729.2,191.8 740.1,255.6 C742.9,272.5 744.7,289.5 745,306.7 C747,410.3 711.1,498.8 637.7,571.2 C584.2,624 519.4,655.7 445.2,667.7 C424.6,671.1 403.8,672.7 383,672.1 C296.9,669.6 221,640.5 155.8,584 C152.4,581 149.1,578 145.8,574.9 C141.9,571.2 141.1,568.1 143.1,564.8 C145.1,561.3 148.6,560.4 153.6,562.3 C176.3,571.1 199.8,577.5 223.8,581.6 C247.3,585.7 271,587.7 294.9,587 C389.7,584.3 472.4,551.1 542,486.6 C595.4,437.1 630.8,376.5 649.1,306 C654.8,284.1 658.4,261.8 659.6,239.1 L659.6,239.1 L660.8,214.2 C660.5,168.6 652.3,124.5 636.3,81.8 C636,80.9 635.6,80 635.3,79 C634.1,74.9 634.9,72 637.7,70.1 Z M145.1,64.4 C169.8,64.5 194.4,64.5 219.1,64.5 C227.1,64.5 229.5,67 229.5,75 L229.5,75 L229.5008,119.5 C229.504,129.5 229.52,139.5 229.6,149.5 C229.6,153.5 228.3,156.4 225.6,159.3 C192.2,194.7 171.7,236.5 164.7,284.8 C159.4,321.5 162.9,357.5 175.3,392.5 C175.5,393 175.6,393.4 175.8,393.9 C177.4,398.8 176.9,401.7 174,403.9 C171,406.2 168.4,406 163.9,402.9 C119,372.3 89.4,330.8 75.4,278.2 C69.8,257.1 67.3,235.6 68.6,213.9 C72,157 93.8,108.3 134.8,68.4 C137.7,65.6 141,64.4 145.1,64.4 Z M454.4,64.7 C460.2,64.6 464.3,66.4 468,71.2 C488,97.4 501.8,126.4 509.4,158.5 C509.6,159.4 509.7,160.4 509.9,161.4 C510.9,167 508.3,170.5 502.5,170.7 C496.2,170.9 489.8,170.7 483.5,170.8 C476.7,170.9 474.9,172.6 474.9,179.4 L474.9,179.4 L474.9,235.9 C474.9,276.8 445.6,311.1 405.3,317.6 C359.9,324.9 316.8,292.7 310.7,247.1 C310.6,246.3 310.6,245.4 310.5,244.8 C310.2,238.4 312.1,236.3 318.6,235.4 C349.6,231.2 372.1,215.3 385.1,186.7 C389.5,176.8 391.6,166.4 391.6,155.6 L391.6,155.6 L391.6,77.1 C391.6,75.4 391.5,73.7 391.7,72.1 C392.3,67.9 394.2,65.9 398.4,65.2 C400.2,64.9 402.1,64.8 403.9,64.8 C420.8,64.7 437.6,64.9 454.4,64.7 Z" fill="currentColor"></path>
</svg>', 'GENIUS', '2020-08-20 15:12:11.289+00', NULL, '2020-08-20 15:12:11.289+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('eed17033-8586-435b-b919-497d40c4f0a2', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Instagram', '<svg viewBox="0 0 448 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M224.1 141c-63.6 0-114.9 51.3-114.9 114.9s51.3 114.9 114.9 114.9S339 319.5 339 255.9 287.7 141 224.1 141zm0 189.6c-41.1 0-74.7-33.5-74.7-74.7s33.5-74.7 74.7-74.7 74.7 33.5 74.7 74.7-33.6 74.7-74.7 74.7zm146.4-194.3c0 14.9-12 26.8-26.8 26.8-14.9 0-26.8-12-26.8-26.8s12-26.8 26.8-26.8 26.8 12 26.8 26.8zm76.1 27.2c-1.7-35.9-9.9-67.7-36.2-93.9-26.2-26.2-58-34.4-93.9-36.2-37-2.1-147.9-2.1-184.9 0-35.8 1.7-67.6 9.9-93.9 36.1s-34.4 58-36.2 93.9c-2.1 37-2.1 147.9 0 184.9 1.7 35.9 9.9 67.7 36.2 93.9s58 34.4 93.9 36.2c37 2.1 147.9 2.1 184.9 0 35.9-1.7 67.7-9.9 93.9-36.2 26.2-26.2 34.4-58 36.2-93.9 2.1-37 2.1-147.8 0-184.8zM398.8 388c-7.8 19.6-22.9 34.7-42.6 42.6-29.5 11.7-99.5 9-132.1 9s-102.7 2.6-132.1-9c-19.6-7.8-34.7-22.9-42.6-42.6-11.7-29.5-9-99.5-9-132.1s-2.6-102.7 9-132.1c7.8-19.6 22.9-34.7 42.6-42.6 29.5-11.7 99.5-9 132.1-9s102.7-2.6 132.1 9c19.6 7.8 34.7 22.9 42.6 42.6 11.7 29.5 9 99.5 9 132.1s2.7 102.7-9 132.1z" fill="currentColor"></path>
</svg>', 'INSTAGRAM', '2020-08-20 15:12:27.184+00', NULL, '2020-08-20 15:12:27.184+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('28a050f9-bb8a-48a1-8ad9-3e842449a947', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Logo', '<svg viewBox="0 0 750 750" xmlns="http://www.w3.org/2000/svg">
  <g fill="none" stroke="currentColor" stroke-width="10">
    <path d="M362.378125,551.130109 C350.422956,555.572516 351.404299,572.29689 354.082373,582.740904 C325.96176,555.546737 313.882983,499.154797 330.076247,468.733523 C337.257709,455.242159 350.157337,434.326361 352.535852,425.78036"></path>
    <path d="M361.430147,438.5274 C350.749305,467.605877 335.122865,495.275269 349.426514,525.25271 C365.738745,554.594235 376.308238,581.169436 375.42741,614.935892 C410.061311,581.28316 425.381602,547.34796 427.573945,508.183291 C429.766288,469.018622 421.678366,457.858481 402.231696,419.208225"></path>
    <path d="M410,313.122178 C422.480392,310.572889 423.916058,298.186987 432.073637,288.351212 C478.639232,232.206034 536.216496,254.350116 593.75171,136 C598.044778,188.58642 582.817484,280.571173 525.078316,303.361084 C547.307535,310.007565 571.124781,304.406739 594.215356,291.787683 C585.08793,320.021109 564.150479,337.536971 539.832277,351.798192 C547.685138,362.729958 558.202995,364.119431 572.838421,364.867373 C557.439832,382.985767 533.104013,388.233596 511.302676,387.716829 C516.279698,404.146207 526.535983,410.78539 541.839045,416.749093 C508.436773,428.098429 441.184119,431.678509 411.7602,403.103814"></path>
    <path d="M156,313.122178 C168.480392,310.572889 169.916058,298.186987 178.073637,288.351212 C224.639232,232.206034 282.216496,254.350116 339.75171,136 C344.044778,188.58642 328.817484,280.571173 271.078316,303.361084 C293.307535,310.007565 317.124781,304.406739 340.215356,291.787683 C331.08793,320.021109 310.150479,337.536971 285.832277,351.798192 C293.685138,362.729958 304.202995,364.119431 318.838421,364.867373 C303.439832,382.985767 279.104013,388.233596 257.302676,387.716829 C262.279698,404.146207 272.535983,410.78539 287.839045,416.749093 C254.436773,428.098429 187.184119,431.678509 157.7602,403.103814" transform="translate(248.215949, 280.571173) scale(-1, 1) translate(-248.215949, -280.571173)"></path>
    <path d="M375.326447,457.926465 C348.113306,419.997776 298.654809,357.872306 338.673161,313.823557 C347.18584,310.172903 354.655303,306.23468 355.142117,295.29914 C355.933713,277.517179 348.88595,249.159125 327.338947,270.664273 C318.958157,250.622644 330.016084,246.722385 348.408934,245.168607 C350.425752,214.284 390.369648,225.840934 394.493157,244.214849 C398.616667,262.588764 394.776964,279.8315 396.465507,297.677431 C397.540016,309.033733 403.45466,309.536753 411.973515,313.823557 C451.991867,357.872306 402.539588,419.997776 375.326447,457.926465 Z"></path>
  </g>
</svg>', 'LOGO', '2020-08-20 15:12:42.036+00', NULL, '2020-08-20 15:12:42.036+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('a31bd46f-ec53-454a-a5e4-cd4a7c66347f', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Amazon', '<svg viewBox="0 0 1000 302" xmlns="http://www.w3.org/2000/svg">
  <path d="M149.00099,193.40115 C223.74089,236.88701 316.15375,263.04816 411.61364,263.04816 C475.99352,263.04816 546.8158,249.72815 611.93573,222.08703 C621.77336,217.90818 630.00041,228.52937 620.38044,235.66818 C562.26875,278.5011 478.03939,301.35401 405.51952,301.35401 C303.83491,301.35401 212.29269,263.74464 143.03746,201.19294 C137.5963,196.27409 142.47156,189.57059 149.00099,193.40115 Z M669.35097,189.13528 C675.70624,197.01411 667.69686,251.64348 636.48629,277.71754 C631.69806,281.72223 627.12748,279.58932 629.26043,274.27872 C636.26865,256.77991 651.98277,217.55998 644.53924,208.02705 C637.13922,198.53765 595.4381,203.54352 576.72049,205.76352 C571.01812,206.46 570.14757,201.49764 575.284,197.92821 C608.49691,174.55295 662.99569,181.30001 669.35097,189.13528 Z" fill="#FF9900"></path>
  <path d="M778.9579,1.5237471 C824.88138,1.5237471 849.73662,40.961349 849.73662,91.107182 C849.73662,139.55535 822.26957,177.99177 778.9579,177.99177 C733.86147,177.99177 709.3109,138.55417 709.3109,89.409532 C709.3109,39.960169 734.16617,1.5237471 778.9579,1.5237471 Z M480.12882,0.00021708008 C495.18999,0.00021708008 514.86525,4.0049271 526.74877,15.409611 C541.659299,29.3289932 540.400539,47.855995 540.373873,68.0340757 L540.37346,116.87656 C540.37346,131.37186 546.38051,137.72711 552.03932,145.56243 C553.99817,148.34828 554.43346,151.70004 551.90861,153.78945 C545.59686,159.05653 534.36627,168.85063 528.18511,174.33532 L528.140998,174.248217 L527.934145,174.425427 C525.89925,176.083686 523.058929,176.166433 520.82879,174.98826 C510.55584,166.45651 508.68409,162.49535 503.06881,154.35536 C486.09235,171.68003 474.0347,176.86001 452.05238,176.86001 C425.97829,176.86001 405.73716,160.79767 405.73716,128.62951 C405.73716,103.51305 419.31834,86.406011 438.73243,78.048379 C455.53475,70.648362 478.99704,69.342505 496.93116,67.296628 L496.93116,63.291927 C496.93116,55.935442 497.49705,47.229568 493.14411,40.874314 C489.40059,35.171945 482.17469,32.821359 475.77589,32.821359 C463.97942,32.821359 453.48887,38.871938 450.92062,51.408392 C450.39827,54.19429 448.35241,56.936639 445.52297,57.067226 L415.53126,53.846031 C413.00654,53.28018 410.17715,51.23427 410.91715,47.360188 C417.79479,10.969646 450.703,0.00021708008 480.12882,0.00021708008 Z M74.391681,0.00021708008 C89.452812,0.00021708008 109.12808,4.0049271 121.0116,15.409611 C135.922158,29.3289932 134.66336,47.855995 134.636693,68.0340757 L134.63628,116.87656 C134.63628,131.37186 140.64336,137.72711 146.30218,145.56243 C148.30452,148.34828 148.73981,151.70004 146.21508,153.78945 C139.90333,159.05653 128.67277,168.85063 122.49157,174.33532 L122.40457,174.24812 L122.40455,174.24825 C120.35868,176.07648 117.39865,176.20706 115.0916,174.98826 C104.8187,166.45651 102.99044,162.49535 97.331628,154.35536 C80.355174,171.68003 68.341102,176.86001 46.315217,176.86001 C20.284648,176.86001 -2.141151e-06,160.79767 -2.141151e-06,128.62951 C-2.141151e-06,103.51305 13.624684,86.406011 32.995241,78.048379 C49.79757,70.648362 73.259897,69.342505 91.194013,67.296628 L91.194013,63.291927 C91.194013,55.935442 91.759897,47.229568 87.450486,40.874314 C83.663406,35.171945 76.437558,32.821359 70.082253,32.821359 C58.285822,32.821359 47.751694,38.871938 45.183467,51.408392 C44.661103,54.19429 42.615225,56.936639 39.82936,57.067226 L9.7941042,53.846031 C7.2693961,53.28018 4.4835138,51.23427 5.1799844,47.360188 C12.101156,10.969646 44.965811,0.00021708008 74.391681,0.00021708008 Z M955.77417,1.5237471 C969.66004,1.5237471 983.19768,6.5296311 991.90355,20.241371 C1000,32.951945 1000,54.324878 1000,69.690715 L1000,169.67769 C999.65178,172.46354 997.08353,174.68354 994.03651,174.68354 L963.00006,174.68354 C960.17063,174.46592 957.82004,172.37651 957.51537,169.67769 L957.51537,83.402489 C957.51537,66.034274 959.51771,40.613105 938.14478,40.613105 C930.61422,40.613105 923.69304,45.662538 920.25422,53.323681 C915.9013,63.030753 915.33541,72.694271 915.33541,83.402489 L915.33541,168.93769 C915.29191,172.11532 912.59307,174.68354 909.28485,174.68354 L878.46602,174.68354 C875.37542,174.46592 872.89425,171.98475 872.89425,168.93769 L872.85075,10.055502 C873.11193,7.1390331 875.68018,4.8755171 878.81428,4.8755171 L907.50015,4.8755171 C910.19894,5.0060171 912.41894,6.8343401 913.02838,9.3155141 L913.02838,33.604881 L913.59423,33.604881 C922.2566,11.88374 934.40125,1.5237471 955.77417,1.5237471 Z M335.13254,1.5237471 C348.10429,1.5237471 362.29486,6.8778581 370.95721,18.891963 C380.75131,32.255475 378.74895,51.669567 378.74895,68.689569 L378.70545,168.93769 C378.70545,172.11532 376.05015,174.68354 372.74193,174.68354 L341.83606,174.68354 C338.7455,174.46592 336.26433,171.98475 336.26433,168.93769 L336.26433,84.751894 C336.26433,78.048379 336.8737,61.333102 335.39373,54.977797 C333.08668,44.313133 326.16552,41.309577 317.19844,41.309577 C309.71139,41.309577 301.87612,46.315457 298.69847,54.324878 C295.589899,62.1601635 295.813927,75.1609322 295.825137,84.1581138 L295.82553,168.93769 C295.82553,172.11532 293.17024,174.68354 289.862,174.68354 L258.95618,174.68354 C255.82206,174.46592 253.38441,171.98475 253.38441,168.93769 L253.34091,84.751894 C253.34091,67.035453 256.25734,40.961349 234.27505,40.961349 C212.03152,40.961349 212.90211,66.382485 212.90211,84.751894 L212.90211,168.93769 C212.90211,172.11532 210.24681,174.68354 206.93859,174.68354 L175.98919,174.68354 C173.02921,174.46592 170.67862,172.24592 170.46096,169.41648 L170.46096,10.577884 C170.46096,7.4002401 173.11626,4.8755171 176.42448,4.8755171 L205.28444,4.8755171 C208.288,5.0060171 210.68208,7.3131541 210.89975,10.186089 L210.89975,30.949621 L211.46563,30.949621 C218.9962,10.88256 233.14323,1.5237471 252.2091,1.5237471 C271.57966,1.5237471 283.68083,10.88256 292.3867,30.949621 C299.87375,10.88256 316.89372,1.5237471 335.13254,1.5237471 Z M685.50034,4.4402171 C688.76506,4.4402171 691.37682,6.7908061 691.37682,10.186089 L691.37682,29.643715 C691.33332,32.908411 688.59094,37.174288 683.71563,43.921337 L631.00159,119.18361 C650.58982,118.70482 671.26627,121.62125 689.02625,131.63301 C693.03094,133.89653 694.11918,137.20476 694.42388,140.46949 L694.42388,164.71535 C694.42388,168.02357 690.76741,171.89765 686.93683,169.89532 C655.63921,153.48474 614.06867,151.70004 579.46283,170.06945 C575.93696,171.98475 572.23697,168.15417 572.23697,164.84592 L572.23697,141.8189 C572.23697,138.11891 572.28047,131.80712 575.98046,126.19184 L637.05217,38.610763 L583.90283,38.610763 C580.63813,38.610763 578.02637,36.303728 578.02637,32.908411 L578.02637,10.186089 C578.02637,6.7472711 580.63813,4.4402171 583.77225,4.4402171 L685.50034,4.4402171 Z M496.93116,92.108363 C474.51354,92.108363 450.87711,96.896587 450.87711,123.27537 C450.87711,136.63888 457.84181,145.69301 469.72533,145.69301 C478.38766,145.69301 486.22294,140.33891 491.14175,131.63301 C497.022032,121.300507 496.944665,111.575938 496.931996,100.073819 Z M91.194013,92.108363 C68.8199,92.108363 45.183467,96.896587 45.183467,123.27537 C45.183467,136.63888 52.104622,145.69301 63.98814,145.69301 C72.694014,145.69301 80.485762,140.33891 85.404607,131.63301 C91.2848606,121.300507 91.2075159,111.575938 91.1948487,100.073819 Z M779.21906,33.953142 C756.40969,33.953142 754.973017,65.033077 754.973017,84.403667 C754.973017,103.81776 754.6685,145.2577 778.9579,145.2577 C802.94257,145.2577 804.07435,111.82718 804.07435,91.455393 C804.07435,78.048379 803.50846,62.029572 799.46021,49.318979 C795.97786,38.262553 789.05672,33.953142 779.21906,33.953142 Z" fill="#000000"></path>
</svg>', 'SERVICE_AMAZON', '2020-08-20 15:13:14.348+00', NULL, '2020-08-20 15:13:14.348+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('6cebe5d4-254d-4927-ba8c-42639bc3147b', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Amazon Music', '<svg viewBox="0 0 240 141" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient x1="0.000573703716%" y1="49.99903%" x2="100%" y2="49.99903%" id="service-amazon-music-linearGradient-1">
      <stop stop-color="#0C6BB3" offset="0%"></stop>
      <stop stop-color="#1D83C3" offset="28.9063%"></stop>
      <stop stop-color="#4BBFEF" offset="89.0625%"></stop>
      <stop stop-color="#4BBFEF" offset="100%"></stop>
    </linearGradient>
  </defs>
  <path d="M2.06399295,90.8599973 C2.60399293,90.8599973 3.14265959,91.1306639 3.68265957,91.3999973 C37.3839921,111.08133 79.1746577,122.94533 122.31199,122.94533 C151.430656,122.94533 183.514655,116.743997 212.902654,104.34133 C217.486654,102.45333 221.261321,107.306664 216.677321,110.542664 C190.525322,129.954663 152.509323,140.199996 119.61599,140.199996 C73.7826578,140.199996 32.2613255,123.214663 0.985326309,94.9053305 C-0.901340311,93.0173306 0.177326329,90.8599973 2.06399295,90.8599973 Z M223.147987,86.2773307 C231.237321,86.2773307 237.707987,87.894664 239.055987,89.5119973 C242.02132,93.2866639 238.246654,117.82133 224.226654,129.68533 C221.799987,131.302663 219.913321,130.49333 220.722654,128.066663 C223.957321,120.247996 230.966654,102.45333 227.731987,98.1399971 C224.226654,93.8266639 205.354655,95.9826638 196.995988,97.0613305 C194.569321,97.3306638 194.030655,95.1733305 196.457321,93.5559972 C204.275988,88.1639973 214.521321,86.2773307 223.147987,86.2773307 Z M154.126656,18.7759978 C158.171989,18.7759978 162.215989,19.5839978 166.259989,20.9319978 C167.067989,21.2026648 167.607989,21.4719978 167.877322,22.0106648 C168.146655,22.5506648 168.417322,23.0893318 168.417322,23.8986648 L168.417322,23.8986648 L168.417322,26.5946648 C168.417322,27.6733308 167.877322,28.2119978 167.067989,28.2119978 C166.798655,28.2119978 165.990656,27.9426648 164.911989,27.6733308 C161.675989,26.5946648 158.171989,26.0546648 154.666656,26.0546648 C148.465323,26.0546648 145.499989,28.2119978 145.499989,32.2559978 C145.499989,34.1439978 146.038656,35.2213308 147.117323,36.2999978 C147.926656,37.3786648 150.082656,38.4573308 153.047989,39.5359978 L153.047989,39.5359978 L160.597322,42.5013306 C164.371989,43.8493306 167.069322,45.7373305 168.686655,47.6239972 C170.303989,49.7813304 171.113322,52.2079971 171.113322,55.443997 C171.113322,60.0266635 169.494655,63.5319968 165.990656,66.2279967 C162.485322,68.9239966 158.171989,70.2719966 152.509323,70.2719966 C147.117323,70.2719966 142.263989,69.4626633 137.950656,67.5759967 C137.141323,67.3066633 136.602656,66.7666634 136.33199,66.49733 C136.062656,65.95733 135.793323,65.4186634 135.793323,64.6106634 L135.793323,64.6106634 L135.793323,61.9133301 C135.793323,60.8359968 136.062656,60.2959968 136.87199,60.2959968 C137.410656,60.2959968 138.21999,60.5653302 139.298656,60.8359968 C143.611989,62.1839968 147.926656,62.7226635 152.509323,62.7226635 C155.475989,62.7226635 157.902656,61.9133301 159.518656,60.8359968 C161.137322,59.7573302 161.945322,57.8693302 161.945322,55.711997 C161.945322,54.095997 161.675989,53.0173304 160.597322,51.9386637 C159.518656,50.8599971 157.901322,50.0506638 155.205322,48.9719971 L155.205322,48.9719971 L147.117323,46.0066639 C140.106656,43.3106639 136.602656,38.7266648 136.602656,32.5253308 C136.602656,28.4813308 138.21999,24.9773318 141.454656,22.5506648 C144.690656,20.1239978 149.005323,18.7759978 154.126656,18.7759978 Z M222.339987,19.2359978 C225.170321,19.2359978 228.207883,19.8556434 231.271349,20.5518516 L232.585321,20.8533308 C233.123987,21.1226638 233.662654,21.6626638 233.93332,21.9319978 C234.202654,22.2013308 234.471987,23.0106638 234.471987,23.8199978 L234.471987,23.8199978 L234.471987,26.5159978 C234.471987,27.8639968 233.93332,28.4026638 233.123987,28.4026638 C232.585321,28.4026638 232.315987,28.4026638 231.506654,28.1333308 C229.079987,27.3239978 226.383987,27.0546638 223.687987,27.0546638 C218.294654,27.0546638 214.521321,28.4026638 212.094654,31.0986638 C209.667988,33.7946638 208.589321,38.1093308 208.319988,44.0399966 L208.319988,44.0399966 L208.319988,45.3893299 C208.319988,51.0506631 209.398654,55.3639963 211.825321,58.0599962 C214.251988,60.7559962 218.026654,62.1039961 223.147987,62.1039961 C225.845321,62.1039961 228.810654,61.5653295 231.775987,60.7559962 C232.315987,60.4866628 232.854654,60.4866628 233.123987,60.4866628 C233.93332,60.4866628 234.471987,61.0253295 234.471987,62.3746628 L234.471987,62.3746628 L234.471987,65.2569015 C234.470393,65.9999803 234.451269,66.708714 234.202654,66.9573294 C233.93332,67.4973293 233.394654,67.7666627 232.585321,68.035996 C229.619987,69.383996 225.845321,69.9226626 221.799987,69.9226626 C214.250654,69.9226626 208.589321,67.7666627 204.545321,63.4533294 C200.501321,59.1386629 198.614655,52.9373297 198.614655,44.8493299 C198.614655,36.7613308 200.770655,30.2906638 204.814655,25.9759978 C209.127988,21.3933308 214.790654,19.2359978 222.339987,19.2359978 Z M93.1946573,19.5066645 C94.5426573,19.5066645 95.081324,20.0453315 95.081324,21.3933315 L95.081324,21.3933315 L95.081324,51.8599971 C95.081324,55.3653303 95.6213239,57.7919969 96.9693239,59.4093302 C98.3173239,61.0266635 100.473324,61.8359968 103.43999,61.8359968 C108.022657,61.8359968 112.606657,60.2186635 117.190657,57.2519969 L117.190657,57.2519969 L117.190657,21.3933315 C117.190657,20.3146645 117.729323,19.5066645 119.346657,19.5066645 L119.346657,19.5066645 L125.009323,19.5066645 C126.357323,19.5066645 126.89599,20.0453315 126.89599,21.3933315 L126.89599,21.3933315 L126.89599,65.8799967 C126.89599,67.2279967 126.357323,67.7679967 125.009323,67.7679967 L125.009323,67.7679967 L120.750303,67.7677933 C120.060265,67.7657598 119.592717,67.7433906 119.346657,67.49733 C118.80799,67.2279967 118.538657,66.9586634 118.538657,66.1493301 L118.538657,66.1493301 L117.998657,62.9146635 C112.06799,67.2279967 105.866657,69.38533 99.6653238,69.38533 C95.081324,69.38533 91.577324,68.03733 89.1506574,65.6106634 C86.7239908,63.1839968 85.6453242,59.4093302 85.6453242,54.8266637 L85.6453242,54.8266637 L85.6453242,21.3933315 C85.6453242,20.0453315 86.1839908,19.5066645 87.5319908,19.5066645 L87.5319908,19.5066645 Z M186.750655,20.1586645 C188.098655,20.1586645 188.637322,20.9666645 188.637322,22.0453315 L188.637322,22.0453315 L188.637322,66.8013301 C188.637322,68.14933 188.098655,68.68933 186.750655,68.68933 L186.750655,68.68933 L181.087988,68.68933 C179.739989,68.68933 179.201322,68.14933 179.201322,66.8013301 L179.201322,66.8013301 L179.201322,22.0453315 C179.201322,20.6973315 179.739989,20.1586645 181.087988,20.1586645 L181.087988,20.1586645 Z M59.7613248,18.4279978 C64.3453247,18.4279978 67.5813246,19.7759978 70.0066579,22.2026648 C72.4333245,24.6293318 73.5119912,28.1333308 73.5119912,32.7173308 L73.5119912,32.7173308 L73.5119912,66.4186634 C73.5119912,67.7666633 72.9733245,68.3066633 71.6253245,68.3066633 L71.6253245,68.3066633 L65.9639914,68.3066633 C64.6146581,68.3066633 64.0759914,67.7666633 64.0759914,66.4186634 L64.0759914,66.4186634 L64.0759914,35.4133308 C64.0759914,32.1786648 63.2666581,30.0213308 62.1879914,28.4039978 C61.1093248,26.7853318 59.2226582,25.9773318 56.5266583,25.9773318 C51.9426584,25.9773318 47.3599918,27.3253308 42.5066586,30.2906648 L42.5066586,30.2906648 L42.5066586,66.4186634 C42.5066586,67.7666633 41.967992,68.3066633 40.619992,68.3066633 L40.619992,68.3066633 L34.9573255,68.3066633 C33.6093255,68.3066633 33.0706588,67.7666633 33.0706588,66.4186634 L33.0706588,66.4186634 L33.0706588,35.4133308 C33.0706588,32.1773308 32.2613255,30.0213308 31.1826589,28.4039978 C30.1053256,26.7853318 28.2173256,25.9759978 25.5213257,25.9759978 C20.6679925,25.9759978 16.0839926,27.5946648 11.501326,30.2906648 L11.501326,30.2906648 L11.501326,66.6879967 C11.501326,68.03733 10.9613261,68.5759966 9.61465943,68.5759966 L9.61465943,68.5759966 L3.9519929,68.5759966 C2.60399293,68.5759966 2.06399295,68.03733 2.06399295,66.6879967 L2.06399295,66.6879967 L2.06399295,21.9333318 C2.06399295,20.5839978 2.60399293,20.0453318 3.9519929,20.0453318 L3.9519929,20.0453318 L8.42701812,20.0456008 C8.91036611,20.0480248 9.3709261,20.0722648 9.61332609,20.3146648 C10.1533261,20.5839978 10.4226594,20.8546648 10.4226594,21.6626648 L10.4226594,21.6626648 L10.9613261,24.6293318 C16.8933259,20.5839978 22.8253258,18.4279978 28.7573256,18.4279978 C34.6879921,18.4279978 38.731992,20.5839978 40.8893253,25.1679978 C47.0906585,20.5839978 53.561325,18.4279978 59.7613248,18.4279978 Z M183.785322,0 C185.671988,0 187.289322,0.54 188.367988,1.617333 C189.446655,2.426666 189.717322,4.044 189.717322,5.661333 C189.717322,7.28 189.177322,8.628 188.098655,9.706666 C187.019988,10.785333 185.671988,11.324 183.785322,11.324 C181.897322,11.324 180.549322,10.785333 179.470655,9.706666 C178.393322,8.897333 177.853322,7.28 177.853322,5.661333 C177.853322,4.044 178.393322,2.697333 179.470655,1.617333 C180.549322,0.54 181.897322,0 183.785322,0 Z" fill="url(#service-amazon-music-linearGradient-1)"></path>
</svg>', 'SERVICE_AMAZON_MUSIC', '2020-08-20 15:13:37.11+00', NULL, '2020-08-20 15:13:37.11+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('af77ac4d-a878-45b9-8797-f0556c059f2a', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Apple Music', '<svg viewBox="0 0 1231 298" xmlns="http://www.w3.org/2000/svg">
  <path d="M878.3,90.7 C924.6,90.7 954.6,116.4 956,153.1 L956,153.1 L917.7,153.1 C915.5,133.9 901.2,121.8 878.4,121.8 C856.3,121.8 841.6,132.5 841.6,148.5 C841.6,160.9 850.6,169.5 872.2,174.4 L872.2,174.4 L904.5,181.8 C945.2,191.2 960.6,207.1 960.6,235.9 C960.6,272.2 926.8,297.1 879.9,297.1 C830.2,297.1 800.4,272.7 796.6,234.9 L796.6,234.9 L837.1,234.9 C840.9,255.7 855.1,265.9 880,265.9 C904.5,265.9 919.7,255.7 919.7,239.4 C919.7,226.5 912.4,219 890.6,214.1 L890.6,214.1 L858.3,206.5 C820.5,197.8 801.8,179.6 801.8,150.7 C801.7,115.1 832.6,90.7 878.3,90.7 Z M1144.4,90.6 C1195.6,90.6 1226.8,123.5 1230.4,162.6 L1230.4,162.6 L1191.4,162.7 C1187.2,141.6 1171.3,124.7 1144.7,124.7 C1113.1,124.7 1092.4,150.9 1092.4,193.6 C1092.4,237.3 1113.4,262.6 1145.1,262.6 C1170.3,262.6 1186.7,248.8 1191.4,225.7 L1191.4,225.7 L1230.7,225.7 C1226.4,268.1 1192.5,296.8 1144.7,296.8 C1087.8,296.8 1050.8,257.8 1050.8,193.6 C1050.8,130.5 1087.9,90.6 1144.4,90.6 Z M642.4,94.3 L642.4,215.1 C642.4,245.3 656.7,261.6 684.9,261.6 C714.4,261.6 732.1,241.2 732.1,210.2 L732.1,210.2 L732.1,94.3 L773,94.3 L773.1,293.1 L734,293.1 L734,259.5 L733,259.5 C722,283.3 701.8,296.7 671.4,296.7 C628.2,296.7 601.6,268.6 601.6,223 L601.6,223 L601.6,94.3 L642.4,94.3 Z M151.9,76.4 C165.3,71.6 176.5,69.6 185.7,70.4 C210.6,72.4 229.5,82.2 241.9,100 C219.5,113.6 208.5,132.5 208.8,156.8 C209,175.7 215.9,191.5 229.4,204 C235.5,209.8 242.3,214.3 250,217.5 C248.4,222.2 246.6,226.8 244.8,231.2 C240.3,241.6 235,251.1 228.9,259.9 C220.5,271.9 213.7,280.1 208.3,284.8 C200.1,292.3 191.3,296.2 181.9,296.4 C175.1,296.4 167,294.5 157.5,290.5 C148,286.6 139.3,284.7 131.3,284.7 C122.9,284.7 113.9,286.6 104.3,290.5 C94.6,294.4 86.9,296.5 81,296.6 C71.9,297 63,293 54,284.6 C48.2,279.6 41.1,271 32.5,258.9 C23.3,245.9 15.7,230.9 9.7,213.7 C3.2,195.4 0,177.4 0,160.1 C0,140.2 4.3,123 12.9,108.7 C19.7,97.1 28.7,88 39.9,81.4 C51.2,74.6 63.4,71.2 76.5,71 C83.7,71 93.1,73.2 104.7,77.6 C116.4,81.9 123.9,84.2 127.1,84.2 C129.6,84.2 137.8,81.6 151.9,76.4 Z M1026.1,94.3 L1026.1,293.1 L985.3,293.1 L985.3,94.3 L1026.1,94.3 Z M338.5,20.4 L426.7,237.7 L428.2,237.7 L516.2,20.4 L565.4,20.4 L565.4,293.1 L526.7,293.1 L526.7,92.4 L525.4,92.4 L443.1,293.1 L411.7,293.1 L329.4,92.4 L328.1,92.4 L328.1,293.1 L289.6,293.1 L289.6,20.4 L338.5,20.4 Z M187.3,0 C187.4,1.9 187.5,3.9 187.5,5.9 C187.5,20.7 182.1,34.6 171.3,47.4 C158.2,62.6 142.5,71.5 125.4,70.1 C125.2,68.3 125.1,66.4 125.1,64.5 C125.1,50.3 131.3,35 142.3,22.5 C147.8,16.2 154.8,11 163.3,6.8 C171.7,2.6 179.7,0.4 187.3,0 Z M1005.7,15.2 C1018.7,15.2 1029.1,25.6 1029.1,38.7 C1029.1,51.6 1018.7,62.2 1005.6,62.2 C992.5,62.2 982.1,51.6 982.1,38.7 C982.1,25.7 992.7,15.2 1005.7,15.2 Z" fill="#000000"></path>
</svg>', 'SERVICE_APPLE_MUSIC', '2020-08-20 15:13:58.236+00', NULL, '2020-08-20 15:13:58.236+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('f7bd00c5-5b03-4b45-b643-c852d41da559', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Deezer', '<svg viewBox="0 0 1000 192" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient x1="50.3799227%" y1="67.4367339%" x2="49.4388672%" y2="32.3538285%" id="service-deezer-linearGradient-1">
      <stop stop-color="#358C7B" offset="0%"></stop>
      <stop stop-color="#33A65E" offset="52.56%"></stop>
    </linearGradient>
    <linearGradient x1="-1.61198612%" y1="65.3225642%" x2="101.430759%" y2="34.5836212%" id="service-deezer-linearGradient-2">
      <stop stop-color="#222B90" offset="0%"></stop>
      <stop stop-color="#367B99" offset="100%"></stop>
    </linearGradient>
    <linearGradient x1="0%" y1="50.0313747%" x2="100.055553%" y2="50.0313747%" id="service-deezer-linearGradient-3">
      <stop stop-color="#FF9900" offset="0%"></stop>
      <stop stop-color="#FF8000" offset="100%"></stop>
    </linearGradient>
    <linearGradient x1="-0.0393171947%" y1="50.0313747%" x2="100.016236%" y2="50.0313747%" id="service-deezer-linearGradient-4">
      <stop stop-color="#FF8000" offset="0%"></stop>
      <stop stop-color="#CC1953" offset="100%"></stop>
    </linearGradient>
    <linearGradient x1="-0.0790528006%" y1="50.0313747%" x2="99.9769145%" y2="50.0313747%" id="service-deezer-linearGradient-5">
      <stop stop-color="#CC1953" offset="0%"></stop>
      <stop stop-color="#241284" offset="100%"></stop>
    </linearGradient>
    <linearGradient x1="-0.118387874%" y1="50.0313747%" x2="99.9371692%" y2="50.0313747%" id="service-deezer-linearGradient-6">
      <stop stop-color="#222B90" offset="0%"></stop>
      <stop stop-color="#3559A6" offset="100%"></stop>
    </linearGradient>
    <linearGradient x1="-3.99956551%" y1="59.1891376%" x2="103.897449%" y2="40.7168001%" id="service-deezer-linearGradient-7">
      <stop stop-color="#CC1953" offset="0%"></stop>
      <stop stop-color="#241284" offset="100%"></stop>
    </linearGradient>
    <linearGradient x1="-3.56666325%" y1="38.5408081%" x2="103.543154%" y2="61.3653772%" id="service-deezer-linearGradient-8">
      <stop stop-color="#FFCC00" offset="0.2669841%"></stop>
      <stop stop-color="#CE1938" offset="99.99%"></stop>
    </linearGradient>
    <linearGradient x1="8.42393044%" y1="27.4398809%" x2="91.552988%" y2="72.3506914%" id="service-deezer-linearGradient-9">
      <stop stop-color="#FFD100" offset="0.2669841%"></stop>
      <stop stop-color="#FD5A22" offset="100%"></stop>
    </linearGradient>
  </defs>
  <path d="M444.95329,61.732919 C480.67412,61.732919 504.85437,81.6999455 504.85437,117.23759 C504.85437,122.916285 504.30482,128.04543 503.20572,132.991391 L503.20572,132.991391 L415.46071,132.991391 C415.82707,152.775234 431.03132,163.949442 449.53288,163.949442 C465.46987,163.949442 475.54497,156.622092 479.57501,141.78421 L479.57501,141.78421 L509.25078,153.507969 C500.27478,178.60414 479.7582,191.243818 449.53288,191.243818 C409.59883,191.243818 380.6558,166.697198 380.6558,125.664041 C380.6558,88.8441111 406.85107,61.732919 444.95329,61.732919 Z M574.09782,61.732919 C609.81865,61.732919 633.9989,81.6999455 633.9989,117.23759 C633.9989,122.916285 633.44935,128.04543 632.35025,132.991391 L632.35025,132.991391 L544.60524,132.991391 C544.97161,152.775234 560.17586,163.949442 578.67741,163.949442 C594.6144,163.949442 604.6895,156.622092 608.71955,141.78421 L608.71955,141.78421 L638.39531,153.507969 C629.41931,178.60414 608.90273,191.243818 578.67741,191.243818 C538.74336,191.243818 509.80033,166.697198 509.80033,125.664041 C509.80033,88.8441111 535.9956,61.732919 574.09782,61.732919 Z M754.71698,61.732919 L754.71698,90.4927647 L683.64169,159.736216 L756.732,159.736216 L756.732,191.243818 L640.04396,191.243818 L640.04396,161.201686 L710.93607,91.7750508 L642.24217,91.7750508 L642.24217,61.732919 L754.71698,61.732919 Z M823.77725,61.732919 C859.49808,61.732919 883.67833,81.6999455 883.67833,117.23759 C883.67833,122.916285 883.12878,128.04543 882.02968,132.991391 L882.02968,132.991391 L794.28467,132.991391 C794.65103,152.775234 809.85528,163.949442 828.35684,163.949442 C844.29383,163.949442 854.36893,156.622092 858.39897,141.78421 L858.39897,141.78421 L888.07474,153.507969 C879.09874,178.60414 858.58216,191.243818 828.35684,191.243818 C788.42279,191.243818 759.47976,166.697198 759.47976,125.664041 C759.47976,88.8441111 785.67503,61.732919 823.77725,61.732919 Z M931.67247,61.916102 L931.67247,81.333578 C937.16798,69.243452 947.79264,61.916102 962.8137,61.916102 C986.07804,61.916102 1000,78.0362708 1000,100.201503 L1000,100.201503 L1000,110.093424 L966.11101,110.093424 L966.11101,110.093424 L966.11101,106.429749 C966.11101,96.904195 959.69958,87.561825 949.62447,87.3786412 C938.81663,87.3786412 931.67247,94.7059906 931.67247,107.895219 L931.67247,107.895219 L931.67247,191.243818 L896.68437,191.243818 L896.68437,61.916102 L931.67247,61.916102 Z M371.31343,0 L371.31343,191.060638 L337.7908,191.060638 L337.7908,172.559077 C329.18117,185.93149 313.79374,191.060638 295.47536,191.060638 C258.83862,191.060638 234.10881,167.063565 234.10881,126.946328 C234.10881,86.2795388 259.93772,61.732919 295.65855,61.732919 C313.97692,61.732919 328.63162,67.777982 336.50852,81.1503943 L336.50852,81.1503943 L336.50852,0 L371.31343,0 Z M303.35226,89.0272948 C284.11797,89.0272948 269.0969,103.681993 269.0969,126.946328 C269.0969,149.844294 283.93479,164.132625 303.35226,164.132625 C322.037,164.132625 337.60762,149.844294 337.60762,126.946328 C337.60762,103.865177 322.037,89.0272948 303.35226,89.0272948 Z M444.95329,87.0122738 C430.66496,87.0122738 418.75801,95.4387255 415.46071,109.727057 L415.46071,109.727057 L470.96538,109.727057 L471.14856,108.627954 C471.14856,95.4387255 460.52391,87.0122738 444.95329,87.0122738 Z M574.09782,87.0122738 C559.80949,87.0122738 547.90255,95.4387255 544.60524,109.727057 L544.60524,109.727057 L600.10991,109.727057 L600.29309,108.627954 C600.29309,95.4387255 589.66844,87.0122738 574.09782,87.0122738 Z M823.77725,87.0122738 C809.48892,87.0122738 797.58197,95.4387255 794.28467,109.727057 L794.28467,109.727057 L849.78934,109.727057 L849.97252,108.627954 C849.97252,95.4387255 839.34787,87.0122738 823.77725,87.0122738 Z" fill="#000000"></path>
  <rect fill="#40AB5D" x="155.52299" y="61.732919" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-1)" x="155.52299" y="96.5378297" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-2)" x="155.52299" y="131.342731" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-3)" x="0" y="166.147643" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-4)" x="51.840996" y="166.147643" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-5)" x="103.68199" y="166.147643" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-6)" x="155.52299" y="166.147643" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-7)" x="103.68199" y="131.342731" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-8)" x="51.840996" y="131.342731" width="42.864994" height="25.09617"></rect>
  <rect fill="url(#service-deezer-linearGradient-9)" x="51.840996" y="96.5378297" width="42.864994" height="25.09617"></rect>
</svg>', 'SERVICE_DEEZER', '2020-08-20 15:14:23.564+00', NULL, '2020-08-20 15:14:23.564+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('bf6c0b40-1761-4e42-9ed9-74e1e09b97e9', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Genius', '<svg viewBox="0 0 468 120" xmlns="http://www.w3.org/2000/svg">
  <polyline fill="#F7F16C" points="0 0 468 0 468 119.894653 0 119.894653 0 0"></polyline>
  <path d="M404.433424,68.7657462 C405.326097,68.8815323 405.255132,69.8713168 405.475499,70.5286832 C405.692131,71.4624421 406.241181,72.2953551 406.954573,72.9340463 C415.283703,79.7392817 427.456185,81.3565523 437.298005,77.0425858 C437.443671,77.1957223 437.731269,77.5019952 437.876935,77.6588667 C435.348316,81.4760734 431.202426,83.9486672 426.824964,85.069178 C418.775962,87.1271828 409.852961,86.0776377 402.730247,81.6964405 C400.713328,80.4041181 398.34158,79.0893855 397.575898,76.650407 C396.126704,72.6165682 400.164278,67.7386113 404.433424,68.7657462 Z M281.707614,32.4201117 C281.655323,46.2621548 281.707614,60.1041979 281.681468,73.946241 C281.632913,75.4253152 282.036297,77.0015004 283.134397,78.0547805 C283.858994,78.835403 284.949625,79.044565 285.834828,79.5786752 C285.99917,82.1222346 284.531301,84.8264006 282.058707,85.692929 C279.903591,86.428731 277.240511,86.1448683 275.56348,84.5014525 C274.357063,83.302506 273.703432,81.6067997 273.710902,79.9148284 C273.714637,65.9719393 273.710902,52.0290503 273.710902,38.0861612 C273.681022,35.669593 275.08913,33.178324 277.427263,32.341676 C278.783081,31.8673264 280.396616,31.7253951 281.707614,32.4201117 Z M207.955595,43.5430487 C214.368651,53.9339186 220.542666,64.4741899 226.862346,74.9248204 C228.180814,77.3227135 230.500271,79.5151796 233.417334,79.4068635 C234.123256,79.5487949 235.131716,79.0557702 235.621006,79.7766321 C235.277382,81.8869274 233.99253,83.8702314 232.110072,84.9197765 C229.86905,86.1859537 227.131269,86.32415 224.66241,85.7564246 C222.219697,85.1849641 220.367119,83.2726257 219.127087,81.1810056 C215.28747,74.8015642 211.473998,68.4109178 207.626911,62.0352115 C207.313168,61.5832721 207.186177,61.049162 207.223528,60.5038468 C207.227263,55.0357542 207.230998,49.5676616 207.227263,44.099569 C207.410279,43.9613727 207.772578,43.681245 207.955595,43.5430487 Z M330.263081,32.139984 C330.393807,40.7193615 330.270551,49.3099441 330.319106,57.8930567 C330.588029,63.7832083 332.25012,70.0057781 336.672402,74.1666081 C341.270231,78.6075658 348.060527,79.8513328 354.234541,79.2948125 C357.054493,79.0856504 359.769864,78.2602075 362.365714,77.1733121 C362.511381,77.2965682 362.802713,77.5393456 362.94838,77.6626018 C359.926736,82.3799521 354.481053,85.0579729 349.046576,85.79751 C343.21992,86.5183719 336.948795,85.9319713 331.887821,82.7385156 C328.208811,80.4862889 325.564405,76.8184836 324.122682,72.79585 C322.580112,68.638755 322.262634,64.1604469 322.266369,59.7643097 C322.281309,52.5407502 322.243958,45.3171907 322.281309,38.0936313 C322.217813,35.3745251 323.808939,32.5284278 326.54672,31.7963607 C327.730726,31.6245491 329.306911,31.2099601 330.263081,32.139984 Z M197.307007,32.4724022 C197.404118,46.3069753 197.318212,60.1490184 197.348093,73.9873264 C197.351828,75.507486 197.856057,77.1060814 199.032594,78.1294812 C199.69743,78.7943176 200.631189,79.0520351 201.434222,79.5039745 C201.837606,82.0437989 200.268891,84.8226656 197.807502,85.6742538 C195.532865,86.4772865 192.690503,86.107518 191.028412,84.24 C189.653919,82.8020112 189.351381,80.7215962 189.358851,78.8129928 C189.381261,65.3556584 189.347646,51.894589 189.373791,38.4372546 C189.340176,35.7554988 190.837925,32.8981963 193.579441,32.1997446 C194.748508,32.0167279 196.399393,31.5498484 197.307007,32.4724022 Z M35.2811492,40.5139346 C35.4529609,40.659601 35.7891141,40.9546688 35.9571907,41.1003352 C33.8431604,46.5236073 33.3986911,52.5930407 34.8030646,58.2516201 C36.2896089,64.4032243 39.9499441,69.987103 44.9548923,73.8491301 C50.9683001,78.5552753 58.9799521,80.6431604 66.5209896,79.4105986 C68.5901995,79.1566161 70.5548284,78.4432243 72.5493376,77.8792338 L72.8436584,78.0473403 C73.011735,78.143525 73.1932578,78.2475084 73.3075499,78.312498 C68.2652514,83.4780527 60.9595211,86.3054749 53.7621069,86.0477574 C47.5470072,85.9581165 41.4140782,83.515403 36.7639585,79.3993935 C31.8075658,75.085427 28.5356744,68.8740623 27.8409577,62.3340144 C26.8399681,54.4306784 29.6898005,46.179984 35.2811492,40.5139346 Z M118.777877,31.9196169 C119.349338,32.3155307 119.184996,33.0326576 119.222346,33.6265283 C119.199936,46.8261453 119.222346,60.0257622 119.211141,73.2253791 C119.199936,74.779154 119.663081,76.4076297 120.764916,77.5468156 C122.016153,78.9848045 124.033073,79.4292737 125.866975,79.4255387 C134.360447,79.4105986 142.857654,79.4255387 151.35486,79.4143336 C152.060782,81.1025698 151.291365,83.0746688 150.122298,84.3632562 C148.968172,85.5211173 147.298611,86.107518 145.670136,86.0514924 C136.575323,86.0365523 127.480511,86.0440223 118.385698,86.0440223 C116.402394,86.0440223 114.370535,85.2932801 112.999777,83.8328811 C111.79336,82.4621229 111.22937,80.6058101 111.233047,78.7980527 C111.240575,65.6059058 111.24431,52.413759 111.233047,39.2216121 C111.225634,37.1598723 111.939026,34.9860814 113.552562,33.6227933 C114.96067,32.3603512 116.914094,31.8486512 118.777877,31.9196169 Z M409.2068,33.4621868 C406.360702,37.3466241 405.669721,42.6690503 407.443863,47.1510934 C408.792211,50.7105826 411.888555,53.347518 415.298643,54.8751476 C419.900208,57.0414685 425.047087,57.3290662 429.932514,58.4831923 C432.113775,59.073328 434.593839,60.0182921 435.553743,62.2481085 C436.427741,64.1567119 435.81146,66.4873743 434.298771,67.8842777 C432.715116,69.4529928 430.451684,69.9497526 428.341389,70.3643416 C427.874509,69.0159936 427.631732,67.4248683 426.309529,66.6106305 C423.631508,64.8028731 420.281181,64.7020271 417.218452,64.0371907 C411.903496,63.2005427 406.390583,61.564597 402.49494,57.6540144 C398.068923,53.1682362 397.269625,45.7653951 400.276329,40.2935674 C401.882394,37.230838 404.642586,34.9113807 407.712785,33.3986911 C408.1834,33.0289226 408.73245,33.1633839 409.2068,33.4621868 Z M363.131397,32.0466081 C363.079106,40.4093536 363.135132,48.772099 363.105251,57.1348444 C362.959585,60.1378132 362.541261,63.2677733 360.90905,65.8598883 C359.583113,68.0075339 357.342091,69.5463687 354.876967,70.0543336 C354.454908,70.203735 354.047789,69.994573 353.666816,69.8713168 C354.675275,67.3763128 355.14589,64.6945571 355.13095,62.0090662 C355.142155,53.9152434 355.134685,45.8176856 355.134685,37.7238627 C355.082394,35.1989785 356.651109,32.6031285 359.138643,31.8598563 C360.430966,31.5050279 361.913775,31.3855068 363.131397,32.0466081 Z M60.2237191,53.2093216 C60.7092737,54.3858579 60.8997606,55.7005906 61.6355626,56.7650758 C62.6626975,58.1881245 64.268763,59.2899601 66.0578452,59.3683958 C68.2092259,59.4505666 70.3643416,59.3273105 72.5157223,59.4020112 C72.9228412,59.3609258 73.4606864,59.6858739 73.4009258,60.1490184 C73.419601,61.676648 73.4943017,63.2192179 73.3523703,64.7431125 C71.346656,66.6890662 68.6238148,67.6900559 65.9682043,68.4109178 C65.206257,67.60415 65.9457941,66.2184517 64.9261293,65.6096409 C62.1995531,65.2921628 59.0060974,66.3379729 56.7277255,64.3285235 C53.9936792,62.3153392 53.5828252,57.9864326 55.8238468,55.4578132 C56.9144773,54.1318755 58.5653631,53.4670391 60.2237191,53.2093216 Z M150.30905,58.1171588 C150.428571,59.6074381 150.297845,61.2284437 149.326736,62.4385954 C148.15767,64.0521309 146.099665,64.7655227 144.161181,64.690822 C139.30937,64.6422666 134.457558,64.7468476 129.609481,64.6422666 C129.508635,64.5414206 129.306943,64.3434637 129.206097,64.2426177 C129.101516,62.2107582 129.191157,60.1751636 129.179952,58.139569 C136.21676,57.9826975 143.268508,58.031253 150.30905,58.1171588 Z M231.646927,32.0690184 C231.863559,33.5667678 231.770184,35.0831923 231.781389,36.5921468 C231.781389,44.0622187 231.781389,51.5322905 231.785124,59.0023623 C231.766449,60.4963767 231.889705,62.0090662 231.590902,63.4844054 C230.37328,62.7971588 229.910136,61.4077255 229.178069,60.2984198 C227.456217,57.3328013 225.562554,54.4605587 223.937813,51.4463847 C223.822027,46.9904868 223.922873,42.5271189 223.892993,38.067486 C223.855642,35.8152594 225.047119,33.4547167 227.161149,32.5134876 C228.543113,31.7851556 230.149178,31.9719074 231.646927,32.0690184 Z M73.423336,40.2860974 C73.3747805,42.4188029 73.4868316,44.5552434 73.3785156,46.6879489 C73.2664645,46.7850599 73.0386273,46.9867518 72.9228412,47.0875978 C70.827486,47.1847087 68.7209258,47.1249481 66.6218356,47.0950678 C62.2182283,42.5756744 55.1888907,40.8500878 49.2053631,42.8707422 C48.6637829,43.1695451 48.1408779,42.9641181 47.6515882,42.6802554 C50.0009258,38.9190742 53.9152434,36.1588827 58.2815004,35.3409098 C63.7346528,34.1942538 69.6995052,36.1439425 73.423336,40.2860974 Z M434.881437,38.3513488 C435.762905,39.1282362 437.021612,39.419569 437.802235,40.2860974 C438.015132,43.7447406 434.717095,47.1510934 431.187486,46.6468635 C428.774653,46.3181804 427.142442,44.3535515 425.028412,43.3600319 C422.974142,42.2619314 420.639745,41.7539665 418.316552,41.8361373 C417.655451,41.7875818 416.837478,42.0266241 416.422889,41.3543176 C416.183847,39.938739 416.628316,38.4223144 417.659186,37.4101197 C419.048619,36.0281564 420.998308,35.4193456 422.899441,35.1728332 C427.105092,34.6723384 431.497494,35.774174 434.881437,38.3513488 Z M149.778675,36.5958819 C150.391221,36.6519074 151.209194,36.4240702 151.578962,37.0889066 C152.146688,40.1628412 149.584453,43.1732801 146.499314,43.3077414 C141.371109,43.5094334 136.22423,43.3226816 131.088555,43.4011173 C130.434924,43.3450918 129.575866,43.6140144 129.206097,42.8856824 C129.135132,40.9584038 129.120192,39.0161852 129.213567,37.0851716 C129.336824,36.9731205 129.575866,36.7527534 129.699122,36.6407023 C136.388571,36.5473264 143.085491,36.6407023 149.778675,36.5958819 Z" fill="#000000"></path>
</svg>', 'SERVICE_GENIUS', '2020-08-20 15:14:50.669+00', NULL, '2020-08-20 15:14:50.669+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('d86a9787-a7c6-4a5e-b750-41805c4137ff', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Google Play Music', '<svg viewBox="0 0 1013 136" xmlns="http://www.w3.org/2000/svg">
  <path d="M216.1,37.5 C197.4,37.5 182.2,51.7 182.2,71.3 C182.2,90.8 197.4,105.1 216.1,105.1 C234.8,105.1 250.00097,90.8 250.00097,71.3 C250.1,51.7 234.8,37.5 216.1,37.5 Z M216.1,91.7 C205.9,91.7 197,83.3 197,71.2 C197,59 205.8,50.7 216.1,50.7 C226.4,50.7 235.2,59 235.2,71.2 C235.2,83.3 226.4,91.7 216.1,91.7 Z M142.1,37.5 C123.4,37.5 108.2,51.7 108.2,71.3 C108.2,90.8 123.4,105.1 142.1,105.1 C160.8,105.1 176,90.8 176,71.3 C176,51.7 160.8,37.5 142.1,37.5 Z M142.1,91.7 C131.9,91.7 123,83.3 123,71.2 C123,59 131.8,50.7 142.1,50.7 C152.3,50.7 161.2,59 161.2,71.2 C161.2,83.3 152.4,91.7 142.1,91.7 Z M54.1,47.8 L54.1,62.1 L88.4,62.1 C87.4,70.2 84.7,76.1 80.6,80.1 C75.6,85.1 67.8,90.6 54.1,90.6 C33,90.6 16.5,73.6 16.5,52.5 C16.5,31.4 33,14.4 54.1,14.4 C65.5,14.4 73.8,18.9 80,24.6 L90.1,14.5 C81.5,6.3 70.1,0 54.1,0 C25.2,0 0.8,23.6 0.8,52.5 C0.8,81.4 25.1,105 54.1,105 C69.7,105 81.5,99.9 90.7,90.3 C100.2,80.8 103.1,67.5 103.1,56.8 C103.1,53.5 102.8,50.4 102.3,47.8 L54.1,47.8 Z M414.1,59 C411.3,51.4 402.7,37.5 385.2,37.5 C367.8,37.5 353.3,51.2 353.3,71.3 C353.3,90.2 367.6,105.1 386.8,105.1 C402.3,105.1 411.2,95.6 415,90.1 L403.5,82.4 C399.7,88 394.4,91.7 386.9,91.7 C379.3,91.7 374,88.2 370.5,81.5 L415.7,62.8 L414.1,59 Z M368,70.2 C367.6,57.1 378.1,50.5 385.7,50.5 C391.6,50.5 396.6,53.4 398.2,57.7 L368,70.2 Z M331.3,103 L346.1,103 L346.1,3.7 L331.3,3.7 L331.3,103 Z M307,45 L306.5,45 C303.2,41 296.8,37.4 288.7,37.4 C271.8,37.4 256.3,52.2 256.3,71.3 C256.3,90.2 271.8,105 288.7,105 C296.8,105 303.2,101.4 306.5,97.3 L307,97.3 L307,102.2 C307,115.1 300.1,122 289,122 C279.9,122 274.3,115.5 272,110 L259.1,115.4 C262.8,124.4 272.7,135.4 289.1,135.4 C306.5,135.4 321.2,125.2 321.2,100.2 L321.2,39.5 L307,39.5 L307,45 Z M289.9,91.7 C279.7,91.7 271.1,83.1 271.1,71.3 C271.1,59.4 279.7,50.7 289.9,50.7 C300,50.7 307.9,59.4 307.9,71.3 C308,83.2 300,91.7 289.9,91.7 Z M483.7,3.7 L448.2,3.7 L448.2,103 L463,103 L463,65.4 L483.7,65.4 C500.1,65.4 516.3,53.5 516.3,34.6 C516.2,15.6 500.1,3.7 483.7,3.7 Z M484,51.5 L463,51.5 L463,17.5 L484,17.5 C495.1,17.5 501.4,26.7 501.4,34.5 C501.4,42.2 495.1,51.5 484,51.5 Z M575.7,37.3 C565,37.3 553.8,42 549.2,52.5 L562.4,58 C565.2,52.5 570.5,50.7 575.9,50.7 C583.6,50.7 591.4,55.3 591.5,63.5 L591.5,64.5 C588.8,63 583.1,60.7 576,60.7 C561.8,60.7 547.4,68.5 547.4,83.1 C547.4,96.4 559,105 572.1,105 C582.1,105 587.6,100.5 591,95.3 L591.5,95.3 L591.5,103 L605.8,103 L605.8,64.9 C605.8,47.1 592.7,37.3 575.7,37.3 Z M573.9,91.7 C569,91.7 562.3,89.3 562.3,83.3 C562.3,75.6 570.7,72.7 578,72.7 C584.5,72.7 587.6,74.1 591.5,76 C590.4,85.2 582.4,91.7 573.9,91.7 Z M658,39.5 L641,82.6 L640.5,82.6 L622.9,39.5 L606.9,39.5 L633.4,99.7 L618.3,133.2 L633.8,133.2 L674.6,39.5 L658,39.5 Z M524.4,103 L539.2,103 L539.2,3.7 L524.4,3.7 L524.4,103 Z" fill="#000000" opacity="0.54"></path>
  <path d="M859.8,40.1 L859.8,103 L848.5,103 L848.5,94.3 L848,94.3 C846.2,97.3 843.5,99.8 839.8,101.9 C836.1,104 832.2,105 828.2,105 C820.3,105 814.4,102.6 810.3,97.8 C806.2,93 804.2,86.6 804.2,78.6 L804.2,40.2 L816,40.2 L816,76.7 C816,88.4 821.2,94.2 831.5,94.2 C836.4,94.2 840.3,92.2 843.4,88.3 C846.5,84.4 848,79.9 848,74.7 L848,40.1 L859.8,40.1 Z M895.6,38.2 C901.1,38.2 906.1,39.5 910.4,42 C914.8,44.5 917.9,48.1 919.7,52.8 L909.5,57 C907.2,51.5 902.4,48.7 895.2,48.7 C891.7,48.7 888.8,49.4 886.4,50.9 C884,52.4 882.8,54.3 882.8,56.8 C882.8,60.4 885.6,62.8 891.1,64.1 L903.5,67 C909.4,68.4 913.7,70.7 916.6,74 C919.4,77.3 920.8,81.1 920.8,85.3 C920.8,90.9 918.5,95.6 913.9,99.4 C909.3,103.2 903.4,105 896.1,105 C889.1,105 883.3,103.3 878.8,99.9 C874.2,96.5 870.9,92.2 868.8,87.1 L879.3,82.7 C882.6,90.6 888.3,94.5 896.3,94.5 C900,94.5 903,93.7 905.3,92.1 C907.6,90.5 908.8,88.3 908.8,85.7 C908.8,81.6 905.9,78.8 900.2,77.4 L887.5,74.3 C883.5,73.3 879.7,71.3 876.1,68.5 C872.5,65.6 870.7,61.8 870.7,56.9 C870.7,51.4 873.2,46.9 878.1,43.4 C883,39.9 888.8,38.2 895.6,38.2 Z M984.7,38.2 C991.7,38.2 997.5,39.9 1002.1,43.3 C1006.7,46.7 1010.1,51 1012.2,56.2 L1001.4,60.7 C998.2,52.9 992.3,48.9 983.9,48.9 C978.7,48.9 974.1,51 970.1,55.3 C966.1,59.6 964.1,65 964.1,71.6 C964.1,78.2 966.1,83.6 970.1,87.9 C974.1,92.2 978.7,94.3 983.9,94.3 C992.7,94.3 998.7,90.4 1002.1,82.5 L1012.6,87 C1010.5,92.1 1007,96.4 1002.3,99.9 C997.5,103.3 991.7,105 984.7,105 C975.3,105 967.6,101.8 961.5,95.5 C955.4,89.1 952.4,81.2 952.4,71.6 C952.4,62 955.4,54.1 961.5,47.7 C967.6,41.3 975.3,38.2 984.7,38.2 Z M714.2,11.4 L746.1,67.2 L746.6,67.2 L778.5,11.4 L790.3,11.4 L790.3,103 L778.5,103 L778.5,48.6 L779,33.2 L778.5,33.2 L749.8,83.5 L742.9,83.5 L714.2,33.2 L713.7,33.2 L714.2,48.6 L714.2,103 L702.4,103 L702.4,11.4 L714.2,11.4 Z M941.9,40.3 L941.9,103 L930.1,103 L930.1,40.3 L941.9,40.3 Z M936,10.3 C938.3,10.3 940.3,11.1 941.9,12.7 C943.5,14.3 944.3,16.3 944.3,18.6 C944.4,21 943.5,22.9 941.9,24.5 C940.3,26.1 938.3,26.9 936,26.9 C933.7,26.9 931.7,26.1 930.1,24.5 C928.5,22.9 927.7,20.9 927.7,18.6 C927.7,16.3 928.5,14.3 930.1,12.7 C931.7,11.1 933.7,10.3 936,10.3 Z" fill="#FF5722"></path>
</svg>', 'SERVICE_GOOGLE_PLAY_MUSIC', '2020-08-20 15:15:33.202+00', NULL, '2020-08-20 15:15:33.202+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('d21dad22-9dd2-41f4-a2eb-ff318d0b4c31', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service iTunes Store', '<svg viewBox="0 0 124 26" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient x1="49.9592876%" y1="-0.0829545817%" x2="49.9592876%" y2="100.031669%" id="service-itunes-store-linearGradient-1">
      <stop stop-color="#EF4DB7" offset="0%"></stop>
      <stop stop-color="#C643FD" offset="100%"></stop>
    </linearGradient>
    <radialGradient cx="222.536461%" cy="186.3666%" fx="222.536461%" fy="186.3666%" r="0.441618865%" gradientTransform="translate(2.225365,1.863666),scale(1,0.865672),translate(-2.225365,-1.863666)" id="service-itunes-store-radialGradient-2">
      <stop stop-color="#FAE9FC" offset="0%"></stop>
      <stop stop-color="#FAE9FC" offset="66.9%"></stop>
      <stop stop-color="#F8DEFA" offset="81.18%"></stop>
      <stop stop-color="#F6D4F8" offset="91%"></stop>
      <stop stop-color="#F6D4F8" offset="100%"></stop>
    </radialGradient>
    <radialGradient cx="-202.801244%" cy="41.7954678%" fx="-202.801244%" fy="41.7954678%" r="0.441618865%" gradientTransform="translate(-2.028012,0.417955),scale(1,0.893939),translate(2.028012,-0.417955)" id="service-itunes-store-radialGradient-3">
      <stop stop-color="#F9E3FB" offset="0%"></stop>
      <stop stop-color="#F9E3FB" offset="74.59%"></stop>
      <stop stop-color="#F8DEFB" offset="80.97%"></stop>
      <stop stop-color="#F3D0FA" offset="88.26%"></stop>
      <stop stop-color="#ECBAF9" offset="95.99%"></stop>
      <stop stop-color="#EAB2F9" offset="98.1%"></stop>
      <stop stop-color="#EAB2F9" offset="100%"></stop>
    </radialGradient>
    <radialGradient cx="-173.285191%" cy="-209.707024%" fx="-173.285191%" fy="-209.707024%" r="0.570815953%" gradientTransform="translate(-1.732852,-2.097070),scale(0.666667,1),translate(1.732852,2.097070)" id="service-itunes-store-radialGradient-4">
      <stop stop-color="#FAE1F8" offset="0%"></stop>
      <stop stop-color="#FAE1F8" offset="60%"></stop>
      <stop stop-color="#F7D6F7" offset="85%"></stop>
      <stop stop-color="#F7D6F7" offset="100%"></stop>
    </radialGradient>
    <radialGradient cx="71.4229903%" cy="371.424872%" fx="71.4229903%" fy="371.424872%" r="0.570815953%" gradientTransform="translate(0.714230,3.714249),scale(0.666667,1),translate(-0.714230,-3.714249)" id="service-itunes-store-radialGradient-5">
      <stop stop-color="#FAE9FB" offset="0%"></stop>
      <stop stop-color="#FAE9FB" offset="68%"></stop>
      <stop stop-color="#F8DEF8" offset="81.32%"></stop>
      <stop stop-color="#F5CAF2" offset="98%"></stop>
      <stop stop-color="#F5CAF2" offset="100%"></stop>
    </radialGradient>
    <radialGradient cx="-199.283517%" cy="217.174008%" fx="-199.283517%" fy="217.174008%" r="0.545468661%" gradientTransform="translate(-1.992835,2.171740),scale(1,0.760345),translate(1.992835,-2.171740)" id="service-itunes-store-radialGradient-6">
      <stop stop-color="#FBE3F8" offset="0%"></stop>
      <stop stop-color="#FBE3F8" offset="74.5%"></stop>
      <stop stop-color="#FADEF6" offset="80.82%"></stop>
      <stop stop-color="#F9D1F0" offset="87.98%"></stop>
      <stop stop-color="#F6BAE7" offset="95.54%"></stop>
      <stop stop-color="#F5B1E3" offset="98%"></stop>
      <stop stop-color="#F5B1E3" offset="100%"></stop>
    </radialGradient>
  </defs>
  <path d="M30.9,6.8 C30.9,6.2 31.4,5.7 32,5.7 C32.6,5.7 33,6.2 33,6.8 C33,7.3 32.6,7.8 32,7.8 C31.4,7.8 30.9,7.3 30.9,6.8 Z M31,9.1 L32.9,9.1 L32.9,18.2 L31,18.2 C31,18.2 31,9.1 31,9.1 Z M37.8,18.2 L37.8,7.4 L34,7.4 L34,5.8 L43.5,5.8 L43.5,7.5 L39.7,7.5 L39.7,18.3 L37.8,18.2 L37.8,18.2 L37.8,18.2 Z M51.3,18.2 L49.5,18.2 L49.5,16.6 L49.5,16.6 C49,17.7 48.1,18.3 46.7,18.3 C44.7,18.3 43.5,17 43.5,15 L43.5,9.1 L45.4,9.1 L45.4,14.5 C45.4,15.9 46.1,16.6 47.3,16.6 C48.6,16.6 49.5,15.7 49.5,14.3 L49.5,9.1 L51.4,9.1 L51.3,18.2 L51.3,18.2 L51.3,18.2 Z M53.2,9.1 L55,9.1 L55,10.6 L55,10.6 C55.5,9.5 56.5,9 57.8,9 C59.8,9 60.9,10.3 60.9,12.4 L60.9,18.2 L59,18.2 L59,12.8 C59,11.4 58.4,10.7 57.1,10.7 C55.8,10.7 55,11.6 55,13 L55,18.2 L53.1,18.2 L53.2,9.1 L53.2,9.1 L53.2,9.1 Z M70.5,15.5 C70.2,17.1 68.6,18.3 66.6,18.3 C64,18.3 62.3,16.5 62.3,13.7 C62.3,10.9 63.9,9 66.5,9 C69,9 70.6,10.7 70.6,13.5 L70.6,14.1 L64.2,14.1 L64.2,14.2 C64.2,15.7 65.2,16.8 66.6,16.8 C67.6,16.8 68.4,16.3 68.7,15.5 L70.5,15.5 Z M64.2,12.8 L68.7,12.8 C68.7,11.4 67.8,10.5 66.5,10.5 C65.3,10.5 64.3,11.5 64.2,12.8 Z M75.4,9 C77.4,9 78.8,10.1 78.9,11.7 L77.2,11.7 C77.1,10.9 76.4,10.4 75.4,10.4 C74.4,10.4 73.7,10.9 73.7,11.6 C73.7,12.1 74.1,12.5 75.1,12.7 L76.6,13.1 C78.4,13.5 79.1,14.2 79.1,15.5 C79.1,17.1 77.6,18.3 75.3,18.3 C73.2,18.3 71.7,17.2 71.6,15.6 L73.4,15.6 C73.5,16.5 74.2,16.9 75.4,16.9 C76.5,16.9 77.2,16.4 77.2,15.7 C77.2,15.1 76.9,14.8 75.9,14.6 L74.3,14.2 C72.7,13.8 71.8,13 71.8,11.7 C71.9,10.1 73.3,9 75.4,9 Z M85.7,14.7 C85.8,15.9 87,16.7 88.7,16.7 C90.3,16.7 91.4,15.9 91.4,14.8 C91.4,13.8 90.7,13.3 89.1,12.9 L87.5,12.5 C85.2,11.9 84.2,10.9 84.2,9.2 C84.2,7.1 86.1,5.6 88.7,5.6 C91.3,5.6 93.1,7.1 93.2,9.2 L91.3,9.2 C91.2,8 90.2,7.2 88.7,7.2 C87.2,7.2 86.2,8 86.2,9.1 C86.2,10 86.9,10.5 88.5,10.9 L89.9,11.2 C92.4,11.8 93.5,12.8 93.5,14.6 C93.5,16.9 91.6,18.4 88.7,18.4 C85.9,18.4 84.1,17 84,14.7 L85.7,14.7 L85.7,14.7 L85.7,14.7 Z M97.3,7 L97.3,9.1 L99,9.1 L99,10.6 L97.3,10.6 L97.3,15.6 C97.3,16.4 97.6,16.7 98.4,16.7 C98.6,16.7 98.9,16.7 99,16.7 L99,18.2 C98.8,18.3 98.4,18.3 98,18.3 C96.2,18.3 95.5,17.6 95.5,15.9 L95.5,10.7 L94.2,10.7 L94.2,9.1 L95.5,9.1 L95.5,7 L97.3,7 C97.3,7 97.3,7 97.3,7 Z M99.7,13.7 C99.7,10.9 101.4,9.1 104,9.1 C106.6,9.1 108.3,10.9 108.3,13.7 C108.3,16.6 106.6,18.3 104,18.3 C101.4,18.3 99.7,16.5 99.7,13.7 Z M106.4,13.7 C106.4,11.7 105.5,10.6 104,10.6 C102.5,10.6 101.6,11.8 101.6,13.7 C101.6,15.7 102.5,16.8 104,16.8 C105.5,16.8 106.4,15.6 106.4,13.7 Z M109.8,9.1 L111.6,9.1 L111.6,10.6 L111.6,10.6 C111.9,9.6 112.7,9 113.8,9 C114.1,9 114.3,9 114.4,9.1 L114.4,10.8 C114.3,10.7 113.9,10.7 113.6,10.7 C112.4,10.7 111.7,11.5 111.7,12.8 L111.7,18.2 L109.8,18.2 L109.8,9.1 L109.8,9.1 L109.8,9.1 Z M122.9,15.5 C122.6,17.1 121,18.3 119,18.3 C116.4,18.3 114.7,16.5 114.7,13.7 C114.7,10.9 116.3,9 118.9,9 C121.4,9 123,10.7 123,13.5 L123,14.1 L116.6,14.1 L116.6,14.2 C116.6,15.7 117.6,16.8 119,16.8 C120,16.8 120.8,16.3 121.1,15.5 L122.9,15.5 Z M116.6,12.8 L121.1,12.8 C121.1,11.4 120.2,10.5 118.9,10.5 C117.7,10.5 116.7,11.5 116.6,12.8 Z" fill="#000000"></path>
  <path d="M7.7,0 C7.4,0 7.2,0 7,0 C6.7,0 6.5,0 6.2,0 C5.6,0 5.1,0 4.5,0.1 C4,0.2 3.5,0.4 3,0.7 C2.5,0.9 2,1.2 1.6,1.6 C1.2,2 0.9,2.4 0.6,2.9 C0.3,3.4 0.2,3.9 0.1,4.5 C0,5.1 0,5.6 0,6.2 C0,6.5 0,6.7 0,7 C0,7.2 0,7.5 0,7.7 L0,7.8 L0,17.2 L0,17.4 C0,17.6 0,17.9 0,18.1 C0,18.4 0,18.6 0,18.9 C0,19.5 0,20 0.1,20.6 C0.2,21.2 0.4,21.7 0.6,22.2 C0.9,22.7 1.2,23.1 1.6,23.5 C2,23.9 2.4,24.2 2.9,24.5 C3.4,24.8 3.9,24.9 4.5,25 C5,25.1 5.6,25.1 6.2,25.1 C6.5,25.1 6.7,25.1 7,25.1 C7.3,25.1 7.5,25.1 7.7,25.1 L7.9,25.1 L17.3,25.1 L17.5,25.1 C17.8,25.1 18,25.1 18.2,25.1 C18.5,25.1 18.7,25.1 19,25.1 C19.6,25.1 20.1,25.1 20.7,25 C21.3,24.9 21.8,24.7 22.3,24.5 C22.8,24.2 23.2,23.9 23.6,23.5 C24,23.1 24.3,22.7 24.6,22.2 C24.9,21.7 25,21.2 25.1,20.6 C25.2,20.1 25.2,19.5 25.2,18.9 C25.2,18.6 25.2,18.4 25.2,18.1 C25.2,17.9 25.2,17.6 25.2,17.4 L25.2,7.7 C25.2,7.5 25.2,7.2 25.2,7 C25.2,6.7 25.2,6.5 25.2,6.2 C25.2,5.6 25.2,5.1 25.1,4.5 C25,3.9 24.8,3.4 24.6,2.9 C24.3,2.4 24,2 23.6,1.6 C23.2,1.2 22.8,0.9 22.3,0.6 C21.8,0.3 21.3,0.2 20.7,0.1 C20.2,0 19.6,0 19,0 C18.7,0 18.5,0 18.2,0 C17.9,0 17.7,0 17.5,0 L7.7,0 L7.7,0 Z" fill="url(#service-itunes-store-linearGradient-1)"></path>
  <path d="M6.9,19.3 C6.9,19.6 6.8,19.9 6.7,20.2 C6.7,20.3 6.7,20.4 6.7,20.5 C6.7,20.5 6.7,20.5 6.7,20.5 C6.7,20.6 6.7,20.6 6.7,20.7 C6.7,20.7 6.8,20.8 6.8,20.8 C6.8,20.8 6.9,20.8 6.9,20.9 C7,20.9 7,20.9 7.1,20.9 C7.1,20.9 7.1,20.9 7.1,20.9 C7.2,20.9 7.3,20.8 7.4,20.8 C7.6,20.6 7.9,20.5 8.1,20.3 L12.5,17.1 L10.1,15.2 L8.7,14.2 L6.9,19.3 Z" fill="url(#service-itunes-store-radialGradient-2)"></path>
  <path d="M12.5,17 L16.9,20.2 C17.1,20.4 17.4,20.5 17.6,20.7 C17.7,20.7 17.8,20.8 17.9,20.8 C17.9,20.8 17.9,20.8 17.9,20.8 C18,20.8 18,20.8 18.1,20.8 C18.2,20.8 18.2,20.8 18.3,20.8 C18.3,20.8 18.4,20.7 18.4,20.7 C18.4,20.6 18.4,20.6 18.4,20.5 C18.4,20.5 18.4,20.5 18.4,20.5 C18.4,20.4 18.4,20.3 18.4,20.2 C18.3,19.9 18.2,19.6 18.1,19.3 L16.4,14.2 L12.5,17 Z" fill="url(#service-itunes-store-radialGradient-3)"></path>
  <path d="M4.7,9.6 C4.4,9.6 4.1,9.6 3.8,9.6 C3.7,9.6 3.6,9.6 3.5,9.7 C3.5,9.7 3.5,9.7 3.5,9.7 C3.4,9.7 3.4,9.8 3.3,9.8 C3.3,9.8 3.2,9.9 3.2,9.9 C3.2,9.9 3.2,10 3.2,10.1 C3.2,10.2 3.2,10.2 3.3,10.3 C3.3,10.3 3.3,10.3 3.3,10.3 C3.4,10.4 3.4,10.4 3.5,10.5 C3.8,10.6 4,10.8 4.2,11 L8.6,14.2 L10.1,9.6 L4.7,9.6 Z" fill="url(#service-itunes-store-radialGradient-4)"></path>
  <path d="M14.9,9.6 L16.4,14.2 L20.8,11 C21.1,10.8 21.3,10.6 21.5,10.4 C21.6,10.3 21.6,10.3 21.7,10.2 C21.7,10.2 21.7,10.2 21.7,10.2 C21.7,10.1 21.8,10.1 21.8,10 C21.8,9.9 21.8,9.9 21.8,9.8 C21.8,9.8 21.8,9.7 21.7,9.7 C21.7,9.7 21.6,9.6 21.5,9.6 C21.5,9.6 21.5,9.6 21.5,9.6 C21.4,9.6 21.3,9.6 21.2,9.6 C20.9,9.6 20.6,9.6 20.3,9.6 L14.9,9.6 Z" fill="url(#service-itunes-store-radialGradient-5)"></path>
  <polygon fill="#FFFFFF" points="10.1 9.6 8.6 14.2 10.1 15.2 12.5 17 16.4 14.2 14.9 9.6"></polygon>
  <path d="M12.4,3.20000044 C12.3,3.20000044 12.3,3.30000044 12.3,3.30000044 C12.3,3.30000044 12.3,3.30000044 12.3,3.30000044 C12.2,3.40000044 12.1,3.50000044 12.1,3.60000044 C12,3.90000044 11.9,4.10000044 11.8,4.40000044 L10.1,9.60000044 L15,9.60000044 L13.3,4.40000044 C13.2,4.10000044 13.1,3.90000044 13,3.60000044 C13,3.50000044 12.9,3.40000044 12.9,3.30000044 C12.9,3.30000044 12.9,3.30000044 12.9,3.30000044 C12.9,3.20000044 12.8,3.20000044 12.8,3.20000044 C12.8,3.20000044 12.7,3.20000044 12.6,3.20000044 C12.5,3.20000044 12.4,3.10000044 12.4,3.20000044" fill="url(#service-itunes-store-radialGradient-6)"></path>
</svg>', 'SERVICE_ITUNES_STORE', '2020-08-20 15:16:02.924+00', NULL, '2020-08-20 15:16:02.924+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('ef4d362f-edd7-4687-81f8-63f5d4e7f6c4', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Pandora', '<svg viewBox="0 0 98 20" xmlns="http://www.w3.org/2000/svg">
  <path d="M58.956,10 C58.956,6.40766384 61.8681638,3.4955 65.4605,3.4955 C69.0528362,3.4955 71.965,6.40766384 71.965,10 C71.965,13.5923362 69.0528362,16.5045 65.4605,16.5045 C61.8681638,16.5045 58.956,13.5923362 58.956,10 Z M25.133,4.958 L25.133,3.9 L27.53,3.9 L27.53,16.1 L25.133,16.1 L25.133,15.042 C22.4809071,17.2031025 18.607988,16.9402254 16.2722472,14.4405703 C13.9365064,11.9409151 13.9365064,8.05908487 16.2722472,5.55942972 C18.607988,3.05977457 22.4809071,2.79689752 25.133,4.958 Z M91.353,3.9 L93.75,3.9 L93.75,16.1 L91.353,16.1 L91.353,15.042 C88.7009071,17.2031025 84.827988,16.9402254 82.4922472,14.4405703 C80.1565064,11.9409151 80.1565064,8.05908487 82.4922472,5.55942972 C84.827988,3.05977457 88.7009071,2.79689752 91.353,4.958 L91.353,3.9 Z M73.623,9.945 C73.623,7.145 74.829,5.567 76.224,4.674 C78.134,3.452 80.395,3.518 80.395,3.522 L80.395,6.119 C80.395,6.119 76.225,5.898 76.225,9.945 L76.225,16.1 L73.622,16.1 L73.622,9.945 L73.623,9.945 Z M35.974,3.495 C37.439,3.495 38.79,3.98 39.877,4.797 C41.5153294,6.02456373 42.4788911,7.95279889 42.4770028,10 L42.4770028,16.1 L39.875,16.1 L39.875,10 C39.8722466,7.84651672 38.1274825,6.10130536 35.974,6.098 C33.819346,6.09965269 32.0727568,7.84534708 32.07,10 L32.07,16.1 L29.4699984,16.1 L29.4699984,10 C29.4685806,7.95244647 30.4329168,6.02414461 32.072,4.797 C33.1965912,3.95056616 34.5664664,3.49382405 35.974,3.496 L35.974,3.495 Z M54.824,4.958 L54.824,1.198 C54.824,0.536 55.362,4.4408921e-16 56.024,4.4408921e-16 L57.222,4.4408921e-16 L57.222,16.1 L54.825,16.1 L54.825,15.042 C52.1729071,17.2031025 48.299988,16.9402254 45.9642472,14.4405703 C43.6285064,11.9409151 43.6285064,8.05908487 45.9642472,5.55942972 C48.299988,3.05977457 52.1729071,2.79689752 54.825,4.958 L54.824,4.958 Z M2.397,4.958 C5.04909295,2.79689752 8.92201198,3.05977457 11.2577528,5.55942972 C13.5934936,8.05908487 13.5934936,11.9409151 11.2577528,14.4405703 C8.92201198,16.9402254 5.04909295,17.2031025 2.397,15.042 L2.397,18.802 C2.397,19.464 1.86,20 1.198,20 L0,20 L0,3.9 L2.397,3.9 L2.397,4.958 L2.397,4.958 Z M2.313,10 C2.31575491,12.2339543 4.12604573,14.0442451 6.36,14.047 C8.59395427,14.0442451 10.4042451,12.2339543 10.407,10 C10.4042451,7.76604573 8.59395427,5.95575491 6.36,5.953 C4.12604573,5.95575491 2.31575491,7.76604573 2.313,10 Z M46.815,10 C46.8177549,12.2339543 48.6280457,14.0442451 50.862,14.047 C53.0959543,14.0442451 54.9062451,12.2339543 54.909,10 C54.9062451,7.76604573 53.0959543,5.95575491 50.862,5.953 C48.6280457,5.95575491 46.8177549,7.76604573 46.815,10 L46.815,10 Z M83.343,10 C83.345205,12.2341824 85.1558176,14.044795 87.39,14.047 C89.6241824,14.044795 91.434795,12.2341824 91.437,10 C91.4342451,7.76604573 89.6239543,5.95575491 87.39,5.953 C85.1560457,5.95575491 83.3457549,7.76604573 83.343,10 Z M17.123,10 C17.125205,12.2341824 18.9358176,14.044795 21.17,14.047 C23.4041824,14.044795 25.214795,12.2341824 25.217,10 C25.2142451,7.76604573 23.4039543,5.95575491 21.17,5.953 C18.9360457,5.95575491 17.1257549,7.76604573 17.123,10 L17.123,10 Z M61.558,10 C61.5607547,12.153873 63.306127,13.8992453 65.46,13.902 C67.6142636,13.8997962 69.3602442,12.1542629 69.363,10 C69.3602453,7.84557467 67.6144253,6.09975467 65.46,6.097 C63.3057371,6.0997558 61.5602038,7.84573645 61.558,10 L61.558,10 Z M94.968,3.544 C94.968,2.877 95.505,2.346 96.166,2.346 C96.833,2.346 97.364,2.877 97.364,3.544 C97.3377383,4.18660785 96.8091442,4.69404083 96.166,4.69404083 C95.5228558,4.69404083 94.9942617,4.18660785 94.968,3.544 L94.968,3.544 Z M95.115,3.544 C95.115,4.121 95.584,4.595 96.166,4.595 C96.748,4.595 97.217,4.121 97.217,3.545 C97.217,2.956 96.748,2.493 96.167,2.493 C95.584,2.493 95.115,2.956 95.115,3.544 Z M96.5,4.234 L96.143,3.691 L95.878,3.691 L95.878,4.234 L95.714,4.234 L95.714,2.86 L96.274,2.86 C96.505,2.86 96.692,3.024 96.692,3.279 C96.6957531,3.4837185 96.5450372,3.65854895 96.342,3.685 L96.709,4.234 L96.499,4.234 L96.5,4.234 Z M95.878,3.013 L95.878,3.533 L96.273,3.533 C96.409532,3.52584086 96.5180088,3.41562844 96.523,3.279 C96.523,3.126 96.393,3.013 96.273,3.013 L95.878,3.013 L95.878,3.013 Z" fill="#3668FF"></path>
</svg>', 'SERVICE_PANDORA', '2020-08-20 15:16:24.021+00', NULL, '2020-08-20 15:16:24.021+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('19acfb25-e5f1-49c5-b88c-b5279f7a219c', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service SoundCloud', '<svg viewBox="0 0 125 15" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient x1="50.0408905%" y1="-57.8785883%" x2="50.0408905%" y2="99.8756944%" id="service-soundcloud-linearGradient-1">
      <stop stop-color="#F8A01D" offset="0%"></stop>
      <stop stop-color="#F26E23" offset="71.28%"></stop>
      <stop stop-color="#EF5826" offset="100%"></stop>
    </linearGradient>
  </defs>
  <path d="M59.9,3.5 L59.9,8.6 C59.9,10.1 59.2,11 58,11 C56.8,11 56.1,10.1 56.1,8.6 L56.1,3.5 L54.3,3.5 L54.3,8.6 C54.3,11.2 55.8,12.7 58,12.7 C60.3,12.7 61.7,11.2 61.7,8.5 L61.7,3.4 L59.9,3.4 L59.9,3.5 Z M69.5,3.5 L69.5,7.3 C69.5,7.8 69.5,8.9 69.5,9.3 C69.4,9.1 69.1,8.6 68.9,8.3 L65.7,3.5 L64,3.5 L64,12.6 L65.8,12.6 L65.8,8.6 C65.8,8.1 65.8,6.9 65.8,6.6 C65.9,6.8 66.2,7.3 66.4,7.6 L69.7,12.6 L71.3,12.6 L71.3,3.5 L69.5,3.5 Z M75.5,5.3 L76.5,5.3 C78.4,5.3 79.2,6.2 79.2,8.1 C79.2,9.8 78.3,10.9 76.4,10.9 L75.5,10.9 L75.5,5.3 Z M73.7,3.5 L73.7,12.6 L76.4,12.6 C78.7,12.6 81.1,11.3 81.1,8.1 C81.1,4.8 79.2,3.6 76.6,3.6 L73.7,3.6 L73.7,3.5 Z M91.6,3.5 L91.6,12.6 L97.1,12.6 L97.1,10.8 L93.5,10.8 L93.5,3.5 L91.6,3.5 Z M113.1,3.5 L113.1,8.6 C113.1,10.1 112.4,11 111.2,11 C110,11 109.3,10.1 109.3,8.6 L109.3,3.5 L107.5,3.5 L107.5,8.6 C107.5,11.2 109,12.7 111.2,12.7 C113.5,12.7 114.9,11.2 114.9,8.5 L114.9,3.4 L113.1,3.4 L113.1,3.5 Z M119,5.3 L120,5.3 C121.9,5.3 122.7,6.2 122.7,8.1 C122.7,9.8 121.8,10.9 119.9,10.9 L119,10.9 L119,5.3 Z M117.2,3.5 L117.2,12.6 L119.9,12.6 C122.2,12.6 124.6,11.3 124.6,8.1 C124.6,4.8 122.7,3.6 120.1,3.6 L117.2,3.6 L117.2,3.5 Z M36.5,6.1 C36.5,7.9 37.7,8.4 39.3,8.8 C41,9.2 41.3,9.4 41.3,10 C41.3,10.7 40.8,11 39.7,11 C38.8,11 38,10.7 37.4,10 L36.1,11.2 C36.8,12.2 38.1,12.9 39.6,12.9 C42.1,12.9 43.2,11.7 43.2,10 C43.2,8 41.6,7.5 40.2,7.2 C38.8,6.9 38.4,6.7 38.4,6.1 C38.4,5.7 38.7,5.3 39.7,5.3 C40.5,5.3 41.2,5.6 41.8,6.2 L43.1,4.9 C42.2,4 41.2,3.5 39.8,3.5 C37.9,3.4 36.5,4.4 36.5,6.1 M46.5,8.1 C46.5,6.5 47.1,5.2 48.6,5.2 C50.1,5.2 50.7,6.5 50.7,8.1 C50.7,9.7 50.1,11 48.6,11 C47.1,11 46.5,9.7 46.5,8.1 M44.6,8.1 C44.6,10.9 46.1,12.8 48.5,12.8 C51,12.8 52.5,10.9 52.5,8.1 C52.5,5.3 51,3.4 48.5,3.4 C46.1,3.4 44.6,5.3 44.6,8.1 M82.6,8.1 C82.6,11 84.2,12.8 86.6,12.8 C88.3,12.8 89.3,12 90,10.7 L88.5,9.8 C88,10.6 87.5,11 86.7,11 C85.3,11 84.5,9.8 84.5,8.1 C84.5,6.4 85.3,5.2 86.6,5.2 C87.4,5.2 87.9,5.6 88.3,6.2 L90,5.4 C89.4,4.2 88.4,3.4 86.7,3.4 C84.3,3.4 82.6,5.3 82.6,8.1 M99.8,8.1 C99.8,6.5 100.4,5.2 101.9,5.2 C103.4,5.2 104,6.5 104,8.1 C104,9.7 103.4,11 101.9,11 C100.4,11 99.8,9.7 99.8,8.1 M97.9,8.1 C97.9,10.9 99.4,12.8 101.8,12.8 C104.3,12.8 105.7,10.9 105.7,8.1 C105.7,5.3 104.2,3.4 101.8,3.4 C99.4,3.4 97.9,5.3 97.9,8.1 M0.2,8.7 L0,10.5 L0.2,12.3 C0.2,12.4 0.3,12.4 0.3,12.4 C0.4,12.4 0.4,12.3 0.4,12.3 L0.7,10.5 L0.4,8.7 C0.4,8.6 0.3,8.6 0.3,8.6 C0.3,8.6 0.2,8.6 0.2,8.7 M1.4,7.6 L1.1,10.5 L1.4,13.4 C1.4,13.5 1.5,13.5 1.5,13.5 C1.6,13.5 1.6,13.4 1.6,13.4 L2,10.5 L1.6,7.6 C1.6,7.5 1.5,7.5 1.5,7.5 C1.5,7.4 1.4,7.5 1.4,7.6 M5.2,7.2 L5,10.5 L5.2,14 C5.2,14.1 5.3,14.2 5.4,14.2 C5.5,14.2 5.6,14.1 5.6,14 L6,10.5 L5.7,7.2 C5.7,7.1 5.6,7 5.5,7 C5.3,7 5.2,7.1 5.2,7.2 M2.7,7 L2.4,10.5 L2.7,13.8 C2.7,13.9 2.8,14 2.9,14 C2.9,14 3,13.9 3,13.8 L3.3,10.5 L3,7 C3,6.9 2.9,6.8 2.8,6.8 C2.8,6.9 2.7,6.9 2.7,7 M3.9,6.9 L3.6,10.5 L3.9,13.9 C3.9,14 4,14.1 4.1,14.1 C4.2,14.1 4.3,14 4.3,13.9 L4.6,10.5 L4.3,6.9 C4.3,6.8 4.2,6.7 4.1,6.7 C4,6.7 4,6.8 3.9,6.9 M6.5,5.1 L6.2,10.5 L6.5,14 C6.5,14.1 6.6,14.2 6.7,14.2 C6.9,14.2 7,14.1 7,14 L7,14 L7.3,10.5 L7,5.1 C7,5 6.9,4.9 6.8,4.9 C6.6,4.9 6.5,5 6.5,5.1 M7.8,3.9 L7.6,10.5 L7.8,14 C7.8,14.2 7.9,14.3 8.1,14.3 C8.2,14.3 8.4,14.2 8.4,14 L8.7,10.5 L8.4,3.9 C8.4,3.7 8.3,3.6 8.1,3.6 C7.9,3.6 7.8,3.7 7.8,3.9 M13.1,3.6 L12.9,10.5 L13.1,13.8 C13.1,14 13.3,14.2 13.5,14.2 C13.7,14.2 13.9,14 13.9,13.8 L13.9,13.8 L14.1,10.5 L13.9,3.5 C13.9,3.3 13.7,3.1 13.5,3.1 C13.2,3.2 13.1,3.3 13.1,3.6 M9.1,3.3 L8.9,10.5 L9.1,13.9 C9.1,14.1 9.2,14.2 9.4,14.2 C9.6,14.2 9.7,14.1 9.7,13.9 L9.9,10.5 L9.7,3.3 C9.7,3.1 9.6,3 9.4,3 C9.2,3 9.1,3.2 9.1,3.3 M11.7,3.3 L11.5,10.5 L11.7,13.9 C11.7,14.1 11.9,14.3 12.1,14.3 C12.3,14.3 12.5,14.1 12.5,13.9 L12.5,13.9 L12.7,10.5 L12.5,3.3 C12.5,3.1 12.3,2.9 12.1,2.9 C11.9,2.9 11.7,3.1 11.7,3.3 M10.4,3.1 L10.2,10.5 L10.4,13.9 C10.4,14.1 10.5,14.2 10.7,14.2 C10.9,14.2 11,14.1 11,13.9 L11,13.9 L11,13.9 L11,13.9 L11.2,10.5 L11,3.1 C11,2.9 10.8,2.8 10.7,2.8 C10.6,2.8 10.4,2.9 10.4,3.1 M14.4,2.2 L14.2,10.5 C14.2,10.5 14.4,13.8 14.4,13.8 C14.4,14 14.6,14.2 14.8,14.2 C15,14.2 15.2,14 15.2,13.8 L15.2,13.8 L15.2,13.8 L15.4,10.5 L15.2,2.2 C15.2,2 15,1.8 14.8,1.8 C14.6,1.8 14.4,2 14.4,2.2 M15.8,1.5 L15.6,10.5 L15.8,13.8 C15.8,14 16,14.2 16.2,14.2 C16.4,14.2 16.6,14 16.6,13.8 L16.6,13.8 L16.8,10.5 L16.6,1.5 C16.6,1.3 16.4,1.1 16.2,1.1 C16,1 15.8,1.2 15.8,1.5 M17.4,0.6 C17.1,0.7 17,0.8 17,1.1 L17,13.8 C17,14 17.2,14.2 17.4,14.3 C17.4,14.3 28.4,14.3 28.5,14.3 C30.7,14.3 32.5,12.5 32.5,10.3 C32.5,8.1 30.7,6.3 28.5,6.3 C28,6.3 27.4,6.4 27,6.6 C26.7,3 23.7,0.2 20,0.2 C19.1,0.1 18.2,0.3 17.4,0.6" fill="url(#service-soundcloud-linearGradient-1)"></path>
</svg>', 'SERVICE_SOUNDCLOUD', '2020-08-20 15:16:58.57+00', NULL, '2020-08-20 15:16:58.57+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('4dd3e970-90a0-4508-a887-d77a4f335c33', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Spotify', '<svg viewBox="0 0 1000 312" xmlns="http://www.w3.org/2000/svg">
  <path d="M155.57644,0 C69.655768,0 0,69.653906 0,155.57458 C0,241.49896 69.655768,311.1473 155.57644,311.1473 C241.5064,311.1473 311.15474,241.49896 311.15474,155.57458 C311.15474,69.659479 241.5064,0.00743 155.57458,0.00743 L155.57644,0 Z M226.92279,224.38319 C224.13611,228.95334 218.15405,230.40242 213.5839,227.59716 C177.05614,205.28517 131.07226,200.232 76.917847,212.60484 C71.699331,213.79382 66.497535,210.52412 65.308553,205.30375 C64.113997,200.08337 67.370693,194.88158 72.602214,193.6926 C131.86554,180.15306 182.70009,185.98279 223.70882,211.0443 C228.27897,213.84956 229.72805,219.81305 226.92279,224.38319 L226.92279,224.38319 Z M245.96508,182.02199 C242.45387,187.72911 234.98558,189.53116 229.28218,186.01995 C187.46345,160.31564 123.71729,152.8715 74.253785,167.88611 C67.838855,169.82378 61.063515,166.20853 59.116557,159.80475 C57.184462,153.38982 60.801568,146.62749 67.205351,144.67681 C123.70615,127.53318 193.94712,135.83748 241.97084,165.34838 C247.67424,168.85959 249.47629,176.32789 245.96508,182.02385 L245.96508,182.02199 Z M247.59993,137.91076 C197.45833,108.12862 114.73119,105.39025 66.857945,119.91998 C59.170433,122.2515 51.040769,117.91171 48.711107,110.2242 C46.381445,102.53297 50.717514,94.408883 58.410599,92.07179 C113.36572,75.388886 204.72227,78.612142 262.45106,112.88269 C269.3806,116.98654 271.64709,125.91691 267.54139,132.82229 C263.45426,139.73696 254.49974,142.01647 247.60736,137.91076 L247.59993,137.91076 Z M423.27202,143.61788 C396.40846,137.21224 391.63396,132.7164 391.63396,123.26956 C391.63396,114.34477 400.03114,108.33855 412.53403,108.33855 C424.64678,108.33855 436.64807,112.89941 449.24385,122.28865 C449.61541,122.57289 450.09843,122.68622 450.56288,122.61191 C451.0459,122.54131 451.45461,122.28308 451.73328,121.8948 L464.84924,103.40613 C465.388,102.64444 465.23937,101.59479 464.51484,101.01331 C449.52252,88.987868 432.65384,83.141421 412.92416,83.141421 C383.92415,83.141421 363.65572,100.547 363.65572,125.4506 C363.65572,152.15625 381.13747,161.61238 411.34505,168.91161 C437.03821,174.83237 441.38542,179.79265 441.38542,188.658 C441.38542,198.48568 432.61668,204.59779 418.49752,204.59779 C402.81782,204.59779 390.01768,199.30311 375.71274,186.93026 C375.35976,186.61444 374.87674,186.48439 374.43087,186.50297 C373.94785,186.54017 373.52056,186.76306 373.22331,187.11604 L358.50966,204.61637 C357.89659,205.35948 357.9709,206.437 358.67686,207.06864 C375.32261,221.93092 395.79539,229.77077 417.90303,229.77077 C449.15096,229.77077 469.345253,212.69773 469.345253,186.26146 C469.40078,163.95504 456.04334,151.60078 423.32776,143.64203 L423.27202,143.61788 Z M540.05235,117.12587 C526.5091,117.12587 515.39955,122.46143 506.2221,133.39449 L506.2221,121.08852 C506.2221,120.1169 505.44183,119.32549 504.47578,119.32549 L480.41747,119.32549 C479.45142,119.32549 478.67115,120.1169 478.67115,121.08852 L478.67115,257.82331 C478.67115,258.78936 479.45142,259.58821 480.41747,259.58821 L504.47578,259.58821 C505.44183,259.58821 506.2221,258.78936 506.2221,257.82331 L506.2221,214.66698 C515.39955,224.94053 526.5091,229.97513 540.05235,229.97513 C565.22533,229.97513 590.714171,210.59843 590.714171,173.55607 C590.75133,136.50628 565.26249,117.12401 540.07093,117.12401 L540.05235,117.12587 Z M562.7359,173.55607 C562.7359,192.41073 551.12475,205.58242 534.479,205.58242 C518.03761,205.58242 505.62761,191.81623 505.62761,173.55607 C505.62761,155.29405 518.03761,141.53158 534.479,141.53158 C550.84608,141.52958 562.7359,154.99495 562.7359,173.55421 L562.7359,173.55607 Z M656.01525,117.12587 C623.59692,117.12587 598.201,142.08706 598.201,173.95921 C598.201,205.48953 623.42972,230.17948 655.62512,230.17948 C688.15492,230.17948 713.62515,205.30375 713.62515,173.55607 C713.62515,141.91615 688.32212,117.12959 656.01525,117.12959 L656.01525,117.12587 Z M656.01525,205.7682 C638.77501,205.7682 625.77052,191.90912 625.77052,173.54678 C625.77052,155.10084 638.32915,141.71551 655.62512,141.71551 C672.97683,141.71551 686.05563,155.569 686.05563,173.94992 C686.05563,192.39215 673.42269,205.7682 656.01525,205.7682 Z M782.84619,119.32549 L756.37277,119.32549 L756.37277,92.265 C756.37277,91.295236 755.5925,90.50382 754.62645,90.50382 L730.56814,90.50382 C729.60209,90.50382 728.80325,91.295236 728.80325,92.265 L728.80325,119.32549 L717.24783,119.32549 C716.28178,119.32549 715.50151,120.1169 715.50151,121.08852 L715.50151,141.76009 C715.50151,142.72986 716.28178,143.52313 717.24783,143.52313 L728.80325,143.52313 L728.80325,197.01803 C728.80325,218.62406 739.55982,229.58499 760.79429,229.58499 C769.41441,229.58499 776.56688,227.80152 783.31064,223.97448 C783.86798,223.67724 784.20238,223.08275 784.20238,222.4511 L784.20238,202.75858 C784.20238,202.16409 783.88655,201.58818 783.36637,201.27236 C782.84619,200.93796 782.19597,200.91938 781.65721,201.19806 C777.03133,203.52029 772.55407,204.5978 767.53805,204.5978 C759.82825,204.5978 756.37277,201.08659 756.37277,193.24674 L756.37277,143.53243 L782.84619,143.53243 C783.81224,143.53243 784.59251,142.74101 784.59251,141.76939 L784.59251,121.09968 C784.62971,120.12806 783.8494,119.33665 782.86477,119.33665 L782.84619,119.32549 Z M875.06661,119.43138 L875.06661,116.1078 C875.06661,106.33029 878.81934,101.97007 887.21652,101.97007 C892.23254,101.97007 896.26393,102.96584 900.77835,104.47064 C901.33568,104.64527 901.9116,104.55794 902.35746,104.22542 C902.82191,103.89287 903.082,103.35969 903.082,102.79492 L903.082,82.526494 C903.082,81.751798 902.59898,81.066276 901.83729,80.837768 C897.08136,79.420279 890.98782,77.965633 881.84753,77.965633 C859.647,77.965633 847.88723,90.475954 847.88723,114.13112 L847.88723,119.22145 L836.33181,119.22145 C835.36576,119.22145 834.56691,120.01287 834.56691,120.98263 L834.56691,141.76009 C834.56691,142.72986 835.36576,143.52313 836.33181,143.52313 L847.88723,143.52313 L847.88723,226.01804 C847.88723,227.00267 848.68607,227.78294 849.65212,227.78294 L873.69185,227.78294 C874.67648,227.78294 875.45675,227.00267 875.45675,226.01804 L875.45675,143.5287 L897.91736,143.5287 L932.32353,226.01804 C928.42218,234.67532 924.57657,236.40306 919.33761,236.40306 C915.10187,236.40306 910.62461,235.13977 906.07303,232.63176 C905.64574,232.40882 905.12556,232.37167 904.6797,232.50171 C904.21525,232.66891 903.82511,233.00331 903.63934,233.44918 L895.48366,251.33965 C895.09353,252.19423 895.42796,253.17885 896.24535,253.62472 C904.75401,258.23203 912.42666,260.20128 921.91993,260.20128 C939.68035,260.20128 949.50803,251.91556 958.14673,229.6593 L999.8726,121.83907 C1000.0955,121.2966 1000.0212,120.68353 999.68679,120.20236 C999.37097,119.72491 998.83221,119.43695 998.2563,119.43695 L973.21336,119.43695 C972.45167,119.43695 971.78287,119.9144 971.54136,120.6185 L945.88535,193.87837 L917.79565,120.5702 C917.53556,119.8884 916.88534,119.43695 916.1608,119.43695 L875.06661,119.43695 L875.06661,119.43138 Z M821.59958,119.32549 L797.54127,119.32549 C796.57522,119.32549 795.77637,120.1169 795.77637,121.08852 L795.77637,226.01804 C795.77637,227.00267 796.57522,227.78294 797.54127,227.78294 L821.59958,227.78294 C822.56562,227.78294 823.36447,227.00267 823.36447,226.01804 L823.36447,121.09596 C823.36447,120.12433 822.5842,119.33292 821.59958,119.33292 L821.59958,119.32549 Z M809.70976,71.545131 C800.17932,71.545131 792.45094,79.258651 792.45094,88.787228 C792.45094,98.321377 800.17932,106.04419 809.70976,106.04419 C819.24019,106.04419 826.95,98.321377 826.95,88.787228 C826.95,79.260509 819.22161,71.545131 809.70976,71.545131 Z" fill="#1ED760"></path>
</svg>', 'SERVICE_SPOTIFY', '2020-08-20 15:17:19.195+00', NULL, '2020-08-20 15:17:19.195+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('0d8f62f9-dcb8-4319-83fe-87e48e054566', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service Tidal', '<svg viewBox="0 0 191 26" xmlns="http://www.w3.org/2000/svg">
  <path d="M18.918532,12.61 L25.2238654,18.9166667 L18.918532,25.2233334 L12.6118653,18.9166667 L18.918532,12.61 Z M95.2281324,3.19552976 L95.2281324,24.7395177 L90.3067981,24.7395177 L90.3067981,3.19552976 L95.2281324,3.19552976 Z M118.043734,3.08839967 C123.7504,3.08839967 129.4864,6.75639968 129.4864,13.9190664 C129.4864,21.517733 123.6344,24.6323997 117.753067,24.6323997 L117.753067,24.6323997 L109.781067,24.6323997 L109.781067,3.08839967 L118.043734,3.08839967 Z M75.6694717,3.03 L75.6694717,7.2233334 L69.342805,7.2233334 L69.342805,24.5740001 L64.450805,24.5740001 L64.450805,7.2233334 L58.1241383,7.2233334 L58.1241383,3.03 L75.6694717,3.03 Z M182.064254,3.03 L182.064254,20.3220001 L190.574921,20.3220001 L190.574921,24.5740001 L177.144254,24.5740001 L177.144254,3.03 L182.064254,3.03 Z M155.156277,3.03 L164.032277,24.5740001 L158.622944,24.5740001 L157.04961,20.3233334 L147.96561,20.3233334 L146.37761,24.5740001 L141.114944,24.5740001 L150.076277,3.03 L155.156277,3.03 Z M117.607734,7.31106635 L114.555734,7.31106635 L114.555734,20.4390664 L117.723734,20.4390664 C121.683734,20.4390664 124.449067,17.8203997 124.449067,13.9483997 C124.449067,9.8723997 121.713067,7.31106635 117.607734,7.31106635 L117.607734,7.31106635 Z M152.52961,8.0700001 L149.284277,16.4953334 L155.744277,16.4953334 L152.52961,8.0700001 Z M18.918532,0 L25.2238654,6.30666668 L18.918532,12.6106667 L12.6120044,6.30666668 L6.30533768,12.612 L4.33500001e-06,6.30666668 L6.30533768,0 L12.6120044,6.30666668 L18.918532,0 Z M31.529731,0 L37.8350644,6.30666668 L31.529731,12.612 L25.2230643,6.30666668 L31.529731,0 Z" fill="#100F0D"></path>
</svg>', 'SERVICE_TIDAL', '2020-08-20 15:17:37.556+00', NULL, '2020-08-20 15:17:37.556+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('83332a9e-5dbd-40c2-b6eb-f1a064540654', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service YouTube', '<svg viewBox="0 0 489 110" xmlns="http://www.w3.org/2000/svg">
  <path d="M468.4,31.7 C473.7,31.7 477.7,32.7 480.5,34.6 C483.3,36.5 485.3,39.5 486.5,43.6 C487.7,47.7 488.2,53.3 488.2,60.5 L488.2,72.2 L462.5,72.2 L462.5,75.8 C462.5,80.2 462.6,83.5 462.9,85.7 C463.2,87.9 463.7,89.5 464.5,90.5 C465.3,91.5 466.6,92 468.3,92 C470.6,92 472.2,91.1 473,89.3 C473.9,87.5 474.3,84.5 474.4,80.4 L487.7,81.2 C487.8,81.8 487.8,82.6 487.8,83.6 C487.8,89.9 486.1,94.6 482.6,97.7 C479.1,100.8 474.3,102.4 468,102.4 C460.4,102.4 455.1,100 452.1,95.3 C449.1,90.6 447.5,83.2 447.5,73.3 L447.5,61.2 C447.5,51 449.1,43.5 452.2,38.8 C455.4,34.1 460.8,31.7 468.4,31.7 Z M362.4,33 L362.4,83.1 C362.4,86.1 362.7,88.3 363.4,89.6 C364.1,90.9 365.2,91.5 366.7,91.5 C368,91.5 369.3,91.1 370.5,90.3 C371.7,89.5 372.6,88.4 373.2,87.2 L373.2,33 L388.5,33 L388.5,101.3 L376.5,101.3 L375.2,92.9 L374.9,92.9 C371.6,99.2 366.7,102.4 360.2,102.4 C355.7,102.4 352.3,100.9 350.2,97.9 C348,94.9 347,90.3 347,84 L347,33 L362.4,33 Z M283.5,33 L283.5,83.1 C283.5,86.1 283.8,88.3 284.5,89.6 C285.2,90.9 286.3,91.5 287.8,91.5 C289.1,91.5 290.4,91.1 291.6,90.3 C292.8,89.5 293.7,88.4 294.3,87.2 L294.3,33 L309.6,33 L309.6,101.3 L297.6,101.3 L296.3,92.9 L296,92.9 C292.7,99.2 287.8,102.4 281.3,102.4 C276.8,102.4 273.4,100.9 271.3,97.9 C269.1,94.9 268.1,90.3 268.1,84 L268.1,33 L283.5,33 Z M239.1,31.7 C244.1,31.7 248.2,32.7 251.2,34.8 C254.2,36.9 256.5,40.1 257.9,44.5 C259.3,48.9 260,54.8 260,62.1 L260,72 C260,79.3 259.3,85.1 257.9,89.5 C256.5,93.9 254.3,97.1 251.2,99.2 C248.1,101.2 243.9,102.3 238.7,102.3 C233.3,102.4 229.1,101.3 226,99.3 C222.9,97.2 220.7,94 219.4,89.6 C218.1,85.2 217.5,79.4 217.5,72.1 L217.5,62.2 C217.5,54.9 218.2,48.9 219.7,44.5 C221.2,40 223.5,36.8 226.7,34.8 C229.9,32.8 234,31.7 239.1,31.7 Z M412.5,4.3 L412.5,40.3 L412.6,40.3 C414,37.7 415.8,35.6 418.3,34 C420.7,32.4 423.4,31.6 426.2,31.6 C429.9,31.6 432.7,32.6 434.8,34.5 C436.9,36.5 438.4,39.6 439.3,43.9 C440.2,48.2 440.7,54.2 440.7,61.8 L440.7,61.8 L440.7,72.6 C440.7,82.7 439.4,90.2 437,95 C434.5,99.8 430.7,102.2 425.5,102.2 C422.6,102.2 420,101.5 417.6,100.2 C415.3,98.8 413.5,97 412.3,94.7 L412.3,94.7 L412,94.7 L410.4,101.2 L397.7,101.2 L397.7,4.3 L412.5,4.3 Z M351.3,7.8 L351.3,20.2 L336.1,20.2 L336.1,101.3 L321.1,101.3 L321.1,20.2 L305.8,20.2 L305.8,7.8 L351.3,7.8 Z M186.4,7.8 L192.5,36.4 C194.1,43.5 195.2,49.5 196,54.4 L196.4,54.4 C196.9,50.8 198.1,44.9 199.9,36.5 L206.2,7.8 L221.5,7.8 L203.8,70.9 L203.8,101.2 L188.7,101.2 L188.7,71 L188.6,71 L171.1,7.8 L186.4,7.8 Z M238.8,42.3 C236.7,42.3 235.3,43.4 234.4,45.7 C233.5,48 233.1,51.5 233.1,56.4 L233.1,77.7 C233.1,82.7 233.5,86.4 234.3,88.6 C235.1,90.8 236.6,91.9 238.8,91.9 C240.9,91.9 242.4,90.8 243.3,88.6 C244.2,86.4 244.6,82.7 244.6,77.7 L244.6,56.4 C244.6,51.5 244.2,47.9 243.3,45.7 C242.4,43.4 240.9,42.3 238.8,42.3 Z M419.3,42.5 C417.8,42.5 416.5,43.1 415.2,44.3 C413.9,45.5 413,47 412.5,48.9 L412.5,48.9 L412.5,87.7 C413.2,88.9 414,89.8 415.1,90.4 C416.2,91 417.3,91.3 418.6,91.3 C420.2,91.3 421.5,90.7 422.5,89.5 C423.5,88.3 424.2,86.3 424.6,83.5 C425,80.7 425.2,76.8 425.2,71.8 L425.2,71.8 L425.2,62.9 C425.2,57.5 425,53.4 424.7,50.5 C424.3,47.6 423.8,45.5 422.9,44.3 C422.1,43.1 420.9,42.5 419.3,42.5 Z M468.1,42 C466.4,42.1 465.2,42.6 464.5,43.5 C463.7,44.5 463.2,46 462.9,48.2 C462.612,50.312 462.50832,53.43776 462.500486,57.6657536 L462.5,63.1 L473.7,63.1 L473.7,58.2 C473.7,53.8 473.6,50.5 473.3,48.2 C473,45.9 472.5,44.3 471.7,43.4 C470.9,42.5 469.7,42 468.1,42 Z" fill="#282828"></path>
  <path d="M77.9291865,8.92e-05 C80.6890596,0.0029701 126.863,0.0990001 138.6,3.3000001 C145.3,5.1000001 150.6,10.4000001 152.4,17.1000001 C155.601,28.9340001 155.79112,53.0937901 155.799646,54.5327269 L155.799788,54.7194433 C155.79472,56.6107201 155.668,80.4840001 152.5,92.1000001 C150.7,98.8000001 145.4,104.1 138.7,105.9 C127.326,109.002 83.6122396,109.18812 78.4075348,109.199287 L77.3924644,109.199287 C72.1877596,109.18812 28.4739996,109.002 17.0999996,105.9 C10.3999996,104.1 5.0999996,98.8000001 3.2999996,92.1000001 C0.1649996,80.5100001 0.0082496,57.0972501 0.0004121,54.7849501 L0.0003996,54.4150626 C0.0079996,52.1030001 0.1599996,28.6950001 3.1999996,17.2000001 C4.9999996,10.5000001 10.2999996,5.2000001 16.9999996,3.4000001 C29.0999996,0.1000001 77.7999996,9.99999957e-08 77.7999996,9.99999957e-08 Z M62.2999996,31.2000001 L62.2999996,78.0000001 L102.7,54.6000001 L62.2999996,31.2000001 Z" fill="#FF0000"></path>
</svg>', 'SERVICE_YOUTUBE', '2020-08-20 15:17:53.592+00', NULL, '2020-08-20 15:17:53.592+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('3cfb2a17-6a3b-495e-be1d-e9167caeef1c', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Service YouTube Music', '<svg viewBox="0 0 77 20" xmlns="http://www.w3.org/2000/svg">
  <path d="M14.3663873,0.217268548 C15.5334024,0.220491124 23.197,0.262384615 25.225,0.807 C26.4409978,1.13618446 27.3897178,2.08795254 27.715,3.305 C28.2544054,5.3302973 28.3006742,9.37542805 28.3046311,10.0180806 L28.3046855,10.1919375 C28.3011213,10.834721 28.2571622,14.8806216 27.715,16.905 C27.3895386,18.1223008 26.4403827,19.0741239 25.224,19.403 C23.2391538,19.9362692 15.8502637,19.9875451 14.4476743,19.9924755 L13.9863248,19.9924746 C12.5837271,19.9875359 5.19475,19.9361731 3.209,19.402 C1.99325614,19.0729946 1.04459116,18.1216627 0.719,16.905 C0.176837838,14.8806216 0.132878744,10.834721 0.129314493,10.1919375 L0.129314493,10.0180444 C0.132878744,9.37513002 0.176837838,5.32845946 0.719,3.305 C1.04446138,2.08769917 1.99361727,1.13587605 3.21,0.807 C5.238,0.262384615 12.9007456,0.220491124 14.0676295,0.217268548 Z M11.397,5.867 L11.397,14.344 L18.717,10.107 L11.397,5.867 Z" fill="#FF0000"></path>
  <path d="M40.699,7.888 C40.195,10.453 39.813,13.586 39.611,14.877 L39.469,14.877 C39.309,13.544 38.924,10.433 38.403,7.907 L37.113,1.627 L33.184,1.627 L33.184,18.577 L35.622,18.577 L35.622,4.605 L35.863,5.909 L38.34,18.574 L40.778,18.574 L43.215,5.91 L43.477,4.599 L43.477,18.576 L45.915,18.576 L45.915,1.627 L41.946,1.627 L40.7,7.888 L40.699,7.888 Z M52.504,16.03 C52.281,16.495 51.799,16.819 51.314,16.819 C50.75,16.819 50.528,16.374 50.528,15.284 L50.528,6.193 L47.747,6.193 L47.747,15.444 C47.747,17.728 48.491,18.777 50.145,18.777 C51.272,18.777 52.179,18.272 52.805,17.06 L52.865,17.06 L53.107,18.574 L55.282,18.574 L55.282,6.191 L52.502,6.191 L52.502,16.031 L52.504,16.031 L52.504,16.03 Z M60.663,11.081 C59.756,10.414 59.193,9.97 59.193,9 C59.193,8.314 59.515,7.93 60.28,7.93 C61.067,7.93 61.329,8.477 61.347,10.335 L63.685,10.235 C63.865,7.225 62.88,5.972 60.32,5.972 C57.943,5.972 56.774,7.042 56.774,9.244 C56.774,11.244 57.741,12.154 59.311,13.344 C60.661,14.395 61.447,14.981 61.447,15.828 C61.447,16.474 61.043,16.918 60.338,16.918 C59.513,16.918 59.028,16.13 59.151,14.758 L56.794,14.798 C56.433,17.363 57.46,18.858 60.199,18.858 C62.597,18.858 63.845003,17.747 63.845003,15.526 C63.847,13.505 62.838,12.698 60.663,11.081 L60.663,11.081 Z M65.378,6.193 L68.038,6.193 L68.038,18.577 L65.378,18.577 L65.378,6.193 Z M66.728,1.305 C65.7,1.305 65.218,1.688 65.218,3.021 C65.218,4.395 65.7,4.737 66.728,4.737 C67.776,4.737 68.238,4.393 68.238,3.021 C68.238,1.749 67.776,1.305 66.728,1.305 Z M76.981,14.112 L74.544,13.991 C74.544,16.172 74.303,16.879 73.477,16.879 C72.651,16.879 72.51,16.091 72.51,13.526 L72.51,11.12 C72.51,8.636 72.67,7.848 73.498,7.848 C74.263,7.848 74.465,8.594 74.465,10.899 L76.882,10.739 C77.042,8.819 76.801,7.506 76.056,6.759 C75.511,6.213 74.686,5.952 73.537,5.952 C70.837,5.952 69.729,7.406 69.729,11.487 L69.729,13.225 C69.729,17.427 70.675,18.78 73.435,18.78 C74.605,18.78 75.409,18.539 75.954,18.013 C76.74,17.28 77.042,16.029 76.981,14.111 L76.981,14.112 Z" fill="#000000"></path>
</svg>', 'SERVICE_YOUTUBE_MUSIC', '2020-08-20 15:18:11.406+00', NULL, '2020-08-20 15:18:11.406+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('f1546355-0c8d-41f9-ac4e-13f5190b0652', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Snapchat', '<svg viewBox="0 0 448 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zm-6.5 314.9c-3.5 8.1-18.1 14-44.8 18.2-1.4 1.9-2.5 9.8-4.3 15.9-1.1 3.7-3.7 5.9-8.1 5.9h-.2c-6.2 0-12.8-2.9-25.8-2.9-17.6 0-23.7 4-37.4 13.7-14.5 10.3-28.4 19.1-49.2 18.2-21 1.6-38.6-11.2-48.5-18.2-13.8-9.7-19.8-13.7-37.4-13.7-12.5 0-20.4 3.1-25.8 3.1-5.4 0-7.5-3.3-8.3-6-1.8-6.1-2.9-14.1-4.3-16-13.8-2.1-44.8-7.5-45.5-21.4-.2-3.6 2.3-6.8 5.9-7.4 46.3-7.6 67.1-55.1 68-57.1 0-.1.1-.2.2-.3 2.5-5 3-9.2 1.6-12.5-3.4-7.9-17.9-10.7-24-13.2-15.8-6.2-18-13.4-17-18.3 1.6-8.5 14.4-13.8 21.9-10.3 5.9 2.8 11.2 4.2 15.7 4.2 3.3 0 5.5-.8 6.6-1.4-1.4-23.9-4.7-58 3.8-77.1C159.1 100 206.7 96 220.7 96c.6 0 6.1-.1 6.7-.1 34.7 0 68 17.8 84.3 54.3 8.5 19.1 5.2 53.1 3.8 77.1 1.1.6 2.9 1.3 5.7 1.4 4.3-.2 9.2-1.6 14.7-4.2 4-1.9 9.6-1.6 13.6 0 6.3 2.3 10.3 6.8 10.4 11.9.1 6.5-5.7 12.1-17.2 16.6-1.4.6-3.1 1.1-4.9 1.7-6.5 2.1-16.4 5.2-19 11.5-1.4 3.3-.8 7.5 1.6 12.5.1.1.1.2.2.3.9 2 21.7 49.5 68 57.1 4 1 7.1 5.5 4.9 10.8z" fill="currentColor"></path>
</svg>', 'SNAPCHAT', '2020-08-20 15:18:27.792+00', NULL, '2020-08-20 15:18:27.792+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('5e0626c5-7d2c-4f0f-b058-ae4e8c14add2', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'SoundCloud', '<svg viewBox="0 0 640 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M111.4 256.3l5.8 65-5.8 68.3c-.3 2.5-2.2 4.4-4.4 4.4s-4.2-1.9-4.2-4.4l-5.6-68.3 5.6-65c0-2.2 1.9-4.2 4.2-4.2 2.2 0 4.1 2 4.4 4.2zm21.4-45.6c-2.8 0-4.7 2.2-5 5l-5 105.6 5 68.3c.3 2.8 2.2 5 5 5 2.5 0 4.7-2.2 4.7-5l5.8-68.3-5.8-105.6c0-2.8-2.2-5-4.7-5zm25.5-24.1c-3.1 0-5.3 2.2-5.6 5.3l-4.4 130 4.4 67.8c.3 3.1 2.5 5.3 5.6 5.3 2.8 0 5.3-2.2 5.3-5.3l5.3-67.8-5.3-130c0-3.1-2.5-5.3-5.3-5.3zM7.2 283.2c-1.4 0-2.2 1.1-2.5 2.5L0 321.3l4.7 35c.3 1.4 1.1 2.5 2.5 2.5s2.2-1.1 2.5-2.5l5.6-35-5.6-35.6c-.3-1.4-1.1-2.5-2.5-2.5zm23.6-21.9c-1.4 0-2.5 1.1-2.5 2.5l-6.4 57.5 6.4 56.1c0 1.7 1.1 2.8 2.5 2.8s2.5-1.1 2.8-2.5l7.2-56.4-7.2-57.5c-.3-1.4-1.4-2.5-2.8-2.5zm25.3-11.4c-1.7 0-3.1 1.4-3.3 3.3L47 321.3l5.8 65.8c.3 1.7 1.7 3.1 3.3 3.1 1.7 0 3.1-1.4 3.1-3.1l6.9-65.8-6.9-68.1c0-1.9-1.4-3.3-3.1-3.3zm25.3-2.2c-1.9 0-3.6 1.4-3.6 3.6l-5.8 70 5.8 67.8c0 2.2 1.7 3.6 3.6 3.6s3.6-1.4 3.9-3.6l6.4-67.8-6.4-70c-.3-2.2-2-3.6-3.9-3.6zm241.4-110.9c-1.1-.8-2.8-1.4-4.2-1.4-2.2 0-4.2.8-5.6 1.9-1.9 1.7-3.1 4.2-3.3 6.7v.8l-3.3 176.7 1.7 32.5 1.7 31.7c.3 4.7 4.2 8.6 8.9 8.6s8.6-3.9 8.6-8.6l3.9-64.2-3.9-177.5c-.4-3-2-5.8-4.5-7.2zm-26.7 15.3c-1.4-.8-2.8-1.4-4.4-1.4s-3.1.6-4.4 1.4c-2.2 1.4-3.6 3.9-3.6 6.7l-.3 1.7-2.8 160.8s0 .3 3.1 65.6v.3c0 1.7.6 3.3 1.7 4.7 1.7 1.9 3.9 3.1 6.4 3.1 2.2 0 4.2-1.1 5.6-2.5 1.7-1.4 2.5-3.3 2.5-5.6l.3-6.7 3.1-58.6-3.3-162.8c-.3-2.8-1.7-5.3-3.9-6.7zm-111.4 22.5c-3.1 0-5.8 2.8-5.8 6.1l-4.4 140.6 4.4 67.2c.3 3.3 2.8 5.8 5.8 5.8 3.3 0 5.8-2.5 6.1-5.8l5-67.2-5-140.6c-.2-3.3-2.7-6.1-6.1-6.1zm376.7 62.8c-10.8 0-21.1 2.2-30.6 6.1-6.4-70.8-65.8-126.4-138.3-126.4-17.8 0-35 3.3-50.3 9.4-6.1 2.2-7.8 4.4-7.8 9.2v249.7c0 5 3.9 8.6 8.6 9.2h218.3c43.3 0 78.6-35 78.6-78.3.1-43.6-35.2-78.9-78.5-78.9zm-296.7-60.3c-4.2 0-7.5 3.3-7.8 7.8l-3.3 136.7 3.3 65.6c.3 4.2 3.6 7.5 7.8 7.5 4.2 0 7.5-3.3 7.5-7.5l3.9-65.6-3.9-136.7c-.3-4.5-3.3-7.8-7.5-7.8zm-53.6-7.8c-3.3 0-6.4 3.1-6.4 6.7l-3.9 145.3 3.9 66.9c.3 3.6 3.1 6.4 6.4 6.4 3.6 0 6.4-2.8 6.7-6.4l4.4-66.9-4.4-145.3c-.3-3.6-3.1-6.7-6.7-6.7zm26.7 3.4c-3.9 0-6.9 3.1-6.9 6.9L227 321.3l3.9 66.4c.3 3.9 3.1 6.9 6.9 6.9s6.9-3.1 6.9-6.9l4.2-66.4-4.2-141.7c0-3.9-3-6.9-6.9-6.9z" fill="currentColor"></path>
</svg>', 'SOUNDCLOUD', '2020-08-20 15:18:43.149+00', NULL, '2020-08-20 15:18:43.149+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('0a28da7b-1b43-4b78-854b-5cb2ddb2892c', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Spotify', '<svg viewBox="0 0 496 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M248 8C111.1 8 0 119.1 0 256s111.1 248 248 248 248-111.1 248-248S384.9 8 248 8zm100.7 364.9c-4.2 0-6.8-1.3-10.7-3.6-62.4-37.6-135-39.2-206.7-24.5-3.9 1-9 2.6-11.9 2.6-9.7 0-15.8-7.7-15.8-15.8 0-10.3 6.1-15.2 13.6-16.8 81.9-18.1 165.6-16.5 237 26.2 6.1 3.9 9.7 7.4 9.7 16.5s-7.1 15.4-15.2 15.4zm26.9-65.6c-5.2 0-8.7-2.3-12.3-4.2-62.5-37-155.7-51.9-238.6-29.4-4.8 1.3-7.4 2.6-11.9 2.6-10.7 0-19.4-8.7-19.4-19.4s5.2-17.8 15.5-20.7c27.8-7.8 56.2-13.6 97.8-13.6 64.9 0 127.6 16.1 177 45.5 8.1 4.8 11.3 11 11.3 19.7-.1 10.8-8.5 19.5-19.4 19.5zm31-76.2c-5.2 0-8.4-1.3-12.9-3.9-71.2-42.5-198.5-52.7-280.9-29.7-3.6 1-8.1 2.6-12.9 2.6-13.2 0-23.3-10.3-23.3-23.6 0-13.6 8.4-21.3 17.4-23.9 35.2-10.3 74.6-15.2 117.5-15.2 73 0 149.5 15.2 205.4 47.8 7.8 4.5 12.9 10.7 12.9 22.6 0 13.6-11 23.3-23.2 23.3z" fill="currentColor"></path>
</svg>', 'SPOTIFY', '2020-08-20 15:19:03.106+00', NULL, '2020-08-20 15:19:03.106+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('ccaca970-24fa-4a7d-9a41-b9bd7692974d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Tidal', '<svg viewBox="0 0 38 26" xmlns="http://www.w3.org/2000/svg">
  <path d="M18.918532,12.61 L25.2238654,18.9166667 L18.918532,25.2233334 L12.6118653,18.9166667 L18.918532,12.61 Z M6.30533768,0 L12.6120044,6.30666668 L6.30533768,12.612 L4.33500001e-06,6.30666668 L6.30533768,0 Z M31.529731,0 L37.8350644,6.30666668 L31.529731,12.612 L25.2230643,6.30666668 L31.529731,0 Z M18.918532,0 L25.2238654,6.30666668 L18.918532,12.6106667 L12.6120044,6.30666668 L18.918532,0 Z" fill="currentColor"></path>
</svg>', 'TIDAL', '2020-08-20 15:19:14.359+00', NULL, '2020-08-20 15:19:14.359+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('bf8c915e-799a-49d4-aaa3-95c34c74bf23', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'TikTok', '<svg viewBox="0 0 448 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M448,209.91a210.06,210.06,0,0,1-122.77-39.25V349.38A162.55,162.55,0,1,1,185,188.31V278.2a74.62,74.62,0,1,0,52.23,71.18V0l88,0a121.18,121.18,0,0,0,1.86,22.17h0A122.18,122.18,0,0,0,381,102.39a121.43,121.43,0,0,0,67,20.14Z" fill="currentColor"></path>
</svg>', 'TIKTOK', '2020-08-20 15:19:26.979+00', NULL, '2020-08-20 15:19:26.979+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('71ec2b61-435a-4f8d-a917-344269f1525f', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Times', '<svg viewBox="0 0 320 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M193.94 256L296.5 153.44l21.15-21.15c3.12-3.12 3.12-8.19 0-11.31l-22.63-22.63c-3.12-3.12-8.19-3.12-11.31 0L160 222.06 36.29 98.34c-3.12-3.12-8.19-3.12-11.31 0L2.34 120.97c-3.12 3.12-3.12 8.19 0 11.31L126.06 256 2.34 379.71c-3.12 3.12-3.12 8.19 0 11.31l22.63 22.63c3.12 3.12 8.19 3.12 11.31 0L160 289.94 262.56 392.5l21.15 21.15c3.12 3.12 8.19 3.12 11.31 0l22.63-22.63c3.12-3.12 3.12-8.19 0-11.31L193.94 256z" fill="currentColor"></path>
</svg>', 'TIMES', '2020-08-20 15:19:48.248+00', NULL, '2020-08-20 15:19:48.248+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('43dfe3aa-7661-450d-8834-63a70d5013a5', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Twitter', '<svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z" fill="currentColor"></path>
</svg>', 'TWITTER', '2020-08-20 15:20:06.947+00', NULL, '2020-08-20 15:20:06.947+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('4db6a13d-b447-4a43-9978-ee4904ec65b7', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'YouTube', '<svg viewBox="0 0 576 512" xmlns="http://www.w3.org/2000/svg">
  <path d="M549.655 124.083c-6.281-23.65-24.787-42.276-48.284-48.597C458.781 64 288 64 288 64S117.22 64 74.629 75.486c-23.497 6.322-42.003 24.947-48.284 48.597-11.412 42.867-11.412 132.305-11.412 132.305s0 89.438 11.412 132.305c6.281 23.65 24.787 41.5 48.284 47.821C117.22 448 288 448 288 448s170.78 0 213.371-11.486c23.497-6.321 42.003-24.171 48.284-47.821 11.412-42.867 11.412-132.305 11.412-132.305s0-89.438-11.412-132.305zm-317.51 213.508V175.185l142.739 81.205-142.739 81.201z" fill="currentColor"></path>
</svg>', 'YOUTUBE', '2020-08-20 15:20:21.552+00', NULL, '2020-08-20 15:20:21.552+00');
INSERT INTO public.icons (id, project_id, name, content, variable_name, created_at, deleted_at, updated_at) VALUES ('cc59a704-fd7c-4999-9f73-1efd38387c93', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'YouTube Music', '<svg viewBox="0 0 176 176" xmlns="http://www.w3.org/2000/svg">
  <path d="M88,0 C136.601058,0 176,39.398942 176,88 C176,136.601058 136.601058,176 88,176 C39.398942,176 0,136.601058 0,88 C0,39.398942 39.398942,0 88,0 Z M88,42 C62.6,42 42,62.6 42,88 C42,113.4 62.6,134 88,134 C113.4,134 134,113.4 134,88 C134,62.6 113.4,42 88,42 Z M88,46 C111.1,46 130,64.8 130,88 C130,111.2 111.2,130 88,130 C64.8,130 46,111.2 46,88 C46,64.8 64.9,46 88,46 Z M72,65 L72,111 L111,87 L72,65 Z" fill="currentColor"></path>
</svg>', 'YOUTUBE_MUSIC', '2020-08-20 15:20:39.776+00', NULL, '2020-08-20 15:20:39.776+00');


--
-- Data for Name: layout_variables; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--



--
-- Data for Name: layouts; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.layouts (id, project_id, name, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at) VALUES ('8abf93a2-4427-4f4e-aebe-0994ab6ec63d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Error', '<div class="error-layout">
  <span class="error-layout__bg"></span>
  <header class="error-layout__header">
    <div class="error-layout__header-logo">
      <a href="{{ link(''/'') }}" aria-label="Home">
        {{ ICON_LOGO }}
      </a>
    </div>
    <button class="error-layout__header-toggler" aria-label="Open menu">
      {{ ICON_BARS }}
    </button>
    <div class="error-layout__header-menu">
      <div class="error-layout__close-container">
        <button class="error-layout__header-close" aria-label="Close menu">
          {{ ICON_TIMES }}
        </button>
      </div>
      <div class="error-layout__header-link">
        <a href="{{ link(''/music'') }}" aria-label="Music">
          MUSIC
        </a>
      </div>
      <div class="error-layout__header-link">
        <a aria-label="Video (soon)">
          VIDEO
          <span class="error-layout__link-badge">soon</span>
        </a>
      </div>
      <div class="error-layout__header-link">
        <a aria-label="Store (soon)">
          STORE
          <span class="error-layout__link-badge">soon</span>
        </a>
      </div>
      <div class="error-layout__header-link">
        <a aria-label="Tour (soon)">
          TOUR
          <span class="error-layout__link-badge">soon</span>
        </a>
      </div>
    </div>
    <div class="error-layout__header-overlay"></div>
  </header>
  <main class="error-layout__main">
    {{ PAGE_CONTENT }}
  </main>
  <footer class="error-layout__footer">
    <div class="error-layout__footer-links">
      <div class="error-layout__footer-links--social">
        <div class="error-layout__footer-link">
          <a href="https://www.facebook.com/aarondelasy/" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Facebook">
            {{ ICON_FACEBOOK }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://www.instagram.com/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Instagram">
            {{ ICON_INSTAGRAM }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://www.snapchat.com/add/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Snapchat">
            {{ ICON_SNAPCHAT }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://www.tiktok.com/@aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on TikTok">
            {{ ICON_TIKTOK }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://twitter.com/aarondelasy/" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Twitter">
            {{ ICON_TWITTER }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://www.youtube.com/user/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on YouTube">
            {{ ICON_YOUTUBE }}
          </a>
        </div>
      </div>
      <div class="error-layout__footer-links--audio">
        <div class="error-layout__footer-link">
          <a href="https://open.spotify.com/artist/5iLgnn7dak5qB89a0VWvI8" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Spotify">
            {{ ICON_SPOTIFY }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://soundcloud.com/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on SoundCloud">
            {{ ICON_SOUNDCLOUD }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://music.apple.com/artist/1519983003" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Apple Music">
            {{ ICON_APPLE_MUSIC }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://music.youtube.com/channel/UCtwWt7rKwkgVWX6BOEBNXtw" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on YouTube Music">
            {{ ICON_YOUTUBE_MUSIC }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://music.amazon.com/artists/B08BPD27TN" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Amazon Music">
            {{ ICON_AMAZON_MUSIC }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://listen.tidal.com/artist/20137232" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Tidal">
            {{ ICON_TIDAL }}
          </a>
        </div>
        <div class="error-layout__footer-link">
          <a href="https://genius.com/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Genius">
            {{ ICON_GENIUS }}
          </a>
        </div>
      </div>
      <div class="error-layout__footer-email">
        <a href="mailto:mgmt@delasy.com" rel="noopener noreferrer" target="_blank">
          mgmt@delasy.com
        </a>
      </div>
    </div>
    <div class="error-layout__footer-copyright">
      <p>Copyright &copy; 2020 Aaron Delasy</p>
    </div>
  </footer>
</div>', '<meta name="robots" content="noindex, nofollow" />', 'function mapElementsByClass (classNames, callback) {
  if (typeof classNames === ''string'') {
    classNames = [classNames]
  }

  for (var i = 0; i < classNames.length; i++) {
    var elements = document.getElementsByClassName(classNames[i])

    for (var j = 0; j < elements.length; j++) {
      callback(elements[j], j)
    }
  }
}

mapElementsByClass(''default-layout__header-toggler'', function (element) {
  element.addEventListener(''click'', function () {
    mapElementsByClass(''default-layout__header-menu'', function (element) {
      element.style.left = ''0''
    })

    mapElementsByClass(''default-layout__header-overlay'', function (element) {
      element.style.display = ''block''
    })
  })
})

mapElementsByClass([''default-layout__header-close'', ''default-layout__header-overlay''], function (element) {
  element.addEventListener(''click'', function () {
    mapElementsByClass(''default-layout__header-menu'', function (element) {
      element.style.left = ''''
    })

    mapElementsByClass(''default-layout__header-overlay'', function (element) {
      element.style.display = ''''
    })
  })
})', '.error-layout {
  background-color: var(--color-black);
  display: grid;
  grid: 75px auto 75px / 1fr;
  min-height: 100vh;
  position: relative;
}

.error-layout__bg {
  background-color: var(--color-black);
  background-image: url(''{{ FEATURED_ALBUM_IMAGE }}'');
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  bottom: 0;
  filter: blur(40px);
  left: 0;
  opacity: 0.25;
  position: absolute;
  right: 0;
  top: 0;
}

.error-layout__header {
  display: inline-grid;
  grid: 1fr / max-content auto;
  justify-content: space-between;
  position: relative;
}

.error-layout__header-logo > a {
  align-items: center;
  color: var(--color-white);
  display: inline-grid;
  height: 100%;
  justify-content: center;
  position: relative;
  text-decoration: none;
}

.error-layout__header-logo > a > svg {
  height: 100%;
}

.error-layout__header-link {
  display: inline-grid;
  height: 100%;
}

.error-layout__header-link > a {
  align-items: center;
  color: var(--color-white);
  display: inline-grid;
  font-size: 20px;
  font-weight: 300;
  height: 100%;
  letter-spacing: 2px;
  padding: 0 25px;
  position: relative;
  text-decoration: none;
}

.error-layout__header-link > a[href]:hover {
  color: rgba(var(--color-white-rgb), 0.8);
}

.error-layout__link-badge {
  background-color: var(--color-white);
  color: var(--color-black);
  font-size: 12px;
  font-weight: 300;
  left: 50%;
  letter-spacing: 1px;
  padding: 3px 8px 5px;
  position: absolute;
  top: calc(100% - 25px + 4px);
  transform: translateX(-50%);
}

.error-layout__header-toggler, .error-layout__close-container {
  display: none;
}

.error-layout__header-overlay {
  background-color: rgba(var(--color-black-rgb), 0.5);
  display: none;
  height: 100vh;
  left: 0;
  position: fixed;
  top: 0;
  width: 100vw;
  z-index: 2147483646;
}

.error-layout__main {
  align-items: center;
  display: inline-grid;
  justify-items: center;
  padding: 25px;
  position: relative;
}

.error-layout__footer {
  display: inline-grid;
  grid: 1fr / auto max-content;
  justify-content: space-between;
  position: relative;
}

.error-layout__footer-links {
  display: inline-grid;
  gap: 48px;
  grid: 1fr / repeat(3, max-content);
  padding-left: 25px;
}

.error-layout__footer-links--audio, .error-layout__footer-links--social, .error-layout__footer-email {
  align-items: center;
  display: inline-grid;
  gap: 16px;
}

.error-layout__footer-links--social {
  grid: 1fr / repeat(6, 30px);
}

.error-layout__footer-links--audio {
  grid: 1fr / repeat(7, 30px);
}

.error-layout__footer-link {
  display: inline-grid;
}

.error-layout__footer-link > a {
  align-items: center;
  color: var(--color-white);
  display: inline-grid;
  height: 30px;
  justify-items: center;
  text-decoration: none;
}

.error-layout__footer-link > a[href]:hover {
  color: rgba(var(--color-white-rgb), 0.8);
}

.error-layout__footer-link > a > svg {
  max-height: 100%;
  max-width: 100%;
}

.error-layout__footer-email > a {
  color: var(--color-white);
  font-size: 12px;
  font-weight: 300;
  letter-spacing: 1px;
  text-decoration: none;
}

.error-layout__footer-email > a:hover {
  text-decoration: underline;
}

.error-layout__footer-copyright {
  align-items: center;
  display: inline-grid;
  justify-items: center;
  padding-right: 25px;
}

.error-layout__footer-copyright > p {
  color: var(--color-white);
  font-size: 12px;
  font-weight: 300;
  letter-spacing: 1px;
}

@media (max-width: 575.98px) {
  .error-layout {
    grid: 50px auto 200px / 1fr;
  }

  .error-layout__header {
    grid: 1fr / auto max-content;
  }

  .error-layout__header-close, .error-layout__header-toggler {
    background-color: transparent;
    border: 0;
    border-radius: 0;
    color: var(--color-white);
    display: inline-grid;
    height: 50px;
    outline: none;
    padding: 10px;
    width: 50px;
  }

  .error-layout__header-close > svg, .error-layout__header-toggler > svg {
    display: inline-grid;
    max-height: 100%;
    max-width: 100%;
  }

  .error-layout__close-container {
    display: inline-grid;
    justify-items: end;
  }

  .error-layout__header-menu {
    align-content: start;
    background-color: var(--color-black);
    display: grid;
    grid: repeat(5, 50px) / 100%;
    height: 100vh;
    left: -80vw;
    max-width: 80vw;
    position: fixed;
    top: 0;
    transition: left 100ms ease-in;
    width: 80vw;
    z-index: 2147483647;
  }

  .error-layout__header-link > a {
    padding: 0 15px;
    width: 100%;
  }

  .error-layout__link-badge {
    left: auto;
    right: 15px;
    top: 50%;
    transform: translateY(-50%);
  }

  .error-layout__main {
    padding: 15px;
  }

  .error-layout__footer {
    grid: 3fr 1fr / 1fr;
  }

  .error-layout__footer-links {
    gap: 0;
    grid: repeat(3, 1fr) / 1fr;
    justify-items: center;
    padding-left: 0;
  }

  .error-layout__footer-copyright {
    padding-right: 0;
  }
}', '2020-08-21 20:17:36.446+00', NULL, '2020-08-28 11:33:49.91+00');
INSERT INTO public.layouts (id, project_id, name, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at) VALUES ('8a49743e-e132-4364-948e-912841a16642', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Album', '<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-ML2F732" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<div class="album-layout">
  <span class="album-layout__bg" style="background-image: url(''{{ SEO_IMAGE }}'')"></span>
  <main class="album-layout__main">
    <h1 class="album-layout__title">
      <span class="album-layout__title-name">{{ ALBUM_NAME }}</span>
      <span class="album-layout__title-author">Aaron Delasy{{ if ALBUM_EXPLICIT === '''' }}{{ ICON_EXPLICIT }}{{ endif }}</span>
    </h1>
    <hr class="album-layout__hr" />
    {{ PAGE_CONTENT }}
    <div class="album-layout__meta{{ if ALBUM_NO_SERVICES === '''' }} album-layout__meta--noservices{{ endif }}">
      <div class="album-layout__cover-container">
        <span class="album-layout__cover" style="background-image: url(''{{ SEO_IMAGE }}'')"></span>
        {{ if ALBUM_RELEASE_DATE }}
          <span class="album-layout__cover-releasedate">Release {{ ALBUM_RELEASE_DATE }}</span>
        {{ endif }}
        <div class="album-layout__cover-home">
          <a href="{{ link(''/'') }}" rel="noopener noreferrer" target="_blank">Open Home Page</a>
        </div>
      </div>
      <div class="album-layout__services">
        {{ if ALBUM_NO_SERVICES !== '''' }}
          {{ if ALBUM_SERVICE_YOUTUBE }}
            <a class="album-layout__service" href="https://youtu.be/{{ ALBUM_SERVICE_YOUTUBE }}" rel="noopener noreferrer" target="_blank" aria-label="Watch on YouTube">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_YOUTUBE }}</div>
              <div class="album-layout__service-action"><p>Watch</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_SPOTIFY }}
            <a class="album-layout__service" href="https://open.spotify.com/album/{{ ALBUM_SERVICE_SPOTIFY }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on Spotify">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_SPOTIFY }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_SOUNDCLOUD }}
            <a class="album-layout__service" href="https://soundcloud.com/aarondelasy/{{ ALBUM_SERVICE_SOUNDCLOUD }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on SoundCloud">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_SOUNDCLOUD }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_APPLE_MUSIC }}
            <a class="album-layout__service" href="https://music.apple.com/album/{{ ALBUM_SERVICE_APPLE_MUSIC }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on Apple Music">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_APPLE_MUSIC }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_ITUNES_STORE }}
            <a class="album-layout__service" href="https://itunes.apple.com/album/{{ ALBUM_SERVICE_ITUNES_STORE }}?app=itunes" rel="noopener noreferrer" target="_blank" aria-label="Download from iTunes Store">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_ITUNES_STORE }}</div>
              <div class="album-layout__service-action"><p>Download</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_PANDORA }}
            <a class="album-layout__service" href="https://pandora.app.link/{{ ALBUM_SERVICE_PANDORA }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on Pandora">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_PANDORA }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_YOUTUBE_MUSIC }}
            <a class="album-layout__service" href="https://music.youtube.com/playlist?list={{ ALBUM_SERVICE_YOUTUBE_MUSIC }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on YouTube Music">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_YOUTUBE_MUSIC }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_GOOGLE_PLAY_MUSIC }}
            <a class="album-layout__service" href="https://play.google.com/music/m/{{ ALBUM_SERVICE_GOOGLE_PLAY_MUSIC }}" rel="noopener noreferrer" target="_blank" aria-label="Download from Google Play Music">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_GOOGLE_PLAY_MUSIC }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_AMAZON_MUSIC }}
            <a class="album-layout__service" href="https://music.amazon.com/albums/{{ ALBUM_SERVICE_AMAZON_MUSIC }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on Amazon Music">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_AMAZON_MUSIC }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_AMAZON }}
            <a class="album-layout__service" href="https://www.amazon.com/dp/{{ ALBUM_SERVICE_AMAZON }}" rel="noopener noreferrer" target="_blank" aria-label="Download from Amazon">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_AMAZON }}</div>
              <div class="album-layout__service-action"><p>Download</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_DEEZER }}
            <a class="album-layout__service" href="https://www.deezer.com/album/{{ ALBUM_SERVICE_DEEZER }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on Deezer">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_DEEZER }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_TIDAL }}
            <a class="album-layout__service" href="https://listen.tidal.com/album/{{ ALBUM_SERVICE_TIDAL }}" rel="noopener noreferrer" target="_blank" aria-label="Listen on Tidal">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_TIDAL }}</div>
              <div class="album-layout__service-action"><p>Listen</p></div>
            </a>
          {{ endif }}
          {{ if ALBUM_SERVICE_GENIUS }}
            <a class="album-layout__service" href="https://genius.com/Aaron-delasy-{{ ALBUM_SERVICE_GENIUS }}-lyrics" rel="noopener noreferrer" target="_blank" aria-label="Read lyrics on Genius">
              <div class="album-layout__service-logo">{{ ICON_SERVICE_GENIUS }}</div>
              <div class="album-layout__service-action"><p>Lyrics</p></div>
            </a>
          {{ endif }}
        {{ endif }}
        <div class="album-layout__services-home">
          <a href="{{ link(''/'') }}" rel="noopener noreferrer" target="_blank">Open Home Page</a>
        </div>
      </div>
    </div>
  </main>
</div>', '<meta name="description" content="{{ SEO_DESCRIPTION || PROJECT_DESCRIPTION }}" />
<meta name="keywords" content="{{ SEO_KEYWORDS || '''' }}" />
<meta name="robots" content="index, follow" />
<meta name="title" content="{{ SEO_TITLE || PAGE_NAME }}" />

<meta property="og:description" content="{{ SEO_DESCRIPTION || PROJECT_DESCRIPTION }}" />
<meta property="og:image" content="{{ SEO_IMAGE || PUBLIC_URL + ''/og.jpg'' }}" />
<meta property="og:locale" content="en_US" />
<meta property="og:site_name" content="{{ PROJECT_NAME }}" />
<meta property="og:title" content="{{ SEO_TITLE || PAGE_NAME }}" />
<meta property="og:type" content="music:album" />
<meta property="og:url" content="{{ PAGE_URL }}" />

<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({''gtm.start'':new Date().getTime(),event:''gtm.js''});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!==''dataLayer''?''&l=''+l:'''';j.async=true;j.src=''https://www.googletagmanager.com/gtm.js?id=''+i+dl;f.parentNode.insertBefore(j,f);})(window,document,''script'',''dataLayer'',''GTM-ML2F732'');</script>', 'function mapElementsByClass (classNames, callback) {
  if (typeof classNames === ''string'') {
    classNames = [classNames]
  }

  for (var i = 0; i < classNames.length; i++) {
    var elements = document.getElementsByClassName(classNames[i])

    for (var j = 0; j < elements.length; j++) {
      callback(elements[j], j)
    }
  }
}

mapElementsByClass(''default-layout__header-toggler'', function (element) {
  element.addEventListener(''click'', function () {
    mapElementsByClass(''default-layout__header-menu'', function (element) {
      element.style.left = ''0''
    })

    mapElementsByClass(''default-layout__header-overlay'', function (element) {
      element.style.display = ''block''
    })
  })
})

mapElementsByClass([''default-layout__header-close'', ''default-layout__header-overlay''], function (element) {
  element.addEventListener(''click'', function () {
    mapElementsByClass(''default-layout__header-menu'', function (element) {
      element.style.left = ''''
    })

    mapElementsByClass(''default-layout__header-overlay'', function (element) {
      element.style.display = ''''
    })
  })
})', '.album-layout {
  align-content: start;
  background-color: var(--color-black);
  display: grid;
  justify-items: center;
  min-height: 100vh;
  position: relative;
}

.album-layout__bg {
  background-color: var(--color-black);
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  bottom: 0;
  filter: blur(40px);
  left: 0;
  opacity: 0.25;
  position: absolute;
  right: 0;
  top: 0;
}

.album-layout__main {
  align-content: start;
  display: inline-grid;
  justify-items: center;
  padding: 25px;
  position: relative;
  width: 750px;
}

.album-layout__title {
  margin-bottom: 25px;
  text-align: center;
}

.album-layout__title-name {
  color: var(--color-white);
  font-size: 28px;
  font-weight: 300;
}

.album-layout__title-name::after {
  content: '' - '';
}

.album-layout__title-author {
  color: var(--color-white);
  font-size: 28px;
  font-weight: 300;
  white-space: nowrap;
}

.album-layout__title-author > svg {
  height: 24px;
  margin-left: 10px;
  vertical-align: baseline;
  width: 24px;
}

.album-layout__hr {
  background-color: var(--color-white);
  border: 0;
  border-radius: 2px;
  height: 4px;
  margin: 0 0 25px;
  width: 50%;
}

.album-layout__meta {
  align-items: start;
  display: inline-grid;
  gap: 50px;
  grid: auto / repeat(2, 1fr);
}

.album-layout__cover-container {
  display: inline-grid;
  gap: 15px;
  position: relative;
}

.album-layout__cover {
  background-color: var(--color-black);
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  border: 10px solid var(--color-white);
  display: inline-grid;
  height: 325px;
  width: 325px;
}

.album-layout__cover-releasedate {
  background-color: var(--color-black);
  color: var(--color-white);
  font-size: 14px;
  font-weight: 300;
  padding: 10px;
  position: absolute;
  right: 10px;
  top: 10px;
}

.album-layout__cover-home, .album-layout__services-home {
  display: inline-grid;
  justify-content: flex-start;
}

.album-layout__cover-home > a, .album-layout__services-home > a {
  color: var(--color-white);
  font-size: 16px;
  font-weight: 300;
  text-align: left;
}

.album-layout__cover-home > a[href]:hover, .album-layout__services-home > a[href]:hover {
  color: rgba(var(--color-white-rgb), 0.8);
}

.album-layout__services {
  display: inline-grid;
  gap: 4px;
}

.album-layout__services-home {
  display: none;
}

.album-layout__service {
  display: inline-grid;
  gap: 4px;
  grid: 85px / 200px auto;
  text-decoration: none;
}

.album-layout__service:hover > .album-layout__service-logo, .album-layout__service:hover > .album-layout__service-action {
  background-color: rgba(var(--color-white-rgb), 0.90);
}

.album-layout__service-logo {
  align-items: center;
  background-color: var(--color-white);
  display: inline-grid;
  height: 100%;
  justify-items: center;
  width: 100%;
}

.album-layout__service-logo > svg {
  max-height: 35px;
  max-width: 150px;
}

.album-layout__service-action {
  align-items: center;
  background-color: var(--color-white);
  display: inline-grid;
  justify-items: center;
}

.album-layout__service-action > p {
  color: var(--color-black);
  font-size: 16px;
  font-weight: 400;
  letter-spacing: 1px;
}

@media (max-width: 575.98px) {
  .album-layout__main {
    padding: 15px;
    width: 100%;
  }

  .album-layout__title {
    font-size: 24px;
    margin-bottom: 15px;
  }

  .album-layout__hr {
    margin-bottom: 15px;
  }

  .album-layout__meta {
    gap: 15px;
    grid: repeat(2, max-content) / 1fr;
    width: 100%;
  }

  .album-layout__meta--noservices {
    gap: 4px;
  }

  .album-layout__cover-home {
    display: none;
  }

  .album-layout__cover {
    height: auto;
    padding-top: calc(100% - 10px * 2);
    width: 100%;
  }

  .album-layout__services-home {
    display: inline-grid;
    justify-content: center;
    margin-top: 11px;
  }

  .album-layout__service:hover > .album-layout__service-logo, .album-layout__service:hover > .album-layout__service-action {
    background-color: var(--color-white);
  }
}', '2020-08-21 23:31:58.843+00', NULL, '2020-08-28 10:56:52.079+00');
INSERT INTO public.layouts (id, project_id, name, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at) VALUES ('d45495af-8d55-4191-918b-772ff545672b', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Default', '<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-ML2F732" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<div class="default-layout">
  <span class="default-layout__bg"></span>
  <header class="default-layout__header">
    <div class="default-layout__header-logo">
      <a href="{{ link(''/'') }}" aria-label="Home">
        {{ ICON_LOGO }}
      </a>
    </div>
    <button class="default-layout__header-toggler" aria-label="Open menu">
      {{ ICON_BARS }}
    </button>
    <div class="default-layout__header-menu">
      <div class="default-layout__close-container">
        <button class="default-layout__header-close" aria-label="Close menu">
          {{ ICON_TIMES }}
        </button>
      </div>
      <div class="default-layout__header-link">
        <a href="{{ link(''/music'') }}" aria-label="Music">
          MUSIC
        </a>
      </div>
      <div class="default-layout__header-link">
        <a aria-label="Video (soon)">
          VIDEO
          <span class="default-layout__link-badge">soon</span>
        </a>
      </div>
      <div class="default-layout__header-link">
        <a aria-label="Store (soon)">
          STORE
          <span class="default-layout__link-badge">soon</span>
        </a>
      </div>
      <div class="default-layout__header-link">
        <a aria-label="Tour (soon)">
          TOUR
          <span class="default-layout__link-badge">soon</span>
        </a>
      </div>
    </div>
    <div class="default-layout__header-overlay"></div>
  </header>
  <main class="default-layout__main">
    {{ PAGE_CONTENT }}
  </main>
  <footer class="default-layout__footer">
    <div class="default-layout__footer-links">
      <div class="default-layout__footer-links--social">
        <div class="default-layout__footer-link">
          <a href="https://www.facebook.com/aarondelasy/" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Facebook">
            {{ ICON_FACEBOOK }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://www.instagram.com/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Instagram">
            {{ ICON_INSTAGRAM }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://www.snapchat.com/add/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Snapchat">
            {{ ICON_SNAPCHAT }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://www.tiktok.com/@aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on TikTok">
            {{ ICON_TIKTOK }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://twitter.com/aarondelasy/" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Twitter">
            {{ ICON_TWITTER }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://www.youtube.com/user/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on YouTube">
            {{ ICON_YOUTUBE }}
          </a>
        </div>
      </div>
      <div class="default-layout__footer-links--audio">
        <div class="default-layout__footer-link">
          <a href="https://open.spotify.com/artist/5iLgnn7dak5qB89a0VWvI8" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Spotify">
            {{ ICON_SPOTIFY }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://soundcloud.com/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on SoundCloud">
            {{ ICON_SOUNDCLOUD }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://music.apple.com/artist/1519983003" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Apple Music">
            {{ ICON_APPLE_MUSIC }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://music.youtube.com/channel/UCtwWt7rKwkgVWX6BOEBNXtw" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on YouTube Music">
            {{ ICON_YOUTUBE_MUSIC }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://music.amazon.com/artists/B08BPD27TN" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Amazon Music">
            {{ ICON_AMAZON_MUSIC }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://listen.tidal.com/artist/20137232" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Tidal">
            {{ ICON_TIDAL }}
          </a>
        </div>
        <div class="default-layout__footer-link">
          <a href="https://genius.com/aarondelasy" rel="noopener noreferrer" target="_blank" aria-label="Aaron Delasy on Genius">
            {{ ICON_GENIUS }}
          </a>
        </div>
      </div>
      <div class="default-layout__footer-email">
        <a href="mailto:mgmt@delasy.com" rel="noopener noreferrer" target="_blank">
          mgmt@delasy.com
        </a>
      </div>
    </div>
    <div class="default-layout__footer-copyright">
      <p>Copyright &copy; 2020 Aaron Delasy</p>
    </div>
  </footer>
</div>', '<meta name="description" content="{{ SEO_DESCRIPTION || PROJECT_DESCRIPTION }}" />
<meta name="keywords" content="{{ SEO_KEYWORDS || '''' }}" />
<meta name="robots" content="index, follow" />
<meta name="title" content="{{ SEO_TITLE || PAGE_NAME }}" />

<meta property="og:description" content="{{ SEO_DESCRIPTION || PROJECT_DESCRIPTION }}" />
<meta property="og:image" content="{{ SEO_IMAGE || PUBLIC_URL + ''/og.jpg'' }}" />
<meta property="og:locale" content="en_US" />
<meta property="og:site_name" content="{{ PROJECT_NAME }}" />
<meta property="og:title" content="{{ SEO_TITLE || PAGE_NAME }}" />
<meta property="og:type" content="website" />
<meta property="og:url" content="{{ PAGE_URL }}" />

<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({''gtm.start'':new Date().getTime(),event:''gtm.js''});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!==''dataLayer''?''&l=''+l:'''';j.async=true;j.src=''https://www.googletagmanager.com/gtm.js?id=''+i+dl;f.parentNode.insertBefore(j,f);})(window,document,''script'',''dataLayer'',''GTM-ML2F732'');</script>', 'function mapElementsByClass (classNames, callback) {
  if (typeof classNames === ''string'') {
    classNames = [classNames]
  }

  for (var i = 0; i < classNames.length; i++) {
    var elements = document.getElementsByClassName(classNames[i])

    for (var j = 0; j < elements.length; j++) {
      callback(elements[j], j)
    }
  }
}

mapElementsByClass(''default-layout__header-toggler'', function (element) {
  element.addEventListener(''click'', function () {
    mapElementsByClass(''default-layout__header-menu'', function (element) {
      element.style.left = ''0''
    })

    mapElementsByClass(''default-layout__header-overlay'', function (element) {
      element.style.display = ''block''
    })
  })
})

mapElementsByClass([''default-layout__header-close'', ''default-layout__header-overlay''], function (element) {
  element.addEventListener(''click'', function () {
    mapElementsByClass(''default-layout__header-menu'', function (element) {
      element.style.left = ''''
    })

    mapElementsByClass(''default-layout__header-overlay'', function (element) {
      element.style.display = ''''
    })
  })
})', '.default-layout {
  background-color: var(--color-black);
  display: grid;
  grid: 75px auto 75px / 1fr;
  min-height: 100vh;
  position: relative;
}

.default-layout__bg {
  background-color: var(--color-black);
  background-image: url(''{{ FEATURED_ALBUM_IMAGE }}'');
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  bottom: 0;
  filter: blur(40px);
  left: 0;
  opacity: 0.25;
  position: absolute;
  right: 0;
  top: 0;
}

.default-layout__header {
  display: inline-grid;
  grid: 1fr / max-content auto;
  justify-content: space-between;
  position: relative;
}

.default-layout__header-logo > a {
  align-items: center;
  color: var(--color-white);
  display: inline-grid;
  height: 100%;
  justify-content: center;
  position: relative;
  text-decoration: none;
}

.default-layout__header-logo > a > svg {
  height: 100%;
}

.default-layout__header-link {
  display: inline-grid;
  height: 100%;
}

.default-layout__header-link > a {
  align-items: center;
  color: var(--color-white);
  display: inline-grid;
  font-size: 20px;
  font-weight: 300;
  height: 100%;
  letter-spacing: 2px;
  padding: 0 25px;
  position: relative;
  text-decoration: none;
}

.default-layout__header-link > a[href]:hover {
  color: rgba(var(--color-white-rgb), 0.8);
}

.default-layout__link-badge {
  background-color: var(--color-white);
  color: var(--color-black);
  font-size: 12px;
  font-weight: 300;
  left: 50%;
  letter-spacing: 1px;
  padding: 3px 8px 5px;
  position: absolute;
  top: calc(100% - 25px + 4px);
  transform: translateX(-50%);
}

.default-layout__header-toggler, .default-layout__close-container {
  display: none;
}

.default-layout__header-overlay {
  background-color: rgba(var(--color-black-rgb), 0.5);
  display: none;
  height: 100vh;
  left: 0;
  position: fixed;
  top: 0;
  width: 100vw;
  z-index: 2147483646;
}

.default-layout__main {
  align-items: center;
  display: inline-grid;
  justify-items: center;
  padding: 25px;
  position: relative;
}

.default-layout__footer {
  display: inline-grid;
  grid: 1fr / auto max-content;
  justify-content: space-between;
  position: relative;
}

.default-layout__footer-links {
  display: inline-grid;
  gap: 48px;
  grid: 1fr / repeat(3, max-content);
  padding-left: 25px;
}

.default-layout__footer-links--audio, .default-layout__footer-links--social, .default-layout__footer-email {
  align-items: center;
  display: inline-grid;
  gap: 16px;
}

.default-layout__footer-links--social {
  grid: 1fr / repeat(6, 30px);
}

.default-layout__footer-links--audio {
  grid: 1fr / repeat(7, 30px);
}

.default-layout__footer-link {
  display: inline-grid;
}

.default-layout__footer-link > a {
  align-items: center;
  color: var(--color-white);
  display: inline-grid;
  height: 30px;
  justify-items: center;
  text-decoration: none;
}

.default-layout__footer-link > a[href]:hover {
  color: rgba(var(--color-white-rgb), 0.8);
}

.default-layout__footer-link > a > svg {
  max-height: 100%;
  max-width: 100%;
}

.default-layout__footer-email > a {
  color: var(--color-white);
  font-size: 12px;
  font-weight: 300;
  letter-spacing: 1px;
  text-decoration: none;
}

.default-layout__footer-email > a:hover {
  text-decoration: underline;
}

.default-layout__footer-copyright {
  align-items: center;
  display: inline-grid;
  justify-items: center;
  padding-right: 25px;
}

.default-layout__footer-copyright > p {
  color: var(--color-white);
  font-size: 12px;
  font-weight: 300;
  letter-spacing: 1px;
}

@media (max-width: 575.98px) {
  .default-layout {
    grid: 50px auto 200px / 1fr;
  }

  .default-layout__header {
    grid: 1fr / auto max-content;
  }

  .default-layout__header-close, .default-layout__header-toggler {
    background-color: transparent;
    border: 0;
    border-radius: 0;
    color: var(--color-white);
    display: inline-grid;
    height: 50px;
    outline: none;
    padding: 10px;
    width: 50px;
  }

  .default-layout__header-close > svg, .default-layout__header-toggler > svg {
    display: inline-grid;
    max-height: 100%;
    max-width: 100%;
  }

  .default-layout__close-container {
    display: inline-grid;
    justify-items: end;
  }

  .default-layout__header-menu {
    align-content: start;
    background-color: var(--color-black);
    display: grid;
    grid: repeat(5, 50px) / 100%;
    height: 100vh;
    left: -80vw;
    max-width: 80vw;
    position: fixed;
    top: 0;
    transition: left 100ms ease-in;
    width: 80vw;
    z-index: 2147483647;
  }

  .default-layout__header-link > a {
    padding: 0 15px;
    width: 100%;
  }

  .default-layout__link-badge {
    left: auto;
    right: 15px;
    top: 50%;
    transform: translateY(-50%);
  }

  .default-layout__main {
    padding: 15px;
  }

  .default-layout__footer {
    grid: 3fr 1fr / 1fr;
  }

  .default-layout__footer-links {
    gap: 0;
    grid: repeat(3, 1fr) / 1fr;
    justify-items: center;
    padding-left: 0;
  }

  .default-layout__footer-copyright {
    padding-right: 0;
  }
}', '2020-08-21 21:34:39.691+00', NULL, '2020-08-28 11:33:02.615+00');


--
-- Data for Name: page_variables; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('86327c90-7e4d-46d0-bba8-c5aa2878ebd9', '15792020-3e1a-4e4c-b50a-1e1eaecfa3d0', '4d53d140-56e7-4180-bada-2bc94f19339d', 'Get the latest music information on Aaron Delasy!', '2020-08-21 23:22:35.613+00', NULL, '2020-08-21 23:22:35.613+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('de793d73-d83a-4638-8f44-9de948d9892c', '15792020-3e1a-4e4c-b50a-1e1eaecfa3d0', 'c4e9471c-c7c7-4133-8faf-f01b4dd9a6b2', 'Delasy, Aaron Delasy, Dollar Over Euro', '2020-08-21 23:22:35.613+00', NULL, '2020-08-21 23:22:35.613+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('2d1da9d6-a040-4b3a-9505-571405ac2ede', '3c6e4960-76ff-449b-83c6-1e27521f49c9', '0526d42e-5ea1-4f6f-8965-55b6c046d11d', 'Dollar Over Euro', '2020-08-23 12:06:36.424+00', NULL, '2020-08-23 12:06:36.424+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('59c704a4-da39-402a-8cd8-3a3e388c6f24', '3c6e4960-76ff-449b-83c6-1e27521f49c9', '4d53d140-56e7-4180-bada-2bc94f19339d', 'Listen to Dollar Over Euro by Aaron Delasy', '2020-08-23 12:06:36.424+00', NULL, '2020-08-23 12:06:36.424+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('ba8f1453-a10d-4fce-ab7a-1b8842fcddf2', '3c6e4960-76ff-449b-83c6-1e27521f49c9', '55b3c4ec-7889-4dfd-9388-ff64708c471a', '{{ PUBLIC_URL }}/img/dollar-over-euro.jpg', '2020-08-23 12:06:36.424+00', NULL, '2020-08-23 12:06:36.424+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('8a5a49f5-67c6-4452-b0e8-c1e64f0083da', '3c6e4960-76ff-449b-83c6-1e27521f49c9', 'c4e9471c-c7c7-4133-8faf-f01b4dd9a6b2', 'Delasy, Aaron Delasy, Dollar Over Euro', '2020-08-23 12:06:36.424+00', NULL, '2020-08-23 12:06:36.424+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('bda339bd-8b23-4eef-801b-e8f20e5a3972', '3c6e4960-76ff-449b-83c6-1e27521f49c9', '10e93338-341b-47bf-ab84-f878068704c3', '2020-09-01', '2020-08-23 12:06:36.424+00', NULL, '2020-08-23 12:06:36.424+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('4b9e9d70-b15a-4bc5-98f9-eeb03c04ed23', '3c6e4960-76ff-449b-83c6-1e27521f49c9', 'd7256b60-7ff1-4914-8ceb-4313b9ee8467', '', '2020-08-23 12:06:36.424+00', NULL, '2020-08-23 12:06:36.424+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('2b433692-9aba-4914-8e93-9dd5abdd839c', 'a4eb2bf1-7543-4139-80fd-7b5d8a559d34', 'c4e9471c-c7c7-4133-8faf-f01b4dd9a6b2', 'Delasy, Aaron Delasy, Dollar Over Euro', '2020-08-21 23:18:27.77+00', '2020-08-28 11:32:36.052+00', '2020-08-21 23:18:27.77+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('f591e9fd-042b-40e1-bbd2-bbfe08a159e6', 'a4eb2bf1-7543-4139-80fd-7b5d8a559d34', 'c4e9471c-c7c7-4133-8faf-f01b4dd9a6b2', 'Delasy, Aaron Delasy, Dollar Over Euro', '2020-08-28 11:32:36.059+00', NULL, '2020-08-28 11:32:36.059+00');
INSERT INTO public.page_variables (id, page_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('126e5768-4a3a-4f74-931c-e03ca89897dd', 'a4eb2bf1-7543-4139-80fd-7b5d8a559d34', '9e158247-410a-4965-9f86-eca077bf5952', 'Dollar Over Euro - Single', '2020-08-28 11:32:36.059+00', NULL, '2020-08-28 11:32:36.059+00');


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.pages (id, layout_id, project_id, name, slug, folder, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at, published_at) VALUES ('3c6e4960-76ff-449b-83c6-1e27521f49c9', '8a49743e-e132-4364-948e-912841a16642', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Dollar Over Euro - Aaron Delasy', 'dollar-over-euro', '', '', '', '', '', '2020-08-22 00:10:51.344+00', NULL, '2020-08-28 16:08:16.095+00', '2020-08-28 16:08:16.094+00');
INSERT INTO public.pages (id, layout_id, project_id, name, slug, folder, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at, published_at) VALUES ('15792020-3e1a-4e4c-b50a-1e1eaecfa3d0', 'd45495af-8d55-4191-918b-772ff545672b', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Music | Aaron Delasy', 'music', '', '<div class="music-page">
  <a href="{{ link(''/dollar-over-euro'') }}" rel="noopener noreferrer" target="_blank" aria-label="Dollar Over Euro - Single">
    <span class="music-page__cover" style="background-image: url(''{{ PUBLIC_URL }}/img/dollar-over-euro.jpg'')"></span>
  </a>
</div>', '', '', '.music-page {
  display: grid;
  gap: 25px;
  grid: auto / repeat(2, 1fr);
}

.music-page > a {
  display: inline-grid;
}

.music-page__cover {
  background-color: var(--color-black);
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  display: inline-grid;
  height: calc(100vw / 2 - 25px - 12.5px);
  width: calc(100vw / 2 - 25px - 12.5px);
}

@media (max-width: 575.98px) {
  .music-page {
    gap: 15px;
    grid: auto / 1fr;
  }

  .music-page__cover {
    height: calc(100vw - 15px * 2);
    width: calc(100vw - 15px * 2);
  }
}', '2020-08-21 23:22:35.6+00', NULL, '2020-08-28 16:08:18.151+00', '2020-08-28 16:08:18.151+00');
INSERT INTO public.pages (id, layout_id, project_id, name, slug, folder, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at, published_at) VALUES ('a4eb2bf1-7543-4139-80fd-7b5d8a559d34', 'd45495af-8d55-4191-918b-772ff545672b', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Aaron Delasy Official Website', '', '', '<div class="index-page">
  <a href="{{ FEATURED_ALBUM_URL }}" rel="noopener noreferrer" target="_blank" aria-label="{{ FEATURED_ALBUM_NAME }}">
    <span class="index-page__cover" style="background-image: url(''{{ FEATURED_ALBUM_IMAGE }}'')"></span>
  </a>
</div>', '', '', '.index-page {
  display: grid;
  position: relative;
}

.index-page > a {
  display: inline-grid;
}

.index-page__cover {
  background-color: var(--color-black);
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  display: inline-grid;
  height: calc(100vh - 75px * 2 - 25px * 2);
  width: calc(100vh - 75px * 2 - 25px * 2);
}

@media (max-width: 575.98px) {
  .index-page__cover {
    height: calc(100vw - 15px * 2);
    width: calc(100vw - 15px * 2);
  }
}', '2020-08-21 23:11:25.732+00', NULL, '2020-08-28 16:08:20.776+00', '2020-08-28 16:08:20.776+00');
INSERT INTO public.pages (id, layout_id, project_id, name, slug, folder, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at, published_at) VALUES ('4adb5fbc-b2a8-4d1b-ad31-5938fdcca933', '8abf93a2-4427-4f4e-aebe-0994ab6ec63d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Page Offline | Aaron Delasy', '_offline', '', '<div class="offline-page">
  <h1 class="offline-page__headline">Page Offline</h1>
  <h2 class="offline-page__subtitle">Unable to load page</h2>
  <p class="offline-page__paragraph">Please check your internet connection and reload the page.</p>
</div>', '', '', '.offline-page {
  display: grid;
  justify-items: center;
}

.offline-page__headline {
  color: var(--color-white);
  font-size: 48px;
  font-weight: 400;
  margin-bottom: 40px;
}

.offline-page__subtitle {
  color: var(--color-white);
  font-size: 20px;
  font-weight: 400;
  margin-bottom: 10px;
}

.offline-page__paragraph {
  color: var(--color-white);
  font-size: 16px;
  font-weight: 300;
  margin-bottom: 20px;
  text-align: center;
}

@media (max-width: 575.98px) {
  .offline-page__headline {
    font-size: 34px;
  }
}', '2020-08-21 21:25:51.555+00', NULL, '2020-08-28 16:08:24.161+00', '2020-08-28 16:08:24.16+00');
INSERT INTO public.pages (id, layout_id, project_id, name, slug, folder, body_code, head_code, scripts, styles, created_at, deleted_at, updated_at, published_at) VALUES ('e21436e4-d575-4ca8-8a2b-debb012338b1', '8abf93a2-4427-4f4e-aebe-0994ab6ec63d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'Page Not Found | Aaron Delasy', '_error', '', '<div class="error-page">
  <h1 class="error-page__headline">Page Not Found</h1>
  <h2 class="error-page__subtitle">Something went wrong</h2>
  <p class="error-page__paragraph">The page you are looking for doesn’t exists or has been moved.<br /><a href="{{ link(''/'') }}">Go to Home page</a></p>
</div>', '', '', '.error-page {
  display: grid;
  justify-items: center;
}

.error-page__headline {
  color: var(--color-white);
  font-size: 48px;
  font-weight: 400;
  margin-bottom: 40px;
}

.error-page__subtitle {
  color: var(--color-white);
  font-size: 20px;
  font-weight: 400;
  margin-bottom: 10px;
}

.error-page__paragraph {
  color: var(--color-white);
  font-size: 16px;
  font-weight: 300;
  margin-bottom: 20px;
  text-align: center;
}

.error-page__paragraph > a {
  color: var(--color-white);
  display: inline-grid;
  margin-top: 4px;
}

.error-page__paragraph > a[href]:hover {
  color: rgba(var(--color-white-rgb), 0.8);
}

@media (max-width: 575.98px) {
  .error-page__headline {
    font-size: 34px;
  }
}', '2020-08-21 20:44:13.381+00', NULL, '2020-08-28 16:08:27.413+00', '2020-08-28 16:08:27.413+00');


--
-- Data for Name: project_variables; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.project_variables (id, project_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('5ba41451-faaf-4a89-a450-24c900f8489d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', '9e158247-410a-4965-9f86-eca077bf5952', 'Dollar Over Euro - Single', '2020-08-28 11:31:49.9+00', NULL, '2020-08-28 11:31:49.9+00');
INSERT INTO public.project_variables (id, project_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('6ec62331-d21d-4a0a-95a1-9a0e20c33514', '9270fe1f-5553-49ac-b5bd-598c5bddea71', '3931c987-decc-4e39-8e67-c1e90891f077', '{{ PUBLIC_URL }}/img/dollar-over-euro.jpg', '2020-08-28 11:31:49.9+00', NULL, '2020-08-28 11:31:49.9+00');
INSERT INTO public.project_variables (id, project_id, variable_id, value, created_at, deleted_at, updated_at) VALUES ('178b92b3-abd6-4c97-a82b-46ca5b33a68d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', '924526ff-7f23-4bd3-bc4a-e13c357d6cd0', '{{ link(''/dollar-over-euro'') }}', '2020-08-28 11:31:49.9+00', NULL, '2020-08-28 11:31:49.9+00');


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.projects (id, user_id, name, public_url, created_at, deleted_at, updated_at, bucket_provider, bucket_config_aws, global_body_code, global_head_code, global_scripts, global_styles, description, cdn_provider, cdn_config_cloudflare) VALUES ('9270fe1f-5553-49ac-b5bd-598c5bddea71', 'b5714378-a6e6-492c-bbb8-085ddc6145c6', 'Aaron Delasy', 'https://www.delasy.com', '2020-08-17 12:53:30.889+00', NULL, '2020-08-28 11:31:49.886+00', 'AWS', '{"bucketName": "www.delasy.com", "accessKeyId": "AKIAJXA6LEO5GZB4QP6Q", "secretAccessKey": "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"}', '{{ LAYOUT_CONTENT }}', '<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="HandheldFriendly" content="true" />
<meta name="MobileOptimized" content="width" />
<meta name="google" content="notranslate" />
<meta name="locale" content="en" />

<meta name="msapplication-TileColor" content="#000000" />
<meta name="msapplication-TileImage" content="{{ PUBLIC_URL }}/favicon-144x144.png" />
<meta name="msapplication-config" content="{{ PUBLIC_URL }}/browserconfig.xml" />

<meta name="theme-color" content="#000000" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, minimum-scale=1.0" />

<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-192x192.png" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-57x57.png" sizes="57x57" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-60x60.png" sizes="60x60" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-72x72.png" sizes="72x72" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-76x76.png" sizes="76x76" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-114x114.png" sizes="114x114" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-120x120.png" sizes="120x120" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-144x144.png" sizes="144x144" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-152x152.png" sizes="152x152" />
<link rel="apple-touch-icon" href="{{ PUBLIC_URL }}/favicon-180x180.png" sizes="180x180" />
<link rel="icon" href="{{ PUBLIC_URL }}/favicon-16x16.png" type="image/png" sizes="16x16" />
<link rel="icon" href="{{ PUBLIC_URL }}/favicon-32x32.png" type="image/png" sizes="32x32" />
<link rel="icon" href="{{ PUBLIC_URL }}/favicon-96x96.png" type="image/png" sizes="96x96" />
<link rel="icon"  href="{{ PUBLIC_URL }}/favicon-192x192.png" type="image/png" sizes="192x192" />
<link rel="manifest" href="{{ PUBLIC_URL }}/manifest.json" />
<link rel="mask-icon" href="{{ PUBLIC_URL }}/favicon.svg" color="#000000" />
<link rel="shortcut icon" href="{{ PUBLIC_URL }}/favicon.ico" />

<title>{{ PAGE_NAME }}</title>', 'if (''serviceWorker'' in navigator) {
  navigator.serviceWorker.register(''{{ PUBLIC_URL }}/sw.js'')
}', ':root {
  --color-black-rgb: 0, 0, 0;
  --color-black: #000000;
  --color-white-rgb: 255, 255, 255;
  --color-white: #FFFFFF;
}

*, *::before, *::after {
  box-sizing: border-box;
}

html {
  font-family: sans-serif;
  height: 100%;
  width: 100%;
}

article, aside, figcaption, figure, footer, header, hgroup, main, nav, section {
  display: block;
}

body {
  height: 100%;
  margin: 0;
  width: 100%;
}

h1, h2, h3, h4, h5, h6, p {
  margin: 0;
}

img {
  border-style: none;
  vertical-align: middle;
}

svg {
  overflow: hidden;
  vertical-align: middle;
}', 'Get the latest information on Aaron Delasy – Music, Album, Videos, Tour and More!', 'CLOUDFLARE', '{"zoneId": "89d316bdeca29783e83c87b05550c7f9", "apiToken": "kf7KO6DZp9yyxsTF3sgpRm5iB8tm1XYt9UgmKahb"}');


--
-- Data for Name: sequelize_migrations; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.sequelize_migrations (name) VALUES ('20200812201156-create-user.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200813160604-create-project.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200817061748-modify-project.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200817142921-modify-project.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200817214244-create-asset.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200817221059-create-file.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200817221103-create-icon.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200818082827-modify-project.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200819123824-create-variable.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200819133222-modify-project.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200819135004-create-project-variable.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200819142128-create-file-variable.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200820183953-create-layout.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200820183958-create-page.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200820194755-create-layout-variable.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200820194816-create-page-variable.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200821131325-modify-asset.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200821131328-modify-file.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200821223504-modify-page.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200823110022-modify-page.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200826214917-modify-project.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200827122423-modify-asset.js');
INSERT INTO public.sequelize_migrations (name) VALUES ('20200827122427-modify-file.js');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.users (id, first_name, last_name, email, password, created_at, deleted_at, updated_at) VALUES ('b5714378-a6e6-492c-bbb8-085ddc6145c6', 'Aaron', 'Delasy', 'mgmt@delasy.com', '$2b$10$7fzfO964Ini2IdTwb0rzMeo5Fd5byoGnnJExuLEK7GQIlYziNQAsm', '2020-08-16 18:29:22.712+00', NULL, '2020-08-16 18:29:22.712+00');


--
-- Data for Name: variables; Type: TABLE DATA; Schema: public; Owner: doakqfghcpmcoq
--

INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('413cc20e-7ba0-45ae-951f-30c1172e4cf5', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'SEO_TITLE', '2020-08-21 21:40:22.037+00', NULL, '2020-08-21 21:40:22.037+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('4d53d140-56e7-4180-bada-2bc94f19339d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'SEO_DESCRIPTION', '2020-08-21 21:40:27.919+00', NULL, '2020-08-21 21:40:27.919+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('c4e9471c-c7c7-4133-8faf-f01b4dd9a6b2', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'SEO_KEYWORDS', '2020-08-21 21:40:33.762+00', NULL, '2020-08-21 21:40:33.762+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('55b3c4ec-7889-4dfd-9388-ff64708c471a', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'SEO_IMAGE', '2020-08-21 21:47:04.437+00', NULL, '2020-08-21 21:47:04.437+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('0526d42e-5ea1-4f6f-8965-55b6c046d11d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_NAME', '2020-08-22 11:43:24.065+00', NULL, '2020-08-22 11:43:24.065+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('f1b44f86-2df7-4176-8e6e-c8a6907096cd', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_EXPLICIT', '2020-08-22 11:43:27.637+00', NULL, '2020-08-22 11:43:27.637+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('10e93338-341b-47bf-ab84-f878068704c3', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_RELEASE_DATE', '2020-08-22 11:43:35.041+00', NULL, '2020-08-22 11:43:35.041+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('d7256b60-7ff1-4914-8ceb-4313b9ee8467', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_NO_SERVICES', '2020-08-22 11:43:39.431+00', NULL, '2020-08-22 11:43:39.431+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('b2d93282-fd61-44d4-a503-7a593d8b7e57', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_YOUTUBE', '2020-08-22 11:43:45.594+00', NULL, '2020-08-22 11:43:45.594+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('ef949ece-9036-4dfc-b97d-366b20551c5d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_SPOTIFY', '2020-08-22 11:43:50.187+00', NULL, '2020-08-22 11:43:50.187+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('e2f65bf6-88cb-4952-89d9-d3120f0b5d3a', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_SOUNDCLOUD', '2020-08-22 11:43:56.234+00', NULL, '2020-08-22 11:43:56.234+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('665e9e5f-f97a-4183-8628-e96560af74cf', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_APPLE_MUSIC', '2020-08-22 11:44:00.915+00', NULL, '2020-08-22 11:44:00.915+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('571dd67a-0e30-4c78-9714-2537dcc02170', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_ITUNES_STORE', '2020-08-22 11:44:06.102+00', NULL, '2020-08-22 11:44:06.102+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('f3f57dd4-53c5-4e28-8b09-3b09f5933c31', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_PANDORA', '2020-08-22 11:44:10.479+00', NULL, '2020-08-22 11:44:10.479+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('6a46b915-2e8d-4174-a90c-79b05cc67def', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_YOUTUBE_MUSIC', '2020-08-22 11:44:16.473+00', NULL, '2020-08-22 11:44:16.473+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('f0c0af1e-145b-4d26-895c-04c97c85939c', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_GOOGLE_PLAY_MUSIC', '2020-08-22 11:44:21.8+00', NULL, '2020-08-22 11:44:21.8+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('c86d0aad-9598-4398-88e1-fb4886538fa5', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_AMAZON_MUSIC', '2020-08-22 11:44:25.44+00', NULL, '2020-08-22 11:44:25.44+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('f4087e28-00fd-4877-b673-fa15d731904d', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_AMAZON', '2020-08-22 11:44:30.711+00', NULL, '2020-08-22 11:44:30.711+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('96b55535-4ad6-43cf-9630-eddab9fef318', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_DEEZER', '2020-08-22 11:44:35.381+00', NULL, '2020-08-22 11:44:35.381+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('17e69bd4-8481-4ac1-9b6f-08ff65ed32d8', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_TIDAL', '2020-08-22 11:44:39.86+00', NULL, '2020-08-22 11:44:39.86+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('2fb12d3c-7ee8-461b-805f-9dc9c8b4ea15', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'ALBUM_SERVICE_GENIUS', '2020-08-22 11:44:45.303+00', NULL, '2020-08-22 11:44:45.303+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('9e158247-410a-4965-9f86-eca077bf5952', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'FEATURED_ALBUM_NAME', '2020-08-28 11:28:22.71+00', NULL, '2020-08-28 11:28:22.71+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('3931c987-decc-4e39-8e67-c1e90891f077', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'FEATURED_ALBUM_IMAGE', '2020-08-28 11:29:24.985+00', NULL, '2020-08-28 11:29:24.985+00');
INSERT INTO public.variables (id, project_id, name, created_at, deleted_at, updated_at) VALUES ('924526ff-7f23-4bd3-bc4a-e13c357d6cd0', '9270fe1f-5553-49ac-b5bd-598c5bddea71', 'FEATURED_ALBUM_URL', '2020-08-28 11:29:30.61+00', NULL, '2020-08-28 11:29:30.61+00');


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: assets assets_project_id_name_folder_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_project_id_name_folder_deleted_at_ukey UNIQUE (project_id, name, folder, deleted_at);


--
-- Name: file_variables file_variables_file_id_variable_id_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.file_variables
    ADD CONSTRAINT file_variables_file_id_variable_id_deleted_at_ukey UNIQUE (file_id, variable_id, deleted_at);


--
-- Name: file_variables file_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.file_variables
    ADD CONSTRAINT file_variables_pkey PRIMARY KEY (id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: files files_project_id_name_folder_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_project_id_name_folder_deleted_at_ukey UNIQUE (project_id, name, folder, deleted_at);


--
-- Name: icons icons_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.icons
    ADD CONSTRAINT icons_pkey PRIMARY KEY (id);


--
-- Name: icons icons_project_id_variable_name_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.icons
    ADD CONSTRAINT icons_project_id_variable_name_deleted_at_ukey UNIQUE (project_id, variable_name, deleted_at);


--
-- Name: layout_variables layout_variables_layout_id_variable_id_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.layout_variables
    ADD CONSTRAINT layout_variables_layout_id_variable_id_deleted_at_ukey UNIQUE (layout_id, variable_id, deleted_at);


--
-- Name: layout_variables layout_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.layout_variables
    ADD CONSTRAINT layout_variables_pkey PRIMARY KEY (id);


--
-- Name: layouts layouts_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.layouts
    ADD CONSTRAINT layouts_pkey PRIMARY KEY (id);


--
-- Name: layouts layouts_project_id_name_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.layouts
    ADD CONSTRAINT layouts_project_id_name_deleted_at_ukey UNIQUE (project_id, name, deleted_at);


--
-- Name: page_variables page_variables_page_id_variable_id_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.page_variables
    ADD CONSTRAINT page_variables_page_id_variable_id_deleted_at_ukey UNIQUE (page_id, variable_id, deleted_at);


--
-- Name: page_variables page_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.page_variables
    ADD CONSTRAINT page_variables_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pages pages_project_id_name_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_project_id_name_deleted_at_ukey UNIQUE (project_id, name, deleted_at);


--
-- Name: pages pages_project_id_slug_folder_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_project_id_slug_folder_deleted_at_ukey UNIQUE (project_id, slug, folder, deleted_at);


--
-- Name: project_variables project_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.project_variables
    ADD CONSTRAINT project_variables_pkey PRIMARY KEY (id);


--
-- Name: project_variables project_variables_project_id_variable_id_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.project_variables
    ADD CONSTRAINT project_variables_project_id_variable_id_deleted_at_ukey UNIQUE (project_id, variable_id, deleted_at);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_user_id_name_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_user_id_name_deleted_at_ukey UNIQUE (user_id, name, deleted_at);


--
-- Name: sequelize_migrations sequelize_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.sequelize_migrations
    ADD CONSTRAINT sequelize_migrations_pkey PRIMARY KEY (name);


--
-- Name: users users_email_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_deleted_at_ukey UNIQUE (email, deleted_at);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: variables variables_pkey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (id);


--
-- Name: variables variables_project_id_name_deleted_at_ukey; Type: CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_project_id_name_deleted_at_ukey UNIQUE (project_id, name, deleted_at);


--
-- Name: assets assets_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_variables file_variables_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.file_variables
    ADD CONSTRAINT file_variables_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.files(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_variables file_variables_variable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.file_variables
    ADD CONSTRAINT file_variables_variable_id_fkey FOREIGN KEY (variable_id) REFERENCES public.variables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: files files_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: icons icons_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.icons
    ADD CONSTRAINT icons_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: layout_variables layout_variables_layout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.layout_variables
    ADD CONSTRAINT layout_variables_layout_id_fkey FOREIGN KEY (layout_id) REFERENCES public.layouts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: layout_variables layout_variables_variable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.layout_variables
    ADD CONSTRAINT layout_variables_variable_id_fkey FOREIGN KEY (variable_id) REFERENCES public.variables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: layouts layouts_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.layouts
    ADD CONSTRAINT layouts_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: page_variables page_variables_page_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.page_variables
    ADD CONSTRAINT page_variables_page_id_fkey FOREIGN KEY (page_id) REFERENCES public.pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: page_variables page_variables_variable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.page_variables
    ADD CONSTRAINT page_variables_variable_id_fkey FOREIGN KEY (variable_id) REFERENCES public.variables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pages pages_layout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_layout_id_fkey FOREIGN KEY (layout_id) REFERENCES public.layouts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pages pages_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: project_variables project_variables_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.project_variables
    ADD CONSTRAINT project_variables_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: project_variables project_variables_variable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.project_variables
    ADD CONSTRAINT project_variables_variable_id_fkey FOREIGN KEY (variable_id) REFERENCES public.variables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: projects projects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: variables variables_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doakqfghcpmcoq
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: doakqfghcpmcoq
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO doakqfghcpmcoq;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: LANGUAGE plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO doakqfghcpmcoq;


--
-- PostgreSQL database dump complete
--

