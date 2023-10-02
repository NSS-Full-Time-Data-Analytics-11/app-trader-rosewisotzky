-- a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

-- b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

--this approach is using union all so we're looking at games in each table. going to try after this one that looks at games in both tables.
WITH both_stores_cte AS (SELECT 
						 name, 
						 rating, 
						 price::decimal, 
						 'app_store_apps' AS location, 
						 '5000.00' AS monthly_revenue,
						 content_rating, 
						 primary_genre,
						 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM app_store_apps
						 UNION ALL
						 SELECT 
						 	name, 
						 	rating, 
						 	price::money::decimal, 
						 	'play_store_apps' AS location,
						 	'5000.00' AS monthly_revenue,
						 	content_rating,
						 	genres AS primary_genre,
						    1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM play_store_apps)
SELECT *,
	   monthly_revenue::numeric * longevity_months::numeric AS profit
FROM both_stores_cte
ORDER BY profit DESC NULLS LAST
LIMIT 10;

--here's my query for games in both tables

WITH games_in_both_stores AS(SELECT name,
							 		 price::decimal,
							 		 rating,
							   		 review_count::integer,
							 		 content_rating
							  FROM app_store_apps												 
							  WHERE price::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0
							  UNION ALL
							  SELECT name,
							  		 price::money::decimal,
							  		 rating,
							  		 review_count::integer,
							 		 content_rating
							  FROM play_store_apps
							  WHERE price::money::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0),
 both_stores_cte AS (SELECT 
						 name, 
						 rating, 
						 price::decimal, 
						 'app_store_apps' AS location, 
						 '5000.00' AS monthly_revenue,
						 content_rating, 
						 primary_genre,
						 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM app_store_apps
						 UNION ALL
						 SELECT 
						 	name, 
						 	rating, 
						 	price::money::decimal, 
						 	'play_store_apps' AS location,
						 	'5000.00' AS monthly_revenue,
						 	content_rating,
						 	genres AS primary_genre,
						    1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM play_store_apps)
				
SELECT  name, 
		rating, 
		price::decimal, 
		'app_store_apps' AS location, 
		'5000.00' AS monthly_revenue,
		 content_rating, 
		 review_count::integer,
		 primary_genre,
		 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
FROM games_in_both_stores
WHERE name IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps);
			   
			   -- 

WITH  both_stores_cte AS (SELECT 
						 name, 
						 rating, 
						 price::decimal, 
						 'app_store_apps' AS location, 
						 '5000.00' AS monthly_revenue,
						 content_rating, 
						 review_count::integer,
						 primary_genre,
						 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM app_store_apps
						 UNION ALL
						 SELECT 
						 	name, 
						 	rating, 
						 	price::money::decimal, 
						 	'play_store_apps' AS location,
						 	'5000.00' AS monthly_revenue,
						 	content_rating,
						  	review_count::integer,
						 	genres AS primary_genre,
						    1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM play_store_apps)
SELECT DISTINCT name, 
				review_count,
				(monthly_revenue * longevity_months)-
FROM both_stores_cte
WHERE name NOT IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps)
ORDER BY review_count DESC;


SELECT * 
FROM app_store_apps
FULL JOIN play_store_apps USING(name)
-- c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for the upcoming Halloween themed campaign.



-- c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.