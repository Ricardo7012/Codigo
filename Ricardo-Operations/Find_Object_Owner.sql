/*HSP1S1A-B-C PATCH WEEKEND FIX*/
-- https://www.mssqltips.com/sqlservertip/5201/drop-login-issues-for-logins-tied-to-sql-server-availability-groups/

SELECT *
FROM sys.server_permissions
WHERE grantor_principal_id =
(
    SELECT principal_id
    FROM sys.server_principals
    WHERE name = N'IEHP\sqladmin5'
);

USE master;
GO
SELECT SUSER_NAME(principal_id) AS endpoint_owner
     , name                     AS endpoint_name
FROM sys.database_mirroring_endpoints;

USE [master];
GO
SELECT ag.[name] AS AG_name
     , ag.group_id
     , r.replica_id
     , r.owner_sid
     , p.[name]  AS owner_name
FROM sys.availability_groups       ag
    JOIN sys.availability_replicas r
        ON ag.group_id = r.group_id
    JOIN sys.server_principals     p
        ON r.owner_sid = p.[sid]
WHERE p.[name] = 'IEHP\sqladmin5';
GO

USE [master];
GO
SELECT pm.class
     , pm.class_desc
     , pm.major_id
     , pm.minor_id
     , pm.grantee_principal_id
     , pm.grantor_principal_id
     , pm.[type]
     , pm.[permission_name]
     , pm.[state]
     , pm.state_desc
     , pr.[name] AS [owner]
     , gr.[name] AS grantee
FROM sys.server_permissions    pm
    JOIN sys.server_principals pr
        ON pm.grantor_principal_id = pr.principal_id
    JOIN sys.server_principals gr
        ON pm.grantee_principal_id = gr.principal_id
WHERE pr.[name] = N'IEHP\sqladmin5';

USE [master];
GO
SELECT [name] AS dbname
FROM sys.databases
WHERE SUSER_SNAME(owner_sid) = 'IEHP\sqladmin5'
GO


--USE [master]
--GO
--SELECT [name] AS dbname FROM sys.databases WHERE SUSER_SNAME(owner_sid) = 'IEHP\sqladmin9'
--GO

--USE master;
--ALTER AUTHORIZATION ON ENDPOINT::Hadr_endpoint TO _system_admin;
--GO
--GRANT CONNECT ON ENDPOINT::Hadr_endpoint TO [_system_admin]
--GO

--USE [master]
--GO
--ALTER AUTHORIZATION ON AVAILABILITY GROUP::PVHAGHSP01 TO _system_admin;
--GO


/*****************************************************************************/
-- HEAPING HEAPS
/*****************************************************************************/
--ALTER TABLE [HSP].[dbo].[Claim_Master] REBUILD;
--ALTER TABLE [HSP].[dbo].[Claim_Details] REBUILD;


/*****************************************************************************/
-- PVSQLFIN01 FIX TEMPDB
/*****************************************************************************/

-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-freeproccache-transact-sql
-- Removes all elements from the plan cache, removes a specific plan from the plan cache by specifying a plan handle 
-- or SQL handle, or removes all cache entries associated with a specified resource pool.

--DBCC FREEPROCCACHE

--USE tempdb;
--GO
--DBCC SHRINKFILE (N'tempdev', EMPTYFILE)

--USE [tempdb]
--GO
--DBCC SHRINKFILE (N'tempdev' , 4096)
--GO

