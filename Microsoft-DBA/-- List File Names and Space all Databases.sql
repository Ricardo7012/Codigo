-- List File Names and Space all Databases

DECLARE @Command VARCHAR(5000)
DECLARE @DBInfo TABLE (
		PollTime DATETIME 
		, ServerName VARCHAR(100)
		, DatabaseName VARCHAR(100)
		, GroupName VARCHAR(100)
		, LogicalFileName VARCHAR(100)
		, PhysicalFileName NVARCHAR(520)
		, FileSizeMB DECIMAL(10, 2)
		, SpaceUsedMB DECIMAL(10, 2)
		, FreeSpaceMB DECIMAL(10, 2)
		, FreeSpacePct VARCHAR(8) 
)

SELECT @Command = 'USE' + ' ' + '?' + ' ' + 'SELECT
    CONVERT(DATETIME, CONVERT(Date, GETDATE())) AS ''Poll Time''
    , @@Servername as ''Server Name''
    , ' + '''' + '?' + '''' + ' AS ''Database Name''
    , fg.GroupName AS ''Group Name''
    , Name as ''Logical File Name''
    , Filename as ''Physical File Name''
    , CONVERT(DECIMAL(15, 2), ROUND(sf.Size/128.000,2)) as ''File Size (MB)''
	, CONVERT(DECIMAL(10, 2), ROUND(FILEPROPERTY(sf.name,'+''''+'SpaceUsed'+''''+') / 128.000, 2)) AS ''Space Used (MB)''
    , CONVERT(DECIMAL(15, 2), ROUND((sf.Size - FILEPROPERTY(sf.Name, ''SpaceUsed'')) / 128.000, 2)) AS ''Free Space (MB)''
FROM dbo.SysFiles sf WITH (NOLOCK)
JOIN SysFileGroups fg WITH (NOLOCK) 
    ON sf.GroupID = fg.GroupID
ORDER BY fg.GroupName'

EXEC sp_MSForEachDB @Command