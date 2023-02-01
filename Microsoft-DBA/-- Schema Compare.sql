-- Schema Compare

USE master
GO

DECLARE @SQL NVARCHAR(MAX)
DECLARE @Server1 VARCHAR(100)
DECLARE @DB1 VARCHAR(100)
DECLARE @Server2 VARCHAR(100)
DECLARE @DB2 VARCHAR(100)

SET @Server1 = '[DEVWRK02]' + '.'
SET @Server2 = '[DEVWRK02]' + '.'

SET @DB1 = '[Accounting_9_1_SP4]'
SET @DB2 = '[MC]'


SET @SQL = 'SELECT Schema1.DBName AS ''DB Name'',
       Schema1.SchemaName AS ''Schema Name'',
       Schema1.TableName AS ''Table Name'',
       Schema2.DBName AS ''DB Name'',
       Schema2.SchemaName AS ''Schema Name'',
       Schema2.TableName AS ''Table Name''
FROM   
    (SELECT ''' + @DB1 + ''' DbName,
		   SCHEMA_NAME(schema_id) SchemaName,
	   	   t.Name TableName
	FROM   ' + @Server1 + @DB1 + '.sys.tables t
	) Schema1 
    FULL OUTER JOIN
	(SELECT ''' + @DB2 + ''' DbName,
		   SCHEMA_NAME(schema_id) SchemaName,
		   t.name TableName
	FROM   ' + @Server2 + @DB2 + '.sys.tables t
	) Schema2
	ON Schema1.TableName = Schema2.TableName
	ORDER BY Schema2.TableName'

EXEC sp_executesql @SQL
