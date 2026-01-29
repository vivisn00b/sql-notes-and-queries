/* ============================================================================== 
   SQL Server Number Functions Guide (SQL Server Specific Only)
-------------------------------------------------------------------------------
   This document covers numeric functions that are specific to, or commonly used
   in, Microsoft SQL Server (T-SQL).

   Table of Contents:
       1. Rounding & Truncation
          - ROUND
          - CEILING
          - FLOOR
       2. Sign & Absolute Value
          - ABS
          - SIGN
       3. Power, Root & Exponential
          - POWER
          - SQRT
       4. Random Numbers
          - RAND
       5. Type Conversion (T-SQL)
          - CONVERT
          - TRY_CONVERT
       6. NULL Handling (T-SQL)
          - ISNULL
       7. Mathematical Operators
          - Modulo (%)
       8. Aggregate Numeric Functions
          - COUNT
          - SUM
          - AVG
          - MIN
          - MAX
=================================================================================
*/

/* ============================================================================== 
   1. ROUNDING & TRUNCATION
=============================================================================== */

/* ROUND() - Round numbers */
SELECT 
    3.516 AS original_number,
    ROUND(3.516, 2) AS round_2,
    ROUND(3.516, 1) AS round_1,
    ROUND(3.516, 0) AS round_0

/* CEILING() - Round up */
SELECT 
    3.2 AS original_number,
    CEILING(3.2) AS ceiling_value

/* FLOOR() - Round down */
SELECT 
    3.8 AS original_number,
    FLOOR(3.8) AS floor_value

/* ============================================================================== 
   2. SIGN & ABSOLUTE VALUE
=============================================================================== */

/* ABS() - Absolute value */
SELECT 
    ABS(-10) AS abs_negative,
    ABS(10)  AS abs_positive

/* SIGN() - Returns -1, 0, or 1 */
SELECT 
    SIGN(-50) AS negative,
    SIGN(0)   AS zero,
    SIGN(25)  AS positive

/* ============================================================================== 
   3. POWER, ROOT & EXPONENTIAL
=============================================================================== */

/* POWER() - Raise to a power */
SELECT 
    POWER(5, 2) AS power_result

/* SQRT() - Square root */
SELECT 
    SQRT(81) AS square_root

/* ============================================================================== 
   4. RANDOM NUMBERS
=============================================================================== */

/* RAND() - Random number between 0 and 1 */
SELECT 
    RAND() AS random_value

/* RAND() with seed (repeatable results) */
SELECT 
    RAND(100) AS seeded_random

/* ============================================================================== 
   5. TYPE CONVERSION (T-SQL)
=============================================================================== */

/* CONVERT() - SQL Server specific conversion */
SELECT 
    CONVERT(DECIMAL(10,2), 123.4567) AS converted_decimal

/* TRY_CONVERT() - Safe conversion (returns NULL on failure) */
SELECT 
    TRY_CONVERT(INT, '123') AS valid_conversion,
    TRY_CONVERT(INT, 'ABC') AS invalid_conversion

/* ============================================================================== 
   6. NULL HANDLING (T-SQL)
=============================================================================== */

/* ISNULL() - Replace NULL value */
SELECT 
    ISNULL(discount, 0) AS discount_value
FROM orders

/* ============================================================================== 
   7. MATHEMATICAL OPERATORS
=============================================================================== */

/* Modulo operator */
SELECT 
    15 % 4 AS remainder

/* ============================================================================== 
   8. AGGREGATE NUMERIC FUNCTIONS (T-SQL)
=============================================================================== */

/* Core numeric aggregates */
SELECT
    COUNT(*)    AS total_rows,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount
FROM orders
