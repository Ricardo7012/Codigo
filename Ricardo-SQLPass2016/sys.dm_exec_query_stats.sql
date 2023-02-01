/*
RICH FERNANDEZ
310-900-6123
10.19.2010
CREATED TO CAPTURE WHAT PROCESS IS EXECUTING BY total_elapsed_time
*/

USE ReportServer
GO
/*QUERY1*/
SELECT * FROM sys.dm_exec_query_stats ORDER BY total_elapsed_time DESC
GO
/*FEED IN BINARY FROM SQL_HANDLE COLUMN*/
SELECT * FROM SYS.dm_exec_sql_text(0x03000500D6A9FB47D80889000D9B00000100000000000000)
GO
/*SELECT TOP 5*/
SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time],
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY total_worker_time/execution_count DESC;
GO


/*--------------------------------------------------------------------
Purpose: Shows what individual SQL statements are currently executing.
---------------------------------------------------------------------*/
BEGIN
    -- Do not lock anything, and do not get held up by any locks.
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    -- What SQL Statements Are Currently Running?
    SELECT 
	 [Spid] = session_Id
	, ecid
	, [Database] = DB_NAME(sp.dbid)
	, [User] = nt_username
	, [Status] = er.status
	, [Wait] = wait_type
	, [Individual Query] = SUBSTRING (qt.text, 
             er.statement_start_offset/2,
	(CASE WHEN er.statement_end_offset = -1
	       THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
		ELSE er.statement_end_offset END - 
                                er.statement_start_offset)/2)
	,[Parent Query] = qt.text
	, Program = program_name
	, Hostname
	, nt_domain
	, start_time
    FROM sys.dm_exec_requests er
    INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)as qt
--    WHERE session_Id > 50              -- Ignore system spids.
--    AND session_Id NOT IN (@@SPID)     -- Ignore this current statement.
    ORDER BY 1, 2
END
