-- Check Completion Time on DBCC Compact File

SELECT CONVERT(NUMERIC(6, 2), r.percent_complete) AS 'Percent Complete'
	, r.start_time AS 'Start Time'
	, r.STATUS AS 'Status'
	, r.command AS 'Command'
	, CONVERT(NUMERIC(6, 2), r.estimated_completion_time / 1000.0 / 60.0) AS 'Est. Completion Time'
	, CONVERT(NUMERIC(6, 2), r.cpu_time / 1000.0 / 60.0) AS 'CPU time'
	, CONVERT(NUMERIC(6, 2), r.total_elapsed_time / 1000.0 / 60.0) AS 'Elapsed Time'
FROM sys.dm_exec_requests r
WHERE command = 'DbccFilesCompact'