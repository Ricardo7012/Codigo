-- Check Statistics on SQL Server Database

SELECT sysobj.NAME AS 'Object Name'
	, sysindex.NAME AS 'Index Name'
	, Stats_date(sysindex.[object_id], sysindex.index_id) AS 'Statistics Update Date'
	, CASE sysstats.auto_created
		WHEN 0
			THEN 'No'
		WHEN 1
			THEN 'Yes'
		END AS 'Stats Created by Query Processor'
	, CASE sysstats.user_created
		WHEN 0
			THEN 'No'
		WHEN 1
			THEN 'Yes'
		END AS 'Stats Created by User'
	, CASE sysstats.no_recompute
		WHEN 0
			THEN 'No'
		WHEN 1
			THEN 'Yes'
		END AS 'Stats Created with No-Recompute Option'
FROM sys.objects AS sysobj WITH (NOLOCK)
INNER JOIN sys.indexes AS sysindex WITH (NOLOCK)
	ON sysobj.[object_id] = sysindex.[object_id]
INNER JOIN sys.stats AS sysstats WITH (NOLOCK)
	ON sysindex.[object_id] = sysstats.[object_id]
		AND sysindex.index_id = sysstats.stats_id
WHERE sysobj.[type] IN (
		'U'
		, 'V'
		)
ORDER BY Stats_date(sysindex.[object_id], sysindex.index_id)
