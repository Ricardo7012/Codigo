--*****************************************************************************
-- HSP1S1A HSP
--*****************************************************************************
-- First you can try the sysprocesses to get SPID and Kill Them
DECLARE @DB SYSNAME -- Put the name of database here
DECLARE @SPID VARCHAR(4), @cmdSQL VARCHAR(10)

SET @DB = 'HSP'

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


USE [master]
GO
ALTER DATABASE [HSP] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

BACKUP DATABASE [HSP] TO  DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1A\HSP_Clone_20180201_NATIVE.bak' 
WITH 
NOFORMAT
, INIT
,  NAME = N'HSP-Full Database Backup'
, SKIP
, NOREWIND
, NOUNLOAD
,  STATS = 10
GO
ALTER DATABASE HSP SET MULTI_USER;
GO

--*****************************************************************************
-- HSP1S1A HSP_PRIME
--*****************************************************************************


-- First you can try the sysprocesses to get SPID and Kill Them
DECLARE @DB SYSNAME -- Put the name of database here
DECLARE @SPID VARCHAR(4), @cmdSQL VARCHAR(10)

SET @DB = 'HSP_Prime'

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
USE [master]
GO
ALTER DATABASE [HSP_Prime] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

BACKUP DATABASE [HSP_Prime] TO  DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1A\HSP_Prime_Clone_20180201_NATIVE.bak' 
WITH 
NOFORMAT
, INIT
,  NAME = N'HSP-Full Database Backup'
, SKIP
, NOREWIND
, NOUNLOAD
,  STATS = 10
GO

ALTER DATABASE HSP_Prime SET MULTI_USER;
GO

--*****************************************************************************
-- CHANGE CONNECTION TO HSP1S1B
-- HSP1S1B HSP_ELIG_TEST
--*****************************************************************************
-- First you can try the sysprocesses to get SPID and Kill Them
DECLARE @DB SYSNAME -- Put the name of database here
DECLARE @SPID VARCHAR(4), @cmdSQL VARCHAR(10)

SET @DB = 'HSP_ELIG_TEST'

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
USE [master]
GO
ALTER DATABASE HSP_ELIG_TEST SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

BACKUP DATABASE HSP_ELIG_TEST TO  DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1A\HSP_ELIG_TEST_Clone_20180201_NATIVE.bak' 
WITH 
NOFORMAT
, INIT
,  NAME = N'HSP-Full Database Backup'
, SKIP
, NOREWIND
, NOUNLOAD
,  STATS = 10
GO

ALTER DATABASE HSP_ELIG_TEST SET MULTI_USER;
GO

