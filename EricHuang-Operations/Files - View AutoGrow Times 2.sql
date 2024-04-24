DECLARE @current_tracefilename VARCHAR(500);
DECLARE @0_tracefilename VARCHAR(500);
DECLARE @indx INT;
DECLARE @database_name SYSNAME;

SET @database_name = 'tempdb'

SELECT @current_tracefilename = path
FROM sys.traces
WHERE is_default = 1;

SET @current_tracefilename = REVERSE(@current_tracefilename);
SELECT @indx = PATINDEX('%\%', @current_tracefilename);
SET @current_tracefilename = REVERSE(@current_tracefilename);
SET @0_tracefilename = LEFT(@current_tracefilename, LEN(@current_tracefilename) - @indx) + '\log.trc';

PRINT 'Current: ' + @current_tracefilename
PRINT ''
PRINT 'Default: ' + @0_tracefilename

--OVERRIDE
--SET @current_tracefilename = 'E:\MSSQL10_50.MSSQLSERVER\MSSQL\Log\log_23581.trc'

SELECT DatabaseName
	,Filename
	,(Duration / 1000) AS 'TimeTaken(ms)'
	,StartTime
	,EndTime
	,(IntegerData * 8.0 / 1024) AS 'ChangeInSize MB'
	,ApplicationName
	,HostName
	,LoginName
FROM::fn_trace_gettable(@current_tracefilename, DEFAULT) t
	LEFT JOIN sys.databases AS d ON (d.NAME = @database_name)
WHERE EventClass >= 92
	AND EventClass <= 95
	AND ServerName = @@servername
	--AND DatabaseName = @database_name
	AND (d.create_date < EndTime)
ORDER BY t.StartTime DESC;
