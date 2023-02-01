-- List Indexes and Percent Frag

SELECT t.NAME AS 'Table name'
	, i.NAME AS 'Index name'
	, ips.index_type_desc AS 'Index Type'
	, ips.alloc_unit_type_desc AS 'Alloc Unit Desc'
	, ips.index_depth AS 'Index Depth'
	, ips.index_level AS 'Index Level'
	, CONVERT(DECIMAL(10, 2), ips.avg_fragmentation_in_percent) AS '% Frag Avg'
	, ips.fragment_count AS 'Frag Count'
	, CONVERT(DECIMAL(10, 2), ips.avg_fragment_size_in_pages) AS 'Frag Page Avg'
	, ips.page_count AS 'Page Count'
	, ips.avg_page_space_used_in_percent AS 'Avg Page Space %'
	, ips.record_count AS 'Record Count'
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) ips
INNER JOIN sys.tables t
	ON ips.OBJECT_ID = t.Object_ID
INNER JOIN sys.indexes i
	ON ips.index_id = i.index_id
		AND ips.OBJECT_ID = i.object_id
WHERE AVG_FRAGMENTATION_IN_PERCENT > 10.0
ORDER BY AVG_FRAGMENTATION_IN_PERCENT
	, fragment_count
