-- List Blocking Two

SELECT 'SPID' = er.session_id
	, ot.Threads AS 'Thread'
	, 'Running Threads' = coalesce(rsp.RunningThreads, 0)
	, 'Pct Comp' = er.percent_complete
	, 'Est Comp Time' = CASE er.estimated_completion_time
		WHEN 0
			THEN NULL
		ELSE dateadd(ms, er.estimated_completion_time, getdate())
		END
	, 'Status' = er.STATUS
	, 'Cmd' = er.command
	, 'DB Name' = sd.NAME
	, 'Blocked By' = wt.blocking_session_id
	, 'Head Blocker' = coalesce(hb5.session_id, hb4.session_id, hb3.session_id, hb2.session_id, hb1.session_id)
	, 'Wait Type' = coalesce(CASE er.wait_type
			WHEN 'CXPACKET'
				THEN 'CXPACKET - ' + sp.lastwaittype1
			ELSE sp.lastwaittype1
			END, lower(er.last_wait_type)) --Lowercase denotes it's not currently waiting, also noted by a wait time of 0.
	, 'Wait Time Sec' = Cast(er.wait_time / 1000.0 AS DECIMAL(20, 3))
	, 'Wait Resource' = er.wait_resource
	, 'Duration Sec' = Cast(DATEDIFF(s, er.start_time, GETDATE()) AS DECIMAL(20, 0))
	, 'CPU Sec' = Cast(er.cpu_time / 1000.0 AS DECIMAL(20, 3))
	, 'Reads K' = Cast(er.reads / 1000.0 AS DECIMAL(20, 3))
	, 'Writes K' = Cast(er.writes / 1000.0 AS DECIMAL(20, 3))
	, 'Statement' = SUBSTRING(st.TEXT, er.statement_start_offset / 2, abs(CASE 
				WHEN er.statement_end_offset = - 1
					THEN LEN(CONVERT(NVARCHAR(MAX), st.TEXT)) * 2
				ELSE er.statement_end_offset
				END - er.statement_start_offset) / 2)
	, 'Query' = st.TEXT
	, 'Login Time' = es.login_time
	, 'Host Name' = es.host_name
	, 'Program Name' = CASE LEFT(es.program_name, 29)
		WHEN 'SQLAgent - TSQL JobStep (Job '
			THEN 'SQLAgent Job: ' + (
					SELECT NAME
					FROM msdb..sysjobs sj
					WHERE substring(es.program_name, 32, 32) = (substring(sys.fn_varbintohexstr(sj.job_id), 3, 100))
					) + ' - ' + SUBSTRING(es.program_name, 67, len(es.program_name) - 67)
		ELSE es.program_name
		END
	, 'Client Interface Name' = es.client_interface_name
	, 'Login Name' = es.login_name
	, 'Status' = es.STATUS
	, 'Total Scheduled Time' = es.total_scheduled_time
	, 'Total Elapsed Time' = es.total_elapsed_time
	, 'Start Time' = er.start_time
	, 'Last Req Start Time' = es.last_request_start_time
	, 'Last Req End Time' = es.last_request_end_time
	, 'DB ID' = er.database_id
--, qp.query_plan 
FROM sys.dm_exec_requests er
INNER JOIN sys.dm_exec_Sessions es
	ON er.session_id = es.session_id
LEFT JOIN sys.databases sd
	ON er.database_id = sd.database_id
INNER JOIN (
	SELECT session_id
		, count(1) Threads
	FROM sys.dm_os_tasks
	GROUP BY session_id
	) ot
	ON er.session_id = ot.session_id
LEFT JOIN (
	SELECT spid
		, LastWaitType1 = MIN(lastwaittype)
		, LastWaitType2 = MAX(lastwaittype)
	FROM sysprocesses sp
	WHERE waittime > 0
		AND lastwaittype <> 'cxpacket'
	GROUP BY spid
	) sp
	ON er.session_id = sp.spid
LEFT JOIN (
	SELECT spid
		, RunningThreads = COUNT(1)
	FROM sysprocesses sp
	WHERE waittime = 0
	GROUP BY spid
	) rsp
	ON er.session_id = rsp.spid
LEFT JOIN (
	SELECT session_id
		, max(blocking_session_id) blocking_session_id
	FROM sys.dm_os_waiting_tasks wt
	WHERE wt.blocking_session_id <> wt.session_id
	GROUP BY session_id
	) wt
	ON er.session_id = wt.session_id
LEFT JOIN (
	SELECT session_id
		, max(blocking_session_id) blocking_session_id
	FROM sys.dm_os_waiting_tasks wt
	GROUP BY session_id
	) hb1
	ON wt.blocking_session_id = hb1.session_id
LEFT JOIN (
	SELECT session_id
		, max(blocking_session_id) blocking_session_id
	FROM sys.dm_os_waiting_tasks wt
	GROUP BY session_id
	) hb2
	ON hb1.blocking_session_id = hb2.session_id
LEFT JOIN (
	SELECT session_id
		, max(blocking_session_id) blocking_session_id
	FROM sys.dm_os_waiting_tasks wt
	GROUP BY session_id
	) hb3
	ON hb2.blocking_session_id = hb3.session_id
LEFT JOIN (
	SELECT session_id
		, max(blocking_session_id) blocking_session_id
	FROM sys.dm_os_waiting_tasks wt
	GROUP BY session_id
	) hb4
	ON hb3.blocking_session_id = hb4.session_id
LEFT JOIN (
	SELECT session_id
		, max(blocking_session_id) blocking_session_id
	FROM sys.dm_os_waiting_tasks wt
	GROUP BY session_id
	) hb5
	ON hb4.blocking_session_id = hb5.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS st
--CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) qp
WHERE er.session_id <> @@SPID
--AND es.host_name like '%%'
--AND er.session_id = 2702
ORDER BY er.percent_complete DESC
	, er.cpu_time DESC
	, er.session_id
	--Use the below command to get the last input of an open session id
	--dbcc inputbuffer(61)
