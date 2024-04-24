-- List Index Fragmentation Percentage

SELECT OBJECT_NAME(ind.OBJECT_ID) AS 'Table Name'
	, ind.NAME AS 'Index Name'
	, indexstats.index_type_desc AS 'Index Type'
	, CONVERT(decimal(10, 2), avg_fragmentation_in_percent) AS 'Frag %'
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
INNER JOIN sys.indexes ind
	ON ind.object_id = indexstats.object_id
		AND ind.index_id = indexstats.index_id
WHERE indexstats.avg_fragmentation_in_percent > 30
ORDER BY indexstats.avg_fragmentation_in_percent DESC
