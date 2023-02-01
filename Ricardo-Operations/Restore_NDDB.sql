-- COPY BAK FROM: \\jupiter\production\SQLC\Network_Development
-- RENAME TO Network_Development.bak
USE [master]
ALTER DATABASE [Network_Development] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [Network_Development] FROM  DISK = N'E:\MSSQL\Backup\Network_Development.bak' 
WITH  
FILE = 1,  
MOVE N'Network_Development_Data' TO N'E:\MSSQL\Data\Network_Development.MDF',  
MOVE N'Network_Development_IDX' TO N'E:\MSSQL\Data\Network_Development.NDF',  
MOVE N'Network_Development_Log' TO N'L:\MSSQL\LOG\Network_Development_1.LDF',  
NOUNLOAD,  
REPLACE,  
STATS = 5
ALTER DATABASE [Network_Development] SET MULTI_USER

GO


USE [Network_Development]
GO
--CREATE ROLE [db_executor]
GO
GRANT EXECUTE TO db_executor
GO
 
 
USE [Network_Development]
GO
CREATE USER [IEHP\HSPSQLPDataReader] FOR LOGIN [IEHP\HSPSQLPDataReader]
GO
USE [Network_Development]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IEHP\HSPSQLPDataReader]
GO
USE [Network_Development]
GO
CREATE USER [IEHP\HSPSQLPDataWriter] FOR LOGIN [IEHP\HSPSQLPDataWriter]
GO
USE [Network_Development]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [IEHP\HSPSQLPDataWriter]
GO
USE [Network_Development]
GO
CREATE USER [IEHP\HSPSQLPExecute] FOR LOGIN [IEHP\HSPSQLPExecute]
GO
USE [Network_Development]
GO
ALTER ROLE [db_executor] ADD MEMBER [IEHP\HSPSQLPExecute]
GO

USE [master] 
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'IEHP\ADMINSQL')
BEGIN
DECLARE @CreateError INT
CREATE LOGIN [IEHP\ADMINSQL] FROM WINDOWS
SET @CreateError = @@ERROR


IF EXISTS(SELECT * FROM sys.databases where name = N'HSP')
ALTER LOGIN [IEHP\ADMINSQL] WITH DEFAULT_DATABASE=[HSP]

GRANT CONNECT SQL TO [IEHP\ADMINSQL] 


USE [Network_Development]
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'IEHP\ADMINSQL')
CREATE USER [IEHP\ADMINSQL] FOR LOGIN [IEHP\ADMINSQL] WITH DEFAULT_SCHEMA=[dbo]

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_datareader' AND type = 'R')
EXEC sp_addrolemember N'db_datareader', N'IEHP\ADMINSQL'


END