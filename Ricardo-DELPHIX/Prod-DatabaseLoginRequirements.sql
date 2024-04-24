/****** CREATE SECTION ******/
-- https://documentation.delphix.com/continuous-data-10-0-0-0/docs/overview-of-requirements-for-sql-server-environments?highlight=sql%20user%20permissions
-- CONNECT: HSP1S1C
-- PDataMasking_RO - PWD in keeppass
USE [master]
GO
CREATE LOGIN [\] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
GO
CREATE USER [\] FOR LOGIN [\]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IEHP\PDataMasking_RO]
GO
USE [msdb]
GO
CREATE USER [IEHP\PDataMasking_RO] FOR LOGIN [IEHP\PDataMasking_RO]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IEHP\PDataMasking_RO]
GO

---- OPTIONAL: Required for the discovery of databases in Availability Groups
--GRANT VIEW DEFINITION TO [IEHP\PDataMasking_RO]
--GO
---- OPTIONAL: Required for the SnapSync and discovery of Availability 
--GRANT VIEW SERVER STATE TO [IEHP\PDataMasking_RO]
--GO
---- OPTIONAL: Required when using backups created by Red Gate SQL Backup
--GRANT EXECUTE TO dbo.sqbutility 
--GO
---- OPTIONAL: Required when using backups created by Quest LiteSpeed for SQL Server
--GRANT EXECUTE TO dbo.xp_sqllightspeed_version 
--GO

/****** DROP SECTION ******/
USE [msdb]
GO
DROP USER [\]
GO
USE [master]
GO
DROP USER [\]
GO
DROP LOGIN [\]
GO
USE [master]
GO
DROP LOGIN [\]
GO

-- CREATTE A SECOND ACCOUNT FOR NON-PROD DEPLOYMENT
-- QDataMasking_SA - PWD in keeppass
USE [master]
GO
CREATE LOGIN [\] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [\]
GO

