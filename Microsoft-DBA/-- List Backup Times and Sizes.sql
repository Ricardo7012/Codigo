-- List Backup Times and Sizes

DECLARE @StartDate DATETIME
DECLARE @FinishDate DATETIME

SET @StartDate = '2015-12-31'
SET @FinishDate = '2016-11-27 23:59:59'

SELECT DISTINCT CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS 'Server'
	, msdb.dbo.backupset.database_name AS 'DB Name'
	, msdb.dbo.backupset.backup_start_date AS 'BU Start Date'
	, msdb.dbo.backupset.backup_finish_date AS 'BU Finish Date'
	, CAST((DATEDIFF(second, msdb.dbo.backupset.backup_start_date, msdb.dbo.backupset.backup_finish_date)) AS VARCHAR) + ' secs  ' AS 'Total Time'
	, Cast(msdb.dbo.backupset.backup_size / 1024 / 1024 AS NUMERIC(10, 2)) AS 'Backup Size(MB)'
	, msdb.dbo.backupset.NAME AS 'BU Set Name'
FROM msdb.dbo.backupmediafamily
INNER JOIN msdb.dbo.backupset
	ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
		--Enter your database below
		--and database_name = 'db_name_here'
		AND msdb.dbo.backupset.backup_start_date > @StartDate
		AND msdb.dbo.backupset.backup_start_date < '2016-11-27 23:59:59'
ORDER BY msdb.dbo.backupset.database_name
	, msdb.dbo.backupset.backup_start_date
