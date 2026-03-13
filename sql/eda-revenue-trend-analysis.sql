-- Exploratory Data Analysis 

-- 1. Revenue & Trend Analysis 
SELECT * 
from retail_sales_cleaned;

-- 1. Total Revenue generated overall 
SELECT SUM(revenue) AS total_revenue 
from retail_sales_cleaned;

-- 2. Yearly Revenue 
SELECT order_year, SUM(revenue) AS yearly_revenue 
from retail_sales_cleaned 
GROUP BY order_year 
ORDER BY order_year;

-- 3. Monthly Revenue Trend 
CREATE VIEW monthly_trend AS 
SELECT order_year, order_month, SUM(revenue) AS monthly_revenue 
from retail_sales_cleaned 
GROUP BY order_year, order_month 
ORDER BY order_year, order_month;

-- 4. Average Monthly Revenue
SELECT order_year, order_month, AVG(revenue) AS avg_monthly_revenue 
from retail_sales_cleaned 
GROUP BY order_year, order_month 
ORDER BY order_year, order_month;  

-- 5. Cumulative Revenue 
WITH monthly_revenue AS (
	SELECT order_year, 
    order_month, 
    SUM(revenue) AS Monthly_revenue 
    from retail_sales_cleaned 
    group by order_year, order_month
) 
SELECT order_year, order_month, 
Monthly_revenue, 
SUM(Monthly_revenue) OVER(
	order by order_year, order_month
) AS cumulative_revenue 
from monthly_revenue 
ORDER BY order_year, order_month;































































