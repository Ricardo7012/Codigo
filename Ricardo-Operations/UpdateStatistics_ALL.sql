USE [master]

EXECUTE dbo.sp_IEHP_IndexOptimize
@Databases = '''',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@StatisticsSample = 100,
@UpdateStatistics = ''ALL''
