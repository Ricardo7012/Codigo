-- Check Data per Second for Database

DECLARE @SQLProcessUtilization INT;
DECLARE @PageReadsPerSecond BIGINT
DECLARE @PageWritesPerSecond BIGINT
DECLARE @CheckpointPagesPerSecond BIGINT
DECLARE @LazyWritesPerSecond BIGINT
DECLARE @BatchRequestsPerSecond BIGINT
DECLARE @CompilationsPerSecond BIGINT
DECLARE @ReCompilationsPerSecond BIGINT
DECLARE @PageLookupsPerSecond BIGINT
DECLARE @TransactionsPerSecond BIGINT
DECLARE @stat_date DATETIME

-- Table for First Sample
DECLARE @RatioStatsX TABLE (
	[object_name] VARCHAR(128)
	, [counter_name] VARCHAR(128)
	, [instance_name] VARCHAR(128)
	, [cntr_value] BIGINT
	, [cntr_type] INT
	)

	-- Table for Second Sample
DECLARE @RatioStatsY TABLE (
	[object_name] VARCHAR(128)
	, [counter_name] VARCHAR(128)
	, [instance_name] VARCHAR(128)
	, [cntr_value] BIGINT
	, [cntr_type] INT
	)

INSERT INTO @RatioStatsX (
	[object_name]
	, [counter_name]
	, [instance_name]
	, [cntr_value]
	, [cntr_type]
	)
SELECT [object_name]
	, [counter_name]
	, [instance_name]
	, [cntr_value]
	, [cntr_type]
FROM sys.dm_os_performance_counters

SET @stat_date = getdate()

SELECT TOP 1 @PageReadsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page reads/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:Buffer Manager'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
		END

SELECT TOP 1 @PageWritesPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page writes/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:Buffer Manager'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
		END

SELECT TOP 1 @CheckpointPagesPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Checkpoint pages/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:Buffer Manager'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
		END

SELECT TOP 1 @LazyWritesPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Lazy writes/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:Buffer Manager'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
		END

SELECT TOP 1 @BatchRequestsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Batch Requests/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:SQL Statistics'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics'
		END

SELECT TOP 1 @CompilationsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'SQL Compilations/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:SQL Statistics'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics'
		END

SELECT TOP 1 @ReCompilationsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'SQL Re-Compilations/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:SQL Statistics'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics'
		END

SELECT TOP 1 @PageLookupsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Page lookups/sec'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:Buffer Manager'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
		END

SELECT TOP 1 @TransactionsPerSecond = cntr_value
FROM @RatioStatsX
WHERE counter_name = 'Transactions/sec'
	AND instance_name = '_Total'
	AND object_name = CASE 
		WHEN @@SERVICENAME = 'MSSQLSERVER'
			THEN 'SQLServer:Databases'
		ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Databases'
		END

-- Wait for 30 seconds before taking second sample
WAITFOR DELAY '00:00:30'

-- Table for second sample
INSERT INTO @RatioStatsY (
	[object_name]
	, [counter_name]
	, [instance_name]
	, [cntr_value]
	, [cntr_type]
	)
SELECT [object_name]
	, [counter_name]
	, [instance_name]
	, [cntr_value]
	, [cntr_type]
FROM sys.dm_os_performance_counters

SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 AS 'Buffer Cache Hit Ratio'
	, c.[PageReadPerSec] AS 'Page Reads (Sec)'
	, d.[PageWritesPerSecond] AS 'Page Writes (Sec)'
	, e.cntr_value AS 'User Connections'
	, f.cntr_value AS 'Page Life Expectency'
	, g.[CheckpointPagesPerSecond] AS 'Checkpoint Pages (Sec)'
	, h.[LazyWritesPerSecond] AS 'Lazy Writes (Sec)'
	, i.cntr_value AS 'Free Space In Tempdb (KB)'
	, j.[BatchRequestsPerSecond] AS 'Batch Requests (Sec)'
	, k.[SQLCompilationsPerSecond] AS 'SQL Compilations (Sec)'
	, l.[SQLReCompilationsPerSecond] AS 'SQL ReCompilations (Sec)'
	, m.cntr_value AS 'Target Server Memory (KB)'
	, n.cntr_value AS 'Total Server Memory (KB)'
	, GETDATE() AS 'Measurement Time'
	, o.[AvgTaskCount] AS 'Avg Task Count'
	, o.[AvgRunnableTaskCount] AS 'Avg Runnable Task Count'
	, o.[AvgPendingDiskIOCount] AS 'Avg Pending Disk IO Count'
	, p.PercentSignalWait AS 'Percent Signal Wait'
	, q.PageLookupsPerSecond AS 'Page Lookups (Sec)'
	, r.TransactionsPerSecond AS ' Transactions (Sec)'
	, s.cntr_value AS 'Memory Grants Pending'
