-- AG PROPERTIES
-- https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/view-availability-group-listener-properties-sql-server?view=sql-server-ver15
-- https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/monitor-availability-groups-transact-sql?view=sql-server-ver15
SELECT * FROM sys.dm_tcp_listener_states 
SELECT * FROM sys.availability_group_listeners
SELECT * FROM sys.availability_group_listener_ip_addresses
SELECT * FROM sys.dm_hadr_cluster
SELECT * FROM sys.dm_hadr_cluster_members
SELECT * FROM sys.dm_hadr_cluster_networks
SELECT * FROM sys.dm_hadr_instance_node_map
SELECT * FROM sys.dm_hadr_name_id_map
SELECT * FROM sys.availability_groups
SELECT * FROM sys.availability_groups_cluster
SELECT * FROM sys.dm_hadr_availability_group_states
SELECT * FROM sys.availability_replicas
SELECT * FROM sys.availability_read_only_routing_lists
SELECT * FROM sys.dm_hadr_availability_replica_cluster_nodes
SELECT * FROM sys.dm_hadr_availability_replica_cluster_states
SELECT * FROM sys.dm_hadr_availability_replica_states
SELECT * FROM sys.dm_hadr_auto_page_repair
SELECT * FROM sys.dm_hadr_database_replica_cluster_states