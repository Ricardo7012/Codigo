-- https://blog.dbi-services.com/sql-server-alwayson-and-availability-groups-session-timeout-parameter/
-- Primary replica
--:CONNECT QVSQLHSP01
SELECT @@servername,
       *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'HADR_s%';
GO

-- Secondary replica
--:CONNECT QVSQLHSP02 


-- WELL LET’S INCREASE THE VALUE TO 360 SECONDS AS A REAL CUSTOMER CASE. THE IDEA BEHIND WAS TO GET RID 
--OF THE DISCONNECTION ERROR MESSAGE ON THE SECONDARY THAT TRIGGERED EMAIL ALERTS TO THE IT INFRASTRUCTURE 
--DURING THE VEEAM BACKUP PROCESS. YES, WE DON’T LIKE TO WAKE UP DURING THE NIGHT FOR A FALSE POSITIVE ALERT 
USE [master];
GO
-- https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/change-the-session-timeout-period-for-an-availability-replica-sql-server?view=sql-server-2017 
-- https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/possible-failures-during-sessions-between-availability-replicas-sql-server?view=sql-server-2017

SELECT replica_server_name, session_timeout FROM sys.availability_replicas

ALTER AVAILABILITY GROUP QVHAGHSP02
MODIFY REPLICA ON 'HSP2S1A'
WITH
(
    SESSION_TIMEOUT = 360
);
GO
SELECT replica_server_name, session_timeout FROM sys.availability_replicas

SELECT * FROM sys.availability_replicas
