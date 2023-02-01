--Ghost clean up thread  –  Check if the user deleted large number of rows
--Lazy Writer thread – Check if any memory pressure on the server
--Resource Monitor thread – Check if any memory pressure on the server
--Run the below query to find if SQL threads are taking up CPU
SELECT *
FROM sys.sysprocesses
WHERE cmd LIKE 'LAZY WRITER'
      OR cmd LIKE '%Ghost%'
      OR cmd LIKE 'RESOURCE MONITOR';

SELECT @@ServerName
     , GETDATE() AS SERVERNAME;

SELECT scheduler_id
     , cpu_id
     , status
     , is_online
FROM sys.dm_os_schedulers;
GO
