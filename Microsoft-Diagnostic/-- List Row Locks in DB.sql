-- List Row Locks in DB

SELECT object_name(s.object_id) AS 'Object Name'
	, i.NAME AS 'Index Name'
	, row_lock_count AS 'Row Lock Count'
	, row_lock_wait_count AS 'Row Lock Wait Count'
	, cast(100.0 * row_lock_wait_count / (1 + row_lock_count) AS NUMERIC(15, 2)) AS 'Block %'
	, row_lock_wait_in_ms AS 'Row Lock Wait in (ms)'
	, cast(1.0 * row_lock_wait_in_ms / (1 + row_lock_wait_count) AS NUMERIC(15, 2)) AS 'Avg Row Lock Waits in (ms)'
FROM sys.dm_db_index_operational_stats(db_id(), NULL, NULL, NULL) s
INNER JOIN sys.indexes i
	ON s.object_id = i.object_id
		AND s.index_id = i.index_id
WHERE objectproperty(s.object_id, 'IsUserTable') = 1
ORDER BY 'Object Name', row_lock_wait_count DESC
