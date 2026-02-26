-- 3. Customer behaviour analysis 

SELECT * 
from retail_sales_cleaned;

-- 1. Most frequent customers by invoice id 
SELECT `customer id`,
COUNT(DISTINCT invoice) AS num_orders, 
SUM(revenue) AS total_revenue
from retail_sales_cleaned 
GROUP BY `customer id` 
ORDER BY num_orders DESC 
LIMIT 10;

-- 2. Average Order Value (AOV) per customer 
SELECT `customer id` AS customer_id, 
SUM(revenue) / COUNT(DISTINCT invoice) AS avg_order_value 
from retail_sales_cleaned 
GROUP BY `customer_id`
ORDER BY avg_order_value DESC;

-- 3. Top customers by revenue 
SELECT `customer id` AS customer_id, 
SUM(revenue) AS total_revenue, 
COUNT(DISTINCT invoice) AS total_count, 
ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS avg_order_value 
from retail_sales_cleaned
GROUP BY `customer id` 
ORDER BY total_revenue DESC 
LIMIT 10;

-- 4. Repeat Purchase Patterns 
SELECT `customer id` AS customer_id, 
SUM(revenue) AS total_revenue, 
COUNT(DISTINCT invoice) AS total_count, 
MIN(invoicedate) AS first_purchase, 
MAX(invoicedate) AS last_purchase, 
DATEDIFF(MAX(invoicedate), MIN(invoicedate)) AS active_days 
from retail_sales_cleaned 
GROUP BY `customer id` 
ORDER BY total_count DESC
LIMIT 10;

-- 5. Average time between orders 
SELECT `customer id` AS customer_id, 
SUM(revenue) AS total_revenue, 
COUNT(DISTINCT invoice) AS total_count, 
MIN(invoicedate) AS first_purchase, 
MAX(invoicedate) AS first_purchase, 
DATEDIFF(MAX(invoicedate), MIN(invoicedate)) AS active_days, 
CASE 
	WHEN COUNT(DISTINCT invoice) > 0 
    THEN DATEDIFF(MAX(invoicedate), MIN(invoicedate)) / (COUNT(DISTINCT invoice) - 1 )
    ELSE 0 
    END AS avg_time 
from retail_sales_cleaned 
GROUP BY `customer id` 
ORDER BY total_count DESC 
LIMIT 10;

-- 6. Country wise customer revenue 
SELECT `customer id` AS customer_id, 
SUM(revenue) AS total_revenue, 
COUNT(DISTINCT invoice) AS total_count, 
ROUND(SUM(revenue) / COUNT(DISTINCT `customer id`), 2) AS avg_per_customer 
from retail_sales_cleaned 
GROUP BY `customer id` 
ORDER BY avg_per_customer DESC 
LIMIT 10;








































































































