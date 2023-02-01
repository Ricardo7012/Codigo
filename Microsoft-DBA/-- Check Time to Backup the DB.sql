-- Check Time to Backup the DB

DECLARE @dbname SYSNAME

SET @dbname = NULL --set this to be whatever dbname you want

SELECT bup.database_name AS [Database]
	, bup.server_name AS [Server]
	, bup.backup_start_date AS [Backup Started]
	, bup.backup_finish_date AS [Backup Finished]
	, CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS INT)) / 3600 AS VARCHAR) + ' Hours, ' + CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS INT)) / 60 AS VARCHAR) + ' Minutes, ' + CAST((CAST(DATEDIFF(s, bup.backup_start_date, bup.backup_finish_date) AS INT)) % 60 AS VARCHAR) + ' Seconds' AS [Total Time]
FROM msdb.dbo.backupset bup
WHERE bup.backup_set_id IN (
		SELECT MAX(backup_set_id)
		FROM msdb.dbo.backupset
		WHERE database_name = ISNULL(@dbname, database_name) AND type = 'D'
		GROUP BY database_name
		)
	-- COMMENT THE NEXT LINE IF YOU WANT ALL BACKUP HISTORY
	AND bup.database_name IN (
		SELECT NAME
		FROM master.dbo.sysdatabases
		)
ORDER BY bup.database_name
