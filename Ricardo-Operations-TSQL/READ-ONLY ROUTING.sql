--CONFIGURE READ-ONLY ROUTING FOR AN AVAILABILITY GROUP
-- https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/configure-read-only-routing-for-an-availability-group-sql-server
-- https://www.sqlshack.com/how-to-configure-read-only-routing-for-an-availability-group-in-sql-server-2016/


ALTER AVAILABILITY GROUP [AGVEGA01]
MODIFY REPLICA ON
N'VEGA01' WITH
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('VEGA02','TITAN')));
 
 
ALTER AVAILABILITY GROUP [AGVEGA01]
MODIFY REPLICA ON
N'VEGA02' WITH
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('TITAN','VEGA01')));
 
 
ALTER AVAILABILITY GROUP [AGVEGA01]
MODIFY REPLICA ON
N'TITAN' WITH
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('VEGA02','VEGA01')));
 


SELECT	AV.name AS AVGName
	, AVGLis.dns_name AS ListenerName
	, AVGLis.ip_configuration_string_from_cluster AS ListenerIP
FROM	sys.availability_group_listeners AVGLis
INNER JOIN sys.availability_groups AV on AV.group_id = AV.group_id
 
SELECT replica_server_name
	, read_only_routing_url
	, secondary_role_allow_connections_desc
FROM sys.availability_replicas
 

 SELECT	  AVGSrc.replica_server_name AS SourceReplica		
		, AVGRepl.replica_server_name AS ReadOnlyReplica
		, AVGRepl.read_only_routing_url AS RoutingURL
		, AVGRL.routing_priority AS RoutingPriority
FROM sys.availability_read_only_routing_lists AVGRL
INNER JOIN sys.availability_replicas AVGSrc ON AVGRL.replica_id = AVGSrc.replica_id
INNER JOIN sys.availability_replicas AVGRepl ON AVGRL.read_only_replica_id = AVGRepl.replica_id
INNER JOIN sys.availability_groups AV ON AV.group_id = AVGSrc.group_id
ORDER BY SourceReplica

