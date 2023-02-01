-- Pull Frag % and Stats on Indexes

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DISTINCT OBJECT_NAME(ind.OBJECT_ID) AS 'Object Name'
	, ind.NAME AS 'Index Name'
	, ips.index_type_desc AS 'Index Type'
	, STATS_DATE(ind.object_id, ind.index_id) AS 'Stats Date'
	, ROUND(ips.avg_fragmentation_in_percent, 2) AS 'Frag %'
	, part.rows AS 'Row Cnt'
	, ips.page_count AS 'Page Cnt'
	, ips.fragment_count AS 'Frag Cnt'
	, ind.fill_factor AS 'Fill Factor'
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) ips
INNER JOIN sys.indexes ind
	ON ind.object_id = ips.object_id
		AND ind.index_id = ips.index_id
INNER JOIN sys.partitions part
    ON ips.object_id = part.object_id	
WHERE ips.avg_fragmentation_in_percent >= 0
ORDER BY 'Object Name', 'Index Type'