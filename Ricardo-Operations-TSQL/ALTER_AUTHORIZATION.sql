-- https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-authorization-transact-sql
SELECT class_desc,
       *
FROM sys.server_permissions
WHERE grantor_principal_id =
(
    SELECT principal_id FROM sys.server_principals WHERE name = N'IEHP\sqladmin9'
);

SELECT name,
       type_desc
FROM sys.server_principals
WHERE principal_id IN (
                          SELECT grantee_principal_id
                          FROM sys.server_permissions
                          WHERE grantor_principal_id =
                          (
                              SELECT principal_id FROM sys.server_principals WHERE name = N'IEHP\sqladmin9'
                          )
                      );


USE master;
SELECT 
 SUSER_NAME(principal_id) AS endpoint_owner
,name AS endpoint_name
FROM sys.database_mirroring_endpoints;


--USE master;
--ALTER AUTHORIZATION ON ENDPOINT::Hadr_endpoint TO _system_admin;

SELECT ar.replica_server_name
	,ag.name AS ag_name
	,ar.owner_sid
	,sp.name
FROM sys.availability_replicas ar
LEFT JOIN sys.server_principals sp
	ON sp.sid = ar.owner_sid 
INNER JOIN sys.availability_groups ag
	ON ag.group_id = ar.group_id
WHERE ar.replica_server_name = SERVERPROPERTY('ServerName') ;

--ALTER AUTHORIZATION ON AVAILABILITY GROUP::QVHAGHSP01 to [_system_admin] ;
