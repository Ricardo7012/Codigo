
--Returns Total SQL Server Memory
SELECT object_name, counter_name, cntr_value AS 'value'
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Memory Manager'
	AND counter_name IN ('Total Server Memory (KB)', 
		'Target Server Memory (KB)', 
		'Maximum Workspace Memory (KB)', 
		'SQL Cache Memory (KB)',
		'Memory Grants Pending',
		'Memory Grants Outstanding',
		'Stolen Server Memory (KB)',
		'Free Memory (KB)',
		'Database Cache Memory (KB)',
		'Log Pool Memory (KB)',
		'External benefit of memory')
GO

-- Queries that have requested memory or waiting for memory to be granted
SELECT  
		mg.session_id,
		sp.hostname,
		DB_NAME(st.dbid) AS [DatabaseName] ,
        mg.requested_memory_kb ,
        mg.ideal_memory_kb ,
        mg.request_time ,
        mg.grant_time ,
        mg.query_cost ,
        mg.dop ,
		object_name(st.objectid) as ObjectName,
		mg.wait_order,
		mg.wait_time_ms,
		mg.grant_time,
		er.percent_complete, 
		er.session_Id,er.blocking_session_id, er.start_time, 
		[User] = sp.nt_username, --tm.Team_Member_Name, 
		er.cpu_time, --er.total_elapsed_time, 
		(
		CASE 
			WHEN CONVERT(VARCHAR(10),(GETDATE() - er.start_time),108) = '23:59:59' THEN '00:00:00'
			ELSE CONVERT(VARCHAR(10),(GETDATE() - er.start_time),108)
			END
		) + ' ( >= ' + CONVERT(VARCHAR(4), DATEDIFF(HOUR, er.start_time, GETDATE())) + ' hrs)' AS Duration, 
		   [DatabaseName] = DB_NAME(sp.dbid), 
       
		[Program] = sp.[program_name], er.logical_reads, er.reads, 
		con.net_packet_size,
		[Status] = er.status, [WaitType] = er.wait_type,
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
        st.[text]
FROM    sys.dm_exec_query_memory_grants AS mg
        CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
		INNER JOIN sys.sysprocesses AS sp ON mg.session_id = sp.spid
		INNER JOIN sys.dm_exec_requests AS er ON sp.spid = er.session_id
		LEFT JOIN sys.dm_exec_sessions AS ses ON ses.session_id = er.session_id
		LEFT JOIN sys.dm_exec_connections AS con ON con.session_id = ses.session_id
		LEFT JOIN sys.dm_tran_session_transactions s ON er.session_id = s.session_id
		LEFT JOIN sys.dm_tran_active_transactions t ON s.transaction_id = t.transaction_id
GO
