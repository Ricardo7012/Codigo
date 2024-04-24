-- http://www.sqlskills.com/blogs/paul/the-accidental-dba-day-27-of-30-troubleshooting-tempdb-contention/
SELECT
    [owt].[session_id],
    [owt].[exec_context_id],
    [owt].[wait_duration_ms],
    [owt].[wait_type],
    [owt].[blocking_session_id],
    [owt].[resource_description],
    CASE [owt].[wait_type]
        WHEN N'CXPACKET' THEN
            RIGHT ([owt].[resource_description],
            CHARINDEX (N'=', REVERSE ([owt].[resource_description])) - 1)
        ELSE NULL
    END AS [Node ID],
    [es].[program_name],
    [est].text,
    [er].[database_id],
    [eqp].[query_plan],
    [er].[cpu_time]
FROM sys.dm_os_waiting_tasks [owt]
INNER JOIN sys.dm_exec_sessions [es] ON
    [owt].[session_id] = [es].[session_id]
INNER JOIN sys.dm_exec_requests [er] ON
    [es].[session_id] = [er].[session_id]
OUTER APPLY sys.dm_exec_sql_text ([er].[sql_handle]) [est]
OUTER APPLY sys.dm_exec_query_plan ([er].[plan_handle]) [eqp]
WHERE
    [es].[is_user_process] = 1
ORDER BY
    [owt].[session_id],
    [owt].[exec_context_id];
GO

--NOTE THAT THE [EST].TEXT LINE DOES NOT HAVE TEXT DELIMITED – IT THROWS OFF THE PLUGIN.
--IF YOU SEE A LOT OF LINES OF OUTPUT WHERE THE 
--WAIT_TYPE IS PAGELATCH_UP OR PAGELATCH_EX, 
--AND THE RESOURCE_DESCRIPTION IS 2:1:1 
--THEN THAT’S THE PFS PAGE (DATABASE ID 2 – TEMPDB, FILE ID 1, PAGE ID 1), AND 
--IF YOU SEE 2:1:3 THEN THAT’S ANOTHER ALLOCATION PAGE CALLED AN SGAM 

--use [tempdb]
--GO
--DBCC FREEPROCCACHE

--USE tempdb;
--GO
--DBCC SHRINKFILE('temp5', EMPTYFILE)
--GO
--USE master;
--GO
--ALTER DATABASE tempdb
--REMOVE FILE temp5;
