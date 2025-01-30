WITH Temp AS (SELECT [customer_id], [store_id], SUM([store_sales])/SUM(SUM([store_sales])) OVER(PARTITION BY [customer_id]) AS Ratio
FROM [FoodMart].[dbo].[sales_fact]
GROUP BY [customer_id], [store_id])

SELECT [store_id], 
SUM(CASE WHEN Ratio > .5 THEN 1 ELSE 0 END) AS NumMainCustomer
FROM Temp
GROUP BY [store_id]
ORDER BY [store_id]