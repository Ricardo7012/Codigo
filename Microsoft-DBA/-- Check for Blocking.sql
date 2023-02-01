-- Check for Blocking

SELECT L.request_session_id AS 'SPID'
	, DB_NAME(L.resource_database_id) AS 'Database Name'
	, O.NAME AS 'Locked Object Name'
	, P.object_id AS 'Locked ObjectId'
	, L.resource_type AS 'Locked Resource'
	, L.request_mode AS 'Lock Type'
	, ST.TEXT AS 'Sql Statement Text'
	, ES.login_name AS 'Login Name'
	, ES.host_name AS 'Host Name'
	, TST.is_user_transaction AS 'Is User Transaction'
	, AT.NAME AS 'Transaction Name'
	, CN.auth_scheme AS 'Authentication Method'
FROM sys.dm_tran_locks L
INNER JOIN sys.partitions P
	ON P.hobt_id = L.resource_associated_entity_id
INNER JOIN sys.objects O
	ON O.object_id = P.object_id
INNER JOIN sys.dm_exec_sessions ES
	ON ES.session_id = L.request_session_id
INNER JOIN sys.dm_tran_session_transactions TST
	ON ES.session_id = TST.session_id
INNER JOIN sys.dm_tran_active_transactions AT
	ON TST.transaction_id = AT.transaction_id
INNER JOIN sys.dm_exec_connections CN
	ON CN.session_id = ES.session_id
CROSS APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) AS ST
WHERE resource_database_id = db_id()
ORDER BY L.request_session_id
