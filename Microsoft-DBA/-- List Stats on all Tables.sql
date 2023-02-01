-- List Stats on all Tables

SELECT DISTINCT OBJECT_NAME(s.[object_id]) AS TableName
	, c.NAME AS ColumnName
	, s.NAME AS StatName
	, s.auto_created
	, s.user_created
	, s.no_recompute
	, s.[object_id]
	, s.stats_id
	, sc.stats_column_id
	, sc.column_id
	, STATS_DATE(s.[object_id], s.stats_id) AS LastUpdated
FROM sys.stats s
INNER JOIN sys.stats_columns sc
	ON sc.[object_id] = s.[object_id]
		AND sc.stats_id = s.stats_id
INNER JOIN sys.columns c
	ON c.[object_id] = sc.[object_id]
		AND c.column_id = sc.column_id
INNER JOIN sys.partitions par
	ON par.[object_id] = s.[object_id]
INNER JOIN sys.objects obj
	ON par.[object_id] = obj.[object_id]
WHERE OBJECTPROPERTY(s.OBJECT_ID, 'IsUserTable') = 1
	AND (
		s.auto_created = 1
		OR s.user_created = 1
		);
