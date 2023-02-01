-- Backup for SQL Express

USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Description: Backup Database Stored Proc
-- Param1: dbName 
-- Param2: backupType F = full, D = differential, L = log
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_BackupDB] @dbName SYSNAME
	, @backupTypeToRun CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(1000)
	DECLARE @dateTime NVARCHAR(20)

	SELECT @dateTime = REPLACE(CONVERT(VARCHAR, GETDATE(), 111), '/', '-') + '-' + REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '')

	DECLARE @databaseFileName NVARCHAR(200)

	SET @databaseFileName = replace(@dbName, ']', '')
	SET @databaseFileName = replace(@databaseFileName, '[', '')

	IF @backupTypeToRun = 'F'
		SET @sqlCommand = 'BACKUP DATABASE ' + @dbName + ' TO DISK = ''\\DEVTESTSQL2014\TFS Backup\' + @databaseFileName + '_Full_' + @dateTime + '.Bak'''

	IF @backupTypeToRun = 'D'
		SET @sqlCommand = 'BACKUP DATABASE ' + @dbName + ' TO DISK = ''\\DEVTESTSQL2014\TFS Backup\' + @databaseFileName + '_Diff_' + @dateTime + '.Bak'' WITH DIFFERENTIAL'

	IF @backupTypeToRun = 'L'
		SET @sqlCommand = 'BACKUP LOG ' + @dbName + ' TO DISK = ''\\DEVTESTSQL2014\TFS Backup\' + @databaseFileName + '_Log_' + @dateTime + '.Trn'''

	EXECUTE sp_executesql @sqlCommand
END
