--Identify which type of tempdb objects are consuming  space

--The following query helps you understand if user objects or version store or internal objects are the ones using the space in tempdb. According to this output, you can focus on the below sections.

SELECT SUM(user_object_reserved_page_count) * 8     AS user_obj_kb
     , SUM(internal_object_reserved_page_count) * 8 AS internal_obj_kb
     , SUM(version_store_reserved_page_count) * 8   AS version_store_kb
     , SUM(unallocated_extent_page_count) * 8       AS freespace_kb
     , SUM(mixed_extent_page_count) * 8             AS mixedextent_kb
FROM sys.dm_db_file_space_usage;

--QUERY THAT IDENTIFIES THE CURRENTLY ACTIVE T-SQL QUERY, IT’S TEXT AND THE APPLICATION THAT IS CONSUMING A LOT OF TEMPDB SPACE

SELECT es.host_name
     , es.login_name
     , es.program_name
     , st.dbid                                                                           AS QueryExecContextDBID
     , DB_NAME(st.dbid)                                                                  AS QueryExecContextDBNAME
     , st.objectid                                                                       AS ModuleObjectId
     , SUBSTRING(   st.text
                  , er.statement_start_offset / 2 + 1
                  , (CASE
                         WHEN er.statement_end_offset = -1
                             THEN
                             LEN(CONVERT(NVARCHAR(MAX), st.text)) * 2
                         ELSE
                             er.statement_end_offset
                     END - er.statement_start_offset
                    ) / 2
                )                                                                        AS Query_Text
     , tsu.session_id
     , tsu.request_id
     , tsu.exec_context_id
     , (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)         AS OutStanding_user_objects_page_counts
     , (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) AS OutStanding_internal_objects_page_counts
     , er.start_time
     , er.command
     , er.open_transaction_count
     , er.percent_complete
     , er.estimated_completion_time
     , er.cpu_time
     , er.total_elapsed_time
     , er.reads
     , er.writes
     , er.logical_reads
     , er.granted_query_memory
FROM sys.dm_db_task_space_usage                     tsu
    INNER JOIN sys.dm_exec_requests                 er
        ON (
               tsu.session_id = er.session_id
               AND tsu.request_id = er.request_id
           )
    INNER JOIN sys.dm_exec_sessions                 es
        ON (tsu.session_id = es.session_id)
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE (tsu.internal_objects_alloc_page_count + tsu.user_objects_alloc_page_count) > 0
ORDER BY (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)
         + (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) DESC;


--You can use the following query to find the oldest transactions that are active and using row versioning.

SELECT TOP 5
       a.session_id
     , a.transaction_id
     , a.transaction_sequence_num
     , a.elapsed_time_seconds
     , b.program_name
     , b.open_tran
     , b.status
FROM sys.dm_tran_active_snapshot_database_transactions a
    JOIN sys.sysprocesses                              b
        ON a.session_id = b.spid
ORDER BY elapsed_time_seconds DESC;

--You can use the following against any of the SQL Servers you manage to find out if any change is required in the tempdb data files to reduce contention and improve general performance.
-- THIS IS OLD SCHOOL THINKING
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

