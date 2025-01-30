SELECT productDim.product_class_id AS prodclass
      ,SUM(fmview.[amount]) AS salesProductClass
  FROM [FoodMart].[dbo].[sales_exam] AS fmview, [FoodMart].[dbo].[product] AS productDim
  WHERE fmview.product = productDim.brand_name
  GROUP BY productDim.product_class_id
  ORDER BY SUM(fmview.[amount]) DESC