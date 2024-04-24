--The last query is what you want, but giving you the rest to see 
USE tempdb
GO

/*
SELECT * FROM sys.dm_db_file_space_usage;

EXEC sp_spaceused;

DBCC SQLPERF(logspace);
*/
SELECT @@SERVERNAME AS SQLInstance, GETDATE() AS CurrentTime
EXEC sys.xp_fixeddrives;
SELECT 
	[LogicalName] = a.[name],
	[PhysicalFile] = a.[physical_name],
	[FileSize_MB] = CONVERT(DECIMAL(12, 2), ROUND(a.size / 128.000, 2)),
	[SpaceUsed_MB] = CONVERT(DECIMAL(12, 2), ROUND(FILEPROPERTY(a.name, 'SpaceUsed') / 128.000, 2)),
	[FreeSpace_MB] = CONVERT(DECIMAL(12, 2), ROUND((a.size - FILEPROPERTY(a.name, 'SpaceUsed')) / 128.000, 2)),
	[FreeSpace_Pcnt] = CONVERT(
								DECIMAL(12, 2),
								(CONVERT(
											DECIMAL(12, 2),
											ROUND((a.size - FILEPROPERTY(a.name, 'SpaceUsed')) / 128.000, 2)
										) / CONVERT(DECIMAL(12, 2), ROUND(a.size / 128.000, 2)) * 100
								)
							)
FROM sys.database_files a
--	WHERE a.[type_desc] = 'ROWS'
ORDER BY a.[name]


SELECT SUM(unallocated_extent_page_count) AS [free_pages],
       (SUM(unallocated_extent_page_count) * 1.0 / 128) AS [free_space_MB],
       SUM(version_store_reserved_page_count) AS [version_pages_used],
       (SUM(version_store_reserved_page_count) * 1.0 / 128) AS [version_space_MB],
       SUM(internal_object_reserved_page_count) AS [internal_object_pages_used],
       (SUM(internal_object_reserved_page_count) * 1.0 / 128) AS [internal_object_space_MB],
       SUM(user_object_reserved_page_count) AS [user object pages used],
       (SUM(user_object_reserved_page_count) * 1.0 / 128) AS [user_object_space_MB]
FROM sys.dm_db_file_space_usage;
GO

SELECT
       tsu.session_id,
	   es.host_name,
       es.login_name,
       es.program_name,
	   (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count) AS UserObj_Pages,--OutStanding_user_objects_page_counts,
       (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) AS InternalObj_Pages,--OutStanding_internal_objects_page_counts,
	   CAST(((tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count)*1.0/128) AS DECIMAL(16,2)) AS InternalObj_MB,
       er.start_time,
       er.command,
       er.cpu_time,
       er.reads,
       er.writes,
       er.logical_reads,
       er.total_elapsed_time,
       SUBSTRING(   st.text,
                    er.statement_start_offset / 2 + 1,
                    (CASE
                         WHEN er.statement_end_offset = -1 THEN
                             LEN(CONVERT(NVARCHAR(MAX), st.text)) * 2
                         ELSE
                             er.statement_end_offset
                     END - er.statement_start_offset
                    ) / 2
                ) AS Query_Text
FROM sys.dm_db_task_space_usage tsu
    INNER JOIN sys.dm_exec_requests er
        ON (
               tsu.session_id = er.session_id
               AND tsu.request_id = er.request_id
           )
    INNER JOIN sys.dm_exec_sessions es
        ON (tsu.session_id = es.session_id)
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE (tsu.internal_objects_alloc_page_count + tsu.user_objects_alloc_page_count) > 0
ORDER BY (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)
         + (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) DESC;

GO



;WITH task_space_usage AS (
    -- SUM alloc/delloc pages
    SELECT session_id,
           request_id,
           SUM(internal_objects_alloc_page_count) AS alloc_pages,
           SUM(internal_objects_dealloc_page_count) AS dealloc_pages
    FROM sys.dm_db_task_space_usage WITH (NOLOCK)
    WHERE session_id <> @@SPID
    GROUP BY session_id, request_id
)
SELECT TSU.session_id,
       TSU.alloc_pages * 1.0 / 128 AS [internal object MB space],
       TSU.dealloc_pages * 1.0 / 128 AS [internal object dealloc MB space],
       EST.text,
       -- Extract statement from sql text
       ISNULL(
           NULLIF(
               SUBSTRING(
                 EST.text, 
                 ERQ.statement_start_offset / 2, 
                 CASE WHEN ERQ.statement_end_offset < ERQ.statement_start_offset 
                  THEN 0 
                 ELSE( ERQ.statement_end_offset - ERQ.statement_start_offset ) / 2 END
               ), ''
           ), EST.text
       ) AS [statement text],
       EQP.query_plan
