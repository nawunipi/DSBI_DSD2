WITH revbyproductyear AS 
(SELECT salesfact.product_id as product_id, timebyday.the_year as the_year, SUM(store_sales) AS store_revenue
  FROM [FoodMart].[dbo].[sales_fact] AS salesfact, [FoodMart].[dbo].[time_by_day] AS timebyday
  WHERE salesfact.time_id = timebyday.time_id
  GROUP BY salesfact.product_id, timebyday.the_year), 
laglead AS 
(SELECT product_id, the_year, store_revenue,
LAG(store_revenue, 1, 0) OVER(PARTITION BY product_id ORDER BY the_year) AS previousyear,
LEAD(store_revenue, 1, 0) OVER(PARTITION BY product_id ORDER BY the_year) AS followingyear
FROM revbyproductyear)
SELECT product_id, the_year, store_revenue, previousyear, followingyear,
CASE WHEN previousyear = 0 THEN 100 ELSE 100*(store_revenue-previousyear)/previousyear END AS deltafromprevyear, 
CASE WHEN store_revenue = 0 THEN 100 ELSE 100*(followingyear-store_revenue)/store_revenue END AS deltawithnextyear
FROM laglead
ORDER BY product_id, the_year