SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT r.session_id AS [Session_Id]
    ,r.command AS [command]
    ,CONVERT(NUMERIC(6, 2), r.percent_complete) AS [% Complete]
    ,GETDATE() AS [Current Time]
    ,CONVERT(VARCHAR(20), DATEADD(ms, r.estimated_completion_time, GetDate()), 20) AS [Estimated Completion Time]
    ,CONVERT(NUMERIC(32, 2), r.total_elapsed_time / 1000.0 / 60.0) AS [Elapsed Min]
    ,CONVERT(NUMERIC(32, 2), r.estimated_completion_time / 1000.0 / 60.0) AS [Estimated Min]
    ,CONVERT(NUMERIC(32, 2), r.estimated_completion_time / 1000.0 / 60.0 / 60.0) AS [Estimated Hours]
    ,CONVERT(VARCHAR(1000), (
            SELECT SUBSTRING(TEXT, r.statement_start_offset / 2, CASE
                        WHEN r.statement_end_offset = - 1
                            THEN 1000
                        ELSE (r.statement_end_offset - r.statement_start_offset) / 2
                        END) 'Statement text'
            FROM sys.dm_exec_sql_text(sql_handle)
            ))
FROM sys.dm_exec_requests r
WHERE command like 'Backup%'
GO 

--EXEC dbo.sp_WhoIsActive 

-- SET STATISTICS TIME, IO ON;
--GO
---- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql?view=sql-server-ver15
--DBCC TRACEON(3042, 3004, 3051, 3212,3014, 3605, 1816, -1)
--GO
-- PRINT 'START DT: ' + (CONVERT( VARCHAR(24), GETDATE(), 121))
--BACKUP DATABASE [dbname]
--TO  DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname01.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname02.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname03.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname04.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname05.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname06.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname07.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname08.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname09.bak',
--    DISK = '\\dtsqlbkups\EntDataSystems\DoNotDELETE\dbname10.bak'
--WITH FORMAT
--   , COPY_ONLY
--   , NOINIT
--   , NAME = 'DESCRIPTION IN HERE' -- MSDB.DBO.BACKUPSET.DESCRIPTION
--   , SKIP
--   , NOREWIND
--   , NOUNLOAD
--   , STATS = 1
---- , MAXTRANSFERSIZE = 4194304
---- , BUFFERCOUNT = 2048 --6144
---- , BLOCKSIZE = 65536
--   , COMPRESSION;

--BACKUP DATABASE [HSP_Supplemental]
--TO  DISK = 'Y:\20210521_QVSQLEDI01_HSP_Supplemental_1.bak'
--  , DISK = 'Q:\20210521_QVSQLEDI01_HSP_Supplemental_2.bak'
--  , DISK = 'R:\20210521_QVSQLEDI01_HSP_Supplemental_3.bak'
--  , DISK = 'U:\20210521_QVSQLEDI01_HSP_Supplemental_4.bak'
--  , DISK = 'V:\20210521_QVSQLEDI01_HSP_Supplemental_5.bak'
--  , DISK = 'W:\20210521_QVSQLEDI01_HSP_Supplemental_6.bak'
--  , DISK = 'X:\20210521_QVSQLEDI01_HSP_Supplemental_7.bak'
--WITH FORMAT
--   , COMPRESSION
--   , MAXTRANSFERSIZE = 524288
--   , BUFFERCOUNT = 512
--   , STATS = 1;

--SET STATISTICS TIME, IO ON;
--GO
--BACKUP DATABASE [HSP_Supplemental]
--TO DISK = 'NUL:'
--TO  DISK = '\\172.18.204.31\smbtest\test\20210528_HSP_Supplemental_1.bak'
--  , DISK = '\\172.18.204.32\smbtest\test\20210528_HSP_Supplemental_2.bak'
--  , DISK = '\\172.18.204.33\smbtest\test\20210528_HSP_Supplemental_3.bak'
--  , DISK = '\\172.18.204.34\smbtest\test\20210528_HSP_Supplemental_4.bak'
--  , DISK = '\\172.18.204.35\smbtest\test\20210528_HSP_Supplemental_5.bak'
--  , DISK = '\\172.18.204.36\smbtest\test\20210528_HSP_Supplemental_6.bak'
--  , DISK = '\\172.18.204.37\smbtest\test\20210528_HSP_Supplemental_7.bak'
--WITH NOFORMAT
--   , INIT
--   , COPY_ONLY
--   , SKIP
--   , CHECKSUM
--   , COMPRESSION
--   , STATS = 1
--   , BUFFERCOUNT = 6144
--   , MAXTRANSFERSIZE = 4194304
--   , BLOCKSIZE = 65536;
--GO
--DBCC TRACEON(3042, -1);
--GO
--SET STATISTICS TIME, IO OFF;
--GO
--DBCC TRACEOFF(3042, 3004, 3051, 3212,3014, 3605, 1816, -1)
--GO
--SET STATISTICS TIME, IO OFF;
--GO


