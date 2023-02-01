-- List Most Utilized Table

IF OBJECT_ID('tempdb..#Temp') IS NOT NULL
	DROP TABLE #Temp
GO

CREATE TABLE #Temp (
	TableName NVARCHAR(255)
	, UserSeeks DECIMAL
	, UserScans DECIMAL
	, UserUpdates DECIMAL
	)

INSERT INTO #Temp
EXEC sp_MSForEachDB 'USE [?]; IF DB_ID(''?'') > 4
BEGIN
	SELECT DB_NAME() + ''.'' + object_name(b.object_id)
		, a.user_seeks
		, a.user_scans
		, a.user_updates
	FROM sys.dm_db_index_usage_stats a
	RIGHT JOIN [?].sys.indexes b
		ON a.object_id = b.object_id
			AND a.database_id = DB_ID()
	WHERE b.object_id > 100
END'

SELECT TableName AS 'Table Name'
	, sum(UserSeeks + UserScans + UserUpdates) AS 'Total Accesses'
	, sum(UserUpdates) AS 'Total Writes'
	, CONVERT(DECIMAL(25, 2), (sum(UserUpdates) / sum(UserSeeks + UserScans + UserUpdates) * 100)) AS 'Accesses are Writes (%)'
	, sum(UserSeeks + UserScans) AS 'Total Reads'
	, CONVERT(DECIMAL(25, 2), (sum(UserSeeks + UserScans) / sum(UserSeeks + UserScans + UserUpdates) * 100)) AS 'Accesses are Reads (%)'
	, SUM(UserSeeks) AS 'Read Seeks'
	, CONVERT(DECIMAL(25, 2), (SUM(UserSeeks) / sum(UserSeeks + UserScans) * 100)) AS 'Reads are Index Seeks (%)'
	, SUM(UserScans) AS 'Read Scans'
	, CONVERT(DECIMAL(25, 2), (SUM(UserScans) / sum(UserSeeks + UserScans) * 100)) AS '% Reads are Index Scans (%)'
FROM #Temp
GROUP BY TableName
HAVING sum(UserSeeks + UserScans) > 0
ORDER BY sum(UserSeeks + UserScans + UserUpdates) DESC

DROP TABLE #Temp
