-- https://www.cdata.com/kb/articles/sqlgateway-linked-server.rst
USE [master]
GO
EXEC master.dbo.sp_addlinkedserver 
	@server = N'DVLAKAMB01_CDATA64', 
	@srvproduct=N'', 
	@provider=N'SQLNCLI11', 
	@datasrc=N'172.18.207.132,1439', 
	@catalog=N'DVLAKAMB01_CDATA64'

GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'rpc', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'rpc out', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'DVLAKAMB01_CDATA64', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

EXEC master.dbo.sp_addlinkedsrvlogin 
	@rmtsrvname = N'DVLAKAMB01_CDATA64', 
	@locallogin = NULL , 
	@useself = N'False', 
	@rmtuser = N'hbase', 
	@rmtpassword = N'hbase'
GO

-- SQL SERVER MANAGEMENT STUDIO USES THE SQL SERVER CLIENT OLE DB PROVIDER, WHICH REQUIRES THE ODBC DRIVER TO BE USED INPROCESS. YOU MUST ENABLE THE "ALLOW INPROCESS" OPTION
USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'SQLOLEDB', N'AllowInProcess', 1
GO

-- TEST
SELECT * FROM DVLAKAMB01_CDATA64.DVLAKAMB01_CDATA64.ApacheHBase.census

-- CLEANUP 
USE [master]
EXEC master.dbo.sp_dropserver @server=N'DVLAKAMB01_CDATA64', @droplogins='droplogins'
GO
