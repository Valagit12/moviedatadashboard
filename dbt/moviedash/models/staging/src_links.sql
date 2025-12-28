WITH raw_links AS (
    SELECT * FROM MOVIELENS.RAW.RAW_LINKS
)
SELECT
    movieId as movie_id,
    imdbId AS imdb_id,
    tmdbId AS tmdbId,
FROM raw_links