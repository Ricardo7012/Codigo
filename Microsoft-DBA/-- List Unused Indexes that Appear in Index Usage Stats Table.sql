-- List Unused Indexes that Appear in Index Usage Stats Table

DECLARE @MinimumPageCount INT

SET @MinimumPageCount = 500

SELECT Databases.NAME AS 'Database'
	, object_name(Indexes.object_id) AS 'Table'
	, Indexes.NAME AS 'Index'
	, PhysicalStats.page_count AS 'Page Count'
	, CONVERT(DECIMAL(18, 2), PhysicalStats.page_count * 8 / 1024.0) AS 'Total Size (MB)'
	, CONVERT(DECIMAL(18, 2), PhysicalStats.avg_fragmentation_in_percent) AS 'Frag %'
	, ParititionStats.row_count AS 'Row Count'
	, CONVERT(DECIMAL(18, 2), (PhysicalStats.page_count * 8.0 * 1024) / ParititionStats.row_count) AS 'Index Size/Row (Bytes)'
FROM sys.dm_db_index_usage_stats UsageStats
INNER JOIN sys.indexes Indexes
	ON Indexes.index_id = UsageStats.index_id
		AND Indexes.object_id = UsageStats.object_id
INNER JOIN SYS.databases Databases
	ON Databases.database_id = UsageStats.database_id
INNER JOIN sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS PhysicalStats
	ON PhysicalStats.index_id = UsageStats.Index_id
		AND PhysicalStats.object_id = UsageStats.object_id
INNER JOIN SYS.dm_db_partition_stats ParititionStats
	ON ParititionStats.index_id = UsageStats.index_id
		AND ParititionStats.object_id = UsageStats.object_id
WHERE UsageStats.user_scans = 0
	AND UsageStats.user_seeks = 0
	-- ignore indexes with less than a certain number of pages of memory  
	AND PhysicalStats.page_count > @MinimumPageCount
	-- Exclude primary keys, which should not be removed  
	AND Indexes.type_desc != 'CLUSTERED'
ORDER BY 'Page Count' DESC
