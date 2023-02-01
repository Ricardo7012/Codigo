USE [master]
GO
--DROP LOGIN [SQL837OUT01]
--GO

CREATE LOGIN [SQL837OUT01] WITH PASSWORD=N'', DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE HSP
GO
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'SQL837OUT01') BEGIN CREATE USER  [SQL837OUT01] FOR LOGIN [SQL837OUT01] WITH DEFAULT_SCHEMA = [dbo] END; 
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'SQL837OUT01'
EXEC sp_addrolemember @rolename = 'db_datawriter', @membername = 'SQL837OUT01'
EXEC sp_addrolemember @rolename = 'db_executor', @membername = 'SQL837OUT01'
GRANT CONNECT TO [SQL837OUT01]
