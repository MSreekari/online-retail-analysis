-- 4. Country/Region sales analysis 

SELECT * 
from retail_sales_cleaned;

SELECT COUNT(DISTINCT country) AS country_count 
from retail_sales_cleaned;

-- 1. Revenue by country 
SELECT country, 
SUM(revenue) AS total_revenue 
from retail_sales_cleaned 
GROUP BY country  
ORDER BY total_revenue DESC;

-- 2. Average revenue per customer by country/region 
SELECT country, 
SUM(revenue) AS total_revenue, 
COUNT(DISTINCT `customer id`) AS orders_num, 
ROUND(SUM(revenue) / COUNT(DISTINCT `customer id`), 2) AS avg_revenue_per_customer 
from retail_sales_cleaned 
GROUP BY country 
ORDER BY avg_revenue_per_customer DESC; 

-- 3. Average Order Value per country 
SELECT country, 
SUM(revenue) AS total_revenue, 
COUNT(DISTINCT `customer id`) AS orders_num, 
ROUND(SUM(revenue) / COUNT(DISTINCT `customer id`), 2) AS avg_revenue_per_customer 
from retail_sales_cleaned 
GROUP BY country 
ORDER BY avg_revenue_per_customer DESC; 

-- 4. Country Revenue Quartiles 
WITH country_revenue AS(
	SELECT country, 
    SUM(revenue) AS total_revenue 
    from retail_sales_cleaned 
    GROUP BY country 
    ORDER BY total_revenue
)
SELECT *, 
NTILE(4) OVER(
	order by total_revenue 
) AS revenue_tier 
from country_revenue;



































































































































































































































































