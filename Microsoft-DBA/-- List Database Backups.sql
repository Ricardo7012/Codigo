-- List Database Backups

DECLARE @db VARCHAR(25)

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT 10000

SET @db = 'PlayerManagement_82'

SELECT (
		SELECT max(backup_finish_date)
		FROM msdb.dbo.backupset
		WHERE type = 'D' AND database_name = @db
		) AS 'Last Database Backup'
	, (
		SELECT max(backup_finish_date)
		FROM msdb.dbo.backupset
		WHERE type = 'I' AND database_name = @db
		) AS 'Last Differential Backup'
	, (
		SELECT max(backup_finish_date)
		FROM msdb.dbo.backupset
		WHERE type = 'L' AND database_name = @db
		) AS 'Last Log Backup'
