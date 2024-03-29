-- List Cost of Queries

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
	, core
AS (
	SELECT eqp.query_plan AS [QueryPlan]
		, ecp.plan_handle [PlanHandle]
		, q.[Text] AS [Statement]
		, n.value('(@StatementOptmLevel)[1]', 'VARCHAR(25)') AS OptimizationLevel
		, ISNULL(CAST(n.value('(@StatementSubTreeCost)[1]', 'VARCHAR(128)') AS FLOAT), 0) AS SubTreeCost
		, ecp.usecounts [UseCounts]
		, ecp.size_in_bytes [SizeInBytes]
	FROM sys.dm_exec_cached_plans AS ecp
	CROSS APPLY sys.dm_exec_query_plan(ecp.plan_handle) AS eqp
	CROSS APPLY sys.dm_exec_sql_text(ecp.plan_handle) AS q
	CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS qn(n)
	)
SELECT TOP 100 QueryPlan AS 'Query Plan'
	, [Statement] AS'Statement'
	, OptimizationLevel AS 'Optimization Level'
	, SubTreeCost AS 'SubTree Cost'
	, UseCounts AS 'Use Counts'
	, SubTreeCost * UseCounts AS 'GrossCost'
	, SizeInBytes AS 'Size In Bytes'
--	, PlanHandle
FROM core
ORDER BY GrossCost DESC
	--SubTreeCost DESC
