use ecommerce_dataset;
SELECT * FROM orders LIMIT 5;

-- Total sales per customer
SELECT 
    customer_id,
    SUM(order_value) AS total_sales
FROM orders
GROUP BY customer_id;

-- Rank customers by sales per region
SELECT
    c.city AS region,
    o.customer_id,
    SUM(o.order_value) AS total_sales,
    ROW_NUMBER() OVER (
        PARTITION BY c.city
        ORDER BY SUM(o.order_value) DESC
    ) AS row_num
FROM orders o
JOIN customer_loyalty c
ON o.customer_id = c.customer_id
GROUP BY c.city, o.customer_id;

-- Compare RANK and DENSE_RANK
SELECT
    c.city AS region,
    o.customer_id,
    SUM(o.order_value) AS total_sales,
    RANK() OVER (
        PARTITION BY c.city
        ORDER BY SUM(o.order_value) DESC
    ) AS sales_rank,
    DENSE_RANK() OVER (
        PARTITION BY c.city
        ORDER BY SUM(o.order_value) DESC
    ) AS dense_sales_rank
FROM orders o
JOIN customer_loyalty c
ON o.customer_id = c.customer_id
GROUP BY c.city, o.customer_id;

-- Running total of sales by date
SELECT
    order_date,
    order_value,
    SUM(order_value) OVER (
        ORDER BY order_date
    ) AS running_total_sales
FROM orders;

-- Monthly total sales
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(order_value) AS total_sales
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    month,
    total_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY month) AS mom_growth
FROM monthly_sales;

-- Top 3 products per category
WITH product_sales AS (
    SELECT p.category, p.product_name,
    SUM(o.order_value) AS total_sales,
    DENSE_RANK() OVER (PARTITION BY p.category ORDER BY SUM(o.order_value) DESC) AS rank_num
    FROM orders o
    JOIN products p ON o.product_category = p.category
    GROUP BY p.category, p.product_name
)
SELECT * FROM product_sales WHERE rank_num <= 3;



