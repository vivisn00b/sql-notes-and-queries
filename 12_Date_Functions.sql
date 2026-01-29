/* ==============================================================================
   SQL Date & Time Functions
-------------------------------------------------------------------------------
   This script demonstrates various date and time functions in SQL.
   It covers functions such as GETDATE, DATETRUNC, DATENAME, DATEPART,
   YEAR, MONTH, DAY, EOMONTH, FORMAT, CONVERT, CAST, DATEADD, DATEDIFF,
   and ISDATE.
   
   Table of Contents:
     1. GETDATE, SYSDATETIME, CURRENT_TIMESTAMP, GETUTCDATE
     2. DATENAME, DATEPART, YEAR, MONTH, DAY, DATETRUNC
     3. EOMONTH
     4. DATEADD
     5. DATEDIFF
     6. CAST, CONVERT, FORMAT
     7. ISDATE 
===============================================================================
*/

/* ==============================================================================
   Getting Current Date/Time
===============================================================================*/
USE SalesDB;
GO

-- GETDATE()
SELECT 
    Sales.Orders.OrderID,
    '2026-01-31' AS HardCoded,
    GETDATE() AS CurrentDateTime
FROM Sales.Orders;

-- SYSDATETIME()
SELECT
    OrderID,
    '2026-01-31' AS HardCoded,
    GETDATE() AS CurrentDateTime,
    SYSDATETIME() AS CurrentDateTimeHighPrecision
FROM Sales.Orders;

-- CURRENT_TIMESTAMP(): ANSI SQL equivalent to GETADTE()               
SELECT
    OrderID,
    '2026-01-31' AS HardCoded,
    GETDATE() AS CurrentDateTime,
    SYSDATETIME() AS CurrentDateTimeHighPrecision,
    CURRENT_TIMESTAMP AS CurrentTimestamp
FROM Sales.Orders;

-- GETUTCDATE(): To get current date and time in UTC
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    GETUTCDATE() AS CurrentUTC
FROM Sales.Orders;

/* To see all orders created today */
SELECT OrderID, CustomerID, OrderDate, CreationTime
FROM Sales.Orders
WHERE CAST(CreationTime AS DATE) = CAST(GETDATE() AS DATE);

/* ==============================================================================
   Extracting Parts of a Date in SQL Server
===============================================================================*/
-- DATEPART(): Returns an integer value
SELECT OrderID,
       OrderDate,
       DATEPART(year, OrderDate) OrderYear,
       DATEPART(month, OrderDate) AS OrderMonth,
       DATEPART(day, OrderDate) AS OrderDay,
       DATEPART(quarter, OrderDate) AS OrderQuarter,
       DATEPART(week, OrderDate) AS OrderWeek
FROM Sales.Orders;

-- DATENAME(): Returns a string (nvarchar) value
SELECT OrderID,
       OrderDate,
       DATENAME(weekday, OrderDate) AS WeekDayName,
       DATENAME(month, OrderDate) AS MonthName,
       DATENAME(quarter, OrderDate) AS Quarter
FROM Sales.Orders;

-- YEAR(), MONTH(), DAY()
SELECT OrderID,
       OrderDate,
       YEAR(OrderDate) AS Yr,
       MONTH(OrderDate) AS Mo,
       DAY(OrderDate) AS Dy
FROM Sales.Orders;

-- DATETRUNC(): Truncates a date or datetime to a specified precision
/* Aggregate orders by year using DATETRUNC on CreationTime. */
SELECT DATETRUNC(year, CreationTime) AS Creation,
       COUNT(*) AS OrderCount
FROM Sales.Orders
GROUP BY DATETRUNC(year, CreationTime);

/* CreationTime column is DATETIME2 (has time). Extract hours, minutes, seconds */
SELECT OrderID,
       CreationTime,
       DATEPART(hour, CreationTime) AS HourOfCreation,
       DATEPART(minute, CreationTime) AS MinuteOfCreation,
       DATEPART(second, CreationTime) AS SecondOfCreation
FROM Sales.Orders;

/* Show orders by day of the week */
SELECT DATENAME(weekday, OrderDate) AS WeekDay,
       COUNT(*) AS OrderCount
FROM Sales.Orders
GROUP BY DATENAME(weekday, OrderDate);

/* Show all orders that were placed during the month of February. */
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2;

/* ==============================================================================
   EOMONTH()
===============================================================================*/
/* Display OrderID, CreationTime, and the end-of-month date for CreationTime. */
SELECT
    OrderID,
    CreationTime,
    EOMONTH(CreationTime) AS EndOfMonth
