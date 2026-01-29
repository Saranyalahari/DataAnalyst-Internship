use ecommerce_dataset;
-- Create Dimension Tables (Primary Keys) 
CREATE TABLE Dim_Customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    loyalty_score DECIMAL(5,2)
);

CREATE TABLE Dim_Product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(8,2)
);

CREATE TABLE Dim_Date (
    date_key INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    year INT,
    month INT
);

CREATE TABLE Dim_Region (
    region_key INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(50)
);

-- Create Fact Table with Foreign Key
CREATE TABLE Fact_Sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_key INT,
    product_key INT,
    date_key INT,
    region_key INT,
    sales_amount DECIMAL(10,2),
    FOREIGN KEY (customer_key) REFERENCES Dim_Customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES Dim_Product(product_key),
    FOREIGN KEY (date_key) REFERENCES Dim_Date(date_key),
    FOREIGN KEY (region_key) REFERENCES Dim_Region(region_key)
);

-- Insert DISTINCT Values into Dimension Tables
INSERT INTO Dim_Customer (customer_id, gender, age, city, loyalty_score)
SELECT DISTINCT customer_id, gender, age, city, loyalty_score
FROM customer_loyalty;

INSERT INTO Dim_Product (product_id, product_name, category, price)
SELECT DISTINCT product_id, product_name, category, price
FROM products;

INSERT INTO Dim_Date (order_date, year, month)
SELECT DISTINCT order_date, YEAR(order_date), MONTH(order_date)
FROM orders;

INSERT INTO Dim_Region (city)
SELECT DISTINCT city
FROM customer_loyalty;

-- Insert Transactions into Fact Table
INSERT INTO Fact_Sales (customer_key, product_key, date_key, region_key, sales_amount)
SELECT
    dc.customer_key,
    dp.product_key,
    dd.date_key,
    dr.region_key,
    o.order_value
FROM orders o
JOIN Dim_Customer dc ON o.customer_id = dc.customer_id
JOIN Dim_Product dp ON o.product_category = dp.category
JOIN Dim_Date dd ON o.order_date = dd.order_date
JOIN Dim_Region dr ON dc.city = dr.city;

-- Create Indexes on Join Keys
CREATE INDEX idx_fact_customer ON Fact_Sales(customer_key);
CREATE INDEX idx_fact_product ON Fact_Sales(product_key);
CREATE INDEX idx_fact_date ON Fact_Sales(date_key);
CREATE INDEX idx_fact_region ON Fact_Sales(region_key);

-- Total Sales by Category
SELECT 
    dp.category,
    SUM(fs.sales_amount) AS total_sales
FROM Fact_Sales fs
JOIN Dim_Product dp ON fs.product_key = dp.product_key
GROUP BY dp.category;

-- Sales by Region
SELECT 
    dr.city,
    SUM(fs.sales_amount) AS total_sales
FROM Fact_Sales fs
JOIN Dim_Region dr ON fs.region_key = dr.region_key
GROUP BY dr.city;

-- Monthly Sales Trend
SELECT 
    dd.year,
    dd.month,
    SUM(fs.sales_amount) AS total_sales
FROM Fact_Sales fs
JOIN Dim_Date dd ON fs.date_key = dd.date_key
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;

SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM Fact_Sales;

SELECT *
FROM Fact_Sales
WHERE customer_key IS NULL
   OR product_key IS NULL
   OR date_key IS NULL
   OR region_key IS NULL;



