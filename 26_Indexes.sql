/* ==============================================================================
   SQL Indexing
-------------------------------------------------------------------------------
   This script demonstrates various index types in SQL Server including clustered,
   non-clustered, columnstore, unique, and filtered indexes. It provides examples 
   of creating a heap table, applying different index types, and testing their 
   usage with sample queries.

   Table of Contents:
	   Index Types:
			 - Clustered and Non-Clustered Indexes
			 - Leftmost Prefix Rule Explanation
			 - Columnstore Indexes
			 - Unique Indexes
			 - Filtered Indexes
=================================================================================
*/

/* ==============================================================================
   Clustered and Non-Clustered Indexes
============================================================================== */

-- Create a Heap Table as a copy of Sales.Customers 
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;

-- Test Query: Select Data and Check the Execution Plan
SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1;

-- Create a Clustered Index on Sales.DBCustomers using CustomerID
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

-- Attempt to create a second Clustered Index on the same table (will fail) 
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

-- Drop the Clustered Index 
DROP INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers;

-- Test Query: Select Data with a Filter on LastName
SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown';

-- Create a Non-Clustered Index on LastName
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName);

-- Create an additional Non-Clustered Index on FirstName
CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName);

-- Create a Composite (Composed) Index on Country and Score 
CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score);

-- Query that uses the Composite Index
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA'
  AND Score > 500;

-- Query that likely won't use the Composite Index due to column order
SELECT *
FROM Sales.DBCustomers
WHERE Score > 500
  AND Country = 'USA';

/* ==============================================================================
   Leftmost Prefix Rule Explanation
-------------------------------------------------------------------------------
   For a composite index defined on columns (A, B, C, D), the index can be
   utilized by queries that filter on:
     - Column A only,
     - Columns A and B,
     - Columns A, B, and C.
   However, queries that filter on:
     - Column B only,
     - Columns A and C,
     - Columns A, B, and D,
   will not be able to fully utilize the index due to the leftmost prefix rule.
=================================================================================
*/

/* ==============================================================================
   Columnstore Indexes
============================================================================== */

-- Create a Clustered Columnstore Index on Sales.DBCustomers
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers;
GO

-- Create a Non-Clustered Columnstore Index on the FirstName column
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName);
GO

-- Switch context to AdventureWorksDW2022 for FactInternetSales examples */
USE AdventureWorksDW2022;

-- Create a Heap Table from FactInternetSales
SELECT *
INTO FactInternetSales_HP
FROM FactInternetSales;

-- Create a RowStore Table from FactInternetSales
SELECT *
INTO FactInternetSales_RS
FROM FactInternetSales;

-- Create a Clustered Index (RowStore) on FactInternetSales_RS
CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber);

-- Create a Columnstore Table from FactInternetSales
SELECT *
INTO FactInternetSales_CS
FROM FactInternetSales;

-- Create a Clustered Columnstore Index on FactInternetSales_CS
CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS;

/* ==============================================================================
   Unique Indexes
============================================================================== */

-- Attempt to create a Unique Index on the Category column in Sales.Products.
   Note: This may fail if duplicate values exist.

CREATE UNIQUE INDEX idx_Products_Category
ON Sales.Products (Category);
  
-- Create a Unique Index on the Product column in Sales.Products
CREATE UNIQUE INDEX idx_Products_Product
ON Sales.Products (Product);
  
-- Test Insert: Attempt to insert a duplicate value (should fail if the constraint is enforced)
INSERT INTO Sales.Products (ProductID, Product)
VALUES (106, 'Caps');

/* ==============================================================================
   ROWSTORE INDEX
============================================================================== */
-- TASK: Create a clustered index (physical order of data)

CREATE CLUSTERED INDEX idx_Customers_Heap_CustomerID
ON Sales.Customers_Heap (CustomerID);

-- Query now uses Clustered Index Seek
SELECT *
FROM Sales.Customers_Heap
WHERE CustomerID = 1;

-- TASK: Create a non-clustered index on LastName

CREATE NONCLUSTERED INDEX idx_Customers_LastName
ON Sales.Customers_Heap (LastName);

-- Index Seek + Key Lookup
SELECT CustomerID, FirstName, LastName
FROM Sales.Customers_Heap
WHERE LastName = 'Brown';

-- TASK: Eliminate Key Lookups
CREATE NONCLUSTERED INDEX idx_Customers_LastName_Covering
ON Sales.Customers_Heap (LastName)
INCLUDE (FirstName, Country);

/* INCLUDE columns are used to cover queries by storing non-filtered columns
   at the leaf level of a nonclustered index. This eliminates key lookups
   without increasing the size or depth of the B-tree. */

-- No key lookup
SELECT FirstName, LastName, Country
FROM Sales.Customers_Heap
WHERE LastName = 'Brown';

/* ==============================================================================
   Filtered Indexes
============================================================================== */

-- Test Query: Select Customers where Country is 'USA' 
SELECT *
FROM Sales.Customers
WHERE Country = 'USA';
  
-- Create a Non-Clustered Filtered Index on the Country column for rows where Country = 'USA'
CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA';

/* ==============================================================================
   Index Monitoring
-------------------------------------------------------------------------------
     - List indexes and monitor their usage.
     - Report missing and duplicate indexes.
     - Retrieve and update statistics.
     - Check index fragmentation and perform index maintenance (reorganize/rebuild).
=================================================================================
*/