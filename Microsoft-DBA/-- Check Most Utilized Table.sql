-- Check Most Utilized Table

IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	DROP TABLE #Temp
GO

CREATE TABLE #Temp (
	DB_Name VARCHAR(50)
	, TableName VARCHAR(150)
	, UserSeeks DECIMAL
	, UserScans DECIMAL
	, UserUpdates DECIMAL
	)

INSERT INTO #Temp
EXEC sp_MSForEachDB 'USE [?]; IF DB_ID(''?'') > 4
BEGIN
SELECT DB_Name(), object_name(b.object_id), a.user_seeks, a.user_scans, a.user_updates 
FROM sys.dm_db_index_usage_stats a
RIGHT OUTER JOIN [?].sys.indexes b on a.object_id = b.object_id and a.database_id = DB_ID()
WHERE b.object_id > 100 
END'

SELECT DB_Name AS 'DB Name'
	, TableName AS 'Table Name'
	, sum(UserSeeks + UserScans + UserUpdates) AS 'DB Access Count'
	, sum(UserUpdates) AS 'Total Writes'
	, CONVERT(DECIMAL(25, 2), (sum(UserUpdates) / sum(UserSeeks + UserScans + UserUpdates) * 100)) AS 'Writes (%)'
	, sum(UserSeeks + UserScans) AS 'Total Reads'
	, CONVERT(DECIMAL(25, 2), (sum(UserSeeks + UserScans) / sum(UserSeeks + UserScans + UserUpdates) * 100)) AS 'Reads (%)'
	, SUM(UserSeeks) AS 'Read Seeks'
	, CONVERT(DECIMAL(25, 2), (SUM(UserSeeks) / sum(UserSeeks + UserScans) * 100)) AS '(%) Reads Index Seeks'
	, SUM(UserScans) AS 'Read Scans'
	, CONVERT(DECIMAL(25, 2), (SUM(UserScans) / sum(UserSeeks + UserScans) * 100)) AS '(%) Reads Index Scans'
FROM #Temp
GROUP BY DB_Name
	, TableName
HAVING sum(UserSeeks + UserScans) > 0
ORDER BY DB_Name, sum(UserSeeks + UserScans + UserUpdates) DESC

DROP TABLE #Temp