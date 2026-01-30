/* ==============================================================================
   SQL Aggregate Functions
-------------------------------------------------------------------------------
   This document provides an overview of SQL aggregate functions, which allow 
   performing calculations on multiple rows of data to generate summary results.

   Table of Contents:
     1. Basic Aggregate Functions
        - COUNT
        - SUM
        - AVG
        - MAX
        - MIN
     2. Grouped Aggregations
        - GROUP BY
        - HAVING
     3. Additional Aggregate Concepts
        - DISTINCT
        - NULL Handling
        - Conditional Aggregation
        - Window Functions
        - STRING_AGG
=================================================================================
*/

USE SalesDB;
GO

/* ==============================================================================
   BASIC AGGREGATE FUNCTIONS
=============================================================================== */

-- Find the total number of customers
SELECT COUNT(*) AS total_customers
FROM Sales.Customers;

-- Find the total sales of all orders
SELECT SUM(sales) AS total_sales
FROM orders;

-- Find the average sales of all orders
SELECT AVG(sales) AS avg_sales
FROM orders;

-- Find the highest score among customers
SELECT MAX(score) AS max_score
FROM customers;

-- Find the lowest score among customers
SELECT MIN(score) AS min_score
FROM customers;


/* ==============================================================================
   GROUPED AGGREGATIONS - GROUP BY
=============================================================================== */

-- Find the number of orders, total sales, average sales, highest sales,
-- and lowest sales per customer
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    AVG(sales) AS avg_sales,
    MAX(sales) AS highest_sales,
    MIN(sales) AS lowest_sales
FROM orders
GROUP BY customer_id;


/* ==============================================================================
   FILTERING AGGREGATED RESULTS - HAVING
=============================================================================== */

-- Find customers with more than 5 orders
SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5;


/* ==============================================================================
   DISTINCT WITH AGGREGATES
=============================================================================== */

-- Count unique customers who placed orders
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;


/* ==============================================================================
   NULL HANDLING IN AGGREGATES
=============================================================================== */

-- COUNT(*) counts all rows, COUNT(column) ignores NULL values
SELECT
    COUNT(*) AS total_rows,
    COUNT(score) AS non_null_scores
FROM customers;

-- Handle NULL values explicitly
SELECT
    AVG(COALESCE(sales, 0)) AS avg_sales_with_nulls
FROM orders;


/* ==============================================================================
   CONDITIONAL AGGREGATION
=============================================================================== */

-- Count orders by status per customer
SELECT
    customer_id,
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = 'Shipped' THEN 1 ELSE 0 END) AS shipped_orders
FROM orders
GROUP BY customer_id;


/* ==============================================================================
   WINDOWED AGGREGATE FUNCTIONS
=============================================================================== */

-- Calculate total sales per customer without collapsing rows
SELECT
    order_id,
    customer_id,
    sales,
    SUM(sales) OVER (PARTITION BY customer_id) AS customer_total_sales
FROM orders;

-- Calculate overall average sales on every row
SELECT
    order_id,
    sales,
    AVG(sales) OVER () AS overall_avg_sales
FROM orders;

/* ==============================================================================
   STRING AGGREGATION (SQL Server 2017+)
=============================================================================== */

-- Combine all product names per order into a single string
SELECT
    o.OrderID,
    STRING_AGG(p.Product, ', ') AS Products
FROM Sales.Orders o
JOIN Sales.Products p
    ON o.ProductID = p.ProductID
GROUP BY o.OrderID;

/* For each customer, list the names of the products they bought (including repeats), in alphabetical order. */
SELECT
    o.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    STRING_AGG(p.Product, ', ')
        WITHIN GROUP (ORDER BY p.Product) AS ProductsOrdered     -- ensures alphabetical order
FROM Sales.Orders o
JOIN Sales.Customers c
    ON o.CustomerID = c.CustomerID
JOIN Sales.Products p
    ON o.ProductID = p.ProductID
GROUP BY
    o.CustomerID,
    c.FirstName,
    c.LastName;