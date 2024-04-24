SET NOCOUNT ON

IF EXISTS (SELECT * FROM sys.sysprocesses p1 JOIN sys.sysprocesses p2 ON (p1.spid=p2.blocked))
BEGIN---

       DECLARE @spid int

       SELECT @spid=p1.spid  -- Get the _last_ prime offender
       FROM sys.sysprocesses p1 JOIN sys.sysprocesses p2 ON (p1.spid=p2.blocked)
       WHERE p1.blocked=0 AND (p1.STATUS = 'sleeping' or p1.status = 'suspended' 
                     or p1.status = 'runnable' or p1.status = 'running')

       SELECT 
              'HeadBlocker' AS QueryType,
              p1.spid, p1.blocked,
              hostname=substring(p1.hostname,1,20), 
              p1.status,
              loginame=LEFT(p1.loginame,20),
              blk=CONVERT(char(3),p1.blocked),
              db=LEFT(db_name(p1.dbid),32),
              p1.cmd,
              p1.waittype,
              p1.waittime,
              p1.[program_name], p1.hostprocess, p1.open_tran, p1.[dbid],
              p1.cpu, p1.physical_io, p1.memusage, p1.login_time, p1.last_batch
       FROM sys.sysprocesses p1
              JOIN sys.sysprocesses p2 ON (p1.spid=p2.blocked)
       WHERE (p1.blocked=0 OR p1.blocked = p1.spid) AND (p1.STATUS = 'sleeping' OR p1.status = 'suspended'
                     or p1.status = 'runnable' or p1.status = 'running')
       ORDER BY p1.last_batch ASC

       SELECT 
              'HeadBlocker Chain' AS QueryType,
              p1.spid, p1.blocked,
              hostname=substring(p1.hostname,1,20), 
              --w.Description AS CV3Workstation, /*QUEST Workstation Info, comment out if for other system*/
              p1.status,
              loginame=LEFT(p1.loginame,20),
              blk=CONVERT(char(3),p1.blocked),
              db=LEFT(db_name(p1.dbid),32),
              p1.cmd,
              p1.waittype,
              p1.waittime,
              p1.[program_name], p1.hostprocess, p1.open_tran, p1.[dbid],
              p1.cpu, p1.physical_io, p1.memusage, p1.login_time, p1.last_batch
       FROM sys.sysprocesses p1
              JOIN sys.sysprocesses p2 ON (p1.spid=p2.blocked)
       WHERE p1.blocked=0
       ORDER BY p1.last_batch ASC

       /*SELECT RootBlockerSPID=@spid  -- Return the last root blocker*/

END 
ELSE 
BEGIN
       SELECT CurrentTime=GETDATE(), [Status]='No processes are currently blocking others.'
END

SELECT 'Blocking' AS QueryType, spid, hostname, blocked, cmd, waittime, waittype, waitresource, lastwaittype,
       loginame, [program_name], hostprocess, [STATUS], open_tran, [dbid],
       cpu, physical_io, memusage, login_time, last_batch
FROM sys.sysprocesses
WHERE blocked <> 0
ORDER BY last_batch ASC

