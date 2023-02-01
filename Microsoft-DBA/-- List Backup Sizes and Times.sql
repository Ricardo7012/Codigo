-- List Backup Sizes and Times

SELECT TOP 100 s.database_name AS 'DB Name'
	, m.physical_device_name AS 'Device Name'
	, CAST(CAST(s.backup_size / 1000000 AS INT) AS VARCHAR(14)) + ' ' + 'MB' AS 'BU Size'
	, CAST(DATEDIFF(second, s.backup_start_date, s.backup_finish_date) AS VARCHAR(4)) + ' ' + 'Seconds' AS 'BU Time'
	, s.backup_start_date AS 'BU Start Date'
	, CASE s.[type]
		WHEN 'D'
			THEN 'Full'
		WHEN 'I'
			THEN 'Differential'
		WHEN 'L'
			THEN 'Transaction Log'
		END AS 'Backup Type'
FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m
	ON s.media_set_id = m.media_set_id
--WHERE s.database_name = DB_NAME() -- Remove this line for all the database
ORDER BY backup_start_date DESC
	, backup_finish_date
GO


