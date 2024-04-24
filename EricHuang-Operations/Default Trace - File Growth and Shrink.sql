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
SELECT @@SERVERNAME as SQLServerInstance;

SELECT traceid,property, [value] FROM [fn_trace_getinfo](NULL) WHERE property = 2
	
SELECT --TOP 100
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
	AND T.StartTime > DATEADD(DAY, -1, GETDATE())
ORDER BY T.StartTime DESC;
