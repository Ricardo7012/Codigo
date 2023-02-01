-- Temp SPID Review

SELECT [SPID] = s.session_id
	, [Login] = s.login_name
	, [Host Name] = ISNULL(s.host_name, N'')
	, [Net Address] = ISNULL(c.client_net_address, N'')
	, [DB] = ISNULL(db_name(p.dbid), N'')
	, [Task State] = ISNULL(t.task_state, N'')
	, [Command] = ISNULL(r.command, N'')
	, [Application] = ISNULL(s.program_name, N'')
	, [Blk By] = ISNULL(CONVERT(VARCHAR, w.blocking_session_id), '')
	, [H.Blkr] = CASE 
		-- session has an active request, is blocked, but is blocking others or session is idle but has an open tran and is blocking others
		WHEN r2.session_id IS NOT NULL
			AND (
				r.blocking_session_id = 0
				OR r.session_id IS NULL
				)
			THEN '1'
				-- session is either not blocking someone, or is blocking someone but is blocked by another party
		ELSE ''
		END
	, [Active Transaction] = ISNULL(tr.transaction_id, N'')
	, [Wait Time (ms)] = ISNULL(w.wait_duration_ms, 0)
	, [Wait Type] = ISNULL(w.wait_type, N'')
	, [Wait Resource] = ISNULL(w.resource_description, N'')
	, [User Process] = CONVERT(CHAR(1), s.is_user_process)
	, [Total CPU (ms)] = s.cpu_time
	, [Total Physical I/O (MB)] = (s.reads + s.writes) * 8 / 1024
	, [Memory Use (KB)] = s.memory_usage * 8192 / 1024
	, [Login Time] = s.login_time
	, [Last Request Start Time] = s.last_request_start_time
	, [Execution Context ID] = ISNULL(t.exec_context_id, 0)
	, [Request ID] = ISNULL(r.request_id, 0)
	, [Workload Group] = ISNULL(g.NAME, N'')
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_connections c
	ON (s.session_id = c.session_id)
LEFT JOIN sys.dm_exec_requests r
	ON (s.session_id = r.session_id)
LEFT JOIN sys.dm_os_tasks t
	ON (
			r.session_id = t.session_id
			AND r.request_id = t.request_id
			)
LEFT JOIN sys.dm_tran_session_transactions tr
	ON (s.session_id = tr.session_id)
LEFT JOIN (
	-- In some cases (e.g. parallel queries, also waiting for a worker), one thread can be flagged as
	-- waiting for several different threads. This will cause that thread to show up in multiple rows
	-- in our grid, which we don't want. Use ROW_NUMBER to select the longest wait for each thread,
	-- and use it as representative of the other wait relationships this thread is involved in.
	SELECT *
		, ROW_NUMBER() OVER (
			PARTITION BY waiting_task_address ORDER BY wait_duration_ms DESC
			) AS row_num
	FROM sys.dm_os_waiting_tasks
	) w
	ON (t.task_address = w.waiting_task_address)
		AND w.row_num = 1
LEFT JOIN sys.dm_exec_requests r2
	ON (s.session_id = r2.blocking_session_id)
LEFT JOIN sys.dm_resource_governor_workload_groups g
	ON (g.group_id = s.group_id) --TAKE THIS dmv OUT TO WORK IN 2005
LEFT JOIN sys.sysprocesses p
	ON (s.session_id = p.spid)
ORDER BY s.session_id;
