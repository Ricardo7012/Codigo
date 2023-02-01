-- Check Index Fragmentation

SET NOCOUNT ON

DECLARE @@ObjectName SYSNAME
DECLARE @@SpaceUsed INT
DECLARE @@FragLevel INT
DECLARE @@DefaultFillFactor CHAR(3)
DECLARE @@OnlineReIndex CHAR(3)

SET @@SpaceUsed = 70
SET @@FragLevel = 25
SET @@DefaultFillFactor = 'NO' --Either YES (use default fillfactor) or NO (use current fillfactor)
SET @@OnlineReIndex = 'YES' --Either YES (rebuild indexes online) or NO (rebuild indexes offline)

CREATE TABLE #FileGroupUsage (
	file_group SYSNAME NULL
	, total_size INT NULL
	, space_used INT NULL
	, space_used_percent INT NULL
	, space_available INT NULL
	)

CREATE TABLE #ObjectList (
	object_name SYSNAME NULL
	, object_id INT NOT NULL
	, object_type CHAR(2) NULL
	, index_name SYSNAME NULL
	, index_id INT NOT NULL
	, fill_factor TINYINT NULL
	, file_group SYSNAME NULL
	, processed BIT NULL
	)

CREATE TABLE #DefragIndexes (
	object_name SYSNAME NULL
	, object_id INT NOT NULL
	, object_type CHAR(2) NULL
	, index_name SYSNAME NULL
	, index_id INT NOT NULL
	, file_group SYSNAME NULL
	, page_count INT NULL
	, fill_factor TINYINT NULL
	, frag_level FLOAT NULL
	, reorganize_index_stmt VARCHAR(1000) NULL
	, rebuild_index_stmt VARCHAR(1000) NULL
	,
	)

INSERT INTO #FileGroupUsage
SELECT ds.NAME AS FileGroup
	, SUM(df.size / 128.0) AS [Total Size in MB]
	, SUM(CAST(FILEPROPERTY(df.NAME, 'SpaceUsed') AS INT) / 128.0) AS [SpaceUsed in MB]
	, ((SUM(CAST(FILEPROPERTY(df.NAME, 'SpaceUsed') AS INT) / 128.0) / SUM(df.size / 128.0)) * 100) AS [Space Used in Percent]
	, SUM(df.size / 128.0 - CAST(FILEPROPERTY(df.NAME, 'SpaceUsed') AS INT) / 128.0) AS [Available Space In MB]
FROM sys.data_spaces ds
INNER JOIN sys.database_files df
	ON df.data_space_id = ds.data_space_id
GROUP BY ds.NAME

INSERT INTO #ObjectList
SELECT o.[name] AS ObjectName
	, o.[object_id] AS ObjectID
	, o.[type] AS ObjectType
	, i.[name] AS IndexName
	, i.[index_id] AS IndexID
	, i.[fill_factor] AS [FillFactor]
	, f.[name] AS FileGroup
	, NULL
FROM sys.indexes i
INNER JOIN sys.filegroups f
	ON i.data_space_id = f.data_space_id
INNER JOIN sys.all_objects o
	ON i.[object_id] = o.[object_id]
WHERE o.type = 'U'
	AND f.[name] IN (
		SELECT file_group
		FROM #FileGroupUsage
		WHERE space_used_percent >= @@SpaceUsed
		)

WHILE EXISTS (
		SELECT TOP 1 Processed
		FROM #ObjectList
		WHERE Processed IS NULL
		)
BEGIN
	SELECT @@ObjectName = object_name
	FROM #ObjectList
	WHERE Processed IS NULL

	INSERT #DefragIndexes
	SELECT l.object_name AS ObjectName
		, l.object_id AS ObjectID
		, l.object_type AS ObjectType
		, l.index_name AS IndexName
		, l.index_id AS IndexID
		, l.file_group AS FileGroup
		, s.page_count AS PageCount
		, l.fill_factor AS [FillFactor]
		, s.avg_fragmentation_in_percent AS Fragmentation
		, 'ALTER INDEX ' + index_name + ' ON ' + object_name + ' REORGANIZE;' AS ReorganizeIndexStatement
		, 'ALTER INDEX ' + index_name + ' ON ' + object_name + CASE 
			WHEN (
					@@DefaultFillFactor = 'YES'
					AND @@OnlineReIndex = 'YES'
					)
				THEN ' REBUILD WITH (SORT_IN_TEMPDB = ON,ONLINE = ON);'
			WHEN (
					@@DefaultFillFactor = 'YES'
					AND @@OnlineReIndex = 'NO'
					)
				THEN ' REBUILD WITH (SORT_IN_TEMPDB = ON);'
			WHEN (
					@@DefaultFillFactor = 'NO'
					AND @@OnlineReIndex = 'NO'
					)
				THEN ' REBUILD WITH (SORT_IN_TEMPDB = ON, FILLFACTOR = ' + CAST(l.fill_factor AS VARCHAR) + ');'
			WHEN (
					@@DefaultFillFactor = 'NO'
					AND @@OnlineReIndex = 'YES'
					)
				THEN ' REBUILD WITH (SORT_IN_TEMPDB = ON, ONLINE = ON, FILLFACTOR = ' + CAST(l.fill_factor AS VARCHAR) + ');'
			END AS ReorganizeIndexStatement
	FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID(@@ObjectName), NULL, NULL, NULL) AS s
	INNER JOIN #ObjectList AS l
		ON s.object_id = l.object_id
			AND s.index_id = l.index_id
	WHERE avg_fragmentation_in_percent >= @@FragLevel
		AND l.index_id > 0

	UPDATE #ObjectList
	SET Processed = 1
	WHERE object_name = @@ObjectName
END

SELECT *
FROM #DefragIndexes
ORDER BY page_count DESC
	, frag_level DESC

DROP TABLE #FileGroupUsage

DROP TABLE #ObjectList

DROP TABLE #DefragIndexes

SET NOCOUNT OFF
