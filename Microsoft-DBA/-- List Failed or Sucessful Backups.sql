-- List Failed or Sucessful Backups

DECLARE @path NVARCHAR(260);

SELECT @path = REVERSE(SUBSTRING(REVERSE([path]), CHARINDEX(CHAR(92), REVERSE([path])), 260)) + N'log.trc'
FROM sys.traces
WHERE is_default = 1;

SELECT dt.DatabaseName AS 'DB Name'
	, dt.StartTime AS 'Trace Start Time'
	, bs.backup_start_date AS 'BU Start Time'
	, bs.backup_finish_date AS 'BU End Time'
	, CASE 
		WHEN bs.backup_start_date IS NULL
			THEN 'Failed'
		ELSE 'Successful'
		END AS 'Status'
FROM sys.fn_trace_gettable(@path, DEFAULT) AS dt
LEFT JOIN msdb.dbo.backupset AS bs
	ON dt.DatabaseName = bs.database_name
		AND ABS(DATEDIFF(SECOND, dt.StartTime, bs.backup_start_date)) < 5
WHERE dt.EventClass = 115
	AND UPPER(CONVERT(NVARCHAR(MAX), dt.TextData)) LIKE N'BACKUP%DATABASE%'
--	AND dt.DatabaseName = N'DBInven' -- to filter to a single database
--	AND bs.database_name = N'DBInven'
ORDER BY dt.StartTime;
