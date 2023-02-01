-- Check for Blocking

SELECT database_name = DB_NAME(tl.resource_database_id)
	, tl.resource_type
	, assoc_entity_id = tl.resource_associated_entity_id
	, lock_req = tl.request_mode
	, waiter_sid = tl.request_session_id
	, wait_duration = wt.wait_duration_ms
	, wt.wait_type
	, waiter_batch = wait_st.TEXT
	, waiter_stmt = substring(wait_st.TEXT, er.statement_start_offset / 2 + 1, abs(CASE 
				WHEN er.statement_end_offset = - 1
					THEN len(convert(NVARCHAR(max), wait_st.TEXT)) * 2
				ELSE er.statement_end_offset
				END - er.statement_start_offset) / 2 + 1)
	, waiter_host = es.host_name
	, waiter_user = es.login_name
	, blocker_sid = wt.blocking_session_id
	, blocker_stmt = block_st.TEXT
	, blocker_host = block_es.host_name
	, blocker_user = block_es.login_name
FROM sys.dm_tran_locks tl(NOLOCK)
INNER JOIN sys.dm_os_waiting_tasks wt(NOLOCK)
	ON tl.lock_owner_address = wt.resource_address
INNER JOIN sys.dm_os_tasks ot(NOLOCK)
	ON tl.request_session_id = ot.session_id AND tl.request_request_id = ot.request_id AND tl.request_exec_context_id = ot.exec_context_id
INNER JOIN sys.dm_exec_requests er(NOLOCK)
	ON tl.request_session_id = er.session_id AND tl.request_request_id = er.request_id
INNER JOIN sys.dm_exec_sessions es(NOLOCK)
	ON tl.request_session_id = es.session_id
LEFT JOIN sys.dm_exec_requests block_er(NOLOCK)
	ON wt.blocking_session_id = block_er.session_id
LEFT JOIN sys.dm_exec_sessions block_es(NOLOCK)
	ON wt.blocking_session_id = block_es.session_id
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) wait_st
OUTER APPLY sys.dm_exec_sql_text(block_er.sql_handle) block_st
