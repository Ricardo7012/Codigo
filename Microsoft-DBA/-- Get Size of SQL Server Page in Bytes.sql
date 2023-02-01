-- Get size of SQL Server Page in Bytes

DECLARE @pg_size INT
DECLARE @Instancename VARCHAR(50)
DECLARE @PollDate datetime

SET @PollDate = (SELECT GETDATE())

SELECT @pg_size = low
FROM master..spt_values
WHERE number = 1
	AND type = 'E'

-- Extract perfmon counters to a temporary table
IF OBJECT_ID('tempdb..#perfmon_counters') IS NOT NULL
	DROP TABLE #perfmon_counters

SELECT dmospc.*
INTO #perfmon_counters
FROM sys.dm_os_performance_counters dmospc;

-- Get SQL Server instance name as it require for capturing Buffer Cache hit Ratio
SELECT @Instancename = LEFT([object_name], (CHARINDEX(':', [object_name])))
FROM #perfmon_counters
WHERE counter_name = 'Buffer cache hit ratio';

SELECT *
FROM (
	SELECT 'Total Server Memory (GB)' AS 'Counter'
		, cast((cntr_value / 1048576.0) AS NUMERIC(18, 2)) AS 'Value'
		, @PollDate AS 'Insert Date'
	FROM #perfmon_counters
	WHERE counter_name = 'Total Server Memory (KB)'
	
	UNION ALL
	
	SELECT 'Target Server Memory (GB)'
		, cast((cntr_value / 1048576.0) AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE counter_name = 'Target Server Memory (KB)'
	
	UNION ALL
	
	SELECT 'Connection Memory (MB)'
		, cast((cntr_value / 1024.0) AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE counter_name = 'Connection Memory (KB)'
	
	UNION ALL
	
	SELECT 'Lock Memory (MB)'
		, cast((cntr_value / 1024.0) AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE counter_name = 'Lock Memory (KB)'
	
	UNION ALL
	
	SELECT 'SQL Cache Memory (MB)'
		, cast((cntr_value / 1024.0) AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE counter_name = 'SQL Cache Memory (KB)'
	
	UNION ALL
	
	SELECT 'Optimizer Memory (MB)'
		, cast((cntr_value / 1024.0) AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE counter_name = 'Optimizer Memory (KB) '
	
	UNION ALL
	
	SELECT 'Granted Workspace Memory (MB)'
		, cast((cntr_value / 1024.0) AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE counter_name = 'Granted Workspace Memory (KB) '
	
	UNION ALL
	
	SELECT 'Cursor Memory Usage (MB)'
		, cast((cntr_value / 1024.0) AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE counter_name = 'Cursor memory usage'
		AND instance_name = '_Total'
	
	UNION ALL
	
	SELECT 'Total Pages Size (MB)'
		, cast((cntr_value * @pg_size) / 1048576.0 AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Total pages'
	
	UNION ALL
	
	SELECT 'Database Pages (MB)'
		, cast((cntr_value * @pg_size) / 1048576.0 AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Database pages'
	
	UNION ALL
	
	SELECT 'Free Pages (MB)'
		, cast((cntr_value * @pg_size) / 1048576.0 AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Free pages'
	
	UNION ALL
	
	SELECT 'Reserved Pages (MB)'
		, cast((cntr_value * @pg_size) / 1048576.0 AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Reserved pages'
	
	UNION ALL
	
	SELECT 'Stolen Pages (MB)'
		, cast((cntr_value * @pg_size) / 1048576.0 AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Stolen pages'
	
	UNION ALL
	
	SELECT 'Cache Pages (MB)'
		, cast((cntr_value * @pg_size) / 1048576.0 AS NUMERIC(18, 2))
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Plan Cache'
		AND counter_name = 'Cache Pages'
		AND instance_name = '_Total'
	
	UNION ALL
	
	SELECT 'Page Life Expectency in (Sec)'
		, cntr_value
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Page life expectancy'
	
	UNION ALL
	
	SELECT 'Free List Stalls in (Sec)'
		, cntr_value
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Free list stalls/sec'
	
	UNION ALL
	
	SELECT 'Checkpoint Pages in (Sec)'
		, cntr_value
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Checkpoint pages/sec'
	
	UNION ALL
	
	SELECT 'Lazy Writes in (Sec)'
		, cntr_value
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Buffer Manager'
		AND counter_name = 'Lazy writes/sec'
	
	UNION ALL
	
	SELECT 'Memory Grants Pending'
		, cntr_value
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Memory Manager'
		AND counter_name = 'Memory Grants Pending'
	
	UNION ALL
	
	SELECT 'Memory Grants Outstanding'
		, cntr_value
		, @PollDate
	FROM #perfmon_counters
	WHERE object_name = @Instancename + 'Memory Manager'
		AND counter_name = 'Memory Grants Outstanding'
	
	UNION ALL
	
	SELECT 'Process Physical Memory Low'
		, process_physical_memory_low
		, @PollDate
	FROM sys.dm_os_process_memory WITH (NOLOCK)
	
	UNION ALL
	
	SELECT 'Process Virtual Memory Low'
		, process_virtual_memory_low
		, @PollDate
	FROM sys.dm_os_process_memory WITH (NOLOCK)
	
	UNION ALL
	
	SELECT 'Max Server Memory (MB)'
		, [value_in_use]
		, @PollDate
	FROM sys.configurations
	WHERE [name] = 'Max Server Memory (MB)'
	
	UNION ALL
	
	SELECT 'Min Server Memory (MB)'
		, [value_in_use]
		, @PollDate
	FROM sys.configurations
	WHERE [name] = 'Min Server Memory (MB)'
	
	UNION ALL
	
	SELECT 'Buffer Cache Hit Ratio'
		, cast((a.cntr_value * 1.0 / b.cntr_value) * 100.0 AS NUMERIC(18, 2))
		, @PollDate
	FROM sys.dm_os_performance_counters a
	INNER JOIN (
		SELECT cntr_value
			, OBJECT_NAME
		FROM sys.dm_os_performance_counters
		WHERE counter_name = 'Buffer cache hit ratio base'
			AND OBJECT_NAME = @Instancename + 'Buffer Manager'
		) b
		ON a.OBJECT_NAME = b.OBJECT_NAME
	WHERE a.counter_name = 'Buffer cache hit ratio'
		AND a.OBJECT_NAME = @Instancename + 'Buffer Manager'
	) AS D;
