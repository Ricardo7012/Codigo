-- Check Service Broker

WITH xCTE (
	[ObjectName]
	, [PartitionId]
	, [Rows]
	, [Type]
	)
AS (
	--Get the partition information for all internal tables that we are interested in
	SELECT so.NAME
		, p.partition_id
		, p.row_count
		, so.type
	FROM sys.objects so
	LEFT JOIN sys.dm_db_partition_stats p
		ON p.object_id = so.object_id
	WHERE so.NAME IN (
			'sysdercv'
			, 'sysdesend'
			, 'sysxmitqueue'
			, 'sysconvgroup'
			, 'sysremsvcbinds'
			)
		AND p.index_id = 1 --Only care about clustered index
	
	UNION ALL
	
	--Get the partion information for all the service queues in the db
	SELECT so.NAME
		, p.partition_id
		, p.rows
		, so.type
	FROM sys.objects so
	LEFT JOIN sys.objects so2
		ON so.object_id = so2.parent_object_id
	LEFT JOIN sys.partitions p
		ON p.object_id = so2.object_id
	WHERE so.type = 'SQ' --type "SQ" = Service Queue
		AND p.index_id = 1 --Only care about clustered index
		AND so.is_ms_shipped = 0 --Do not care about MS shipped broker queues
	)
SELECT ObjectName
	, Type
	, CAST((reserved_page_count * 8.0) / 1024.0 AS DECIMAL(10, 2)) AS 'Reserved Space (mb)'
	, CAST((used_page_count * 8.0) / 1024.0 AS DECIMAL(10, 2)) AS 'Used Space (mb)'
	, [Rows] AS 'Rows'
FROM xCTE x
LEFT JOIN sys.dm_db_partition_stats s
	ON x.PartitionId = s.partition_id
ORDER BY 'Reserved Space (mb)' DESC
