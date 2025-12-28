select
  iff(m.genres ilike '%Animation%', true, false) as is_animated,
  count(*) as ratings_count,
  avg(r.rating) as avg_rating,
  count(distinct r.user_id) as users_count,
  count(distinct r.movie_id) as movies_rated
from {{ ref('fct_ratings') }} r
join {{ ref('dim_movies') }} m
  on m.movie_id = r.movie_id
group by 1
order by 1
