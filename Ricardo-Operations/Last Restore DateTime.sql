--LAST RESTORE DATE
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT  [rs].[destination_database_name]
       ,[rs].[restore_date]
       ,[bs].[backup_start_date]
       ,[bs].[backup_finish_date]
       ,[bs].[database_name] AS [source_database_name]
       ,[bmf].[physical_device_name] AS [backup_file_used_for_restore]
FROM    msdb..restorehistory rs
        INNER JOIN msdb..backupset bs ON [rs].[backup_set_id] = [bs].[backup_set_id]
        INNER JOIN msdb..backupmediafamily bmf ON [bs].[media_set_id] = [bmf].[media_set_id]
ORDER BY [rs].[restore_date] DESC;

WITH LastRestores AS
(
SELECT  DatabaseName = [d].[name]
       ,[d].[create_date]
       ,[d].[compatibility_level]
       --,[d].[collation_name]
       ,r.*
       ,RowNum = ROW_NUMBER() OVER ( PARTITION BY d.name ORDER BY r.[restore_date] DESC )
FROM    master.sys.databases d
        LEFT OUTER JOIN msdb.dbo.[restorehistory] r ON r.[destination_database_name] = d.name
)
SELECT  *
FROM    [LastRestores]
WHERE   [Recovery] = 1


SELECT *
FROM msdb.dbo.[restorehistory]
ORDER BY restore_date DESC;

