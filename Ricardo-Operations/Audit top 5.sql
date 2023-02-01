-- https://www.idera.com/resourcecentral/whitepapers/top-5-items-to-audit-in-sql-server/thankyou
-- https://www.idera.com/resourcecentral/whitepapers/protecting-personally-identifiable-information-in-databases 

USE HSP_Supplemental;
GO

SELECT name
     , is_disabled
FROM sys.sql_logins
WHERE principal_id = 1;

SELECT R.name AS 'Role'
     , L.name AS 'Login'
FROM sys.server_principals       AS L
    JOIN sys.server_role_members AS RM
        ON L.principal_id = RM.member_principal_id
    JOIN sys.server_principals   AS R
        ON R.principal_id = RM.role_principal_id
WHERE R.name IN ( 'sysadmin', 'securityadmin' )
ORDER BY R.name
       , L.name;


-- For the codes used in class and type
-- See the Books Online entry for sys.server_permissions
SELECT L.name
     , P.state_desc
     , P.permission_name
FROM sys.server_permissions    AS P
    JOIN sys.server_principals AS L
        ON P.grantee_principal_id = L.principal_id
WHERE P.class = 100
      --WHERE P.class = 0 
      AND P.type = 'CL'
ORDER BY L.name;

-- For the codes used in class and type
-- See the Books Online entry for sys.server_permissions
SELECT L.name
     , P.state_desc
     , P.permission_name
     , I.name
FROM sys.server_permissions    AS P
    JOIN sys.server_principals AS L
        ON P.grantee_principal_id = L.principal_id
    JOIN sys.server_principals AS I
        ON P.major_id = I.principal_id
WHERE P.class = 101
      AND P.type = 'IM'
ORDER BY L.name
       , I.name;


SELECT D.name AS 'Database'
     , L.name AS 'Owner'
FROM sys.databases                  AS D
    LEFT JOIN sys.server_principals AS L
        ON D.owner_sid = L.sid
ORDER BY D.name;


SELECT U.name AS 'User'
     , R.name AS 'ROLE'
FROM sys.database_principals       AS U
    JOIN sys.database_role_members AS RM
        ON U.principal_id = RM.member_principal_id
    JOIN sys.database_principals   AS R
        ON R.principal_id = RM.role_principal_id
WHERE R.name = 'db_owner'
ORDER BY U.name;

SELECT U.name
     , P.state_desc
     , P.permission_name
FROM sys.database_permissions    AS P
    JOIN sys.database_principals AS U
        ON P.grantee_principal_id = U.principal_id
WHERE P.class = 0
      AND NOT P.type = 'CO' -- Excluding Connect permission
ORDER BY U.name
       , P.permission_name;


SELECT U.name AS 'User'
     , P.state_desc
     , P.permission_name
     , S.name AS 'Schema'
FROM sys.database_permissions    AS P
    JOIN sys.database_principals AS U
        ON P.grantee_principal_id = U.principal_id
    JOIN sys.schemas             AS S
        ON P.major_id = S.schema_id
WHERE P.class = 3
ORDER BY U.name
       , S.name;



SELECT U.name                AS 'USER'
     , P.state_desc
     , P.permission_name
     , S.name + '.' + O.name AS 'Object'
FROM sys.database_permissions    AS P
    JOIN sys.database_principals AS U
        ON P.grantee_principal_id = U.principal_id
    JOIN sys.objects             AS O
        ON P.major_id = O.object_id
    JOIN sys.schemas             AS S
        ON O.schema_id = S.schema_id
WHERE P.class = 1
ORDER BY U.name
       , O.name
       , P.permission_name;

