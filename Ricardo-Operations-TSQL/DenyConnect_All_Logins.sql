SELECT 'ALTER LOGIN ' + QUOTENAME(sp.name) + ' DISABLE;'
FROM sys.server_principals sp
WHERE sp.principal_id > 100
    AND sp.is_disabled = 0
    AND sp.type IN (
        'U' -- Windows user
        , 'G' -- Windows Group
        , 'S' -- SQL user
        );

SELECT 'DENY CONNECT SQL TO ' + QUOTENAME(sp.name) +';'
FROM sys.server_principals sp
WHERE sp.principal_id > 100
    AND sp.is_disabled = 0
    AND sp.type IN (
        'U' -- Windows user
        , 'G' -- Windows Group
        , 'S' -- SQL user
        );
