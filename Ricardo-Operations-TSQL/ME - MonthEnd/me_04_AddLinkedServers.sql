USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'HSP4S1A', @srvproduct=N'SQL Server'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'HSP4S1A',@useself=N'False',@locallogin=NULL,@rmtuser=N'SQLEDIMSUser04',@rmtpassword=''
GO

EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'collation name', @optvalue=NULL
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'HSP4S1A', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO