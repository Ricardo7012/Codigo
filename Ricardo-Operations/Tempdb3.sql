-- https://msdn.microsoft.com/en-us/library/ms176029.aspx
USE tempdb
GO

SELECT SUM(unallocated_extent_page_count) AS [free pages], 
(SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]
FROM sys.dm_db_file_space_usage;

SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
(SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;

SELECT transaction_id
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds DESC;

SELECT SUM(internal_object_reserved_page_count) AS [internal object pages used],
(SUM(internal_object_reserved_page_count)*1.0/128) AS [internal object space in MB]
FROM sys.dm_db_file_space_usage;

SELECT SUM(user_object_reserved_page_count) AS [user object pages used],
(SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]
FROM sys.dm_db_file_space_usage;

SELECT SUM(size)*1.0/128 AS [FREE size in MB]
FROM tempdb.sys.database_files

USE tempdb
GO
CREATE VIEW all_task_usage
AS 
    SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
    GROUP BY session_id;
GO

CREATE VIEW all_session_usage 
AS
    SELECT R1.session_id,
        R1.internal_objects_alloc_page_count 
        + R2.task_internal_objects_alloc_page_count AS session_internal_objects_alloc_page_count,
        R1.internal_objects_dealloc_page_count 
        + R2.task_internal_objects_dealloc_page_count AS session_internal_objects_dealloc_page_count
    FROM sys.dm_db_session_space_usage AS R1 
    INNER JOIN all_task_usage AS R2 ON R1.session_id = R2.session_id;
GO
--DECLARE @max int;
--DECLARE @i int;
--SELECT @max = max (session_id)
--FROM sys.dm_exec_sessions
--SET @i = 51
--  WHILE @i <= @max BEGIN
--         IF EXISTS (SELECT session_id FROM sys.dm_exec_sessions
--                    WHERE session_id=@i)
--         DBCC INPUTBUFFER (@i)
--         SET @i=@i+1
--         END;
-- https://thesqldude.com/tag/version-store/
--THE FOLLOWING QUERY HELPS YOU UNDERSTAND IF USER OBJECTS OR VERSION STORE OR INTERNAL OBJECTS ARE THE ONES USING THE SPACE IN TEMPDB. ACCORDING TO THIS OUTPUT, YOU CAN FOCUS ON THE BELOW SECTIONS.
--TYPES
SELECT
SUM (user_object_reserved_page_count)*8 as user_obj_kb,
SUM (internal_object_reserved_page_count)*8 as internal_obj_kb,
SUM (version_store_reserved_page_count)*8  as version_store_kb,
SUM (unallocated_extent_page_count)*8 as freespace_kb,
SUM (mixed_extent_page_count)*8 as mixedextent_kb
FROM sys.dm_db_file_space_usage
--TSQL
SELECT es.host_name , es.login_name , es.program_name,
st.dbid as QueryExecContextDBID, DB_NAME(st.dbid) as QueryExecContextDBNAME, st.objectid as ModuleObjectId,
SUBSTRING(st.text, er.statement_start_offset/2 + 1,(CASE WHEN er.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max),st.text)) * 2 ELSE er.statement_end_offset 
END - er.statement_start_offset)/2) as Query_Text,
tsu.session_id ,tsu.request_id, tsu.exec_context_id, 
(tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count) as OutStanding_user_objects_page_counts,
(tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) as OutStanding_internal_objects_page_counts,
er.start_time, er.command, er.open_transaction_count, er.percent_complete, er.estimated_completion_time, er.cpu_time, er.total_elapsed_time, er.reads,er.writes, 
er.logical_reads, er.granted_query_memory
FROM sys.dm_db_task_space_usage tsu inner join sys.dm_exec_requests er 
 ON ( tsu.session_id = er.session_id and tsu.request_id = er.request_id) 
inner join sys.dm_exec_sessions es ON ( tsu.session_id = es.session_id ) 
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE (tsu.internal_objects_alloc_page_count+tsu.user_objects_alloc_page_count) > 0
ORDER BY (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)+(tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) 
DESC

SELECT top 5 a.session_id, a.transaction_id, a.transaction_sequence_num, a.elapsed_time_seconds,
b.program_name, b.open_tran, b.status
FROM sys.dm_tran_active_snapshot_database_transactions a
join sys.sysprocesses b
on a.session_id = b.spid
ORDER BY elapsed_time_seconds DESC

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
 
