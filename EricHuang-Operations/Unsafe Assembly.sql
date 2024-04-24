SELECT
who.name AS [Principal Name],
who.type_desc AS [Principal Type],
who.is_disabled AS [Principal Is Disabled],
what.state_desc AS [Permission State],
what.permission_name AS [Permission Name]
FROM
sys.server_permissions what
INNER JOIN sys.server_principals who
ON who.principal_id = what.grantee_principal_id
WHERE
what.permission_name = 'Unsafe assembly'
AND who.name NOT LIKE '##MS%##'
AND who.type_desc <> 'SERVER_ROLE'
ORDER BY
who.name
;
GO

SELECT
what.permission_name AS [Permission Name],
what.state_desc AS [Permission State],
who.name AS [Principal Name],
who.type_desc AS [Principal Type],
who.is_disabled AS [Principal Is Disabled]
FROM
sys.server_permissions what
INNER JOIN sys.server_principals who
ON who.principal_id = what.grantee_principal_id
WHERE
what.permission_name IN
(
'Administer bulk operations',
'Alter any availability group',
'Alter any connection',
'Alter any credential',
'Alter any database',
'Alter any endpoint ',
'Alter any event notification ',
'Alter any event session ',
'Alter any linked server',
'Alter any login',
'Alter any server audit',
'Alter any server role',
'Alter resources',
'Alter server state ',
'Alter Settings ',
'Alter trace',
'Authenticate server ',
'Control server',
'Create any database ',
'Create availability group',
'Create DDL event notification',
'Create endpoint',
'Create server role',
'Create trace event notification',
'External access assembly',
'Shutdown',
'Unsafe Assembly',
'View any database',
'View any definition',
'View server state'
)
AND who.name NOT LIKE '##MS%##'
AND who.type_desc <> 'SERVER_ROLE'
ORDER BY
what.permission_name,
who.name
;
GO

SELECT pr.name, pe.permission_name
FROM sys.server_principals pr
INNER JOIN sys.server_permissions pe
ON pr.principal_id = pe.grantee_principal_id
WHERE pe.permission_name = 'EXTERNAL ACCESS ASSEMBLY'

--CHECK TRUSTWORHTY
select name,is_trustworthy_on from sys.databases 



select * from sys.assembly_modules


SELECT
        SCHEMA_NAME(O.schema_id) AS [Schema], O.name,
        A.name AS assembly_name, AM.assembly_class, 
        AM.assembly_method,
        A.permission_set_desc,
        O.[type_desc]
FROM
        sys.assembly_modules AM
        INNER JOIN sys.assemblies A ON A.assembly_id = AM.assembly_id
        INNER JOIN sys.objects O ON O.object_id = AM.object_id
ORDER BY
        A.name, AM.assembly_class



SELECT      so.name AS [ObjectName],
            so.[type],
            SCHEMA_NAME(so.[schema_id]) AS [SchemaName],
            asmbly.name AS [AssemblyName],
            asmbly.permission_set_desc,
            am.assembly_class, 
            am.assembly_method
FROM        sys.assembly_modules am
INNER JOIN  sys.assemblies asmbly
        ON  asmbly.assembly_id = am.assembly_id
        AND asmbly.is_user_defined = 1 -- if using SQL Server 2008 or newer
--      AND asmbly.name NOT LIKE 'Microsoft%' -- if using SQL Server 2005
INNER JOIN  sys.objects so
        ON  so.[object_id] = am.[object_id]
UNION ALL
SELECT      at.name AS [ObjectName],
            'UDT' AS [type],
            SCHEMA_NAME(at.[schema_id]) AS [SchemaName], 
            asmbly.name AS [AssemblyName],
            asmbly.permission_set_desc,
            at.assembly_class,
            NULL AS [assembly_method]
FROM        sys.assembly_types at
INNER JOIN  sys.assemblies asmbly
        ON  asmbly.assembly_id = at.assembly_id
        AND asmbly.is_user_defined = 1 -- if using SQL Server 2008 or newer
--      AND asmbly.name NOT LIKE 'Microsoft%' -- if using SQL Server 2005
ORDER BY    [AssemblyName], [type], [ObjectName]



