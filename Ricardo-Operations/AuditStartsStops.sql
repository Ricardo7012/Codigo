SELECT TE.name      AS [EventName]
     , @@ServerName AS VM
     , v.subclass_name
     , T.DatabaseName
     , T.DatabaseID
     , T.NTDomainName
     , T.ApplicationName
     , T.LoginName
     , T.SPID
     , T.StartTime
     , T.SessionLoginName
FROM sys.fn_trace_gettable(CONVERT(VARCHAR(150)
                                 , (
                                       SELECT TOP 1
                                              f.[value]
                                       FROM sys.fn_trace_getinfo(NULL) f
                                       WHERE f.property = 2
                                   )
                                  )
                         , 4
                          )        T -- 4 is the default number of trace log files
    JOIN sys.trace_events          TE
        ON T.EventClass = TE.trace_event_id
    JOIN sys.trace_subclass_values v
        ON v.trace_event_id = TE.trace_event_id
           AND v.subclass_value = T.EventSubClass
WHERE TE.name IN ( 'Audit Server Starts and Stops' );
