USE [master]
GO
EXEC [dbo].[sp_IEHP_DatabaseIntegrityCheck] @Databases = 'EdiManagement', @CheckCommands= 'CHECKDB',  @PhysicalOnly = 'Y'

--@Databases = 'ALL_DATABASES', @CheckCommands = 'CHECKDB', @PhysicalOnly = 'N', @NoIndex = 'N', @ExtendedLogicalChecks = 'N', @TabLock = 'N', @FileGroups = NULL, @Objects = NULL, @MaxDOP = NULL, @AvailabilityGroups = NULL, @AvailabilityGroupReplicas = 'ALL', @Updateability = 'ALL', @LockTimeout = NULL, @LogToTable = 'N', @Execute = 'Y'
GO


ALTER DATABASE [EdiManagement] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DBCC CHECKDB(EdiManagement, REPAIR_ALLOW_DATA_LOSS);
ALTER DATABASE [EdiManagement] SET MULTI_USER WITH ROLLBACK IMMEDIATE;

USE [master]
GO
ALTER DATABASE [EdiManagement] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
USE [master]
GO
EXECUTE dbo.sp_IEHP_IndexOptimize
 @Databases = 'EDIManagement',
 @FragmentationLow = NULL,
 @FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
 @FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
 @FragmentationLevel1 = 5,
 @FragmentationLevel2 = 30,
 @UpdateStatistics = 'ALL',
 @OnlyModifiedStatistics = 'Y'
GO
ALTER DATABASE EdiManagement SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO