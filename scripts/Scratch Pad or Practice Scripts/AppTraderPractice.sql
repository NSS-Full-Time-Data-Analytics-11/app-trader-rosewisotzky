SELECT * 
FROM play_store_apps;

SELECT * 
FROM app_store_apps;

-- looking at genre, price, content, etc

WITH both_stores_cte AS (SELECT 
						 name, 
						 rating, 
						 price::decimal, 
						 'app_store_apps' AS location, 
						 '5000.00' AS monthly_revenue,
						 content_rating, 
						 primary_genre
						 FROM app_store_apps
						 UNION ALL
						 SELECT 
						 	name, 
						 	rating, 
						 	price::money::decimal, 
						 	'play_store_apps' AS location,
						 	'5000.00' AS monthly_revenue,
						 	content_rating,
						 	genres AS primary_genre
						 FROM play_store_apps)
SELECT name,
	 	price,
	   	ROUND(CEILING(rating * 4)/4, 2) AS rounded_rating,
		1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
-- 		CASE WHEN(content_rating = '4+' )

-- 		ROUND((CEILING(rating * 4)/4)*6)) AS longevity
FROM both_stores_cte
WHERE price = 0.00
GROUP BY ROLLUP(name, price, rating)
ORDER BY longevity_months DESC NULLS LAST, price;

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

WITH both_stores_cte AS (SELECT 
						 name, 
						 rating, 
						 price::decimal, 
						 'app_store_apps' AS location, 
						 '5000.00' AS monthly_revenue,
						 content_rating, 
						 primary_genre,
						 1+(ROUND(rating * 4)/4, 2)*2) * 12 AS longevity_months
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
						    1+(ROUND(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM play_store_apps)
SELECT primary_genre,
-- 	  CASE (WHEN price > 0 THEN price * 10000 ELSE 25000 END) AS cost_to_buy,
-- 	  (monthly_revenue::numeric * longevity_months::numeric) AS profit
FROM both_stores_cte
WHERE name ILIKE '%HALLOWEEN%'
ORDER BY profit DESC NULLS LAST
LIMIT 10;

-- 


--
SELECT *
FROM app_store_apps
WHERE name ILIKE ('%halloween%', '%zombie
				  
				  
				  
				  WITH  both_stores_cte AS (SELECT 
						 name, 
						 rating, 
						 price::decimal, 
						 'app_store_apps' AS location, 
						 5000.00 AS monthly_revenue,
						 CASE WHEN price::decimal = 0 THEN 25000 ELSE price::decimal*10000 END AS cost_to_buy,
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
						 	5000.00 AS monthly_revenue,
						    CASE WHEN price::money::decimal = 0 THEN 25000 ELSE price::money::decimal*10000 END AS cost_to_buy,
						 	content_rating,
						  	review_count::integer,
						 	genres AS primary_genre,
						    1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months
						 FROM play_store_apps)