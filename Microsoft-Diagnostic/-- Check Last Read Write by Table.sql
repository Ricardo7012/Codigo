-- Check Last (Read, Write) by Table

SELECT DISTINCT OBJECT_SCHEMA_NAME(t.[object_id]) AS 'Schema'
	, OBJECT_NAME(t.[object_id]) AS 'Table/View Name'
	, CASE 
		WHEN rw.last_read > 0
			THEN rw.last_read
		END AS 'Last Read'
	, rw.last_write AS 'Last Write'
--	, t.[object_id]
FROM sys.tables AS t
LEFT JOIN sys.dm_db_index_usage_stats AS us
	ON us.[object_id] = t.[object_id]
		AND us.database_id = DB_ID()
LEFT JOIN (
	SELECT MAX(up.last_user_read) AS 'last_read'
		, MAX(up.last_user_update) AS 'last_write'
		, up.[object_id]
	FROM (
		SELECT last_user_seek
			, last_user_scan
			, last_user_lookup
			, [object_id]
			, database_id
			, last_user_update
			, COALESCE(last_user_seek, last_user_scan, last_user_lookup, 0) AS null_indicator
		FROM sys.dm_db_index_usage_stats
		) AS sus
	UNPIVOT(last_user_read FOR read_date IN (
				last_user_seek
				, last_user_scan
				, last_user_lookup
				, null_indicator
				)) AS up
	WHERE database_id = DB_ID()
	GROUP BY up.[object_id]
	) AS rw
	ON rw.[object_id] = us.[object_id]
ORDER BY [Last Read]
	, [Last Write]
	, [Table/View Name];
