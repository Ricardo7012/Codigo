-- List Matrix for Indexes

SELECT DB_NAME() AS 'Database Name'
	, [SchemaName] AS 'Schema Name'
	, [ObjectName] AS 'Object Name'
	, [ObjectType] AS 'Object Type'
	, [IndexID] AS 'Index ID'
	, [IndexName] AS 'Index Name'
	, [IndexType] AS 'Index Type'
	, COALESCE([0], [1], '') AS [Col1]
	, ISNULL([2], '') AS [Col2]
	, ISNULL([3], '') AS [Col3]
	, ISNULL([4], '') AS [Col4]
	, ISNULL([5], '') AS [Col5]
	, ISNULL([6], '') AS [Col6]
	, ISNULL([7], '') AS [Col7]
	, ISNULL([8], '') AS [Col8]
	, ISNULL([9], '') AS [Col9]
	, ISNULL([10], '') AS [Col10]
	, ISNULL([11], '') AS [Col11]
	, ISNULL([12], '') AS [Col12]
	, ISNULL([13], '') AS [Col13]		
	, ISNULL([14], '') AS [Col14]	
	, CASE 
		WHEN [IsIncludedColumn] = 0x1
			THEN 'Yes'
		WHEN [IsIncludedColumn] = 0x0
			THEN 'No'
		WHEN [IsIncludedColumn] IS NULL
			THEN 'N/A'
		END AS 'Is Covering Index'
	, [IsDisabled] AS 'Is Disabled'
FROM (
	SELECT SCHEMA_NAME([sObj].[schema_id]) AS [SchemaName]
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
		, [sCol].[name] AS [ColumnName]
		, [sIdxCol].[is_included_column] AS [IsIncludedColumn]
		, [sIdxCol].[key_ordinal] AS [KeyOrdinal]
		, [sIdx].[is_disabled] AS [IsDisabled]
	FROM [sys].[indexes] AS [sIdx]
	INNER JOIN [sys].[objects] AS [sObj]
		ON [sIdx].[object_id] = [sObj].[object_id]
	LEFT JOIN [sys].[index_columns] AS [sIdxCol]
		ON [sIdx].[object_id] = [sIdxCol].[object_id]
			AND [sIdx].[index_id] = [sIdxCol].[index_id]
	LEFT JOIN [sys].[columns] AS [sCol]
		ON [sIdxCol].[object_id] = [sCol].[object_id]
			AND [sIdxCol].[column_id] = [sCol].[column_id]
	WHERE [sObj].[type] IN (
			'U'
			, 'V'
			) -- Look in Tables & Views
		AND [sObj].[is_ms_shipped] = 0x0 -- Exclude System Generated Objects
	) AS [UnpivotedData]
PIVOT(MIN([ColumnName]) FOR [KeyOrdinal] IN (
			[0]
			, [1]
			, [2]
			, [3]
			, [4]
			, [5]
			, [6]
			, [7]
			, [8]
			, [9]
			, [10]
			, [11]
			, [12]			
			, [13]			
			, [14]			
			)) AS [ColumnPivot]
