-- https://www.brentozar.com/archive/2019/02/what-should-you-do-about-memory-dumps/
-- If you’re not comfortable with looking at DMPs, patch your SQL Server, then call Microsoft!!

SELECT @@servername as SERVERNAME, *
FROM sys.dm_server_memory_dumps AS dsmd
where creation_time > convert(datetime, ''2018-12-31'', 101)
ORDER BY creation_time DESC;


