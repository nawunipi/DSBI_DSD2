WITH GroupByProductCustomerBasket AS (
SELECT product_id, customer_id, store_id, time_id
  FROM [FoodMart].[dbo].[sales_fact]
  GROUP BY product_id, customer_id, store_id, time_id),

Temp1_BasketCounter AS(
SELECT product_id, customer_id, store_id, time_id, 
DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY store_id ASC, time_id ASC) AS BasketCounterPerC
FROM GroupByProductCustomerBasket), 

-- First I must get the total basket number from each customer
-- Then I will count the basket with p_x for c_x (group by expression, so I can also do the math now?)
Temp2_TotalBasket AS(
SELECT product_id, customer_id, store_id, time_id, MAX(BasketCounterPerC) OVER(PARTITION BY customer_id) AS TotalBasketPerC
FROM Temp1_BasketCounter),

Temp3_CheckLikePerPC AS(
SELECT product_id, customer_id, CASE WHEN 100*COUNT(*)/MAX(TotalBasketPerC) >= 30 THEN 1 ELSE 0 END AS CLikesP
FROM Temp2_TotalBasket
GROUP BY product_id, customer_id)

SELECT product_id, SUM(CLikesP) AS customer_who_likes
FROM Temp3_CheckLikePerPC
GROUP BY product_id
ORDER BY customer_who_likes DESC, product_id ASC