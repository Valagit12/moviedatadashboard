WITH ratings AS (
    SELECT DISTINCT user_id FROM {{ ref('src_ratings')}}
),
tags AS (
    SELECT DISTINCT user_id FROM {{ ref('src_tags')}}
)
SELECT DISTINCT user_id
FROM (
    SELECT * from ratings
    UNION
    SELECT * FROM tags
)