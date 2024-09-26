USE imdb;
/*
------------ Team Members --------------------
Jerin Joy P
Sujata Jha
Devpriya Jaiswal
*/ 

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

/* Using 'show tables;' we collected all table names of imdb schema 
 Then used performed individual queries on each table with count(*)
 and combined them using union all command */

select 'movie' as Table_name, count(*) row_cnt  from movie union all
select 'genre' as Table_name, count(*) row_cnt  from genre union all
select 'director_mapping' as Table_name, count(*) row_cnt  from director_mapping union all
select 'role_mapping' as Table_name, count(*) row_cnt  from role_mapping union all
select 'names' as Table_name, count(*) row_cnt  from names union all
select 'ratings' as Table_name, count(*) row_cnt  from ratings;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

/* Using 'DESC movie;' we collected all column names of table movie and used case staement */

select
sum(case when id is null then 1 else 0 end) as  null_cnt_id,
sum(case when title is null then 1 else 0 end) as  null_cnt_title,
sum(case when year is null then 1 else 0 end) as  null_cnt_year,
sum(case when date_published is null then 1 else 0 end) as  null_cnt_date_published,
sum(case when duration is null then 1 else 0 end) as  null_cnt_duration,
sum(case when country is null then 1 else 0 end) as  null_cnt_country,
sum(case when worlwide_gross_income is null then 1 else 0 end) as  null_cnt_worlwide_gross_income,
sum(case when languages is null then 1 else 0 end) as null_cnt_languages ,
sum(case when production_company is null then 1 else 0 end) as  null_cnt_production_company
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* We are using count, group by and order by for getting desired output */

select Year,count(id) Number_of_movies 
from movie 
group by year
order by year;
----------------------------------------

/* In addition to above for extracting numerical Month value we used month function */

select 
month(date_published) as Month_num, 
count(id) Number_of_movies 
from movie 
group by Month_num
order by Month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

/* Used In clause for filteration and Logical operator 'AND' for multiple filter conditions */

select Country, count(id) Number_of_movies from movie 
where country in ('India','USA') and Year = 2019
group by country;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

/* We used Distinct key word for desired output */

select distinct genre from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT Genre, COUNT(MOVIE_ID) Number_of_movies 
FROM GENRE 
GROUP BY GENRE 
ORDER BY Number_of_movies DESC 
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with movie_with_one_genre as(
select movie_id,count(genre) 
from genre 
group by movie_id 
having count(genre)=1) 
select count(movie_id) Cnt_movie_with_one_genre from movie_with_one_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select gen.Genre,avg(mov.duration) avg_duration 
from movie mov inner join genre gen on gen.movie_id=mov.id
group by gen.genre
order by avg_duration desc;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_rank as (
select genre, count(movie_id) movie_count , Rank() over w genre_rank
from genre
group by genre
window w as (
  order by count(movie_id) desc))
  select * from genre_rank where genre='Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
/*
 To find the minimum and maximum value min() and max() functions are used.
 As in the sample output avg_rating is not shown in decimals so using round() function for it.
 */
 
SELECT round(min(avg_rating)) AS min_avg_rating,
       round(max(avg_rating)) AS max_avg_rating,
       min(total_votes) AS min_total_votes,
       max(total_votes) AS max_total_votes,
       min(median_rating) AS min_median_rating,
       max(median_rating) AS max_median_rating
FROM ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

/*
 AS intructed DENSE_RANK() is used as we do not want to skip any movie.
 First movie_avg_rank CTE is created then the top 10 movie ranking is queried from it.
 */
 
WITH movie_avg_rank AS
(
SELECT mov.title,
       rate.avg_rating,
       DENSE_RANK() OVER(ORDER BY rate.avg_rating DESC) AS movie_rank
FROM movie AS mov
   INNER JOIN ratings AS rate
   ON mov.id= rate.movie_id
)
SELECT * 
FROM movie_avg_rank
WHERE movie_rank<=10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

/* We have used count() to find the number of movies under each median_rating.
 We have sorted the median rating in ascending order.
 */
SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

/* We have used the dense_rank() so that no information is skipped.
 Here max_hits_by CTE is created to give the movie counts with avg rating>8.
 From the CTE production company with rank=1 is queried. We can see there 
 are 2 production company with rank=1.
*/
WITH max_hits_by AS
(
SELECT mov.production_company ,
       COUNT(mov.id) AS movie_count,
       DENSE_RANK() OVER(ORDER BY COUNT(mov.id) DESC) AS prod_company_rank
FROM movie AS mov
    INNER JOIN ratings AS rate
     ON mov.id=rate.movie_id
WHERE mov.production_company IS NOT NULL AND rate.avg_rating >8
GROUP BY mov.production_company
)
SELECT * 
FROM max_hits_by
WHERE prod_company_rank=1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* To solve it we need genre, country,year and month of movie and votes
   from genre,movie and ratings respectively hence performed inner join on them.
   Added filter for country,year, month and total votes more than 1000.
