select * from netflix;

-- 1. Count the number of Movies vs TV Shows 

select type, count(*) as total_content
from netflix
group by type;



-- 2. Find the most common rating for movies and TV shows

select type, rating
from(
	select type, rating,
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
	from netflix
	group by 1,2
) as t1
where 
	ranking = 1


	
-- 3. List all movies released in a specific year (e.g., 2829)

select *
from netflix
where type = 'Movie' 
	  and release_year = 2020 ;



-- 4. Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix	
group by new_country
order by 2 desc
limit 5;



-- 5. Identify the longest movie or TV show duration

select * from netflix
where type = 'Movie'
	  and
	  duration = (select max(duration) from netflix);



-- 6. Find content added in the last 5 years

select * from netflix
where
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years' ;



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director ilike '%Rajiv Chilaka%'



-- 8. List all TV shows with more than 5 seasons

select * from netflix
where type = 'TV Show'
	  and 
	  split_part(duration, ' ', 1)::numeric > 5 ;



-- 9. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by genre;



-- 10. Find each year and the average number of content release by India on netflix.
	   return top 5 year with highest average content release !

select
	extract(year from to_date(date_added, 'Month DD, YYYY')) as date,
	count(*) as yearly_content,
	round(
		count(*)::numeric / (select count(*) from netflix where country = 'India')::numeric * 100 ,2
	) as avg_content_per_year
from netflix
where country = 'India'
group by 1;



-- 11. List all movies that are documentaries

select * from netflix 
where listed_in ilike '%documentaries%';



-- 12. Find all content without a director

select * from netflix
where director is NULL 



-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where casts ilike '%Salman Khan%'
and 
release_year > extract(year from current_date) - 10 ;



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10;



-- 15. categorize the content based on the presence of the keyboards 'kill and violence' in
the description field. Label content containing these kaywords as 'Bad' and all other
content as 'Good' . Count how many items fall into each category. 

with new_table
as
(
select *,
case
	when
		description ilike '%kill%' or
		description ilike '%violence%' then 'Bad_Content'
	else 
		'Good_Content'
end category
from netflix
)
select 
	category,
	count(*) as total_content
from new_table
group by 1;





