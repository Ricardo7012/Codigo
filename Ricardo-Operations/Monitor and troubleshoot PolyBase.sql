-- Monitor and troubleshoot PolyBase
-- https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-troubleshooting?view=sql-server-ver15
-- Find the longest running queries
SELECT execution_id
     , st.text
     , dr.total_elapsed_time
FROM sys.dm_exec_distributed_requests            dr
    CROSS APPLY sys.dm_exec_sql_text(sql_handle) st
ORDER BY execution_id desc
--ORDER BY total_elapsed_time DESC;

-- Find the longest running step of the distributed query plan  
SELECT execution_id
     , step_index
     , operation_type
     , distribution_type
     , location_type
     , status
     , total_elapsed_time
     , command
FROM sys.dm_exec_distributed_request_steps
WHERE execution_id = 'QID42'
ORDER BY total_elapsed_time DESC;


-- Find the execution progress of SQL step    
SELECT execution_id
     , step_index
     , distribution_id
     , status
     , total_elapsed_time
     , row_count
     , command
FROM sys.dm_exec_distributed_sql_requests
WHERE execution_id = 'QID42'
      AND step_index = 1;

-- Find the execution progress of DMS step    
SELECT execution_id
     , step_index
     , dms_step_index
     , status
     , type
     , bytes_processed
     , total_elapsed_time
FROM sys.dm_exec_dms_workers
WHERE execution_id = 'QID42'
ORDER BY total_elapsed_time DESC;

-- Find the information about external DMS operations
SELECT execution_id
     , step_index
     , dms_step_index
     , compute_node_id
     , type
     , input_name
     , length
     , total_elapsed_time
     , status
FROM sys.dm_exec_external_work
WHERE execution_id = 'QID42'
      AND step_index = 7
ORDER BY total_elapsed_time DESC;
