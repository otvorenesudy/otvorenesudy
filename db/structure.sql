--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Homebrew)
-- Dumped by pg_dump version 16.3 (Homebrew)

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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accusations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accusations (
    id integer NOT NULL,
    defendant_id integer NOT NULL,
    value character varying(510) NOT NULL,
    value_unprocessed character varying(510) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accusations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accusations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accusations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accusations_id_seq OWNED BY public.accusations.id;


--
-- Name: court_expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.court_expenses (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    court_id integer NOT NULL,
    year integer NOT NULL,
    value integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: court_expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.court_expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: court_expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.court_expenses_id_seq OWNED BY public.court_expenses.id;


--
-- Name: court_jurisdictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.court_jurisdictions (
    id integer NOT NULL,
    court_proceeding_type_id integer NOT NULL,
    municipality_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: court_jurisdictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.court_jurisdictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: court_jurisdictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.court_jurisdictions_id_seq OWNED BY public.court_jurisdictions.id;


--
-- Name: court_office_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.court_office_types (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: court_office_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.court_office_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: court_office_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.court_office_types_id_seq OWNED BY public.court_office_types.id;


--
-- Name: court_offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.court_offices (
    id integer NOT NULL,
    court_id integer NOT NULL,
    court_office_type_id integer NOT NULL,
    email character varying(255),
    phone character varying(255),
    hours_monday character varying(255),
    hours_tuesday character varying(255),
    hours_wednesday character varying(255),
    hours_thursday character varying(255),
    hours_friday character varying(255),
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: court_offices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.court_offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: court_offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.court_offices_id_seq OWNED BY public.court_offices.id;


--
-- Name: court_proceeding_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.court_proceeding_types (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: court_proceeding_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.court_proceeding_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: court_proceeding_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.court_proceeding_types_id_seq OWNED BY public.court_proceeding_types.id;


--
-- Name: court_statistical_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.court_statistical_summaries (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    court_id integer NOT NULL,
    year integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: court_statistical_summaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.court_statistical_summaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: court_statistical_summaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.court_statistical_summaries_id_seq OWNED BY public.court_statistical_summaries.id;


--
-- Name: court_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.court_types (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: court_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.court_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: court_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.court_types_id_seq OWNED BY public.court_types.id;


--
-- Name: courts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courts (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    court_type_id integer NOT NULL,
    court_jurisdiction_id integer,
    municipality_id integer NOT NULL,
    name character varying(255) NOT NULL,
    street character varying(255) NOT NULL,
    phone character varying(255),
    fax character varying(255),
    media_person character varying(255),
    media_person_unprocessed character varying(255),
    media_phone character varying(255),
    information_center_id integer,
    registry_center_id integer,
    business_registry_center_id integer,
    latitude numeric(12,8),
    longitude numeric(12,8),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    acronym character varying(255),
    source_class character varying(255),
    source_class_id integer,
    data_protection_email character varying(255),
    destroyed_at timestamp without time zone,
    other_contacts_json text
);


--
-- Name: courts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.courts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.courts_id_seq OWNED BY public.courts.id;


--
-- Name: decree_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.decree_forms (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: decree_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.decree_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: decree_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.decree_forms_id_seq OWNED BY public.decree_forms.id;


--
-- Name: decree_naturalizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.decree_naturalizations (
    id integer NOT NULL,
    decree_id integer NOT NULL,
    decree_nature_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: decree_naturalizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.decree_naturalizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: decree_naturalizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.decree_naturalizations_id_seq OWNED BY public.decree_naturalizations.id;


--
-- Name: decree_natures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.decree_natures (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: decree_natures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.decree_natures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: decree_natures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.decree_natures_id_seq OWNED BY public.decree_natures.id;


--
-- Name: decree_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.decree_pages (
    id integer NOT NULL,
    decree_id integer NOT NULL,
    number integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: decree_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.decree_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: decree_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.decree_pages_id_seq OWNED BY public.decree_pages.id;


--
-- Name: decrees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.decrees (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    proceeding_id integer,
    court_id integer,
    decree_form_id integer,
    case_number character varying(255),
    file_number character varying(255),
    date date,
    ecli character varying(255),
    summary text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pdf_uri character varying(2048),
    pdf_uri_invalid boolean DEFAULT false NOT NULL,
    source_class character varying(255),
    source_class_id integer,
    embedding public.vector(768)
);


--
-- Name: decrees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.decrees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: decrees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.decrees_id_seq OWNED BY public.decrees.id;


--
-- Name: defendants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.defendants (
    id integer NOT NULL,
    hearing_id integer NOT NULL,
    name character varying(255) NOT NULL,
    name_unprocessed character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: defendants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.defendants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: defendants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.defendants_id_seq OWNED BY public.defendants.id;


--
-- Name: employments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employments (
    id integer NOT NULL,
    court_id integer NOT NULL,
    judge_id integer NOT NULL,
    judge_position_id integer,
    active boolean,
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying(255)
);


--
-- Name: employments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employments_id_seq OWNED BY public.employments.id;


--
-- Name: hearing_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hearing_forms (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hearing_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hearing_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hearing_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hearing_forms_id_seq OWNED BY public.hearing_forms.id;


--
-- Name: hearing_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hearing_sections (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hearing_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hearing_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hearing_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hearing_sections_id_seq OWNED BY public.hearing_sections.id;


--
-- Name: hearing_subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hearing_subjects (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hearing_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hearing_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hearing_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hearing_subjects_id_seq OWNED BY public.hearing_subjects.id;


--
-- Name: hearing_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hearing_types (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hearing_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hearing_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hearing_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hearing_types_id_seq OWNED BY public.hearing_types.id;


--
-- Name: hearings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hearings (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    proceeding_id integer,
    court_id integer,
    hearing_type_id integer NOT NULL,
    hearing_section_id integer,
    hearing_subject_id integer,
    hearing_form_id integer,
    case_number character varying(255),
    file_number character varying(255),
    date timestamp without time zone,
    room character varying(255),
    special_type character varying(255),
    commencement_date timestamp without time zone,
    selfjudge boolean,
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    anonymized_at timestamp without time zone,
    source_class character varying(255),
    source_class_id integer,
    original_court_id integer,
    original_case_number character varying(255)
);


--
-- Name: hearings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hearings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hearings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hearings_id_seq OWNED BY public.hearings.id;


--
-- Name: judge_designation_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_designation_types (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_designation_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_designation_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_designation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_designation_types_id_seq OWNED BY public.judge_designation_types.id;


--
-- Name: judge_designations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_designations (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    judge_id integer NOT NULL,
    judge_designation_type_id integer,
    date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_designations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_designations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_designations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_designations_id_seq OWNED BY public.judge_designations.id;


--
-- Name: judge_incomes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_incomes (
    id integer NOT NULL,
    judge_property_declaration_id integer NOT NULL,
    description character varying(255) NOT NULL,
    value numeric(12,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_incomes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_incomes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_incomes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_incomes_id_seq OWNED BY public.judge_incomes.id;


--
-- Name: judge_positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_positions (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_positions_id_seq OWNED BY public.judge_positions.id;


--
-- Name: judge_proclaims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_proclaims (
    id integer NOT NULL,
    judge_property_declaration_id integer NOT NULL,
    judge_statement_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_proclaims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_proclaims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_proclaims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_proclaims_id_seq OWNED BY public.judge_proclaims.id;


--
-- Name: judge_properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_properties (
    id integer NOT NULL,
    judge_property_list_id integer NOT NULL,
    judge_property_acquisition_reason_id integer,
    judge_property_ownership_form_id integer,
    judge_property_change_id integer,
    description character varying(255),
    acquisition_date character varying(255),
    cost bigint,
    share_size character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_properties_id_seq OWNED BY public.judge_properties.id;


--
-- Name: judge_property_acquisition_reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_property_acquisition_reasons (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_property_acquisition_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_property_acquisition_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_property_acquisition_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_property_acquisition_reasons_id_seq OWNED BY public.judge_property_acquisition_reasons.id;


--
-- Name: judge_property_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_property_categories (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_property_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_property_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_property_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_property_categories_id_seq OWNED BY public.judge_property_categories.id;


--
-- Name: judge_property_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_property_changes (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_property_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_property_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_property_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_property_changes_id_seq OWNED BY public.judge_property_changes.id;


--
-- Name: judge_property_declarations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_property_declarations (
    id integer NOT NULL,
    uri character varying(255),
    source_id integer NOT NULL,
    court_id integer NOT NULL,
    judge_id integer NOT NULL,
    year integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_property_declarations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_property_declarations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_property_declarations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_property_declarations_id_seq OWNED BY public.judge_property_declarations.id;


--
-- Name: judge_property_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_property_lists (
    id integer NOT NULL,
    judge_property_declaration_id integer NOT NULL,
    judge_property_category_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_property_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_property_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_property_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_property_lists_id_seq OWNED BY public.judge_property_lists.id;


--
-- Name: judge_property_ownership_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_property_ownership_forms (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_property_ownership_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_property_ownership_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_property_ownership_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_property_ownership_forms_id_seq OWNED BY public.judge_property_ownership_forms.id;


--
-- Name: judge_related_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_related_people (
    id integer NOT NULL,
    judge_property_declaration_id integer NOT NULL,
    name character varying(255) NOT NULL,
    name_unprocessed character varying(255) NOT NULL,
    institution character varying(255),
    function character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_related_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_related_people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_related_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_related_people_id_seq OWNED BY public.judge_related_people.id;


--
-- Name: judge_senate_inclusions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_senate_inclusions (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_senate_inclusions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_senate_inclusions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_senate_inclusions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_senate_inclusions_id_seq OWNED BY public.judge_senate_inclusions.id;


--
-- Name: judge_statements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_statements (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_statements_id_seq OWNED BY public.judge_statements.id;


--
-- Name: judge_statistical_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judge_statistical_summaries (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    court_id integer NOT NULL,
    judge_id integer NOT NULL,
    judge_senate_inclusion_id integer,
    author character varying(255),
    year integer NOT NULL,
    date date,
    days_worked integer,
    days_heard integer,
    days_used integer,
    released_constitutional_decrees integer,
    delayed_constitutional_decrees integer,
    idea_reduction_reasons text,
    educational_activities text,
    substantiation_notes text,
    court_chair_actions text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judge_statistical_summaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judge_statistical_summaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_statistical_summaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judge_statistical_summaries_id_seq OWNED BY public.judge_statistical_summaries.id;


--
-- Name: judgements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judgements (
    id integer NOT NULL,
    decree_id integer NOT NULL,
    judge_id integer,
    judge_name_similarity numeric(3,2) NOT NULL,
    judge_name_unprocessed character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judgements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judgements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judgements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judgements_id_seq OWNED BY public.judgements.id;


--
-- Name: judges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judges (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    name character varying(255) NOT NULL,
    name_unprocessed character varying(255) NOT NULL,
    prefix character varying(255),
    first character varying(255) NOT NULL,
    middle character varying(255),
    last character varying(255) NOT NULL,
    suffix character varying(255),
    addition character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    source_class character varying(255),
    source_class_id integer
);


--
-- Name: judges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judges_id_seq OWNED BY public.judges.id;


--
-- Name: judgings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.judgings (
    id integer NOT NULL,
    hearing_id integer NOT NULL,
    judge_id integer,
    judge_name_similarity numeric(3,2) NOT NULL,
    judge_name_unprocessed character varying(255),
    judge_chair boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: judgings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.judgings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judgings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.judgings_id_seq OWNED BY public.judgings.id;


--
-- Name: legislation_area_usages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislation_area_usages (
    id integer NOT NULL,
    decree_id integer NOT NULL,
    legislation_area_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislation_area_usages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legislation_area_usages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislation_area_usages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislation_area_usages_id_seq OWNED BY public.legislation_area_usages.id;


--
-- Name: legislation_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislation_areas (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislation_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legislation_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislation_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislation_areas_id_seq OWNED BY public.legislation_areas.id;


--
-- Name: legislation_subarea_usages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislation_subarea_usages (
    id integer NOT NULL,
    decree_id integer NOT NULL,
    legislation_subarea_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislation_subarea_usages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legislation_subarea_usages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislation_subarea_usages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislation_subarea_usages_id_seq OWNED BY public.legislation_subarea_usages.id;


--
-- Name: legislation_subareas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislation_subareas (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislation_subareas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legislation_subareas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislation_subareas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislation_subareas_id_seq OWNED BY public.legislation_subareas.id;


--
-- Name: legislation_usages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislation_usages (
    id integer NOT NULL,
    legislation_id integer NOT NULL,
    decree_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislation_usages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legislation_usages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislation_usages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislation_usages_id_seq OWNED BY public.legislation_usages.id;


--
-- Name: legislations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legislations (
    id integer NOT NULL,
    value character varying(510) NOT NULL,
    value_unprocessed character varying(510) NOT NULL,
    type character varying(255),
    number integer,
    year integer,
    name character varying(510),
    section character varying(255),
    paragraph character varying(255),
    letter character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legislations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legislations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legislations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legislations_id_seq OWNED BY public.legislations.id;


--
-- Name: municipalities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.municipalities (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    zipcode character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: municipalities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.municipalities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: municipalities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.municipalities_id_seq OWNED BY public.municipalities.id;


--
-- Name: opponents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opponents (
    id integer NOT NULL,
    hearing_id integer NOT NULL,
    name character varying(255) NOT NULL,
    name_unprocessed character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: opponents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.opponents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: opponents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.opponents_id_seq OWNED BY public.opponents.id;


--
-- Name: paragraph_explanations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paragraph_explanations (
    id integer NOT NULL,
    paragraph_id integer NOT NULL,
    explainable_id integer NOT NULL,
    explainable_type character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: paragraph_explanations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.paragraph_explanations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: paragraph_explanations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.paragraph_explanations_id_seq OWNED BY public.paragraph_explanations.id;


--
-- Name: paragraphs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paragraphs (
    id integer NOT NULL,
    legislation integer NOT NULL,
    number character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: paragraphs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.paragraphs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: paragraphs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.paragraphs_id_seq OWNED BY public.paragraphs.id;


--
-- Name: periods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.periods (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    value integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: periods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.periods_id_seq OWNED BY public.periods.id;


--
-- Name: proceedings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proceedings (
    id integer NOT NULL,
    file_number character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: proceedings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.proceedings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: proceedings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.proceedings_id_seq OWNED BY public.proceedings.id;


--
-- Name: proposers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.proposers (
    id integer NOT NULL,
    hearing_id integer NOT NULL,
    name character varying(255) NOT NULL,
    name_unprocessed character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: proposers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.proposers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: proposers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.proposers_id_seq OWNED BY public.proposers.id;


--
-- Name: queries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.queries (
    id integer NOT NULL,
    model character varying(255) NOT NULL,
    digest character varying(255) NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: queries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.queries_id_seq OWNED BY public.queries.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: selection_procedure_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.selection_procedure_candidates (
    id integer NOT NULL,
    uri character varying(255),
    selection_procedure_id integer NOT NULL,
    judge_id integer,
    name character varying(255) NOT NULL,
    name_unprocessed character varying(255) NOT NULL,
    accomplished_expectations text,
    oral_score character varying(255),
    oral_result character varying(255),
    written_score character varying(255),
    written_result character varying(255),
    score character varying(255),
    rank character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    application_url character varying(2048),
    curriculum_url character varying(2048),
    declaration_url character varying(2048),
    motivation_letter_url character varying(2048)
);


--
-- Name: selection_procedure_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.selection_procedure_candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: selection_procedure_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.selection_procedure_candidates_id_seq OWNED BY public.selection_procedure_candidates.id;


--
-- Name: selection_procedure_commissioners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.selection_procedure_commissioners (
    id integer NOT NULL,
    selection_procedure_id integer NOT NULL,
    judge_id integer,
    name character varying(255) NOT NULL,
    name_unprocessed character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: selection_procedure_commissioners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.selection_procedure_commissioners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: selection_procedure_commissioners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.selection_procedure_commissioners_id_seq OWNED BY public.selection_procedure_commissioners.id;


--
-- Name: selection_procedures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.selection_procedures (
    id integer NOT NULL,
    uri character varying(2048) NOT NULL,
    source_id integer NOT NULL,
    court_id integer,
    organization_name character varying(255) NOT NULL,
    organization_name_unprocessed character varying(255) NOT NULL,
    organization_description text,
    date date,
    description text,
    place character varying(255),
    "position" character varying(255) NOT NULL,
    state character varying(255),
    workplace character varying(255),
    closed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    declaration_url character varying(2048),
    report_url character varying(2048)
);


--
-- Name: selection_procedures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.selection_procedures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: selection_procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.selection_procedures_id_seq OWNED BY public.selection_procedures.id;


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sources (
    id integer NOT NULL,
    module character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    uri character varying(2048) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sources_id_seq OWNED BY public.sources.id;


--
-- Name: statistical_table_cells; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statistical_table_cells (
    id integer NOT NULL,
    statistical_table_column_id integer NOT NULL,
    statistical_table_row_id integer NOT NULL,
    value character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statistical_table_cells_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statistical_table_cells_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistical_table_cells_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statistical_table_cells_id_seq OWNED BY public.statistical_table_cells.id;


--
-- Name: statistical_table_column_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statistical_table_column_names (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statistical_table_column_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statistical_table_column_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistical_table_column_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statistical_table_column_names_id_seq OWNED BY public.statistical_table_column_names.id;


--
-- Name: statistical_table_columns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statistical_table_columns (
    id integer NOT NULL,
    statistical_table_id integer NOT NULL,
    statistical_table_column_name_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statistical_table_columns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statistical_table_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistical_table_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statistical_table_columns_id_seq OWNED BY public.statistical_table_columns.id;


--
-- Name: statistical_table_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statistical_table_names (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statistical_table_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statistical_table_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistical_table_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statistical_table_names_id_seq OWNED BY public.statistical_table_names.id;


--
-- Name: statistical_table_row_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statistical_table_row_names (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statistical_table_row_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statistical_table_row_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistical_table_row_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statistical_table_row_names_id_seq OWNED BY public.statistical_table_row_names.id;


--
-- Name: statistical_table_rows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statistical_table_rows (
    id integer NOT NULL,
    statistical_table_id integer NOT NULL,
    statistical_table_row_name_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statistical_table_rows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statistical_table_rows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistical_table_rows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statistical_table_rows_id_seq OWNED BY public.statistical_table_rows.id;


--
-- Name: statistical_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statistical_tables (
    id integer NOT NULL,
    statistical_summary_id integer NOT NULL,
    statistical_summary_type character varying(255) NOT NULL,
    statistical_table_name_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statistical_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statistical_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistical_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statistical_tables_id_seq OWNED BY public.statistical_tables.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    query_id integer NOT NULL,
    period_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    confirmed_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    remember_created_at timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: accusations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accusations ALTER COLUMN id SET DEFAULT nextval('public.accusations_id_seq'::regclass);


--
-- Name: court_expenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_expenses ALTER COLUMN id SET DEFAULT nextval('public.court_expenses_id_seq'::regclass);


--
-- Name: court_jurisdictions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_jurisdictions ALTER COLUMN id SET DEFAULT nextval('public.court_jurisdictions_id_seq'::regclass);


--
-- Name: court_office_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_office_types ALTER COLUMN id SET DEFAULT nextval('public.court_office_types_id_seq'::regclass);


--
-- Name: court_offices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_offices ALTER COLUMN id SET DEFAULT nextval('public.court_offices_id_seq'::regclass);


--
-- Name: court_proceeding_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_proceeding_types ALTER COLUMN id SET DEFAULT nextval('public.court_proceeding_types_id_seq'::regclass);


--
-- Name: court_statistical_summaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_statistical_summaries ALTER COLUMN id SET DEFAULT nextval('public.court_statistical_summaries_id_seq'::regclass);


--
-- Name: court_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_types ALTER COLUMN id SET DEFAULT nextval('public.court_types_id_seq'::regclass);


--
-- Name: courts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courts ALTER COLUMN id SET DEFAULT nextval('public.courts_id_seq'::regclass);


--
-- Name: decree_forms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_forms ALTER COLUMN id SET DEFAULT nextval('public.decree_forms_id_seq'::regclass);


--
-- Name: decree_naturalizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_naturalizations ALTER COLUMN id SET DEFAULT nextval('public.decree_naturalizations_id_seq'::regclass);


--
-- Name: decree_natures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_natures ALTER COLUMN id SET DEFAULT nextval('public.decree_natures_id_seq'::regclass);


--
-- Name: decree_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_pages ALTER COLUMN id SET DEFAULT nextval('public.decree_pages_id_seq'::regclass);


--
-- Name: decrees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decrees ALTER COLUMN id SET DEFAULT nextval('public.decrees_id_seq'::regclass);


--
-- Name: defendants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.defendants ALTER COLUMN id SET DEFAULT nextval('public.defendants_id_seq'::regclass);


--
-- Name: employments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments ALTER COLUMN id SET DEFAULT nextval('public.employments_id_seq'::regclass);


--
-- Name: hearing_forms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_forms ALTER COLUMN id SET DEFAULT nextval('public.hearing_forms_id_seq'::regclass);


--
-- Name: hearing_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_sections ALTER COLUMN id SET DEFAULT nextval('public.hearing_sections_id_seq'::regclass);


--
-- Name: hearing_subjects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_subjects ALTER COLUMN id SET DEFAULT nextval('public.hearing_subjects_id_seq'::regclass);


--
-- Name: hearing_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_types ALTER COLUMN id SET DEFAULT nextval('public.hearing_types_id_seq'::regclass);


--
-- Name: hearings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearings ALTER COLUMN id SET DEFAULT nextval('public.hearings_id_seq'::regclass);


--
-- Name: judge_designation_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_designation_types ALTER COLUMN id SET DEFAULT nextval('public.judge_designation_types_id_seq'::regclass);


--
-- Name: judge_designations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_designations ALTER COLUMN id SET DEFAULT nextval('public.judge_designations_id_seq'::regclass);


--
-- Name: judge_incomes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_incomes ALTER COLUMN id SET DEFAULT nextval('public.judge_incomes_id_seq'::regclass);


--
-- Name: judge_positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_positions ALTER COLUMN id SET DEFAULT nextval('public.judge_positions_id_seq'::regclass);


--
-- Name: judge_proclaims id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_proclaims ALTER COLUMN id SET DEFAULT nextval('public.judge_proclaims_id_seq'::regclass);


--
-- Name: judge_properties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_properties ALTER COLUMN id SET DEFAULT nextval('public.judge_properties_id_seq'::regclass);


--
-- Name: judge_property_acquisition_reasons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_acquisition_reasons ALTER COLUMN id SET DEFAULT nextval('public.judge_property_acquisition_reasons_id_seq'::regclass);


--
-- Name: judge_property_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_categories ALTER COLUMN id SET DEFAULT nextval('public.judge_property_categories_id_seq'::regclass);


--
-- Name: judge_property_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_changes ALTER COLUMN id SET DEFAULT nextval('public.judge_property_changes_id_seq'::regclass);


--
-- Name: judge_property_declarations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_declarations ALTER COLUMN id SET DEFAULT nextval('public.judge_property_declarations_id_seq'::regclass);


--
-- Name: judge_property_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_lists ALTER COLUMN id SET DEFAULT nextval('public.judge_property_lists_id_seq'::regclass);


--
-- Name: judge_property_ownership_forms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_ownership_forms ALTER COLUMN id SET DEFAULT nextval('public.judge_property_ownership_forms_id_seq'::regclass);


--
-- Name: judge_related_people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_related_people ALTER COLUMN id SET DEFAULT nextval('public.judge_related_people_id_seq'::regclass);


--
-- Name: judge_senate_inclusions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_senate_inclusions ALTER COLUMN id SET DEFAULT nextval('public.judge_senate_inclusions_id_seq'::regclass);


--
-- Name: judge_statements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_statements ALTER COLUMN id SET DEFAULT nextval('public.judge_statements_id_seq'::regclass);


--
-- Name: judge_statistical_summaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_statistical_summaries ALTER COLUMN id SET DEFAULT nextval('public.judge_statistical_summaries_id_seq'::regclass);


--
-- Name: judgements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judgements ALTER COLUMN id SET DEFAULT nextval('public.judgements_id_seq'::regclass);


--
-- Name: judges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judges ALTER COLUMN id SET DEFAULT nextval('public.judges_id_seq'::regclass);


--
-- Name: judgings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judgings ALTER COLUMN id SET DEFAULT nextval('public.judgings_id_seq'::regclass);


--
-- Name: legislation_area_usages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_area_usages ALTER COLUMN id SET DEFAULT nextval('public.legislation_area_usages_id_seq'::regclass);


--
-- Name: legislation_areas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_areas ALTER COLUMN id SET DEFAULT nextval('public.legislation_areas_id_seq'::regclass);


--
-- Name: legislation_subarea_usages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_subarea_usages ALTER COLUMN id SET DEFAULT nextval('public.legislation_subarea_usages_id_seq'::regclass);


--
-- Name: legislation_subareas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_subareas ALTER COLUMN id SET DEFAULT nextval('public.legislation_subareas_id_seq'::regclass);


--
-- Name: legislation_usages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_usages ALTER COLUMN id SET DEFAULT nextval('public.legislation_usages_id_seq'::regclass);


--
-- Name: legislations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislations ALTER COLUMN id SET DEFAULT nextval('public.legislations_id_seq'::regclass);


--
-- Name: municipalities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipalities ALTER COLUMN id SET DEFAULT nextval('public.municipalities_id_seq'::regclass);


--
-- Name: opponents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opponents ALTER COLUMN id SET DEFAULT nextval('public.opponents_id_seq'::regclass);


--
-- Name: paragraph_explanations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paragraph_explanations ALTER COLUMN id SET DEFAULT nextval('public.paragraph_explanations_id_seq'::regclass);


--
-- Name: paragraphs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paragraphs ALTER COLUMN id SET DEFAULT nextval('public.paragraphs_id_seq'::regclass);


--
-- Name: periods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.periods ALTER COLUMN id SET DEFAULT nextval('public.periods_id_seq'::regclass);


--
-- Name: proceedings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proceedings ALTER COLUMN id SET DEFAULT nextval('public.proceedings_id_seq'::regclass);


--
-- Name: proposers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposers ALTER COLUMN id SET DEFAULT nextval('public.proposers_id_seq'::regclass);


--
-- Name: queries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queries ALTER COLUMN id SET DEFAULT nextval('public.queries_id_seq'::regclass);


--
-- Name: selection_procedure_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selection_procedure_candidates ALTER COLUMN id SET DEFAULT nextval('public.selection_procedure_candidates_id_seq'::regclass);


--
-- Name: selection_procedure_commissioners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selection_procedure_commissioners ALTER COLUMN id SET DEFAULT nextval('public.selection_procedure_commissioners_id_seq'::regclass);


--
-- Name: selection_procedures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selection_procedures ALTER COLUMN id SET DEFAULT nextval('public.selection_procedures_id_seq'::regclass);


--
-- Name: sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sources ALTER COLUMN id SET DEFAULT nextval('public.sources_id_seq'::regclass);


--
-- Name: statistical_table_cells id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_cells ALTER COLUMN id SET DEFAULT nextval('public.statistical_table_cells_id_seq'::regclass);


--
-- Name: statistical_table_column_names id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_column_names ALTER COLUMN id SET DEFAULT nextval('public.statistical_table_column_names_id_seq'::regclass);


--
-- Name: statistical_table_columns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_columns ALTER COLUMN id SET DEFAULT nextval('public.statistical_table_columns_id_seq'::regclass);


--
-- Name: statistical_table_names id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_names ALTER COLUMN id SET DEFAULT nextval('public.statistical_table_names_id_seq'::regclass);


--
-- Name: statistical_table_row_names id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_row_names ALTER COLUMN id SET DEFAULT nextval('public.statistical_table_row_names_id_seq'::regclass);


--
-- Name: statistical_table_rows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_rows ALTER COLUMN id SET DEFAULT nextval('public.statistical_table_rows_id_seq'::regclass);


--
-- Name: statistical_tables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_tables ALTER COLUMN id SET DEFAULT nextval('public.statistical_tables_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: accusations accusations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accusations
    ADD CONSTRAINT accusations_pkey PRIMARY KEY (id);


--
-- Name: court_expenses court_expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_expenses
    ADD CONSTRAINT court_expenses_pkey PRIMARY KEY (id);


--
-- Name: court_jurisdictions court_jurisdictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_jurisdictions
    ADD CONSTRAINT court_jurisdictions_pkey PRIMARY KEY (id);


--
-- Name: court_office_types court_office_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_office_types
    ADD CONSTRAINT court_office_types_pkey PRIMARY KEY (id);


--
-- Name: court_offices court_offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_offices
    ADD CONSTRAINT court_offices_pkey PRIMARY KEY (id);


--
-- Name: court_proceeding_types court_proceeding_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_proceeding_types
    ADD CONSTRAINT court_proceeding_types_pkey PRIMARY KEY (id);


--
-- Name: court_statistical_summaries court_statistical_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_statistical_summaries
    ADD CONSTRAINT court_statistical_summaries_pkey PRIMARY KEY (id);


--
-- Name: court_types court_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.court_types
    ADD CONSTRAINT court_types_pkey PRIMARY KEY (id);


--
-- Name: courts courts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courts
    ADD CONSTRAINT courts_pkey PRIMARY KEY (id);


--
-- Name: decree_forms decree_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_forms
    ADD CONSTRAINT decree_forms_pkey PRIMARY KEY (id);


--
-- Name: decree_naturalizations decree_naturalizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_naturalizations
    ADD CONSTRAINT decree_naturalizations_pkey PRIMARY KEY (id);


--
-- Name: decree_natures decree_natures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_natures
    ADD CONSTRAINT decree_natures_pkey PRIMARY KEY (id);


--
-- Name: decree_pages decree_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decree_pages
    ADD CONSTRAINT decree_pages_pkey PRIMARY KEY (id);


--
-- Name: decrees decrees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.decrees
    ADD CONSTRAINT decrees_pkey PRIMARY KEY (id);


--
-- Name: defendants defendants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.defendants
    ADD CONSTRAINT defendants_pkey PRIMARY KEY (id);


--
-- Name: employments employments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employments
    ADD CONSTRAINT employments_pkey PRIMARY KEY (id);


--
-- Name: hearing_forms hearing_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_forms
    ADD CONSTRAINT hearing_forms_pkey PRIMARY KEY (id);


--
-- Name: hearing_sections hearing_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_sections
    ADD CONSTRAINT hearing_sections_pkey PRIMARY KEY (id);


--
-- Name: hearing_subjects hearing_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_subjects
    ADD CONSTRAINT hearing_subjects_pkey PRIMARY KEY (id);


--
-- Name: hearing_types hearing_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearing_types
    ADD CONSTRAINT hearing_types_pkey PRIMARY KEY (id);


--
-- Name: hearings hearings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hearings
    ADD CONSTRAINT hearings_pkey PRIMARY KEY (id);


--
-- Name: judge_designation_types judge_designation_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_designation_types
    ADD CONSTRAINT judge_designation_types_pkey PRIMARY KEY (id);


--
-- Name: judge_designations judge_designations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_designations
    ADD CONSTRAINT judge_designations_pkey PRIMARY KEY (id);


--
-- Name: judge_incomes judge_incomes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_incomes
    ADD CONSTRAINT judge_incomes_pkey PRIMARY KEY (id);


--
-- Name: judge_positions judge_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_positions
    ADD CONSTRAINT judge_positions_pkey PRIMARY KEY (id);


--
-- Name: judge_proclaims judge_proclaims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_proclaims
    ADD CONSTRAINT judge_proclaims_pkey PRIMARY KEY (id);


--
-- Name: judge_properties judge_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_properties
    ADD CONSTRAINT judge_properties_pkey PRIMARY KEY (id);


--
-- Name: judge_property_acquisition_reasons judge_property_acquisition_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_acquisition_reasons
    ADD CONSTRAINT judge_property_acquisition_reasons_pkey PRIMARY KEY (id);


--
-- Name: judge_property_categories judge_property_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_categories
    ADD CONSTRAINT judge_property_categories_pkey PRIMARY KEY (id);


--
-- Name: judge_property_changes judge_property_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_changes
    ADD CONSTRAINT judge_property_changes_pkey PRIMARY KEY (id);


--
-- Name: judge_property_declarations judge_property_declarations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_declarations
    ADD CONSTRAINT judge_property_declarations_pkey PRIMARY KEY (id);


--
-- Name: judge_property_lists judge_property_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_lists
    ADD CONSTRAINT judge_property_lists_pkey PRIMARY KEY (id);


--
-- Name: judge_property_ownership_forms judge_property_ownership_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_property_ownership_forms
    ADD CONSTRAINT judge_property_ownership_forms_pkey PRIMARY KEY (id);


--
-- Name: judge_related_people judge_related_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_related_people
    ADD CONSTRAINT judge_related_people_pkey PRIMARY KEY (id);


--
-- Name: judge_senate_inclusions judge_senate_inclusions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_senate_inclusions
    ADD CONSTRAINT judge_senate_inclusions_pkey PRIMARY KEY (id);


--
-- Name: judge_statements judge_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_statements
    ADD CONSTRAINT judge_statements_pkey PRIMARY KEY (id);


--
-- Name: judge_statistical_summaries judge_statistical_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judge_statistical_summaries
    ADD CONSTRAINT judge_statistical_summaries_pkey PRIMARY KEY (id);


--
-- Name: judgements judgements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judgements
    ADD CONSTRAINT judgements_pkey PRIMARY KEY (id);


--
-- Name: judges judges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judges
    ADD CONSTRAINT judges_pkey PRIMARY KEY (id);


--
-- Name: judgings judgings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.judgings
    ADD CONSTRAINT judgings_pkey PRIMARY KEY (id);


--
-- Name: legislation_area_usages legislation_area_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_area_usages
    ADD CONSTRAINT legislation_area_usages_pkey PRIMARY KEY (id);


--
-- Name: legislation_areas legislation_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_areas
    ADD CONSTRAINT legislation_areas_pkey PRIMARY KEY (id);


--
-- Name: legislation_subarea_usages legislation_subarea_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_subarea_usages
    ADD CONSTRAINT legislation_subarea_usages_pkey PRIMARY KEY (id);


--
-- Name: legislation_subareas legislation_subareas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_subareas
    ADD CONSTRAINT legislation_subareas_pkey PRIMARY KEY (id);


--
-- Name: legislation_usages legislation_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislation_usages
    ADD CONSTRAINT legislation_usages_pkey PRIMARY KEY (id);


--
-- Name: legislations legislations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legislations
    ADD CONSTRAINT legislations_pkey PRIMARY KEY (id);


--
-- Name: municipalities municipalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipalities
    ADD CONSTRAINT municipalities_pkey PRIMARY KEY (id);


--
-- Name: opponents opponents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opponents
    ADD CONSTRAINT opponents_pkey PRIMARY KEY (id);


--
-- Name: paragraph_explanations paragraph_explainations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paragraph_explanations
    ADD CONSTRAINT paragraph_explainations_pkey PRIMARY KEY (id);


--
-- Name: paragraphs paragraphs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paragraphs
    ADD CONSTRAINT paragraphs_pkey PRIMARY KEY (id);


--
-- Name: periods periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_pkey PRIMARY KEY (id);


--
-- Name: proceedings proceedings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proceedings
    ADD CONSTRAINT proceedings_pkey PRIMARY KEY (id);


--
-- Name: proposers proposers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.proposers
    ADD CONSTRAINT proposers_pkey PRIMARY KEY (id);


--
-- Name: queries queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_pkey PRIMARY KEY (id);


--
-- Name: selection_procedure_candidates selection_procedure_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selection_procedure_candidates
    ADD CONSTRAINT selection_procedure_candidates_pkey PRIMARY KEY (id);


--
-- Name: selection_procedure_commissioners selection_procedure_commissioners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selection_procedure_commissioners
    ADD CONSTRAINT selection_procedure_commissioners_pkey PRIMARY KEY (id);


--
-- Name: selection_procedures selection_procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selection_procedures
    ADD CONSTRAINT selection_procedures_pkey PRIMARY KEY (id);


--
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: statistical_table_cells statistical_table_cells_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_cells
    ADD CONSTRAINT statistical_table_cells_pkey PRIMARY KEY (id);


--
-- Name: statistical_table_column_names statistical_table_column_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_column_names
    ADD CONSTRAINT statistical_table_column_names_pkey PRIMARY KEY (id);


--
-- Name: statistical_table_columns statistical_table_columns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_columns
    ADD CONSTRAINT statistical_table_columns_pkey PRIMARY KEY (id);


--
-- Name: statistical_table_names statistical_table_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_names
    ADD CONSTRAINT statistical_table_names_pkey PRIMARY KEY (id);


--
-- Name: statistical_table_row_names statistical_table_row_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_row_names
    ADD CONSTRAINT statistical_table_row_names_pkey PRIMARY KEY (id);


--
-- Name: statistical_table_rows statistical_table_rows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_table_rows
    ADD CONSTRAINT statistical_table_rows_pkey PRIMARY KEY (id);


--
-- Name: statistical_tables statistical_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statistical_tables
    ADD CONSTRAINT statistical_tables_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: decrees_embedding_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX decrees_embedding_idx ON public.decrees USING hnsw (embedding public.vector_cosine_ops) WITH (m='20', ef_construction='64');


--
-- Name: index_accusations_on_defendant_id_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accusations_on_defendant_id_and_value ON public.accusations USING btree (defendant_id, value);


--
-- Name: index_area_usage_on_decree_id_and_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_area_usage_on_decree_id_and_area_id ON public.legislation_area_usages USING btree (decree_id, legislation_area_id);


--
-- Name: index_commissioners_on_selection_procedure; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commissioners_on_selection_procedure ON public.selection_procedure_commissioners USING btree (selection_procedure_id);


--
-- Name: index_court_expenses_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_expenses_on_court_id ON public.court_expenses USING btree (court_id);


--
-- Name: index_court_expenses_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_expenses_on_source_id ON public.court_expenses USING btree (source_id);


--
-- Name: index_court_expenses_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_expenses_on_uri ON public.court_expenses USING btree (uri);


--
-- Name: index_court_expenses_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_expenses_on_year ON public.court_expenses USING btree (year);


--
-- Name: index_court_jurisdictions_on_court_proceeding_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_jurisdictions_on_court_proceeding_type_id ON public.court_jurisdictions USING btree (court_proceeding_type_id);


--
-- Name: index_court_jurisdictions_on_municipality_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_jurisdictions_on_municipality_id ON public.court_jurisdictions USING btree (municipality_id);


--
-- Name: index_court_office_types_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_court_office_types_on_value ON public.court_office_types USING btree (value);


--
-- Name: index_court_offices_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_offices_on_court_id ON public.court_offices USING btree (court_id);


--
-- Name: index_court_proceeding_types_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_court_proceeding_types_on_value ON public.court_proceeding_types USING btree (value);


--
-- Name: index_court_statistical_summaries_on_court_and_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_court_statistical_summaries_on_court_and_year ON public.court_statistical_summaries USING btree (court_id, year);


--
-- Name: index_court_statistical_summaries_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_statistical_summaries_on_court_id ON public.court_statistical_summaries USING btree (court_id);


--
-- Name: index_court_statistical_summaries_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_statistical_summaries_on_source_id ON public.court_statistical_summaries USING btree (source_id);


--
-- Name: index_court_statistical_summaries_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_statistical_summaries_on_uri ON public.court_statistical_summaries USING btree (uri);


--
-- Name: index_court_statistical_summaries_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_court_statistical_summaries_on_year ON public.court_statistical_summaries USING btree (year);


--
-- Name: index_court_types_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_court_types_on_value ON public.court_types USING btree (value);


--
-- Name: index_courts_on_acronym; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_acronym ON public.courts USING btree (acronym);


--
-- Name: index_courts_on_court_jurisdiction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_court_jurisdiction_id ON public.courts USING btree (court_jurisdiction_id);


--
-- Name: index_courts_on_court_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_court_type_id ON public.courts USING btree (court_type_id);


--
-- Name: index_courts_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_created_at ON public.courts USING btree (created_at);


--
-- Name: index_courts_on_municipality_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_municipality_id ON public.courts USING btree (municipality_id);


--
-- Name: index_courts_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_courts_on_name ON public.courts USING btree (name);


--
-- Name: index_courts_on_source_class_and_source_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_source_class_and_source_class_id ON public.courts USING btree (source_class, source_class_id);


--
-- Name: index_courts_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_source_id ON public.courts USING btree (source_id);


--
-- Name: index_courts_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courts_on_updated_at ON public.courts USING btree (updated_at);


--
-- Name: index_courts_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_courts_on_uri ON public.courts USING btree (uri);


--
-- Name: index_decree_forms_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_decree_forms_on_value ON public.decree_forms USING btree (value);


--
-- Name: index_decree_naturalizations_on_decree_id_and_decree_nature_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_decree_naturalizations_on_decree_id_and_decree_nature_id ON public.decree_naturalizations USING btree (decree_id, decree_nature_id);


--
-- Name: index_decree_naturalizations_on_decree_nature_id_and_decree_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_decree_naturalizations_on_decree_nature_id_and_decree_id ON public.decree_naturalizations USING btree (decree_nature_id, decree_id);


--
-- Name: index_decree_natures_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_decree_natures_on_value ON public.decree_natures USING btree (value);


--
-- Name: index_decree_pages_on_decree_id_and_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_decree_pages_on_decree_id_and_number ON public.decree_pages USING btree (decree_id, number);


--
-- Name: index_decrees_on_case_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_case_number ON public.decrees USING btree (case_number);


--
-- Name: index_decrees_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_court_id ON public.decrees USING btree (court_id);


--
-- Name: index_decrees_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_created_at ON public.decrees USING btree (created_at);


--
-- Name: index_decrees_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_date ON public.decrees USING btree (date);


--
-- Name: index_decrees_on_decree_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_decree_form_id ON public.decrees USING btree (decree_form_id);


--
-- Name: index_decrees_on_ecli; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_ecli ON public.decrees USING btree (ecli);


--
-- Name: index_decrees_on_file_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_file_number ON public.decrees USING btree (file_number);


--
-- Name: index_decrees_on_proceeding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_proceeding_id ON public.decrees USING btree (proceeding_id);


--
-- Name: index_decrees_on_source_class_and_source_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_source_class_and_source_class_id ON public.decrees USING btree (source_class, source_class_id);


--
-- Name: index_decrees_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_source_id ON public.decrees USING btree (source_id);


--
-- Name: index_decrees_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_updated_at ON public.decrees USING btree (updated_at);


--
-- Name: index_decrees_on_updated_at_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_decrees_on_updated_at_and_id ON public.decrees USING btree (updated_at, id);


--
-- Name: index_decrees_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_decrees_on_uri ON public.decrees USING btree (uri);


--
-- Name: index_defendants_on_hearing_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_defendants_on_hearing_id_and_name ON public.defendants USING btree (hearing_id, name);


--
-- Name: index_defendants_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_defendants_on_name ON public.defendants USING btree (name);


--
-- Name: index_defendants_on_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_defendants_on_name_unprocessed ON public.defendants USING btree (name_unprocessed);


--
-- Name: index_employments_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employments_on_active ON public.employments USING btree (active);


--
-- Name: index_employments_on_court_id_and_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employments_on_court_id_and_judge_id ON public.employments USING btree (court_id, judge_id);


--
-- Name: index_employments_on_judge_id_and_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employments_on_judge_id_and_court_id ON public.employments USING btree (judge_id, court_id);


--
-- Name: index_hearing_forms_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hearing_forms_on_value ON public.hearing_forms USING btree (value);


--
-- Name: index_hearing_sections_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hearing_sections_on_value ON public.hearing_sections USING btree (value);


--
-- Name: index_hearing_subjects_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hearing_subjects_on_value ON public.hearing_subjects USING btree (value);


--
-- Name: index_hearing_types_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hearing_types_on_value ON public.hearing_types USING btree (value);


--
-- Name: index_hearings_on_anonymized_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_anonymized_at ON public.hearings USING btree (anonymized_at);


--
-- Name: index_hearings_on_case_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_case_number ON public.hearings USING btree (case_number);


--
-- Name: index_hearings_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_court_id ON public.hearings USING btree (court_id);


--
-- Name: index_hearings_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_created_at ON public.hearings USING btree (created_at);


--
-- Name: index_hearings_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_date ON public.hearings USING btree (date);


--
-- Name: index_hearings_on_file_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_file_number ON public.hearings USING btree (file_number);


--
-- Name: index_hearings_on_proceeding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_proceeding_id ON public.hearings USING btree (proceeding_id);


--
-- Name: index_hearings_on_source_class_and_source_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_source_class_and_source_class_id ON public.hearings USING btree (source_class, source_class_id);


--
-- Name: index_hearings_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_source_id ON public.hearings USING btree (source_id);


--
-- Name: index_hearings_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hearings_on_updated_at ON public.hearings USING btree (updated_at);


--
-- Name: index_hearings_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hearings_on_uri ON public.hearings USING btree (uri);


--
-- Name: index_judge_designation_types_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_designation_types_on_value ON public.judge_designation_types USING btree (value);


--
-- Name: index_judge_designations_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_designations_on_date ON public.judge_designations USING btree (date);


--
-- Name: index_judge_designations_on_judge_designation_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_designations_on_judge_designation_type_id ON public.judge_designations USING btree (judge_designation_type_id);


--
-- Name: index_judge_designations_on_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_designations_on_judge_id ON public.judge_designations USING btree (judge_id);


--
-- Name: index_judge_designations_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_designations_on_source_id ON public.judge_designations USING btree (source_id);


--
-- Name: index_judge_designations_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_designations_on_uri ON public.judge_designations USING btree (uri);


--
-- Name: index_judge_incomes_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_incomes_on_description ON public.judge_incomes USING btree (description);


--
-- Name: index_judge_incomes_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_incomes_on_unique_values ON public.judge_incomes USING btree (judge_property_declaration_id, description);


--
-- Name: index_judge_positions_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_positions_on_value ON public.judge_positions USING btree (value);


--
-- Name: index_judge_proclaims_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_proclaims_on_unique_values ON public.judge_proclaims USING btree (judge_property_declaration_id, judge_statement_id);


--
-- Name: index_judge_proclaims_on_unique_values_reversed; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_proclaims_on_unique_values_reversed ON public.judge_proclaims USING btree (judge_statement_id, judge_property_declaration_id);


--
-- Name: index_judge_properties_on_judge_property_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_properties_on_judge_property_list_id ON public.judge_properties USING btree (judge_property_list_id);


--
-- Name: index_judge_property_acquisition_reasons_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_acquisition_reasons_on_value ON public.judge_property_acquisition_reasons USING btree (value);


--
-- Name: index_judge_property_categories_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_categories_on_value ON public.judge_property_categories USING btree (value);


--
-- Name: index_judge_property_changes_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_changes_on_value ON public.judge_property_changes USING btree (value);


--
-- Name: index_judge_property_declarations_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_property_declarations_on_court_id ON public.judge_property_declarations USING btree (court_id);


--
-- Name: index_judge_property_declarations_on_judge_id_and_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_declarations_on_judge_id_and_year ON public.judge_property_declarations USING btree (judge_id, year);


--
-- Name: index_judge_property_declarations_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_property_declarations_on_source_id ON public.judge_property_declarations USING btree (source_id);


--
-- Name: index_judge_property_declarations_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_declarations_on_uri ON public.judge_property_declarations USING btree (uri);


--
-- Name: index_judge_property_declarations_on_year_and_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_declarations_on_year_and_judge_id ON public.judge_property_declarations USING btree (year, judge_id);


--
-- Name: index_judge_property_lists_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_lists_on_unique_values ON public.judge_property_lists USING btree (judge_property_declaration_id, judge_property_category_id);


--
-- Name: index_judge_property_lists_on_unique_values_reversed; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_lists_on_unique_values_reversed ON public.judge_property_lists USING btree (judge_property_category_id, judge_property_declaration_id);


--
-- Name: index_judge_property_ownership_forms_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_property_ownership_forms_on_value ON public.judge_property_ownership_forms USING btree (value);


--
-- Name: index_judge_related_people_on_function; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_related_people_on_function ON public.judge_related_people USING btree (function);


--
-- Name: index_judge_related_people_on_institution; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_related_people_on_institution ON public.judge_related_people USING btree (institution);


--
-- Name: index_judge_related_people_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_related_people_on_name ON public.judge_related_people USING btree (name);


--
-- Name: index_judge_related_people_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_related_people_on_unique_values ON public.judge_related_people USING btree (judge_property_declaration_id, name);


--
-- Name: index_judge_senate_inclusions_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_senate_inclusions_on_value ON public.judge_senate_inclusions USING btree (value);


--
-- Name: index_judge_statements_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_statements_on_value ON public.judge_statements USING btree (value);


--
-- Name: index_judge_statistical_summaries_on_author; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_statistical_summaries_on_author ON public.judge_statistical_summaries USING btree (author);


--
-- Name: index_judge_statistical_summaries_on_court_and_judge_and_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judge_statistical_summaries_on_court_and_judge_and_year ON public.judge_statistical_summaries USING btree (court_id, judge_id, year);


--
-- Name: index_judge_statistical_summaries_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_statistical_summaries_on_court_id ON public.judge_statistical_summaries USING btree (court_id);


--
-- Name: index_judge_statistical_summaries_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_statistical_summaries_on_date ON public.judge_statistical_summaries USING btree (date);


--
-- Name: index_judge_statistical_summaries_on_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_statistical_summaries_on_judge_id ON public.judge_statistical_summaries USING btree (judge_id);


--
-- Name: index_judge_statistical_summaries_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_statistical_summaries_on_source_id ON public.judge_statistical_summaries USING btree (source_id);


--
-- Name: index_judge_statistical_summaries_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_statistical_summaries_on_uri ON public.judge_statistical_summaries USING btree (uri);


--
-- Name: index_judge_statistical_summaries_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judge_statistical_summaries_on_year ON public.judge_statistical_summaries USING btree (year);


--
-- Name: index_judgements_on_decree_id_and_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judgements_on_decree_id_and_judge_id ON public.judgements USING btree (decree_id, judge_id);


--
-- Name: index_judgements_on_judge_id_and_decree_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judgements_on_judge_id_and_decree_id ON public.judgements USING btree (judge_id, decree_id);


--
-- Name: index_judgements_on_judge_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judgements_on_judge_name_unprocessed ON public.judgements USING btree (judge_name_unprocessed);


--
-- Name: index_judges_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judges_on_created_at ON public.judges USING btree (created_at);


--
-- Name: index_judges_on_first_and_middle_and_last; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judges_on_first_and_middle_and_last ON public.judges USING btree (first, middle, last);


--
-- Name: index_judges_on_last_and_middle_and_first; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judges_on_last_and_middle_and_first ON public.judges USING btree (last, middle, first);


--
-- Name: index_judges_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judges_on_name ON public.judges USING btree (name);


--
-- Name: index_judges_on_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judges_on_name_unprocessed ON public.judges USING btree (name_unprocessed);


--
-- Name: index_judges_on_source_class_and_source_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judges_on_source_class_and_source_class_id ON public.judges USING btree (source_class, source_class_id);


--
-- Name: index_judges_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judges_on_source_id ON public.judges USING btree (source_id);


--
-- Name: index_judges_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judges_on_updated_at ON public.judges USING btree (updated_at);


--
-- Name: index_judges_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judges_on_uri ON public.judges USING btree (uri);


--
-- Name: index_judgings_on_hearing_id_and_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judgings_on_hearing_id_and_judge_id ON public.judgings USING btree (hearing_id, judge_id);


--
-- Name: index_judgings_on_judge_id_and_hearing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_judgings_on_judge_id_and_hearing_id ON public.judgings USING btree (judge_id, hearing_id);


--
-- Name: index_judgings_on_judge_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_judgings_on_judge_name_unprocessed ON public.judgings USING btree (judge_name_unprocessed);


--
-- Name: index_legislation_area_usages_on_decree_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_area_usages_on_decree_id ON public.legislation_area_usages USING btree (decree_id);


--
-- Name: index_legislation_area_usages_on_legislation_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_area_usages_on_legislation_area_id ON public.legislation_area_usages USING btree (legislation_area_id);


--
-- Name: index_legislation_areas_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_legislation_areas_on_value ON public.legislation_areas USING btree (value);


--
-- Name: index_legislation_subarea_usages_on_decree_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_subarea_usages_on_decree_id ON public.legislation_subarea_usages USING btree (decree_id);


--
-- Name: index_legislation_subarea_usages_on_legislation_subarea_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legislation_subarea_usages_on_legislation_subarea_id ON public.legislation_subarea_usages USING btree (legislation_subarea_id);


--
-- Name: index_legislation_subareas_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_legislation_subareas_on_value ON public.legislation_subareas USING btree (value);


--
-- Name: index_legislation_usages_on_decree_id_and_legislation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_legislation_usages_on_decree_id_and_legislation_id ON public.legislation_usages USING btree (decree_id, legislation_id);


--
-- Name: index_legislation_usages_on_legislation_id_and_decree_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_legislation_usages_on_legislation_id_and_decree_id ON public.legislation_usages USING btree (legislation_id, decree_id);


--
-- Name: index_legislations_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_legislations_on_value ON public.legislations USING btree (value);


--
-- Name: index_municipalities_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_municipalities_on_name ON public.municipalities USING btree (name);


--
-- Name: index_municipalities_on_zipcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_municipalities_on_zipcode ON public.municipalities USING btree (zipcode);


--
-- Name: index_opponents_on_hearing_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_opponents_on_hearing_id_and_name ON public.opponents USING btree (hearing_id, name);


--
-- Name: index_opponents_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opponents_on_name ON public.opponents USING btree (name);


--
-- Name: index_opponents_on_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opponents_on_name_unprocessed ON public.opponents USING btree (name_unprocessed);


--
-- Name: index_paragraph_explainations_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_paragraph_explainations_on_unique_values ON public.paragraph_explanations USING btree (paragraph_id, explainable_id, explainable_type);


--
-- Name: index_paragraph_explainations_on_unique_values_reversed; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_paragraph_explainations_on_unique_values_reversed ON public.paragraph_explanations USING btree (explainable_id, explainable_type, paragraph_id);


--
-- Name: index_paragraphs_on_legislation_and_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_paragraphs_on_legislation_and_number ON public.paragraphs USING btree (legislation, number);


--
-- Name: index_periods_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_periods_on_name ON public.periods USING btree (name);


--
-- Name: index_proceedings_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_proceedings_on_created_at ON public.proceedings USING btree (created_at);


--
-- Name: index_proceedings_on_file_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_proceedings_on_file_number ON public.proceedings USING btree (file_number);


--
-- Name: index_proceedings_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_proceedings_on_updated_at ON public.proceedings USING btree (updated_at);


--
-- Name: index_proposers_on_hearing_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_proposers_on_hearing_id_and_name ON public.proposers USING btree (hearing_id, name);


--
-- Name: index_proposers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_proposers_on_name ON public.proposers USING btree (name);


--
-- Name: index_proposers_on_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_proposers_on_name_unprocessed ON public.proposers USING btree (name_unprocessed);


--
-- Name: index_queries_on_digest_and_model; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_queries_on_digest_and_model ON public.queries USING btree (digest, model);


--
-- Name: index_queries_on_model_and_digest; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_queries_on_model_and_digest ON public.queries USING btree (model, digest);


--
-- Name: index_selection_procedure_candidates_on_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedure_candidates_on_judge_id ON public.selection_procedure_candidates USING btree (judge_id);


--
-- Name: index_selection_procedure_candidates_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedure_candidates_on_name ON public.selection_procedure_candidates USING btree (name);


--
-- Name: index_selection_procedure_candidates_on_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedure_candidates_on_name_unprocessed ON public.selection_procedure_candidates USING btree (name_unprocessed);


--
-- Name: index_selection_procedure_candidates_on_selection_procedure_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedure_candidates_on_selection_procedure_id ON public.selection_procedure_candidates USING btree (selection_procedure_id);


--
-- Name: index_selection_procedure_commissioners_on_judge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedure_commissioners_on_judge_id ON public.selection_procedure_commissioners USING btree (judge_id);


--
-- Name: index_selection_procedure_commissioners_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedure_commissioners_on_name ON public.selection_procedure_commissioners USING btree (name);


--
-- Name: index_selection_procedure_commissioners_on_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedure_commissioners_on_name_unprocessed ON public.selection_procedure_commissioners USING btree (name_unprocessed);


--
-- Name: index_selection_procedures_on_closed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_closed_at ON public.selection_procedures USING btree (closed_at);


--
-- Name: index_selection_procedures_on_court_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_court_id ON public.selection_procedures USING btree (court_id);


--
-- Name: index_selection_procedures_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_created_at ON public.selection_procedures USING btree (created_at);


--
-- Name: index_selection_procedures_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_date ON public.selection_procedures USING btree (date);


--
-- Name: index_selection_procedures_on_organization_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_organization_name ON public.selection_procedures USING btree (organization_name);


--
-- Name: index_selection_procedures_on_organization_name_unprocessed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_organization_name_unprocessed ON public.selection_procedures USING btree (organization_name_unprocessed);


--
-- Name: index_selection_procedures_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_source_id ON public.selection_procedures USING btree (source_id);


--
-- Name: index_selection_procedures_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_updated_at ON public.selection_procedures USING btree (updated_at);


--
-- Name: index_selection_procedures_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selection_procedures_on_uri ON public.selection_procedures USING btree (uri);


--
-- Name: index_sources_on_module; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sources_on_module ON public.sources USING btree (module);


--
-- Name: index_sources_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sources_on_name ON public.sources USING btree (name);


--
-- Name: index_sources_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sources_on_uri ON public.sources USING btree (uri);


--
-- Name: index_statistical_table_cells_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_table_cells_on_unique_values ON public.statistical_table_cells USING btree (statistical_table_column_id, statistical_table_row_id);


--
-- Name: index_statistical_table_cells_on_unique_values_reversed; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_table_cells_on_unique_values_reversed ON public.statistical_table_cells USING btree (statistical_table_row_id, statistical_table_column_id);


--
-- Name: index_statistical_table_column_names_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_table_column_names_on_value ON public.statistical_table_column_names USING btree (value);


--
-- Name: index_statistical_table_columns_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_table_columns_on_unique_values ON public.statistical_table_columns USING btree (statistical_table_id, statistical_table_column_name_id);


--
-- Name: index_statistical_table_names_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_table_names_on_value ON public.statistical_table_names USING btree (value);


--
-- Name: index_statistical_table_row_names_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_table_row_names_on_value ON public.statistical_table_row_names USING btree (value);


--
-- Name: index_statistical_table_rows_on_unique_values; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_table_rows_on_unique_values ON public.statistical_table_rows USING btree (statistical_table_id, statistical_table_row_name_id);


--
-- Name: index_statistical_tables_on_statistical_table_name_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistical_tables_on_statistical_table_name_id ON public.statistical_tables USING btree (statistical_table_name_id);


--
-- Name: index_statistical_tables_on_summary_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistical_tables_on_summary_and_name ON public.statistical_tables USING btree (statistical_summary_id, statistical_summary_type, statistical_table_name_id);


--
-- Name: index_subarea_usage_on_decree_id_and_subarea_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subarea_usage_on_decree_id_and_subarea_id ON public.legislation_subarea_usages USING btree (decree_id, legislation_subarea_id);


--
-- Name: index_subscriptions_on_period_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_period_id ON public.subscriptions USING btree (period_id);


--
-- Name: index_subscriptions_on_query_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_query_id ON public.subscriptions USING btree (query_id);


--
-- Name: index_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_user_id ON public.subscriptions USING btree (user_id);


--
-- Name: index_subscriptions_on_user_id_and_query_id_and_period_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_user_id_and_query_id_and_period_id ON public.subscriptions USING btree (user_id, query_id, period_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unconfirmed_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unconfirmed_email ON public.users USING btree (unconfirmed_email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20121030193140');

INSERT INTO schema_migrations (version) VALUES ('20121030193141');

INSERT INTO schema_migrations (version) VALUES ('20121030193145');

INSERT INTO schema_migrations (version) VALUES ('20121030201052');

INSERT INTO schema_migrations (version) VALUES ('20121030201112');

INSERT INTO schema_migrations (version) VALUES ('20121030201219');

INSERT INTO schema_migrations (version) VALUES ('20121030201236');

INSERT INTO schema_migrations (version) VALUES ('20121030201250');

INSERT INTO schema_migrations (version) VALUES ('20121030201308');

INSERT INTO schema_migrations (version) VALUES ('20121030201322');

INSERT INTO schema_migrations (version) VALUES ('20121030201350');

INSERT INTO schema_migrations (version) VALUES ('20121030201356');

INSERT INTO schema_migrations (version) VALUES ('20121030201423');

INSERT INTO schema_migrations (version) VALUES ('20121030201443');

INSERT INTO schema_migrations (version) VALUES ('20121030201459');

INSERT INTO schema_migrations (version) VALUES ('20121030201504');

INSERT INTO schema_migrations (version) VALUES ('20121030201511');

INSERT INTO schema_migrations (version) VALUES ('20121030201516');

INSERT INTO schema_migrations (version) VALUES ('20121030202830');

INSERT INTO schema_migrations (version) VALUES ('20121030202900');

INSERT INTO schema_migrations (version) VALUES ('20121030202907');

INSERT INTO schema_migrations (version) VALUES ('20121030202928');

INSERT INTO schema_migrations (version) VALUES ('20121030210248');

INSERT INTO schema_migrations (version) VALUES ('20121030210328');

INSERT INTO schema_migrations (version) VALUES ('20121030210337');

INSERT INTO schema_migrations (version) VALUES ('20121030210342');

INSERT INTO schema_migrations (version) VALUES ('20121030210345');

INSERT INTO schema_migrations (version) VALUES ('20121030210348');

INSERT INTO schema_migrations (version) VALUES ('20121030210352');

INSERT INTO schema_migrations (version) VALUES ('20121030210413');

INSERT INTO schema_migrations (version) VALUES ('20121030210417');

INSERT INTO schema_migrations (version) VALUES ('20121030210424');

INSERT INTO schema_migrations (version) VALUES ('20121030210430');

INSERT INTO schema_migrations (version) VALUES ('20130413211311');

INSERT INTO schema_migrations (version) VALUES ('20130413211340');

INSERT INTO schema_migrations (version) VALUES ('20130413211353');

INSERT INTO schema_migrations (version) VALUES ('20130413211414');

INSERT INTO schema_migrations (version) VALUES ('20130413211444');

INSERT INTO schema_migrations (version) VALUES ('20130413211459');

INSERT INTO schema_migrations (version) VALUES ('20130413211510');

INSERT INTO schema_migrations (version) VALUES ('20130413211530');

INSERT INTO schema_migrations (version) VALUES ('20130413211544');

INSERT INTO schema_migrations (version) VALUES ('20130413211558');

INSERT INTO schema_migrations (version) VALUES ('20130413211610');

INSERT INTO schema_migrations (version) VALUES ('20130513160056');

INSERT INTO schema_migrations (version) VALUES ('20130513160121');

INSERT INTO schema_migrations (version) VALUES ('20130513160127');

INSERT INTO schema_migrations (version) VALUES ('20130513160134');

INSERT INTO schema_migrations (version) VALUES ('20130513160146');

INSERT INTO schema_migrations (version) VALUES ('20130513160158');

INSERT INTO schema_migrations (version) VALUES ('20130513160211');

INSERT INTO schema_migrations (version) VALUES ('20130513160224');

INSERT INTO schema_migrations (version) VALUES ('20130513160231');

INSERT INTO schema_migrations (version) VALUES ('20130516184433');

INSERT INTO schema_migrations (version) VALUES ('20130519163020');

INSERT INTO schema_migrations (version) VALUES ('20130522160707');

INSERT INTO schema_migrations (version) VALUES ('20130523011102');

INSERT INTO schema_migrations (version) VALUES ('20130527211651');

INSERT INTO schema_migrations (version) VALUES ('20130606174658');

INSERT INTO schema_migrations (version) VALUES ('20130611161353');

INSERT INTO schema_migrations (version) VALUES ('20130703182132');

INSERT INTO schema_migrations (version) VALUES ('20130706175615');

INSERT INTO schema_migrations (version) VALUES ('20130706175848');

INSERT INTO schema_migrations (version) VALUES ('20130706180818');

INSERT INTO schema_migrations (version) VALUES ('20130930184827');

INSERT INTO schema_migrations (version) VALUES ('20131019123234');

INSERT INTO schema_migrations (version) VALUES ('20140129205512');

INSERT INTO schema_migrations (version) VALUES ('20140605144041');

INSERT INTO schema_migrations (version) VALUES ('20140605144050');

INSERT INTO schema_migrations (version) VALUES ('20140605144100');

INSERT INTO schema_migrations (version) VALUES ('20141011195736');

INSERT INTO schema_migrations (version) VALUES ('20141114014737');

INSERT INTO schema_migrations (version) VALUES ('20141124173307');

INSERT INTO schema_migrations (version) VALUES ('20141124173318');

INSERT INTO schema_migrations (version) VALUES ('20141124231648');

INSERT INTO schema_migrations (version) VALUES ('20141201144408');

INSERT INTO schema_migrations (version) VALUES ('20151010220257');

INSERT INTO schema_migrations (version) VALUES ('20151027124327');

INSERT INTO schema_migrations (version) VALUES ('20151102145748');

INSERT INTO schema_migrations (version) VALUES ('20160111115719');

INSERT INTO schema_migrations (version) VALUES ('20160115123443');

INSERT INTO schema_migrations (version) VALUES ('20160117173159');

INSERT INTO schema_migrations (version) VALUES ('20160215195259');

INSERT INTO schema_migrations (version) VALUES ('20170305152500');

INSERT INTO schema_migrations (version) VALUES ('20170305154502');

INSERT INTO schema_migrations (version) VALUES ('20181226101609');

INSERT INTO schema_migrations (version) VALUES ('20190329094548');

INSERT INTO schema_migrations (version) VALUES ('20190418202027');

INSERT INTO schema_migrations (version) VALUES ('20191218100057');

INSERT INTO schema_migrations (version) VALUES ('20191218104004');

INSERT INTO schema_migrations (version) VALUES ('20200501214856');

INSERT INTO schema_migrations (version) VALUES ('20240301134042');

INSERT INTO schema_migrations (version) VALUES ('20240408153736');

INSERT INTO schema_migrations (version) VALUES ('20240408171033');

INSERT INTO schema_migrations (version) VALUES ('20240419135456');

INSERT INTO schema_migrations (version) VALUES ('20240422190139');

INSERT INTO schema_migrations (version) VALUES ('20240429101517');

INSERT INTO schema_migrations (version) VALUES ('20240430115407');

INSERT INTO schema_migrations (version) VALUES ('20240504114137');

INSERT INTO schema_migrations (version) VALUES ('20240504161043');

INSERT INTO schema_migrations (version) VALUES ('20240513145707');

INSERT INTO schema_migrations (version) VALUES ('20240516084658');

INSERT INTO schema_migrations (version) VALUES ('20240613170412');