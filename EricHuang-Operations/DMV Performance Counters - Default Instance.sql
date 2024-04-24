/*
SELECT DISTINCT [object_name] 
FROM sys.[dm_os_performance_counters] 
ORDER BY[object_name]; 

SELECT [object_name], [counter_name], 
   [instance_name], [cntr_value]
FROM sys.[dm_os_performance_counters]
WHERE counter_name like'%wait%' and [object_name] = 'SQLServer:Wait Statistics'
ORDER BY cntr_value DESC

The Five Values Of Cntr_Type
 
1. Cntr_Type = 65792
This is the easiest one, because what you get is the counter’s actual value, the whole value, 
and nothing but the value. For example, the SQLServer:Buffer Manager / Total pages counter 
is of this type. It shows the number of (8k) pages in SQL Server’s buffer pool, and on one 
of my servers shows 332272 representing the 2.5GB of memory allocated to that instance of SQL. 
Every time you query the DMV, the result is the real-time value for that counter.

2. Cntr_Type = 537003264
Counters of this type are also real-time results, but with an added complexity that they 
need to be divided by a “base” to obtain the actual value. By themselves, they are useless … 
kind of like how a car is useless without gas in it …It is, literally, the same counter with 
the word “base” tacked onto the counter name. If you’re sorting the DMV’s results by 
counter_name, you’ll see the two rows next to each other. You’ll probably also notice that 
the base value has it’s own counter type: 1073939712.you divide cntr_value from the first row 
by cntr_value from the second row to get a ratio, or multiply that result by 100.0 to get a 
percentage (don’t forget that one of the two values needs to be converted to float!)

SELECT CntrVal.object_name, CntrVal.counter_name, CntrVal.instance_name,
       CASE WHEN CntrBase.cntr_value = 0
            THEN 0
            ELSE CAST(CntrVal.cntr_value AS FLOAT) / CntrBase.cntr_value
       END AS CounterValueRatio
FROM sys.dm_os_performance_counters CntrVal
  JOIN sys.dm_os_performance_counters CntrBase
    ON CntrVal.object_name = CntrBase.object_name
      AND CntrVal.instance_name = CntrBase.instance_name
      AND (
           RTRIM(CntrVal.counter_name) + N' Base' = CntrBase.counter_name
           OR (
               CntrVal.counter_name = N'Worktables From Cache Ratio'
               AND CntrBase.counter_name = N'Worktables From Cache Base'
              )
          )
WHERE CntrVal.cntr_type = 537003264

*/
SELECT @@SERVERNAME AS SQLInstance, GETDATE() AS CurrentDateTime;

EXEC sys.sp_configure @configname = 'cost threshold for parallelism'
EXEC sys.sp_configure @configname = 'max degree of parallelism'

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


SELECT * FROM SYS.DM_OS_SYS_INFO

--Returns Total SQL Server Memory
SELECT object_name, counter_name, cntr_value AS 'value'
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

--Average Latch Wait Time
SELECT ROUND(CAST(A.cntr_value1 AS NUMERIC) / CAST(B.cntr_value2 AS NUMERIC), 3) AS [Average Latch Wait Time]
FROM (
	SELECT cntr_value AS cntr_value1
	FROM sys.dm_os_performance_counters
	WHERE object_name = 'SQLServer:Latches'
		AND counter_name = 'Average Latch Wait Time (ms)'
	) AS A,
	(
		SELECT cntr_value AS cntr_value2
		FROM sys.dm_os_performance_counters
		WHERE object_name = 'SQLServer:Latches'
			AND counter_name = 'Average Latch Wait Time Base'
		) AS B


--IO
SELECT counter_name, cntr_value AS 'Page Splits Per Sec'
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Access Methods'
	AND counter_name = 'Page Splits/sec'
ORDER BY cntr_value DESC


SELECT counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:SQL Statistics'
	AND counter_name IN ('SQL Compilations/sec', 
						'SQL Re-Compilations/sec', 
						'Batch Requests/sec')
ORDER BY cntr_value DESC


-- Returns the number of user connections
SELECT cntr_value AS [User Connections]
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:General Statistics'
	AND counter_name = 'User Connections'


--Returns Transactions per second
SELECT instance_name AS 'DB Name',
	cntr_value AS 'Transactions per second'
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Databases'
	AND counter_name = 'Transactions/sec'
ORDER BY cntr_value DESC
