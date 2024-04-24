USE Diam_725;

SELECT @@SERVERNAME AS SQL_Instance, GETDATE() AS Current_Datetime

SELECT t1.resource_type AS [lock type],
       DB_NAME(resource_database_id) AS [database],
       t1.resource_associated_entity_id AS [blk object],
       t1.request_mode AS [lock req],           -- lock requested
       t1.request_session_id AS [waiter sid],   -- spid of waiter
       t2.wait_duration_ms AS [wait time],
       (
           SELECT text
           FROM sys.dm_exec_requests AS r --- get sql for waiter
               CROSS APPLY sys.dm_exec_sql_text(r.sql_handle)
           WHERE r.session_id = t1.request_session_id
       ) AS waiter_batch,
       (
           SELECT SUBSTRING(   qt.text,
                               r.statement_start_offset / 2,
                               (CASE
                                    WHEN r.statement_end_offset = -1 THEN
                                        LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                    ELSE
                                        r.statement_end_offset
                                END - r.statement_start_offset
                               ) / 2
                           )
           FROM sys.dm_exec_requests AS r
               CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS qt
           WHERE r.session_id = t1.request_session_id
       ) AS waiter_stmt,                        --- this is the statement executing right now
       t2.blocking_session_id AS [blocker sid], -- spid of blocker
       (
           SELECT text
           FROM sys.sysprocesses AS p --- get sql for blocker
               CROSS APPLY sys.dm_exec_sql_text(p.sql_handle)
           WHERE p.spid = t2.blocking_session_id
       ) AS blocker_stmt
FROM sys.dm_tran_locks AS t1,
     sys.dm_os_waiting_tasks AS t2
WHERE t1.lock_owner_address = t2.resource_address
ORDER BY CAST(t2.[wait_duration_ms] AS BIGINT) DESC;


