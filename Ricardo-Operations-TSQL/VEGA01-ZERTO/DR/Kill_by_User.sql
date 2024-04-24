DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'KILL ' + CONVERT(VARCHAR(11), session_id) + N';'
FROM sys.dm_exec_sessions
  WHERE 
  --[program_name] = N'app_name' AND
  login_name = N'IEHP\E1003' 
  --AND last_request_start_time < DATEADD(HOUR, -5, SYSDATETIME());

PRINT @sql
EXEC sys.sp_executesql @sql;

USE [master]
GO
DROP LOGIN [IEHP\E1003]
GO
USE [HSP]
GO
DROP USER [IEHP\E1003]
GO
