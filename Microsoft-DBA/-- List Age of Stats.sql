-- List Age of Stats

SELECT DISTINCT OBJECT_NAME(s.[object_id]) AS 'Table Name'
	, c.NAME AS 'Column Name'
	, s.NAME AS 'Stat Name'
	, STATS_DATE(s.[object_id], s.stats_id) AS 'Last Updated'
	, DATEDIFF(d, STATS_DATE(s.[object_id], s.stats_id), getdate()) AS 'Days Old'
	, dsp.modification_counter AS 'Mod Counter'
	, s.auto_created AS 'Auto Created'
	, s.user_created AS 'User Created'
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
CROSS APPLY sys.dm_db_stats_properties(sc.[object_id], s.stats_id) AS dsp
WHERE OBJECTPROPERTY(s.OBJECT_ID, 'IsUserTable') = 1
	AND (
		s.auto_created = 1
		OR s.user_created = 1
		)
ORDER BY 'Days Old'
