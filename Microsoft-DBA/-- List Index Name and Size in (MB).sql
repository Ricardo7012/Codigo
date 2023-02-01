-- List Index Name and Size in (MB)

SELECT object_name(i.object_id) AS 'Table Name'
	, COALESCE(i.NAME, space(0)) AS 'Index Name'
	, ps.partition_number AS 'Partition #'
	, ps.row_count AS 'Row Count'
	, Cast((ps.reserved_page_count * 8) / 1024. AS DECIMAL(12, 2)) AS 'Size in (mb)'
	, COALESCE(ius.user_seeks, 0) AS 'User Seeks'
	, COALESCE(ius.user_scans, 0) AS 'User Scans'
	, COALESCE(ius.user_lookups, 0) AS 'User Lookups'
	, i.type_desc AS 'Index Type'
FROM sys.all_objects t
INNER JOIN sys.indexes i
	ON t.object_id = i.object_id
INNER JOIN sys.dm_db_partition_stats ps
	ON i.object_id = ps.object_id AND i.index_id = ps.index_id
LEFT JOIN sys.dm_db_index_usage_stats ius
	ON ius.database_id = db_id() AND i.object_id = ius.object_id
		AND i.index_id = ius.index_id
ORDER BY object_name(i.object_id)
	, i.NAME
