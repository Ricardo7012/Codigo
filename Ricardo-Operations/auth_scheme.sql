SELECT auth_scheme
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;

select * from sys.server_permissions

select * from sys.server_principals