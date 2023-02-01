-- List Avg Reads for all the DB

SELECT DB_NAME(st.dbid) AS 'DB Name'
	, OBJECT_SCHEMA_NAME(objectid, st.dbid) AS 'Schema Name'
	, OBJECT_NAME(objectid, st.dbid) AS 'Stored Procedure'
	, max(cp.usecounts) AS 'Execution Counts'
	, sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) AS 'Total IO'
	, sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) / (max(cp.usecounts)) AS 'Avg Total IO'
	, sum(qs.total_physical_reads) AS 'Total Physical Reads'
	, sum(qs.total_physical_reads) / (max(cp.usecounts) * 1.0) AS 'Avg Physical Read'
	, sum(qs.total_logical_reads) AS 'Total Logical Reads'
	, sum(qs.total_logical_reads) / (max(cp.usecounts) * 1.0) AS 'Avg Logical Read'
	, sum(qs.total_logical_writes) AS 'Total Logical Writes'
	, sum(qs.total_logical_writes) / (max(cp.usecounts) * 1.0) AS 'Avg Logical Writes'
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
INNER JOIN sys.dm_exec_cached_plans cp
	ON qs.plan_handle = cp.plan_handle
WHERE DB_NAME(st.dbid) IS NOT NULL
	AND cp.objtype = 'proc'
GROUP BY DB_NAME(st.dbid)
	, OBJECT_SCHEMA_NAME(objectid, st.dbid)
	, OBJECT_NAME(objectid, st.dbid)
ORDER BY sum(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) DESC
