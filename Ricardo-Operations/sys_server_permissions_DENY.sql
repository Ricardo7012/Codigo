--GRANT CONNECT SQL TO [IEHP\i2494]

SELECT SUSER_NAME() AS LN
SELECT DISTINCT name, usage FROM sys.login_token
WHERE type ='WINDOWS GROUP'
GO

SELECT * FROM sys.server_permissions WHERE type = 'COSQ' OR class = 105
GO

SELECT sp.[name]
     , sp.type_desc
FROM sys.server_principals            sp
    INNER JOIN sys.server_permissions PERM
        ON sp.principal_id = PERM.grantee_principal_id
WHERE PERM.state_desc = 'DENY';

SELECT * FROM sys.database_principals ORDER BY name


