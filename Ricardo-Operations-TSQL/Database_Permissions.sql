-- https://www.mssqltips.com/sqlservertip/3047/determining-permission-issues-for-a-sql-server-object/ 
-- DETERMINING PERMISSION ISSUES FOR A SQL SERVER OBJECT
--USE HSP_Supplemental
--go
DECLARE @command varchar(1000) 
SELECT @command = 'USE ? SELECT 
	@@servername AS SERVERNAME, 	
	DB_NAME() AS DATABASENAME,
		o.name AS ''Object'',
       u.name AS ''User_or_Role'',
       dp.state_desc,
       dp.permission_name
FROM sys.database_permissions AS dp
    JOIN sys.objects AS o
        ON dp.major_id = o.object_id
    JOIN sys.database_principals AS u
        ON dp.grantee_principal_id = u.principal_id' 
EXEC sp_MSforeachdb @command 

--SELECT 
--	@@servername AS SERVERNAME, 	
--	DB_NAME() AS DATABASENAME,
--		o.name AS 'Object',
--       u.name AS 'User_or_Role',
--       dp.state_desc,
--       dp.permission_name
--FROM sys.database_permissions AS dp
--    JOIN sys.objects AS o
--        ON dp.major_id = o.object_id
--    JOIN sys.database_principals AS u
--        ON dp.grantee_principal_id = u.principal_id
----WHERE dp.class = 1
----      AND o.name = 'IEHP\HSP1DataWriter';
