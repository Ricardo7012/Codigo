/*
Property of the trace:
1= Trace options. For more information, see @options in sp_trace_create (Transact-SQL).
	2=TRACE_FILE_ROLLOVER
		Specifies that when the max_file_size is reached, the current trace file is closed 
		and a new file is created. All new records will be written to the new file. The new 
		file will have the same name as the previous file, but an integer will be appended 
		to indicate its sequence. For example, if the original trace file is named filename.trc, 
		the next trace file is named filename_1.trc, the following trace file is filename_2.trc, 
		and so on.  As more rollover trace files are created, the integer value appended to the 
		file name increases sequentially.

		SQL Server uses the default value of max_file_size (5 MB) if this option is specified 
		without specifying a value for max_file_size.
	4=SHUTDOWN_ON_ERROR
		Specifies that if the trace cannot be written to the file for whatever reason, 
		SQL Server shuts down. This option is useful when performing security audit traces.
	8=TRACE_PRODUCE_BLACKBOX
		Specifies that a record of the last 5 MB of trace information produced by the server will 
		be saved by the server. TRACE_PRODUCE_BLACKBOX is incompatible with all other options.
2 = File name
3 = Max size
4 = Stop time
5 = Current trace status. 0 = stopped. 1 = running.
*/

SET NOCOUNT ON


SELECT @@SERVERNAME AS SQLInstance, GETDATE() AS CurrentDateTime, @@VERSION AS VersionInfo, 
	'Drop Database Activities' AS ReportingCategory


SELECT traceid,property, [value] FROM [fn_trace_getinfo](NULL) WHERE property = 2
	
-- Ojbect Events
DECLARE @current VARCHAR(500);
DECLARE @start VARCHAR(500);
DECLARE @indx INT;
SELECT @current = path
FROM sys.traces
WHERE is_default = 1;
SET @current = REVERSE(@current);
SELECT @indx = PATINDEX('%\%', @current);
SET @current = REVERSE(@current);
SET @start = LEFT(@current, LEN(@current) - @indx) + '\log.trc';

-- CHNAGE FILER AS NEEDED
SELECT 
	EventClass,
	  CASE 
           WHEN EventClass = 46 THEN 'Object:Created'
           WHEN EventClass = 47 AND ObjectName IS NOT NULL THEN 'Object:Deleted'
           WHEN EventClass = 47 AND ObjectName IS NULL THEN 'Object:Dropped'
           WHEN EventClass = 164 THEN 'Object:Altered'
       END AS EventClassDesc,
       DatabaseName,
       ObjectName,
       HostName,
       ApplicationName,
       LoginName,
       StartTime
FROM::fn_trace_gettable(@start, DEFAULT)
WHERE EventClass IN (47)
      AND EventSubclass = 0
      AND DatabaseID > 4
	  AND ObjectName IS NULL
ORDER BY StartTime DESC;

