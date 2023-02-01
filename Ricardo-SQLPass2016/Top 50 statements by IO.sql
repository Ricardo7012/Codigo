-- TOP 50 STATEMENTS BY IO
SELECT TOP 50
        (qs.total_logical_reads + qs.total_logical_writes) /qs.execution_count as [Avg IO],
            SUBSTRING(qt.text,qs.statement_start_offset/2, 
                  (case when qs.statement_end_offset = -1 
                  then len(convert(nvarchar(max), qt.text)) * 2 
                  else qs.statement_end_offset end -qs.statement_start_offset)/2) 
            as query_text,
            qt.dbid, dbname=db_name(qt.dbid),
            qt.objectid,
            qs.sql_handle,
            qs.plan_handle
FROM sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) as qt
ORDER BY 
       [Avg IO] DESC

