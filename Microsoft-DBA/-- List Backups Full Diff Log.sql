-- List Backups Full Diff Log

SELECT DISTINCT a.NAME AS 'DB Name'
	, CONVERT(SYSNAME, DATABASEPROPERTYEX(a.NAME, 'Recovery')) AS 'Recovery Model'
	, COALESCE((
			SELECT CONVERT(VARCHAR(12), MAX(backup_finish_date), 101)
			FROM msdb.dbo.backupset
			WHERE database_name = a.NAME
				AND type = 'D'
				AND is_copy_only = '0'
			), 'No Full') AS 'Full'
	, COALESCE((
			SELECT CONVERT(VARCHAR(12), MAX(backup_finish_date), 101)
			FROM msdb.dbo.backupset
			WHERE database_name = a.NAME
				AND type = 'I'
				AND is_copy_only = '0'
			), 'No Diff') AS 'Diff'
	, COALESCE((
			SELECT CONVERT(VARCHAR(20), MAX(backup_finish_date), 120)
			FROM msdb.dbo.backupset
			WHERE database_name = a.NAME
				AND type = 'L'
			), 'No Log') AS 'Last Log'
	, COALESCE((
			SELECT CONVERT(VARCHAR(20), backup_finish_date, 120)
			FROM (
				SELECT ROW_NUMBER() OVER (
						ORDER BY backup_finish_date DESC
						) AS 'rownum'
					, backup_finish_date
				FROM msdb.dbo.backupset
				WHERE database_name = a.NAME
					AND type = 'L'
				) withrownum
			WHERE rownum = 2
			), 'No Log') AS 'Last Log 2'
FROM sys.databases a
LEFT JOIN msdb.dbo.backupset b
	ON b.database_name = a.NAME
WHERE a.NAME <> 'tempdb'
	AND a.state_desc = 'online'
GROUP BY a.NAME
	, a.compatibility_level
ORDER BY a.NAME
