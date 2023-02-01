--LISTENER INFO
SELECT gl.dns_name
      ,gl.port
      --,gl.is_conformant
      ,gl.ip_configuration_string_from_cluster
      ,lip.ip_address
      ,lip.ip_subnet_mask
      ,lip.is_dhcp
      ,lip.network_subnet_ip
      ,lip.network_subnet_prefix_length
      ,lip.network_subnet_ipv4_mask
      ,lip.state_desc
FROM sys.availability_group_listeners gl
INNER JOIN sys.availability_group_listener_ip_addresses lip
    ON gl.listener_id = lip.listener_id

--READONLY ROUTING 
SELECT    AV.name AS AVGName
	, AVGLis.dns_name AS ListenerName
	, AVGLis.ip_configuration_string_from_cluster AS ListenerIP
FROM    sys.availability_group_listeners AVGLis
INNER JOIN sys.availability_groups AV on AV.group_id = AV.group_id
 
SELECT replica_server_name
	, read_only_routing_url
	, secondary_role_allow_connections_desc
FROM sys.availability_replicas
 
 
 SELECT      AVGSrc.replica_server_name AS SourceReplica        
	, AVGRepl.replica_server_name AS ReadOnlyReplica
	, AVGRepl.read_only_routing_url AS RoutingURL
	, AVGRL.routing_priority AS RoutingPriority
FROM sys.availability_read_only_routing_lists AVGRL
INNER JOIN sys.availability_replicas AVGSrc ON AVGRL.replica_id = AVGSrc.replica_id
INNER JOIN sys.availability_replicas AVGRepl ON AVGRL.read_only_replica_id = AVGRepl.replica_id
INNER JOIN sys.availability_groups AV ON AV.group_id = AVGSrc.group_id
ORDER BY SourceReplica
