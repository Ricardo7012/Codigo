---- EXECUTE ON HSP1S1B
--USE [master]
--GO
--CREATE LOGIN [SQLLSRead02] WITH PASSWORD=N'', DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
--GO

--USE [HSP_Supplemental]
--GO
--CREATE USER [SQLLSRead02] FOR LOGIN [SQLLSRead02]
--GO
--USE [HSP_Supplemental]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [SQLLSRead02]
--GO

SELECT @@SERVERNAME

-- EXECUTE ON SOURCE
USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'HSP1S1B', @srvproduct=N'HSP1S1B', @provider=N'SQLNCLI', @datasrc=N'HSP1S1B', @catalog=N'HSP_Supplemental'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'HSP1S1B',@useself=N'False',@locallogin=NULL,@rmtuser=N'SQLLSRead01',@rmtpassword=''
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'HSP1S1B', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

--GRANT EXECUTE ON SYS.XP_PROP_OLEDB_PROVIDER to [COMPANYDOMAIN\ADGroup];
