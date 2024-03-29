--USE [master]
--GO

--CREATE LOGIN [IEHP\_EDPIntake] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
--GO

--CREATE LOGIN [IEHP\ArchDevAdmin] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
--GO

--CREATE LOGIN [IEHP\EDIMSArchDev] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb], DEFAULT_LANGUAGE=[us_english]
--GO
USE [EdiManagementBlob]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [EdiManagementBlob]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [EdiManagementHub]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [EdiManagementHub]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [HspMember]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [HspMember]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [Member]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [Member]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [MemberDoc]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [MemberDoc]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [X12277CA]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [X12277CA]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [X124010]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [X124010]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [X12834]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [X12834]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [X12837I]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [X12837I]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [X12837P]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [X12837P]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [X12999]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [X12999]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO
USE [X12TA1]
GO
CREATE USER [IEHP\EDIMSArchDev] FOR LOGIN [IEHP\EDIMSArchDev]
GO
USE [X12TA1]
GO
ALTER ROLE [db_owner] ADD MEMBER [IEHP\EDIMSArchDev]
GO


