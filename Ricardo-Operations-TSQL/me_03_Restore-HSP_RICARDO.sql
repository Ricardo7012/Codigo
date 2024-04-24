/******************************************************************************
SCRIPT LOGINS BEFORE RESTORE!!
*******************************************************************************/
/******************************************************************************
(Script DB Level Permissions and Logins v3.sql)

This script will script the role members for all roles on the database.

This is useful for scripting permissions before restoring.  
This will allow us to easily ensure permissions are not lost during a restoration. 
******************************************************************************/

SET STATISTICS TIME, IO ON;
PRINT GETDATE();
PRINT @@ServerName;
GO
/******************************************************************************
RESTORE HPSP4S1A
*******************************************************************************/
--USE [master];
ALTER DATABASE [HSP_QA2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
USE [master];
RESTORE DATABASE [HSP_QA2]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1A\HSP_MonthEnd.me'
WITH 
    NOUNLOAD
   , REPLACE
   , MAXTRANSFERSIZE = 4194304
   , BUFFERCOUNT = 2048
   , STATS = 1;
GO

ALTER DATABASE [HSP_QA2] SET MULTI_USER;

SET STATISTICS TIME, IO OFF;
PRINT GETDATE();
PRINT @@ServerName;
GO


/******************************************************************************
SERVICE BROKER
*******************************************************************************/
USE HSP_QA2
GO
SET NOCOUNT ON;
SELECT is_broker_enabled
FROM sys.databases
WHERE name = 'HSP_QA2';
PRINT 'is_broker_enabled #1 COMPLETED';
GO
ALTER DATABASE HSP_QA2 SET DISABLE_BROKER;
PRINT 'disable_broker COMPLETED';
GO
ALTER DATABASE HSP_QA2 SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE;
PRINT 'ENABLE_BROKER COMPLETED';
GO
ALTER DATABASE HSP_QA2 SET NEW_BROKER;
PRINT 'NEW_BROKER COMPLETED';
GO
SELECT is_broker_enabled
FROM sys.databases
WHERE name = 'HSP_QA2';
PRINT 'is_broker_enabled #2 COMPLETED';
GO
sp_changedbowner HSP_QA2_dbo;
PRINT 'sp_changedbowner COMPLETED';
GO

SELECT
[ItemValue]
FROM [dbo].[SystemOptions]
where ItemType ='HSPLicensingServer'
GO

UPDATE SystemOptions
SET ItemValue = @@SERVERNAME WHERE ItemType = 'HSPLicensingServer'

SELECT 
[ItemValue]
FROM [dbo].[SystemOptions]
where ItemType ='HSPLicensingServer'
GO
