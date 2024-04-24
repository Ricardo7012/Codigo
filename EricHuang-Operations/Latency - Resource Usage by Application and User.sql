--Resource Usage by Application
SELECT
     CPU            = SUM(cpu_time)
    ,WaitTime       = SUM(total_scheduled_time)
    ,ElapsedTime    = SUM(total_elapsed_time)
    ,Reads          = SUM(num_reads)
    ,Writes         = SUM(num_writes)
    ,Connections    = COUNT(1)
    ,Program        = program_name
FROM sys.dm_exec_connections con
LEFT JOIN sys.dm_exec_sessions ses
    ON ses.session_id = con.session_id
GROUP BY program_name
ORDER BY cpu DESC


--Resource Usage by Application and User
SELECT
     CPU            = SUM(cpu_time)
    ,WaitTime       = SUM(total_scheduled_time)
    ,ElapsedTime    = SUM(total_elapsed_time)
    ,Reads          = SUM(num_reads)
    ,Writes         = SUM(num_writes)
    ,Connections    = COUNT(1)
    ,Program        = program_name
    ,LoginName      = ses.login_name
FROM sys.dm_exec_connections con
LEFT JOIN sys.dm_exec_sessions ses
    ON ses.session_id = con.session_id
GROUP BY program_name, ses.login_name
ORDER BY cpu DESC

