

USE customer_analysis;


SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'orders',                   COUNT(*)               FROM orders;

-- Preview first 5 rows of each table
SELECT * FROM customers LIMIT 5;
SELECT * FROM orders    LIMIT 5;
