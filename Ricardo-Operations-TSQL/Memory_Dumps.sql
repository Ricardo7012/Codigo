SELECT @@ServerName AS SERVERNAME
     , *
FROM sys.dm_server_memory_dumps AS dsmd
WHERE creation_time > CONVERT(DATETIME, '2017-12-31', 101)
ORDER BY creation_time DESC;
