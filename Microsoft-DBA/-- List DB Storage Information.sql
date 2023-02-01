-- List DB Storage Information

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @dbname VARCHAR(200)
	, @sql VARCHAR(8000)

SET @sql = ''
SET @dbname = ''

CREATE TABLE #TMP_ServerDrive (
	[DriveName] VARCHAR(5) PRIMARY KEY
	, [FreeDriveSpace] BIGINT
	)

INSERT INTO #TMP_ServerDrive
EXEC master..xp_fixeddrives

CREATE TABLE #TMP_LogSpace (
	[DBName] VARCHAR(200) NOT NULL PRIMARY KEY
	, [LogSize] MONEY NOT NULL
	, [LogPercentUsed] MONEY NOT NULL
	, [LogStatus] INT NOT NULL
	)

SELECT @sql = 'DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS'

INSERT INTO #TMP_LogSpace
EXEC (@sql)

CREATE TABLE #TMP_DBFileInfo (
	[DBName] VARCHAR(200)
	, [FileLogicalName] VARCHAR(200)
	, [FileID] INT NOT NULL
	, [Filename] VARCHAR(250) NOT NULL
	, [Filegroup] VARCHAR(100) NOT NULL
	, [FileCurrentSize] BIGINT NOT NULL
	, [FileMaxSize] VARCHAR(50) NOT NULL
	, [FileGrowth] VARCHAR(50) NOT NULL
	, [FileUsage] VARCHAR(50) NOT NULL
	, [FileGrowthSize] BIGINT NOT NULL
	)

CREATE TABLE #TMP_DB ([DBName] VARCHAR(200) PRIMARY KEY)

INSERT INTO #TMP_DB
SELECT DBName = LTRIM(RTRIM(NAME))
FROM master.dbo.sysdatabases
WHERE category IN (
		'0'
		, '1'
		, '16'
		)
	AND DATABASEPROPERTYEX(NAME, 'status') = 'ONLINE'
ORDER BY NAME

CREATE TABLE #TMP_DataSpace (
	[DBName] VARCHAR(200) NULL
	, [Fileid] INT NOT NULL
	, [FileGroup] INT NOT NULL
	, [TotalExtents] MONEY NOT NULL
	, [UsedExtents] MONEY NOT NULL
	, [FileLogicalName] SYSNAME NOT NULL
	, [Filename] VARCHAR(1000) NOT NULL
	)

SELECT @dbname = MIN(dbname)
FROM #TMP_DB

WHILE @dbname IS NOT NULL
BEGIN
	SET @sql = 'USE ' + @dbname + '
  INSERT INTO #TMP_DBFileInfo (
   [DBName],
   [FileLogicalName],
   [FileID],
   [Filename],
   [Filegroup],
   [FileCurrentSize],
   [FileMaxSize],
   [FileGrowth],
   [FileUsage],
   [FileGrowthSize])
  SELECT DBName = ''' + @dbname + 
		''',
   FileLogicalName = SF.name, 
   FileID = SF.fileid, 
   Filename = SF.filename, 
   Filegroup = ISNULL(filegroup_name(SF.groupid),''''), 
   FileCurrentSize = (SF.size * 8)/1024, 
   FileMaxSize = CASE SF.maxsize WHEN -1 THEN N''Unlimited'' 
       ELSE CONVERT(VARCHAR(15), (CAST(SF.maxsize AS BIGINT) * 8)/1024) + N'' MB'' END, 
   FileGrowth = (case SF.status & 0x100000 when 0x100000 then 
       convert(varchar(3), SF.growth) + N'' %'' 
      else 
       convert(varchar(15), ((CAST(SF.growth AS BIGINT) * 8)/1024)) + N'' MB'' end), 
   FileUsage = (case WHEN SF.status & 0x40 = 0x40 then ''Log'' else ''Data'' end),
   FileGrowthSize = CASE SF.status & 0x100000 WHEN 0x100000 THEN
        ((((CAST(SF.size AS BIGINT) * 8)/1024)* SF.growth)/100) + ((CAST(SF.size AS BIGINT) * 8)/1024)
       ELSE
        ((CAST(SF.size AS BIGINT) * 8)/1024) + ((CAST(SF.growth AS BIGINT) * 8)/1024)
       END
  FROM sysfiles SF
  ORDER BY SF.fileid'

	EXEC (@sql)

	SET @sql = 'USE ' + @dbname + '
    DBCC SHOWFILESTATS WITH NO_INFOMSGS'

	INSERT INTO #TMP_DataSpace (
		[Fileid]
		, [FileGroup]
		, [TotalExtents]
		, [UsedExtents]
		, [FileLogicalName]
		, [Filename]
		)
	EXEC (@sql)

	UPDATE #TMP_DataSpace
	SET [DBName] = @dbname
	WHERE ISNULL([DBName], '') = ''

	SELECT @dbname = MIN(dbname)
	FROM #TMP_DB
	WHERE dbname > @dbname
END

SELECT 'DB - Name' = DFI.DBName
	, 'File Logical Name' = DFI.FileLogicalName
	, 'File Name' = DFI.[Filename]
	, 'File MB Size' = DFI.FileCurrentSize
	, 'File Growth' = DFI.FileGrowth
	, 'File MB Growth' = DFI.FileGrowthSize
	, 'Drive Name' = SD.DriveName
	, 'Drive MB Empty' = SD.FreeDriveSpace
	, 'File MB Used' = CAST(ISNULL(((DSP.UsedExtents * 64.00) / 1024), LSP.LogSize * (LSP.LogPercentUsed / 100)) AS BIGINT)
	, 'File MB Empty' = DFI.FileCurrentSize - CAST(ISNULL(((DSP.UsedExtents * 64.00) / 1024), LSP.LogSize * (LSP.LogPercentUsed / 100)) AS BIGINT)
	, 'File Percent Empty' = (
		CAST((DFI.FileCurrentSize - CAST(ISNULL(((DSP.UsedExtents * 64.00) / 1024), LSP.LogSize * (LSP.LogPercentUsed / 100)) AS BIGINT)) AS MONEY) / CAST(CASE 
				WHEN ISNULL(DFI.FileCurrentSize, 0) = 0
					THEN 1
				ELSE DFI.FileCurrentSize
				END AS MONEY)
		) * 100
FROM #TMP_DBFileInfo DFI
LEFT JOIN #TMP_ServerDrive SD
	ON LEFT(LTRIM(RTRIM(DFI.[FileName])), 1) = LTRIM(RTRIM(SD.DriveName))
LEFT JOIN #TMP_DataSpace DSP
	ON LTRIM(RTRIM(DSP.[Filename])) = LTRIM(RTRIM(DFI.[Filename]))
LEFT JOIN #TMP_LogSpace LSP
	ON LtRIM(RTRIM(LSP.DBName)) = LTRIM(RTRIM(DFI.DBName))

DROP TABLE #TMP_ServerDrive

DROP TABLE #TMP_LogSpace

DROP TABLE #TMP_DBFileInfo

DROP TABLE #TMP_DataSpace

DROP TABLE #TMP_DB
