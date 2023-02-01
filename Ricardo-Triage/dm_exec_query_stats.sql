/*
RETURNS AGGREGATE PERFORMANCE STATISTICS FOR CACHED QUERY PLANS IN SQL SERVER. THE VIEW CONTAINS ONE ROW PER QUERY STATEMENT WITHIN THE CACHED PLAN, 
AND THE LIFETIME OF THE ROWS ARE TIED TO THE PLAN ITSELF. WHEN A PLAN IS REMOVED FROM THE CACHE, THE CORRESPONDING ROWS ARE ELIMINATED FROM THIS VIEW.
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-2017
*/
SELECT 
    substring(text,qs.statement_start_offset/2
        ,(CASE    
            WHEN qs.statement_end_offset = -1 THEN len(convert(nvarchar(max), text)) * 2 
            ELSE qs.statement_end_offset 
        END - qs.statement_start_offset)/2) 
    ,qs.plan_generation_num as recompiles
    ,qs.execution_count as execution_count
    ,qs.total_elapsed_time - qs.total_worker_time as total_wait_time
    ,qs.total_worker_time as cpu_time
    ,qs.total_logical_reads as reads
    ,qs.total_logical_writes as writes
FROM sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
    LEFT JOIN sys.dm_exec_requests r 
        ON qs.sql_handle = r.sql_handle
ORDER BY 5 DESC