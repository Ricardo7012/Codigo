USE HSP
GO

/******************************************************************************
(Script DB Level Permissions and Logins v3.sql)

This script will script the role members for all roles on the database.

This is useful for scripting permissions before restoring.  
This will allow us to easily ensure permissions are not lost during a restoration. 
******************************************************************************/

DECLARE @sql VARCHAR(2048),
        @sort INT;

DECLARE tmp CURSOR FOR


/*********************************************/
/*********   DB CONTEXT STATEMENT    *********/
/*********************************************/
SELECT '-- [-- DB CONTEXT --] --' AS [-- SQL STATEMENTS --],
       1 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT 'USE' + SPACE(1) + QUOTENAME(DB_NAME()) AS [-- SQL STATEMENTS --],
       1.1 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT '' AS [-- SQL STATEMENTS --],
       2 AS [-- RESULT ORDER HOLDER --]
UNION

/*********************************************/
/*********     DB USER CREATION      *********/
/*********************************************/

SELECT '-- [-- DB USERS --] --' AS [-- SQL STATEMENTS --],
       3 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE
           WHEN rm.authentication_type IN ( 2, 0 ) /* 2=contained database user with password, 0 =user without login; create users without logins*/ THEN
    ('IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] = ' + SPACE(1) + '''' + [name] + ''''
     + ') BEGIN CREATE USER ' + SPACE(1) + QUOTENAME([name]) + ' WITHOUT LOGIN WITH DEFAULT_SCHEMA = '
     + QUOTENAME([default_schema_name]) + SPACE(1) + ', SID = ' + CONVERT(VARCHAR(1000), sid, 1) + SPACE(1) + ' END; '
    )
           ELSE
    ('IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] = ' + SPACE(1) + '''' + [name] + ''''
     + ') BEGIN CREATE USER ' + SPACE(1) + QUOTENAME([name]) + ' FOR LOGIN ' + QUOTENAME(SUSER_SNAME([sid]))
     + ' WITH DEFAULT_SCHEMA = ' + QUOTENAME(ISNULL([default_schema_name], 'dbo')) + SPACE(1) + 'END; '
    )
       END AS [-- SQL STATEMENTS --],
       3.1 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_principals AS rm
WHERE [type] IN ( 'U', 'S', 'G' ) -- windows users, sql users, windows groups

UNION

/*********************************************/
/*********    MAP ORPHANED USERS     *********/
/*********************************************/

SELECT '-- [-- ORPHANED USERS --] --' AS [-- SQL STATEMENTS --],
       4 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT 'ALTER USER [' + rm.name + '] WITH LOGIN = [' + rm.name + ']',
       4.1 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_principals AS rm
    INNER JOIN sys.server_principals AS sp
        ON rm.name = sp.name
           AND rm.sid <> sp.sid
WHERE rm.[type] IN ( 'U', 'S', 'G' ) -- windows users, sql users, windows groups
      AND rm.name NOT IN ( 'dbo', 'guest', 'INFORMATION_SCHEMA', 'sys', 'MS_DataCollectorInternalUser' )
UNION

