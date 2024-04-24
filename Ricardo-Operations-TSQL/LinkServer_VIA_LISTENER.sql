------ https://sqlserver-help.com/2014/09/30/tips-and-tricks-creating-linked-server-to-an-availability-group-listener-with-readonly-routing/
---- EXECUTE ON HSP2S1B
--USE [master]
--GO
--CREATE LOGIN [SQLLSReadFIN02] WITH PASSWORD=N'EP36BbTUCYFo+D#ys-H1', DEFAULT_DATABASE=[HSP_MO], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
--GO
--USE [HSP_MO]
--GO
--CREATE USER [SQLLSReadFIN02] FOR LOGIN [SQLLSReadFIN02]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [SQLLSReadFIN02]
--GO

-- EXECUTE ON DESTINATION SERVER
USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'HSP2S1B'
, @srvproduct=N'HSP2S1B'
, @provider=N'SQLNCLI'
, @datasrc=N'QLVNNHSP02'
, @catalog=N'HSP_MO'
,@provstr = N'ApplicationIntent=ReadOnly'

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'HSP2S1B',@useself=N'False',@locallogin=NULL,@rmtuser=N'SQLLSReadFIN02',@rmtpassword='EP36BbTUCYFo+D#ys-H1'
GO


---TEST 
SELECT * FROM OPENQUERY(HSP2S1B,'SELECT @@servername')

