-- Compare Schema in Different Databases

USE master
GO

DECLARE @Server1 VARCHAR(100) = '[Server1].';--include a dot at the end
DECLARE @DB1 VARCHAR(100) = '[Database1]';
DECLARE @Server2 VARCHAR(100) = '[Server2].';--include a dot at the end
DECLARE @DB2 VARCHAR(100) = '[Database2]';
DECLARE @SQL NVARCHAR(MAX);

SET @SQL =

'SELECT Schema1.DBName
	, Schema1.SchemaName
	, Schema1.TableName
	, Schema1.ColumnName
	, Schema1.NAME DataType
	, Schema1.Length
	, Schema1.Precision
	, Schema1.Scale
	, Schema1.Is_Identity
	, Schema1.Is_Nullable
	, Schema2.DBName
	, Schema2.SchemaName
	, Schema2.TableName
	, Schema2.ColumnName
	, Schema2.NAME DataType
	, Schema2.Length
	, Schema2.Precision
	, Schema2.Scale
	, Schema2.Is_Identity
	, Schema2.Is_Nullable
FROM (
	SELECT ''' + @DB1 + ''' DbName
		, SCHEMA_NAME(schema_id) SchemaName
		, t.NAME TableName
		, c.NAME ColumnName
		, st.NAME
		, c.Max_Length Length
		, c.Precision
		, c.Scale
		, c.Is_Identity
		, c.Is_Nullable
	FROM ' + @Server1 + @DB1 + '.sys.tables t
	INNER JOIN ' + @Server1 + @DB1 + '.sys.columns c
		ON t.Object_ID = c.Object_ID
	INNER JOIN systypes st
		ON St.xType = c.System_Type_id
	) Schema1
FULL JOIN (
	SELECT ''' + @DB2 + ''' DbName
		, SCHEMA_NAME(schema_id) SchemaName
		, t.NAME TableName
		, c.NAME ColumnName
		, st.NAME
		, c.max_length Length
		, c.Precision
		, c.Scale
		, c.Is_Identity
		, c.Is_Nullable
	FROM ' + @Server2 + @DB2 + '.sys.tables t
	INNER JOIN ' + @Server2 + @DB2 + '.sys.columns c
		ON t.Object_ID = c.Object_ID
	INNER JOIN systypes st
		ON St.xType = c.System_Type_id
	) Schema2
	ON Schema1.TableName = Schema2.TableName
		AND Schema1.ColumnName = Schema2.ColumnName
ORDER BY CASE 
		WHEN Schema1.TableName IS NULL
			THEN 2
		ELSE 1
		END
	, Schema1.TableName
	, CASE 
		WHEN Schema1.ColumnName IS NULL
			THEN 2
		ELSE 1
		END
	, Schema1.ColumnName'

EXEC sp_executesql @SQL
