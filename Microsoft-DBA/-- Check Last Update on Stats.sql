-- Check Last Update on Stats

SELECT o.Type_Desc AS 'Object Type'
	, o.NAME AS 'Object'
	, s.NAME AS 'Stat'
	, stats_date(s.object_id, stats_id) AS 'LastUpdated'
FROM sys.stats s
INNER JOIN sys.objects o
	ON s.object_id = o.object_id
WHERE o.type_desc <> 'SYSTEM_TABLE' --exclude internal tables
ORDER BY OBJECT