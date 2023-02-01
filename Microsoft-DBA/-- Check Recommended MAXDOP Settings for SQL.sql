-- Check Recommended MAXDOP Settings for SQL

DECLARE @hyperthreadingRatio BIT
DECLARE @logicalCPUs INT
DECLARE @HTEnabled INT
DECLARE @physicalCPU INT
DECLARE @SOCKET INT
DECLARE @logicalCPUPerNuma INT
DECLARE @NoOfNUMA INT
DECLARE @MaxString VARCHAR(25)
DECLARE @MaxSetting CHAR(1)

SET @MaxString = 'MAXDOP Setting: '

SELECT @MaxSetting = CONVERT(CHAR(1), value_in_use)
FROM sys.configurations
WHERE NAME LIKE 'max degree of parallelism%'

SELECT @MaxString + @MaxSetting

SELECT @logicalCPUs = cpu_count -- [Logical CPU Count]
	, @hyperthreadingRatio = hyperthread_ratio -- [Hyper thread Ratio]
	, @physicalCPU = cpu_count / hyperthread_ratio -- [Physical CPU Count]
	, @HTEnabled = CASE 
		WHEN cpu_count > hyperthread_ratio
			THEN 1
		ELSE 0
		END -- HTEnabled
FROM sys.dm_os_sys_info
OPTION (RECOMPILE);

SELECT @logicalCPUPerNuma = COUNT(parent_node_id) -- [Number Of Logical Processors Per Numa]
FROM sys.dm_os_schedulers
WHERE [status] = 'VISIBLE ONLINE'
	AND parent_node_id < 64
GROUP BY parent_node_id
OPTION (RECOMPILE);

SELECT @NoOfNUMA = count(DISTINCT parent_node_id)
FROM sys.dm_os_schedulers -- [Find NO OF NUMA Nodes]
WHERE [status] = 'VISIBLE ONLINE'
	AND parent_node_id < 64

-- [Report the recommendations] ....
SELECT
	-- [8 or less processors and NO HT enabled]
	CASE 
		WHEN @logicalCPUs < 8
			AND @HTEnabled = 0
			THEN 'MAXDOP Setting should be: ' + CAST(@logicalCPUs AS VARCHAR(3))
				-- [8 or more processors and NO HT enabled]
		WHEN @logicalCPUs >= 8
			AND @HTEnabled = 0
			THEN 'MAXDOP Setting should be: 8'
				-- [8 or more processors and HT enabled and NO NUMA]
		WHEN @logicalCPUs >= 8
			AND @HTEnabled = 1
			AND @NoofNUMA = 1
			THEN 'MaxDop Setting should be: ' + CAST(@logicalCPUPerNuma / @physicalCPU AS VARCHAR(3))
				-- [8 or more processors and HT enabled and NUMA]
		WHEN @logicalCPUs >= 8
			AND @HTEnabled = 1
			AND @NoofNUMA > 1
			THEN 'MaxDop Setting should be: ' + CAST(@logicalCPUPerNuma / @physicalCPU AS VARCHAR(3))
		ELSE ''
		END AS 'Recommendations'