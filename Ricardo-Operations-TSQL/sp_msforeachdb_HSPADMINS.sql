
DECLARE @sql1 varchar(1000)
DECLARE @sql2 varchar(1000) 
SET @sql2 = 'CREATE USER [IEHP\_HSPAdmins] FOR LOGIN [IEHP\_HSPAdmins] ALTER ROLE [db_datareader] ADD MEMBER [IEHP\_HSPAdmins]'

SELECT @sql1 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb'' AND ''?'' <> ''HSPLicensing''
BEGIN
USE [?] 
' + @sql2 + 
' 
END'
EXEC sp_msforeachdb @sql1 
--PRINT @sql1 
--PRINT @sql2
