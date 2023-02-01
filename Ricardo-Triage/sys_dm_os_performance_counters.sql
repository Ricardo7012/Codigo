--https://bahtisametcoban.home.blog/2019/02/07/always-on-secondary-database-in-reverting-in-recovery/
--https://docs.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-database-replica?view=sql-server-2017 

SELECT DB_NAME(database_id) AS DatabaseName
     , synchronization_state_desc
     , database_state_desc
FROM sys.dm_hadr_database_replica_states
WHERE is_local = 1
      AND is_primary_replica = 0;

SELECT [object_name]
     , [counter_name]
     , [cntr_value] AS [KB]
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%DATABASE REPLICA%'
      AND [counter_name] = 'LOG remaining FOR undo'

SELECT DB_NAME(database_id) AS DatabaseName
     , synchronization_state_desc
     , database_state_desc
FROM sys.dm_hadr_database_replica_states
WHERE is_local = 1
      AND is_primary_replica = 0;
