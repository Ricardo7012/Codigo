SELECT LOGINPROPERTY('SQLBatchLoadUser', 'PasswordLastSetTime') ; -- 2017-08-22 13:49:01.007

SELECT * FROM master.dbo.syslogins
WHERE name = 'SQLBatchLoadUser'
