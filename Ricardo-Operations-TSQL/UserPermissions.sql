USE HSP;
GO

----TABLES TO COMPARE
----#1
--SELECT  permission_name ,
--        state_desc ,
--        type_desc ,
--        U.name ,
--        OBJECT_NAME(major_id) AS ObjectName
--FROM    sys.database_permissions P
--        JOIN sys.tables T ON P.major_id = T.object_id
--        JOIN sysusers U ON U.uid = P.grantee_principal_id
--WHERE   OBJECT_NAME(major_id) = 'Fame_Archive2016';
----#2
--SELECT  permission_name ,
--        state_desc ,
--        type_desc ,
--        U.name ,
--        OBJECT_NAME(major_id) AS ObjectName
--FROM    sys.database_permissions P
--        JOIN sys.tables T ON P.major_id = T.object_id
--        JOIN sysusers U ON U.uid = P.grantee_principal_id
--WHERE   OBJECT_NAME(major_id) = 'Fame_Archive2017';

----Database user and role memberships (if any).
SELECT  u.name ,
        r.name
FROM    sys.database_principals u
        LEFT JOIN sys.database_role_members rm ON rm.member_principal_id = u.principal_id
        LEFT JOIN sys.database_principals r ON r.principal_id = rm.role_principal_id
WHERE   u.type != 'R'
        AND u.[name] = 'IEHP\NDReadOnly';
GO

--Individual GRANTs and DENYs.
SELECT  prin.[name] [User] ,
        sec.state_desc + ' ' + sec.permission_name [Permission] ,
        sec.class_desc Class ,
        OBJECT_NAME(sec.major_id) [Securable] ,
        sec.major_id [Securible_Id]
FROM    [sys].[database_permissions] sec
        JOIN [sys].[database_principals] prin ON sec.[grantee_principal_id] = prin.[principal_id]
WHERE   prin.[name] = 'IEHP\NDReadOnly'
ORDER BY [User] ,
        [Permission];
GO
