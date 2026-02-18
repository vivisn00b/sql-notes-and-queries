/* ==============================================================================
   CTAS (CREATE TABLE AS SELECT) IN SQL SERVER
-------------------------------------------------------------------------------
   SQL Server does NOT support native CTAS syntax.
   Instead, it uses:
     1. SELECT INTO
     2. CREATE TABLE + INSERT INTO ... SELECT

   These patterns are critical for:
     - ETL pipelines
     - Staging layers
     - Fact & dimension creation
     - Archiving & snapshotting
     - Data transformations

   Table of Contents:
     1. SELECT INTO (Basic CTAS)
     2. CTAS with Filters
     3. CTAS with Aggregations
     4. CTAS with Joins
     5. CTAS with CTEs
     6. CTAS for Fact Tables
     7. CTAS for Dimension Tables
     8. CTAS for Archiving
     9. CTAS with Deduplication
    10. Production-Grade CTAS Patterns
=================================================================================
*/
USE SalesDB;
GO
/* ============================================================
   1. BASIC CTAS | SELECT INTO
   ============================================================ */

/* TASK:
   Create a full copy of the Orders table for staging purposes
*/

SELECT *
INTO Sales.Orders_Staging
FROM Sales.Orders;

/* ============================================================
   2. CTAS WITH FILTERING
   ============================================================ */

/* TASK:
   Create a table containing only Delivered orders
*/

SELECT *
INTO Sales.DeliveredOrders
FROM Sales.Orders
WHERE OrderStatus = 'Delivered';

/* ============================================================
   3. CTAS WITH AGGREGATION
   ============================================================ */

/* TASK:
   Create a Customer Sales Summary table
*/

SELECT
    CustomerID,
    COUNT(OrderID) AS TotalOrders,
    SUM(Sales) AS TotalSales
INTO Sales.CustomerSalesSummary
FROM Sales.Orders
GROUP BY CustomerID;

/* ============================================================
   4. CTAS WITH JOINS
   ============================================================ */

/* TASK:
   Create an enriched Orders table with customer and product details
*/

SELECT
    o.OrderID,
    o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.Product,
    p.Category,
    o.Quantity,
    o.Sales
INTO Sales.EnrichedOrders
FROM Sales.Orders o
JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
JOIN Sales.Products p ON o.ProductID = p.ProductID;

/* ============================================================
   5. CTAS USING CTEs
   ============================================================ */

/* TASK:
   Create a table showing high-value customers using a CTE
*/

WITH CustomerRevenue AS (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
SELECT *
INTO Sales.HighValueCustomers
FROM CustomerRevenue
WHERE TotalSales >= 100;

/* ============================================================
   6. CTAS FOR FACT TABLES
   ============================================================ */

/* TASK:
   Create a FactSales table (grain: Customer + Product)
*/

SELECT
    o.CustomerID,
    o.ProductID,
    SUM(o.Quantity) AS TotalQuantity,
    SUM(o.Sales) AS TotalSales
INTO Sales.FactSales
FROM Sales.Orders o
GROUP BY
    o.CustomerID,
    o.ProductID;

/* ============================================================
   7. CTAS FOR DIMENSION TABLES
   ============================================================ */

/* TASK:
   Create a Customer Dimension table
*/

SELECT DISTINCT
    CustomerID,
    FirstName,
    LastName,
    Country,
    Score
INTO Sales.DimCustomer
FROM Sales.Customers;

/* ============================================================
   8. CTAS FOR ARCHIVING DATA
   ============================================================ */

/* TASK:
   Archive orders older than 2025 into a history table
*/

SELECT *
INTO Sales.Orders_2024
FROM Sales.OrdersArchive
WHERE OrderDate < '2025-01-01';

/* ============================================================
   9. CTAS WITH DEDUPLICATION
   ============================================================ */

/* TASK:
   Remove duplicate orders from OrdersArchive
   (keep the latest CreationTime)
*/

WITH RankedOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY OrderID
               ORDER BY CreationTime DESC
           ) AS rn
    FROM Sales.OrdersArchive
)
SELECT
    OrderID,
    ProductID,
    CustomerID,
    SalesPersonID,
    OrderDate,
    ShipDate,
    OrderStatus,
    ShipAddress,
    BillAddress,
    Quantity,
    Sales,
    CreationTime
INTO Sales.OrdersArchive_Deduped
FROM RankedOrders
WHERE rn = 1;

/* ============================================================
   10. PRODUCTION-GRADE CTAS PATTERN (BEST PRACTICE)
   ============================================================ */

/* TASK:
   Create a properly defined Fact table with schema control
*/

CREATE TABLE Sales.FactSales_Final (
    CustomerID INT,
    ProductID INT,
    TotalQuantity INT,
    TotalSales INT
);

INSERT INTO Sales.FactSales_Final
SELECT
    CustomerID,
    ProductID,
    SUM(Quantity),
    SUM(Sales)
FROM Sales.Orders
GROUP BY CustomerID, ProductID;