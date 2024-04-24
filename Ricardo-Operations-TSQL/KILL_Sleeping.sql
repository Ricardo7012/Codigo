--SELECT *
--FROM sys.dm_exec_sessions s
--WHERE is_user_process = 1;

SELECT --COUNT(*) AS sessions,
    s.session_id,
    s.[host_name],
    s.[status],
    s.host_process_id,
    s.[program_name],
    DB_NAME(s.database_id) AS database_name
FROM sys.dm_exec_sessions s
    (NOLOCK)
WHERE is_user_process = 1
      AND s.nt_user_name NOT LIKE '%SVC'
      AND s.status = 'sleeping'
      AND s.program_name LIKE '%Microsoft SQL Server Management Studio - Query%'; --DB_NAME(s.database_id) = 'HSP_MO'
--GROUP BY host_name,
--         status,
--		 host_process_id,
--         program_name,
--         database_id
--ORDER BY COUNT(*) DESC;

DECLARE @Table TABLE
(
    session_id INT,
    [host_name] VARCHAR(MAX),
    [status] VARCHAR(MAX),
    host_process_id VARCHAR(MAX),
    [program_name] VARCHAR(MAX),
    [database_name] VARCHAR(MAX)
);
SET NOCOUNT ON;
INSERT INTO @Table
SELECT --COUNT(*) AS sessions,
    s.session_id,
    s.[host_name],
    s.[status],
    s.host_process_id,
    s.[program_name],
    DB_NAME(s.database_id) AS database_name
FROM sys.dm_exec_sessions s
    (NOLOCK)
WHERE is_user_process = 1
      AND s.nt_user_name NOT LIKE '%SVC'
      AND s.status = 'sleeping'
      AND s.program_name LIKE '%Microsoft SQL Server Management Studio%'; --DB_NAME(s.database_id) = 'HSP_MO'
DECLARE @killids NVARCHAR(MAX) = '';
SELECT @killids = @killids + N'Kill ' + CAST(session_id AS VARCHAR) + N';'
FROM @Table;
--WHERE session_id > 50
--      AND session_id <> @@spid;
--and LOGIN = <loginname>--SUSER_name()
PRINT @killids;
EXEC sp_executesql @killids;

SELECT --COUNT(*) AS sessions,
    s.session_id,
    s.[host_name],
    s.[status],
    s.host_process_id,
    s.[program_name],
    DB_NAME(s.database_id) AS database_name
FROM sys.dm_exec_sessions s
    (NOLOCK)
WHERE is_user_process = 1
      AND s.nt_user_name NOT LIKE '%SVC'
      AND s.status = 'sleeping'
      AND s.program_name LIKE '%Microsoft SQL Server Management Studio - Query%'; --DB_NAME(s.database_id) = 'HSP_MO'
--GROUP BY host_name,
--         status,
--		 host_process_id,
--         program_name,
--         database_id
--ORDER BY COUNT(*) DESC;
