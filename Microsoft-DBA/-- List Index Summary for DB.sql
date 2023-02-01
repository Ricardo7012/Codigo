--List Index Summary for DB

WITH IndexSummary
AS (
	SELECT DISTINCT sys.objects.NAME AS [Table Name]
		, sys.indexes.NAME AS [Index Name]
		, SUBSTRING((
				SELECT ', ' + sys.columns.NAME AS [text()]
				FROM sys.columns
				INNER JOIN sys.index_columns
					ON sys.index_columns.column_id = sys.columns.column_id
						AND sys.index_columns.object_id = sys.columns.object_id
				WHERE sys.index_columns.index_id = sys.indexes.index_id
					AND sys.index_columns.object_id = sys.indexes.object_id
					AND sys.index_columns.is_included_column = 0
				ORDER BY sys.columns.NAME
				FOR XML Path('')
				), 2, 10000) AS [Indexed Column Names]
		, ISNULL(SUBSTRING((
					SELECT ', ' + sys.columns.NAME AS [text()]
					FROM sys.columns
					INNER JOIN sys.index_columns
						ON sys.index_columns.column_id = sys.columns.column_id
							AND sys.index_columns.object_id = sys.columns.object_id
					WHERE sys.index_columns.index_id = sys.indexes.index_id
						AND sys.index_columns.object_id = sys.indexes.object_id
						AND sys.index_columns.is_included_column = 1
					ORDER BY sys.columns.NAME
					FOR XML Path('')
					), 2, 10000), '') AS [Included Column Names]
		, sys.indexes.index_id
		, sys.indexes.object_id
	FROM sys.indexes
	INNER JOIN SYS.index_columns
		ON sys.indexes.index_id = SYS.index_columns.index_id
			AND sys.indexes.object_id = sys.index_columns.object_id
	INNER JOIN sys.objects
		ON sys.OBJECTS.object_id = SYS.indexES.object_id
	WHERE sys.objects.type = 'U'
	)
SELECT IndexSummary.[Table Name]
	, IndexSummary.[Index Name]
	, IndexSummary.[Indexed Column Names]
	, IndexSummary.[Included Column Names]
	, PhysicalStats.page_count AS [Page Count]
	, CONVERT(DECIMAL(18, 2), PhysicalStats.page_count * 8 / 1024.0) AS [Size (MB)]
	, CONVERT(DECIMAL(18, 2), PhysicalStats.avg_fragmentation_in_percent) AS [Fragment %]
FROM IndexSummary
INNER JOIN sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS PhysicalStats
	ON PhysicalStats.index_id = IndexSummary.index_id
		AND PhysicalStats.object_id = IndexSummary.object_id
WHERE (
		SELECT COUNT(*) AS Computed
		FROM IndexSummary Summary2
		WHERE Summary2.[Table Name] = IndexSummary.[Table Name]
			--AND Summary2.[Indexed Cols] = IndexSummary.[Indexed Cols]
		) > 1
ORDER BY [Table Name]
	, [Index Name]
	, [Indexed Column Names]
	, [Included Column Names]
