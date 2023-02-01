-- Calculate Memory Needed for SQL

DECLARE @MemToApps INT
DECLARE @RoomForOS INT
DECLARE @WT INT
DECLARE @PhysicalMemory INT

SET @RoomForOS = 2048
SET @MemToApps = 2048


SET @WT = (
		SELECT [max_workers_count]
		FROM sys.dm_os_sys_info
		)

SET @PhysicalMemory = (
		SELECT [physical_memory_kb] / 1024
		FROM sys.dm_os_sys_info
		)

IF OBJECT_ID('tempdb..#memory') IS NOT NULL
	DROP TABLE #memory

CREATE TABLE #memory (
	[PhysicalMemory] INT
	, [RoomForOS] INT
	, [MemToApps] INT
	, [WorkerThreadMemory] INT
	, [CalculatedMaxServerMemoryMB] INT
	, [ConfiguredMaxServerMemoryMB] INT
	, [ActiveMaxServerMemoryMB] INT
	)

IF EXISTS (
		SELECT 1
		FROM sys.configurations
		WHERE NAME LIKE '%64%'
		)
BEGIN
	-- 64 bit platform:
	INSERT INTO #memory
	SELECT @PhysicalMemory AS [PhysicalMemory]
		, @RoomForOS AS [RoomForOS]
		, @MemToApps AS [MemToApps]
		, CAST((@WT * 2) AS INT) AS [WorkerThreadMemory]
		, CAST((@PhysicalMemory - @RoomForOS - @MemToApps - (@WT * 2)) AS INT) AS [CalculatedMaxServerMemoryMB]
		, CAST([value] AS INT) AS [ConfiguredMaxServerMemoryMB]
		, CAST([value_in_use] AS INT) AS [ActiveMaxServerMemoryMB]
	FROM sys.configurations
	WHERE [name] = 'max server memory (MB)'
END
ELSE
BEGIN
	-- 32 bit platform:
	INSERT INTO #memory
	SELECT @PhysicalMemory AS [PhysicalMemory]
		, @RoomForOS AS [RoomForOS]
		, @MemToApps AS [MemToApps]
		, CAST((@WT * 0.5) AS INT) AS [WorkerThreadMemory]
		, CAST((@PhysicalMemory - @RoomForOS - @MemToApps - (@WT * 0.5)) AS INT) AS [CalculatedMaxServerMemoryMB]
		, CAST([value] AS INT) AS [ConfiguredMaxServerMemoryMB]
		, CAST([value_in_use] AS INT) AS [ActiveMaxServerMemoryMB]
	FROM sys.configurations
	WHERE [name] = 'max server memory (MB)'
END

SELECT #memory.PhysicalMemory AS 'Physical Memory'
	, #memory.RoomForOS AS 'Room For OS'
	, #memory.MemToApps AS 'Mem To Apps'
	, #memory.WorkerThreadMemory AS 'Worker Thread Memory'
	, #memory.CalculatedMaxServerMemoryMB AS 'Calculated Max Server Memory (MB)'
	, #memory.ConfiguredMaxServerMemoryMB AS 'Configured Max Server Memory (MB)'
	, #memory.ActiveMaxServerMemoryMB AS 'Active Max Server Memory (MB)'
FROM #memory
