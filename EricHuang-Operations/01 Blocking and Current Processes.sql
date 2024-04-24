SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
/*
	SELECT hostname, cmd, spi, blocked,	waittime, waittype, waitresource, lastwaittype,
	loginame, [program_name], hostprocess, [STATUS], open_tran, [dbid],
	cpu, physical_io, memusage, login_time, last_batch	
FROM sys.sysprocesses
WHERE spid in (select spid from sys.sysprocesses where blocked <> 0)
	AND blocked = 0
	--AND cmd = 'AWAITING COMMAND'
ORDER BY last_batch ASC
*/

SET NOCOUNT ON


SELECT @@SERVERNAME AS SQLInstance, GETDATE() AS CurrentDateTime, @@VERSION AS VersionInfo, 
	'Blocking and Current Activities' AS ReportingCategory



IF EXISTS (SELECT * FROM sys.sysprocesses p1 JOIN sys.sysprocesses p2 ON (p1.spid=p2.blocked))
BEGIN

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
	and spid <> blocked
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
    [qp].[query_plan] AS [Last Plan],
	ec.net_packet_size
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





-- SELECT @@SERVERNAME AS SQLInstance, GETDATE() AS CurrentDateTime, @@VERSION AS VersionInfo, 'Blocking and Current Activities' AS ReportingCategory

SELECT
	'CurrentActivity' AS QueryType, 
	er.percent_complete as pcnt_cmpl, 
	er.session_Id,er.blocking_session_id as blockedby, 
	er.start_time, 
		DATEADD(SECOND, estimated_completion_time / 1000, GETDATE()) AS estimated_completion_time,
	CASE
		WHEN COALESCE(sp.nt_username, '') = '' THEN sp.loginame
		ELSE sp.nt_username
	END AS [User], 
	--tm.Team_Member_Name, 
	sp.Hostname, 
	er.cpu_time, 
	sp.cpu,
	--er.total_elapsed_time, 
	[WaitType] = er.wait_type, er.wait_resource,
	(
	CASE 
		WHEN CONVERT(VARCHAR(10),(GETDATE() - er.start_time),108) = '23:59:59' THEN '00:00:00'
		ELSE CONVERT(VARCHAR(10),(GETDATE() - er.start_time),108)
		END
	) + ' ( >= ' + CONVERT(VARCHAR(4), DATEDIFF(HOUR, er.start_time, GETDATE())) + ' hrs)' AS Duration, 
		[DatabaseName] = DB_NAME(sp.dbid), 
	[QueryText] = SUBSTRING (qt.text, er.statement_start_offset/2, 
					(CASE WHEN er.statement_end_offset = -1
						THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
					ELSE er.statement_end_offset END - er.statement_start_offset)/2),
	[Parent Query] = qt.text,
       
	[Program] = sp.[program_name], er.logical_reads, er.reads, 
	con.net_packet_size,
	[Status] = er.status, --[WaitType] = er.wait_type, er.wait_resource,
	OpenTrans=er.open_transaction_count,
	t.[name] AS ImplicitTransactions,  --Outputs:  user_transaction, implicit_transaction
	CASE 
		WHEN er.transaction_isolation_level = 0 THEN 'Unspecified'
		WHEN er.transaction_isolation_level = 1 THEN 'ReadUncomitted'
		WHEN er.transaction_isolation_level = 2 THEN 'ReadCommitted'
		WHEN er.transaction_isolation_level = 3 THEN 'Repeatable'
		WHEN er.transaction_isolation_level = 4 THEN 'Serializable'
		WHEN er.transaction_isolation_level = 5 THEN 'Snapshot'
	ELSE NULL
	END AS tran_isolation_level,
	er.writes, 
	er.row_count,
	sp.kpid, 
	Protocol = con.net_transport,
	ConnectionWrites = con.num_writes,
	ConnectionReads = con.num_reads,
	ClientAddress = con.client_net_address,
	[Authentication] = con.auth_scheme
	, er.sql_handle, er.statement_sql_handle,
	er.statement_start_offset, er.statement_end_offset
	--er.estimated_completion_time
	--,wt.wait_duration_ms, wt.wait_type, wt.resource_address,
	--wt.blocking_session_id,
	--wt.resource_description 
FROM sys.dm_exec_requests AS er
INNER JOIN sys.sysprocesses AS sp ON er.session_id = sp.spid
LEFT JOIN sys.dm_exec_sessions AS ses ON ses.session_id = er.session_id
LEFT JOIN sys.dm_exec_connections AS con ON con.session_id = ses.session_id
LEFT JOIN sys.dm_tran_session_transactions s ON er.session_id = s.session_id
LEFT JOIN sys.dm_tran_active_transactions t ON s.transaction_id = t.transaction_id
--INNER JOIN sys.dm_os_waiting_tasks AS wt ON er.session_id = wt.session_id
--CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt
CROSS APPLY sys.dm_exec_sql_text(con.most_recent_sql_handle) AS qt
--LEFT OUTER JOIN EDW.dw2.DIM_Team_Member tm WITH(NOLOCK)  ON sp.nt_username = tm.Team_Member_Employee_Number
WHERE er.session_id <> @@SPID
	AND (er.wait_type NOT IN ('BROKER_RECEIVE_WAITFOR', 'WAITFOR') OR er.wait_type IS NULL)
	--AND blocked <> 0
	--and sp.[program_name] = 'HSP.Meditrac.exe'
	--and sp.hostname LIKE 'EWEB%'
	--and sp.hostname IN ('PVSQLODS01', 'IEHP-36520')
ORDER BY 
	--er.cpu_time desc; -- 
	er.total_elapsed_time DESC;



select count(1) as total_sleeping, 
	sum(cpu) as total_cpu, 
	sum(memusage) as total_memusage, 
	sum(physical_io) as total_physical_io, 
	sum(open_tran) as total_opentran,
	sum(stmt_start) as total_stmt_start,
	sum(stmt_end) as total_stmt_end
from sys.sysprocesses
where status in ('sleeping', 'dormant')


/*

SELECT --TOP 25 
	spid, hostname, status, 
	cpu, memusage, physical_io,
	open_tran, loginame, [program_name],
	waittype, waittime, waitresource,
	lastwaittype, 
	--stmt_start, stmt_end, 
	last_batch
FROM sys.sysprocesses
WHERE [status] NOT IN ('Background', 'Runable', 'Running', 'Suspended')
	--status = 'sleeping'
	--AND program_name = 'jTDS'
ORDER BY physical_io DESC;

*/

/*

SELECT 'Waits' AS QueryType,
	w.session_id, w.wait_duration_ms, w.wait_type, w.resource_address, w.blocking_session_id, 
	w.resource_description, st.text AS [SQL Text]
FROM sys.dm_os_waiting_tasks AS w
INNER JOIN sys.dm_exec_connections AS c ON w.session_id = c.session_id
CROSS APPLY (SELECT * FROM sys.dm_exec_sql_text(c.most_recent_sql_handle)) AS st 
WHERE w.session_id > 50

*/	