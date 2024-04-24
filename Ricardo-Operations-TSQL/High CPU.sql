-- https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/performance/troubleshoot-high-cpu-usage-issues
/******************************************************************************
-- 1. VERIFY THAT SQL SERVER IS CAUSING HIGH CPU USAGE
-- 2. IDENTIFY QUERIES CONTRIBUTING TO CPU USAGE
******************************************************************************/
declare @init_sum_cpu_time int
      , @utilizedCpuCount  int; 
	  --get CPU count used by SQL Server
	  select @utilizedCpuCount = count(*)from sys.dm_os_schedulers where status = 'VISIBLE ONLINE';
	  --calculate the CPU usage by queries OVER a 5 sec interval 
	  select @init_sum_cpu_time = sum(cpu_time)
from sys.dm_exec_requests;
waitfor delay '00:00:05';
select convert(decimal(5, 2), ((sum(cpu_time) - @init_sum_cpu_time) / (@utilizedCpuCount * 5000.00)) * 100) as [CPU FROM Queries AS Percent of Total CPU Capacity]
from sys.dm_exec_requests; 

/******************************************************************************
-- 3. UPDATE STATISTICS
-- 4. ADD MISSING INDEXES

-- Captures the Total CPU time spent by a query along with the query plan and total executions
******************************************************************************/
select qs_cpu.total_worker_time / 1000 as total_cpu_time_ms
     , q.[text]
     , p.query_plan
     , qs_cpu.execution_count
     , q.dbid
     , q.objectid
     , q.encrypted                     as text_encrypted
from
(
    select top 500
           qs.plan_handle
         , qs.total_worker_time
         , qs.execution_count
    from sys.dm_exec_query_stats qs
    order by qs.total_worker_time desc
)                                                 as qs_cpu
    cross apply sys.dm_exec_sql_text(plan_handle) as q
    cross apply sys.dm_exec_query_plan(plan_handle) p
where p.query_plan.exist('declare namespace qplan = "http://schemas.microsoft.com/sqlserver/2004/07/showplan"; //qplan:MissingIndexes') = 1; 

/******************************************************************************
-- 5. REVIEW EXECUTION PLANS
-- 6. INVESTIGATE AND RESOLVE PARAMETER-SENSITIVE ISSUES
-- 7. DISABLE HEAVY TRACING
******************************************************************************/

print '--Profiler trace summary--';
select traceid
     , property
     , convert(varchar(1024), value) as value
from::fn_trace_getinfo(default);
go
print '--Trace event details--';
select trace_id
     , status
     , case
           when row_number = 1 then
               path
           else
               null
       end              as path
     , case
           when row_number = 1 then
               max_size
           else
               null
       end              as max_size
     , case
           when row_number = 1 then
               start_time
           else
               null
       end              as start_time
     , case
           when row_number = 1 then
               stop_time
           else
               null
       end              as stop_time
     , max_files
     , is_rowset
     , is_rollover
     , is_shutdown
     , is_default
     , buffer_count
     , buffer_size
     , last_event_time
     , event_count
     , trace_event_id
     , trace_event_name
     , trace_column_id
     , trace_column_name
     , expensive_event
from
(
    select t.id                                                                                 as trace_id
         , row_number() over (partition by t.id order by te.trace_event_id, tc.trace_column_id) as row_number
         , t.status
         , t.path
         , t.max_size
         , t.start_time
         , t.stop_time
         , t.max_files
         , t.is_rowset
         , t.is_rollover
         , t.is_shutdown
         , t.is_default
         , t.buffer_count
         , t.buffer_size
         , t.last_event_time
         , t.event_count
         , te.trace_event_id
         , te.name                                                                              as trace_event_name
         , tc.trace_column_id
         , tc.name                                                                              as trace_column_name
         , case
               when te.trace_event_id in ( 23, 24, 40, 41, 44, 45, 51, 52, 54, 68, 96, 97, 98, 113, 114, 122, 146, 180 ) then
                   cast(1 as bit)
               else
                   cast(0 as bit)
           end                                                                                  as expensive_event
    from sys.traces                              t
        cross apply::fn_trace_geteventinfo(t.id) as e
        join sys.trace_events  te
            on te.trace_event_id = e.eventid
        join sys.trace_columns tc
            on e.columnid = trace_column_id
) as x;
go
print '--XEvent Session Details--';
select sess.name     'session_name'
     , event_name
     , xe_event_name
     , trace_event_id
     , case
           when xemap.trace_event_id in ( 23, 24, 40, 41, 44, 45, 51, 52, 54, 68, 96, 97, 98, 113, 114, 122, 146, 180 ) then
               cast(1 as bit)
           else
               cast(0 as bit)
       end           as expensive_event
from sys.dm_xe_sessions               sess
    join sys.dm_xe_session_events     evt
        on sess.address = evt.event_session_address
    inner join sys.trace_xe_event_map xemap
        on evt.event_name = xemap.xe_event_name;
go

/******************************************************************************
-- 8. CONFIGURE YOUR VIRTUAL MACHINE
If you're using a virtual machine, ensure that you aren't overprovisioning CPUs and that they're configured correctly. 

-- 9. SCALE UP SYSTEM TO USE MORE CPUS OR ARCHIVE SOME DATA. BEST IF YOU DO BOTH

******************************************************************************/

