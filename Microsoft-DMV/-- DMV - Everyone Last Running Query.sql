SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT c.session_id, s.host_name, s.login_name, s.status
	, st.text, s.login_time, s.program_name, *
FROM sys.dm_exec_connections c
INNER JOIN sys.dm_exec_sessions s ON c.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS st
ORDER BY c.session_id