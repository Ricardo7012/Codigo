-- Calculate Memory Needed for SQL Server (Single Instance) 

IF OBJECT_ID('tempdb..#mem') IS NOT NULL
	DROP TABLE #mem
GO

DECLARE @memInMachine DECIMAL(9, 2)
	, @memOsBase DECIMAL(9, 2)
	, @memOs4_16GB DECIMAL(9, 2)
	, @memOsOver_16GB DECIMAL(9, 2)
	, @memOsTot DECIMAL(9, 2)
	, @memForSql DECIMAL(9, 2)
	, @CurrentMem DECIMAL(9, 2)
	, @sql VARCHAR(1000)

CREATE TABLE #mem (mem DECIMAL(9, 2))

SET @CurrentMem = (
		SELECT CAST(value AS INT) / 1024.
		FROM sys.configurations
		WHERE NAME = 'MAX Server Memory (MB)'
		)

IF CAST(LEFT(CAST(SERVERPROPERTY('ResourceVersion') AS VARCHAR(20)), 1) AS INT) = 9
	SET @sql = 'SELECT physical_memory_in_bytes/(1024 * 1024 * 1024.) FROM sys.dm_os_sys_info'
ELSE
	IF CAST(LEFT(CAST(SERVERPROPERTY('ResourceVersion') AS VARCHAR(20)), 2) AS INT) >= 11
		SET @sql = 'SELECT physical_memory_kb/(1024 * 1024.) FROM sys.dm_os_sys_info'
	ELSE
		SET @sql = 'SELECT physical_memory_in_bytes/(1024 * 1024 * 1024.) FROM sys.dm_os_sys_info'

SET @sql = 'DECLARE @mem decimal(9,2) SET @mem = (' + @sql + ') INSERT INTO #mem(mem) VALUES(@mem)'

PRINT @sql

EXEC (@sql)

SET @memInMachine = (
		SELECT MAX(mem)
		FROM #mem
		)

SET @memOsBase = 1
SET @memOs4_16GB = CASE 
		WHEN @memInMachine <= 4
			THEN 0
		WHEN @memInMachine > 4
			AND @memInMachine <= 16
			THEN (@memInMachine - 4) / 4
		WHEN @memInMachine >= 16
			THEN 3
		END
SET @memOsOver_16GB = CASE 
		WHEN @memInMachine <= 16
			THEN 0
		ELSE (@memInMachine - 16) / 8
		END
SET @memOsTot = @memOsBase + @memOs4_16GB + @memOsOver_16GB
SET @memForSql = @memInMachine - @memOsTot

SELECT 'Current Mem Config:' AS 'SQL Memory Setting'
	, @CurrentMem AS 'SQL Memory Setting'

SELECT 'Mem In Machine:' AS 'MB Memory'
	, @memInMachine AS 'MB Memory'

SELECT 'Memory For OS' AS 'Memory for OS'
	, @memOsTot AS 'Memory for OS'

SELECT 'Memory For Sql' AS 'Memory for SQL'
	, @memForSql AS 'Memory for SQL'

SELECT 'Command To Execute' AS 'Configure SQL'
	, 'EXEC sp_configure ''Max Server Memory'', ' + CAST(CAST(@memForSql * 1024 AS INT) AS VARCHAR(10)) + ' RECONFIGURE' AS 'Configure SQL'

SELECT 'Comment' AS 'Comment for SQL'
	, 'Assumes dedicated instance. Only use the value after you verify it is reasonable.' AS 'Comment for SQL'