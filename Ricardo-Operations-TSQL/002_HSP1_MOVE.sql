USE [master]
GO
CREATE LOGIN [IEHP\ArchDevAdmin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
CREATE LOGIN [IEHP\QJAMSVC] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
CREATE LOGIN [IEHP\QSQLLITSVC] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [IEHP\QSQLLITSVC]
GO
CREATE LOGIN [IEHP\solaradmin] FROM WINDOWS WITH DEFAULT_DATABASE=[HSP], DEFAULT_LANGUAGE=[us_english]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [IEHP\solaradmin]
GO
CREATE LOGIN [IEHP\SQLHSP1SVC] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
CREATE LOGIN [IEHP\svcExBackups] FROM WINDOWS WITH DEFAULT_DATABASE=[HSP], DEFAULT_LANGUAGE=[us_english]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [IEHP\svcExBackups]
GO
CREATE LOGIN [SQLBatchLoadUser01] WITH PASSWORD=N'', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [bulkadmin] ADD MEMBER [SQLBatchLoadUser01]
GO
CREATE LOGIN [SQLiConnectUser01] WITH PASSWORD=N'', DEFAULT_DATABASE=[HSP], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
CREATE LOGIN [SSISDB_User01] WITH PASSWORD=N'', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO