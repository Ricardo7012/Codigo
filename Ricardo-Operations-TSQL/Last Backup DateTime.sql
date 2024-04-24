SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--select @@SERVERNAME
--go
-- MSDB DETAILS
DECLARE @DBName SYSNAME;
SET @DBName = DB_NAME(); -- modify these as you desire.
SET @DBName = NULL; -- comment this line if you want to limit the displayed history

SELECT 
	bs.machine_name
	, bs.database_name
	, bs.backup_start_date
	, bs.backup_finish_date
	, CONVERT(TIME,bs.backup_finish_date - bs.backup_start_date) as ElapsedTime
	, bs.backup_size
	, bs.compressed_backup_size -- = BYTES
	, bs.compressed_backup_size / 1073741824  AS 'GB'
	, bs.compressed_backup_size / 1099511627776   AS 'TB'
	, bs.[type]
	--, LogicalDeviceName = bmf.logical_device_name
    , PhysicalDeviceName = bmf.physical_device_name
FROM msdb.dbo.backupset bs
    INNER JOIN msdb.dbo.backupmediafamily bmf 
        ON [bs].[media_set_id] = [bmf].[media_set_id]
WHERE bs.type = 'D'
ORDER BY bs.backup_start_date DESC;
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/backupset-transact-sql?view=sql-server-ver15 

-- LAST BACKUP DATE 
--SELECT  sdb.name AS DatabaseName
--       ,COALESCE(CONVERT(VARCHAR(30), MAX(bus.backup_finish_date), 109), '-') AS LastBackUpDate
--FROM    sys.sysdatabases sdb
--        LEFT OUTER JOIN msdb.dbo.backupset bus ON bus.database_name = sdb.name
--WHERE   sdb.name NOT IN ( 'master', 'tempdb', 'model', 'msdb' )
--GROUP BY sdb.name;

-- MSDB DETAILS
DECLARE @DBName SYSNAME;
SET @DBName = DB_NAME(); -- modify these as you desire.
SET @DBName = NULL; -- comment this line if you want to limit the displayed history

SELECT DatabaseName = bs.database_name
    , BackupStartDate = bs.backup_start_date
	, bs.backup_finish_date
    , CompressedBackupSize = bs.compressed_backup_size
    , ExpirationDate = bs.expiration_date
    , BackupSetName = bs.name
    , RecoveryModel = bs.recovery_model
    , ServerName = bs.server_name
    , BackupType = CASE bs.type 
        WHEN 'D' THEN 'Database' 
        WHEN 'L' THEN 'Log' 
        ELSE '[unknown]' END
    , LogicalDeviceName = bmf.logical_device_name
    , PhysicalDeviceName = bmf.physical_device_name
FROM msdb.dbo.backupset bs
    INNER JOIN msdb.dbo.backupmediafamily bmf 
        ON [bs].[media_set_id] = [bmf].[media_set_id]
WHERE (bs.database_name = @DBName
    OR @DBName IS NULL) 
	--AND bs.name LIKE '%Member%'
    --AND bs.type = 'D'
ORDER BY bs.backup_start_date DESC;

DECLARE @DBName2 SYSNAME;
SET @DBName2 = DB_NAME(); -- modify these as you desire.
SET @DBName2 = NULL; -- comment this line if you want to limit the displayed history
SELECT 
bs.name
,bs.first_lsn
,bs.last_lsn
,bs.checkpoint_lsn
,bs.database_backup_lsn
,bs.backup_finish_date
,bs.type
,bs.database_name
,bs.is_copy_only
,bmf.physical_device_name
FROM msdb.dbo.backupset                   bs
    INNER JOIN msdb.dbo.backupmediafamily bmf
        ON [bs].[media_set_id] = [bmf].[media_set_id]
WHERE (
          bs.database_name = @DBName2
          OR @DBName2 IS NULL
      )
--AND bs.type = 'L'
--AND bs.database_name = 'HealthHomes'
ORDER BY bs.backup_start_date DESC;


----TRANSACTION LOG BACKUP 
--SELECT   d.name,
--         MAX(b.backup_finish_date) AS backup_finish_date
--FROM     master.sys.sysdatabases d
--         LEFT OUTER JOIN msdb..backupset b
--         ON       b.database_name = d.name
--         AND      b.type          = 'L'
--GROUP BY d.name
--ORDER BY backup_finish_date DESC




--select @@servername AS 'X'
--select getdate() as 'DATETIME'
--dbcc sqlperf(logspace)
