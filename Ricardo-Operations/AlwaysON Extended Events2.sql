-- https://www.mssqltips.com/sqlservertip/5287/monitoring-sql-server-availability-groups-with-alwayson-extended-events-health-session/ 

/********************************************************************************************************************
How to Query the Extended Events Session for When a Server Becomes the Primary
Now you can write some queries against the extended event and pull out the data you need for alerts.  For example, 
for Role Change alert number 1480 here is the query to pull out only when a server becomes the primary so you only 
get one alert.  The first part of the code goes and finds the current file on the operating system that holds the 
extended event session data.  Then we SELECT from that WHERE the availability_replica_state_change change became 
the PRIMARY_NORMAL state
******************************************************************************************************************/
DECLARE @FileName NVARCHAR(4000);
SELECT @FileName = target_data.value('(EventFileTarget/File/@name)[1]', 'nvarchar(4000)')
FROM
(
    SELECT CAST(target_data AS XML) target_data
    FROM sys.dm_xe_sessions s
        JOIN sys.dm_xe_session_targets t
            ON s.address = t.event_session_address
    WHERE s.name = N'AlwaysOn_health'
) ft;

SELECT XEData.value('(event/@timestamp)[1]', 'datetime2(3)') AS event_timestamp,
       XEData.value('(event/data[@name="previous_state"]/text)[1]', 'varchar(255)') AS previous_state,
       XEData.value('(event/data[@name="current_state"]/text)[1]', 'varchar(255)') AS current_state,
       XEData.value('(event/data[@name="availability_replica_name"]/value)[1]', 'varchar(255)') AS availability_replica_name,
       XEData.value('(event/data[@name="availability_group_name"]/value)[1]', 'varchar(255)') AS availability_group_name
FROM
(
    SELECT CAST(event_data AS XML) XEData,
           *
    FROM sys.fn_xe_file_target_read_file(@FileName, NULL, NULL, NULL)
    WHERE object_name = 'availability_replica_state_change'
) event_data
WHERE XEData.value('(event/data[@name="current_state"]/text)[1]', 'varchar(255)') = 'PRIMARY_NORMAL'
ORDER BY event_timestamp DESC;

/******************************************************************************************************************
How to Query the Extended Events Session for Error Numbers
Next we can query for specific error numbers that are that referenced in the extended events session.  In the query 
below we are looking for the error numbers related to possible database corruption issues.
*******************************************************************************************************************/
DECLARE @FileName2 NVARCHAR(4000);
SELECT @FileName2 = target_data.value('(EventFileTarget/File/@name)[1]', 'nvarchar(4000)')
FROM
(
    SELECT CAST(target_data AS XML) target_data
    FROM sys.dm_xe_sessions s
        JOIN sys.dm_xe_session_targets t
            ON s.address = t.event_session_address
    WHERE s.name = N'AlwaysOn_health'
) ft;

SELECT XEData.value('(event/@timestamp)[1]', 'datetime2(3)') AS event_timestamp,
       XEData.value('(event/data[@name="error_number"]/value)[1]', 'int') AS error_number,
       XEData.value('(event/data[@name="severity"]/value)[1]', 'int') AS severity,
       XEData.value('(event/data[@name="message"]/value)[1]', 'varchar(max)') AS message
FROM
(
    SELECT CAST(event_data AS XML) XEData,
           *
    FROM sys.fn_xe_file_target_read_file(@FileName2, NULL, NULL, NULL)
    WHERE object_name = 'error_reported'
) event_data
WHERE XEData.value('(event/data[@name="error_number"]/value)[1]', 'int') IN ( 823, 824, 829 )
ORDER BY event_timestamp DESC;

/********************************************************************************************************************
********************************************************************************************************************/
select * from sys.dm_hadr_cluster
select * from sys.dm_hadr_cluster_members
select * from sys.dm_hadr_cluster_networks
select * from sys.availability_groups
select * from sys.availability_groups_cluster
select * from sys.dm_hadr_availability_group_states
select * from sys.availability_replicas
select * from sys.dm_hadr_availability_replica_cluster_nodes
select * from sys.dm_hadr_availability_replica_cluster_states
select * from sys.dm_hadr_availability_replica_states
select * from sys.dm_hadr_auto_page_repair
select * from sys.dm_hadr_database_replica_states
select * from sys.dm_hadr_database_replica_cluster_states
select * from sys.availability_group_listener_ip_addresses
select * from sys.availability_group_listeners
select * from sys.dm_tcp_listener_states

