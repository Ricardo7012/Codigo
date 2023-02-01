--USE [master]
--GO

--CREATE PROCEDURE [dbo].[sp_who3]
--AS
--BEGIN
--	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT er.session_id AS 'SPID'
		, CASE 
			WHEN lead_blocker = 1
				THEN - 1
			ELSE er.blocking_session_id
			END AS 'Block By'
		, er.total_elapsed_time AS 'Elapsed (ms)'
		, er.cpu_time AS 'CPU'
		, er.logical_reads + er.reads AS 'IO Reads'
		, er.writes AS 'IO Writes'
		, ec.execution_count AS 'Exec'
		, er.command AS 'Cmd Type'
		, er.last_wait_type AS 'Last Wait Type'
		, OBJECT_SCHEMA_NAME(qt.objectid, dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid) AS 'Object Name'
		, SUBSTRING(qt.TEXT, er.statement_start_offset / 2, CASE 
				WHEN (
						CASE 
							WHEN er.statement_end_offset = - 1
								THEN LEN(CONVERT(NVARCHAR(MAX), qt.TEXT)) * 2
							ELSE er.statement_end_offset
							END - er.statement_start_offset / 2
						) < 0
					THEN 0
				ELSE CASE 
						WHEN er.statement_end_offset = - 1
							THEN LEN(CONVERT(NVARCHAR(MAX), qt.TEXT)) * 2
						ELSE er.statement_end_offset
						END - er.statement_start_offset / 2
				END) AS 'SQL Statement'
		, ses.STATUS AS 'Satus'
		, ses.login_name AS 'Login'
		, ses.host_name AS 'Host'
		, DB_Name(er.database_id) AS 'DB Name'
		, er.start_time AS 'Start Time'
		, con.net_transport AS 'Protocol'
		, CASE ses.transaction_isolation_level
			WHEN 0
				THEN 'Unspecified'
			WHEN 1
				THEN 'Read Uncommitted'
			WHEN 2
				THEN 'Read Committed'
			WHEN 3
				THEN 'Repeatable'
			WHEN 4
				THEN 'Serializable'
			WHEN 5
				THEN 'Snapshot'
			END AS 'Transaction Isolation'
		, con.num_writes AS 'Connection Writes'
		, con.num_reads AS 'Connection Reads'
		, con.client_net_address AS 'Client Address'
		, con.auth_scheme AS 'Authentication'
		, GETDATE() AS 'Datetime Snapshot'
		, er.plan_handle AS 'Plan Handle'
	FROM sys.dm_exec_requests er
	LEFT JOIN sys.dm_exec_sessions ses
		ON ses.session_id = er.session_id
	LEFT JOIN sys.dm_exec_connections con
		ON con.session_id = ses.session_id
	OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt
	OUTER APPLY (
		SELECT execution_count = MAX(cp.usecounts)
		FROM sys.dm_exec_cached_plans cp
		WHERE cp.plan_handle = er.plan_handle
		) ec
	OUTER APPLY (
		SELECT lead_blocker = 1
		FROM master.dbo.sysprocesses sp
		WHERE sp.spid IN (
				SELECT blocked
				FROM master.dbo.sysprocesses WITH (NOLOCK)
				WHERE blocked != 0
				)
			AND sp.blocked = 0
			AND sp.spid = er.session_id
		) lb
	WHERE er.sql_handle IS NOT NULL
		AND er.session_id != @@SPID
	ORDER BY CASE 
			WHEN lb.lead_blocker = 1
				THEN - 1 * 1000
			ELSE - er.blocking_session_id
			END
		, er.blocking_session_id DESC
		, er.logical_reads + er.reads DESC
		, er.session_id;
--END
