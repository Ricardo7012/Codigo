/****************************************************
-- RUN RESULTS WITH CAUTION THIS WILL OUTPUT ALL PER DATABASE

-- Update Statistics on all the Tables in the Database
****************************************************/
USE dbatools
go

SET NOCOUNT ON

print 'USE ' + db_name();
print 'GO'
print ''

DECLARE @SQLcommand NVARCHAR(512)
DECLARE @Table SYSNAME

DECLARE curAllTables CURSOR
FOR
SELECT table_schema + '.' + table_name
FROM information_schema.tables
WHERE TABLE_TYPE = 'BASE TABLE'

OPEN curAllTables

FETCH NEXT
FROM curAllTables
INTO @Table

WHILE (@@FETCH_STATUS = 0)
BEGIN
	PRINT N'UPDATE STATISTICS ' + @Table+ ' WITH FULLSCAN'

	SET @SQLcommand = 'UPDATE STATISTICS ' + @Table + ' WITH FULLSCAN'

	--EXEC sp_executesql @SQLcommand

	FETCH NEXT
	FROM curAllTables
	INTO @Table
END

CLOSE curAllTables

DEALLOCATE curAllTables

SET NOCOUNT OFF
GO

USE dbatools; -- Replace with your actual database name
GO
SET NOCOUNT ON
GO
SELECT @@SERVERNAME AS ServerName
       ,DB_NAME() AS DatabaseName
       ,t.name AS TableName
       ,i.name AS IndexName
       ,STATS_DATE(i.OBJECT_ID, i.index_id) AS StatsUpdated
       ,s.avg_fragmentation_in_percent AS Density
       ,p.row_count AS [RowCount]
	   ,CASE ss.auto_created
		WHEN 0
			THEN 'No'
		WHEN 1
			THEN 'Yes'
		END AS 'Stats Created by Query Processor'
	 ,CASE ss.user_created
		WHEN 0
			THEN 'No'
		WHEN 1
			THEN 'Yes'
		END AS 'Stats Created by User'
	 ,CASE ss.no_recompute
		WHEN 0
			THEN 'No'
		WHEN 1
			THEN 'Yes'
		END AS 'Stats Created with No-Recompute Option'
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.stats AS ss 
	ON i.[object_id] = ss.[object_id]
		AND i.index_id = ss.stats_id
LEFT JOIN sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) s ON i.object_id = s.object_id AND i.index_id = s.index_id
LEFT JOIN sys.dm_db_partition_stats p ON i.object_id = p.object_id AND i.index_id = p.index_id;
