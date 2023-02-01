-- List Blocking

SELECT db.NAME AS 'DB Name'
	, tl.request_session_id AS 'Request Session ID'
	, wt.blocking_session_id AS 'Blocking Session ID'
	, OBJECT_NAME(p.OBJECT_ID) AS 'Blocked Object Name'
	, tl.resource_type AS'Resource Type'
	, h1.TEXT AS 'Requesting Text'
	, h2.TEXT AS 'Blocking Test'
	, tl.request_mode AS 'Request Mode'
FROM sys.dm_tran_locks AS tl
INNER JOIN sys.databases db
	ON db.database_id = tl.resource_database_id
INNER JOIN sys.dm_os_waiting_tasks AS wt
	ON tl.lock_owner_address = wt.resource_address
INNER JOIN sys.partitions AS p
	ON p.hobt_id = tl.resource_associated_entity_id
INNER JOIN sys.dm_exec_connections ec1
	ON ec1.session_id = tl.request_session_id
INNER JOIN sys.dm_exec_connections ec2
	ON ec2.session_id = wt.blocking_session_id
CROSS APPLY sys.dm_exec_sql_text(ec1.most_recent_sql_handle) AS h1
CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2
GO


