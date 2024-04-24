
USE [master]
GO
CREATE LOGIN [IEHP\ArchDevAdmin] FROM WINDOWS WITH DEFAULT_DATABASE=[HSP_Supplemental], DEFAULT_LANGUAGE=[us_english]
GO


--00 CREATE LOGINS ROLE AND SCHEMA
/******************************************************************************
--CREATE LOGIN
--
*******************************************************************************/
USE [master]
GO
--CREATE TEST USER LOGIN
CREATE LOGIN [EbmUser] WITH PASSWORD=N'D@ng3rB1llR0b1ns0n'
GO
CREATE LOGIN [EbmUser]
WITH PASSWORD = 0x0200E42DDA3700E18979164EE576C603D4D63FB4CF9799865335A8ACF7D5704AE397131EA99C77A4742EF4CABFF404FA82254EDC74436168B2F9781BB88B3169F52927AEDEDC HASHED,
     CHECK_POLICY = OFF;

USE HSP_Supplemental;
GO
/******************************************************************************
--CREATE ROLE
--
*******************************************************************************/
CREATE ROLE EBMRole AUTHORIZATION dbo;
EXEC sp_addrolemember 'EBMRole', 'EBMUser';
GO
/******************************************************************************
--EBM SCHEMA
--
*******************************************************************************/
USE [HSP_Supplemental]
GO
CREATE SCHEMA EBM AUTHORIZATION EbmUser;
GO

CREATE USER [EbmUser] FOR LOGIN [EbmUser] WITH DEFAULT_SCHEMA = [EBM];
ALTER ROLE [db_datareader] ADD MEMBER [EbmUser];
ALTER ROLE [db_executor] ADD MEMBER [EbmUser];
GRANT CONNECT TO [EbmUser];
GO
GRANT ALTER,
      DELETE,
      EXECUTE,
      INSERT,
      REFERENCES,
      SELECT,
      UPDATE,
      VIEW DEFINITION
ON SCHEMA::EBM
TO  EBMRole;

GRANT CREATE TABLE,
      CREATE PROCEDURE,
      CREATE FUNCTION,
      CREATE VIEW
TO  EBMRole;
GO
/******************************************************************************
--EBMLastRun SCHEMA
--
*******************************************************************************/
USE [HSP_Supplemental]
GO
CREATE SCHEMA EBMLastRun AUTHORIZATION EbmUser;
GO
GRANT ALTER,
      DELETE,
      EXECUTE,
      INSERT,
      REFERENCES,
      SELECT,
      UPDATE,
      VIEW DEFINITION
ON SCHEMA::EBMLastRun
TO  EBMRole;

--GRANT CREATE TABLE,
--      CREATE PROCEDURE,
--      CREATE FUNCTION,
--      CREATE VIEW
--TO  EBMRole;
GO
/******************************************************************************
--EBMNextRun SCHEMA
--
*******************************************************************************/
USE [HSP_Supplemental]
GO
CREATE SCHEMA EBMTempRun AUTHORIZATION EbmUser;
GO
GRANT ALTER,
      DELETE,
      EXECUTE,
      INSERT,
      REFERENCES,
      SELECT,
      UPDATE,
      VIEW DEFINITION
ON SCHEMA::EBMTempRun
TO  EBMRole;

--GRANT CREATE TABLE,
--      CREATE PROCEDURE,
--      CREATE FUNCTION,
--      CREATE VIEW
--TO  EBMRole;
GO
/******************************************************************************
--NDDB SCHEMA
--
*******************************************************************************/
USE [HSP_Supplemental]
GO
CREATE SCHEMA NDDB AUTHORIZATION EbmUser;
GO

CREATE USER [EbmUser] FOR LOGIN [EbmUser] WITH DEFAULT_SCHEMA = [NDDB];
ALTER ROLE [db_datareader] ADD MEMBER [EbmUser];
ALTER ROLE [db_executor] ADD MEMBER [EbmUser];
GRANT CONNECT TO [EbmUser];
GO
GRANT ALTER,
      DELETE,
      EXECUTE,
      INSERT,
      REFERENCES,
      SELECT,
      UPDATE,
      VIEW DEFINITION
