-- WAITFOR DELAY '00:59:00'
USE dbatools
GO
SELECT 'START', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME
GO
EXECUTE [dbo].[IndexOptimize]
	@Databases = 'AdventureWorksLT2019',
	@FragmentationLow = NULL,
	@FragmentationMedium = NULL,
	@FragmentationHigh = NULL,
	@UpdateStatistics = 'ALL',
	@StatisticsSample = 100,
	@OnlyModifiedStatistics = 'N'
GO

SELECT 'END', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME
GO