-- List File Sizes and Locations for Databases

DECLARE @DatabaseIDs TABLE (
	DatabaseNumber INT IDENTITY(1, 1)
	, DatabaseID INT
	, DatabaseName VARCHAR(250)
	)
DECLARE @DatabaseInfo TABLE (
	DatabaseName VARCHAR(250)
	, LogicalName VARCHAR(250)
	, FileType VARCHAR(20)
	, PhysicalName VARCHAR(500)
	, [Size(MB)] DECIMAL(38, 2)
	, [Used(MB)] DECIMAL(38, 2)
	, [Used(%)] DECIMAL(38, 2)
	, [Available(MB)] DECIMAL(38, 2)
	, [Available(%)] DECIMAL(38, 2)
	, MaxSizeInMB VARCHAR(20)
	, GrowthRate VARCHAR(50)
	)
DECLARE @DatabaseCount INT
DECLARE @DatabaseNumber INT = 1
DECLARE @DatabaseName VARCHAR(250)
DECLARE @SQLText VARCHAR(4000)

INSERT INTO @DatabaseIDs (
	DatabaseID
	, DatabaseName
	)
SELECT dbid AS DatabaseID
	, NAME
FROM MASTER.dbo.sysdatabases

SELECT @DatabaseCount = COUNT(*)
FROM @DatabaseIDs

WHILE @DatabaseNumber <= @DatabaseCount
BEGIN
	SELECT @DatabaseName = DatabaseName
	FROM @DatabaseIDs
	WHERE DatabaseNumber = @DatabaseNumber

	SET @SQLText = '
        USE ' + @DatabaseName + 
		'
        SELECT
        DB_NAME(database_id) AS ''Database Name'',
        Name AS ''Logical Name'',
        CASE WHEN type_desc = ''ROWS'' THEN ''Data File'' WHEN type_desc = ''LOG'' THEN ''Log File'' ELSE ''Unknown'' END AS ''File Type'',
        Physical_Name AS ''Physical Name'',
        size / 128.0 AS ''File Size In (MB)'',
        CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6)) / 128.0 AS ''Used Space In (MB)'',
        ((CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6))) / (size)) * 100 AS ''Percent Used'',
        size / 128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6)) / 128.0 AS ''Available Space In (MB)'',
        ((size - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS DECIMAL(38,6))) / (size)) * 100 AS ''Percent Available'',
        CASE WHEN max_size = -1 THEN ''Unrestricted'' ELSE CONVERT(VARCHAR, max_size) END AS ''Max Size In (MB)'',
        CASE WHEN is_percent_growth = 1 THEN CONVERT(VARCHAR, growth) + '' %'' ELSE CONVERT(VARCHAR, growth / 128) + '' MB'' END AS ''Growth Rate''
    FROM sys.master_files
    WHERE type_desc IN (''ROWS'',''LOG'') AND DB_NAME(database_id) = ' 
		+ '''' + @DatabaseName + ''''

	INSERT INTO @DatabaseInfo
	EXEC (@SQLText)

	SET @DatabaseNumber = @DatabaseNumber + 1
END

SELECT DatabaseName AS 'Database Name'
	, LogicalName AS 'Logical Name'
	, FileType AS 'File Type'
	, PhysicalName AS 'Physical Name'
	, [Size(MB)] AS 'Size (MB)'
	, [Used(MB)] AS 'Used (MB)'
	, [Used(%)] AS 'Used (%)'
	, [Available(MB)] AS 'Available (MB)'
	, [Available(%)] AS 'Available (%)'
	, MaxSizeInMB AS 'Max Size In (MB)'
	, GrowthRate AS 'Growth Rate'
FROM @DatabaseInfo
ORDER BY DatabaseName