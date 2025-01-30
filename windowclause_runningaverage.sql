-- each store running average sale for each 4 month window, group by month
WITH temp1 AS(
SELECT f.[store_id] as store
      ,sum(f.[store_sales]) as revenue, (t.month_of_year) AS mymonth, t.the_year AS myyear

  FROM [FoodMart].[dbo].[sales_fact] as f, foodmart.dbo.time_by_day as t
  WHERE f.time_id = t.time_id
GROUP BY f.[store_id], t.month_of_year,  t.the_year
)
SELECT store, myyear, mymonth,revenue, SUM(revenue) OVER(PARTITION BY store ORDER BY myyear ASC, mymonth ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS RUNNINGSUM
FROM temp1
ORDER BY store, myyear, mymonth