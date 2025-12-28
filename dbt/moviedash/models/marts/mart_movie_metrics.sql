select
  m.movie_id,
  m.movie_title,
  iff(m.genres ilike '%Animation%', true, false) as is_animated,
  count(*) as ratings_count,
  avg(r.rating) as avg_rating
from {{ ref('fct_ratings') }} r
join {{ ref('dim_movies') }} m
  on m.movie_id = r.movie_id
group by 1,2,3
