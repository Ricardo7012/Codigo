-- List Index Usage

SELECT @@SERVERNAME AS [ServerName]
	, DB_NAME() AS [DatabaseName]
	, SCHEMA_NAME([sObj].[schema_id]) AS [SchemaName]
	, [sObj].[name] AS [ObjectName]
	, CASE 
		WHEN [sObj].[type] = 'U'
			THEN 'Table'
		WHEN [sObj].[type] = 'V'
			THEN 'View'
		END AS [ObjectType]
	, [sIdx].[index_id] AS [IndexID]
	, ISNULL([sIdx].[name], 'N/A') AS [IndexName]
	, CASE 
		WHEN [sIdx].[type] = 0
			THEN 'Heap'
		WHEN [sIdx].[type] = 1
			THEN 'Clustered'
		WHEN [sIdx].[type] = 2
			THEN 'Nonclustered'
		WHEN [sIdx].[type] = 3
			THEN 'XML'
		WHEN [sIdx].[type] = 4
			THEN 'Spatial'
		WHEN [sIdx].[type] = 5
			THEN 'Reserved for future use'
		WHEN [sIdx].[type] = 6
			THEN 'Nonclustered columnstore index'
		END AS [IndexType]
	, [sdmvIUS].[user_seeks] AS [TotalUserSeeks]
	, [sdmvIUS].[user_scans] AS [TotalUserScans]
	, [sdmvIUS].[user_lookups] AS [TotalUserLookups]
	, [sdmvIUS].[user_updates] AS [TotalUserUpdates]
	, [sdmvIUS].[last_user_seek] AS [LastUserSeek]
	, [sdmvIUS].[last_user_scan] AS [LastUserScan]
	, [sdmvIUS].[last_user_lookup] AS [LastUserLookup]
	, [sdmvIUS].[last_user_update] AS [LastUserUpdate]
	, [sdmfIOPS].[leaf_insert_count] AS [LeafLevelInsertCount]
	, [sdmfIOPS].[leaf_update_count] AS [LeafLevelUpdateCount]
	, [sdmfIOPS].[leaf_delete_count] AS [LeafLevelDeleteCount]
FROM [sys].[indexes] AS [sIdx]
INNER JOIN [sys].[objects] AS [sObj]
	ON [sIdx].[object_id] = [sObj].[object_id]
LEFT JOIN [sys].[dm_db_index_usage_stats] AS [sdmvIUS]
	ON [sIdx].[object_id] = [sdmvIUS].[object_id]
		AND [sIdx].[index_id] = [sdmvIUS].[index_id]
		AND [sdmvIUS].[database_id] = DB_ID()
LEFT JOIN [sys].[dm_db_index_operational_stats](DB_ID(), NULL, NULL, NULL) AS [sdmfIOPS]
	ON [sIdx].[object_id] = [sdmfIOPS].[object_id]
		AND [sIdx].[index_id] = [sdmfIOPS].[index_id]
WHERE [sObj].[type] IN (
		'U'
		, 'V'
		) -- Look in Tables & Views
	AND [sObj].[is_ms_shipped] = 0x0 -- Exclude System Generated Objects
	AND [sIdx].[is_disabled] = 0x0 -- Exclude Disabled Indexes
