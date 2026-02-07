/* ==============================================================================
   SQL Temporary Tables
-------------------------------------------------------------------------------
   This script provides a generic example of data migration using a temporary
   table. 
=================================================================================
*/

/* ==============================================================================
   Step 0: Idempotency Check
============================================================================== */
IF OBJECT_ID('Sales.OrdersTest', 'U') IS NOT NULL
    DROP TABLE Sales.OrdersTest;

/* ==============================================================================
   Step 1: Create Temporary Table (#Orders)
============================================================================== */
SELECT
    *
INTO #Orders
FROM Sales.Orders;
  
/* ==============================================================================
   Step 2: Clean Data in Temporary Table
============================================================================== */
-- Remove delivered orders
DELETE
FROM #Orders
WHERE OrderStatus = 'Delivered';

-- Remove invalid quantities
DELETE
FROM #Orders
WHERE Quantity <= 0;

-- Remove invalid sales
DELETE
FROM #Orders
WHERE Sales < 0;
  
  /* ==============================================================================
   Step 3: Deduplication (Keep Latest Record per OrderID)
============================================================================== */
WITH RankedOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY OrderID
               ORDER BY CreationTime DESC
           ) AS rn
    FROM #Orders
)
DELETE FROM RankedOrders
WHERE rn > 1;

/* ==============================================================================
   Step 4: Load Cleaned Data into Permanent Table (Sales.OrdersTest)
============================================================================== */
SELECT
    *
INTO Sales.OrdersTest
FROM #Orders;