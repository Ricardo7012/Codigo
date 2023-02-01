-- https://msdn.microsoft.com/en-us/library/ms189631.aspx 
SELECT @@servername as SN, *
FROM sys.configurations ORDER BY NAME--where configuration_id = 16388

EXEC sp_configure 'remote access', 0 ;  
GO  
RECONFIGURE ;  
GO  

--SIMPLE SELECT FOR ALL VALUES
SELECT *
FROM sys.configurations
ORDER BY [name];
GO

--ALL ADVANCED OPTIONS CONFIGURATIONS
SELECT * 
FROM sys.configurations
WHERE is_advanced = 1 order by name asc
GO

--ALL OPTIONS REQUIRING THE RECONFIGURE OPTION
SELECT * 
FROM sys.configurations
WHERE is_dynamic = 1 
GO

--ALL  RELATED CONFIGURATIONS 
SELECT * 
FROM sys.configurations
WHERE [Name] = 'max degree of parallelism'
GO
 

EXEC sp_configure 'Show Advanced Options', 0;
GO
RECONFIGURE;
GO
EXEC sp_configure;

-- BACKUP COMPRESSION
-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/view-or-configure-the-backup-compression-default-server-configuration-option?view=sql-server-2017
SELECT name
     , value
     , value_in_use
FROM sys.configurations
WHERE name LIKE '%backup%' AND value = 0;
GO
EXEC sp_configure 'backup compression default', 1;
RECONFIGURE;
GO

