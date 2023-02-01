/*
 Use the Missing Indexes  DMV’s  
 Use Statistics Profile /XML events in Sql Trace
 Use sp_helpindex  and sys.indexes to view index information
 Use sys.dm_db_index_operational_stats  for index usage
*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT TOP 20
ROUND(s.avg_total_user_cost * s.avg_user_impact *
		(s.user_seeks + s.user_scans),0) AS [Total Cost]
, s.avg_user_impact
, d.statement AS TableName
, d.equality_columns
, d.inequality_columns
, d.included_columns
FROM sys.dm_db_missing_index_groups g
INNER JOIN sys.dm_db_missing_index_group_stats s
	ON s.group_handle = g.index_group_handle
INNER JOIN sys.dm_db_missing_index_details d
	ON d.index_handle = g.index_handle
ORDER BY [Total Cost] DESC;




--sys.dm_db_index_operational_stats FUNCTION SCRIPT: 
SELECT OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME], 
       B.[NAME] AS [INDEX NAME], 
       A.LEAF_INSERT_COUNT, 
       A.LEAF_UPDATE_COUNT, 
       A.LEAF_DELETE_COUNT, 
	   A.*
FROM   SYS.DM_DB_INDEX_OPERATIONAL_STATS (NULL,NULL,NULL,NULL ) A 
       INNER JOIN SYS.INDEXES AS B
         ON B.[OBJECT_ID] = A.[OBJECT_ID] 
            AND B.INDEX_ID = A.INDEX_ID 
WHERE  OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1