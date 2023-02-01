-- List Index Data

SELECT DB_NAME(ixUS.database_id) AS 'Database Name'
	, OBJECT_SCHEMA_NAME(SI.object_id, ixUS.database_id) AS 'Schema Name'
	, OBJECT_NAME(SI.object_id, ixUS.database_id) AS 'Object Name'
	, SI.NAME AS 'Index Name'
	, ixUS.index_id AS 'Index ID'
	, CASE ixUS.user_updates
		WHEN NULL
			THEN (ixUS.user_seeks + ixUS.user_scans + ixUS.user_lookups)
		WHEN 0
			THEN (ixUS.user_seeks + ixUS.user_scans + ixUS.user_lookups)
		ELSE CAST((ixUS.user_seeks + ixUS.user_scans + ixUS.user_lookups) / (ixUS.user_updates * 1.0) AS DECIMAL(15, 1))
		END AS 'R per W'
	, ixUS.user_seeks AS 'User Seeks'
	, ixUS.user_scans AS 'User Scans'
	, ixUS.user_lookups AS 'User Lookups'
	, (ixUS.user_seeks + ixUS.user_scans + ixUS.user_lookups) AS 'Total Reads'
	, ixUS.user_updates AS 'Total Writes'
FROM sys.dm_db_index_usage_stats ixUS
INNER JOIN sys.indexes SI
	ON SI.object_id = ixUS.object_id
		AND SI.index_id = ixUS.index_id
WHERE ixUS.database_id = DB_ID()
ORDER BY 'R per W' DESC
	, 'Total Writes'
	, 'Total Reads' DESC
	, OBJECT_NAME(ixUS.object_id, IxUS.database_id)
	, ixUS.index_id;
