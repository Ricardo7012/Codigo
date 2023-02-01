-- List Stored Procedure (Count, ShowPlan)

SELECT decp.usecounts AS 'Use Count'
	, cacheobjtype AS 'Cache Object Type'
	, objtype AS 'Object Type'
	, OBJECT_NAME(dest.objectid) AS 'Object Name'
	, deqp.query_plan
FROM sys.dm_exec_cached_plans decp
CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
WHERE dest.objectid = OBJECT_ID('fn_CompBalance')
	AND dest.dbid = DB_ID()
ORDER BY usecounts DESC;
