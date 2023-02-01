-- List Table Stats and When Last Updated

DECLARE @ObjectName nvarchar(128)

SET @ObjectName = 'PlayerTrip0'

SELECT OBJECT_NAME(stats.object_id) AS 'Table Name'
	, stats.NAME AS 'Statistics Name'
	, stats_properties.last_updated AS 'Last Updated'
	, stats_properties.rows_sampled AS 'Rows Sampled'
	, stats_properties.rows AS 'Rows'
	, stats_properties.unfiltered_rows AS 'Unfiltered Rows'
	, stats_properties.steps AS 'Histogram Steps'
	, stats_properties.modification_counter AS 'Mod Counter'
FROM sys.stats stats
OUTER APPLY sys.dm_db_stats_properties(stats.object_id, stats.stats_id) AS stats_properties
WHERE OBJECT_NAME(stats.object_id) = @ObjectName
ORDER BY stats.NAME;
