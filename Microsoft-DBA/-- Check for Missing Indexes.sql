-- Check for Missing Indexes

SELECT t.NAME AS 'affected_table'
	, 'Create NonClustered Index IX_' + t.NAME + '_missing_' + Cast(ddmid.index_handle AS VARCHAR(10)) + ' On ' + ddmid.statement + ' (' + IsNull(ddmid.equality_columns, '') + CASE 
		WHEN ddmid.equality_columns IS NOT NULL
			AND ddmid.inequality_columns IS NOT NULL
			THEN ','
		ELSE ''
		END + IsNull(ddmid.inequality_columns, '') + ')' + IsNull(' Include (' + ddmid.included_columns + ');', ';') AS sql_statement
	, ddmigs.user_seeks
	, ddmigs.user_scans
	, Cast((ddmigs.user_seeks + ddmigs.user_scans) * ddmigs.avg_user_impact AS INT) AS 'est_impact'
	, ddmigs.last_user_seek
FROM sys.dm_db_missing_index_groups AS ddmig
INNER JOIN sys.dm_db_missing_index_group_stats AS ddmigs
	ON ddmigs.group_handle = ddmig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS ddmid
	ON ddmig.index_handle = ddmid.index_handle
INNER JOIN sys.tables AS t
	ON ddmid.object_id = t.object_id
WHERE ddmid.database_id = DB_ID()
	AND Cast((ddmigs.user_seeks + ddmigs.user_scans) * ddmigs.avg_user_impact AS INT) > 100
ORDER BY Cast((ddmigs.user_seeks + ddmigs.user_scans) * ddmigs.avg_user_impact AS INT) DESC;
