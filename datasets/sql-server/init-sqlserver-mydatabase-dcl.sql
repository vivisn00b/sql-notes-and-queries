/* ==============================================================================
   SQL Server Users and Roles Setup
-------------------------------------------------------------------------------
   This guide shows how to create logins, database users, and roles
   so you can practice DCL (GRANT, REVOKE, DENY).
=================================================================================
*/

/* ==============================================================================
   1. Create a Login (Server-Level Access)
=============================================================================== */
-- Login allows a user to connect to SQL Server
-- Example: login for 'user1' with password 'User1@123'
CREATE LOGIN user1 WITH PASSWORD = 'User1@123';
CREATE LOGIN user2 WITH PASSWORD = 'User2@123';
CREATE LOGIN user3 WITH PASSWORD = 'User3@123';


/* ==============================================================================
   2. Create Database Users (Database-Level Access)
=============================================================================== */
-- Map the login to the database 'MyDatabase'
USE MyDatabase;
GO

-- Create database users
CREATE USER user1 FOR LOGIN user1;
CREATE USER user2 FOR LOGIN user2;
CREATE USER user3 FOR LOGIN user3;
CREATE USER user4 FOR LOGIN user4;


/* ==============================================================================
   3. Create a Role (Optional - Group Permissions)
=============================================================================== */
-- Create a role named 'SalesTeam'
CREATE ROLE SalesTeam;

-- Add users to the role
ALTER ROLE SalesTeam ADD MEMBER user1;
ALTER ROLE SalesTeam ADD MEMBER user2;
