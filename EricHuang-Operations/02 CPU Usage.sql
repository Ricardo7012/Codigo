--Exploring ring buffers to get historical data
SELECT @@SERVERNAME

DECLARE @ms_ticks_now BIGINT

SELECT @ms_ticks_now = ms_ticks
FROM sys.dm_os_sys_info;

SELECT record_id
	,dateadd(ms, - 1 * (@ms_ticks_now - [timestamp]), GetDate()) AS EventTime
	,SQLProcessUtilization
	,CASE WHEN (100 - SystemIdle - SQLProcessUtilization) < 0 THEN 0
		ELSE 100 - SystemIdle - SQLProcessUtilization
		END AS OtherProcessUtilization
	,CASE WHEN (SystemIdle + y.SQLProcessUtilization) > 100
			THEN y.SQLProcessUtilization
		ELSE 100 - y.SystemIdle
		END AS TotalCPU
	--,SystemIdle
FROM (
	SELECT record.value('(./Record/@id)[1]', 'int') AS record_id
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization
		,TIMESTAMP
	FROM (
		SELECT TIMESTAMP
			,convert(XML, record) AS record
		FROM sys.dm_os_ring_buffers
		WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
			AND record LIKE '%<SystemHealth>%'
		) AS x
	) AS y
ORDER BY record_id DESC





SELECT  scheduler_id
        ,cpu_id
        ,status
        ,runnable_tasks_count
        ,active_workers_count
		,current_tasks_count
        ,load_factor
        ,yield_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255 AND runnable_tasks_count > 0


/*
scheduler_id – ID of the scheduler. All schedulers that are used to run regular queries have ID numbers less than 1048576. 
Those schedulers that have IDs greater than or equal to 1048576 are used internally by SQL Server, such as the 
dedicated administrator connection scheduler.

cpu_id – ID of the CPU with which this scheduler is associated.

status – Indicates the status of the scheduler.

runnable_tasks_count – Number of workers, with tasks assigned to them that are waiting to be scheduled on the runnable queue.

active_workers_count – Number of workers that are active. An active worker is never preemptive, must have an associated 
task, and is either running, runnable, or suspended.

current_tasks_count - Number of current tasks that are associated with this scheduler.

load_factor – Internal value that indicates the perceived load on this scheduler.

yield_count – Internal value that is used to indicate progress on this scheduler.
*/


SELECT TOP 10 st.text
               ,st.dbid
               ,st.objectid
               ,qs.total_worker_time
               ,qs.last_worker_time
               ,qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_worker_time DESC


--total_worker_time - Total amount of CPU time, in microseconds, that was consumed by executions of this plan since it was compiled.
-- last_worker_time - CPU time, in microseconds, that was consumed the last time the plan was executed.

 

--Examining SQL Server processes - The output shows the data sorted by CPU
SELECT 
	r.session_id
	,st.TEXT AS batch_text
	,SUBSTRING(st.TEXT, statement_start_offset / 2 + 1, (
			(
				CASE 
					WHEN r.statement_end_offset = - 1
						THEN (LEN(CONVERT(NVARCHAR(max), st.TEXT)) * 2)
					ELSE r.statement_end_offset
					END
				) - r.statement_start_offset
			) / 2 + 1) AS statement_text
	,qp.query_plan AS 'XML Plan'
	,r.*
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp
ORDER BY cpu_time DESC


--Below query gives us an overview of cached batches or procedures which have used most CPU historically:
select top 50 
    sum(qs.total_worker_time) as total_cpu_time, 
    sum(qs.execution_count) as total_execution_count,
    count(*) as  number_of_statements, 
    qs.plan_handle 
from 
    sys.dm_exec_query_stats qs
group by qs.plan_handle
order by sum(qs.total_worker_time) desc


--TOP 50 cached plans that consumed the most cumulative CPU All times are in microseconds
SELECT TOP 50 qs.creation_time, qs.execution_count, qs.total_worker_time as total_cpu_time, 
	qs.max_worker_time as max_cpu_time, qs.total_elapsed_time, qs.max_elapsed_time, 
	qs.total_logical_reads, qs.max_logical_reads, qs.total_physical_reads, 
	qs.max_physical_reads,t.[text], qp.query_plan, t.dbid, t.objectid, t.encrypted, 
	qs.plan_handle, qs.plan_generation_num 
FROM sys.dm_exec_query_stats qs 
	CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
	CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp 
ORDER BY qs.total_worker_time DESC