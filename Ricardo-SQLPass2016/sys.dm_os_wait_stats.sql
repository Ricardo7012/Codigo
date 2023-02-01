/*
http://technet.microsoft.com/en-us/library/ms179984.aspx
http://msdn.microsoft.com/en-us/library/ms179984(SQL.90).aspx
http://msdn.microsoft.com/en-us/magazine/cc135978.aspx

Requires VIEW SERVER STATE permission on the server

RETURNS INFORMATION ABOUT THE WAITS ENCOUNTERED BY THREADS THAT EXECUTED. 
YOU CAN USE THIS AGGREGATED VIEW TO DIAGNOSE PERFORMANCE ISSUES WITH SQL 
SERVER AND ALSO WITH SPECIFIC QUERIES AND BATCHES.


COLUMN NAME  DATA TYPE  DESCRIPTION  
____________________________________________________________________________
wait_type 
 nvarchar(60) 
 Name of the wait type. 
 
waiting_tasks_count 
 bigint 
 Number of waits on this wait type. This counter is incremented at the start of each wait. 
 
wait_time_ms 
 bigint 
 Total wait time for this wait type in milliseconds. This time is inclusive of signal_wait_time_ms. 
 
max_wait_time_ms 
 bigint 
 Maximum wait time on this wait type.
 
signal_wait_time_ms 
 bigint 
 Difference between the time the waiting thread was signaled and when it started running. 
 
*/

SELECT 
	* 
FROM 
	sys.dm_os_wait_stats
ORDER BY 
	max_wait_time_ms DESC



--This Command Resets All Counters To 0
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR);
GO

--Causes of Server Waits
SELECT TOP 10
 [Wait type] = wait_type,
 [Wait time (s)] = wait_time_ms / 1000,
 [% waiting] = CONVERT(DECIMAL(12,2), wait_time_ms * 100.0 
               / SUM(wait_time_ms) OVER())
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE '%SLEEP%' 
ORDER BY wait_time_ms DESC;

--Identifying the Most Reads and Writes 
SELECT TOP 10 
        [Total Reads] = SUM(total_logical_reads)
        ,[Execution count] = SUM(qs.execution_count)
        ,DatabaseName = DB_NAME(qt.dbid)
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
GROUP BY DB_NAME(qt.dbid)
ORDER BY [Total Reads] DESC;

SELECT TOP 10 
        [Total Writes] = SUM(total_logical_writes)
        ,[Execution count] = SUM(qs.execution_count)
        ,DatabaseName = DB_NAME(qt.dbid)
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
GROUP BY DB_NAME(qt.dbid)
ORDER BY [Total Writes] DESC;

--Identifying Queries Most Often Blocked 
SELECT TOP 10 
 [Average Time Blocked] = (total_elapsed_time - total_worker_time) / qs.execution_count
,[Total Time Blocked] = total_elapsed_time - total_worker_time 
,[Execution count] = qs.execution_count
,[Individual Query] = SUBSTRING (qt.text,qs.statement_start_offset/2, 
         (CASE WHEN qs.statement_end_offset = -1 
            THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
          ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) 
,[Parent Query] = qt.text
,DatabaseName = DB_NAME(qt.dbid)
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
ORDER BY [Average Time Blocked] DESC;
