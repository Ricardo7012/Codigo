SELECT suser_sname( owner_sid ) FROM sys.databases where database_id > 5

DECLARE @sql1 varchar(1000)
SELECT @sql1 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb'' AND ''?'' <> ''HSPLicensing''
BEGIN
USE [?] 
ALTER AUTHORIZATION ON DATABASE::? TO [HSP_dbo]
END'
PRINT @sql1 
EXEC sp_msforeachdb @sql1 
--PRINT @sql1 

SELECT suser_sname( owner_sid ) FROM sys.databases --where database_id > 5