/*********************************************/
/*********    DB ROLE PERMISSIONS    *********/
/*********************************************/
SELECT '-- [-- DB ROLES --] --' AS [-- SQL STATEMENTS --],
       5 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT 'EXEC sp_addrolemember @rolename =' + SPACE(1) + QUOTENAME(USER_NAME(rm.role_principal_id), '''')
       + ', @membername =' + SPACE(1) + QUOTENAME(USER_NAME(rm.member_principal_id), '''') AS [-- SQL STATEMENTS --],
       5.1 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_role_members AS rm
WHERE USER_NAME(rm.member_principal_id) IN (
                                               --get user names on the database
                                               SELECT [name]
                                               FROM sys.database_principals
                                               WHERE [principal_id] > 4 -- 0 to 4 are system users/schemas
                                                     AND [type] IN ( 'G', 'S', 'U' ) -- S = SQL user, U = Windows user, G = Windows group
                                           )
--ORDER BY rm.role_principal_id ASC


UNION
SELECT '' AS [-- SQL STATEMENTS --],
       7 AS [-- RESULT ORDER HOLDER --]
UNION

/*********************************************/
/*********  OBJECT LEVEL PERMISSIONS *********/
/*********************************************/
SELECT '-- [-- OBJECT LEVEL PERMISSIONS --] --' AS [-- SQL STATEMENTS --],
       7.1 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE
           WHEN perm.state <> 'W' THEN
               perm.state_desc
           ELSE
               'GRANT'
       END + SPACE(1) + perm.permission_name + SPACE(1) + 'ON ' + QUOTENAME(SCHEMA_NAME(obj.schema_id)) + '.'
       + QUOTENAME(obj.name) --select, execute, etc on specific objects
       + CASE
             WHEN cl.column_id IS NULL THEN
                 SPACE(0)
             ELSE
                 '(' + QUOTENAME(cl.name) + ')'
         END + SPACE(1) + 'TO' + SPACE(1) + QUOTENAME(USER_NAME(usr.principal_id)) COLLATE DATABASE_DEFAULT
       + CASE
             WHEN perm.state <> 'W' THEN
                 SPACE(0)
             ELSE
                 SPACE(1) + 'WITH GRANT OPTION'
         END AS [-- SQL STATEMENTS --],
       7.2 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_permissions AS perm
    INNER JOIN sys.objects AS obj
        ON perm.major_id = obj.[object_id]
    INNER JOIN sys.database_principals AS usr
        ON perm.grantee_principal_id = usr.principal_id
    LEFT JOIN sys.columns AS cl
        ON cl.column_id = perm.minor_id
           AND cl.[object_id] = perm.major_id
--WHERE usr.name = @OldUser
--ORDER BY perm.permission_name ASC, perm.state_desc ASC


UNION

/*********************************************/
/*********  TYPE LEVEL PERMISSIONS *********/
/*********************************************/
SELECT '-- [-- TYPE LEVEL PERMISSIONS --] --' AS [-- SQL STATEMENTS --],
       8 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE
           WHEN perm.state <> 'W' THEN
               perm.state_desc
           ELSE
               'GRANT'
       END + SPACE(1) + perm.permission_name + SPACE(1) + 'ON ' + QUOTENAME(SCHEMA_NAME(tp.schema_id)) + '.'
       + QUOTENAME(tp.name) --select, execute, etc on specific objects
       + SPACE(1) + 'TO' + SPACE(1) + QUOTENAME(USER_NAME(usr.principal_id)) COLLATE DATABASE_DEFAULT
       + CASE
             WHEN perm.state <> 'W' THEN
                 SPACE(0)
             ELSE
                 SPACE(1) + 'WITH GRANT OPTION'
         END AS [-- SQL STATEMENTS --],
       8.1 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_permissions AS perm
    INNER JOIN sys.types AS tp
        ON perm.major_id = tp.user_type_id
    INNER JOIN sys.database_principals AS usr
        ON perm.grantee_principal_id = usr.principal_id
UNION
SELECT '' AS [-- SQL STATEMENTS --],
       9 AS [-- RESULT ORDER HOLDER --]
UNION

/*********************************************/
/*********    DB LEVEL PERMISSIONS   *********/
/*********************************************/
SELECT '-- [--DB LEVEL PERMISSIONS --] --' AS [-- SQL STATEMENTS --],
       10 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE
           WHEN perm.state <> 'W' THEN
               perm.state_desc --W=Grant With Grant Option
           ELSE
               'GRANT'
       END + SPACE(1) + perm.permission_name --CONNECT, etc
       + SPACE(1) + 'TO' + SPACE(1) + '[' + USER_NAME(usr.principal_id) + ']' COLLATE DATABASE_DEFAULT --TO <user name>
       + CASE
             WHEN perm.state <> 'W' THEN
                 SPACE(0)
             ELSE
                 SPACE(1) + 'WITH GRANT OPTION'
         END AS [-- SQL STATEMENTS --],
       10.1 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_permissions AS perm
    INNER JOIN sys.database_principals AS usr
        ON perm.grantee_principal_id = usr.principal_id
--WHERE usr.name = @OldUser

WHERE [perm].[major_id] = 0
      AND [usr].[principal_id] > 4 -- 0 to 4 are system users/schemas
      AND [usr].[type] IN ( 'G', 'S', 'U' ) -- S = SQL user, U = Windows user, G = Windows group

UNION
SELECT '' AS [-- SQL STATEMENTS --],
       11 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT '-- [--DB LEVEL SCHEMA PERMISSIONS --] --' AS [-- SQL STATEMENTS --],
       12 AS [-- RESULT ORDER HOLDER --]
UNION
SELECT CASE
           WHEN perm.state <> 'W' THEN
               perm.state_desc --W=Grant With Grant Option
           ELSE
               'GRANT'
       END + SPACE(1) + perm.permission_name --CONNECT, etc
       + SPACE(1) + 'ON' + SPACE(1) + class_desc + '::' COLLATE DATABASE_DEFAULT --TO <user name>
       + QUOTENAME(SCHEMA_NAME(major_id)) + SPACE(1) + 'TO' + SPACE(1)
       + QUOTENAME(USER_NAME(grantee_principal_id)) COLLATE DATABASE_DEFAULT + CASE
                                                                                   WHEN perm.state <> 'W' THEN
                                                                                       SPACE(0)
                                                                                   ELSE
                                                                                       SPACE(1) + 'WITH GRANT OPTION'
                                                                               END AS [-- SQL STATEMENTS --],
       12.1 AS [-- RESULT ORDER HOLDER --]
FROM sys.database_permissions AS perm
    INNER JOIN sys.schemas s
        ON perm.major_id = s.schema_id
    INNER JOIN sys.database_principals dbprin
        ON perm.grantee_principal_id = dbprin.principal_id
WHERE class = 3 --class 3 = schema
ORDER BY [-- RESULT ORDER HOLDER --];


OPEN tmp;
FETCH NEXT FROM tmp
INTO @sql,
     @sort;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @sql;
    FETCH NEXT FROM tmp
    INTO @sql,
         @sort;
END;

CLOSE tmp;
DEALLOCATE tmp;