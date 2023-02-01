SELECT * from master.sys.sql_logins
SELECT * from master.sys.sysusers

--GET THE LIST OF ALL LOGIN ACCOUNTS IN A SQL SERVER
SELECT name AS Login_Name, type_desc AS Account_Type
FROM sys.server_principals 
WHERE TYPE IN ('U', 'S', 'G')
and name not like '%##%'
ORDER BY name, type_desc

--GET THE LIST OF ALL SQL LOGIN ACCOUNTS ONLY
SELECT name
FROM sys.server_principals 
WHERE TYPE = 'S'
and name not like '%##%'

--GET THE LIST OF ALL WINDOWS LOGIN ACCOUNTS ONly
SELECT name
FROM sys.server_principals 
WHERE TYPE = 'U'

--GET THE LIST OF ALL WINDOWS GROUP LOGIN ACCOUNTS ONLY
SELECT name
FROM sys.server_principals 
WHERE TYPE = 'G'