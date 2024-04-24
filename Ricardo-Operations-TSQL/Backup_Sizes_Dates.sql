--SELECT name
--     , [description]
--     , value_in_use
--FROM sys.configurations
--WHERE name LIKE '%BACKUP%';


DECLARE @FromDate AS DATETIME;
-- Specify the from date value
--SET @FromDate = CONVERT(date,getdate());
SET @FromDate = Getdate() -1;

SELECT CONVERT(CHAR(100), SERVERPROPERTY('Servername'))                                              AS SQLServerName
     , msdb.dbo.backupset.database_name
     , CASE msdb..backupset.type
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
     --, msdb.dbo.backupset.backup_start_date
     , msdb.dbo.backupset.backup_finish_date
     --, msdb.dbo.backupset.expiration_date
     , DATEDIFF(SECOND, msdb.dbo.backupset.backup_start_date, msdb.dbo.backupset.backup_finish_date) 'Backup Elapsed Time (sec)'
     , msdb.dbo.backupset.compressed_backup_size                                                     AS 'Compressed Backup Size in KB'
     , (msdb.dbo.backupset.compressed_backup_size / 1024 / 1024)                                     AS 'Compress Backup Size in MB'
	 , (msdb.dbo.backupset.compressed_backup_size / 1024 / 1024/1024)                                AS 'Compress Backup Size in GB'
     , msdb.dbo.backupset.backup_size
     , msdb.dbo.backupmediafamily.logical_device_name
     , msdb.dbo.backupmediafamily.physical_device_name
     , msdb.dbo.backupset.name                                                                       AS backupset_name
     , msdb.dbo.backupset.description
FROM msdb.dbo.backupmediafamily
    INNER JOIN msdb.dbo.backupset
        ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
WHERE CONVERT(DATETIME, msdb.dbo.backupset.backup_start_date, 102) >= @FromDate
      AND msdb.dbo.backupset.backup_size > 0
	  AND bs.database_name = 'WebAPISecurity'
	AND bs.type ='I'
ORDER BY msdb.dbo.backupset.database_name
       , msdb.dbo.backupset.backup_finish_date;


-- https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/backupset-transact-sql?view=sql-server-2017

--SELECT @@ServerName                                  AS SERVERNAME
--     , name
--     , description
--     , database_name
--     , backup_size
--     , compressed_backup_size
--	 , (compressed_backup_size / 1048576) AS compressed_backup_size_MB
--	 , (compressed_backup_size / 1073741824) AS compressed_backup_size_GB
--     , backup_size / compressed_backup_size          AS CompressionRatio
--     , backup_finish_date
--     , type
--FROM msdb..backupset
--WHERE DATEDIFF(d, backup_finish_date, GETDATE()) = 0
--      --AND type = 'D'
--ORDER BY backup_finish_date DESC;



--SELECT * FROM msdb..backupset ORDER BY backup_finish_date desc

--SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')

--DECLARE @sql1 varchar(1000)
--DECLARE @sql2 varchar(1000) 
--SET @sql2 = 'SELECT backup_size / compressed_backup_size FROM msdb..backupset '

--SELECT @sql1 = 'USE [?]
--IF ''?'' <> ''tempdb'' 
--BEGIN
--USE [?] 
--' + @sql2 + 
--'END'
--EXEC sp_msforeachdb @sql1 
----PRINT @sql1 
----PRINT @sql2

--SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')



-- Total Byte count of the backup stored on disk.
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/backupset-transact-sql?view=sql-server-2017
SELECT database_name
     , backup_size
     , compressed_backup_size
     , backup_size / compressed_backup_size AS CompressedRatio
	 , backup_finish_date
	 , type
	 , name
FROM msdb..backupset
WHERE backup_finish_date >= '07/24/2019'
AND database_name = 'HSP_CFG'
--AND type = 'D'

SELECT *
FROM msdb..backupset
WHERE backup_finish_date >= '07/24/2019'
      AND database_name = 'HSP_CFG';
