SELECT AG.name                               AS [AvailabilityGroupName]
     , ISNULL(agstates.primary_replica, '')  AS [PrimaryReplicaServerName]
     , ISNULL(arstates.role, 3)              AS [LocalReplicaRole]
     , dbcs.database_name                    AS [DatabaseName]
     , ISNULL(dbrs.synchronization_state, 0) AS [SynchronizationState]
     , ISNULL(dbrs.is_suspended, 0)          AS [IsSuspended]
     , ISNULL(dbcs.is_database_joined, 0)    AS [IsJoined]
FROM master.sys.availability_groups                               AS AG
    LEFT OUTER JOIN master.sys.dm_hadr_availability_group_states  AS agstates
        ON AG.group_id = agstates.group_id
    INNER JOIN master.sys.availability_replicas                   AS AR
        ON AG.group_id = AR.group_id
    INNER JOIN master.sys.dm_hadr_availability_replica_states     AS arstates
        ON AR.replica_id = arstates.replica_id
           AND arstates.is_local = 1
    INNER JOIN master.sys.dm_hadr_database_replica_cluster_states AS dbcs
        ON arstates.replica_id = dbcs.replica_id
    LEFT OUTER JOIN master.sys.dm_hadr_database_replica_states    AS dbrs
        ON dbcs.replica_id = dbrs.replica_id
           AND dbcs.group_database_id = dbrs.group_database_id
ORDER BY AG.name ASC
       , dbcs.database_name;
