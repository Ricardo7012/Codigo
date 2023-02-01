/********************************************************************
RUN IN POWERSHELL
CLS
Get-winEvent -ComputerName PVLISEDI01 -filterHashTable @{logname ='Microsoft-Windows-FailoverClustering/Operational'; id=1641}| ft -AutoSize -Wrap 
**********************************************************************/

SELECT NodeName,
	STATUS AS NodeStatus,
	status_description AS NodeStatusDescription,
	is_current_owner AS CurrentlyActiveNode
FROM sys.dm_os_cluster_nodes

SELECT ar.replica_server_name, 
    database_name,
	ar.availability_mode_desc,
	ar.failover_mode_desc,
	is_failover_ready
FROM sys.dm_hadr_database_replica_cluster_states as a
 INNER JOIN sys.availability_replicas AS ar 
	ON ar.replica_id = a.replica_id  
WHERE a.replica_id IN (
		SELECT replica_id
		FROM sys.dm_hadr_availability_replica_states
		)
GO
--CHECK ERRORLOG LAST 3 DAYS 
sp_readerrorlog 0,1, 'RESOLVING'
go
sp_readerrorlog 1,1, 'RESOLVING'
go
sp_readerrorlog 2,1, 'RESOLVING'
go
sp_readerrorlog 3,1, 'RESOLVING'
GO
select * from sys.dm_hadr_availability_group_states
GO
select * from sys.dm_tcp_listener_states
GO

IF SERVERPROPERTY ('IsHadrEnabled') = 1
BEGIN
SELECT
   AGC.name -- Availability Group
 , RCS.replica_server_name -- SQL cluster node name
 , ARS.role_desc  -- Replica Role
 , AGL.dns_name  -- Listener Name
FROM
 sys.availability_groups_cluster AS AGC
  INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS RCS
   ON
    RCS.group_id = AGC.group_id
  INNER JOIN sys.dm_hadr_availability_replica_states AS ARS
   ON
    ARS.replica_id = RCS.replica_id
  INNER JOIN sys.availability_group_listeners AS AGL
   ON
    AGL.group_id = ARS.group_id
WHERE
 ARS.role_desc = 'PRIMARY'
END

