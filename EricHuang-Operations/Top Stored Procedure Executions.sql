SELECT DB_NAME(database_id) DatabaseName,
	OBJECT_NAME(object_id) ProcedureName,
	cached_time, last_execution_time, execution_count,
	(total_elapsed_time/execution_count)/1000000.00 AS avg_elapsed_time,
	type_desc
FROM sys.dm_exec_procedure_stats
WHERE DB_NAME(database_id) = 'HSP'
ORDER BY avg_elapsed_time DESC;


SELECT DB_NAME(database_id) DatabaseName,
	OBJECT_NAME(object_id) ProcedureName,
	--cached_time, last_execution_time,
	SUM(execution_count) AS TotalExecutionCount,
	--SUM(total_elapsed_time)/SUM(execution_count) AS AvgElapsedTime_Microseconds,
	(SUM(total_elapsed_time)/SUM(execution_count)/1000000.0) AS AvgElapsedTime_Seconds
	--type_desc
FROM sys.dm_exec_procedure_stats
WHERE DB_NAME(database_id) = 'HSP' 
GROUP BY DB_NAME(database_id), OBJECT_NAME(object_id)
ORDER BY 4 DESC
--ORDER BY avg_elapsed_time;



SELECT TOP 50 
	OBJECT_NAME(qt.objectid) AS ObjectName,
	qs.statement_start_offset, qs.statement_end_offset,
	qs.execution_count,
	qs.total_logical_reads,
	qs.total_logical_reads/qs.execution_count as avg_logical_reads,
	qs.total_logical_writes,
	qs.total_logical_writes / qs.execution_count as avg_logical_writes,
	qs.total_elapsed_time/1000000.0 total_elapsed_time_in_S,
	(qs.total_elapsed_time/1000000.0) / qs.execution_count as avg_elapsed_time_in_S
FROM sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE OBJECT_NAME(qt.objectid) IS NOT NULL
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time




SELECT TOP 10 -- Change as appropriate
	t.text ,
	s.sql_handle ,
	s.plan_handle ,
	s.total_worker_time / 1000 AS total_cpu_time_millis ,
	s.total_worker_time / s.execution_count / 1000 AS avg_cpu_time_millis ,
	s.total_logical_reads,
	s.total_logical_reads / s.execution_count AS avg_logical_reads ,
	s.total_logical_writes,
	s.total_logical_writes / s.execution_count AS avg_logical_writes ,
	s.total_physical_reads,
	s.total_physical_reads / s.execution_count AS avg_physical_reads,
	s.cached_time,
	s.execution_count ,
	s.last_execution_time,
	s.last_elapsed_time / 1000 AS last_elapsed_time_millis,
	s.last_logical_reads,
	s.last_physical_reads,
	s.last_worker_time / 1000 AS last_worker_time_millis
FROM	sys.dm_exec_procedure_stats AS s
CROSS APPLY sys.dm_exec_sql_text(s.sql_handle) AS t
WHERE	DB_NAME(t.dbid) = 'HSP' -- Substitute for your database name
	AND s.last_execution_time > '2022-01-01 00:00:00.000' -- Change date as appropriate (or comment out)
	--AND s.last_physical_reads > 10 -- Sample filter; change column and value as appropriate
ORDER BY -- Comment/uncomment below to order by column of interest
	avg_logical_reads DESC
--	avg_physical_reads DESC
--	avg_cpu_time_millis DESC
--	last_elapsed_time_millis DESC
;


SELECT TOP 50 
	OBJECT_NAME(qt.objectid) AS ObjectName,
	--SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
	--((CASE qs.statement_end_offset
	--WHEN -1 THEN DATALENGTH(qt.TEXT)
	--ELSE qs.statement_end_offset
	--END - qs.statement_start_offset)/2)+1),
	qs.execution_count,
	qs.total_logical_reads, qs.last_logical_reads,
	qs.total_logical_writes, qs.last_logical_writes,
	qs.total_worker_time,
	qs.last_worker_time,
	qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
	qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
	qs.last_execution_time,
	qp.query_plan
FROM sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time


SELECT Db_Name(QueryText.dbid) AS database_name,
  Sum(CASE WHEN ExecPlans.usecounts = 1 THEN 1 ELSE 0 END) AS Single,
  Sum(CASE WHEN ExecPlans.usecounts > 1 THEN 1 ELSE 0 END) AS Reused,
  Sum(ExecPlans.size_in_bytes) / (1024) AS KB
FROM sys.dm_exec_cached_plans AS ExecPlans
	CROSS APPLY sys.dm_exec_sql_text(ExecPlans.plan_handle) AS QueryText
WHERE ExecPlans.cacheobjtype = 'Compiled Plan' AND QueryText.dbid IS NOT NULL
GROUP BY QueryText.dbid;


SELECT Convert(INT,Sum
        (
        CASE a.objtype 
        WHEN 'Adhoc' 
        THEN 1 ELSE 0 END)
        * 1.00/ Count(*) * 100
              ) as 'Ad-hoc query %'
FROM sys.dm_exec_cached_plans AS a


select top 100 *
from sys.dm_exec_cached_plans
where objtype = 'Adhoc' 

SELECT cplan.usecounts, cplan.objtype, qtext.text, qplan.query_plan, cplan.
FROM sys.dm_exec_cached_plans AS cplan
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS qtext
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qplan
WHERE cplan.objtype = 'Adhoc' and qtext.text NOT LIKE '--RedGate%'
ORDER BY cplan.usecounts DESC
