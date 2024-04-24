USE HSP
GO
--SEE HOW THE TOTAL NUMBER OF ALLOCATED BUFFERS (NUM PROC BUFFS) 
--COMPARES WITH THE NUMBER USED (NUM PROC BUFFS USED). 
--A HIGH-VALUE PERCENTAGE INDICATES POOR USE OF PROCEDURE CACHE.
DBCC PROCCACHE;

--OBSERVE THE VALUES FOR BUFFER DISTRIBUTION TABLE. IF THE NUMBER OF TARGETED PAGES DECREASES OVER TIME, 
--IT IS LIKELY THAT YOUR SQL SERVER IS EXPERIENCING EXTERNAL MEMORY PRESSURE. 
--COMPARE THE NUMBER OF TARGETED PAGES AGAINST THE STOLEN PAGES. 
--IF THE NUMBER OF STOLEN PAGES DOES STABILIZE OVER TIME, THE SERVER MAY EVENTUALLY GET INTO INTERNAL PHYSICAL MEMORY PRESSURE. 
DBCC MEMORYSTATUS;

--
SELECT *
FROM master.sys.sysperfinfo
WHERE object_name = 'SQLSERVER:BUFFER MANAGER'
      AND
      (
          counter_name = 'TARGET PAGES'
          OR counter_name = 'TOTAL PAGES'
          OR counter_name = 'DATABASE PAGES'
          OR counter_name = 'STOLEN PAGES'
          OR counter_name = 'FREE PAGES'
      );

--DETERMINE WHICH SQL SERVER COMPONENTS ARE CONSUMING THE MOST AMOUNT OF MEMORY, AND OBSERVE HOW THIS CHANGES OVER TIME:
SELECT type,
       SUM(pages_kb) AS PagesKB
FROM sys.dm_os_memory_clerks
WHERE pages_kb != 0
GROUP BY type
ORDER BY PagesKB DESC;

--This query will show which SQL Server objects are consuming memory:

SELECT type,
       exclusive_access_count
FROM sys.dm_os_memory_objects
WHERE page_allocator_address IN (
                                    SELECT TOP 10
                                           page_allocator_address
                                    FROM sys.dm_os_memory_clerks
                                    ORDER BY pages_kb DESC
                                )
ORDER BY exclusive_access_count DESC;

--select * from SYS.dm_os_memory_objects

--To get an idea of which individual processes are taking up memory, use the following query:

SELECT TOP 10
       session_id,
       login_time,
       host_name,
       program_name,
       login_name,
       nt_domain,
       nt_user_name,
       status,
       cpu_time,
       memory_usage,
       total_scheduled_time,
       total_elapsed_time,
       last_request_start_time,
       last_request_end_time,
       reads,
       writes,
       logical_reads,
       transaction_isolation_level,
       lock_timeout,
       deadlock_priority,
       row_count,
       prev_error
FROM sys.dm_exec_sessions
ORDER BY memory_usage DESC;

--TO SOLVE MEMORY PROBLEMS, SEE IF SQL SERVER MEMORY IS CORRECTLY ALLOCATED. IF SO, ENSURE THAT THE PROCEDURE CACHE HAS BEEN SQUEEZED. TYPICAL CULPRITS EATING UP PROCEDURE CACHE ARE LARGE STORED PROCEDURES OR LARGE AMOUNTS OF AD HOC SQL THAT ARE PARAMETERIZED. THEN EXAMINE LARGE MEMORY CONSUMERS AND OBJECTS TO SEE IF YOUR APPLICATIONS NEED RE-ARCHITECTING. PROCESSES CONSUMING LARGE AMOUNTS OF MEMORY SHOULD BE REDESIGNED TO CONSUME LESS MEMORY

--Processes that are disk intensive typically do have the appropriate indexes or have poor execution plans. Here is a DMV query that lists the top 25 tables experiencing I/O waits.
SELECT TOP 25
       DB_NAME(D.database_id) AS DATABASE_NAME,
       QUOTENAME(OBJECT_SCHEMA_NAME(D.object_id, D.database_id)) + N'.'
       + QUOTENAME(OBJECT_NAME(D.object_id, D.database_id)) AS OBJECT_NAME,
       D.database_id,
       D.object_id,
       D.PAGE_IO_LATCH_WAIT_COUNT,
       D.PAGE_IO_LATCH_WAIT_IN_MS,
       D.RANGE_SCANS,
       D.INDEX_LOOKUPS
FROM
(
    SELECT database_id,
           object_id,
           ROW_NUMBER() OVER (PARTITION BY database_id
                              ORDER BY SUM(page_io_latch_wait_in_ms) DESC
                             ) AS ROW_NUMBER,
           SUM(page_io_latch_wait_count) AS PAGE_IO_LATCH_WAIT_COUNT,
           SUM(page_io_latch_wait_in_ms) AS PAGE_IO_LATCH_WAIT_IN_MS,
           SUM(range_scan_count) AS RANGE_SCANS,
           SUM(singleton_lookup_count) AS INDEX_LOOKUPS
    FROM sys.dm_db_index_operational_stats(NULL, NULL, NULL, NULL)
    WHERE page_io_latch_wait_count > 0
    GROUP BY database_id,
             object_id
) AS D
    LEFT JOIN
    (
        SELECT DISTINCT
               database_id,
               object_id
        FROM sys.dm_db_missing_index_details
    ) AS MID
        ON MID.database_id = D.database_id
           AND MID.object_id = D.object_id
