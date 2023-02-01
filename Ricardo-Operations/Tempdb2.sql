use tempdb
go

SELECT
  sys.dm_exec_sessions.session_id AS [SESSION ID]
  ,DB_NAME(ss.database_id) AS [DATABASE Name]
  ,HOST_NAME AS [System Name]
  ,program_name AS [Program Name]
  ,login_name AS [USER Name]
  ,status
  ,cpu_time AS [CPU TIME (in milisec)]
  ,total_scheduled_time AS [Total Scheduled TIME (in milisec)]
  ,total_elapsed_time AS    [Elapsed TIME (in milisec)]
  ,(memory_usage * 8)      AS [Memory USAGE (in KB)]
  ,(user_objects_alloc_page_count * 8) AS [SPACE Allocated FOR USER Objects (in KB)]
  ,(user_objects_dealloc_page_count * 8) AS [SPACE Deallocated FOR USER Objects (in KB)]
  ,(internal_objects_alloc_page_count * 8) AS [SPACE Allocated FOR Internal Objects (in KB)]
  ,(internal_objects_dealloc_page_count * 8) AS [SPACE Deallocated FOR Internal Objects (in KB)]
  ,CASE is_user_process
             WHEN 1      THEN 'user session'
             WHEN 0      THEN 'system session'
  END         AS [SESSION Type], row_count AS [ROW COUNT]
FROM 
  sys.dm_db_session_space_usage as ss
INNER join
  sys.dm_exec_sessions
ON  ss.session_id = sys.dm_exec_sessions.session_id
order by [ROW COUNT] DESC

SELECT SUM(version_store_reserved_page_count) AS [version store pages used], 
(SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB] 
FROM sys.dm_db_file_space_usage; 

SELECT transaction_id FROM sys.dm_tran_active_snapshot_database_transactions ORDER BY elapsed_time_seconds DESC;

SELECT
                    sys.dm_exec_sessions.session_id AS [SESSION ID],
                    DB_NAME(SS.database_id) AS [DATABASE Name],
                    HOST_NAME AS [System Name],
                    program_name AS [Program Name],
                    login_name AS [USER Name],
                    status,
                    cpu_time AS [CPU TIME (in milisec)],
                    total_scheduled_time AS [Total Scheduled TIME (in milisec)],
                    total_elapsed_time AS    [Elapsed TIME (in milisec)],
                    (memory_usage * 8)      AS [Memory USAGE (in KB)],
                    (user_objects_alloc_page_count * 8) AS [SPACE Allocated FOR USER Objects (in KB)],
                    (user_objects_dealloc_page_count * 8) AS [SPACE Deallocated FOR USER Objects (in KB)],
                    (internal_objects_alloc_page_count * 8) AS [SPACE Allocated FOR Internal Objects (in KB)],
                    (internal_objects_dealloc_page_count * 8) AS [SPACE Deallocated FOR Internal Objects (in KB)],
                    CASE is_user_process
                                         WHEN 1      THEN 'user session'
                                         WHEN 0      THEN 'system session'
                    END         AS [SESSION Type], row_count AS [ROW COUNT]
FROM sys.dm_db_session_space_usage AS SS
                                         INNER join
                    sys.dm_exec_sessions
                                         ON SS.session_id = sys.dm_exec_sessions.session_id
ORDER BY [ROW COUNT] DESC

SELECT
                    transaction_id AS [Transacton ID],
                    [name]      AS [TRANSACTION Name],
                    transaction_begin_time AS [TRANSACTION BEGIN TIME],
                    DATEDIFF(mi, transaction_begin_time, GETDATE()) AS [Elapsed TIME (in MIN)],
                    CASE transaction_type
                                         WHEN 1 THEN 'Read/write'
                    WHEN 2 THEN 'Read-only'
                    WHEN 3 THEN 'System'
                    WHEN 4 THEN 'Distributed'
                    END AS [TRANSACTION Type],
                    CASE transaction_state
                                         WHEN 0 THEN 'The transaction has not been completely initialized yet.'
                                         WHEN 1 THEN 'The transaction has been initialized but has not started.'
                                         WHEN 2 THEN 'The transaction is active.'
                                         WHEN 3 THEN 'The transaction has ended. This is used for read-only transactions.'
                                         WHEN 4 THEN 'The commit process has been initiated on the distributed transaction. This is for distributed transactions only. The distributed transaction is still active but further processing cannot take place.'
                                         WHEN 5 THEN 'The transaction is in a prepared state and waiting resolution.'
                                         WHEN 6 THEN 'The transaction has been committed.'
                                         WHEN 7 THEN 'The transaction is being rolled back.'
                                         WHEN 8 THEN 'The transaction has been rolled back.'
                    END AS [TRANSACTION Description]
FROM sys.dm_tran_active_transactions
--select * from sys.dm_tran_database_transactions

--SELECT
--                    HOST_NAME                                                          AS [System Name],
--                    program_name                                                      AS [Application Name],
--                    DB_NAME(a.database_id)                  AS [DATABASE Name],
--                    USER_NAME(USER_ID)                     AS [USER Name],
--                    connection_id                                                       AS [CONNECTION ID],
--                    a.session_id AS [CURRENT SESSION ID],
--                    blocking_session_id                         AS [Blocking SESSION ID],
--                    start_time                                           AS [Request START TIME],
--                    a.status         AS [Status],
--                    command                         AS [Command Type],
--                    (SELECT TEXT FROM sys.dm_exec_sql_text(sql_handle)) AS [Query TEXT],
--                    wait_type                                           AS [Waiting Type],
--                    wait_time                                           AS [Waiting Duration],
--                    wait_resource                                                       AS [Waiting FOR Resource],
--                    a.transaction_id AS [TRANSACTION ID],
--                    percent_complete                           AS [PERCENT Completed],
--                    estimated_completion_time          AS [Estimated COMPLETION TIME (in mili sec)],
--                    a.cpu_time AS [CPU TIME used (in mili sec)],
--                    (memory_usage * 8)                        AS [Memory USAGE (in KB)],
--                    a.total_elapsed_time AS [Elapsed TIME (in mili sec)]
--FROM sys.dm_exec_requests as a
--                                         INNER join
--                    sys.dm_exec_sessions
--                                         ON a.session_id = sys.dm_exec_sessions.session_id
--WHERE DB_NAME(a.database_id) = 'tempdb'
 

 USE tempdb;
GO
select [Current LSN],
       [Operation],
	   [Context],
       [Transaction Name],
       [Transaction ID],
       [Transaction SID],
       [SPID],
       [Begin Time],
	   [Description]
FROM   fn_dblog(null,null)
WHERE [Transaction Name]  IS NOT NULL 
ORDER BY [Transaction Name]

select * from sys.dm_db_task_space_usage

SELECT * FROM fn_dblog(null,null)
WHERE [Transaction Name]  IS NOT NULL 
ORDER BY [Transaction Name]

dbcc opentran(tempdb)