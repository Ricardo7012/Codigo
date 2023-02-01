-- List Backup History

USE msdb
GO

DECLARE @DBName varchar(25)
DECLARE @RecoveryModel varchar(10)
DECLARE @BackupType1 varchar(1)
DECLARE @BackupType2 varchar(1)

--------------------------------------------------------
-- Set the 2 parameters to the database and backup type
--------------------------------------------------------

SET @DBName = 'ezPay'
SET @BackupType1 = 'D' -- Backup Type
SET @BackupType2 = 'L'

-- 'D' = 'Full'
-- 'I' = 'Differential'
-- 'L' = 'Log'
-- 'F' = 'File or filegroup'
-- 'G' = 'Differential file'
-- 'P' = 'P'
-- 'Q' = 'Differential partial'

SELECT
	bs.server_name AS 'Server Name', -- Server name
	bs.database_name AS 'Databse Name', -- Database name
	CASE bs.compatibility_level
		WHEN 80 THEN 'SQL Server 2000'
		WHEN 90 THEN 'SQL Server 2005 '
		WHEN 100 THEN 'SQL Server 2008'
		WHEN 110 THEN 'SQL Server 2012'
		WHEN 120 THEN 'SQL Server 2014'
		WHEN 130 THEN 'SQL Server 2016'
		WHEN 140 THEN 'SQL Server 2017'
	END AS 'Compatibility Level',
	-- Return backup compatibility level
	recovery_model AS 'Recovery Model', -- Database recovery model
	CASE bs.type
		WHEN 'D' THEN 'Full'
		WHEN 'I' THEN 'Differential'
		WHEN 'L' THEN 'Log'
		WHEN 'F' THEN 'File or filegroup'
		WHEN 'G' THEN 'Differential file'
		WHEN 'P' THEN 'P'
		WHEN 'Q' THEN 'Differential partial'
	END AS 'Backup Type', -- Type of database backup
	bs.backup_start_date AS 'Backup Start Date', -- Backup start date
	bs.backup_finish_date AS 'Backup Finish Date', -- Backup finish date
	bmf.physical_device_name AS 'Physical Device', -- backup Physical location
	CASE device_type
		WHEN 2 THEN 'Disk - Temporary'
		WHEN 102 THEN 'Disk - Permanent'
		WHEN 5 THEN 'Tape - Temporary'
		WHEN 105 THEN 'Tape - Temporary'
		ELSE 'Other Device'
	END AS 'Device Type', -- Device type
	CAST((bs.backup_size / 1024 / 1024) AS numeric(36, 2)) AS 'Backup Size (MB)',
	-- Normal backup size (In bytes)
	CAST((compressed_backup_size / 1024 / 1024) AS numeric(36, 2)) AS 'Compressed Backup Size (MB)'
-- Compressed backup size (In bytes)
FROM msdb.dbo.backupset bs WITH (NOLOCK)
INNER JOIN msdb.dbo.backupmediafamily bmf WITH (NOLOCK)
	ON (bs.media_set_id = bmf.media_set_id)
	WHERE bs.database_name = @DBName
	AND bs.type = @BackupType1
	OR bs.type = @BackupType2
ORDER BY bs.backup_start_date DESC
GO