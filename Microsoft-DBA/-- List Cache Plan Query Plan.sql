-- List Cache Plan Query Plan

;WITH XMLNAMESPACES (DEFAULT N'http://schemas.microsoft.com/sqlserver/2004/07/showplan') 

SELECT cp.usecounts AS 'Use Counts'
	, cp.refcounts AS 'Ref Counts'
	, cp.objtype AS 'Object Type'
	, cp.cacheobjtype AS 'Cache Object Type'
	, des.dbid AS 'DB ID'
	, des.TEXT AS 'Query Text'
	, deq.query_plan AS 'Query Plan'
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS des
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS deq
WHERE deq.query_plan.exist(N'/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple/QueryPlan/MissingIndexes/MissingIndexGroup') <> 0
ORDER BY cp.usecounts DESC
