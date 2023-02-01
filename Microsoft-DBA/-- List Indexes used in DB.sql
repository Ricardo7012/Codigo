-- List Indexes used in DB

SELECT
   @@SERVERNAME AS [ServerName]
   , DB_NAME() AS [DatabaseName]
   , [SchemaName]
   , [ObjectName]
   , [ObjectType]
   , [IndexID]
   , [IndexName]
   , [IndexType]
   , COALESCE([0],[1],'') AS [Column1]
   , ISNULL([2],'') AS [Column2]
   , ISNULL([3],'') AS [Column3]
   , ISNULL([4],'') AS [Column4]
   , ISNULL([5],'') AS [Column5]
   , ISNULL([6],'') AS [Column6]
   , ISNULL([7],'') AS [Column7]
   , ISNULL([8],'') AS [Column8]
   , ISNULL([9],'') AS [Column9]
   , ISNULL([10],'') AS [Column10]
   , CASE 
      WHEN [IsIncludedColumn] = 0x1 THEN 'Yes'
      WHEN [IsIncludedColumn] = 0x0 THEN 'No'
      WHEN [IsIncludedColumn] IS NULL THEN 'N/A'
     END AS [IsCoveringIndex]
   , [IsDisabled]
FROM (
   SELECT
      SCHEMA_NAME([sObj].[schema_id]) AS [SchemaName]
      , [sObj].[name] AS [ObjectName]
      , CASE
         WHEN [sObj].[type] = 'U' THEN 'Table'
         WHEN [sObj].[type] = 'V' THEN 'View'
         END AS [ObjectType]
      , [sIdx].[index_id] AS [IndexID]  -- 0: Heap
								-- 1: Clustered Idx
								-- 2: Nonclustered Idx
      , ISNULL([sIdx].[name], 'N/A') AS [IndexName]
      , CASE
         WHEN [sIdx].[type] = 0 THEN 'Heap'
         WHEN [sIdx].[type] = 1 THEN 'Clustered'
         WHEN [sIdx].[type] = 2 THEN 'Nonclustered'
         WHEN [sIdx].[type] = 3 THEN 'XML'
         WHEN [sIdx].[type] = 4 THEN 'Spatial'
         WHEN [sIdx].[type] = 5 THEN 'Reserved for future use'
         WHEN [sIdx].[type] = 6 THEN 'Nonclustered columnstore index'
        END AS [IndexType]
      , [sCol].[name] AS [ColumnName]
   , [sIdxCol].[is_included_column] AS [IsIncludedColumn]
      , [sIdxCol].[key_ordinal] AS [KeyOrdinal]
      , [sIdx].[is_disabled] AS [IsDisabled]
   FROM 
      [sys].[indexes] AS [sIdx]
      INNER JOIN [sys].[objects] AS [sObj]
         ON [sIdx].[object_id] = [sObj].[object_id]
      LEFT JOIN [sys].[index_columns] AS [sIdxCol]
         ON [sIdx].[object_id] = [sIdxCol].[object_id]
         AND [sIdx].[index_id] = [sIdxCol].[index_id]
      LEFT JOIN [sys].[columns] AS [sCol]
         ON [sIdxCol].[object_id] = [sCol].[object_id]
         AND [sIdxCol].[column_id] = [sCol].[column_id]
   WHERE
      [sObj].[type] IN ('U','V')      	-- Look in Tables & Views
      AND [sObj].[is_ms_shipped] = 0x0  -- Exclude System Generated Objects
) AS [UnpivotedData]
PIVOT 
(
   MIN([ColumnName])
   FOR [KeyOrdinal] IN ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10])
) AS [ColumnPivot]