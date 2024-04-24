-- Check Index Frag Level
use AdventureWorks2019
go
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
	, ISNULL([sPtn].[partition_number], 1) AS [PartitionNumber]
	, [sdmfIPS].[alloc_unit_type_desc] AS [IndexAllocationUnitType]
	, [IdxSizeDetails].[IndexSizeInKB]
	, [sIdx].[fill_factor] AS [FillFactor]
	, CAST([sdmfIPS].[avg_fragmentation_in_percent] AS NUMERIC(5, 2)) AS [AvgPctFrag]
FROM [sys].[indexes] AS [sIdx]
INNER JOIN [sys].[objects] AS [sObj]
	ON [sIdx].[object_id] = [sObj].[object_id]
LEFT JOIN [sys].[partitions] AS [sPtn]
	ON [sIdx].[object_id] = [sPtn].[object_id]
		AND [sIdx].[index_id] = [sPtn].[index_id]
LEFT JOIN (
	SELECT [sIdx].[object_id]
		, [sIdx].[index_id]
		, SUM([sAU].[used_pages]) * 8 AS [IndexSizeInKB]
	FROM [sys].[indexes] AS [sIdx]
	INNER JOIN [sys].[partitions] AS [sPtn]
		ON [sIdx].[object_id] = [sPtn].[object_id]
			AND [sIdx].[index_id] = [sPtn].[index_id]
	INNER JOIN [sys].[allocation_units] AS [sAU]
		ON [sPtn].[partition_id] = [sAU].[container_id]
	GROUP BY [sIdx].[object_id]
		, [sIdx].[index_id]
	) [IdxSizeDetails]
	ON [sIdx].[object_id] = [IdxSizeDetails].[object_id]
		AND [sIdx].[index_id] = [IdxSizeDetails].[index_id]
LEFT JOIN [sys].[dm_db_index_physical_stats](DB_ID(), NULL, NULL, NULL, 'LIMITED') [sdmfIPS]
	ON [sIdx].[object_id] = [sdmfIPS].[object_id]
		AND [sIdx].[index_id] = [sdmfIPS].[index_id]
		AND [sdmfIPS].[database_id] = DB_ID()
WHERE [sObj].[type] IN (
		'U'
		, 'V'
		) -- Look in Tables & Views
	AND [sObj].[is_ms_shipped] = 0x0 -- Exclude System Generated Objects
	AND [sIdx].[is_disabled] = 0x0 -- Exclude Disabled Indexes
