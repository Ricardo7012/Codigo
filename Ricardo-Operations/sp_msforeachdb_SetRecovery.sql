/**********************************************************************
	SERVER: 
	SET RECOVERY SIMPLE
**********************************************************************/

SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')
DECLARE @sql1 varchar(1000)db

DECLARE @sql2 varchar(1000) 
SET @sql2 = 'ALTER DATABASE [?] SET RECOVERY SIMPLE WITH NO_WAIT '

SELECT @sql1 = 'USE [?]
IF ''?'' <> ''tempdb'' 
BEGIN
USE [?] 
' + @sql2 + 
'END'
--EXEC sp_msforeachdb @sql1 
PRINT @sql1 
PRINT @sql2

SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')

/**********************************************************************
ALTER AUTHORIZATION ON DATABASE
**********************************************************************/
DECLARE @sql3 varchar(1000)
DECLARE @sql4 varchar(1000) 
SET @sql4 = 'ALTER AUTHORIZATION ON DATABASE::[?] TO [_system_admin]'

SELECT @sql3 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb''
BEGIN
USE [?] 
' + @sql4 + 
'END'
--EXEC sp_msforeachdb @sql3 
PRINT @sql3 
PRINT @sql4

