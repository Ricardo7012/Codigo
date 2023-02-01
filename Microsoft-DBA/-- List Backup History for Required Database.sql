-- List Backup History for Required Database

SELECT TOP 100 s.database_name AS 'Database Name'
		, m.physical_device_name 'Physical File Name'
		, CAST(CAST(s.backup_size / 1000000 AS INT) AS VARCHAR(14)) + ' ' + 'MB' AS 'Backup Size'
		, CAST(DATEDIFF(second, s.backup_start_date,s.backup_finish_date) AS VARCHAR(4)) + ' ' + 'Seconds' AS 'Backup Time'
		, s.backup_start_date AS 'Start Date'
		, s.backup_finish_date AS 'Finish Date'
--		, CAST(s.first_lsn AS VARCHAR(50)) AS 'First LSN' 
--		, CAST(s.last_lsn AS VARCHAR(50)) AS 'Last LSN'
		, CASE s.[type] 
			WHEN 'D' THEN 'Full'
			WHEN 'I' THEN 'Differential'
			WHEN 'L' THEN 'Transaction Log'
			END AS 'Backup Type'
		, s.server_name AS 'Server Name'
		, s.recovery_model AS 'Recovery Model'
FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m 
ON s.media_set_id = m.media_set_id
WHERE s.database_name = DB_NAME()
ORDER BY backup_start_date DESC
		, backup_finish_date
 GO