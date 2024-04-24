SET STATISTICS TIME, IO ON;
PRINT GETDATE();
PRINT @@ServerName;

--RUN C:\Users\i4682\Documents\Ricardo\T-SQL\Operations[Script DB Level Permissions and Logins v3.sql] TO GET ALL PERMISSIONS FIRST

GO
/******************************************************************************
RESTORE
*******************************************************************************/
--USE [master];
ALTER DATABASE [HSP_QA2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
USE [master];
RESTORE DATABASE [HSP_QA2]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1A\HSP_MonthEnd'
WITH FILE = 1
   , MOVE N'HSP'
     TO N'E:\Data\HSP_QA2.mdf'
   , MOVE N'Secondary'
     TO N'E:\Data\HSP_QA2_1.ndf'
   , MOVE N'HSP_log'
     TO N'E:\Log\HSP_QA2_2.ldf'
   , NOUNLOAD
   , REPLACE
   , MAXTRANSFERSIZE = 4194304
   , BUFFERCOUNT = 2048
   , STATS = 5;

GO

ALTER DATABASE [HSP_QA2] SET MULTI_USER;

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

USE [HSP_QA2]
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

SELECT DISTINCT [DatabaseName]
      ,[LastUpdatedAt]
  FROM [HSPLicensing].[dbo].[LicenseKeys]
 
IF EXISTS (SELECT 1 FROM SystemOptions)
BEGIN 
UPDATE  SystemOptions
SET     ItemValue ='HSP4S1A' -- in our case
WHERE   ItemType = 'HSPLicensingSERVER'
END; 
--------------------------------------------------------------------------------
DELETE FROM HSPLicensing.dbo.Seats WHERE databasename = 'HSP_QA2'
