-- List Fragmentation Level, Database and Table

-- This query will give DETAILED information

DECLARE @db_id SMALLINT;
DECLARE @object_id INT;

SET @db_id = DB_ID(N'PlayerManagement');
SET @object_id = OBJECT_ID(N'dbo.player');

IF @object_id IS NULL
BEGIN
	PRINT N'Invalid object';
END
ELSE
BEGIN
	SELECT object_name(IPS.object_id) AS [TableName]
		, SI.NAME AS [IndexName]
		, IPS.Index_type_desc
		, IPS.avg_fragmentation_in_percent
		, IPS.avg_fragment_size_in_pages
		, IPS.avg_page_space_used_in_percent
		, IPS.record_count
		, IPS.ghost_record_count
		, IPS.fragment_count
		, IPS.avg_fragment_size_in_pages
	FROM sys.dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL, NULL) AS IPS
	INNER JOIN sys.tables ST WITH (NOLOCK)
		ON IPS.object_id = ST.object_id
	INNER JOIN sys.indexes SI WITH (NOLOCK)
		ON IPS.object_id = SI.object_id
			AND IPS.index_id = SI.index_id
	WHERE ST.is_ms_shipped = 0
	ORDER BY 1
		, 5
END
GO