-- List Who Created Temporary Table

SELECT DISTINCT te.NAME
	, t.NAME
	, t.create_date
	, SPID
	, SessionLoginName
FROM::fn_trace_gettable((
			SELECT LEFT(path, LEN(path) - CHARINDEX('\', REVERSE(path))) + '\Log.trc'
			FROM sys.traces -- read all five trace files
			WHERE is_default = 1
			), DEFAULT) trace
INNER JOIN sys.trace_events te
	ON trace.EventClass = te.trace_event_id
INNER JOIN TempDB.sys.tables AS t
	ON trace.ObjectID = t.OBJECT_ID
WHERE trace.DatabaseName = 'TempDB'
	AND t.NAME LIKE '#%'
	AND te.NAME = 'Object:Created'
	AND DATEPART(dy, t.create_date) = DATEPART(Dy, trace.StartTime)
	AND ABS(DATEDIFF(Ms, t.create_date, trace.StartTime)) < 50 --sometimes slightly out
ORDER BY t.create_date
