SELECT s.session_id,
       r.status,
       r.blocking_session_id 'Blk by',
       r.wait_type,
       wait_resource,
       r.wait_time / (1000.0) 'Wait Sec',
       r.cpu_time,
       r.logical_reads,
       r.reads,
       r.writes,
       r.total_elapsed_time / (1000.0) 'Elaps Sec',
       SUBSTRING(   st.text,
                    (r.statement_start_offset / 2) + 1,
                    ((CASE r.statement_end_offset
                          WHEN -1 THEN
                              DATALENGTH(st.text)
                          ELSE
                              r.statement_end_offset
                      END - r.statement_start_offset
                     ) / 2
                    ) + 1
                ) AS statement_text,
       COALESCE(
                   QUOTENAME(DB_NAME(st.dbid)) + N'.' + QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid, st.dbid)) + N'.'
                   + QUOTENAME(OBJECT_NAME(st.objectid, st.dbid)),
                   ''
               ) AS command_text,
       r.command,
       s.login_name,
       s.host_name,
       s.program_name,
       s.last_request_end_time,
       s.login_time,
       r.open_transaction_count
FROM sys.dm_exec_sessions AS s
    JOIN sys.dm_exec_requests AS r
        ON r.session_id = s.session_id
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id != @@SPID
ORDER BY r.cpu_time DESC,
         r.status,
         r.blocking_session_id,
         s.session_id;