WHERE D.ROW_NUMBER > 20
ORDER BY PAGE_IO_LATCH_WAIT_COUNT DESC;

--YOU CAN ALSO GENERATE A LIST OF COLUMNS THAT SHOULD HAVE INDEXES ON THEM:
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-missing-index-details-transact-sql 
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-missing-index-group-stats-transact-sql
SELECT *
FROM sys.dm_db_missing_index_groups G
    JOIN sys.dm_db_missing_index_group_stats GS
        ON GS.group_handle = G.index_group_handle
    JOIN sys.dm_db_missing_index_details D
        ON G.index_handle = D.index_handle;


--CPU. One of the most frequent contributors to high CPU consumption is stored procedure recompilation. Here is a DMV that displays the list of the top 25 recompilations:
SELECT TOP 25
       SQL_TEXT.text,
       sql_handle,
       plan_generation_num,
       execution_count,
       dbid,
       objectid
FROM sys.dm_exec_query_stats A
    CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS SQL_TEXT
WHERE plan_generation_num > 1
ORDER BY plan_generation_num DESC;


--LISTS THE TOP CPU CONSUMERS:
SELECT TOP 50
       SUM(QS.total_worker_time) AS TOTAL_CPU_TIME,
       SUM(QS.execution_count) AS TOTAL_EXECUTION_COUNT,
       COUNT(*) AS NUMBER_OF_STATEMENTS,
       SQL_TEXT.text,
       QS.plan_handle
FROM sys.dm_exec_query_stats QS
    CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS SQL_TEXT
GROUP BY SQL_TEXT.text,
         QS.plan_handle
ORDER BY SUM(QS.total_worker_time) DESC;

-- PASS SQL_HANDLE TO SYS.DM_EXEC_SQL_TEXT
SELECT * FROM sys.dm_exec_sql_text(0x050008007FC17E2700100808B200000001000000000000000000000000000000000000000000000000000000) -- modify this value with your actual sql_handle
-- DBID CANBE DETERMINED FROM SQL_HANDLE FOR AD HOC QUERIES. TO DETERMINE DBID FOR AD HOC QUERIES, USE PLAN_HANDLE INSTEAD.

-- acquire sql_handle
SELECT sql_handle FROM sys.dm_exec_requests WHERE session_id = 59  -- modify this value with your actual spid

-- pass sql_handle to sys.dm_exec_sql_text
SELECT * FROM sys.dm_exec_sql_text(0x030008007FC17E27EDAC930051A8000001000000000000000000000000000000000000000000000000000000) -- modify this value with your actual sql_handle


SELECT 
     * 
FROM 
	sys.dm_exec_procedure_stats
WHERE 
	object_id = 662618495

SELECT OBJECT_ID(662618495)

--OTHER THINGS THAT CAUSE HIGH CPU USAGE ARE BOOKMARK LOOKUPS, BAD PARALLELISM AND LOOPING CODE.

--NOTE

--WHEN SEARCHING FOR BOTTLENECKS, LOOK FOR MEMORY BOTTLENECKS, THEN DISK AND FINALLY CPU. 
--CAPTURE A BASELINE USING SYSTEM MONITOR, SQL PROFILER AND DMVS TO DETERMINE WHAT IS CAUSING THE 
--BOTTLENECK AND IF IT CAN BE SOLVED BY A HARDWARE UPGRADE. ONCE YOU HAVE A BASELINE, YOU ARE READY 
--TO START DIAGNOSING THE PROBLEM. IN MOST CASES, THE SOLUTION WILL INVOLVE QUERY TUNING, QUERY 
--REWRITES OR RE-ARCHITECTING YOUR SOLUTION. MANY TIMES, THROWING HARDWARE AT THE PROBLEM WILL 
--HAVE THE PERFORMANCE GAINS OF SIMPLE INDEX PLACEMENT

--Just note that the counter type for all three counters is 272696576 and that the values shown are cumulative since the last SQL Server start, so they have to be calculated. One of the methods is to take two samples with a 10-second delay
SELECT *
FROM sys.dm_os_performance_counters
WHERE counter_name IN ( 'Batch Requests/sec', 'SQL Compilations/sec', 'SQL Re-Compilations/sec' );

--The Batch Requests/sec value depends on hardware used, but it should be under 1000. The recommended value for SQL Compilations/sec is less than 10% of Batch Requests/sec and for SQL Re-Compilations/sec is less than 10% of SQL Compilations/sec
DECLARE @BatchRequests BIGINT;

SELECT @BatchRequests = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec';

WAITFOR DELAY '00:00:10';

SELECT (cntr_value - @BatchRequests) / 10 AS 'Batch Requests/sec'
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec';




