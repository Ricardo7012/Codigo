-- List all SPID's Blocking

SELECT stst.session_id AS 'Session ID'
	, ses.login_name AS 'Login Name'
	, DB_NAME(stdt.database_id) AS 'Database'
	, stdt.database_transaction_begin_time AS 'Begin Time'
	, stdt.database_transaction_log_bytes_used AS 'Log Bytes'
	, stdt.database_transaction_log_bytes_reserved AS 'Log Rsvd'
	, sest.TEXT AS 'Last T-SQL Text'
	, seqp.query_plan AS 'Last Plan'
FROM sys.dm_tran_database_transactions stdt
INNER JOIN sys.dm_tran_session_transactions stst
	ON stst.transaction_id = stdt.transaction_id
INNER JOIN sys.dm_exec_sessions ses
	ON ses.session_id = stst.session_id
INNER JOIN sys.dm_exec_connections sec
	ON sec.session_id = stst.session_id
LEFT JOIN sys.dm_exec_requests ser
	ON ser.session_id = stst.session_id
CROSS APPLY sys.dm_exec_sql_text(sec.most_recent_sql_handle) AS sest
OUTER APPLY sys.dm_exec_query_plan(ser.plan_handle) AS seqp
ORDER BY 'Begin Time' ASC