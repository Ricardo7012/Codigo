-- FIX A REPLICA READ ONLY DB OWNER IN AN AVAILABILITY GROUP

BACKUP DATABASE [yourdb]
TO  DISK = N'\\servername\backups\.BAK'
WITH NOFORMAT,
     NOINIT,
     NAME = N'Full Database Backup',
     SKIP,
     NOREWIND,
     NOUNLOAD,
     COPY_ONLY,
     STATS = 10;
GO

-- Now remove DB from Replica AG Group (only run this on the secondary you are trying to correct the DB Owner on) 
ALTER DATABASE [yourdb] SET HADR OFF;

--Now (still connected to replica node) restore fully 
USE [master];
RESTORE DATABASE [yourdb]
FROM DISK = N'\\servername\backups\.BAK'
WITH FILE = 1,
     NOUNLOAD,
     STATS = 5;

ALTER AUTHORIZATION ON DATABASE::HSP TO HSP_dbo;

--Now (still connected to replica node) restore fully 
USE [master];
RESTORE DATABASE [yourdb]
FROM DISK = N'\\servername\backups\.BAK'
WITH FILE = 1,
     REPLACE,
     NORECOVERY,
     NOUNLOAD,
     STATS = 5;

RESTORE LOG [yourdb]
FROM DISK = '\\servername\logbackups\DBName_backup_2018_01_16_140023_9917111.trn'
WITH NORECOVERY;

ALTER DATABASE [HSP] SET HADR AVAILABILITY GROUP = [yourag];

