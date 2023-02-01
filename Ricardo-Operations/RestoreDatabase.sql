PRINT GETDATE()

-- https://support.purestorage.com/Solutions/Microsoft_Platform_Guide/Microsoft_SQL_Server/001_Microsoft_SQL_Server_Quick_Reference
-- https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/backup-compression-sql-server
SET STATISTICS TIME, IO ON;
GO

-- First you can try the sysprocesses to get SPID and Kill Them
DECLARE @DB SYSNAME -- Put the name of database here
DECLARE @SPID VARCHAR(4), @cmdSQL VARCHAR(10)

SET @DB = ''

-- Looks for all spids that are connected in the databases
DECLARE cCursor CURSOR
FOR SELECT CAST(SPID AS VARCHAR(4)) FROM master.dbo.sysprocesses
WHERE SPID > 50 -- To not try to Kill SQL Server Process
AND SPID != @@SPID -- To not kill yourself
AND DBID = DB_ID(@DB) -- To filter only the users connected in specific database

OPEN cCursor

FETCH NEXT FROM cCursor INTO @SPID

-- For each user connected in the database
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @cmdSQL = 'KILL ' + @SPID

 -- Kill the user
 EXEC (@cmdSQL)
 FETCH NEXT FROM cCursor INTO @SPID 
END

CLOSE cCURSOR

DEALLOCATE cCURSOR

USE [master];
ALTER DATABASE [Ricardo] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Ricardo] FROM DISK = N'\\MSSQL\Backup\Ricardo.bak' 
WITH 
	NOFORMAT
	, NOINIT
	, NAME = N''
	, SKIP
	, NOREWIND
	, NOUNLOAD
	, STATS = 5
	, MAXTRANSFERSIZE=4194304
	, BUFFERCOUNT = 2048
	, COMPRESSION
ALTER DATABASE [Ricardo] SET MULTI_USER;
GO

USE [master];
RESTORE DATABASE [HSP_ELIG_TEST]
FROM DISK = N'E:\BACKUP\HSP_CV_full.BAK0'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK1'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK2'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK3'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK4'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK5'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK6'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK7'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK8'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK9'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK10'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK11'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK12'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK13'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK14'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK15'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK16'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK17'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK18'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK19'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK20'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK21'
, DISK = N'E:\BACKUP\HSP_CV_full.BAK22'
WITH FILE = 1,
     MOVE N'HSP'
     TO N'E:\Data\HSP_ELIG_TEST.MDF',
     MOVE N'Secondary'
     TO N'E:\Data\HSP_ELIG_TEST.NDF',
     MOVE N'HSP_log'
     TO N'E:\LOG\HSP_Elig_Test.LDF',
     NOFORMAT
	, NOINIT
	, NAME = N''
	, SKIP
	, NOREWIND
	, NOUNLOAD
	, STATS = 5
	, MAXTRANSFERSIZE=4194304
	, BUFFERCOUNT = 2048
	, COMPRESSION

GO


GO
SET STATISTICS TIME, IO OFF;
GO