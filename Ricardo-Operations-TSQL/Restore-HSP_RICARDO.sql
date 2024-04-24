/******************************************************************************
COPY DATABASE USER PERMISSIONS FIRST!!
Script DB Level Permissions and Logins v3.sql
*******************************************************************************/
SET STATISTICS TIME, IO ON;
PRINT GETDATE();
PRINT @@ServerName;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master]
GO
ALTER DATABASE [HSP_IT_SB2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE [HSP_IT_SB2]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1B\HSP_COPYONLY.bak'
WITH FILE = 1
   , NOUNLOAD
   , REPLACE
   , MAXTRANSFERSIZE = 4194304
   , BUFFERCOUNT = 2048
   , STATS = 5;

GO

ALTER DATABASE [HSP_IT_SB2] SET MULTI_USER;

/******************************************************************************
SERVICE BROKER
*******************************************************************************/
USE HSP_IT_SB2
GO

SET NOCOUNT ON;
SELECT is_broker_enabled
FROM sys.databases
WHERE name = 'HSP_IT_SB2';
PRINT 'is_broker_enabled #1 COMPLETED';
GO
ALTER DATABASE HSP_IT_SB2 SET DISABLE_BROKER;
PRINT 'disable_broker COMPLETED';
GO
ALTER DATABASE HSP_IT_SB2 SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE;
PRINT 'ENABLE_BROKER COMPLETED';
GO
ALTER DATABASE HSP_IT_SB2 SET NEW_BROKER;
PRINT 'NEW_BROKER COMPLETED';
GO
SELECT is_broker_enabled
FROM sys.databases
WHERE name = 'HSP_IT_SB2';
PRINT 'is_broker_enabled #2 COMPLETED';
GO
sp_changedbowner HSP_dbo;
PRINT 'sp_changedbowner COMPLETED';
GO

SET STATISTICS TIME, IO OFF;
PRINT GETDATE();
PRINT @@ServerName;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master]
GO
ALTER DATABASE [HSP_IT_SB2] SET RECOVERY SIMPLE WITH NO_WAIT
GO
SET STATISTICS TIME, IO OFF
GO
