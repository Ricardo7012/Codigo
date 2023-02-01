-- Check for Open Transaction

DECLARE @SQLScript NVARCHAR(MAX)

SELECT @SQLScript = ISNULL(@SQLScript, '') + 'DBCC OPENTRAN(' + NAME + ');'
FROM sys.databases

EXEC (@SQLScript)