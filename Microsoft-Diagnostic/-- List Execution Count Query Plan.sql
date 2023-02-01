-- List Execution Count & Query Plan

DECLARE @StoredProc VARCHAR(40)

SET @StoredProc = 'Proc_ReconstructPlayerDays'

SELECT cp.objtype AS 'Object Type'
	, OBJECT_NAME(st.objectid, st.dbid) AS 'Object Name'
	, cp.usecounts AS 'Execution Count'
	, st.TEXT AS 'Query Text'
	, qp.query_plan AS 'Query Plan'
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
WHERE OBJECT_NAME(st.objectid, st.dbid) = @StoredProc
