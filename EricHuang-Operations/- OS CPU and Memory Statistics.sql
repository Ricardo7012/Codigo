--System memory configuration. 
SELECT total_physical_memory_kb, 
	available_physical_memory_kb, 
	system_memory_state_desc
FROM sys.dm_os_sys_memory; 

DECLARE @memory_usage FLOAT, 
		@cpu_usage FLOAT
		
SET @memory_usage = ( SELECT 1.0 - ( 
									available_physical_memory_kb / ( total_physical_memory_kb * 1.0 )
								   ) AS memory_usage
                        FROM      sys.dm_os_sys_memory
                    )

SET @cpu_usage = ( SELECT TOP ( 1 )
                            [CPU] / 100.0 AS [CPU_usage]
                    FROM     ( SELECT    record.value('(./Record/@id)[1]', 'int') AS record_id
                                        , record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [CPU]
                                FROM      ( SELECT    [timestamp]
                                                    , CONVERT(XML, record) AS [record]
                                            FROM      sys.dm_os_ring_buffers WITH ( NOLOCK )
                                            WHERE     ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
                                                    AND record LIKE N'%<SystemHealth>%'
                                        ) AS x
                            ) AS y
                    ORDER BY record_id DESC
                    )


SELECT
	(SELECT  @memory_usage) AS [Memory_Usage],
	(SELECT @cpu_usage) AS [SQL_CPU_Usage]



-- DBCC MEMORYSTATUS

--********************************************************************
--*  View the currently activated stored procedures
--*  The activated stored procedure is now waiting on a LCK_M_IS wait type
--*  and is never *ever* finishing...
--********************************************************************
SELECT t.*, s.last_wait_type FROM sys.dm_broker_activated_tasks t
INNER JOIN sys.dm_exec_requests s ON s.session_id = t.spid
GO


--Returns Total SQL Server Memory
SELECT object_name, counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Memory Manager'
	AND counter_name IN ('Total Server Memory (KB)', 
		'Target Server Memory (KB)', 
		'Maximum Workspace Memory (KB)', 
		'SQL Cache Memory (KB)',
		'Memory Grants Pending',
		'Memory Grants Outstanding',
		'Stolen Server Memory (KB)',
		'Free Memory (KB)',
		'Database Cache Memory (KB)',
		'Log Pool Memory (KB)',
		'External benefit of memory')
ORDER BY counter_name DESC


--Returns the page life expectancy
SELECT
	Instance_Name,
	CAST(cntr_value AS NUMERIC) AS 'PLE in Seconds',
	ROUND((CAST(cntr_value AS NUMERIC) / 60), 1) AS 'PLE in Minutes',
	ROUND(((CAST(cntr_value AS NUMERIC) / 60)/60), 1) AS 'PLE in Hours',
	(SELECT (DATEDIFF(MINUTE, crdate, GETDATE())/60.0)
		FROM sys.sysdatabases WHERE NAME = 'tempdb') AS 'SQLUpTime Hours',
	ROUND((((CAST(cntr_value AS NUMERIC) / 60)/60)/24), 1) AS 'PLE in Days',
	(SELECT ((DATEDIFF(MINUTE, crdate, GETDATE())/60.0)/24)
		FROM sys.sysdatabases WHERE NAME = 'tempdb') AS 'SQLUpTime Days'
FROM sys.dm_os_performance_counters
WHERE object_name IN ('SQLServer:Buffer Manager', 'SQLServer:Buffer Node')
	AND counter_name = 'Page life expectancy'
ORDER BY  instance_name


--Returns the buffer cache hit ratio
SELECT ROUND((100 * CAST(A.cntr_value1 AS NUMERIC)) / CAST(B.cntr_value2 AS NUMERIC), 3) AS Buffer_Cache_Hit_Ratio
FROM (
	SELECT cntr_value AS cntr_value1
	FROM sys.dm_os_performance_counters
	WHERE object_name = 'SQLServer:Buffer Manager'
		AND counter_name = 'Buffer cache hit ratio'
	) AS A,
	(
		SELECT cntr_value AS cntr_value2
		FROM sys.dm_os_performance_counters
		WHERE object_name = 'SQLServer:Buffer Manager'
			AND counter_name = 'Buffer cache hit ratio base'
		) AS B


--Lazy writes/sec should be near zero, this tells you how many times the 
--buffer pool flushed dirty pages to disk outside of the CHECKPOINT process
SELECT object_name, counter_name, cntr_value, dba_note = 'This value is cummulative.',
	CAST (
		ROUND((cntr_value / (SELECT (DATEDIFF(SECOND, crdate, GETDATE())/60.0) 
		FROM sys.sysdatabases WHERE NAME = 'tempdb')), 2) AS DECIMAL (16,2)) AS AcutalPerSecValue
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
	and counter_name IN ('Checkpoint pages/sec', 'Free list stalls/sec', 'Lazy writes/sec')
