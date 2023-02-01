-- Kill SPID by Database

USE master
GO

DECLARE @kill VARCHAR(8000) = '';

SELECT @kill = @kill + 'Kill ' + CONVERT(VARCHAR(5), spid) + ';'
FROM master..sysprocesses
WHERE dbid = db_id('Accounting')

EXEC (@kill);
