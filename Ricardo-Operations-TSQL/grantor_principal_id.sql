--sys.sp_helplogins 'iehp\sqladmin9'; 
--GO
SELECT  *
FROM    sys.server_permissions
WHERE   grantor_principal_id = ( SELECT principal_id
                                 FROM   sys.server_principals
                                 WHERE  name = N'IEHP\'
                               );

SELECT  class_desc
       ,*
FROM    sys.server_permissions
WHERE   grantor_principal_id = ( SELECT principal_id
                                 FROM   sys.server_principals
                                 WHERE  name = N'IEHP\'
                               );

SELECT  name
       ,type_desc
FROM    sys.server_principals
WHERE   principal_id IN (
        SELECT  grantee_principal_id
        FROM    sys.server_permissions
        WHERE   grantor_principal_id = ( SELECT principal_id
                                         FROM   sys.server_principals
                                         WHERE  name = N'IEHP\'
                                       ) );
GO
REVOKE CONNECT ON ENDPOINT::[hadr_endpoint] TO [IEHP\]
GO

sys.sp_who2


