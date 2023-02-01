-- List Tables and Stats

SELECT sch.NAME AS 'Schema Name'
	, so.NAME AS 'Table'
	, ss.NAME AS 'Statistic'
	, CASE 
		WHEN ss.auto_Created = 0
			AND ss.user_created = 0
			THEN 'Index Statistic'
		WHEN ss.auto_created = 0
			AND ss.user_created = 1
			THEN 'User Created'
		WHEN ss.auto_created = 1
			AND ss.user_created = 0
			THEN 'Auto Created'
		WHEN ss.AUTO_created = 1
			AND ss.user_created = 1
			THEN 'Not Possible?'
		END AS 'Statistic Type'
	, CASE 
		WHEN ss.has_filter = 1
			THEN 'Filtered Index'
		WHEN ss.has_filter = 0
			THEN 'No Filter'
		END AS 'Filtered?'
	, CASE 
		WHEN ss.filter_definition IS NULL
			THEN ''
		WHEN ss.filter_definition IS NOT NULL
			THEN ss.filter_definition
		END AS 'Filter Definition'
	, sp.last_updated AS 'Stats Last Updated'
	, sp.rows AS 'Rows'
	, sp.rows_sampled AS 'Rows Sampled'
	, sp.unfiltered_rows AS 'Unfiltered Rows'
	, sp.modification_counter AS 'Row Modifications'
	, sp.steps AS 'Histogram Steps'
FROM sys.stats ss
INNER JOIN sys.objects so
	ON ss.object_id = so.object_id
INNER JOIN sys.schemas sch
	ON so.schema_id = sch.schema_id
OUTER APPLY sys.dm_db_stats_properties(so.object_id, ss.stats_id) AS sp
WHERE so.TYPE = 'U'
	AND sp.last_updated < getdate() - 30
ORDER BY sp.last_updated DESC;
