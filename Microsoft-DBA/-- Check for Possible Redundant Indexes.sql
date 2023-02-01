-- Check for Possible Redundant Indexes

-- This script will generate 3 reports that give an overall or high level
-- view of the indexes in a particular database. The sections are as follows:
-- 1.  Lists ALL indexes and constraints along with the key details of each
-- 2.  Lists any tables with potential Redundant indexes
-- 3.  Lists any tables with potential Reverse indexes
--  Create a table variable to hold the core index info
DECLARE @AllIndexes TABLE (
	[Table ID] [int] NOT NULL
	, [Schema] [sysname] NOT NULL
	, [Table Name] [sysname] NOT NULL
	, [Index ID] [int] NULL
	, [Index Name] [nvarchar](128) NULL
	, [Index Type] [varchar](12) NOT NULL
	, [Constraint Type] [varchar](11) NOT NULL
	, [Object Type] [varchar](10) NOT NULL
	, [AllColName] [nvarchar](2078) NULL
	, [ColName1] [nvarchar](128) NULL
	, [ColName2] [nvarchar](128) NULL
	, [ColName3] [nvarchar](128) NULL
	, [ColName4] [nvarchar](128) NULL
	, [ColName5] [nvarchar](128) NULL
	, [ColName6] [nvarchar](128) NULL
	, [ColName7] [nvarchar](128) NULL
	, [ColName8] [nvarchar](128) NULL
	, [ColName9] [nvarchar](128) NULL
	, [ColName10] [nvarchar](128) NULL
	)

--  Load up the table variable with the index information to be used in follow on queries
INSERT INTO @AllIndexes (
	[Table ID]
	, [Schema]
	, [Table Name]
	, [Index ID]
	, [Index Name]
	, [Index Type]
	, [Constraint Type]
	, [Object Type]
	, [AllColName]
	, [ColName1]
	, [ColName2]
	, [ColName3]
	, [ColName4]
	, [ColName5]
	, [ColName6]
	, [ColName7]
	, [ColName8]
	, [ColName9]
	, [ColName10]
	)
SELECT o.[object_id] AS [Table ID]
	, u.[name] AS [Schema]
	, o.[name] AS [Table Name]
	, i.[index_id] AS [Index ID]
	, CASE i.[name]
		WHEN o.[name]
			THEN '** Same as Table Name **'
		ELSE i.[name]
		END AS [Index Name]
	, CASE i.[type]
		WHEN 1
			THEN 'CLUSTERED'
		WHEN 0
			THEN 'HEAP'
		WHEN 2
			THEN 'NONCLUSTERED'
		WHEN 3
			THEN 'XML'
		ELSE 'UNKNOWN'
		END AS [Index Type]
	, CASE 
		WHEN (i.[is_primary_key]) = 1
			THEN 'PRIMARY KEY'
		WHEN (i.[is_unique]) = 1
			THEN 'UNIQUE'
		ELSE ''
		END AS [Constraint Type]
	, CASE 
		WHEN (i.[is_unique_constraint]) = 1
			OR (i.[is_primary_key]) = 1
			THEN 'CONSTRAINT'
		WHEN i.[type] = 0
			THEN 'HEAP'
		WHEN i.[type] = 3
			THEN 'XML INDEX'
		ELSE 'INDEX'
		END AS [Object Type]
	, (
		SELECT COALESCE(c1.[name], '')
		FROM [sys].[columns] AS c1
		INNER JOIN [sys].[index_columns] AS ic1
			ON c1.[object_id] = ic1.[object_id]
				AND c1.[column_id] = ic1.[column_id]
				AND ic1.[key_ordinal] = 1
		WHERE ic1.[object_id] = i.[object_id]
			AND ic1.[index_id] = i.[index_id]
		) + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 2) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 2)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 3) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 3)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 4) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 4)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 5) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 5)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 6) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 6)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 7) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 7)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 8) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 8)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 9) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 9)
		END + CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 10) IS NULL
			THEN ''
		ELSE ', ' + INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 10)
		END AS [AllColName]
	, (
		SELECT COALESCE(c1.[name], '')
		FROM [sys].[columns] AS c1
		INNER JOIN [sys].[index_columns] AS ic1
			ON c1.[object_id] = ic1.[object_id]
				AND c1.[column_id] = ic1.[column_id]
				AND ic1.[key_ordinal] = 1
		WHERE ic1.[object_id] = i.[object_id]
			AND ic1.[index_id] = i.[index_id]
		) AS [ColName1]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 2) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 2)
		END AS [ColName2]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 3) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 3)
		END AS [ColName3]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 4) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 4)
		END AS [ColName4]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 5) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 5)
		END AS [ColName5]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 6) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 6)
		END AS [ColName6]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 7) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 7)
		END AS [ColName7]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 8) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 8)
		END AS [ColName8]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 9) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 9)
		END AS [ColName9]
	, CASE 
		WHEN INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 10) IS NULL
			THEN ''
		ELSE INDEX_COL('[' + u.[name] + '].[' + o.[name] + ']', i.[index_id], 10)
		END AS [ColName10]
FROM [sys].[objects] AS o WITH (NOLOCK)
LEFT JOIN [sys].[indexes] AS i WITH (NOLOCK)
	ON o.[object_id] = i.[object_id]
INNER JOIN [sys].[schemas] AS u WITH (NOLOCK)
	ON o.[schema_id] = u.[schema_id]
WHERE o.[type] = 'U' --AND i.[index_id] < 255
	AND o.[name] NOT IN ('dtproperties')
	AND i.[name] NOT LIKE '_WA_Sys_%'

-----------
SELECT 'Listing All Indexes' AS [Comments]

SELECT I.*
FROM @AllIndexes AS I
ORDER BY [Table Name]

-----------
SELECT 'Listing Possible Redundant Index keys' AS [Comments]

SELECT DISTINCT I.[Table Name]
	, I.[Index Name]
	, I.[Index Type]
	, I.[Constraint Type]
	, I.[AllColName]
FROM @AllIndexes AS I
INNER JOIN @AllIndexes AS I2
	ON I.[Table ID] = I2.[Table ID]
		AND I.[ColName1] = I2.[ColName1]
		AND I.[Index Name] <> I2.[Index Name]
		AND I.[Index Type] <> 'XML'
ORDER BY I.[Table Name]
	, I.[AllColName]

----------
SELECT 'Listing Possible Reverse Index keys' AS [Comments]

SELECT DISTINCT I.[Table Name]
	, I.[Index Name]
	, I.[Index Type]
	, I.[Constraint Type]
	, I.[AllColName]
FROM @AllIndexes AS I
INNER JOIN @AllIndexes AS I2
	ON I.[Table ID] = I2.[Table ID]
		AND I.[ColName1] = I2.[ColName2]
		AND I.[ColName2] = I2.[ColName1]
		AND I.[Index Name] <> I2.[Index Name]
		AND I.[Index Type] <> 'XML'
