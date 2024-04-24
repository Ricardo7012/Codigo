--SELECT traceid, value FROM [fn_trace_getinfo](NULL)

SELECT TOP 100
    TE.name AS [EventName],
    T.DatabaseName,
    T.DatabaseID,
    T.NTDomainName,
    T.ApplicationName,
    T.LoginName,
    T.SPID,
    T.Duration,
    T.StartTime,
    T.EndTime
--FROM sys.fn_trace_gettable('E:\System\MSSQL13.SQL1\MSSQL\Log\log_129.trc', DEFAULT) T
--    JOIN sys.trace_events TE
--        ON T.EventClass = TE.trace_event_id
FROM sys.fn_trace_gettable(CONVERT(   VARCHAR(150),
                           (
                               SELECT TOP 1
                                   f.[value]
                               FROM sys.fn_trace_getinfo(NULL) f
                               WHERE f.property = 2
                           )
                                  ),
                           DEFAULT
                          ) T
    JOIN sys.trace_events TE
        ON T.EventClass = TE.trace_event_id
WHERE
    -- Database Events
    TE.name IN ( 'Data File Auto Grow', 'Data File Auto Shrink', 'Log File Auto Grow', 'Log File Auto Shrink' )
    -- Errors and Warnings Events
    --OR TE.name IN ( 'Errorlog', 'Hash warning', 'Missing Column STATISTICS', 'Missing Join Predicate', 'Sort Warning' )
ORDER BY T.StartTime;


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
SELECT EventClass, CASE EventClass
           WHEN 46 THEN
               'Object:Created'
           WHEN 47 THEN
               'Object:Deleted'
           WHEN 164 THEN
               'Object:Altered'
       END AS EventClassDesc,
       DatabaseName,
       ObjectName,
       HostName,
       ApplicationName,
       LoginName,
       StartTime
FROM::fn_trace_gettable(@start, DEFAULT)
WHERE EventClass IN ( 46, 47, 164 )
      AND EventSubclass = 0
      AND DatabaseID <> 2
      AND ObjectName NOT LIKE '_WA_Sys%'
	  AND NTUserName <> 'SQLTELEMETRY'
	  --AND databasename = ''
ORDER BY StartTime DESC;


-- Most recently manipulated objects
SELECT TE.name,
       v.subclass_name,
       DB_NAME(T.DatabaseID) AS DBName,
       T.NTDomainName,
       T.NTUserName,
       T.HostName,
       T.ApplicationName,
       T.LoginName,
       T.Duration,
       T.StartTime,
       T.ObjectName,
       CASE T.ObjectType
           WHEN 8259 THEN
               'Check Constraint'
           WHEN 8260 THEN
               'Default (constraint or standalone)'
           WHEN 8262 THEN
               'Foreign-key Constraint'
           WHEN 8272 THEN
               'Stored Procedure'
           WHEN 8274 THEN
               'Rule'
           WHEN 8275 THEN
               'System Table'
           WHEN 8276 THEN
               'Trigger on Server'
           WHEN 8277 THEN
               '(User-defined) Table'
           WHEN 8278 THEN
               'View'
           WHEN 8280 THEN
               'Extended Stored Procedure'
           WHEN 16724 THEN
               'CLR Trigger'
           WHEN 16964 THEN
               'Database'
           WHEN 16975 THEN
               'Object'
           WHEN 17222 THEN
               'FullText Catalog'
           WHEN 17232 THEN
               'CLR Stored Procedure'
           WHEN 17235 THEN
               'Schema'
           WHEN 17475 THEN
               'Credential'
           WHEN 17491 THEN
               'DDL Event'
           WHEN 17741 THEN
               'Management Event'
           WHEN 17747 THEN
               'Security Event'
           WHEN 17749 THEN
               'User Event'
           WHEN 17985 THEN
               'CLR Aggregate Function'
           WHEN 17993 THEN
               'Inline Table-valued SQL Function'
           WHEN 18000 THEN
               'Partition Function'
           WHEN 18002 THEN
               'Replication Filter Procedure'
           WHEN 18004 THEN
               'Table-valued SQL Function'
           WHEN 18259 THEN
               'Server Role'
           WHEN 18263 THEN
               'Microsoft Windows Group'
           WHEN 19265 THEN
               'Asymmetric Key'
           WHEN 19277 THEN
               'Master Key'
           WHEN 19280 THEN
               'Primary Key'
           WHEN 19283 THEN
               'ObfusKey'
           WHEN 19521 THEN
               'Asymmetric Key Login'
           WHEN 19523 THEN
               'Certificate Login'
           WHEN 19538 THEN
               'Role'
           WHEN 19539 THEN
               'SQL Login'
           WHEN 19543 THEN
               'Windows Login'
           WHEN 20034 THEN
               'Remote Service Binding'
           WHEN 20036 THEN
               'Event Notification on Database'
           WHEN 20037 THEN
               'Event Notification'
           WHEN 20038 THEN
               'Scalar SQL Function'
           WHEN 20047 THEN
               'Event Notification on Object'
           WHEN 20051 THEN
               'Synonym'
           WHEN 20549 THEN
               'End Point'
           WHEN 20801 THEN
               'Adhoc Queries which may be cached'
           WHEN 20816 THEN
               'Prepared Queries which may be cached'
           WHEN 20819 THEN
               'Service Broker Service Queue'
           WHEN 20821 THEN
               'Unique Constraint'
           WHEN 21057 THEN
               'Application Role'
           WHEN 21059 THEN
               'Certificate'
           WHEN 21075 THEN
               'Server'
           WHEN 21076 THEN
               'Transact-SQL Trigger'
           WHEN 21313 THEN
               'Assembly'
           WHEN 21318 THEN
               'CLR Scalar Function'
           WHEN 21321 THEN
               'Inline scalar SQL Function'
           WHEN 21328 THEN
               'Partition Scheme'
           WHEN 21333 THEN
               'User'
           WHEN 21571 THEN
               'Service Broker Service Contract'
           WHEN 21572 THEN
               'Trigger on Database'
           WHEN 21574 THEN
               'CLR Table-valued Function'
           WHEN 21577 THEN
               'Internal Table (For example, XML Node Table, Queue Table.)'
           WHEN 21581 THEN
               'Service Broker Message Type'
           WHEN 21586 THEN
               'Service Broker Route'
           WHEN 21587 THEN
               'Statistics'
           WHEN 21825 THEN
               'User'
           WHEN 21827 THEN
               'User'
           WHEN 21831 THEN
               'User'
           WHEN 21843 THEN
               'User'
           WHEN 21847 THEN
               'User'
           WHEN 22099 THEN
               'Service Broker Service'
           WHEN 22601 THEN
               'Index'
           WHEN 22604 THEN
               'Certificate Login'
           WHEN 22611 THEN
               'XMLSchema'
           WHEN 22868 THEN
               'Type'
           ELSE
               'Hmmm???'
       END AS ObjectType
