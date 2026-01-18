/* ==============================================================================
   SQL Server Data Definition Language (DDL)
-------------------------------------------------------------------------------
   This guide covers essential DDL commands for defining and managing
   database structures in SQL Server.
-------------------------------------------------------------------------------
   Queries Used in This Script
-------------------------------------------------------------------------------
   1. CREATE TABLE
      - Creates a new table with defined columns and a primary key constraint.

   2. ALTER TABLE ... ADD
      - Adds new columns or constraints to an existing table.

   3. ALTER TABLE ... DROP COLUMN
      - Removes a column from an existing table.

   4. CONSTRAINTS (PRIMARY KEY, UNIQUE, CHECK, DEFAULT)
      - Enforce data integrity rules such as uniqueness, validation, and
        default values.

   5. CREATE INDEX / DROP INDEX
      - Improves query performance by indexing columns used in searches.

   6. RENAME (sp_rename)
      - Renames tables or columns in SQL Server.

   7. TRUNCATE TABLE
      - Deletes all rows from a table without affecting the table structure.

   8. SCHEMA OPERATIONS
      - Creates schemas and moves database objects between schemas.

   9. DROP CONSTRAINT
      - Removes constraints from a table.

  10. DROP TABLE IF EXISTS
      - Safely deletes a table only if it exists.
================================================================================
*/

/* ==============================================================================
   CREATE
=============================================================================== */

-- Create a new table called persons
CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE NULL,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);
GO

/* ==============================================================================
   ALTER
=============================================================================== */

-- Add a new column called email
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;
GO

-- Remove the column phone
ALTER TABLE persons
DROP COLUMN phone;
GO

/* ==============================================================================
   CONSTRAINTS
=============================================================================== */

-- Add a UNIQUE constraint on email
ALTER TABLE persons
ADD CONSTRAINT uq_persons_email UNIQUE (email);
GO

-- CHECK constraint (LEN is used in SQL Server)
ALTER TABLE persons
ADD CONSTRAINT chk_phone_length
CHECK (LEN(phone) >= 10);
GO

-- Add a DEFAULT constraint (SQL Server requires a named constraint)
ALTER TABLE persons
ADD CONSTRAINT df_persons_birth_date
DEFAULT GETDATE() FOR birth_date;
GO

/* ==============================================================================
   INDEXES
=============================================================================== */

-- Create an index on person_name
CREATE INDEX idx_persons_name
ON persons (person_name);
GO

-- Drop the index
DROP INDEX idx_persons_name ON persons;
GO

/* ==============================================================================
   RENAME OPERATIONS
=============================================================================== */

-- Rename table (SQL Server uses sp_rename)
EXEC sp_rename 'persons', 'people';
GO

-- Rename column
EXEC sp_rename 'people.person_name', 'full_name', 'COLUMN';
GO

-- Rename index
EXEC sp_rename 
    'people.idx_people_name', 'idx_people_full_name', 'INDEX';

-- Rename Constraint
EXEC sp_rename 
    'people.pk_persons', 'pk_people', 'OBJECT';

/* ==============================================================================
   TRUNCATE
=============================================================================== */

-- Remove all records but keep structure
TRUNCATE TABLE people;
GO

/* ==============================================================================
   SCHEMA-LEVEL OPERATIONS
=============================================================================== */

-- Create a new schema
CREATE SCHEMA human_resources;
GO

-- Move table to another schema
ALTER SCHEMA human_resources
TRANSFER dbo.people;
GO

/* ==============================================================================
   DROP CONSTRAINTS
=============================================================================== */

-- Drop primary key constraint
ALTER TABLE human_resources.people
DROP CONSTRAINT pk_persons;
GO

-- Drop unique constraint
ALTER TABLE human_resources.people
DROP CONSTRAINT uq_persons_email;
GO

/* ==============================================================================
   DROP TABLE
=============================================================================== */

-- Drop table only if it exists
DROP TABLE IF EXISTS human_resources.people;
GO