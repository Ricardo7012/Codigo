-- https://docs.microsoft.com/en-us/sql/relational-databases/performance/query-store-usage-scenarios?view=sql-server-ver15#ab-testing


--Do cardinality analysis when suspect on ad hoc workloads
SELECT COUNT(*) AS CountQueryTextRows
FROM sys.query_store_query_text;
SELECT COUNT(*) AS CountQueryRows
FROM sys.query_store_query;
SELECT COUNT(DISTINCT query_hash) AS CountDifferentQueryRows
FROM sys.query_store_query;
SELECT COUNT(*) AS CountPlanRows
FROM sys.query_store_plan;
SELECT COUNT(DISTINCT query_plan_hash) AS CountDifferentPlanRows
FROM sys.query_store_plan;


/*
A RATIO BETWEEN UNIQUE QUERY TEXTS AND UNIQUE QUERY HASHES, WHICH IS MUCH BIGGER THAN 1, 
IS AN INDICATION THAT WORKLOAD IS A GOOD CANDIDATE FOR PARAMETERIZATION, AS THE ONLY 
DIFFERENCE BETWEEN THE QUERIES IS LITERAL CONSTANT (PARAMETER) PROVIDED AS PART OF THE QUERY TEXT.
*/

/*
The following query returns information about queries and plans in the Query Store.
-- https://docs.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-ver15
*/

SELECT Txt.query_text_id
     , Txt.query_sql_text
     , Pl.plan_id
     , Qry.*
FROM sys.query_store_plan                 AS Pl
    INNER JOIN sys.query_store_query      AS Qry
        ON Pl.query_id = Qry.query_id
    INNER JOIN sys.query_store_query_text AS Txt
        ON Qry.query_text_id = Txt.query_text_id;

/*You can also view wait information using T-SQL. An example query is the one below, which includes the query, the plan_id(s) for that query, and wait statistics for a given interval of time:*/
SELECT TOP (10)
       [ws].[wait_category_desc]
     , [ws].[avg_query_wait_time_ms]
     , [ws].[total_query_wait_time_ms]
     , [ws].[plan_id]
     , [qt].[query_sql_text]
     , [rsi].[start_time]
     , [rsi].[end_time]
FROM [sys].[query_store_query_text]                 [qt]
    JOIN [sys].[query_store_query]                  [q]
        ON [qt].[query_text_id] = [q].[query_text_id]
    JOIN [sys].[query_store_plan]                   [qp]
        ON [q].[query_id] = [qp].[query_id]
    JOIN [sys].[query_store_runtime_stats]          [rs]
        ON [qp].[plan_id] = [rs].[plan_id]
    JOIN [sys].[query_store_runtime_stats_interval] [rsi]
        ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
    JOIN [sys].[query_store_wait_stats]             [ws]
        ON [ws].[runtime_stats_interval_id] = [rs].[runtime_stats_interval_id]
           AND [ws].[plan_id] = [qp].[plan_id]
WHERE [rsi].[end_time] > DATEADD(MINUTE, -5, GETUTCDATE())
      AND [ws].[execution_type] = 0
ORDER BY [ws].[avg_query_wait_time_ms] DESC;

SELECT qsws.plan_id
     , qsws.wait_stats_id
     , qsrs.runtime_stats_interval_id
     , count_executions
     , qsws.wait_category_desc
     , qsws.total_query_wait_time_ms
     , qsws.avg_query_wait_time_ms
     , qsws.last_query_wait_time_ms
     , qsws.min_query_wait_time_ms
     , qsws.max_query_wait_time_ms
     , qsqt.query_sql_text
     , x.actual_xml
FROM sys.query_store_wait_stats                         qsws
    JOIN sys.query_store_plan                           AS qsp
        ON qsws.plan_id = qsp.plan_id
    JOIN sys.query_store_runtime_stats                  AS qsrs
        ON qsrs.plan_id = qsp.plan_id
    JOIN sys.query_store_query                          AS qsq
        ON qsq.query_id = qsp.query_id
    JOIN sys.query_store_query_text                     AS qsqt
        ON qsq.query_text_id = qsqt.query_text_id
    CROSS APPLY
(SELECT TRY_CONVERT(XML, qsp.query_plan) AS actual_xml) AS x
WHERE qsws.plan_id = 62
      AND qsrs.execution_type = 0;

