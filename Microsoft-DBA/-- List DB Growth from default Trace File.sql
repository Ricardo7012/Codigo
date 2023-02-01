-- List DB Growth from default Trace File

DECLARE @path NVARCHAR(260)

SELECT @path = REVERSE(SUBSTRING(REVERSE([path]), CHARINDEX('\', REVERSE([path])), 260)) + N'log.trc'
FROM sys.traces
WHERE is_default = 1

SELECT DatabaseName AS 'Database Name'
	, FileName AS 'File Name'
	, SPID AS 'SPID'
	, Duration AS 'Duration'
	, StartTime AS 'Start Time'
	, EndTime AS 'End Time'
	, CASE EventClass
		WHEN 92
			THEN 'Data'
		WHEN 93
			THEN 'Log'
		END AS 'File Type'
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (
		92
		, 93
		)
ORDER BY StartTime DESC