/* Open transactions with text and plans */
SELECT
       'OpenTran' AS QueryType,
    [st].[session_id],
       [dt].[database_transaction_begin_time] AS [Begin Time],
       DATEDIFF(SECOND, [dt].[database_transaction_begin_time], GETDATE()) AS [Lapse Time Sec],
    [es].[host_name],
    [es].[login_name] AS [Login Name],
    DB_NAME (dt.database_id) AS [Database],
    [dt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [dt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [est].text AS [Last T-SQL Text],
    [qp].[query_plan] AS [Last Plan]
FROM 
sys.dm_tran_database_transactions [dt]
JOIN sys.dm_tran_session_transactions [st] ON [st].[transaction_id] = [dt].[transaction_id]
JOIN sys.[dm_exec_sessions] [es] ON [es].[session_id] = [st].[session_id]
JOIN sys.dm_exec_connections [ec] ON [ec].[session_id] = [st].[session_id]
LEFT OUTER JOIN sys.dm_exec_requests [er] ON [er].[session_id] = [st].[session_id]
CROSS APPLY sys.dm_exec_sql_text ([ec].[most_recent_sql_handle]) AS [est]
OUTER APPLY sys.dm_exec_query_plan ([er].[plan_handle]) AS [qp]
WHERE 
       dt.database_id = DB_ID('PROD') AND
       --es.login_name NOT IN ('b89b13a8_EDI')
       [est].text NOT LIKE '%BEGIN CONVERSATION TIMER%'
ORDER BY [Begin Time] ASC

SELECT
       'CurrentActivity' AS QueryType,
    er.session_Id,er.start_time, 
       [User] = sp.nt_username, sp.Hostname, 
       er.cpu_time, --er.total_elapsed_time, 
       (
       CASE 
              WHEN CONVERT(VARCHAR(10),(GETDATE() - er.start_time),108) = '23:59:59' THEN '00:00:00'
              ELSE CONVERT(VARCHAR(10),(GETDATE() - er.start_time),108)
        END
       ) + ' ( >= ' + CONVERT(VARCHAR(4), DATEDIFF(HOUR, er.start_time, GETDATE())) + ' hrs)' AS Duration, 
       [DatabaseName] = DB_NAME(sp.dbid), 
       [Status] = er.status, [WaitType] = er.wait_type,
       er.logical_reads,
       CASE 
              WHEN er.transaction_isolation_level = 0 THEN 'Unspecified'
              WHEN er.transaction_isolation_level = 1 THEN 'ReadUncomitted'
              WHEN er.transaction_isolation_level = 2 THEN 'ReadCommitted'
              WHEN er.transaction_isolation_level = 3 THEN 'Repeatable'
              WHEN er.transaction_isolation_level = 4 THEN 'Serializable'
              WHEN er.transaction_isolation_level = 5 THEN 'Snapshot'
       ELSE NULL
       END AS tran_isolation_level,
    [QueryText] = SUBSTRING (qt.text, er.statement_start_offset/2, 
                                  (CASE WHEN er.statement_end_offset = -1
                     THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                  ELSE er.statement_end_offset END - er.statement_start_offset)/2),
    [Parent Query] = qt.text, [Program] = sp.[program_name],
       er.percent_complete, er.reads, er.writes, 
       er.row_count,
       sp.kpid, 
       Protocol = con.net_transport,
       ConnectionWrites = con.num_writes,
       ConnectionReads = con.num_reads,
       ClientAddress = con.client_net_address,
       [Authentication] = con.auth_scheme
       --,wt.wait_duration_ms, wt.wait_type, wt.resource_address,
       --wt.blocking_session_id,
       --wt.resource_description 
FROM sys.dm_exec_requests AS er
INNER JOIN sys.sysprocesses AS sp ON er.session_id = sp.spid
LEFT JOIN sys.dm_exec_sessions AS ses ON ses.session_id = er.session_id
LEFT JOIN sys.dm_exec_connections AS con ON con.session_id = ses.session_id
--INNER JOIN sys.dm_os_waiting_tasks AS wt ON er.session_id = wt.session_id
--CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt
CROSS APPLY sys.dm_exec_sql_text(con.most_recent_sql_handle) AS qt
WHERE er.session_id <> @@SPID
       AND (er.wait_type NOT IN ('BROKER_RECEIVE_WAITFOR', 'WAITFOR') OR er.wait_type IS NULL)
       --AND blocked <> 0
ORDER BY er.total_elapsed_time DESC ;


DECLARE @spid INT
DECLARE @db VARCHAR(32)

SET NOCOUNT ON

SET @db = ''  -- Leave blank if you want to see all opentran on all DBs

SELECT dd.database_id AS [DBID], DB_NAME(dd.database_id) AS [DBNAME],
           dd.transaction_id,
       ds.session_id,
       database_transaction_begin_time,
       CASE database_transaction_type
         WHEN 1 THEN 'Read/write transaction'
         WHEN 2 THEN 'Read-only transaction'
         WHEN 3 THEN 'System transaction'
       END database_transaction_type,
       CASE database_transaction_state
         WHEN 1 THEN 'The transaction has not been initialized.'
         WHEN 3 THEN 'The transaction has been initialized but has not generated any log records.'
         WHEN 4 THEN 'The transaction has generated log records.'
        WHEN 5 THEN 'The transaction has been prepared.'
         WHEN 10 THEN 'The transaction has been committed.'
         WHEN 11 THEN 'The transaction has been rolled back.'
         WHEN 12 THEN 'The transaction is being committed. In this state the log record is being generated, but it has not been materialized or persisted'
       END database_transaction_state,
       database_transaction_log_bytes_used,
       database_transaction_log_bytes_reserved,
       database_transaction_begin_lsn,
       database_transaction_last_lsn
FROM   sys.dm_tran_database_transactions dd
       INNER JOIN sys.dm_tran_session_transactions ds
           ON ds.transaction_id = dd.transaction_id
WHERE
        dd.database_id = ISNULL(DB_ID(@db), dd.database_id)
        AND database_transaction_begin_time IS NOT NULL
ORDER BY database_transaction_begin_time ASC

SELECT TOP 1 @spid = ds.session_id
        FROM   sys.dm_tran_database_transactions dd
                  INNER JOIN sys.dm_tran_session_transactions ds
                          ON ds.transaction_id = dd.transaction_id
        WHERE
               dd.database_id = ISNULL(DB_ID(@db), dd.database_id)
               AND database_transaction_begin_time IS NOT NULL
        ORDER BY database_transaction_begin_time ASC

DBCC INPUTBUFFER(@spid)

EXEC SP_WHO2 @spid

