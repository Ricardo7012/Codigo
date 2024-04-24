
/*
THIS MAINTENANCE WILL CAUSE BLOCKING AND SHOULD BE DONE AFTER HOURS
THIS MAINTENANCE WILL ALSO CAUSE HIGH REDO RATES

A heap table is a table without a clusteres index. 
In common, using heap tables isn't best practice, only in some less scenarios a heap is acceptable.
In SQL Azure heap tables are not allowed, every table must have a clustered index. So if you want to migrate you SQL Server database to SQL Azure you have to define a clustered index or modify an existing index for all table, where no CI exists.
With this simple Transact-SQL statement you can query all heap tables.

Works with SQL Server 2005 and higher version with all editions.

Links:
- MSDN SQL Server Best Practices Article: 
  http://msdn.microsoft.com/en-us/library/cc917672.aspx
- MSDN Heap Structures
  http://msdn.microsoft.com/en-us/library/ms188270.aspx

*/
USE HSP_rpt;
GO

 --List all heap tables
SELECT 'ALTER TABLE ' + SCH.[name] + '.' + TBL.[name] + ' REBUILD;' AS HEAPTableName
FROM sys.tables AS TBL
     INNER JOIN sys.schemas AS SCH
         ON TBL.schema_id = SCH.schema_id
     INNER JOIN sys.indexes AS IDX
         ON TBL.object_id = IDX.object_id
            AND IDX.type = 0 -- = Heap
ORDER BY HEAPTableName

--CHECK
SELECT @@ServerName           AS SERVERNAME
     , DB_NAME()              AS DATABASENAME
     , OBJECT_NAME(object_id) AS table_name
     , forwarded_record_count
     , avg_fragmentation_in_percent
     , page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Claim_Master'), DEFAULT, DEFAULT, 'DETAILED');

--CHECK
SELECT @@ServerName           AS SERVERNAME
     , DB_NAME()              AS DATABASENAME
     , OBJECT_NAME(object_id) AS table_name
     , forwarded_record_count
     , avg_fragmentation_in_percent
     , page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Claim_Details'), DEFAULT, DEFAULT, 'DETAILED');


USE HSP_RPT
go
SET STATISTICS IO,TIME ON
SELECT 'START TIME', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME
/*START PASTE RESULTS IN HERE*/
ALTER TABLE dbo.CapitationRecordPostActionHistory REBUILD;
/*END PASTE RESULTS IN HERE*/
SELECT 'END TIME', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME
SET STATISTICS IO,TIME OFF

