-- List File Sizes & Free Space

DECLARE @Command VARCHAR(5000)
DECLARE @DBInfo TABLE (
	ServerName VARCHAR(100)
	, DatabaseName VARCHAR(100)
	, PhysicalFileName NVARCHAR(520)
	, FileSizeMB DECIMAL(10, 2)
	, SpaceUsedMB DECIMAL(10, 2)
	, FreeSpaceMB DECIMAL(10, 2)
	, FreeSpacePct VARCHAR(8)
	)

SELECT @Command = 'USE' + ' ' + '?' + ' ' + 'SELECT   
			@@ServerName AS ''ServerName''
			, ' + '''' + '?' + '''' + ' AS ''DatabaseName''
			, FileName 
			, CONVERT(DECIMAL(10, 2), ROUND(sf.SIZE / 128.000, 2)) AS ''FileSizeMB'' 
			, CONVERT(DECIMAL(10, 2), ROUND(FILEPROPERTY(sf.name,' + '''' + 'SpaceUsed' + '''' + ') / 128.000, 2)) AS ''SpaceUsedMB'' 
			, CONVERT(DECIMAL(10, 2), ROUND((sf.SIZE - FILEPROPERTY(sf.NAME,' + '''' + 'SpaceUsed' + '''' + '))/128.000, 2)) AS ''FreeSpaceMB''
			, CAST(100 * (CAST (((sf.SIZE / 128.0 - CAST(FILEPROPERTY(sf.NAME,' + '''' + 'SpaceUsed' + '''' + ' ) AS INT) / 128.0) / (sf.SIZE / 128.0)) AS DECIMAL(4,2))) AS VARCHAR(8)) + ' + '''' + '%' + '''' + ' AS ''FreeSpacePct''
			FROM dbo.SysFiles sf 
			WITH (NOLOCK)'

INSERT INTO @DBInfo
EXEC sp_MSForEachDB @command

SELECT ServerName AS 'Server Name'
	, DatabaseName AS 'Database Name'
	, PhysicalFileName AS 'Physical File Name'
	, FileSizeMB AS 'File Size (MB)'
	, SpaceUsedMB AS 'Space Used (MB)'
	, FreeSpaceMB AS 'Free Space (MB)'
	, FreeSpacePct AS 'Free Space %'
FROM @DBInfo
