SELECT * 
from retail_2009;

SELECT * 
from retail_2010;

-- Combine both the tables retail_2009 and retail_2010 using union all
CREATE TABLE retail_combined AS 
SELECT * 
from retail_2009 
UNION ALL 
SELECT * 
from retail_2010;

SELECT * 
from retail_combined;

SELECT COUNT(*) 
from retail_combined;

-- Create a staging table 
CREATE TABLE retail_staging AS 
SELECT * 
from retail_combined;

SELECT * 
from retail_staging;

SELECT COUNT(*) 
from retail_staging;

-- Rename the column invoice 
ALTER TABLE retail_staging
RENAME COLUMN `ï»¿Invoice` TO Invoice;

-- Find out duplicate records using row_number() window function
SELECT * 
from (
	SELECT rs.*, 
    row_number() OVER(
		partition by Invoice, StockCode, `Description`, Quantity, InvoiceDate, Price, `Customer ID`, Country
    ) AS rn 
    from retail_staging AS rs 
) re_staging 
WHERE rn > 1; 

-- Create a new staging2 table excluding the duplicate records 
CREATE TABLE retail_staging2 AS 
SELECT * 
from (
	SELECT rs.*, 
    row_number() OVER(
		partition by Invoice, StockCode, `Description`, Quantity, InvoiceDate, Price, `Customer ID`, Country
    ) AS rn 
    from retail_staging AS rs 
) re_staging2 
WHERE rn = 1;

SELECT COUNT(*) 
from retail_staging2;

SELECT * 
from retail_staging2;

-- Find negative quantity records
SELECT COUNT(*) 
from retail_staging2 
WHERE quantity < 0;

-- Find records with with invoice starting from 'C' 
SELECT * 
from retail_staging2 
WHERE invoice LIKE 'c%';

-- Create a final cleaned table without duplicates, negative quantity and unwanted values 
CREATE TABLE retail_sales_cleaned AS 
SELECT * 
from retail_staging2 
WHERE quantity > 0 
AND invoice NOT LIKE 'c%';

-- Check if the table contains cleaned values 
SELECT * 
from retail_sales_cleaned 
WHERE quantity < 0 
AND invoice LIKE 'c%';

SELECT * 
from retail_sales_cleaned;

















