-- List Index Sizes

SET NOCOUNT ON

IF OBJECT_ID('tempdb..#SpaceUsed') IS NOT NULL
	DROP TABLE #SpaceUsed

CREATE TABLE #SpaceUsed (
	TableName SYSNAME
	, [Rows] INT
	, [Reserved] VARCHAR(20)
	, [Data] VARCHAR(20)
	, [Index_Size] VARCHAR(20)
	, [Unused] VARCHAR(20)
	, [Reserved_KB] BIGINT
	, [Data_KB] BIGINT
	, [Index_Size_KB] BIGINT
	, [Unused_KB] BIGINT
	)

DECLARE @CMD NVARCHAR(MAX) = ''

SELECT @CMD += 'EXEC sp_spaceused ' + '''' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + '''' + ';' + CHAR(10)
FROM INFORMATION_SCHEMA.TABLES

--PRINT @CMD
INSERT INTO #SpaceUsed (
	TableName
	, [Rows]
	, [Reserved]
	, [Data]
	, [Index_Size]
	, [Unused]
	)
EXEC sp_executesql @CMD

UPDATE #SpaceUsed
SET [Reserved_KB] = CONVERT(BIGINT, RTRIM(LTRIM(REPLACE([Reserved], ' KB', ''))))
	, [Data_KB] = CONVERT(BIGINT, RTRIM(LTRIM(REPLACE([Data], ' KB', ''))))
	, [Index_Size_KB] = CONVERT(BIGINT, RTRIM(LTRIM(REPLACE([Index_Size], ' KB', ''))))
	, [Unused_KB] = CONVERT(BIGINT, RTRIM(LTRIM(REPLACE([Unused], ' KB', ''))))

SELECT TableName AS 'Table Name'
	, [Rows] AS 'Rows'
	, Reserved_KB AS 'Reserved (KB)'
	, Data_KB AS 'Data (KB)'
	, Index_Size_KB AS 'Index Size (KB)'
	, Unused_KB AS 'Unused (KB)'
	, Data_KB / 1024.0 AS 'Data (MB)'
	, Data_KB / 1024.0 / 1024.0 AS 'Data (GB)'
FROM #SpaceUsed
ORDER BY Data_KB DESC

SELECT SUM(Reserved_KB) as 'Reserved (KB)'
	, SUM(Data_KB) AS 'Data (KB)'
	, SUM(Index_Size_KB) AS 'Index Size (KB)'
	, SUM(Unused_KB) AS 'Unused (KB)'
	, SUM(Data_KB / 1024.0) as 'Data (MB)'
	, SUM(Data_KB / 1024.0 / 1024.0) AS 'Data (GB)'
FROM #SpaceUsed

DROP TABLE #SpaceUsed
