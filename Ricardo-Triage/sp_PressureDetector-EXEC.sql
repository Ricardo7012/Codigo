USE master;
GO
EXEC sp_pressuredetector;
GO
EXEC sp_pressuredetector @help = 1;
GO
SELECT @@servername AS SN, * FROM sys.configurations WHERE configuration_id = 1576;
GO
EXEC sp_configure 'remote admin connections', 1;
RECONFIGURE;
GO
SELECT @@servername AS SN, * FROM sys.configurations WHERE configuration_id = 1576;
GO
--:CONNECT ADMIN:SERVERNAME
