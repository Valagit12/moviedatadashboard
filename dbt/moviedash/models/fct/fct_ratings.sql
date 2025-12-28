{{
    config(
        materialized = 'incremental',
        on_schema_change = 'fail'
    )
}}

WITH src_ratings AS (
    SELECT * FROM {{ ref('src_ratings') }}
)
SELECT
    user_id,
    movie_id,
    rating,
    rating_timestamp,
    to_timestamp_ntz(rating_timestamp) as rating_ts
FROM src_ratings
WHERE rating IS NOT NULL

{% if is_incremental() %}
    AND rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{this}})
{% endif %}
