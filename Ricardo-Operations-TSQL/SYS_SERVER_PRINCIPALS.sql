SELECT name
FROM sys.server_principals
WHERE name LIKE 'iehp\%'
      AND type_desc = 'windows_login'
ORDER BY name ASC;

--FIND OWNER
SELECT [name], SUSER_SNAME(owner_sid) from sys.databases
