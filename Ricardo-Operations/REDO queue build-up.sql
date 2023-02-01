-- REDO queue build-up
-- https://blogs.msdn.microsoft.com/alwaysonpro/2015/01/06/troubleshooting-redo-queue-build-up-data-latency-issues-on-alwayson-readable-secondary-replicas-using-the-wait_info-extended-event/

/*
On the SQL Server hosting the secondary replica of a given availability group, each database 
has a single REDO thread with its own session_id.  To get a list of all of the redo threads 
on a given secondary replica instance (across all availability groups), issue the following 
query which will return the session_ids performing “REDO” -- otherwise known as  “DB STARTUP”.

Once we have the session_id(s) to monitor, we can then configure an extended event session to capture 
the WAIT_INFO events for only the session_id(s) of interest.   This is important because the WAIT_INFO 
event can be fired quite extensively in a busy system.   Even when limiting to REDO specific session_ids, 
it can generate a lot of data very quickly.

Note – for a given secondary replica database – if the REDO thread is completely caught up and there is 
no new activity on the primary, this thread will eventually be closed and returned to the HADR thread 
pool, so it is possible you may not see any active session_id for a given database – or that the session_id 
can change for a given database.   However, in busy systems, where there are new transactions constantly 
taking place on the primary, the REDO thread will remain active and have the same session_id for extended 
periods of time.

*/

SELECT @@ServerName         AS servername
     , DB_NAME(database_id) AS DBName
     , session_id
FROM sys.dm_exec_requests
WHERE command = 'DB STARTUP';


CREATE EVENT SESSION [redo_wait_info] ON SERVER 
ADD EVENT sqlos.wait_info(
    ACTION(package0.event_sequence,
        sqlos.scheduler_id,
        sqlserver.database_id,
        sqlserver.session_id)
    WHERE ([opcode]=(1) AND 
        [sqlserver].[session_id]=(22))) 
ADD TARGET package0.event_file(
    SET filename=N'redo_wait_info')
WITH (MAX_MEMORY=4096 KB,
    EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY=30 SECONDS,
    MAX_EVENT_SIZE=0 KB,
    MEMORY_PARTITION_MODE=NONE,
    TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO

ALTER EVENT SESSION [redo_wait_info] ON SERVER STATE=START

WAITFOR DELAY '00:00:30'

ALTER EVENT SESSION [redo_wait_info] ON SERVER STATE=STOP


SELECT *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE '%FLOW%';

SELECT *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE '%REDO%';

WAITFOR DELAY '00:00:30'

SELECT *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE '%FLOW%';

SELECT *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE '%REDO%';


