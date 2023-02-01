-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql

USE HSP_MO
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
FROM sys.stats;

--DBCC SHOW_STATISTICS ('', );  
--GO 

