USE [master]
GO

-- Login: _QHSPAppDSvc

CREATE LOGIN [_QHSPAppDSvc] WITH PASSWORD=N'p23ESo23Zq57htRjqkcdzm/7CtGZ5KdE6XsauHMCjN8=', 
	SID = 0xB52C6F9DACBABD4898E6F041C6253235, 
	DEFAULT_DATABASE=[tempdb], 
	DEFAULT_LANGUAGE=[us_english], 
	CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


-- Login: _QHSPAppDSvc
CREATE LOGIN [_QHSPAppDSvc] WITH PASSWORD = 0x0200DE24E8E21EFC43932A8EB8E2046C6F76075644247A087DD3C06F5024E55120E3715454D0D197A459E453F930CC9776EEE9C922A5D639D532990F98484020566B41785B58 HASHED, 
	SID = 0xB52C6F9DACBABD4898E6F041C6253235, 
	DEFAULT_DATABASE = [tempdb], 
	CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
GO


USE [master]
GO

CREATE USER [_QHSPAppDSvc] FOR LOGIN [_QHSPAppDSvc]
GO

ALTER USER [_QHSPAppDSvc] WITH DEFAULT_SCHEMA=[dbo]
GO

GRANT VIEW ANY DATABASE TO [_QHSPAppDSvc]
GO

GRANT VIEW ANY definition to [_QHSPAppDSvc]
GO

GRANT VIEW server state to [_QHSPAppDSvc]
GO

GRANT SELECT ON [sys].[master_files] TO [_QHSPAppDSvc]
GO

GRANT execute on sp_helplogins to [_QHSPAppDSvc];
GO

GRANT execute on sp_readErrorLog to [_QHSPAppDSvc]
GO

USE [msdb]
GO

CREATE USER [_QHSPAppDSvc] FOR LOGIN [_QHSPAppDSvc]
GO

ALTER USER [_QHSPAppDSvc] WITH DEFAULT_SCHEMA=[dbo]
GO

GRANT SELECT on dbo.sysjobsteps TO [_QHSPAppDSvc]
GO

GRANT SELECT on dbo.sysjobs TO [_QHSPAppDSvc]
GO

GRANT SELECT on dbo.sysjobhistory TO [_QHSPAppDSvc]
GO

/*  -- SKIPPED FOR B NODE
------ User Databases -----
USE [HSP_MO]
GO

CREATE USER [_QHSPAppDSvc] FOR LOGIN [_QHSPAppDSvc]
GO

ALTER USER [_QHSPAppDSvc] WITH DEFAULT_SCHEMA=[dbo]
GO
*/
