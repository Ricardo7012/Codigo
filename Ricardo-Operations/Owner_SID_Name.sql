
SELECT d.name, d.owner_sid, sl.name   
FROM sys.databases AS d  
JOIN sys.sql_logins AS sl  
ON d.owner_sid = sl.sid
ORDER BY D.[name]

--SELECT CAST(owner_sid as uniqueidentifier) AS Owner_SID   
SELECT owner_sid
FROM sys.databases   
WHERE name = 'MASTER';  

SELECT SID_BINARY('')

SELECT SUSER_SID('')

SELECT SUSER_SNAME(SUSER_SID('iehp\i4682', 0)); 

SELECT distinct security_id, login_name, sy.name
FROM sys.dm_exec_sessions dms
JOIN sys.sysusers sy ON
dms.security_id = sy.sid
where security_id <> 0x01 

