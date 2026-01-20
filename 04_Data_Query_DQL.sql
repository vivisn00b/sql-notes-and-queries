/* ==============================================================================
   SQL Data Query Language (DQL)
-------------------------------------------------------------------------------
   This guide covers the SELECT statement used to retrieve data
   from database tables without modifying the data.

   Table of Contents:
     1. SELECT   - Retrieving Data
     2. WHERE    - Filtering Data
     3. DISTINCT - Removing Duplicate Values
     4. ORDER BY - Sorting Results
     5. TOP      - Limiting Rows
     6. GROUP BY - Grouping Data
     7. HAVING   - Filtering Groups
     8. JOIN     - Combining Tables
=================================================================================
*/

/* ==============================================================================
   1. SELECT
=============================================================================== */
-- Retrieve all columns from customers
SELECT *
FROM customers;

-- Retrieve specific columns
SELECT first_name, country, score
FROM customers;


/* ==============================================================================
   2. WHERE
=============================================================================== */
-- Filter customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';

-- Filter customers with score greater than 500
SELECT *
FROM customers
WHERE score > 500;


/* ==============================================================================
   3. DISTINCT
=============================================================================== */
-- Retrieve unique countries
SELECT DISTINCT country
FROM customers;


/* ==============================================================================
   4. ORDER BY
=============================================================================== */
-- Sort customers by score (highest first)
SELECT *
FROM customers
ORDER BY score DESC;


/* ==============================================================================
   5. TOP
=============================================================================== */
-- Retrieve top 3 customers by score
SELECT TOP 3 *
FROM customers
ORDER BY score DESC;


/* ==============================================================================
   6. GROUP BY
=============================================================================== */
-- Count customers per country
SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country;


/* ==============================================================================
   7. HAVING
=============================================================================== */
-- Countries with average score greater than 500
SELECT country, AVG(score) AS avg_score
FROM customers
GROUP BY country
HAVING AVG(score) > 500;


/* ==============================================================================
   8. JOIN
=============================================================================== */
-- Retrieve customer names with their order details
SELECT c.first_name, o.order_id, o.sales
FROM customers c
JOIN orders o
ON c.id = o.customer_id;
