--------------------------------------------------------------------------------- 
--Database Backups for all databases For Previous Week 
--------------------------------------------------------------------------------- 
SELECT CONVERT(VARCHAR(128), SERVERPROPERTY('Servername')) AS Server,
       bs.database_name,
       bs.backup_start_date,
       bs.backup_finish_date,
       bs.expiration_date,
       CASE bs.type
           WHEN 'D' THEN
               'Database'
           WHEN 'L' THEN
               'Log'
       END AS backup_type,
	   bs.is_copy_only,
       bs.backup_size,
       bmf.logical_device_name,
       bmf.physical_device_name,
       bs.name AS backupset_name,
       bs.description
FROM msdb.dbo.backupmediafamily bmf
    INNER JOIN msdb.dbo.backupset bs
        ON bmf.media_set_id = bs.media_set_id
WHERE (CONVERT(DATETIME, bs.backup_start_date, 102) >= GETDATE() - 1)
ORDER BY bs.database_name,
         bs.backup_finish_date;


------------------------------------------------------------------------------------------- 
--Most Recent Database Backup for Each Database 
------------------------------------------------------------------------------------------- 
SELECT CONVERT(VARCHAR(128), SERVERPROPERTY('Servername')) AS Server,
       bs.database_name,
       MAX(bs.backup_finish_date) AS last_db_backup_date
FROM msdb.dbo.backupmediafamily bmf
    INNER JOIN msdb.dbo.backupset bs
        ON bmf.media_set_id = bs.media_set_id
WHERE bs.[type] = 'D'
GROUP BY bs.database_name
ORDER BY bs.database_name;


------------------------------------------------------------------------------------------- 
--Most Recent Database Backup for Each Database - Detailed 
------------------------------------------------------------------------------------------- 
SELECT A.[Server],
	   A.database_name,
       A.last_db_backup_date,
       B.backup_start_date,
       B.expiration_date,
       B.backup_size,
       B.logical_device_name,
       B.physical_device_name,
       B.backupset_name,
       B.description
FROM
(
    SELECT CONVERT(VARCHAR(128), SERVERPROPERTY('Servername')) AS Server,
           bs.database_name,
           MAX(bs.backup_finish_date) AS last_db_backup_date
    FROM msdb.dbo.backupmediafamily bmf
        INNER JOIN msdb.dbo.backupset bs
            ON bmf.media_set_id = bs.media_set_id
    WHERE bs.type = 'D'
    GROUP BY bs.database_name
) AS A
    LEFT JOIN
    (
        SELECT CONVERT(VARCHAR(128), SERVERPROPERTY('Servername')) AS Server,
               bs.database_name,
               bs.backup_start_date,
               bs.backup_finish_date,
               bs.expiration_date,
               bs.backup_size,
               bmf.logical_device_name,
               bmf.physical_device_name,
               bs.name AS backupset_name,
               bs.description
        FROM msdb.dbo.backupmediafamily bmf
            INNER JOIN msdb.dbo.backupset bs
                ON bmf.media_set_id = bs.media_set_id
        WHERE bs.type = 'D'
    ) AS B
        ON A.[Server] = B.[Server]
           AND A.[database_name] = B.[database_name]
           AND A.[last_db_backup_date] = B.[backup_finish_date]
ORDER BY A.database_name;


------------------------------------------------------------------------------------------- 
--Databases Missing a Data (aka Full) Back-Up Within Past 24 Hours 
------------------------------------------------------------------------------------------- 
--Databases with data backup over 24 hours old 
SELECT 
   CONVERT(VARCHAR(128), SERVERPROPERTY('Servername')) AS Server, 
   bs.database_name, 
   MAX(bs.backup_finish_date) AS last_db_backup_date, 
   DATEDIFF(hh, MAX(bs.backup_finish_date), GETDATE()) AS [Backup Age (Hours)] 
FROM    msdb.dbo.backupset bs
WHERE     bs.type = 'D'  
GROUP BY bs.database_name 
HAVING      (MAX(bs.backup_finish_date) < DATEADD(hh, - 24, GETDATE()))  

UNION  

--Databases without any backup history 
SELECT      
   CONVERT(VARCHAR(128), SERVERPROPERTY('Servername')) AS Server,  
   db.NAME AS database_name,  
   NULL AS [Last Data Backup Date],  
   9999 AS [Backup Age (Hours)]  
FROM 
   master.dbo.sysdatabases db LEFT JOIN msdb.dbo.backupset bs
       ON db.name  = bs.database_name 
WHERE bs.database_name IS NULL AND db.name <> 'tempdb' 
ORDER BY  
   bs.database_name 


