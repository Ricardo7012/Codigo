use master
go
EXECUTE dbo.sp_IEHP_IndexOptimize
@Databases = 'ALL_DATABASES',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = 'ALL',
@StatisticsSample = 100,
@OnlyModifiedStatistics = 'N'
GO
