-- Calulate Memory for SQL

------------------------------------------------
-- Itanium is not supported in this calculation!
------------------------------------------------
-- MemToApps and RoomForOS should be manually 
-- specified below.
------------------------------------------------
-- Memory for applications in MB
DECLARE @MemToApps INT

SET @MemToApps = 2048

-- Memory allocated to the OS in MB
DECLARE @RoomForOS INT

SET @RoomForOS = 2048

-- Querying max worker threads
DECLARE @WT INT

SET @WT = (
		SELECT [max_workers_count]
		FROM sys.dm_os_sys_info
		)

-- Querying physical memory
DECLARE @PhysicalMemory INT

SET @PhysicalMemory = (
		SELECT [physical_memory_kb] / 1024 --131072
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

-- Memory allocated to other apps than SQL Server.
-- Antivirus, Backups software + 1024 MB for multi-page alocation, sqlxml, etc.
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

-- Returning results:
SELECT @PhysicalMemory AS 'Physical Memory'
	, @RoomForOS AS 'Room For OS'
	, @MemToApps AS 'Mem For Apps'
	, #memory.WorkerThreadMemory AS 'Worker Thread Memory'
	, #memory.CalculatedMaxServerMemoryMB AS 'Calculated Max Server Memory (MB)'
	, #memory.ConfiguredMaxServerMemoryMB AS 'Configured Max Server Memory (MB)'
	, #memory.ActiveMaxServerMemoryMB AS 'Active Max Server Memory (MB)'
FROM #memory
