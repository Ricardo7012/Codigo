-- Missing Index DMV and System Impact

SELECT migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) AS 'Improvement Measure'
	, OBJECT_NAME(mid.Object_id) AS 'Object ID'
	, 'CREATE INDEX [missing_index_' + CONVERT(VARCHAR, mig.index_group_handle) + '_' + CONVERT(VARCHAR, mid.index_handle) + '_' + LEFT(PARSENAME(mid.statement, 1), 32) + ']' + ' ON ' + mid.statement + ' (' + ISNULL(mid.equality_columns, '') + CASE 
		WHEN mid.equality_columns IS NOT NULL
			AND mid.inequality_columns IS NOT NULL
			THEN ','
		ELSE ''
		END + ISNULL(mid.inequality_columns, '') + ')' + ISNULL(' INCLUDE (' + mid.included_columns + ')', '') AS 'Create Index Statement'
	, migs.last_user_seek AS 'Last User Seek'
	, migs.last_user_scan AS 'Last User Scan'
	, migs.avg_total_user_cost AS 'Avg Total User Cost'
	, migs.avg_total_system_cost AS 'Avg Total System Cost'
	, migs.avg_system_impact AS 'Avg System Impact'
	, migs.avg_user_impact AS 'Avg User Impact'
	, migs.system_seeks AS 'System Seeks'
	, migs.system_scans AS 'System Scans'
	, migs.last_system_seek AS 'Last System Seek'
	, migs.last_system_scan AS 'Last System Scan'
	, mid.statement AS 'Statement'
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs
	ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid
	ON mig.index_handle = mid.index_handle
WHERE migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC
