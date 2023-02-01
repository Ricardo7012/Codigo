--exec sp_who2

SELECT * FROM master.dbo.sysprocesses AS p where loginame = 'IEHP\i4682'

---- Kill all current connections

DECLARE @cmdKill VARCHAR(50)

DECLARE killCursor CURSOR FOR
SELECT 'KILL ' + Convert(VARCHAR(5), p.spid)
FROM master.dbo.sysprocesses AS p
--WHERE p.dbid = db_id('HSP_test3')
WHERE loginame = 'IEHP\i4682'

OPEN killCursor
FETCH killCursor INTO @cmdKill

WHILE 0 = @@fetch_status
BEGIN
EXECUTE (@cmdKill) 
FETCH killCursor INTO @cmdKill
END

CLOSE killCursor
DEALLOCATE killCursor 


SELECT * FROM master.dbo.sysprocesses AS p where loginame = 'IEHP\i4682'
USE [HSP]
GO
DROP USER [IEHP\i4682]
GO
USE [HSPLicensing]
GO
DROP USER [IEHP\i4682]
GO
USE [master]
GO
DROP LOGIN [IEHP\i4682]
GO

