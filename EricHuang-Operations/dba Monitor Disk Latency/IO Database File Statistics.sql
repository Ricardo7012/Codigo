DECLARE @WaitTimeSec int
SET @WaitTimeSec = 300 -- seconds between samples.

/* If temp tables exist drop them. */
IF OBJECT_ID('tempdb..#IOStallSnapshot') IS NOT NULL
BEGIN
DROP TABLE #IOStallSnapshot
END

IF OBJECT_ID('tempdb..#IOStallResult') IS NOT NULL
BEGIN
DROP TABLE #IOStallResult
END

/* Create temp tables for capture baseline */
CREATE TABLE #IOStallSnapshot(
CaptureDate datetime,
read_per_ms float,
write_per_ms float,
num_of_bytes_written bigint,
num_of_reads bigint,
num_of_writes bigint,
database_id int,
file_id int
)

CREATE TABLE #IOStallResult(
CaptureDate datetime,
read_per_ms float,
write_per_ms float,
num_of_bytes_written bigint,
num_of_reads bigint,
num_of_writes bigint,
database_id int,
file_id int
)

/* Get baseline snapshot of stalls */
INSERT INTO #IOStallSnapshot (CaptureDate,
read_per_ms,
write_per_ms,
num_of_bytes_written,
num_of_reads,
num_of_writes,
database_id,
[file_id])
SELECT getdate(),
a.io_stall_read_ms,
a.io_stall_write_ms,
a.num_of_bytes_written,
a.num_of_reads,
a.num_of_writes,
a.database_id,
a.file_id
FROM sys.dm_io_virtual_file_stats (NULL, NULL) a
JOIN sys.master_files b ON a.file_id = b.file_id
AND a.database_id = b.database_id

/* Wait a few minutes and get final snapshot */
WAITFOR DELAY @WaitTimeSec

INSERT INTO #IOStallResult (CaptureDate,
read_per_ms,
write_per_ms,
num_of_bytes_written,
num_of_reads,
num_of_writes,
database_id,
[file_id])
SELECT getdate(),
a.io_stall_read_ms,
a.io_stall_write_ms,
a.num_of_bytes_written,
a.num_of_reads,
a.num_of_writes,
a.database_id,
a.[file_id]
FROM sys.dm_io_virtual_file_stats (NULL, NULL) a
JOIN sys.master_files b ON a.[file_id] = b.[file_id]
AND a.database_id = b.database_id

/* Get differences between captures */
SELECT
inline.CaptureDate
,CASE WHEN inline.num_of_reads =0 THEN 0
ELSE inline.io_stall_read_ms / inline.num_of_reads END AS read_per_ms
,CASE WHEN inline.num_of_writes = 0 THEN 0
ELSE inline.io_stall_write_ms / inline.num_of_writes END AS write_per_ms
,inline.io_stall_read_ms
,inline.io_stall_write_ms
,inline.num_of_reads
,inline.num_of_writes
,inline.num_of_bytes_written
,inline.database_id
,inline.[file_id]
FROM (
SELECT r.CaptureDate
,r.read_per_ms - s.read_per_ms AS io_stall_read_ms
,r.num_of_reads - s.num_of_reads AS num_of_reads
,r.write_per_ms - s.write_per_ms AS io_stall_write_ms
,r.num_of_writes - s.num_of_writes AS num_of_writes
,r.num_of_bytes_written - s.num_of_bytes_written AS num_of_bytes_written
,r.database_id AS database_id
,r.[file_id] AS [file_id]

FROM #IOStallSnapshot s
JOIN #IOStallResult r
ON (s.database_id = r.database_id and s.[file_id] = r.[file_id])
) inline



/* If temp tables exist drop them. */
IF OBJECT_ID('tempdb..#IOStallSnapshot') IS NOT NULL
BEGIN
DROP TABLE #IOStallSnapshot
END

IF OBJECT_ID('tempdb..#IOStallResult') IS NOT NULL
BEGIN
DROP TABLE #IOStallResult
END