*/

SELECT gen.genre AS genre,
	   COUNT(gen.movie_id) AS movie_count
FROM genre gen
    INNER JOIN movie mov
     ON gen.movie_id = mov.id
	INNER JOIN ratings rate
      ON mov.id= rate.movie_id
WHERE mov.country='USA' AND mov.year='2017' AND MONTH(mov.date_published)=3 AND rate.total_votes>1000
GROUP BY gen.genre 
ORDER BY COUNT(gen.movie_id) DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/*
To solve above query we need title,avg_rating,genre from tables movie,
genre,ratings respectively so performed inner join on them.
We have used LIKE operator to filter the movies starting with 'The'.
Movie names are repeating as same movie belongs to multiple genre.
*/
SELECT 
    mov.title, rate.avg_rating, gen.genre
FROM
    movie AS mov
        INNER JOIN
    ratings AS rate ON mov.id = rate.movie_id
        INNER JOIN
    genre AS gen ON mov.id = gen.movie_id
WHERE
    rate.avg_rating > 8 AND mov.title LIKE 'The%'
ORDER BY genre;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

/*We have used count() to find the number of movies with median_rating=8 and released between 1 April 2018 and 1 April 2019
*/
SELECT rate.median_rating,COUNT(mov.id) cnt_of_Movies
FROM movie AS mov
  INNER JOIN ratings AS rate
    ON mov.id=rate.movie_id
WHERE median_rating=8 AND (date_published BETWEEN '2018-04-01' AND '2019-04-01')
GROUP BY median_rating;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/*
We can find the no. of German movies and Italian movies using language column.
Then two CTEs are created to summarize at one place.
If condition is used to find whether the German movies have more votes or the Italian 
movies.
*/
WITH German_total_votes AS
(
SELECT sum(total_votes) AS German_votes
FROM movie AS mov
  INNER JOIN ratings AS rate
   ON mov.id=rate.movie_id
where languages like '%German%'
),
Italian_total_votes AS
(
SELECT sum(total_votes) AS Italian_votes
FROM movie AS mov
  INNER JOIN ratings AS rate
   ON mov.id=rate.movie_id
where languages like '%Italian%'
)
SELECT *,
   IF(German_votes > Italian_votes,'YES','NO') AS Are_German_movie_votes_more
FROM German_total_votes, Italian_total_votes;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_3_genres AS
(
SELECT genre,
Count(mov.id) AS movie_count ,
Rank() OVER(ORDER BY Count(mov.id) DESC) AS genre_rank
FROM movie AS mov
INNER JOIN genre AS gen
ON gen.movie_id = mov.id
INNER JOIN ratings AS rate
ON rate.movie_id = mov.id
WHERE avg_rating > 8
GROUP BY genre limit 3 )
SELECT nm.NAME AS director_name ,
Count(dir.movie_id) AS movie_count
FROM director_mapping AS dir
INNER JOIN genre G
using (movie_id)
INNER JOIN names AS nm
ON nm.id = dir.name_id
INNER JOIN top_3_genres
using (genre)
INNER JOIN ratings
using (movie_id)
WHERE avg_rating > 8
GROUP BY NAME
ORDER BY movie_count DESC limit 3 ;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT nm.name AS actor_name,
Count(rm.movie_id) AS movie_count
FROM role_mapping AS rm
INNER JOIN ratings AS rate USING(movie_id)
INNER JOIN names AS nm
ON nm.id = rm.name_id
WHERE rate.median_rating >= 8
AND upper(rm.category) = 'ACTOR'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT mov.production_company,
Sum(rate.total_votes) AS vote_count,
Rank() OVER(ORDER BY Sum(rate.total_votes) DESC) AS prod_comp_rank
FROM movie AS mov
INNER JOIN ratings AS rate
ON rate.movie_id = mov.id
GROUP BY production_company limit 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_summary
AS (SELECT nm.NAME AS actor_name,
sum(rate.total_votes) as total_votes,
Count(rate.movie_id) AS movie_count,
Round(Sum(rate.avg_rating * rate.total_votes) / Sum(rate.total_votes), 2) AS actor_avg_rating
FROM movie AS mv
INNER JOIN ratings AS rate
ON mv.id = rate.movie_id
INNER JOIN role_mapping AS rm
ON mv.id = RM.movie_id
INNER JOIN names AS nm
ON RM.name_id = nm.id
WHERE upper(rm.category) = 'ACTOR'
AND upper(mv.country) = "INDIA"
GROUP BY NAME
HAVING movie_count >= 5)
SELECT *,
Rank()
OVER(
ORDER BY actor_avg_rating desc,total_votes desc) AS actor_rank
FROM actor_summary;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS
(
SELECT nm.NAME AS actress_name,
sum(rate.total_votes) total_votes,
Count(rate.movie_id) AS movie_count,
Round(Sum(rate.avg_rating*rate.total_votes)/Sum(rate.total_votes),2) AS actress_avg_rating
FROM movie AS mv
INNER JOIN ratings AS rate
ON mv.id=rate.movie_id
INNER JOIN role_mapping AS rm
ON mv.id = rm.movie_id
INNER JOIN names AS nm
ON rm.name_id = nm.id
WHERE upper(category) = 'ACTRESS'
AND upper(country) = "INDIA"
AND upper(languages) LIKE '%HINDI%'
GROUP BY NAME
HAVING movie_count>=3 )
SELECT *,
Rank() OVER(ORDER BY actress_avg_rating DESC,total_votes desc) AS actress_rank
FROM actress_summary LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies
AS (SELECT DISTINCT mv.title,
rate.avg_rating
FROM movie AS mv
INNER JOIN ratings AS rate
ON rate.movie_id = mv.id
INNER JOIN genre AS gr using(movie_id)
WHERE upper(gr.genre)='THRILLER')
SELECT *,
CASE
WHEN avg_rating > 8 THEN 'Superhit movies'
WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
ELSE 'Flop movies'
END AS avg_rating_category
FROM thriller_movies
ORDER BY avg_rating desc;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select gen.genre, round(avg(mov.duration)) avg_duration, 
sum(round(avg(mov.duration),1)) over(order by gen.genre) running_total_duration, 
round(avg(round(avg(mov.duration),2)) over(order by gen.genre),2) moving_avg_duration
from genre gen inner join movie mov on mov.id=gen.movie_id
group by genre; 
-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
with 
genre_rank as (
	select genre, count(movie_id) movie_count , Rank() over w genre_rank
	from genre
	group by genre
	window w as (
	order by count(movie_id) desc)),  