-- CHECK HOW MANY PAGES APROX
--USE HSP_Supplemental
--go
--SELECT t.name                                   AS TableName
--     , p.rows                                   AS RowCounts
--     , SUM(a.total_pages)                       AS TotalPages
--     , SUM(a.used_pages)                        AS UsedPages
--     , (SUM(a.total_pages) - SUM(a.used_pages)) AS UnusedPages
--FROM sys.tables                     t
--    INNER JOIN sys.indexes          i
--        ON t.object_id = i.object_id
--    INNER JOIN sys.partitions       p
--        ON i.object_id = p.object_id
--           AND i.index_id = p.index_id
--    INNER JOIN sys.allocation_units a
--        ON p.partition_id = a.container_id
--WHERE t.name NOT LIKE 'dt%'
--      AND t.is_ms_shipped = 0
--      AND i.object_id > 255
--GROUP BY t.name
--       , p.rows WITH ROLLUP
--ORDER BY t.name
--GO 
--sys.sp_who2
--GO
--/**********************************************************
--WHO'S DOING WHAT WHERE
--**********************************************************/
--DECLARE @VersionDate DATETIME;
--EXEC DBAKit.dbo.sp_BlitzWho @Help = 0,                         -- tinyint
--						--@@Spid = 
--                     @ShowSleepingSPIDs = 1,            -- tinyint
--                     @ExpertMode = 1,                -- bit
--                     @Debug = NULL,                     -- bit
--                     @VersionDate = @VersionDate OUTPUT -- datetime
--GO

--DBCC SQLPERF(LOGSPACE);  
--GO  
----DBCC LOG(HSP)
--GO
--SELECT name, log_reuse_wait_desc FROM master.sys.databases WHERE name = 'hsp'
--GO
use msdb
go

SELECT bs.database_name
, backuptype = CASE 
	WHEN bs.type = 'D' and bs.is_copy_only = 0 THEN 'Full Database'
	WHEN bs.type = 'D' and bs.is_copy_only = 1 THEN 'Full Copy-Only Database'
	WHEN bs.type = 'I' THEN 'Differential database backup'
	WHEN bs.type = 'L' THEN 'Transaction Log'
	WHEN bs.type = 'F' THEN 'File or filegroup'
	WHEN bs.type = 'G' THEN 'Differential file'
	WHEN bs.type = 'P' THEN 'Partial'
	WHEN bs.type = 'Q' THEN 'Differential partial' END + ' Backup'
, bs.recovery_model
, BackupStartDate = bs.Backup_Start_Date
, BackupFinishDate = bs.Backup_Finish_Date
, LatestBackupLocation = bf.physical_device_name
, backup_size_mb = bs.backup_size/1024./1024.
, compressed_backup_size_mb = bs.compressed_backup_size/1024./1024.
, database_backup_lsn -- For tlog and differential backups, this is the checkpoint_lsn of the FULL backup it is based on. 
, checkpoint_lsn
, begins_log_chain
FROM msdb.dbo.backupset bs	
LEFT OUTER JOIN msdb.dbo.backupmediafamily bf ON bs.[media_set_id] = bf.[media_set_id]
WHERE 
	recovery_model in ('FULL', 'BULK-LOGGED')
AND 
	bs.backup_start_date > DATEADD(month, -1, sysdatetime()) --only look at last 1 months
AND
	bs.database_name = 'WebAPISecurity'
AND
	bs.type ='I'
ORDER BY bs.database_name ASC, bs.Backup_Start_Date DESC;

--select * FROM msdb.dbo.backupset 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
DECLARE @FromDate AS DATETIME;
-- Specify the from date value
--SET @FromDate = CONVERT(date,getdate());
SET @FromDate = Getdate() -1;

SELECT CONVERT(CHAR(100), SERVERPROPERTY('Servername'))                                              AS SQLServerName
     , bs.database_name
     , CASE bs.type
           WHEN 'D'
               THEN
               'Database'
           WHEN 'L'
               THEN
               'Log'
           WHEN 'I'
               THEN
               'Differential'
       END                                                                                           AS backup_type
     --, bs.backup_start_date
     , bs.backup_finish_date
     --, bs.expiration_date
     , DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date) 'Backup Elapsed Time (sec)'
     , bs.compressed_backup_size                                                     AS 'Compressed Backup Size in KB'
     , (bs.compressed_backup_size / 1024 / 1024)                                     AS 'Compress Backup Size in MB'
	 , (bs.compressed_backup_size / 1024 / 1024/1024)                                AS 'Compress Backup Size in GB'
     , bs.backup_size
     , bmf.logical_device_name
     , bmf.physical_device_name
	 , bmf.family_sequence_number
     , bs.name                                                                       AS backupset_name
     , bs.description
FROM msdb.dbo.backupmediafamily bmf
    INNER JOIN msdb.dbo.backupset bs
        ON bmf.media_set_id = bs.media_set_id
WHERE CONVERT(DATETIME, bs.backup_start_date, 102) >= @FromDate
      AND bs.backup_size > 0
	  AND bs.database_name = 'WebAPISecurity'
	  AND bs.type ='I'
ORDER BY bs.database_name
       , bs.backup_finish_date;

--SELECT * FROM msdb.dbo.backupmediafamily 
