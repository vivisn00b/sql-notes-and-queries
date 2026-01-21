/* ==============================================================================
   SQL Transaction Control Language (TCL)
-------------------------------------------------------------------------------
   This guide covers the commands used to manage transactions in SQL Server.
   Transactions ensure data integrity by controlling when changes are saved 
   or undone.

   Table of Contents:
     1. BEGIN TRANSACTION - Start a transaction
     2. COMMIT            - Save changes
     3. ROLLBACK          - Undo changes
     4. SAVEPOINT         - Partial rollback
=================================================================================
*/

/* ==============================================================================
   What is TCL?
=============================================================================== */
-- TCL is used to manage transactions in SQL Server, controlling when changes to the database are saved or undone.
-- Transactions ensure data integrity, especially in multi-step operations.

/* ==============================================================================
   1. BEGIN TRANSACTION
=============================================================================== */
-- Start a new transaction
BEGIN TRANSACTION;

-- Example: Increase customer score
UPDATE customers
SET score = score + 100
WHERE id = 1;


/* ==============================================================================
   2. COMMIT
=============================================================================== */
-- Save all changes made in the current transaction
COMMIT;


/* ==============================================================================
   3. ROLLBACK
=============================================================================== */
-- Start transaction
BEGIN TRANSACTION;

-- Example: Decrease customer score
UPDATE customers
SET score = score - 50
WHERE id = 2;

-- Undo changes if something goes wrong
ROLLBACK;


/* ==============================================================================
   4. SAVEPOINT (Partial Rollback)
=============================================================================== */
BEGIN TRANSACTION;

-- Step 1: Update customer 1
UPDATE customers
SET score = score + 50
WHERE id = 1;

-- Step 2: Savepoint
SAVE TRANSACTION step2;

-- Step 3: Update customer 2
UPDATE customers
SET score = score - 20
WHERE id = 2;

-- Undo only step 3
ROLLBACK TRANSACTION step2;

-- Commit remaining changes
COMMIT;
