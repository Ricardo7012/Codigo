-- List Index Finger Print

SELECT
	--IDENTIFICATION:
	DB_NAME(ixO.database_id) AS 'Database Name'
	, O.NAME AS 'Object Name'
	, I.NAME AS 'Index Name'
	, I.type_desc AS 'Index Type'
	,
	--LEAF LEVEL ACTIVITY:
	ixO.leaf_insert_count AS 'Leaf Insert Count'
	, ixO.range_scan_count AS 'Range Scan Count'
	,
	--LOCKING ACTIVITY:
	ixO.row_lock_count AS 'Row Lock Count'
	, ixO.page_lock_count AS 'Page Lock Count'
	,
	--LATCHING ACTIVITY:
	ixO.page_io_latch_wait_count AS 'Page IO Latch Wait Count'
FROM sys.dm_db_index_operational_stats(DB_ID(), NULL, NULL, NULL) AS ixO
INNER JOIN sys.indexes I
	ON ixO.object_id = I.object_id
		AND ixO.index_id = I.index_id
INNER JOIN sys.objects AS O
	ON O.object_id = ixO.object_id
WHERE O.is_ms_shipped = 0;

SELECT O.NAME AS 'Object Name'
	, I.NAME AS 'Index Name'
	, I.type_desc AS 'Index Type'
	, ixU.user_seeks AS 'User Seeks'
	, ixU.user_scans AS 'User Scans'
	, ixU.user_lookups AS 'User Lookups'
	, ixU.user_updates AS 'Total User Writes'
FROM sys.dm_db_index_usage_stats AS ixU
INNER JOIN sys.indexes AS I
	ON ixU.index_id = I.index_id
		AND ixU.object_id = I.object_id
INNER JOIN sys.objects AS O
	ON ixU.object_id = O.object_id
WHERE ixU.database_id = DB_ID()
ORDER BY 4
	, 5
	, 6 DESC;