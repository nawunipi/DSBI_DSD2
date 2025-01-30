SELECT 
CASE WHEN Grouping(pdim.product_class_id) = 1 THEN 0 ELSE pdim.product_class_id END AS ProductClass, 
CASE WHEN Grouping(pdim.brand_name) = 1 THEN 'SUBTOTAL' ELSE pdim.brand_name END AS Brand, fact.store_id AS store, sum(fact.store_sales) as Revenue 
  FROM [FoodMart].[dbo].[sales_fact] as fact, [FoodMart].[dbo].[product] as pdim
  WHERE fact.product_id = pdim.product_id
  GROUP BY CUBE(pdim.product_class_id, pdim.brand_name, fact.store_id)
ORDER BY pdim.product_class_id, pdim.brand_name, fact.store_id
