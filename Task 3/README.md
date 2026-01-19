# Retail Sales SQL Analysis

## Dataset
Retail Sales Transactions dataset containing customer details, product categories, sales quantity, and total amount.

## Queries Written and Their Meaning

1. **SELECT * FROM retail_sales**
   - Displays all records in the table to understand the dataset structure and values.

2. **COUNT(*)**
   - Counts the total number of records to verify successful data import.

3. **WHERE product_category = 'Electronics'**
   - Filters and displays only transactions related to Electronics products.

4. **ORDER BY total_amount DESC LIMIT 5**
   - Retrieves the top 5 transactions with the highest total sales amount.

5. **SUM(total_amount) GROUP BY product_category**
   - Calculates total sales for each product category.

6. **AVG(total_amount) GROUP BY gender**
   - Finds the average amount spent by customers based on gender.

7. **COUNT(*) GROUP BY product_category**
   - Counts the number of transactions for each product category.

8. **HAVING SUM(total_amount) > 2000**
   - Filters product categories where total sales exceed 2000.

9. **BETWEEN '2023-02-01' AND '2023-04-30'**
   - Retrieves transactions that occurred between February and April 2023.

10. **LIKE 'CUST01%'**
    - Searches for customer IDs that start with a specific pattern.

11. **Sales Summary Query**
    - Generates a summarized report showing total quantity sold and total sales for each product category, which is exported as a CSV file.

## Output Files
- `queries_task3.sql` – Contains all SQL queries used for analysis  
- `sales_summary.csv` – Exported summary report of sales by product category
