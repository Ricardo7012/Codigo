--CREATE LOGIN [IEHP\_sqladmins] FROM WINDOWS WITH DEFAULT_DATABASE=master;
--GO
--EXEC master..sp_addsrvrolemember @loginame = N'IEHP\_sqladmins', @rolename = N'sysadmin'
--GO
ALTER LOGIN sa WITH PASSWORD=N'';
GO
ALTER LOGIN sa WITH NAME = _system_admin;
GO
--DISABLE SA
--ALTER LOGIN _system_admin DISABLE;
--GO
--DISABLE TELEMETRY
ALTER LOGIN [NT SERVICE\SQLTELEMETRY] DISABLE
GO
