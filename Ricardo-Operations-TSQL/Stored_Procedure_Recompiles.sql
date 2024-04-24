SET STATISTICS TIME, IO ON;
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
AND text NOT LIKE '%SQL Diagnostic Manager%'
AND text NOT LIKE '%sp_IEHP_IndexOptimize%'
ORDER BY plan_generation_num DESC;
SET STATISTICS TIME, IO OFF;
