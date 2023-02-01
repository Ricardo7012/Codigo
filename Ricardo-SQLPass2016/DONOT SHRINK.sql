/*******************************************************************************
http://www.sqlskills.com/BLOGS/PAUL/post/Why-you-should-not-shrink-your-data-files.aspx
*******************************************************************************/

USE MASTER;
GO 

IF DATABASEPROPERTYEX ('DBMaint2008', 'Version') > 0
 DROP DATABASE DBMaint2008; 

CREATE DATABASE DBMaint2008;
GO
USE DBMaint2008;
GO 

SET NOCOUNT ON;
GO 

-- Create the 10MB filler table at the 'front' of the data file
CREATE TABLE FillerTable (c1 INT IDENTITY,  c2 CHAR (8000) DEFAULT 'filler');
GO 

-- Fill up the filler table
INSERT INTO FillerTable DEFAULT VALUES;
GO 1280 

-- Create the production table, which will be 'after' the filler table in the data file
CREATE TABLE ProdTable (c1 INT IDENTITY,  c2 CHAR (8000) DEFAULT 'production');
CREATE CLUSTERED INDEX prod_cl ON ProdTable (c1);
GO 

INSERT INTO ProdTable DEFAULT VALUES;
GO 1280 

-- check the fragmentation of the production table
SELECT [avg_fragmentation_in_percent] FROM sys.dm_db_index_physical_stats (
    DB_ID ('DBMaint2008'), OBJECT_ID ('ProdTable'), 1, NULL, 'LIMITED');
GO 

-- drop the filler table, creating 10MB of free space at the 'front' of the data file
DROP TABLE FillerTable;
GO 

-- shrink the database
DBCC SHRINKDATABASE (DBMaint2008);
GO 

-- check the index fragmentation again
SELECT [avg_fragmentation_in_percent] FROM sys.dm_db_index_physical_stats (
    DB_ID ('DBMaint2008'), OBJECT_ID ('ProdTable'), 1, NULL, 'LIMITED');
GO 

/******************************************************************************
avg_fragmentation_in_percent
----------------------------
0.390625

DbId   FileId      CurrentSize MinimumSize UsedPages   EstimatedPages
------ ----------- ----------- ----------- ----------- --------------
6      1           1456        152         1448        1440
6      2           63          63          56          56 

DBCC execution completed. If DBCC printed error messages, contact your system administrator.

avg_fragmentation_in_percent
----------------------------
99.296875 

******************************************************************************/
