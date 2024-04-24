--AlwaysOn
--AO AG Check health and status

-- Health and status of AG listeners
SELECT agl.dns_name,
       agl.port,
       aglia.*
FROM sys.availability_group_listener_ip_addresses aglia
    INNER JOIN sys.availability_group_listeners agl
        ON agl.listener_id = aglia.listener_id;


-- Health and status of AG databases, run this on the primary replica. 
-- On secondary this will only show info for that instance
SELECT ag.name ag_name,
       ar.replica_server_name,
       adc.database_name,
       hdrs.database_state_desc,
       hdrs.synchronization_state_desc,
       hdrs.synchronization_health_desc,
       agl.dns_name,
       agl.port
-- ,*
FROM sys.dm_hadr_database_replica_states hdrs
    LEFT JOIN sys.availability_groups ag
        ON hdrs.group_id = ag.group_id
    LEFT JOIN sys.availability_replicas ar
        ON ag.group_id = ar.group_id
           AND ar.replica_id = hdrs.replica_id
    LEFT JOIN sys.availability_databases_cluster adc
        ON adc.group_id = ag.group_id
           AND adc.group_database_id = hdrs.group_database_id
    LEFT JOIN sys.availability_group_listeners agl
        ON agl.group_id = ag.group_id
ORDER BY ar.replica_server_name,--ag.name,
         adc.database_name;


SELECT ar.replica_server_name,
       CASE ar.replica_server_name
           WHEN 'HSP1S1A' THEN
               'Primary Replica'
           WHEN 'HSP1S1B' THEN
               'Secondary DC Replica'
           ELSE
               'Secondary DR Replica'
       END AS [Replica],
       adc.[database_name],
       drs.is_local,
       drs.is_primary_replica,
       drcs.is_failover_ready,
       drs.synchronization_state_desc,
       drs.is_commit_participant,
       drs.synchronization_health_desc,
       drs.recovery_lsn
FROM sys.dm_hadr_database_replica_states AS drs
    INNER JOIN sys.availability_databases_cluster AS adc
        ON drs.group_id = adc.group_id
           AND drs.group_database_id = adc.group_database_id
    INNER JOIN sys.availability_groups AS ag
        ON ag.group_id = drs.group_id
    INNER JOIN sys.availability_replicas AS ar
        ON drs.group_id = ar.group_id
           AND drs.replica_id = ar.replica_id
    INNER JOIN sys.dm_hadr_database_replica_cluster_states AS drcs
        ON drs.replica_id = drcs.replica_id
ORDER BY Replica;


SELECT r.replica_server_name,
       CASE r.replica_server_name
           WHEN 'HSP1S1A' THEN
               'Primary Replica'
           WHEN 'HSP1S1B' THEN
               'Secondary DC Replica'
           ELSE
               'Secondary DR Replica'
       END AS Replica,
       rs.is_primary_replica IsPrimary,
       drcs.is_failover_ready AS FailoverReady,
       rs.last_received_lsn,
       rs.last_hardened_lsn,
       rs.last_redone_lsn,
       rs.end_of_log_lsn,
       rs.last_commit_lsn
FROM sys.availability_replicas r
    INNER JOIN sys.dm_hadr_database_replica_states rs
        ON r.replica_id = rs.replica_id
    INNER JOIN sys.dm_hadr_database_replica_cluster_states AS drcs
        ON r.replica_id = drcs.replica_id
ORDER BY Replica;

/*

-- Health and status of WSFC cluster. These two queries work only if the WSFC has quorum
SELECT *
FROM sys.dm_hadr_cluster;
SELECT *
FROM sys.dm_hadr_cluster_members;

-- Health of the AGs
SELECT ag.name agname,
       ags.*
FROM sys.dm_hadr_availability_group_states ags
    INNER JOIN sys.availability_groups ag
        ON ag.group_id = ags.group_id;

-- Health and status of AG replics from the WsFC perspective
SELECT harc.replica_server_name,
       harc.*
FROM sys.dm_hadr_availability_replica_cluster_states harc
    INNER JOIN sys.availability_replicas ar
        ON ar.replica_id = harc.replica_id;

-- Health and status of AG replicas, run this on the primary replica. 
-- On secondary this will only show info for that instance
SELECT *
FROM sys.dm_hadr_availability_replica_states;

-- Health and status of AG databases from the WSFC perspective
SELECT *
FROM sys.dm_hadr_database_replica_cluster_states;


SELECT replica_id,
       database_name,
       is_failover_ready
FROM sys.dm_hadr_database_replica_cluster_states;

*/