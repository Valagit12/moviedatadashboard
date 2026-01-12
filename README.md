# MovieLens Data Warehouse + Public Dashboard

This project builds an end to end analytics pipeline on MovieLens. Raw CSV files land in S3, Snowflake stores the raw and modeled tables, dbt builds the clean analytics layer, and a public Streamlit dashboard reads only from a small set of marts.

## Public dashboard
Live app: [https://moviedatadashboard-p5jdvl7ktdsptevwtk4xsf.streamlit.app/](https://moviedatadashboard-p5jdvl7ktdsptevwtk4xsf.streamlit.app/)

## Overarching architecture

### 1) Storage layer (S3)
MovieLens CSV files are stored in an S3 bucket. This is the “landing zone” for raw data.

### 2) Raw layer (Snowflake)
The CSV files are loaded from S3 into Snowflake raw tables (one per dataset such as movies, ratings, tags). These tables keep the data close to the source format.

Purpose:
- Preserve raw data for reprocessing
- Keep transformations out of the ingest step

### 3) Modeling layer (dbt in Snowflake)
dbt runs SQL inside Snowflake to build the analytics schema. The model layers are:

- Sources (`src_*`): references to the raw tables
- Dimensions (`dim_*`): cleaned, conformed entities (movies, users, tags)
- Facts (`fct_*`): event tables (ratings), built incrementally
- Marts (`mart_*`): small aggregates designed for fast dashboard queries

Key idea:
Snowflake does the compute and stores the results. dbt is the build system and the dependency graph.

### 4) Serving layer (Streamlit)
A Streamlit app is hosted publicly and connects to Snowflake using a dedicated read only Snowflake user. The app queries only the marts and renders charts and tables.

Why marts:
- Faster page loads
- Simpler SQL in the app
- Smaller surface area exposed to the app user

### 5) Security and access boundaries
- The Streamlit Snowflake user has SELECT only on the marts (or secure views)
- No access to raw tables
- All credentials are stored as Streamlit secrets, not in GitHub

## Data flow (high level)
S3 CSV
-> Snowflake RAW tables
-> dbt dims and fact tables
-> dbt marts
-> Streamlit dashboard (public)
