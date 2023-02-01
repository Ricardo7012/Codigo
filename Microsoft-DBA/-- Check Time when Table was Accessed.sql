-- Check Time when Table was Accessed

WITH cte_recent
AS (
	SELECT SCHEMA_NAME(B.schema_id) + '.' + object_name(b.object_id) AS tbl_name
		, (
			SELECT MAX(last_user_dt)
			FROM (
				VALUES (last_user_seek)
					, (last_user_scan)
					, (last_user_lookup)
				) AS all_val(last_user_dt)
			) AS access_datetime
	FROM sys.dm_db_index_usage_stats a
	RIGHT JOIN sys.tables b
		ON a.object_id = b.object_id
	)
SELECT tbl_name
	, max(access_datetime) AS recent_datetime
FROM cte_recent
GROUP BY tbl_name
ORDER BY recent_datetime DESC
	, 1
