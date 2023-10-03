-- a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

--created CTE that uses a UNION statement to stack both tables together since their column names are almost the same (aliasing where htey aren't)
WITH both_stores AS(SELECT name,
							 		 price::decimal,
							 		 rating,
					--the minimum price is 25000 so any game under 2.50 is 2500 otherwise it's multiplied by 10000
							 		 CASE WHEN price::decimal <= 2.50 THEN 25000 ELSE price::decimal*10000 END AS cost_to_buy,
							--since the longevity increases by six months with every quarter rating, i wanted to round each rating to the quarter. i used ceiling to round up and multipled the rating by four, so then i could divide that by 4 to get the closest quarter. the one outside of the parentheses is because we are starting with a baseline of one year. this would be 12 months. then i'm multiplying the rounded rating by two since my one is referring to a year . then multiplying this by 12 to bring it BACK to months. i don't think this is the most intuitive way to do it but i'm rolling with it. 
							 		 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months,
							         5000 AS monthly_revenue,
							   		 review_count::integer,
							 		 content_rating
							  FROM app_store_apps												 
							  WHERE price::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0
							 	AND review_count::integer > 100
							  UNION ALL
							  SELECT name,
							  		 price::money::decimal,
							  		 rating,
									 CASE WHEN price::money::decimal <= 2.50 THEN 25000 ELSE price::money::decimal*10000 END AS cost_to_buy,
							 		 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months,
							 		 5000 AS monthly_revenue,
							  		 review_count::integer,
							 		 content_rating
							  FROM play_store_apps
							  WHERE price::money::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0
								AND review_count::integer > 100)
				
SELECT content_rating,
	   COUNT(DISTINCT name),
	   SUM((monthly_revenue * longevity_months)-cost_to_buy) AS total_roi
FROM both_stores
WHERE name IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps)
GROUP BY content_rating
UNION 		   	    
(SELECT 	 				content_rating,
 							COUNT(DISTINCT name),
   							SUM((monthly_revenue * longevity_months)-cost_to_buy) AS total_roi
FROM both_stores
WHERE name NOT IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps)
 				GROUP BY content_rating
 			   LIMIT 2
			  )

LIMIT 50
;
-- b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.
WITH both_stores AS(SELECT name,
							 		 price::decimal,
							 		 rating,
							 		 CASE WHEN price::decimal <= 2.50 THEN 25000 ELSE price::decimal*10000 END AS cost_to_buy,
							 		 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months,
							         5000 AS monthly_revenue,
							   		 review_count::integer,
							 		 content_rating
							  FROM app_store_apps												 
							  WHERE price::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0
							 	AND review_count::integer > 100
							  UNION ALL
							  SELECT name,
							  		 price::money::decimal,
							  		 rating,
									 CASE WHEN price::money::decimal <= 2.50 THEN 25000 ELSE price::money::decimal*10000 END AS cost_to_buy,
							 		 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months,
							 		 5000 AS monthly_revenue,
							  		 review_count::integer,
							 		 content_rating
							  FROM play_store_apps
							  WHERE price::money::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0
								AND review_count::integer > 100)
				
SELECT DISTINCT *,
		(monthly_revenue * longevity_months)-cost_to_buy AS roi
FROM both_stores
WHERE name IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps)
UNION 		   	    
(SELECT DISTINCT *,
 				(monthly_revenue * longevity_months)-cost_to_buy AS roi
FROM both_stores
WHERE name NOT IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps)
			   ORDER BY review_count DESC NULLS LAST
 			   LIMIT 2
			  )
ORDER BY review_count DESC
;

-- c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for the upcoming Halloween themed campaign.

WITH both_stores AS(SELECT name,
							 		 price::decimal,
							 		 rating,
							 		 CASE WHEN price::decimal <= 2.50 THEN 25000 ELSE price::decimal*10000 END AS cost_to_buy,
							 		 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months,
							         5000 AS monthly_revenue,
							   		 review_count::integer,
							 		 content_rating
							  FROM app_store_apps												 
							  WHERE price::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0
							 	AND review_count::integer > 100
							  UNION ALL
							  SELECT name,
							  		 price::money::decimal,
							  		 rating,
									 CASE WHEN price::money::decimal <= 2.50 THEN 25000 ELSE price::money::decimal*10000 END AS cost_to_buy,
							 		 1+(ROUND(CEILING(rating * 4)/4, 2)*2) * 12 AS longevity_months,
							 		 5000 AS monthly_revenue,
							  		 review_count::integer,
							 		 content_rating
							  FROM play_store_apps
							  WHERE price::money::decimal <= 2.50
							  	AND ROUND(rating*4)/4 = 5.0
								AND review_count::integer > 100)
				
SELECT DISTINCT *,
		(monthly_revenue * longevity_months)-cost_to_buy AS roi
FROM both_stores
WHERE name IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps)
			   AND name ILIKE '%Halloween%'
			   OR name  ILIKE '%Zombie%'
			   OR name ILIKE '%ghost%'
			   OR name ILIKE '%pumpkin%'
			   OR name ILIKE '%bone%'
UNION 		   	    
(SELECT DISTINCT *,
 				(monthly_revenue * longevity_months)-cost_to_buy AS roi
FROM both_stores
WHERE name NOT IN (SELECT name
			   FROM app_store_apps
			   INTERSECT
			   SELECT name
			   FROM play_store_apps)
	AND name ILIKE '%Halloween%'
	OR name  ILIKE '%Zombie%'
 	OR name ILIKE '%ghost%'
    OR name ILIKE '%pumpkin%'
 	OR name ILIKE '%bone%'
			   ORDER BY review_count DESC NULLS LAST
			  )

ORDER BY review_count DESC
LIMIT 4;

-- c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.