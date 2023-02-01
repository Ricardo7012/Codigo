SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--identify the SPID and check with user executing the query to KILL the process.

SELECT GETDATE()  AS [RunTime]
     , st.text    AS batch
     , SUBSTRING(   st.text
                  , a.statement_start_offset / 2 + 1
                  , ((CASE
                          WHEN a.statement_end_offset = -1
                              THEN
                  (LEN(CONVERT(NVARCHAR(MAX), st.text)) * 2)
                          ELSE
                              a.statement_end_offset
                      END
                     ) - a.statement_start_offset
                    ) / 2 + 1
                ) AS current_statement
     , qp.query_plan
     , a.*
FROM sys.dm_exec_requests                          a
    CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) AS st
    CROSS APPLY sys.dm_exec_query_plan(a.plan_handle) AS qp
ORDER BY a.cpu_time DESC;

--SELECT @@ServerName
--     , GETDATE() AS SERVERNAME;

--Open execution plan and check for operators with high cost
--Check indexes being used and number of rows estimated
--Index Scans / multiple scans
--Operators with high very high rowcount
--Make sure statistics are updated on the referenced tables.
--Check for any Index recommendations in the execution plan
--Check for Implicit Conversions in the execution plan tool tips as below. 
--Implicit Conversion can cause HIGH CPU condition


----RETRIEVE EVERY QUERY PLAN FROM THE PLAN CACHE
--USE master;  
--GO  
--SELECT * 
--FROM sys.dm_exec_cached_plans AS cp 
--CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle);  
--GO  

--RETRIEVE INFORMATION ABOUT THE TOP FIVE QUERIES BY AVERAGE CPU TIME
SELECT TOP 5
       total_worker_time / execution_count AS [Avg CPU Time]
     , plan_handle
     , query_plan
FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)
ORDER BY total_worker_time / execution_count DESC;
GO  

-- acquire sql_handle
--SELECT sql_handle FROM sys.dm_exec_requests WHERE session_id = 59  -- modify this value with your actual spid

---- pass sql_handle to sys.dm_exec_sql_text
--SELECT *
--FROM sys.dm_exec_sql_text(0x030005004616BD2358315D014BAB000001000000000000000000000000000000000000000000000000000000); -- modify this value with your actual sql_handle
--GO

--USE master;  
--GO  
--SELECT * 
--FROM sys.dm_exec_query_plan (0x060005008ED5F90E5017BF1E4701000001000000F30700000000000000000000000000000000000000000000);  
--GO 
--USE master;  
--GO  
--SELECT * 
--FROM sys.dm_exec_query_plan (0x060005008ED5F90E80B471D83A01000001000000F10900000000000000000000000000000000000000000000);  
--GO  
--USE master;  
--GO  
--SELECT * 
--FROM sys.dm_exec_query_plan (0x06000500F1A90E1AD0BE75913F01000001000000F30700000000000000000000000000000000000000000000);  
--GO  
--USE master;  
--GO  
--SELECT * 
--FROM sys.dm_exec_query_plan (0x06000500F1A90E1A501D8F320E01000001000000F10900000000000000000000000000000000000000000000);  
--GO  
--USE master;  
--GO  
--SELECT * 
--FROM sys.dm_exec_query_plan (0x060001002913C614A0989C6BC000000001000000000000000000000000000000000000000000000000000000);  
--GO   