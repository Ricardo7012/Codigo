-- Connection Time to SQL

SELECT dmec.session_id AS 'Session ID'
	, dmec.most_recent_session_id AS 'Current Session ID'
	, dmec.connect_time AS 'Connect Time'
	, '- -' AS '- -'
	, dmec.last_read AS 'Last Read'
	, dmec.last_write AS 'Last Write'
	, '- -' AS '- -'	
	, dmec.num_reads AS '# Reads'
	, dmec.num_writes AS '# Writes'
	, '- -' AS '- -'	
	, dmec.connection_id AS 'Connection ID'
	, dmec.parent_connection_id AS 'Parent Connection ID'
	, dmec.most_recent_sql_handle AS 'Recent SQL Handle'
	, CASE 
		WHEN dmest.dbid = 32767
			THEN 'resourcedb'
		ELSE db_name(dmest.dbid)
		END AS database_name
	, dmest.TEXT AS 'sqltext'
FROM sys.dm_exec_connections dmec
CROSS APPLY sys.dm_exec_sql_text(dmec.most_recent_sql_handle) dmest