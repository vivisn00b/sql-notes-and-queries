/* ==============================================================================
   SQL Data Control Language (DCL)
-------------------------------------------------------------------------------
   This guide covers the commands used to control access and permissions 
   on database objects in SQL Server.

   Table of Contents:
     1. GRANT  - Giving Permissions
     2. REVOKE - Removing Permissions
     3. DENY   - Explicitly Blocking Permissions
=================================================================================
*/

/* ==============================================================================
   What is DCL?
=============================================================================== */
-- DCL is used to control access and permissions on database objects.
-- It does not manipulate or query data, it manages security.

/* ==============================================================================
   1. GRANT
=============================================================================== */
-- Give user1 permission to SELECT data from the customers table
GRANT SELECT ON customers TO user1;

-- Give user2 permission to INSERT and UPDATE data in the orders table
GRANT INSERT, UPDATE ON orders TO user2;

-- Give a role 'SalesTeam' permission to SELECT and UPDATE
GRANT SELECT, UPDATE ON customers TO SalesTeam;


/* ==============================================================================
   2. REVOKE
=============================================================================== */
-- Remove SELECT permission from user1 on the customers table
REVOKE SELECT ON customers FROM user1;

-- Remove INSERT and UPDATE permissions from user2 on the orders table
REVOKE INSERT, UPDATE ON orders FROM user2;


/* ==============================================================================
   3. DENY
=============================================================================== */
-- Explicitly block DELETE permission for user3 on customers table
DENY DELETE ON customers TO user3;

-- Deny UPDATE permission for user4 on orders table
DENY UPDATE ON orders TO user4;