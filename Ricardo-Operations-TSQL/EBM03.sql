--03 CREATE SCHEMA AND LOGINS 
USE [master]
GO
--CREATE TEST USER LOGIN
CREATE LOGIN [EbmUser] WITH PASSWORD=N'D@ng3rB1llR0b1ns0n'
GO

USE HSP_Supplemental
GO
/*****************************************************
 *** ROLE ***
******************************************************/
--CREATE ROLE
CREATE ROLE EBMRole AUTHORIZATION [dbo]
--CREATE USER DATABASE LEVEL
CREATE USER [EbmUser] FOR LOGIN [EbmUser] WITH DEFAULT_SCHEMA=[EBM]
--Allow user to connect to database
GRANT CONNECT TO [EbmUser]

--ensure role membership is correct
EXEC sp_addrolemember N'EBMRole', N'EbmUser'
--allow users to create tables in Developer_Schema [EBM]
GRANT CREATE TABLE TO EBMRole
--allow users to create procedures in Developer_Schema [EBM]
GRANT CREATE PROCEDURE TO EBMRole
GO
/*****************************************************
 *** SCHEMA ***
******************************************************/
--CREATE SCHEMA
CREATE SCHEMA [EBM] AUTHORIZATION [dbo]
GO
--APPLY PERMISSIONS TO SCHEMAS
GRANT ALTER ON SCHEMA::[EBM] TO EBMRole
GRANT CONTROL ON SCHEMA::[EBM] TO EBMRole
GRANT SELECT ON SCHEMA::[EBM] TO EBMRole
GRANT DELETE ON SCHEMA::[EBM] TO [EBMRole]
GRANT EXECUTE ON SCHEMA::[EBM] TO [EBMRole]
GRANT INSERT ON SCHEMA::[EBM] TO [EBMRole]
GRANT UPDATE ON SCHEMA::[EBM] TO [EBMRole]
GRANT VIEW DEFINITION ON SCHEMA::[EBM] TO [EBMRole]
GO


/***********************************************************
 *** CHANGE THIS TO CORRECT DATABASE ***
***********************************************************/
USE [HSP]
GO
CREATE USER [EbmUser] FOR LOGIN [EbmUser]
ALTER ROLE [db_datareader] ADD MEMBER [EbmUser]
ALTER ROLE [db_executor] ADD MEMBER [EbmUser]
GO

/***********************************************************
 *** DEV ONLY ***
***********************************************************/
USE [master]
GO
CREATE LOGIN [IEHP\ArchDevAdmin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
USE HSP_Supplemental
GO
CREATE USER [IEHP\ArchDevAdmin] FOR LOGIN [IEHP\ArchDevAdmin] WITH DEFAULT_SCHEMA=[EBM]
--ensure role membership is correct
EXEC sp_addrolemember N'EBMRole', N'IEHP\ArchDevAdmin'
GO
USE [HSP]
GO
CREATE USER [IEHP\ArchDevAdmin] FOR LOGIN [IEHP\ArchDevAdmin]
ALTER ROLE [db_datareader] ADD MEMBER [IEHP\ArchDevAdmin]
ALTER ROLE [db_executor] ADD MEMBER [IEHP\ArchDevAdmin]
GO
/***********************************************************
 *** DEV ONLY ***
***********************************************************/
