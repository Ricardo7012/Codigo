SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- LAST BACKUP DATE 
SELECT sdb.name                                                              AS DatabaseName
     , COALESCE(CONVERT(VARCHAR(30), MAX(bus.backup_finish_date), 109), '-') AS LastBackUpDate
FROM sys.sysdatabases                  sdb
    LEFT OUTER JOIN msdb.dbo.backupset bus
        ON bus.database_name = sdb.name
WHERE sdb.name NOT IN ( 'master', 'tempdb', 'model', 'msdb' )
GROUP BY sdb.name;
