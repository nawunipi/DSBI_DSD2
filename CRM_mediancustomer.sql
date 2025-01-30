WITH Temp1 AS
(SELECT store_id, customer_id, SUM(store_sales) AS StoreSalesPerCust
FROM [FoodMart].[dbo].[sales_fact]
GROUP BY store_id, customer_id
),
Temp2 AS
(SELECT store_id, customer_id, DENSE_RANK() OVER(PARTITION BY store_id ORDER BY StoreSalesPerCust ASC) AS RankPerStore,
Count(customer_id) OVER(PARTITION BY store_id) AS NumCustPerStore
FROM Temp1),
Temp3 AS
(SELECT store_id, customer_id, RankPerStore, NumCustPerStore,
CASE WHEN NumCustPerStore%2=1 THEN (ROUND(NumCustPerStore/2,0))+1 
ELSE ROUND(NumCustPerStore/2,0) END AS MedianRankCustomer
FROM Temp2),

Temp4 AS
(SELECT store_id, customer_id, RankPerStore, MedianRankCustomer,
CASE WHEN RankPerStore = MIN(MedianRankCustomer) OVER(PARTITION BY store_id) THEN customer_id ELSE 0 END AS MedianCustomerID
FROM Temp3)

SELECT store_id, MedianCustomerID
FROM Temp4
WHERE MedianCustomerID != 0
ORDER BY store_id, rankperstore
