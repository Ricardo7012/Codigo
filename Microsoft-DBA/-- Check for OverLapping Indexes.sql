-- Check for OverLapping Indexes
use AdventureWorks2019
go
DECLARE @dbid INT
DECLARE @dbName VARCHAR(100);

SELECT @dbid = DB_ID()
	, @dbName = DB_Name();

WITH partitionCTE (
	object_id
	, index_id
	, row_count
	, partition_count
	)
AS (
	SELECT [object_id]
		, index_id
		, Sum([rows]) AS 'row_count'
		, Count(partition_id) AS 'partition_count'
	FROM sys.partitions
	GROUP BY [object_id]
		, index_id
	)
SELECT Object_Name(i.[object_id]) AS objectName
	, i.NAME
	, CASE 
		WHEN i.is_unique = 1
			THEN 'UNIQUE '
		ELSE ''
		END + i.type_desc AS 'indexType'
	, ddius.user_seeks
	, ddius.user_scans
	, ddius.user_lookups
	, ddius.user_updates
	, cte.row_count
	, CASE 
		WHEN partition_count > 1
			THEN 'yes'
		ELSE 'no'
		END AS 'partitioned?'
	, CASE 
		WHEN i.type = 2
			AND i.is_unique_constraint = 0
			THEN 'Drop Index ' + i.NAME + ' On ' + @dbName + '.dbo.' + Object_Name(ddius.[object_id]) + ';'
		WHEN i.type = 2
			AND i.is_unique_constraint = 1
			THEN 'Alter Table ' + @dbName + '.dbo.' + Object_Name(ddius.[object_ID]) + ' Drop Constraint ' + i.NAME + ';'
		ELSE ''
		END AS 'SQL_DropStatement'
FROM sys.indexes AS i
INNER JOIN sys.dm_db_index_usage_stats ddius
	ON i.object_id = ddius.object_id
		AND i.index_id = ddius.index_id
INNER JOIN partitionCTE AS cte
	ON i.object_id = cte.object_id
		AND i.index_id = cte.index_id
WHERE ddius.database_id = @dbid
ORDER BY (ddius.user_seeks + ddius.user_scans + ddius.user_lookups) DESC
	, user_updates DESC;
