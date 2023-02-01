-- Check Stall Information for 30 Minutes

IF EXISTS (
		SELECT *
		FROM [tempdb].[sys].[objects]
		WHERE [name] = N'##SQLStats1'
		)
	DROP TABLE [##SQLskillsStats1];

IF EXISTS (
		SELECT *
		FROM [tempdb].[sys].[objects]
		WHERE [name] = N'##SQLStats2'
		)
	DROP TABLE [##SQLStats2];
GO

SELECT [database_id]
	, [file_id]
	, [num_of_reads]
	, [io_stall_read_ms]
	, [num_of_writes]
	, [io_stall_write_ms]
	, [io_stall]
	, [num_of_bytes_read]
	, [num_of_bytes_written]
	, [file_handle]
INTO ##SQLStats1
FROM sys.dm_io_virtual_file_stats(NULL, NULL);
GO

WAITFOR DELAY '00:00:02';
GO

SELECT [database_id]
	, [file_id]
	, [num_of_reads]
	, [io_stall_read_ms]
	, [num_of_writes]
	, [io_stall_write_ms]
	, [io_stall]
	, [num_of_bytes_read]
	, [num_of_bytes_written]
	, [file_handle]
INTO ##SQLStats2
FROM sys.dm_io_virtual_file_stats(NULL, NULL);
GO

WITH [DiffLatencies]
AS (
	SELECT
		-- Files that weren't in the first snapshot
		[ts2].[database_id]
		, [ts2].[file_id]
		, [ts2].[num_of_reads]
		, [ts2].[io_stall_read_ms]
		, [ts2].[num_of_writes]
		, [ts2].[io_stall_write_ms]
		, [ts2].[io_stall]
		, [ts2].[num_of_bytes_read]
		, [ts2].[num_of_bytes_written]
	FROM [##SQLStats2] AS [ts2]
	LEFT JOIN [##SQLStats1] AS [ts1]
		ON [ts2].[file_handle] = [ts1].[file_handle]
	WHERE [ts1].[file_handle] IS NULL
	
	UNION
	
	SELECT
		-- Diff of latencies in both snapshots
		[ts2].[database_id]
		, [ts2].[file_id]
		, [ts2].[num_of_reads] - [ts1].[num_of_reads] AS [num_of_reads]
		, [ts2].[io_stall_read_ms] - [ts1].[io_stall_read_ms] AS [io_stall_read_ms]
		, [ts2].[num_of_writes] - [ts1].[num_of_writes] AS [num_of_writes]
		, [ts2].[io_stall_write_ms] - [ts1].[io_stall_write_ms] AS [io_stall_write_ms]
		, [ts2].[io_stall] - [ts1].[io_stall] AS [io_stall]
		, [ts2].[num_of_bytes_read] - [ts1].[num_of_bytes_read] AS [num_of_bytes_read]
		, [ts2].[num_of_bytes_written] - [ts1].[num_of_bytes_written] AS [num_of_bytes_written]
	FROM [##SQLStats2] AS [ts2]
	LEFT JOIN [##SQLStats1] AS [ts1]
		ON [ts2].[file_handle] = [ts1].[file_handle]
	WHERE [ts1].[file_handle] IS NOT NULL
	)
SELECT DB_NAME([vfs].[database_id]) AS 'DB Name'
	, LEFT([mf].[physical_name], 2) AS 'Drive'
	, [mf].[type_desc] AS 'Type Desc'
	, [num_of_reads] AS 'Reads'
	, [num_of_writes] AS 'Writes'
	, 'Read Latency (ms)' = CASE 
		WHEN [num_of_reads] = 0
			THEN 0
		ELSE ([io_stall_read_ms] / [num_of_reads])
		END
	, 'Write Latency (ms)' = CASE 
		WHEN [num_of_writes] = 0
			THEN 0
		ELSE ([io_stall_write_ms] / [num_of_writes])
		END
	, 'Latency' = CASE 
		WHEN (
				[num_of_reads] = 0
				AND [num_of_writes] = 0
				)
			THEN 0
		ELSE ([io_stall] / ([num_of_reads] + [num_of_writes]))
		END
	, 'Avg B Per Read' = CASE 
		WHEN [num_of_reads] = 0
			THEN 0
		ELSE ([num_of_bytes_read] / [num_of_reads])
		END
	, 'Avg B Per Write' = CASE 
		WHEN [num_of_writes] = 0
			THEN 0
		ELSE ([num_of_bytes_written] / [num_of_writes])
		END
	, 'Avg B Per Transfer' = CASE 
		WHEN (
				[num_of_reads] = 0
				AND [num_of_writes] = 0
				)
			THEN 0
		ELSE (([num_of_bytes_read] + [num_of_bytes_written]) / ([num_of_reads] + [num_of_writes]))
		END
	, [mf].[physical_name] AS 'Physical Name'
FROM [DiffLatencies] AS [vfs]
INNER JOIN sys.master_files AS [mf]
	ON [vfs].[database_id] = [mf].[database_id]
		AND [vfs].[file_id] = [mf].[file_id]

ORDER BY 'Write Latency (ms)', 'Read Latency (ms)' DESC
GO

-- Cleanup
IF EXISTS (
		SELECT *
		FROM [tempdb].[sys].[objects]
		WHERE [name] = N'##SQLStats1'
		)
	DROP TABLE [##SQLStats1]

IF EXISTS (
		SELECT *
		FROM [tempdb].[sys].[objects]
		WHERE [name] = N'##SQLStats2'
		)
	DROP TABLE [##SQLStats2]
GO


