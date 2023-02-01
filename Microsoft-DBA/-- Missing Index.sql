-- Missing Index

SELECT TOP 25 dm_mid.database_id AS 'Database ID'
	, dm_migs.avg_user_impact * (dm_migs.user_seeks + dm_migs.user_scans) AS 'Avg Est Impact'
	, dm_migs.last_user_seek AS 'Last User Seek'
	, OBJECT_NAME(dm_mid.OBJECT_ID, dm_mid.database_id) AS 'Table Name'
	, 'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID, dm_mid.database_id) + '_' + REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns, ''), ', ', '_'), '[', ''), ']', '') + CASE 
		WHEN dm_mid.equality_columns IS NOT NULL
			AND dm_mid.inequality_columns IS NOT NULL
			THEN '_'
		ELSE ''
		END + REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns, ''), ', ', '_'), '[', ''), ']', '') + ']' + ' ON ' + dm_mid.statement + ' (' + ISNULL(dm_mid.equality_columns, '') + CASE 
		WHEN dm_mid.equality_columns IS NOT NULL
			AND dm_mid.inequality_columns IS NOT NULL
			THEN ','
		ELSE ''
		END + ISNULL(dm_mid.inequality_columns, '') + ')' + ISNULL(' INCLUDE (' + dm_mid.included_columns + ')', '') AS 'Create Statement'
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
	ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
	ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY 'Avg Est Impact' DESC
GO


