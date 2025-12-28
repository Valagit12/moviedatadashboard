{{
    config(
        materialized = 'ephemeral'
    )
}}

WITH movies AS (
    SELECT * FROM {{ ref("dim_movies")}}
),
tags AS (
    SELECT * FROM {{ ref("dim_tags")}}
)

SELECT 
    m.movie_id as movie_id,
    m.movie_title as movie_title,
    m.genres as genres,
    t.tag_name as tag,
FROM movies m
LEFT JOIN scores s ON m.movie_id = t.movie_id
