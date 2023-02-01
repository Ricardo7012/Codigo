-- https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/configure-read-only-routing-for-an-availability-group-sql-server
-- https://www.sqlshack.com/how-to-configure-read-only-routing-for-an-availability-group-in-sql-server-2016/ 
/*******************************************************************************
In order to create the Read-Only Routing list, we should check first that an Availability Group 
Listener is configured, as the read-only client will direct the connection requests to the Availability 
Groups listener. We can do that by querying the sys.availability_group_listeners DMV and join it 
with the sys.availability_groups DMV to get the Availability Group name as follows:
*******************************************************************************/

SELECT	AV.name AS AVGName
	, AVGLis.dns_name AS ListenerName
	, AVGLis.ip_configuration_string_from_cluster AS ListenerIP
FROM	sys.availability_group_listeners AVGLis
INNER JOIN sys.availability_groups AV on AV.group_id = AV.group_id

/********************************************************************************/
--SECONDARY ROLE
ALTER AVAILABILITY GROUP [PVHAGHSP01]  
 MODIFY REPLICA ON N'HSP1S1A' WITH   
       (SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));  
ALTER AVAILABILITY GROUP [PVHAGHSP01]  
 MODIFY REPLICA ON  N'HSP1S1A' WITH   
       (SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://HSP1S1A.iehp.local:1433'));  
 
ALTER AVAILABILITY GROUP [PVHAGHSP01]  
 MODIFY REPLICA ON  N'HSP1S1B' WITH   
       (SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));  
ALTER AVAILABILITY GROUP [PVHAGHSP01]  
 MODIFY REPLICA ON  N'HSP1S1B' WITH   
       (SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://HSP1S1B.iehp.local:1433'));
 
--PRIMARY ROLE
ALTER AVAILABILITY GROUP [PVHAGHSP01]   
MODIFY REPLICA ON  N'HSP1S1A' WITH   
       (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('HSP1S1B','HSP1S1A')));  
 
ALTER AVAILABILITY GROUP [PVHAGHSP01]   
MODIFY REPLICA ON  N'HSP1S1B' WITH   
       (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('HSP1S1A','HSP1S1B')));  
GO 

/******************************************************************************
--The sys.availability_replicas DMV can be used to review the configured read-only routing URL for each replica as below:
*******************************************************************************/
SELECT replica_server_name
	, read_only_routing_url
	, secondary_role_allow_connections_desc
FROM sys.availability_replicas
/********************************************************************************/

SELECT	  AVGSrc.replica_server_name AS SourceReplica		
		, AVGRepl.replica_server_name AS ReadOnlyReplica
		, AVGRepl.read_only_routing_url AS RoutingURL
		, AVGRL.routing_priority AS RoutingPriority
FROM sys.availability_read_only_routing_lists AVGRL
INNER JOIN sys.availability_replicas AVGSrc ON AVGRL.replica_id = AVGSrc.replica_id
INNER JOIN sys.availability_replicas AVGRepl ON AVGRL.read_only_replica_id = AVGRepl.replica_id
INNER JOIN sys.availability_groups AV ON AV.group_id = AVGSrc.group_id
ORDER BY SourceReplica
