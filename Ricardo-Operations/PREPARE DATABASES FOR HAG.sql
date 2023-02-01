/******************************************************************
PREPARE DATABASES FOR HAG
*******************************************************************/

SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')

DECLARE @sql1 varchar(1000)
DECLARE @sql2 varchar(1000) 
SET @sql2 = 'ALTER DATABASE [?] SET RECOVERY FULL WITH NO_WAIT '

SELECT @sql1 = 'USE [?]
IF ''?'' <> ''tempdb'' 
BEGIN
USE [?] 
' + @sql2 + 
'END'
EXEC sp_msforeachdb @sql1 
--PRINT @sql1 
--PRINT @sql2

SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')


--****************************************************************
SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')

DECLARE @sql1 varchar(1000)
DECLARE @sql2 varchar(1000) 
SET @sql2 = 'BACKUP DATABASE [?] TO DISK = ''NUL;'' '

SELECT @sql1 = 'USE [?]
IF ''?'' <> ''tempdb'' 
BEGIN
USE [?] 
' + @sql2 + 
'END'
EXEC sp_msforeachdb @sql1 
--PRINT @sql1 
--PRINT @sql2

SELECT [name], DATABASEPROPERTYEX([name],'recovery') FROM sysdatabases
--WHERE [name] NOT IN ('master','model','tempdb','msdb')