FROM task_space_usage AS TSU
LEFT OUTER JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
    ON  TSU.session_id = ERQ.session_id
    AND TSU.request_id = ERQ.request_id
OUTER APPLY sys.dm_exec_sql_text(ERQ.sql_handle) AS EST
OUTER APPLY sys.dm_exec_query_plan(ERQ.plan_handle) AS EQP
WHERE EST.text IS NOT NULL OR EQP.query_plan IS NOT NULL
ORDER BY 3 DESC;
GO


/*

SELECT R1.session_id,
       R1.request_id,
       R1.Task_request_internal_objects_alloc_page_count,
       R1.Task_request_internal_objects_dealloc_page_count,
       R1.Task_request_user_objects_alloc_page_count,
       R1.Task_request_user_objects_dealloc_page_count,
       R3.Session_request_internal_objects_alloc_page_count,
       R3.Session_request_internal_objects_dealloc_page_count,
       R3.Session_request_user_objects_alloc_page_count,
       R3.Session_request_user_objects_dealloc_page_count,
       R2.sql_handle,
       RL2.text AS SQLText,
       R2.statement_start_offset,
       R2.statement_end_offset,
       R2.plan_handle
FROM
(
    SELECT session_id,
           request_id,
           SUM(internal_objects_alloc_page_count) AS Task_request_internal_objects_alloc_page_count,
           SUM(internal_objects_dealloc_page_count) AS Task_request_internal_objects_dealloc_page_count,
           SUM(user_objects_alloc_page_count) AS Task_request_user_objects_alloc_page_count,
           SUM(user_objects_dealloc_page_count) AS Task_request_user_objects_dealloc_page_count
    FROM sys.dm_db_task_space_usage
    GROUP BY session_id,
             request_id
) R1
    INNER JOIN
    (
        SELECT session_id,
               SUM(internal_objects_alloc_page_count) AS Session_request_internal_objects_alloc_page_count,
               SUM(internal_objects_dealloc_page_count) AS Session_request_internal_objects_dealloc_page_count,
               SUM(user_objects_alloc_page_count) AS Session_request_user_objects_alloc_page_count,
               SUM(user_objects_dealloc_page_count) AS Session_request_user_objects_dealloc_page_count
        FROM sys.dm_db_session_space_usage
        GROUP BY session_id
    ) R3
        ON R1.session_id = R3.session_id
    LEFT OUTER JOIN sys.dm_exec_requests R2
        ON R1.session_id = R2.session_id
           AND R1.request_id = R2.request_id
    OUTER APPLY sys.dm_exec_sql_text(R2.sql_handle) AS RL2
WHERE Task_request_internal_objects_alloc_page_count > 0
      OR Task_request_internal_objects_dealloc_page_count > 0
      OR Task_request_user_objects_alloc_page_count > 0
      OR Task_request_user_objects_dealloc_page_count > 0
      OR Session_request_internal_objects_alloc_page_count > 0
      OR Session_request_internal_objects_dealloc_page_count > 0
      OR Session_request_user_objects_alloc_page_count > 0
      OR Session_request_user_objects_dealloc_page_count > 0;

-- transaction which is still using transaction log
SELECT database_transaction_log_bytes_reserved,
       session_id
FROM sys.dm_tran_database_transactions AS tdt
    INNER JOIN sys.dm_tran_session_transactions AS tst
        ON tdt.transaction_id = tst.transaction_id
WHERE database_id = 2;



SELECT transaction_id FROM sys.dm_tran_active_snapshot_database_transactions ORDER BY elapsed_time_seconds DESC; 
 --Tempdb session File usage
--sys.dm_db_session_space_usage : Returns the number of pages allocated and deallocated by each session for the database.
--sys.dm_exec_sessions: Gives details about the sessions.
 
SELECT
                    sys.dm_exec_sessions.session_id AS [SESSION ID],
                    DB_NAME(database_id) AS [DATABASE Name],
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
FROM sys.dm_db_session_space_usage
                                         INNER join
                    sys.dm_exec_sessions
                                         ON sys.dm_db_session_space_usage.session_id = sys.dm_exec_sessions.session_id
 
 
--A long running transaction may prevent cleanup of transaction log thus eating up all log space available resulting space crisis for all other applications.
 
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
 


--Long running Queries
--sys.dm_exec_requests : Returns information regarding the requests made to the database server.
SELECT
                    HOST_NAME                                                          AS [System Name],
                    program_name                                                      AS [Application Name],
                    DB_NAME(sys.dm_exec_requests.database_id)                  AS [DATABASE Name],
                    USER_NAME(USER_ID)                     AS [USER Name],
                    connection_id                                                       AS [CONNECTION ID],
                    sys.dm_exec_requests.session_id AS [CURRENT SESSION ID],
                    blocking_session_id                         AS [Blocking SESSION ID],
                    start_time                                           AS [Request START TIME],
                    sys.dm_exec_requests.status         AS [Status],
                    command                         AS [Command Type],
                    (SELECT TEXT FROM sys.dm_exec_sql_text(sql_handle)) AS [Query TEXT],
                    wait_type                                           AS [Waiting Type],
                    wait_time                                           AS [Waiting Duration],
                    wait_resource                                                       AS [Waiting FOR Resource],
                    sys.dm_exec_requests.transaction_id AS [TRANSACTION ID],
                    percent_complete                           AS [PERCENT Completed],
                    estimated_completion_time          AS [Estimated COMPLETION TIME (in mili sec)],
                    sys.dm_exec_requests.cpu_time AS [CPU TIME used (in mili sec)],
                    (memory_usage * 8)                        AS [Memory USAGE (in KB)],
                    sys.dm_exec_requests.total_elapsed_time AS [Elapsed TIME (in mili sec)]
FROM sys.dm_exec_requests
                                         INNER join
                    sys.dm_exec_sessions
                                         ON sys.dm_exec_requests.session_id = sys.dm_exec_sessions.session_id
WHERE DB_NAME(sys.dm_exec_requests.database_id) = 'tempdb'




SELECT instance_name AS 'Database',
       [Data File(s) Size (KB)] / 1024 AS [Data file (MB)],
       [LOG File(s) Size (KB)] / 1024 AS [Log file (MB)],
       [Log File(s) Used Size (KB)] / 1024 AS [Log file space used (MB)]
FROM
(
    SELECT *
    FROM sys.dm_os_performance_counters
    WHERE counter_name IN ( 'Data File(s) Size (KB)', 'Log File(s) Size (KB)', 'Log File(s) Used Size (KB)' )
          AND instance_name = 'tempdb'
) AS A
PIVOT
(
    MAX(cntr_value)
    FOR counter_name IN ([Data File(s) Size (KB)], [LOG File(s) Size (KB)], [Log File(s) Used Size (KB)])
) AS B;
GO




SELECT create_date AS [Creation date],
       recovery_model_desc [Recovery model]
FROM sys.databases
WHERE name = 'tempdb';
GO




Declare @tempdbfilecount as int;
select @tempdbfilecount = (select count(*) from sys.master_files where database_id=2 and type=0);
WITH Processor_CTE ([cpu_count], [hyperthread_ratio])
AS
(
      SELECT  cpu_count, hyperthread_ratio
      FROM sys.dm_os_sys_info sysinfo
)
select Processor_CTE.cpu_count as [# of Logical Processors], @tempdbfilecount as [Current_Tempdb_DataFileCount], 
(case 
      when (cpu_count<8 and @tempdbfilecount=cpu_count)  then 'No' 
      when (cpu_count<8 and @tempdbfilecount<>cpu_count and @tempdbfilecount<cpu_count) then 'Yes' 
      when (cpu_count<8 and @tempdbfilecount<>cpu_count and @tempdbfilecount>cpu_count) then 'No'
      when (cpu_count>=8 and @tempdbfilecount=cpu_count)  then 'No (Depends on continued Contention)' 
      when (cpu_count>=8 and @tempdbfilecount<>cpu_count and @tempdbfilecount<cpu_count) then 'Yes'
      when (cpu_count>=8 and @tempdbfilecount<>cpu_count and @tempdbfilecount>cpu_count) then 'No (Depends on continued Contention)'
end) AS [TempDB_DataFileCount_ChangeRequired]
from Processor_CTE;


*/