FROM Sales.Orders;

/* ==============================================================================
   Adding or Subtracting Dates
===============================================================================*/
-- DATEADD(): Primary function to add or subtract a specific time interval to a date
SELECT OrderID,
       OrderDate,
       DATEADD(day, -10, OrderDate) AS TenDaysBefore,
       DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
       DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM Sales.Orders;

/* Filters orders in the last 7 days dynamically. */
SELECT *
FROM Sales.Orders
WHERE OrderDate >= DATEADD(day, -7, GETDATE())

/* ==============================================================================
   Date Difference
===============================================================================*/
-- DATEDIFF(): Calculates the difference between two dates and returns an integer representing the number of intervals between them
/* Calculate the age of employees. */
SELECT EmployeeID,
       BirthDate,
       DATEDIFF(year, BirthDate, GETDATE()) AS Age
FROM Sales.Employees;

/* Find the average shipping duration in days for each month. */
SELECT MONTH(OrderDate) AS OrderMonth,
       AVG(DATEDIFF(day, OrderDate, ShipDate)) AS AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

/* Time Gap Analysis: Find the number of days between each order and the previous order. */
SELECT OrderID,
       OrderDate AS CurrentOrderDate,
       LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrderDate,
       DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) AS NrOfDays
FROM Sales.Orders;

/* ==============================================================================
   Converting Dates
===============================================================================*/
-- CAST()
SELECT CAST('123' AS INT) AS [String to Int],
       CAST(123 AS VARCHAR) AS [Int to String],
       CAST('2025-08-20' AS DATE) AS [String to Date],         -- Works only if format is ISO (yyyy-mm-dd)
       CAST('2025-08-20' AS DATETIME2) AS [String to Datetime],
       CreationTime,
       CAST(CreationTime AS DATE) AS [Datetime to Date]
FROM Sales.Orders;

-- CONVERT()
SELECT CONVERT(INT, '123') AS [String to Int CONVERT],
       CONVERT(DATE, '2025-08-20') AS [String to Date CONVERT],
       CreationTime,
       CONVERT(DATE, CreationTime) AS [Datetime to Date CONVERT],
       CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
       CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM Sales.Orders;

/*
| Style | Format                  | Example                 |
| ----- | ----------------------- | ----------------------- |
| 120   | yyyy-mm-dd hh:mm:ss     | 2026-01-25 14:30:45     |
| 121   | yyyy-mm-dd hh:mm:ss.mmm | 2026-01-25 14:30:45.123 |
| 101   | mm/dd/yyyy              | 01/25/2026              |
| 103   | dd/mm/yyyy              | 25/01/2026              |
| 112   | yyyymmdd                | 20260125                |
*/

-- FORMAT()
SELECT
    OrderID,
    CreationTime,
    FORMAT(CreationTime, 'MM-dd-yyyy') AS USA_Format,
    FORMAT(CreationTime, 'dd-MM-yyyy') AS EURO_Format,
    FORMAT(CreationTime, 'dd') AS dd,
    FORMAT(CreationTime, 'ddd') AS ddd,
    FORMAT(CreationTime, 'dddd') AS dddd,
    FORMAT(CreationTime, 'MM') AS MM,
    FORMAT(CreationTime, 'MMM') AS MMM,
    FORMAT(CreationTime, 'MMMM') AS MMMM
FROM Sales.Orders;

/* Display CreationTime using a custom format:
   Example: Day Wed Jan Q1 2025 12:34:56 PM */
SELECT OrderID,
       CreationTime,
       'Day ' + FORMAT(CreationTime, 'ddd MMM') +
       ' Q' + DATENAME(quarter, CreationTime) + ' ' +
       FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders;

/* How many orders were placed each year, formatted by month and year (e.g., "Jan 25")? */
SELECT FORMAT(CreationTime, 'MMM yy') AS OrderDate,
       COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY FORMAT(CreationTime, 'MMM yy');

/* ==============================================================================
   ISDATE()
===============================================================================*/
/* Validate OrderDate using ISDATE and convert valid dates. */
SELECT
    OrderDate,
    ISDATE(OrderDate) AS IsValidDate,
    CASE 
        WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
        ELSE '9999-01-01'
    END AS NewOrderDate
FROM (
    SELECT '2025-08-20' AS OrderDate UNION
    SELECT '2025-08-21' UNION
    SELECT '2025-08-23' UNION
    SELECT '2025-08'
) AS t