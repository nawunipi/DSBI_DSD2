-- ASSUMING I WANT TO ROLL UP by product and by brand
SELECT CASE WHEN Grouping(p.brand_name) = 1 THEN 'TOTAL' ELSE p.brand_name END AS BRAND, f.[product_id] AS PRODUCT, SUM(f.[store_sales]) AS REVENUE

  FROM [FoodMart].[dbo].[sales_fact] AS f, [FoodMart].[dbo].[product] as p
  WHERE f.product_id = p.product_id
  GROUP BY ROLLUP(p.[brand_name], f.[product_id])
  ORDER BY p.[brand_name] ASC, f.[product_id] ASC
 