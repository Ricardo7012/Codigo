
/******************************************************************************
KILL SAMPLE
******************************************************************************/
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'KILL ' + CONVERT(VARCHAR(11), session_id) + N';'
FROM sys.dm_exec_sessions
  WHERE 
  --[program_name] = N'app_name' AND
  login_name = 'IEHP\v3193'
  --AND last_request_start_time < DATEADD(HOUR, -5, SYSDATETIME());

PRINT @sql
EXEC sys.sp_executesql @sql;

USE [master]
GO
DROP LOGIN [IEHP\v3193]
GO
USE [HSP]
GO
DROP USER [IEHP\v3193]
GO
USE [master]
GO

IF NOT EXISTS (SELECT * FROM DBO.SYSUSERS WHERE NAME = 'IEHP\v3193' )
BEGIN
  PRINT 'Granting access to the current database to login iehp\v3193 ...'
		/******************************************************************************
		CREATE SAMPLE
		******************************************************************************/
		USE [master]
		CREATE LOGIN [IEHP\v3193] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]

		USE [HSP]
		CREATE USER [IEHP\v3193] FOR LOGIN [IEHP\v3193]
		ALTER ROLE [db_datareader] ADD MEMBER [IEHP\v3193]
		ALTER ROLE [db_datawriter] ADD MEMBER [IEHP\v3193]
		ALTER ROLE [db_executor] ADD MEMBER [IEHP\v3193]
		ALTER ROLE [db_ddladmin] ADD MEMBER [IEHP\v3193]
END ELSE BEGIN  
  PRINT 'Login iehp\v3193 already granted access to current database.'  
END 


USE [master]
GO
CREATE LOGIN [IEHP\v3193] FROM WINDOWS WITH DEFAULT_DATABASE=[tempdb]
GO
USE [HSP]
GO
CREATE USER [IEHP\v3193] FOR LOGIN [IEHP\v3193]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IEHP\v3193]
ALTER ROLE [db_datawriter] ADD MEMBER [IEHP\v3193]
ALTER ROLE [db_ddladmin] ADD MEMBER [IEHP\v3193]
ALTER ROLE [db_executor] ADD MEMBER [IEHP\v3193]
