/****************************************************
-- RUN RESULTS WITH CAUTION THIS WILL OUTPUT ALL PER DATABASE
<<<<<<< HEAD

=======
-- https://www.sqlshack.com/fundamentals-of-sql-server-statistics/
>>>>>>> 106542f79e57dd65f0858010ed7904c3cafa1477
-- List Overlapping Statistics
****************************************************/
USE dbatools
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
SELECT OBJECT_NAME(sys.stats.object_id) AS 'Table'
--	, sys.columns.NAME AS 'Column'
	, sys.stats.NAME AS 'Overlapped'
	, autostats.NAME AS 'Overlapping'
	, 'DROP STATISTICS [' + OBJECT_SCHEMA_NAME(sys.stats.object_id) + '].[' + OBJECT_NAME(sys.stats.object_id) + '].[' + autostats.NAME + ']' AS 'Drop Statement'
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

