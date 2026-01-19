CREATE DATABASE retail_db;
USE retail_db;
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    customer_id VARCHAR(10),
    gender VARCHAR(10),
    age INT,
    product_category VARCHAR(50),
    quantity INT,
    price_per_unit INT,
    total_amount INT
);
-- View all records
SELECT * 
FROM retail_sales;

-- Count total records
SELECT COUNT(*) AS total_records 
FROM retail_sales;

-- Filter Electronics category
SELECT *
FROM retail_sales
WHERE product_category = 'Electronics';

-- Top 5 highest sales transactions
SELECT customer_id, product_category, total_amount
FROM retail_sales
ORDER BY total_amount DESC
LIMIT 5;

-- Total sales by product category
SELECT product_category, SUM(total_amount) AS total_sales
FROM retail_sales
GROUP BY product_category;

-- Average spending by gender
SELECT gender, AVG(total_amount) AS avg_spent
FROM retail_sales
GROUP BY gender;

-- Transaction count by product category
SELECT product_category, COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY product_category;

-- Categories with total sales greater than 2000
SELECT product_category, SUM(total_amount) AS total_sales
FROM retail_sales
GROUP BY product_category
HAVING SUM(total_amount) > 2000;

-- Transactions between February and April 2023
SELECT *
FROM retail_sales
WHERE transaction_date BETWEEN '2023-02-01' AND '2023-04-30';

-- Search customer IDs starting with CUST01
SELECT *
FROM retail_sales
WHERE customer_id LIKE 'CUST01%';

-- Sales summary for export
SELECT 
    product_category,
    SUM(quantity) AS total_quantity,
    SUM(total_amount) AS total_sales
FROM retail_sales
GROUP BY product_category;
