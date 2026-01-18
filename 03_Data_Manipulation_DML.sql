/* ==============================================================================
   SQL Data Manipulation Language (DML)
-------------------------------------------------------------------------------
   This guide covers the essential DML commands used for inserting, updating, 
   and deleting data in database tables.

   Table of Contents:
     1. INSERT - Adding Data to Tables
     2. UPDATE - Modifying Existing Data
     3. OUTPUT - Returns the rows affected by a DML operation
     4. MERGE - Synchronizes two tables by DML operations
     5. DELETE - Removing Data from Tables
=================================================================================
*/

/* ============================================================================== 
   INSERT
=============================================================================== */
/* #1 Method: Manual INSERT using VALUES */
-- Insert new records into the customers table
INSERT INTO customers (id, first_name, country, score)
VALUES 
    (6, 'Anna', 'USA', NULL),
    (7, 'Sam', NULL, 100)

-- Incorrect column order 
INSERT INTO customers (id, first_name, country, score)
VALUES 
    (8, 'Max', 'USA', NULL)
    
-- Incorrect data type in values
INSERT INTO customers (id, first_name, country, score)
VALUES 
	('Max', 9, 'Max', NULL)

-- Insert a new record with full column values
INSERT INTO customers (id, first_name, country, score)
VALUES (8, 'Max', 'USA', 368)

-- Insert a new record without specifying column names (not recommended)
INSERT INTO customers 
VALUES 
    (9, 'Andreas', 'Germany', NULL)
    
-- Insert a record with only id and first_name (other columns will be NULL or default values)
INSERT INTO customers (id, first_name)
VALUES 
    (10, 'Sahra')

/* #2 Method: INSERT DATA USING SELECT - Moving Data From One Table to Another */
-- Copy data from the 'customers' table into 'persons'
--INSERT INTO persons (id, person_name, birth_date, phone)
SELECT
    id,
    first_name,
    NULL,
    'Unknown'
FROM customers

-- INSERT USING SELECT - Create a backup table
SELECT *
INTO customers_backup
FROM customers

/* ============================================================================== 
   UPDATE
=============================================================================== */

-- Change the score of customer with ID 6 to 0
UPDATE customers
SET score = 0
WHERE id = 6

-- Change the score of customer with ID 10 to 0 and update the country to 'UK'
UPDATE customers
SET score = 0,
    country = 'UK'
WHERE id = 10

-- Update all customers with a NULL score by setting their score to 0
UPDATE customers
SET score = 0
WHERE score IS NULL

-- Verify the update
SELECT *
FROM customers
WHERE score IS NULL

/* ============================================================================== 
   OUTPUT
=============================================================================== */

-- Track updated scores
UPDATE customers
SET score = score + 10
OUTPUT
    deleted.score AS old_score,
    inserted.score AS new_score,
    inserted.first_name
WHERE country = 'UK';


/* ============================================================================== 
   MERGE
=============================================================================== */

-- New incoming customers table
CREATE TABLE new_customers (
    id INT,
    first_name VARCHAR(50),
    country VARCHAR(50),
    score INT
);

INSERT INTO new_customers VALUES
(2, 'John', 'USA', 950),
(7, 'Elena', 'Spain', 400)

-- Merge into customers
MERGE customers AS target
USING new_customers AS source
ON target.id = source.id

WHEN MATCHED THEN
    UPDATE SET
        target.first_name = source.first_name,
        target.country = source.country,
        target.score = source.score

WHEN NOT MATCHED THEN
    INSERT (id, first_name, country, score)
    VALUES (source.id, source.first_name, source.country, source.score);

/* ============================================================================== 
   DELETE
=============================================================================== */

-- Select customers with an ID greater than 5 before deleting
SELECT *
FROM customers
WHERE id > 5

-- Delete all customers with an ID greater than 5
DELETE FROM customers
WHERE id > 5

-- Delete all data from the persons table
DELETE FROM persons

-- Faster method to delete all rows, especially useful for large tables
TRUNCATE TABLE persons