movie_rank as (
	select g.genre,mv.year,mv.title movie_name,mv.worlwide_gross_income worldwide_gross_income,
	rank() over (partition by g.genre,mv.year  
	order by year,
	case when worlwide_gross_income like '%$%' then
	cast(trim(replace(worlwide_gross_income,'$','')) as float)
	when worlwide_gross_income like '%INR%' then
	round(cast(trim(replace(worlwide_gross_income,'INR','')) as float) / 82.9) end desc) as movie_rank -- 82.9 is the currency exchange rate as of Mar 1 2024
	from movie mv inner join genre g on mv.id=g.movie_id
	inner join genre_rank gr using(genre) 
	where gr.genre_rank <4 ) 
		select * from movie_rank 
		where movie_rank<6 
		order by genre,year,movie_rank;
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
with prod_comp_rank as(
select production_company, count(id) movie_count, 
dense_rank() over(order by count(id) desc) prod_comp_rank
from movie mv inner join ratings rt on mv.id=rt.movie_id
where production_company is not null
and POSITION(',' IN languages)>0
and rt.median_rating >=8
group by production_company)
select * from prod_comp_rank where prod_comp_rank<3;
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select 
	nm.name actress_name,
	sum(rt.total_votes) total_votes,
	count(rm.movie_id) movie_count,
	Round(Sum(rt.avg_rating*rt.total_votes)/Sum(rt.total_votes),2) actress_avg_rating,
	dense_rank() over(order by count(rm.movie_id) desc) actress_rank
from 
role_mapping rm
	inner join names nm on nm.id=rm.name_id
	inner join ratings rt using(movie_id)
	inner join genre gr using(movie_id)
where rt.avg_rating>8
and rm.category='actress'
and gr.genre='Drama'
group by nm.name;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with dr_frame as(
select 
	dr.name_id director_id, nm.name director_name, 
	dr.movie_id, mv.title, mv.date_published,
    coalesce(datediff(mv.date_published,
			lag(mv.date_published) 
			over(partition by dr.name_id 
			order by mv.date_published)),0) no_of_days,
	rt.avg_rating, rt.total_votes, mv.duration
from director_mapping dr 
inner join movie mv on mv.id=dr.movie_id
inner join ratings rt on rt.movie_id=mv.id
inner join names nm on nm.id=dr.name_id
order by director_id)
select 	director_id,director_name, count(movie_id) number_of_movies,
		avg(no_of_days) avg_inter_movie_days,avg(avg_rating) avg_rating,sum(total_votes) total_votes,
        min(avg_rating) min_rating,max(avg_rating) max_rating,sum(duration) total_duration
        from dr_frame
        group by director_id,director_name
        order by number_of_movies desc
        limit 9;
 






