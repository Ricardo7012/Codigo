-- Schema Layout

USE master
GO

DECLARE @SQL NVARCHAR(MAX)
DECLARE @Server1 VARCHAR(100)
DECLARE @DB1 VARCHAR(100)
DECLARE @Server2 VARCHAR(100)
DECLARE @DB2 VARCHAR(100)

SET @Server1 = '[DEVWRK02]' + '.'
SET @Server2 = '[DEVWRK02]' + '.'
SET @DB1 = '[Accounting_9_1_SP1_HF3]'
SET @DB2 = '[Accounting_MB]'

SET @SQL = '
SELECT Schema1.DBName,
       Schema1.SchemaName,
       Schema1.TableName,
       Schema1.ColumnName,
       Schema1.name DataType,
       Schema1.Length,
       Schema1.Precision,
       Schema1.Scale,
       Schema1.Is_Identity,
       Schema1.Is_Nullable,
       Schema2.DBName,
       Schema2.SchemaName,
       Schema2.TableName,
       Schema2.ColumnName,
       Schema2.name DataType,
       Schema2.Length,
       Schema2.Precision,
       Schema2.Scale,
       Schema2.Is_Identity,
       Schema2.Is_Nullable
FROM   
    (SELECT ''' + @DB1 + ''' DbName,
		   SCHEMA_NAME(schema_id) SchemaName,
	   	   t.Name TableName,
		   c.Name ColumnName,
		   st.Name,
		   c.Max_Length Length,
		   c.Precision,
		   c.Scale,
		   c.Is_Identity,
		   c.Is_Nullable
	FROM   ' + @Server1 + @DB1 + '.sys.tables t
		   INNER JOIN ' + @Server1 + @DB1 + 
	'.sys.columns c ON t.Object_ID = c.Object_ID
		   INNER JOIN systypes st ON St.xType = c.System_Type_id
	) Schema1 
    FULL OUTER JOIN
	(SELECT ''' + @DB2 + ''' DbName,
		   SCHEMA_NAME(schema_id) SchemaName,
		   t.name TableName,
		   c.name ColumnName,
		   st.Name,
		   c.max_length Length,
		   c.Precision,
		   c.Scale,
		   c.Is_Identity,
		   c.Is_Nullable
	FROM   ' + @Server2 + @DB2 + '.sys.tables t
		   INNER JOIN ' + @Server2 + @DB2 + '.sys.columns c ON t.Object_ID = c.Object_ID
		   INNER JOIN systypes st ON St.xType = c.System_Type_id
	) Schema2
	ON Schema1.TableName = Schema2.TableName
	AND Schema1.ColumnName = Schema2.ColumnName	
ORDER BY  CASE WHEN Schema1.TableName IS NULL THEN 2 ELSE 1 END, Schema1.TableName,
          CASE WHEN Schema1.ColumnName IS NULL THEN 2 ELSE 1 END, Schema1.ColumnName
'

EXEC sp_executesql @SQL
