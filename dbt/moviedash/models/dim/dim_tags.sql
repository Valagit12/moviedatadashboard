WITH src_tags AS (
    SELECT * FROM {{ref('src_tags')}}
)
SELECT
    user_id,
    movie_id,
    INITCAP(TRIM(tag)) as tag_name
FROM src_tags