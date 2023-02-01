-- Missing Index Detail DMV

SELECT statement AS 'Table'
	, column_id AS 'Column'
	, column_name AS 'Column Name'
	, column_usage AS 'Column Usage'
	, migs.user_seeks AS 'User Seeks'
	, migs.user_scans AS 'User Scans'
	, migs.last_user_seek AS 'Last User Seek'
	, migs.avg_total_user_cost AS 'Avg Total User Cost'
	, migs.avg_user_impact AS 'Avg User Impact'
FROM sys.dm_db_missing_index_details AS mid
CROSS APPLY sys.dm_db_missing_index_columns(mid.index_handle)
INNER JOIN sys.dm_db_missing_index_groups AS mig
	ON mig.index_handle = mid.index_handle
INNER JOIN sys.dm_db_missing_index_group_stats AS migs
	ON mig.index_group_handle = migs.group_handle
ORDER BY mig.index_group_handle
	, mig.index_handle
	, column_id
GO


