-- Calculate MAXDOP for System

DECLARE @hyperthreadingRatio BIT
DECLARE @logicalCPUs INT
DECLARE @HTEnabled INT
DECLARE @physicalCPU INT
DECLARE @SOCKET INT
DECLARE @logicalCPUPerNuma INT
DECLARE @NoOfNUMA INT
DECLARE @MaxDOP INT

SELECT @logicalCPUs = cpu_count
	, @hyperthreadingRatio = hyperthread_ratio
	, @physicalCPU = cpu_count / hyperthread_ratio
	, @HTEnabled = CASE 
		WHEN cpu_count > hyperthread_ratio
			THEN 1
		ELSE 0
		END -- HTEnabled
FROM sys.dm_os_sys_info
OPTION (RECOMPILE);

SELECT @logicalCPUPerNuma = COUNT(parent_node_id)
FROM sys.dm_os_schedulers
WHERE [status] = 'VISIBLE ONLINE'
	AND parent_node_id < 64
GROUP BY parent_node_id
OPTION (RECOMPILE);

SELECT @NoOfNUMA = count(DISTINCT parent_node_id)
FROM sys.dm_os_schedulers
WHERE [status] = 'VISIBLE ONLINE'
	AND parent_node_id < 64

IF @NoofNUMA > 1
	AND @HTEnabled = 0
	SET @MaxDOP = @logicalCPUPerNuma
ELSE IF @NoofNUMA > 1
	AND @HTEnabled = 1
	SET @MaxDOP = round(@NoofNUMA / @physicalCPU * 1.0, 0)
ELSE IF @HTEnabled = 0
	SET @MaxDOP = @logicalCPUs
ELSE IF @HTEnabled = 1
	SET @MaxDOP = @physicalCPU

IF @MaxDOP > 10
	SET @MaxDOP = 10

IF @MaxDOP = 0
	SET @MaxDOP = 1

PRINT 'Logical CPUs : ' + CONVERT(VARCHAR, @logicalCPUs)
PRINT 'Hyperthreading Ratio : ' + CONVERT(VARCHAR, @hyperthreadingRatio)
PRINT 'Physical CPU : ' + CONVERT(VARCHAR, @physicalCPU)
PRINT 'HTEnabled : ' + CONVERT(VARCHAR, @HTEnabled)
PRINT 'Logical CPU PerNuma : ' + CONVERT(VARCHAR, @logicalCPUPerNuma)
PRINT 'NoOfNUMA : ' + CONVERT(VARCHAR, @NoOfNUMA)
PRINT '---------------------------'
PRINT 'MAXDOP setting should be : ' + CONVERT(VARCHAR, @MaxDOP)
