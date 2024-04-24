-- http://www.sqlservercentral.com/blogs/brian_kelley/2013/04/22/troubleshooting-sql-server-error-15517/
-- SQL Server Error 15517
-- Message
-- An exception occurred while enqueueing a message in the target queue. Error: 15517, State: 1. 
-- Cannot execute as the database principal because the principal "dbo" does not exist, this type of principal cannot be impersonated, or you do not have permission.

SELECT d.name AS 'Database', s.name AS 'Owner'
FROM sys.databases d 
  LEFT JOIN sys.server_principals s 
    ON d.owner_sid = s.sid; 

SELECT sp.name AS 'dbo_login', o.name AS 'sysdb_login'
FROM sys.database_principals dp
  LEFT JOIN master.sys.server_principals sp
    ON dp.sid = sp.sid
  LEFT JOIN master.sys.databases d 
    ON DB_ID('Example') = d.database_id
  LEFT JOIN master.sys.server_principals o 
    ON d.owner_sid = o.sid
WHERE dp.name = 'dbo';


EXEC sp_MSForEachDB 
'SELECT ''?'' AS ''DBName'', sp.name AS ''dbo_login'', o.name AS ''sysdb_login''
FROM ?.sys.database_principals dp
  LEFT JOIN master.sys.server_principals sp
    ON dp.sid = sp.sid
  LEFT JOIN master.sys.databases d 
    ON DB_ID(''?'') = d.database_id
  LEFT JOIN master.sys.server_principals o 
    ON d.owner_sid = o.sid
WHERE dp.name = ''dbo'';';
