USE [master]
GO
EXECUTE dbo.sp_IndexOptimize
 @Databases = 'ALL_DATABASES',
 @FragmentationLow = NULL,
 @FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
 @FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
 @FragmentationLevel1 = 5,
 @FragmentationLevel2 = 30,
 @UpdateStatistics = 'ALL',
 @PageCountLevel = 5,
 @OnlyModifiedStatistics = 'N'
GO

-- ***************************************************************************
--ALT
-- ***************************************************************************
DECLARE @Database VARCHAR(255)   
DECLARE @Table VARCHAR(255)  
DECLARE @cmd NVARCHAR(500)  
DECLARE @fillfactor INT 

SET @fillfactor = 90 

DECLARE DatabaseCursor CURSOR FOR  
SELECT name FROM master.dbo.sysdatabases   
WHERE name IN ('master','msdb','model')   
ORDER BY 1  

OPEN DatabaseCursor  

FETCH NEXT FROM DatabaseCursor INTO @Database  
WHILE @@FETCH_STATUS = 0  
BEGIN  

   SET @cmd = 'DECLARE TableCursor CURSOR FOR SELECT ''['' + table_catalog + ''].['' + table_schema + ''].['' + 
  table_name + '']'' as tableName FROM [' + @Database + '].INFORMATION_SCHEMA.TABLES 
  WHERE table_type = ''BASE TABLE'''   

   -- create table cursor  
   EXEC (@cmd)  
   OPEN TableCursor   

   FETCH NEXT FROM TableCursor INTO @Table   
   WHILE @@FETCH_STATUS = 0   
   BEGIN   

       IF (@@MICROSOFTVERSION / POWER(2, 24) >= 9)
       BEGIN
           -- SQL 2005 or higher command 
           SET @cmd = 'ALTER INDEX ALL ON ' + @Table + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ')' 
           EXEC (@cmd) 
       END
       ELSE
       BEGIN
          -- SQL 2000 command 
          DBCC DBREINDEX(@Table,' ',@fillfactor)  
       END

       FETCH NEXT FROM TableCursor INTO @Table   
   END   

   CLOSE TableCursor   
   DEALLOCATE TableCursor  

   FETCH NEXT FROM DatabaseCursor INTO @Database  
END  
CLOSE DatabaseCursor   
DEALLOCATE DatabaseCursor

-- ***************************************************************************
---UPDATE STATS
-- ***************************************************************************
USE [master] -- Change desired database name here
GO
SET NOCOUNT ON
GO
DECLARE updatestats CURSOR FOR
SELECT table_name FROM information_schema.tables
	where TABLE_TYPE = 'BASE TABLE'
OPEN updatestats

DECLARE @tablename NVARCHAR(128)
DECLARE @Statement NVARCHAR(300)

FETCH NEXT FROM updatestats INTO @tablename
WHILE (@@FETCH_STATUS = 0)
BEGIN
   PRINT N'UPDATING STATISTICS ' + @tablename
   SET @Statement = 'UPDATE STATISTICS '  + @tablename + '  WITH FULLSCAN'
   EXEC sp_executesql @Statement
   FETCH NEXT FROM updatestats INTO @tablename
END