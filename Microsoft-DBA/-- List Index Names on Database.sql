-- List Index Names on Database

SELECT DB_NAME() AS DatabaseName
	, OBJECT_NAME(idx.OBJECT_ID) AS 'Table Name'
	, idx.NAME AS 'Index Name'
	, idx.index_id AS 'Index ID'
FROM sys.objects obj
INNER JOIN sys.indexes idx
	ON obj.OBJECT_ID = idx.OBJECT_ID
WHERE NOT EXISTS (
		SELECT stats.index_id
		FROM sys.dm_db_index_usage_stats stats
		WHERE idx.OBJECT_ID = stats.OBJECT_ID
			AND idx.INDEX_ID = stats.INDEX_ID
		)
	AND obj.TYPE <> 'S'
ORDER BY DatabaseName
	, 'Table Name'
	, 'Index Name'