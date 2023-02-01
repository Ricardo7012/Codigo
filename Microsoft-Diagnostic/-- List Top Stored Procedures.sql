-- List Top Stored Procedures

SELECT usecounts AS 'Use Count'
	, cacheobjtype AS 'Cache Object Type'
	, objtype AS 'Object Type'
	, size_in_bytes AS 'Size in Bytes'
	, text AS 'Text'
	, query_plan AS 'Query Plan'
FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
CROSS APPLY sys.dm_exec_query_plan(plan_handle)
WHERE usecounts > 1
	AND TEXT LIKE '%Proc_ReconstructPlayerTrips%'
	AND objtype = 'Proc'
ORDER BY usecounts ASC
