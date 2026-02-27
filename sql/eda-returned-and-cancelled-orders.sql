-- 5. Cancelled Orders analysis 

-- The retail_staging2 table is used because it consists of the cancelled orders 
SELECT * 
from retail_staging2; 

-- 1. Find the total count of cancelled orders 
SELECT COUNT(invoice) AS cancelled_orders 
from retail_staging2 
WHERE invoice LIKE 'C%'; 

-- 2. Product-level cancellation rate 
CREATE VIEW cancellation_rate AS 
SELECT 
ROUND(
	COUNT(CASE 
		WHEN invoice LIKE 'C%' 
        THEN 1 
	END) / COUNT(*) * 100,
    2
) AS cancellation_rate 
from retail_staging2;

-- 3. Find the total count of cancelled orders by product 
SELECT `description` AS product, 
COUNT(invoice) AS total_count 
from retail_staging2 
WHERE quantity < 0 
GROUP BY `description`; 

-- 4. Revenue Lost due to returns 
SELECT 
ROUND(SUM(quantity * price), 2) AS revenue_lost 
from retail_staging2 
WHERE quantity < 0;

-- 5. Absolute of revenue lost due to returns 
SELECT 
ABS(ROUND(SUM(quantity * price), 2)) AS revenue_lost 
from retail_staging2 
WHERE quantity < 0;

-- 6. Products with highest returns 
SELECT `description` AS product, 
ABS(SUM(quantity)) AS return_nums 
from retail_staging2 
WHERE quantity < 0 
GROUP BY `description` 
ORDER BY return_nums DESC; 

-- 7. Order-level cancellation rate 
WITH total_returns AS(
	SELECT country, 
    COUNT(DISTINCT invoice) AS total_orders, 
    COUNT(
		CASE 
			WHEN invoice LIKE 'C%' 
            THEN invoice  
		END 
    ) AS cancelled_orders 
    from retail_staging2 
    GROUP BY country 
) 
SELECT country,
total_orders, 
cancelled_orders,  
ROUND(cancelled_orders / total_orders * 100, 2) AS cancellation_rate 
from total_returns 
WHERE cancelled_orders > 0
GROUP BY country 
ORDER BY cancellation_rate DESC;










































































































































































































