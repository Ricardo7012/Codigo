-- https://techcommunity.microsoft.com/t5/sql-server-support/troubleshooting-redo-queue-build-up-data-latency-issues-on/ba-p/318488
--On the SQL Server hosting the secondary replica of a given availability group, each database has a single REDO thread with its own session_id.  
--To get a list of all of the redo threads on a given secondary replica instance (across all availability groups), issue the following 
--query which will return the session_ids performing “REDO” -- otherwise known as  “DB STARTUP”.
SELECT DB_NAME(database_id) AS DBName
     , session_id
FROM sys.dm_exec_requests
WHERE command = 'DB STARTUP';
GO

--When recovery queuing is occurring with a database and parallel recovery is being used, we must find all the sessions involved in parallel recovery, 
--IN this example, we know AdventureWorks2016 is where we are seeing recovery queuing, so we find all the sessions involved in parallel recovery on the secondary:
SELECT DB_NAME(database_id) AS dbname
     , command
     , session_id
FROM sys.dm_exec_requests
WHERE command IN ( 'PARALLEL REDO HELP TASK', 'PARALLEL REDO TASK', 'DB STARTUP' )
      AND database_id = DB_ID('HSP');
GO

EXEC dbo.sp_WhoIsActive @show_sleeping_spids = 1,@show_system_spids=1,@filter_type='database',@filter='HSP'
GO

-- https://www.sqlshack.com/measuring-availability-group-synchronization-lag/

-- RTO METRIC
USE HSP
GO

;WITH UpTime AS
			(
			SELECT DATEDIFF(SECOND,create_date,GETDATE()) [upTime_secs]
			FROM sys.databases
			WHERE name = 'tempdb'
			),
	AG_Stats AS 
			(
			SELECT AR.replica_server_name,
				   HARS.role_desc, 
				   Db_name(DRS.database_id) [DBName], 
				   CAST(DRS.log_send_queue_size AS DECIMAL(19,2)) log_send_queue_size_KB, 
				   (CAST(perf.cntr_value AS DECIMAL(19,2)) / CAST(UpTime.upTime_secs AS DECIMAL(19,2))) / CAST(1024 AS DECIMAL(19,2)) [log_KB_flushed_per_sec]
			FROM   sys.dm_hadr_database_replica_states DRS 
			INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
			INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id 
				AND AR.replica_id = HARS.replica_id 
			--I am calculating this as an average over the entire time that the instance has been online.
			--To capture a smaller, more recent window, you will need to:
			--1. Store the counter value.
			--2. Wait N seconds.
			--3. Recheck counter value.
			--4. Divide the difference between the two checks by N.
			INNER JOIN sys.dm_os_performance_counters perf ON perf.instance_name = Db_name(DRS.database_id)
				AND perf.counter_name like 'Log Bytes Flushed/sec%'
			CROSS APPLY UpTime
			),
	Pri_CommitTime AS 
			(
			SELECT	replica_server_name
					, DBName
					, [log_KB_flushed_per_sec]
			FROM	AG_Stats
			WHERE	role_desc = 'PRIMARY'
			),
	Sec_CommitTime AS 
			(
			SELECT	replica_server_name
					, DBName
					--Send queue will be NULL if secondary is not online and synchronizing
					, log_send_queue_size_KB
			FROM	AG_Stats
			WHERE	role_desc = 'SECONDARY'
			)
SELECT p.replica_server_name [primary_replica]
	, p.[DBName] AS [DatabaseName]
	, s.replica_server_name [secondary_replica]
	, CAST(s.log_send_queue_size_KB / p.[log_KB_flushed_per_sec] AS BIGINT) [Sync_Lag_Secs]
FROM Pri_CommitTime p
LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName]
--
;WITH 
	AG_Stats AS 
			(
			SELECT AR.replica_server_name,
				   HARS.role_desc, 
				   Db_name(DRS.database_id) [DBName], 
				   DRS.redo_queue_size redo_queue_size_KB,
				   DRS.redo_rate redo_rate_KB_Sec
			FROM   sys.dm_hadr_database_replica_states DRS 
			INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
			INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id 
				AND AR.replica_id = HARS.replica_id 
			),
	Pri_CommitTime AS 
			(
			SELECT	replica_server_name
					, DBName
					, redo_queue_size_KB
					, redo_rate_KB_Sec
			FROM	AG_Stats
			WHERE	role_desc = 'PRIMARY'
			),
	Sec_CommitTime AS 
			(
			SELECT	replica_server_name
					, DBName
					--Send queue and rate will be NULL if secondary is not online and synchronizing
					, redo_queue_size_KB
					, redo_rate_KB_Sec
			FROM	AG_Stats
			WHERE	role_desc = 'SECONDARY'
			)
SELECT p.replica_server_name [primary_replica]
	, p.[DBName] AS [DatabaseName]
	, s.replica_server_name [secondary_replica]
	, CAST(s.redo_queue_size_KB / s.redo_rate_KB_Sec AS BIGINT) [Redo_Lag_Secs]
FROM Pri_CommitTime p
LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName]

