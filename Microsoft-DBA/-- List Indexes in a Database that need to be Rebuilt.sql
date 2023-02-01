-- List Indexes in a Database that need to be Rebuilt
--
-- The recommendation is to rebuilt queries whose fragmentation exceeds 30.0% 
-- and who page count exceeds 50 pages.  These parameters may be adjusted below

DECLARE @page_count_minimum SMALLINT
DECLARE @fragmentation_minimum FLOAT

SET @page_count_minimum = 50
SET @fragmentation_minimum = 30

SELECT sys.objects.NAME AS Table_Name
	, sys.indexes.NAME AS Index_Name
	, avg_fragmentation_in_percent AS frag
	, page_count AS page_count
	, sys.dm_db_index_physical_stats.object_id AS objectid
	, sys.dm_db_index_physical_stats.index_id AS indexid
	, partition_number AS partitionnum
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
INNER JOIN sys.objects
	ON sys.objects.object_id = sys.dm_db_index_physical_stats.object_id
INNER JOIN sys.indexes
	ON sys.indexes.index_id = sys.dm_db_index_physical_stats.index_id
		AND sys.indexes.object_id = sys.dm_db_index_physical_stats.object_id
WHERE avg_fragmentation_in_percent > @fragmentation_minimum
	AND sys.dm_db_index_physical_stats.index_id > 0
	AND page_count > @page_count_minimum
ORDER BY page_count DESC