-- List Database File Names and Space

SELECT CONVERT(DATETIME, CONVERT(DATE, GETDATE())) AS 'Poll Time'
	, @@Servername AS 'Server Name'
	, db_name() AS 'DB Name'
	, fg.groupname AS 'FileGroup Name'
	, NAME AS 'Logical File Name'
	, [Filename] AS 'OS FileName'
	, CONVERT(DECIMAL(15, 2), ROUND(sf.Size / 128.000, 2)) AS 'Total (mb)'
	, CONVERT(DECIMAL(15, 2), ROUND((sf.Size - FILEPROPERTY(sf.NAME, 'SpaceUsed')) / 128.000, 2)) AS 'Free (mb)'
FROM dbo.sysfiles sf(NOLOCK)
INNER JOIN sysfilegroups fg(NOLOCK)
	ON sf.groupid = fg.groupid
ORDER BY fg.groupname;
