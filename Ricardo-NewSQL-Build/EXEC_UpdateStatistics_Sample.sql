USE master
GO
EXECUTE dbo.sp_IndexOptimize
@Databases = 'All_DATABASES',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = 'ALL'

--EXECUTE dbo.IndexOptimize
--@Databases = ''USER_DATABASES'',
--@FragmentationLow = NULL,
--@FragmentationMedium = NULL,
--@FragmentationHigh = NULL,
--@UpdateStatistics = ''ALL'',
--@OnlyModifiedStatistics = ''Y''', 