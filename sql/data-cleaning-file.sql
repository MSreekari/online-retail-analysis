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

-- Count the rows in the cleaned table
SELECT COUNT(*) 
from retail_sales_cleaned;

-- Add revenue column to the table 
ALTER TABLE retail_sales_cleaned 
ADD COLUMN revenue DECIMAL(10, 2);

-- Populate the column with revenue values 
UPDATE retail_sales_cleaned 
SET revenue = quantity * price;

-- Check the maximum and minimum revenue 
SELECT MAX(revenue) 
from retail_sales_cleaned;

SELECT MIN(revenue) 
from retail_sales_cleaned;

-- Convert the invoice date column to DATETIME 
SELECT InvoiceDate, str_to_date(InvoiceDate, '%m-%d-%Y %H:%i') AS invoice_date
from retail_sales_cleaned;

ALTER TABLE retail_sales_cleaned 
MODIFY COLUMN InvoiceDate DATETIME;

UPDATE retail_sales_cleaned 
SET InvoiceDate = str_to_date(InvoiceDate, '%d-%m-%Y %H:%i');

-- Check all the columns and ther type 
DESCRIBE retail_sales_cleaned;

-- Add time columns for analysis 
ALTER TABLE retail_sales_cleaned 
ADD COLUMN Order_year INT, 
ADD COLUMN Order_month INT, 
ADD COLUMN Order_day INT;

UPDATE retail_sales_cleaned 
SET Order_year = YEAR(InvoiceDate),
	Order_month = MONTH(InvoiceDate), 
    Order_day = DAY(InvoiceDate); 
    
SELECT * 
from retail_sales_cleaned;