--1. EITHER YOU HAVE TO ROLLBACK ANY TRANSACTIONS CONSUMING TEMPDB SPACE OR KILL THE TRANSACTIONS (NOT A GOOD IDEA).
--2. CREATE ADDITIONAL TEMPDB FILES IN OTHER DRIVES WHICH HAVE FREE SPACE, WHILE YOU DIG AROUND TO FIND THE CULPRIT WHO IS GROWING TEMPDB.
--3. RESTART YOUR SQL SERVER SERVICE.

-- https://dba.stackexchange.com/questions/19870/how-to-identify-which-query-is-filling-up-the-tempdb-transaction-log

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
INNER JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
    ON  TSU.session_id = ERQ.session_id
    AND TSU.request_id = ERQ.request_id
OUTER APPLY sys.dm_exec_sql_text(ERQ.sql_handle) AS EST
OUTER APPLY sys.dm_exec_query_plan(ERQ.plan_handle) AS EQP
WHERE EST.text IS NOT NULL OR EQP.query_plan IS NOT NULL
ORDER BY 3 DESC;

SELECT database_transaction_log_bytes_reserved,session_id 
  FROM sys.dm_tran_database_transactions AS tdt 
  INNER JOIN sys.dm_tran_session_transactions AS tst 
  ON tdt.transaction_id = tst.transaction_id 
  WHERE database_id = 2;

SELECT tdt.database_transaction_log_bytes_reserved,tst.session_id,
       t.[text], [statement] = COALESCE(NULLIF(
         SUBSTRING(
           t.[text],
           r.statement_start_offset / 2,
           CASE WHEN r.statement_end_offset < r.statement_start_offset
             THEN 0
             ELSE( r.statement_end_offset - r.statement_start_offset ) / 2 END
         ), ''
       ), t.[text])
     FROM sys.dm_tran_database_transactions AS tdt
     INNER JOIN sys.dm_tran_session_transactions AS tst
     ON tdt.transaction_id = tst.transaction_id
         LEFT OUTER JOIN sys.dm_exec_requests AS r
         ON tst.session_id = r.session_id
         OUTER APPLY sys.dm_exec_sql_text(r.plan_handle) AS t
     WHERE tdt.database_id = 2;

	 ;WITH s AS
(
    SELECT 
        s.session_id,
        [pages] = SUM(s.user_objects_alloc_page_count 
          + s.internal_objects_alloc_page_count) 
    FROM sys.dm_db_session_space_usage AS s
    GROUP BY s.session_id
    HAVING SUM(s.user_objects_alloc_page_count 
      + s.internal_objects_alloc_page_count) > 0
)
SELECT s.session_id, s.[pages], t.[text], 
  [statement] = COALESCE(NULLIF(
    SUBSTRING(
        t.[text], 
        r.statement_start_offset / 2, 
        CASE WHEN r.statement_end_offset < r.statement_start_offset 
        THEN 0 
        ELSE( r.statement_end_offset - r.statement_start_offset ) / 2 END
      ), ''
    ), t.[text])
FROM s
LEFT OUTER JOIN 
sys.dm_exec_requests AS r
ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.plan_handle) AS t
ORDER BY s.[pages] DESC;


--SOME TIPS FOR MINIMIZING TEMPDB UTILIZATION
--1.use fewer #temp tables and @table variables
--2.minimize concurrent index maintenance, and avoid the SORT_IN_TEMPDB option if it isn't needed
--3.avoid unnecessary cursors; avoid static cursors if you think this may be a bottleneck, since static cursors use work tables in tempdb - though this is the type of cursor I always recommend if tempdb isn't a bottleneck
--4.try to avoid spools (e.g. large CTEs that are referenced multiple times in the query)
--5.don't use MARS
--6.thoroughly test the use of snapshot / RCSI isolation levels - don't just turn it on for all databases since you've been told it's better than NOLOCK (it is, but it isn't free)
--7.in some cases, it may sound unintuitive, but use more temp tables. e.g. breaking up a humongous query into parts may be slightly less efficient, but if it can avoid a huge memory spill to tempdb because the single, larger query requires a memory grant too large...
--8.avoid enabling triggers for bulk operations
--9.avoid overuse of LOB types (max types, XML, etc) as local variables
--10.keep transactions short and sweet
--11.don't set tempdb to be everyone's default database - 

--You may also consider that your tempdb log usage may be caused by internal processes that you have little or no control over - for example database mail, event notifications, query notifications and service broker all use tempdb in some way. You can stop using these features, but if you're using them you can't dictate how and when they use tempdb.
