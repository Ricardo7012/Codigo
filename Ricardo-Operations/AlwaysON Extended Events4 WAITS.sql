-- https://www.red-gate.com/simple-talk/sql/database-administration/a-first-look-at-sql-server-2012-availability-group-wait-statistics/
-- https://www.mssqltips.com/sqlservertip/2573/monitor-sql-server-alwayson-availability-groups/

SELECT *
FROM sys.dm_hadr_availability_replica_states;
GO
SELECT replica_server_name,
       session_timeout
FROM sys.availability_replicas;

-- Signal Waits for instance
SELECT CAST(100.0 * SUM(signal_wait_time_ms) / SUM(wait_time_ms) AS NUMERIC(20, 2)) AS [%signal (cpu) waits],
       CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM(wait_time_ms) AS NUMERIC(20, 2)) AS [%resource waits]
FROM sys.dm_os_wait_stats
OPTION (RECOMPILE);

--IF OBJECT_ID('dbo.T_WaitStats', 'U') IS NOT NULL
--    DROP TABLE dbo.T_WaitStats
--GO

--CREATE TABLE [dbo].[T_WaitStats] (
--    RowNum INT IDENTITY (1, 1) PRIMARY KEY,
--    CaptureDate DATETIME,
--    WaitType NVARCHAR(120),
--    Wait_S DECIMAL(14,2),
--    Resource_S DECIMAL(14,2),
--    Signal_S DECIMAL(14,2),
--    WaitCount BIGINT,
--    Percentage DECIMAL(4,2),
--    AvgWait_S DECIMAL(14,2),
--    AvgRes_S DECIMAL(14,2),
--    AvgSig_S DECIMAL(14,2)
--)
--GO

--INSERT INTO dbo.T_WaitStats ([WaitType])
--VALUES ('Wait Statistics for ' + CAST(GETDATE() AS NVARCHAR(19)))

--INSERT INTO dbo.T_WaitStats (CaptureDate, WaitType, Wait_S, Resource_S, Signal_S, WaitCount, Percentage, AvgWait_S, AvgRes_S, AvgSig_S)
EXEC ('WITH [Waits] AS(
        SELECT
            [wait_type],
            [wait_time_ms] / 1000.0 AS [Wait_S],
            ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [Resource_S],
            [signal_wait_time_ms] / 1000.0 AS [Signal_S],
            [waiting_tasks_count] AS [WaitCount],
            100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
            ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
        FROM sys.dm_os_wait_stats
        WHERE [wait_type] LIKE N''HADR_SYNC_COMMIT''
		--NOT IN (
  --          N''BROKER_EVENTHANDLER'',   N''BROKER_RECEIVE_WAITFOR'',
  --          N''BROKER_TASK_STOP'',      N''BROKER_TO_FLUSH'',
  --          N''BROKER_TRANSMITTER'',    N''CHECKPOINT_QUEUE'',
  --          N''CHKPT'',                 N''CLR_AUTO_EVENT'', 
  --          N''CLR_MANUAL_EVENT''       
  --        )
    )
    SELECT      
        GETDATE() AS [CaptureDate],
        [W1].[wait_type] AS [WaitType], 
        [W1].[Wait_S] AS [Wait_S],
        [W1].[Resource_S] AS [Resource_S],
        [W1].[Signal_S] AS [Signal_S],
        [W1].[WaitCount] AS [WaitCount],
        [W1].[Percentage] AS [Percentage],
        [W1].[Wait_S] / [W1].[WaitCount] AS [AvgWait_S],
        [W1].[Resource_S] / [W1].[WaitCount] AS [AvgRes_S],
        [W1].[Signal_S] / [W1].[WaitCount] AS [AvgSig_S]
    FROM [Waits] AS [W1]
    INNER JOIN [Waits] AS [W2]
        ON [W2].[RowNum] <= [W1].[RowNum]
    GROUP BY [W1].[RowNum], [W1].[wait_type], [W1].[Wait_S], 
        [W1].[Resource_S], [W1].[Signal_S], [W1].[WaitCount],
        [W1].[Percentage]
    HAVING SUM ([W2].[Percentage]) - [W1].[Percentage] < 95;'
);

SELECT object_name,
       counter_name,
       instance_name,
       cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name LIKE '%replica%';
