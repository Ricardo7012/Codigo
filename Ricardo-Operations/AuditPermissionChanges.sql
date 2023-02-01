--List all Security Audit Events
DECLARE @id INT;

SELECT @id = id
FROM   sys.traces
WHERE  is_default = 1;

SELECT DISTINCT eventid AS 'EventID' ,
       name AS 'Event Name'
FROM   fn_trace_geteventinfo(@id) GEI
       JOIN sys.trace_events TE ON GEI.eventid = TE.trace_event_id
WHERE  name LIKE '%Audit%';

DECLARE @tracefile VARCHAR(256)
SELECT @tracefile = CAST(value AS VARCHAR(256))
FROM ::fn_trace_getinfo(DEFAULT)
WHERE traceid = 1
AND property = 2 -- filename property

SELECT *
FROM ::fn_trace_gettable(@tracefile, DEFAULT) trc 
INNER JOIN sys.trace_events evt ON trc.EventClass = evt.trace_event_id
WHERE trc.EventClass IN (102, 103, 104, 105, 106, 108, 109, 110, 111)
ORDER BY trc.StartTime
