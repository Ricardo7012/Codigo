SELECT es.session_id
    ,es.program_name
    ,es.login_name
    ,es.nt_user_name
    ,es.login_time
    ,es.host_name
    ,es.cpu_time
    ,es.total_scheduled_time
    ,es.total_elapsed_time
    ,es.memory_usage
    ,es.logical_reads
    ,es.reads
    ,es.writes
    ,st.text
FROM sys.dm_exec_sessions es
    LEFT JOIN sys.dm_exec_connections ec 
        ON es.session_id = ec.session_id
    LEFT JOIN sys.dm_exec_requests er
        ON es.session_id = er.session_id
    OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) st
WHERE es.session_id > 50    -- < 50 system sessions
--WHERE es.nt_user_name = 'i3477'
ORDER BY 
	login_name DESC