FROM (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Buffer cache hit ratio'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) a
INNER JOIN (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Buffer cache hit ratio base'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) b
	ON a.x = b.x
INNER JOIN (
	SELECT (cntr_value - @PageReadsPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [PageReadPerSec]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Page reads/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) c
	ON a.x = c.x
INNER JOIN (
	SELECT (cntr_value - @PageWritesPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [PageWritesPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Page writes/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) d
	ON a.x = d.x
INNER JOIN (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'User Connections'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:General Statistics'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':General Statistics'
			END
	) e
	ON a.x = e.x
INNER JOIN (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Page life expectancy '
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) f
	ON a.x = f.x
INNER JOIN (
	SELECT (cntr_value - @CheckpointPagesPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [CheckpointPagesPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Checkpoint pages/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) g
	ON a.x = g.x
INNER JOIN (
	SELECT (cntr_value - @LazyWritesPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [LazyWritesPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Lazy writes/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) h
	ON a.x = h.x
INNER JOIN (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Free Space in tempdb (KB)'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Transactions'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Transactions'
			END
	) i
	ON a.x = i.x
INNER JOIN (
	SELECT (cntr_value - @BatchRequestsPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [BatchRequestsPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Batch Requests/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:SQL Statistics'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics'
			END
	) j
	ON a.x = j.x
INNER JOIN (
	SELECT (cntr_value - @CompilationsPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [SQLCompilationsPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'SQL Compilations/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:SQL Statistics'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics'
			END
	) k
	ON a.x = k.x
INNER JOIN (
	SELECT (cntr_value - @ReCompilationsPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [SQLReCompilationsPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'SQL Re-Compilations/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:SQL Statistics'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':SQL Statistics'
			END
	) l
	ON a.x = l.x
INNER JOIN (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Target Server Memory (KB)'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Memory Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Memory Manager'
			END
	) m
	ON a.x = m.x
INNER JOIN (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Total Server Memory (KB)'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Memory Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Memory Manager'
			END
	) n
	ON a.x = n.x
INNER JOIN (
	SELECT 1 AS x
		, AVG(current_tasks_count) AS [AvgTaskCount]
		, AVG(runnable_tasks_count) AS [AvgRunnableTaskCount]
		, AVG(pending_disk_io_count) AS [AvgPendingDiskIOCount]
	FROM sys.dm_os_schedulers
	WHERE scheduler_id < 255
	) o
	ON a.x = o.x
INNER JOIN (
	SELECT 1 AS x
		, SUM(signal_wait_time_ms) / sum(wait_time_ms) AS PercentSignalWait
	FROM sys.dm_os_wait_stats
	) p
	ON a.x = p.x
INNER JOIN (
	SELECT (cntr_value - @PageLookupsPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [PageLookupsPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Page Lookups/sec'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Buffer Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Buffer Manager'
			END
	) q
	ON a.x = q.x
INNER JOIN (
	SELECT (cntr_value - @TransactionsPerSecond) / (
			CASE 
				WHEN datediff(ss, @stat_date, getdate()) = 0
					THEN 1
				ELSE datediff(ss, @stat_date, getdate())
				END
			) AS [TransactionsPerSecond]
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Transactions/sec'
		AND instance_name = '_Total'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Databases'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Databases'
			END
	) r
	ON a.x = r.x
INNER JOIN (
	SELECT *
		, 1 x
	FROM @RatioStatsY
	WHERE counter_name = 'Memory Grants Pending'
		AND object_name = CASE 
			WHEN @@SERVICENAME = 'MSSQLSERVER'
				THEN 'SQLServer:Memory Manager'
			ELSE 'MSSQL$' + rtrim(@@SERVICENAME) + ':Memory Manager'
			END
	) s
	ON a.x = s.x
