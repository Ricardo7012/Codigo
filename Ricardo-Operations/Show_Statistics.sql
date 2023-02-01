USE HSP_RPT
GO

SELECT OBJECT_NAME(object_id) AS [ObjectName]
      ,[name] AS [StatisticName]
      ,STATS_DATE([object_id], [stats_id]) AS [StatisticUpdateDate]
	  ,auto_created
	  ,user_created
	  ,no_recompute
	  ,has_filter
	  ,filter_definition
	  ,is_temporary
	  ,is_incremental
FROM sys.stats
WHERE OBJECT_NAME(object_id) = 'Records'

--DBCC SHOW_STATISTICS ('', );  
--GO 

SELECT OBJECT_NAME(object_id) AS [ObjectName]
      ,[name] AS [StatisticName]
      ,STATS_DATE([object_id], [stats_id]) AS [StatisticUpdateDate]
	  ,auto_created
	  ,user_created
	  ,no_recompute
	  ,has_filter
	  ,filter_definition
	  ,is_temporary
	  ,is_incremental
FROM sys.stats
WHERE OBJECT_NAME(object_id) = 'Claims'
