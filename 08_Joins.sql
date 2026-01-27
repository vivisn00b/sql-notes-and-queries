/* ==============================================================================
   SQL Joins 
-------------------------------------------------------------------------------
   This document provides an overview of SQL joins, which allow combining data
   from multiple tables to retrieve meaningful insights.

   Table of Contents:
     1. Basic Joins
        - INNER JOIN
        - LEFT JOIN
        - RIGHT JOIN
        - FULL JOIN
        - SELF JOIN
     2. Advanced Joins
        - LEFT ANTI JOIN
        - RIGHT ANTI JOIN
        - ALTERNATIVE INNER JOIN
        - FULL ANTI JOIN
        - CROSS JOIN
        - SEMI JOIN
     3. Multiple Table Joins (4 Tables)
=================================================================================
*/

/* ============================================================================== 
   BASIC JOINS 
=============================================================================== */

-- No Join
/* Retrieve all data from customers and orders as separate results */
SELECT * FROM customers;
SELECT * FROM orders;

-- INNER JOIN
/* Get all customers along with their orders, but only for customers who have placed an order */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

-- LEFT JOIN
/* Get all customers along with their orders, including those without orders */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

-- RIGHT JOIN
/* Get all customers along with their orders, including orders without matching customers */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.customer_id,
    o.sales
FROM customers AS c 
RIGHT JOIN orders AS o 
ON c.id = o.customer_id

-- Alternative to RIGHT JOIN using LEFT JOIN
/* Get all customers along with their orders, including orders without matching customers */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders AS o 
LEFT JOIN customers AS c
ON c.id = o.customer_id

-- FULL JOIN
/* Get all customers and all orders, even if there’s no match */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.customer_id,
    o.sales
FROM customers AS c 
FULL JOIN orders AS o 
ON c.id = o.customer_id

-- SELF JOIN
/* Get all the employee and their corresponding manager */
SELECT
    e.EmployeeID,
    e.FirstName AS Employee,
    m.FirstName AS Manager
FROM Sales.Employees e
LEFT JOIN Sales.Employees m
    ON e.ManagerID = m.EmployeeID;


/* ============================================================================== 
   ADVANCED JOINS
=============================================================================== */

-- LEFT ANTI JOIN
/* Get all customers who haven't placed any order */
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

/* Using NOT EXISTS */
SELECT *
FROM Sales.Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- RIGHT ANTI JOIN
/* Get all orders without matching customers */
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL

/* Using NOT EXISTS */
SELECT *
FROM Sales.Orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Customers c
    WHERE o.CustomerID = c.CustomerID
);

-- Alternative to RIGHT ANTI JOIN using LEFT JOIN
/* Get all orders without matching customers */
SELECT *
FROM orders AS o 
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL

-- Alternative to INNER JOIN using LEFT JOIN
/* Get all customers along with their orders, but only for customers who have placed an order */
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL

-- FULL ANTI JOIN
/* Find customers without orders and orders without customers */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.customer_id,
    o.sales
FROM customers AS c 
FULL JOIN orders AS o 
ON c.id = o.customer_id
WHERE o.customer_id IS NULL OR c.id IS NULL

-- CROSS JOIN
/* Generate all possible combinations of customers and orders */
SELECT *
FROM customers
CROSS JOIN orders

-- SEMI JOIN
/* A semi join is a relational operation that returns rows from the left table for which at least one matching row exists in the right table, but it only returns the columns from the left table,
and importantly, it returns each matching left table row only once (duplicate-free). */
SELECT *
FROM Sales.Customers c
WHERE EXISTS (
    SELECT 1
    FROM Sales.Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- SEMI JOIN using INNER JOIN
SELECT DISTINCT c.*
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON o.CustomerID = c.CustomerID

-- SEMI JOIN using LEFT JOIN + IS NOT NULL
SELECT DISTINCT c.*
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
    ON o.CustomerID = c.CustomerID
WHERE o.CustomerID IS NOT NULL;

-- SEMI JOIN using IN (Works only if Orders.CustomerID has no NULLs)
SELECT *
FROM Sales.Customers c
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sales.Orders
    WHERE CustomerID IS NOT NULL   -- add this to be safe
)

/* ============================================================================== 
   MULTIPLE TABLE JOINS (4 Tables)
=============================================================================== */

/* Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, 
   and employee details. For each order, display:
   - Order ID
   - Customer's name
   - Product name
   - Sales amount
   - Product price
   - Salesperson's name */

USE SalesDB

SELECT 
    o.OrderID,
    o.Sales,
    c.FirstName AS CustomerFirstName,
    c.LastName AS CustomerLastName,
    p.Product AS ProductName,
    p.Price,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID

/* ============================================================================== 
   NATURAL JOIN (Why SQL Server Avoids It)
=============================================================================== */
-- SQL Server does not support NATURAL JOIN. Heer's why:
-- Implicit column matching
-- Breaks when schema changes
-- Dangerous in production