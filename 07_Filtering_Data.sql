/* ============================================================================== 
   SQL Filtering Data
-------------------------------------------------------------------------------
   This document provides an overview of SQL filtering techniques using WHERE 
   and various operators for precise data retrieval.

   Table of Contents:
     1. Comparison Operators
        - =, <>, >, >=, <, <=
     2. Logical Operators
        - AND, OR, NOT
     3. Range Filtering
        - BETWEEN
     4. Set Filtering
        - IN
     5. Pattern Matching
        - LIKE
=================================================================================
*/

/* ============================================================================== 
   COMPARISON OPERATORS
=============================================================================== */

-- Retrieve all customers from Germany.
SELECT *
FROM customers
WHERE country = 'Germany'

-- Retrieve all customers who are not from Germany.
SELECT *
FROM customers
WHERE country <> 'Germany'

-- Retrieve all customers with a score greater than 500.
SELECT *
FROM customers
WHERE score > 500

-- Retrieve all customers with a score of 500 or more.
SELECT *
FROM customers
WHERE score >= 500

-- Retrieve all customers with a score less than 500.
SELECT *
FROM customers
WHERE score < 500

-- Retrieve all customers with a score of 500 or less.
SELECT *
FROM customers
WHERE score <= 500

/* ============================================================================== 
   LOGICAL OPERATORS
=============================================================================== */

/* Combining conditions using AND, OR, and NOT */

-- Retrieve all customers who are from the USA and have a score greater than 500.
SELECT *
FROM customers
WHERE country = 'USA' AND score > 500

-- Retrieve all customers who are either from the USA or have a score greater than 500.
SELECT *
FROM customers
WHERE country = 'USA' OR score > 500

-- Retrieve all customers with a score not less than 500.
SELECT *
FROM customers
WHERE NOT score < 500

/* ============================================================================== 
   RANGE FILTERING - BETWEEN
=============================================================================== */

-- Retrieve all customers whose score falls in the range between 100 and 500.
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500

-- Alternative method (Equivalent to BETWEEN)
SELECT *
FROM customers
WHERE score >= 100 AND score <= 500

/* ============================================================================== 
   SET FILTERING - IN
=============================================================================== */

-- Retrieve all customers from either Germany or the USA.
SELECT *
FROM customers
WHERE country IN ('Germany', 'USA')

/* ============================================================================== 
   NULL Handling - IS NULL, IS NOT NULL
=============================================================================== */

-- Retrieve customers with no score
SELECT *
FROM customers
WHERE score IS NULL;

-- Retrieve customers with a score present
SELECT *
FROM customers
WHERE score IS NOT NULL;

/* ============================================================================== 
   NOT IN (Set Exclusion)
=============================================================================== */

-- Retrieve customers not from Germany or the USA
SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'USA');

/* ============================================================================== 
   NOT BETWEEN (Range Exclusion)
=============================================================================== */

-- Retrieve customers with scores outside the range 100–500
SELECT *
FROM customers
WHERE score NOT BETWEEN 100 AND 500;

/* ============================================================================== 
   EXISTS / NOT EXISTS (Subquery Filtering)
=============================================================================== */

-- Retrieve customers who have at least one order
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);

-- Retrieve customers with no orders
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
);

/* ============================================================================== 
   ANY / ALL
=============================================================================== */

-- Retrieve customers with a score higher than ANY customer from Germany
SELECT *
FROM customers
WHERE score > ANY (
    SELECT score
    FROM customers
    WHERE country = 'Germany'
);

-- Retrieve customers with a score higher than ALL customers from Germany
SELECT *
FROM customers
WHERE score > ALL (
    SELECT score
    FROM customers
    WHERE country = 'Germany'
);

/* ============================================================================== 
   PATTERN MATCHING - LIKE
=============================================================================== */

-- Find all customers whose first name starts with 'M'.
SELECT *
FROM customers
WHERE first_name LIKE 'M%'

-- Find all customers whose first name ends with 'n'.
SELECT *
FROM customers
WHERE first_name LIKE '%n'

-- Find all customers whose first name contains 'r'.
SELECT *
FROM customers
WHERE first_name LIKE '%r%'

-- Find all customers whose first name has 'r' in the third position.
SELECT *
FROM customers
WHERE first_name LIKE '__r%'

-- First name starts with A, B, or C
SELECT *
FROM customers
WHERE first_name LIKE '[ABC]%';

-- First name starts with any letter from A to M
SELECT *
FROM customers
WHERE first_name LIKE '[A-M]%';

-- First name does NOT start with a vowel
SELECT *
FROM customers
WHERE first_name LIKE '[^AEIOU]%';

/* ============================================================================== 
   OFFSET / FETCH
=============================================================================== */

-- Retrieve rows 11–20 ordered by score
SELECT *
FROM customers
ORDER BY score DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;