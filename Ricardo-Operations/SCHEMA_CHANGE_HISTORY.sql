DECLARE @d1 DATETIME;
DECLARE @diff INT;
DECLARE @curr_tracefilename VARCHAR(500);
DECLARE @base_tracefilename VARCHAR(500);
DECLARE @indx INT;
DECLARE @temp_trace TABLE
(
    obj_name NVARCHAR(256) COLLATE DATABASE_DEFAULT,
    database_name NVARCHAR(256) COLLATE DATABASE_DEFAULT,
    start_time DATETIME,
    event_class INT,
    event_subclass INT,
    object_type INT,
    server_name NVARCHAR(256) COLLATE DATABASE_DEFAULT,
    login_name NVARCHAR(256) COLLATE DATABASE_DEFAULT,
    application_name NVARCHAR(256) COLLATE DATABASE_DEFAULT,
    ddl_operation NVARCHAR(40) COLLATE DATABASE_DEFAULT
);

SELECT @curr_tracefilename = path
FROM sys.traces
WHERE is_default = 1;
SET @curr_tracefilename = REVERSE(@curr_tracefilename);
SELECT @indx = PATINDEX('%\%', @curr_tracefilename);
SET @curr_tracefilename = REVERSE(@curr_tracefilename);
SET @base_tracefilename = LEFT(@curr_tracefilename, LEN(@curr_tracefilename) - @indx) + '\log.trc';

INSERT INTO @temp_trace
SELECT ObjectName,
       DatabaseName,
       StartTime,
       EventClass,
       EventSubClass,
       ObjectType,
       ServerName,
       LoginName,
       ApplicationName,
       'temp'
FROM::fn_trace_gettable(@base_tracefilename, DEFAULT)
WHERE EventClass IN ( 46, 47, 164 )
      AND EventSubclass = 0
      AND DatabaseID <> 2;

UPDATE @temp_trace
SET ddl_operation = 'CREATE'
WHERE event_class = 46;
UPDATE @temp_trace
SET ddl_operation = 'DROP'
WHERE event_class = 47;
UPDATE @temp_trace
SET ddl_operation = 'ALTER'
WHERE event_class = 164;

SELECT @d1 = MIN(start_time)
FROM @temp_trace;
SET @diff = DATEDIFF(hh, @d1, GETDATE());
SET @diff = @diff / 24;

--SELECT @diff AS difference,
--       @d1 AS date,
--       object_type AS obj_type_desc,
--       *
--FROM @temp_trace
--WHERE --object_type NOT IN ( 21587 )
---- database_name = 'HSP_IT_SB2'
----AND login_name = 'IEHP\V2805'
----AND event_class = 46
--ORDER BY start_time DESC;

/*STORED PROCEDURES*/
--SELECT name,
--       create_date,
--       modify_date
--FROM sys.objects
--WHERE type = 'P'
--      --AND name = 'rr_GetFileDataWithAttributes'
--ORDER BY modify_date DESC;

SELECT name,
       create_date,
       modify_date
FROM sys.procedures
ORDER BY modify_date DESC;
