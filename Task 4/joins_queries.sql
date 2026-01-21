Create database ecommerce_dataset;
use ecommerce_dataset;

CREATE TABLE customer_loyalty (
    customer_id INT PRIMARY KEY,
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    loyalty_score DECIMAL(5,2)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    cateproductsgory VARCHAR(50),
    price DECIMAL(8,2),
    stock INT
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT,
    review_text VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product_category VARCHAR(50),
    order_value DECIMAL(8,2),
    payment_method VARCHAR(50),
    delivered TINYINT
);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customer_loyalty(customer_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_customer
FOREIGN KEY (customer_id)
REFERENCES customer_loyalty(customer_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

-- Orders combined with customer details
SELECT 
    p.product_id, 
    p.product_name, 
    SUM(o.order_value) AS total_revenue
FROM orders o
JOIN products p 
    ON o.product_category = p.category  -- Matches your CREATE statement
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- Category-wise revenue
SELECT 
    p.category AS category,
    SUM(o.order_value) AS category_revenue
FROM orders o
JOIN products p
ON o.product_category = p.category
GROUP BY p.category
ORDER BY category_revenue DESC;


-- Revenue per product (by category mapping)
SELECT 
    p.product_id,
    p.product_name,
    SUM(o.order_value) AS total_revenue
FROM orders o
JOIN products p
ON o.product_category = p.cateproductsgory
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- Category-wise revenue
SELECT 
    p.cateproductsgory AS category,
    SUM(o.order_value) AS category_revenue
FROM orders o
JOIN products p
ON o.product_category = p.cateproductsgory
GROUP BY p.cateproductsgory
ORDER BY category_revenue DESC;

-- Sales in a specific city and date range
SELECT 
    c.city,
    o.order_date,
    o.order_value
FROM orders o
JOIN customer_loyalty c
ON o.customer_id = c.customer_id
WHERE c.city = 'Mumbai'
AND o.order_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Aliases used consistently:
-- c → customers
-- o → orders
-- p → products
-- Queries are readable, scalable, professional

-- Final joined dataset for export
SELECT 
    o.order_id,
    c.customer_id,
    c.city,
    p.product_name,
    p.category AS category,
    o.order_value,
    o.order_date
FROM orders o
JOIN customer_loyalty c ON o.customer_id = c.customer_id
JOIN products p ON o.product_category = p.category;




