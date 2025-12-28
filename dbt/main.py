import streamlit as st
import snowflake.connector
import pandas as pd

st.set_page_config(page_title="MovieLens Results", layout="wide")

def conn():
    cfg = st.secrets["snowflake"]
    return snowflake.connector.connect(
        account=cfg["account"],
        user=cfg["user"],
        password=cfg["password"],
        role=cfg["role"],
        warehouse=cfg["warehouse"],
        database=cfg["database"],
        schema=cfg["schema"],
    )

@st.cache_data(ttl=600)
def df(sql: str) -> pd.DataFrame:
    c = conn()
    try:
        cur = c.cursor()
        cur.execute(sql)
        return cur.fetch_pandas_all()
    finally:
        c.close()

st.title("MovieLens: Animated vs Non-animated")

summary = df("""
select
  case when is_animated then 'Animated' else 'Non-animated' end as movie_type,
  ratings_count,
  avg_rating,
  users_count,
  movies_rated
from MART_ANIMATED_SUMMARY
order by movie_type;
""")

st.subheader("Summary")
st.dataframe(summary, use_container_width=True)

st.subheader("Ratings over time")
monthly = df("""
select
  month,
  case when is_animated then 'Animated' else 'Non-animated' end as movie_type,
  ratings_count
from MART_ANIMATED_MONTHLY
order by month, movie_type;
""")
pivot = monthly.pivot(index="MONTH", columns="MOVIE_TYPE", values="RATINGS_COUNT").fillna(0)
st.line_chart(pivot)

st.subheader("Top movies")
movie_type = st.selectbox("Movie type", ["Animated", "Non-animated"])
min_ratings = st.slider("Minimum ratings", 100, 10000, 2000, 100)

top = df(f"""
select
  movie_title,
  ratings_count,
  avg_rating
from MART_MOVIE_METRICS
where is_animated = {str(movie_type == "Animated").upper()}
  and ratings_count >= {int(min_ratings)}
order by avg_rating desc
limit 25;
""")
st.dataframe(top, use_container_width=True)
