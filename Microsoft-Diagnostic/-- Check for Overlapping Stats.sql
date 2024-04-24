-- Check for Overlapping Stats
Use AdventureWorks2019
go
WITH autostats (
	object_id
	, stats_id
	, NAME
	, column_id
	)
AS (
	SELECT sys.stats.object_id
		, sys.stats.stats_id
		, sys.stats.NAME
		, sys.stats_columns.column_id
	FROM sys.stats
	INNER JOIN sys.stats_columns
		ON sys.stats.object_id = sys.stats_columns.object_id
			AND sys.stats.stats_id = sys.stats_columns.stats_id
	WHERE sys.stats.auto_created = 1
		AND sys.stats_columns.stats_column_id = 1
	)
SELECT OBJECT_NAME(sys.stats.object_id) AS [Table]
	, sys.columns.NAME AS [Column]
	, sys.stats.NAME AS [Overlapped]
	, autostats.NAME AS [Overlapping]
	, 'DROP STATISTICS [' + OBJECT_SCHEMA_NAME(sys.stats.object_id) + '].[' + OBJECT_NAME(sys.stats.object_id) + '].[' + autostats.NAME + ']'
FROM sys.stats
INNER JOIN sys.stats_columns
	ON sys.stats.object_id = sys.stats_columns.object_id
		AND sys.stats.stats_id = sys.stats_columns.stats_id
INNER JOIN autostats
	ON sys.stats_columns.object_id = autostats.object_id
		AND sys.stats_columns.column_id = autostats.column_id
INNER JOIN sys.columns
	ON sys.stats.object_id = sys.columns.object_id
		AND sys.stats_columns.column_id = sys.columns.column_id
WHERE sys.stats.auto_created = 0
	AND sys.stats_columns.stats_column_id = 1
	AND sys.stats_columns.stats_id != autostats.stats_id
	AND OBJECTPROPERTY(sys.stats.object_id, 'IsMsShipped') = 0
/*
In SQL Server, overlapping statistics refer to a situation where both auto-created column statistics and index statistics exist for the same column. 

SQL Server's query optimizer uses statistics to determine the most efficient execution plan for a query. 
When the option to automatically create statistics is enabled (which it is by default), 
SQL Server will create statistics on columns used in a query's predicate as necessary. 
This usually means when statistics don't already exist for the column in question. 

Statistics are also created on the key columns of an index when the index is created. 
SQL Server understands the difference between auto-created column statistics and index statistics and maintains both. 
However, having both auto-created statistics and index statistics on the same column can sometimes cause the query optimizer to choose a different - and less than optimal - execution plan.

In most cases, it makes sense to manually drop the auto-created statistics in favor of index statistics that exist for the same column. 
SQL Server provides the information needed to identify when column statistics are overlapped by index statistics. 

*/