ON SCHEMA::NDDB
TO  EBMRole;

GRANT CREATE TABLE,
      CREATE PROCEDURE,
      CREATE FUNCTION,
      CREATE VIEW
TO  EBMRole;
GO

USE [HSP_Supplemental]
GO
ALTER AUTHORIZATION ON SCHEMA::[EBM] TO [dbo]
ALTER AUTHORIZATION ON SCHEMA::[EBMLastRun] TO [dbo]
ALTER AUTHORIZATION ON SCHEMA::[EBMTempRun] TO [dbo]
--ALTER AUTHORIZATION ON SCHEMA::[EBMTest] TO [dbo]
GO

use [HSP_Supplemental]
GO
GRANT ALTER ON SCHEMA::[EBM] TO [EBMRole]
GRANT DELETE ON SCHEMA::[EBM] TO [EBMRole]
GRANT EXECUTE ON SCHEMA::[EBM] TO [EBMRole]
GRANT INSERT ON SCHEMA::[EBM] TO [EBMRole]
GRANT REFERENCES ON SCHEMA::[EBM] TO [EBMRole]
GRANT SELECT ON SCHEMA::[EBM] TO [EBMRole]
GRANT UPDATE ON SCHEMA::[EBM] TO [EBMRole]
GRANT VIEW DEFINITION ON SCHEMA::[EBM] TO [EBMRole]

GRANT ALTER ON SCHEMA::[EBMLastRun] TO [EBMRole]
GRANT DELETE ON SCHEMA::[EBMLastRun] TO [EBMRole]
GRANT EXECUTE ON SCHEMA::[EBMLastRun] TO [EBMRole]
GRANT INSERT ON SCHEMA::[EBMLastRun] TO [EBMRole]
GRANT REFERENCES ON SCHEMA::[EBMLastRun] TO [EBMRole]
GRANT SELECT ON SCHEMA::[EBMLastRun] TO [EBMRole]
GRANT UPDATE ON SCHEMA::[EBMLastRun] TO [EBMRole]
GRANT VIEW DEFINITION ON SCHEMA::[EBMLastRun] TO [EBMRole]

GRANT ALTER ON SCHEMA::[EBMTempRun] TO [EBMRole]
GRANT DELETE ON SCHEMA::[EBMTempRun] TO [EBMRole]
GRANT EXECUTE ON SCHEMA::[EBMTempRun] TO [EBMRole]
GRANT INSERT ON SCHEMA::[EBMTempRun] TO [EBMRole]
GRANT REFERENCES ON SCHEMA::[EBMTempRun] TO [EBMRole]
GRANT SELECT ON SCHEMA::[EBMTempRun] TO [EBMRole]
GRANT UPDATE ON SCHEMA::[EBMTempRun] TO [EBMRole]
GRANT VIEW DEFINITION ON SCHEMA::[EBMTempRun] TO [EBMRole]
GO

USE [HSP_Supplemental]
GO
ALTER ROLE [db_executor] ADD MEMBER [IEHP\ArchDevAdmin]
GO

USE [HSP_Supplemental]
GO
--CREATE ROLE [EBMAdmin]
GO
GRANT VIEW DEFINITION ON USER::[IEHP\ArchDevAdmin] TO [EBMAdmin]
GO
ALTER ROLE [EBMAdmin] ADD MEMBER [IEHP\ArchDevAdmin]
GO
ALTER ROLE [EBMRole] ADD MEMBER [IEHP\ArchDevAdmin]
GO
/**********************************************************************************
ADDED FOR HSP1S1A MOVE 06-22-2018
************************************************************************************/
USE [HSP_MO]
GO
CREATE USER [IEHP\ArchDevAdmin] FOR LOGIN [IEHP\ArchDevAdmin]
ALTER ROLE [db_datareader] ADD MEMBER [IEHP\ArchDevAdmin]
ALTER ROLE [db_executor] ADD MEMBER [IEHP\ArchDevAdmin]
GO

