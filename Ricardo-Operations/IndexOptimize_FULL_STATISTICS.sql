WAITFOR DELAY '00:59:00'
SELECT 'START', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME

EXECUTE dbo.sp_IEHP_IndexOptimize
@Databases = 'ALL_DATABASES',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = 'ALL',
@StatisticsSample = 100,
@OnlyModifiedStatistics = 'N'
GO

SELECT 'END', @@ServerName AS SERVERNAME,DB_NAME() AS DATABASENAME, GETDATE() AS DATETIME
