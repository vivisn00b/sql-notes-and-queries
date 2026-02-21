/* ==============================================================================
   SQL Indexing
-------------------------------------------------------------------------------
   This script demonstrates various index types in SQL Server including clustered,
   non-clustered, columnstore, unique, and filtered indexes. It provides examples 
   of creating a heap table, applying different index types, and testing their 
   usage with sample queries.

   Table of Contents:
	   Index Monitoring:
			 - Monitor Index Usage
			 - Monitor Missing Indexes
			 - Monitor Duplicate Indexes
			 - Update Statistics
			 - Fragmentations
=================================================================================
*/

/* ==============================================================================
     - List indexes and monitor their usage.
     - Report missing and duplicate indexes.
     - Retrieve and update statistics.
     - Check index fragmentation and perform index maintenance (reorganize/rebuild).
=================================================================================
*/

/* ==============================================================================
   Monitor Index Usage
============================================================================== */

-- List all indexes on a specific table
sp_helpindex 'Sales.Customers'

-- Monitor Index Usage
SELECT 
	tbl.name AS TableName,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    idx.is_primary_key AS IsPrimaryKey,
    idx.is_unique AS IsUnique,
    idx.is_disabled AS IsDisabled,
    s.user_seeks AS UserSeeks,
    s.user_scans AS UserScans,
    s.user_lookups AS UserLookups,
    s.user_updates AS UserUpdates,
    COALESCE(s.last_user_seek, s.last_user_scan) AS LastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
    ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
    ON s.object_id = idx.object_id
    AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;

/* ==============================================================================
   Monitor Missing Indexes
============================================================================== */

SELECT * 
FROM sys.dm_db_missing_index_details;

/* ==============================================================================
   Monitor Duplicate Indexes
============================================================================== */

SELECT  
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	COUNT(*) OVER (PARTITION BY  tbl.name , col.name ) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC

/* ==============================================================================
   Update Statistics
============================================================================== */

SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated AS LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables AS t
    ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC;

-- Update statistics for a specific automatically created system statistic
UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000001_6EF57B66;
GO

-- Update all statistics for the Sales.DBCustomers table
UPDATE STATISTICS Sales.DBCustomers;
GO

-- Update statistics for all tables in the database
EXEC sp_updatestats;
GO

/* ==============================================================================
   Fragementations
============================================================================== */

-- Retrieve index fragmentation statistics for the current database
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl 
    ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx 
    ON idx.object_id = s.object_id
    AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- Reorganize the index (lightweight defragmentation)
ALTER INDEX idx_Customers_CS_Country 
ON Sales.Customers REORGANIZE;
GO

-- Rebuild the index (full rebuild, more resource-intensive)
ALTER INDEX idx_Customers_Country 
ON Sales.Customers REBUILD;
GO