FROM [fn_trace_gettable](CONVERT(   VARCHAR(150),
                         (
                             SELECT TOP 1 value FROM [fn_trace_getinfo](NULL) WHERE [property] = 2
                         )
                                ),
                         DEFAULT
                        ) T
    JOIN sys.trace_events TE
        ON T.EventClass = TE.trace_event_id
    JOIN sys.trace_subclass_values v
        ON v.trace_event_id = TE.trace_event_id
           AND v.subclass_value = T.EventSubClass
WHERE TE.name IN ( 'Object:Created', 'Object:Deleted', 'Object:Altered' )
	  AND NTUserName <> 'SQLTELEMETRY'
	  -- filter statistics created by SQL server
      AND T.ObjectType NOT IN ( 21587 )
      -- filter tempdb objects
      AND DatabaseID <> 2
      -- get only events in the past 24 hours
      AND StartTime > DATEADD(HH, -24, GETDATE())
ORDER BY T.StartTime DESC;


-- Security Events 
SELECT  TE.name AS [EventName] ,
        v.subclass_name ,
        T.DatabaseName ,
        t.DatabaseID ,
        t.NTDomainName ,
        t.ApplicationName ,
        t.LoginName ,
        t.SPID ,
        t.StartTime ,
        t.RoleName ,
        t.TargetUserName ,
        t.TargetLoginName ,
        t.SessionLoginName
FROM    sys.fn_trace_gettable(CONVERT(VARCHAR(150), ( SELECT TOP 1
                                                              f.[value]
                                                      FROM    sys.fn_trace_getinfo(NULL) f
                                                      WHERE   f.property = 2
                                                    )), DEFAULT) T
        JOIN sys.trace_events TE ON T.EventClass = TE.trace_event_id
        JOIN sys.trace_subclass_values v ON v.trace_event_id = TE.trace_event_id
                                            AND v.subclass_value = t.EventSubClass
WHERE   te.name IN ( 'Audit Addlogin Event', 'Audit Add DB User Event',
                     'Audit Add Member to DB Role Event' )
        AND (
			v.subclass_name IN ( 'add', 'Grant database access' )
			OR v.subclass_name IN ( 'Drop', 'Revoke database access' )
			)
		--te.name IN ( 'Audit Login Failed' )
		--te.name IN ( 'Audit Server Starts and Stops' )
		--te.name IN ( 'Server Memory Change' )

/*
Event_ID	Event_Desc
18	Audit Server Starts And Stops
20	Audit Login Failed
22	ErrorLog
46	Object:Created
47	Object:Deleted
55	Hash Warning
69	Sort Warnings
79	Missing Column Statistics
80	Missing Join Predicate
81	Server Memory Change
92	Data File Auto Grow
93	Log File Auto Grow
94	Data File Auto Shrink
95	Log File Auto Shrink
102	Audit Database Scope GDR Event
103	Audit Schema Object GDR Event
104	Audit Addlogin Event
105	Audit Login GDR Event
106	Audit Login Change Property Event
108	Audit Add Login to Server Role Event
109	Audit Add DB User Event
110	Audit Add Member to DB Role Event
111	Audit Add Role Event
115	Audit Backup/Restore Event
116	Audit DBCC Event
117	Audit Change Audit Event
152	Audit Change Database Owner
153	Audit Schema Object Take Ownership Event
155	FT:Crawl Started
156	FT:Crawl Stopped
164	Object:Altered
167	Database Mirroring State Change
175	Audit Server Alter Trace Event
218	Plan Guide Unsuccessful
*/