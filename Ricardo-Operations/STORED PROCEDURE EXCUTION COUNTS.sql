-- STORED PROCEDURE EXCUTION COUNTS
SELECT DB_NAME(st.dbid)         AS database_name
     , OBJECT_NAME(st.objectid) AS name
     , p.size_in_bytes / 1024   AS size_in_kb
     , p.usecounts
     , st.text
FROM sys.dm_exec_cached_plans                       p
    CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) st
WHERE p.objtype = 'proc'
      AND st.dbid = DB_ID('EdiManagementhub')
ORDER BY p.usecounts DESC;

SELECT DB_NAME(database_id)   AS dbname
     , OBJECT_NAME(object_id) AS objectname
     , cached_time
     , last_execution_time
     , execution_count
FROM sys.dm_exec_procedure_stats;
