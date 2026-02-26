-- 2. Product Performance Analysis 

-- 1. Top 10 products by revenue 
SELECT description AS product, 
SUM(revenue) AS total_revenue, 
SUM(quantity) AS total_units 
from retail_sales_cleaned 
GROUP BY product 
ORDER BY total_revenue DESC 
LIMIT 10;

-- 2. Top 10 products from units sold 
SELECT description AS product, 
SUM(revenue) AS total_revenue,
SUM(quantity) AS total_units 
from retail_sales_cleaned 
GROUP BY description 
ORDER BY total_units DESC 
LIMIT 10;

-- 3. Revenue contribution per product 
SELECT description AS product, 
SUM(revenue) AS total_revenue, 
ROUND(SUM(revenue) / (SELECT SUM(revenue) from retail_sales_cleaned) * 100, 2) AS revenue_per_product
from retail_sales_cleaned 
GROUP BY description 
ORDER BY total_revenue DESC;

-- 4. Revenue Quartiles per product 
WITH product_revenue AS(
	SELECT `description` AS product, 
	SUM(revenue) AS total_revenue, 
	ROUND(SUM(revenue) / (SELECT SUM(revenue) from retail_sales_cleaned) * 100, 2) AS revenue_per_product 
    from  retail_sales_cleaned 
    GROUP BY description
)
SELECT *, 
NTILE(4) OVER(
	order by total_revenue 
) AS revenue_quartile 
from product_revenue 
WHERE revenue_per_product > 0.0 
ORDER BY revenue_quartile, total_revenue DESC;

-- 5. Top 10 products by quantity - units sold 
SELECT `description` AS product, 
SUM(revenue) AS total_revenue, 
SUM(quantity) AS total_quantity 
from retail_sales_cleaned 
GROUP BY product 
ORDER BY total_quantity DESC 
LIMIT 10;














