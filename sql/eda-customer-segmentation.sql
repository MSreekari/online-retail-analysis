-- 6. Customer Segmentation 

SELECT * 
from retail_sales_cleaned;

-- 1. Find recency 
SELECT `customer id` AS customer_id, 
DATEDIFF(current_date(), MAX(invoicedate)) AS recency 
from retail_sales_cleaned 
GROUP BY `customer id` 
ORDER BY recency DESC;

-- 2. Find frequency 
SELECT `customer id` AS customer_id, 
COUNT(DISTINCT invoice) AS frequency  
from retail_sales_cleaned 
GROUP BY `customer id` 
ORDER BY frequency DESC;

-- 3. Find Monetary 
SELECT `customer id` AS customer_id, 
SUM(revenue) AS monetary  
from retail_sales_cleaned 
GROUP BY `customer id` 
ORDER BY monetary DESC; 

-- Using CTEs 
WITH rfm AS(
	SELECT `customer id` AS customer_id, 
    DATEDIFF(current_date(), MAX(invoicedate)) AS recency, 
    COUNT(DISTINCT invoice) AS frequency, 
    SUM(revenue) AS monetary 
    from retail_sales_cleaned 
    GROUP BY `customer id` 
    ORDER BY recency, frequency, monetary DESC
), 
rfm_quartiles AS(
	SELECT *, 
    NTILE(4) OVER(
		order by recency ASC 
    ) AS recency_quartile, 
    NTILE(4) OVER(
		order by frequency DESC 
    ) AS frequency_quartile, 
    NTILE(4) OVER(
		order by monetary DESC 
    ) AS monetary_quartile 
    from rfm 
), 
rfm_segments AS(
	SELECT *, 
    CASE 
		WHEN recency_quartile = 1 AND frequency_quartile = 4 AND monetary_quartile = 4 THEN 'VIP' 
        WHEN recency_quartile IN (1, 2) AND frequency_quartile >= 3 AND monetary_quartile >= 3 THEN 'Loyal'
        WHEN recency_quartile = 4 AND frequency_quartile <= 2 AND monetary_quartile <= 2 THEN 'At risk'
        WHEN recency_quartile = 4 AND frequency_quartile = 1 AND monetary_quartile = 1 THEN 'Lost'
	END AS segments 
    from rfm_quartiles
)
SELECT * 
from rfm_segments 
WHERE segments IS NOT NULL
ORDER BY recency_quartile;














































































































































































































































































































































































