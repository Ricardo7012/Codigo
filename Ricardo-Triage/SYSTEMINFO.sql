SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
USE master
go
--SELECT  *
--FROM    sys.configurations
--WHERE name = 'xp_cmdshell'
--go
EXEC sp_configure 'Show Advanced Options', 1;
GO
RECONFIGURE;
GO


EXEC sp_configure 'xp_cmdshell', 1 ;  
GO  
RECONFIGURE ;  
GO  
--GET ALL SYSTEMINFO
EXEC master..xp_cmdshell 'systeminfo'
GO 
EXEC sp_configure 'xp_cmdshell', 0 ;  
GO  
RECONFIGURE ;  
GO 

--SELECT  *
--FROM    sys.configurations
--WHERE name = 'xp_cmdshell'
--GO

EXEC sp_configure 'Show Advanced Options', 0;
GO
RECONFIGURE;
GO


SELECT *
FROM sys.dm_os_windows_info;  

SELECT *
FROM sys.dm_os_sys_info

SELECT @@servername as SERVERNAME, cpu_count, scheduler_count, max_workers_count, physical_memory_kb, virtual_machine_type_desc FROM sys.dm_os_sys_info
go

SELECT @@servername as SERVERNAME, OSVersion =RIGHT(@@version, LEN(@@version)- 3 -charindex (' ON ', @@VERSION)), * FROM sys.dm_os_host_info
GO

SELECT @@servername as SERVERNAME, @@Version AS VER
GO
