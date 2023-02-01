--EXEC master..sp_helplogins
--EXEC master..sp_helpsrvrolemember
DECLARE @name sysname,
@sql nvarchar(4000),
@maxlen1 smallint,
@maxlen2 smallint,
@maxlen3 smallint

IF EXISTS (SELECT TABLE_NAME FROM tempdb.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE '#tmpTable%')
DROP TABLE #tmpTable

CREATE TABLE #tmpTable 
(
DBName sysname NOT NULL ,
UserName sysname NOT NULL,
RoleName sysname NOT NULL
)

DECLARE c1 CURSOR for 
SELECT name FROM master.sys.databases

OPEN c1
FETCH c1 INTO @name
WHILE @@FETCH_STATUS >= 0
BEGIN
SELECT @sql = 
'INSERT INTO #tmpTable
SELECT N'''+ @name + ''', a.name, c.name
FROM [' + @name + '].sys.database_principals a 
JOIN [' + @name + '].sys.database_role_members b ON b.member_principal_id = a.principal_id
JOIN [' + @name + '].sys.database_principals c ON c.principal_id = b.role_principal_id
WHERE a.name != ''dbo'''
EXECUTE (@sql)
FETCH c1 INTO @name
END
CLOSE c1
DEALLOCATE c1

SELECT @maxlen1 = (MAX(LEN(COALESCE(DBName, 'NULL'))) + 2)
FROM #tmpTable

SELECT @maxlen2 = (MAX(LEN(COALESCE(UserName, 'NULL'))) + 2)
FROM #tmpTable

SELECT @maxlen3 = (MAX(LEN(COALESCE(RoleName, 'NULL'))) + 2)
FROM #tmpTable

SET @sql = 'SELECT LEFT(DBName, ' + LTRIM(STR(@maxlen1)) + ') AS ''DB Name'', '
SET @sql = @sql + 'LEFT(UserName, ' + LTRIM(STR(@maxlen2)) + ') AS ''User Name'', '
SET @sql = @sql + 'LEFT(RoleName, ' + LTRIM(STR(@maxlen3)) + ') AS ''Role Name'' '
SET @sql = @sql + 'FROM #tmpTable '
SET @sql = @sql + 'ORDER BY DBName, UserName'
EXEC(@sql)
