CREATE DATABASE movies_imdb;
USE movies_imdb;

CREATE TABLE movies_data
(
ranking INT,
title VARCHAR(100),
release_year INT, 
runtime INT,
genre VARCHAr(60),
ratings FLOAT,
director VARCHAR(100),
votes BIGINT,
gross_revenue FLOAT
);

ALTER TABLE movies_data MODIFY COLUMN runtime VARCHAR(10);
ALTER TABLE movies_data MODIFY COLUMN gross_revenue BIGINT;

SELECT * FROM movies_data;

-- Data Exploration

SELECT COUNT(*) AS total_movies FROM movies_data;
SELECT * FROM movies_data LIMIT 10;

-- Checking for any missing value
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN ranking IS NULL THEN 1 ELSE 0 END) AS missing_ranking,
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS missing_title,
  SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS missing_release_year,
  SUM(CASE WHEN runtime IS NULL THEN 1 ELSE 0 END) AS missing_runtime,
  SUM(CASE WHEN genre IS NULL THEN 1 ELSE 0 END) AS missing_genre,
  SUM(CASE WHEN ratings IS NULL THEN 1 ELSE 0 END) AS missing_ratings,
  SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS missing_director,
  SUM(CASE WHEN votes IS NULL THEN 1 ELSE 0 END) AS missing_votes,
  SUM(CASE WHEN gross_revenue IS NULL THEN 1 ELSE 0 END) AS missing_gross_revenue
FROM MOVIES_DATA;


-- Counting miovies per year
SELECT release_year, COUNT(*) AS movie_count
FROM movies_data
GROUP BY release_year
ORDER BY movie_count DESC;

-- Best Director  
SELECT director,count(*) as best_director
FROM movies_data
WHERE ratings>=8
GROUP BY director
ORDER BY best_director DESC
LIMIT 5;

-- TOP 10 longest movies

SELECT title, runtime
FROM movies_data
ORDER BY CAST(REPLACE(runtime, 'min', '') AS UNSIGNED) DESC
LIMIT 10;
-- here i have to convert the runtime value to number

-- most common genres
SELECT genre,COUNT(*) as count
FROM movies_data
GROUP BY genre 
ORDER BY count DESC
LIMIT 10;

SELECT title,ratings
FROM movies_data
WHERE ratings>=8
LIMIT 10;

-- Most voted movies

SELECT title,votes
FROM movies_data
ORDER BY votes DESC
LIMIT 10;

-- Directors with most movies

SELECT director,COUNT(*) AS count
FROM movies_data
GROUP BY director
ORDER BY count DESC
LIMIT 10;

-- average revenue by genre

SELECT genre, ROUND(AVG(gross_revenue),2) as average_revenue
FROM movies_data
GROUP BY genre
ORDER BY average_revenue DESC
limit 10;
 
 
 -- putting(bucket) movies based on runtime
 
 WITH runtime_categors AS
  (
  SELECT title,
  runtime,
  CASE
	WHEN runtime<90 THEN 'Short'
    WHEN runtime>=90 AND runtime< 120 THEN 'Medium'
    WHEN runtime>=120 THEN 'LONG'
END AS runtime_bucket
FROM movies_data
)
SELECT runtime_bucket,COUNT(*) AS movie_total
FROM runtime_categors
GROUP BY runtime_bucket;

-- Top 10 grossing movies

SELECT title,gross_revenue AS gross_usd
FROM movies_data
ORDER BY gross_usd DESC
LIMIT 10;

-- Top genres by average rating

WITH top_genre AS
(
SELECT genre,
COUNT(*) AS total_movies,
ROUND(AVG(ratings),2) AS average_rating
FROM movies_data
GROUP BY genre
HAVING COUNT(*) >10
)
SELECT *
FROM top_genre
ORDER BY average_rating DESC;

SELECT * FROM movies_data;