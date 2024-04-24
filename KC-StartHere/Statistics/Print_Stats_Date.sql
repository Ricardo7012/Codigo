
/******************************************************************
PRINT STATS_DATE 
*******************************************************************/

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


/******************************************************************
READERRORLOG 
*******************************************************************/
USE master
GO
xp_readerrorlog 0, 1, N'Statistics', NULL, NULL, NULL 
GO

/*
Database Configuration: In some cases, database settings or configurations could affect the behavior of statistics updates.
To troubleshoot, you can try the following:

Check the SQL Server error log for any messages related to the update statistics command.
Verify permissions of the user executing the command.
Check for any blocking or locking issues.
Check if there are any maintenance plans or jobs scheduled to update statistics.
Ensure that the database configuration settings are appropriate for statistics updates.

-- DBCC SHOW_STATISTICS ('Object_Name', 'Statistic_Name')
*/

USE dbatools
GO
DBCC SHOW_STATISTICS ('CommandLog', 'PK_CommandLog')
DBCC SHOW_STATISTICS ('SqlServerVersions', 'PK_SqlServerVersions')
