-- Calculates the Dependencies Between Database Tables

DECLARE @crlf VARCHAR(2)

SET @crlf = CHAR(13) + CHAR(10)

-- 1. Get the tables that we want to clear data from. We're restricting ourselves
-- to a single schema here. To support multiple schemata we'd need to track 
-- schema names along with table names. Is it common to have foreign key 
-- constraints between tables belonging to different schemata?

DECLARE @Table TABLE (
	TableName NVARCHAR(128)
	, Depth INT NULL
	)

INSERT @Table (TableName)
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'

-- Add additional filtering here to exclude certain tables, e.g. read-only 
-- 'reference' data, logs etc.
-- 2. Get the dependencies between the tables 

DECLARE @Dependency TABLE (
	ConstraintName NVARCHAR(128)
	, FKTableName NVARCHAR(128)
	, PKTableName NVARCHAR(128)
	)

INSERT @Dependency
SELECT rc.CONSTRAINT_NAME
	, pkccu.TABLE_Name AS PKTableName
	, fkccu.TABLE_NAME AS FKTableName
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE fkccu
	ON rc.UNIQUE_CONSTRAINT_NAME = fkccu.CONSTRAINT_NAME
INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE pkccu
	ON rc.CONSTRAINT_NAME = pkccu.CONSTRAINT_NAME
WHERE fkccu.TABLE_NAME IN (
		SELECT TableName
		FROM @Table
		)
	AND pkccu.TABLE_NAME IN (
		SELECT TableName
		FROM @Table
		)
	AND pkccu.TABLE_SCHEMA = 'dbo'
	AND fkccu.TABLE_SCHEMA = 'dbo'

-- 3. Define delete order so that tables are deleted before tables that 
-- they depend on

DECLARE @Depth INT
	, @Complete BIT

SET @Depth = 0
SET @Complete = 0

WHILE @Complete = 0
BEGIN
	UPDATE t
	SET Depth = @Depth
	FROM @Table t
	WHERE [Depth] IS NULL
		AND NOT EXISTS (
			SELECT 1
			FROM @Dependency r
			INNER JOIN @Table t2
				ON r.FKTableName = t2.TableName
			WHERE PKTableName = t.TableName
				AND t2.Depth IS NULL
			)

	IF @@ROWCOUNT = 0
		SET @Complete = 1
	SET @Depth = @Depth + 1
END

DECLARE @Warning VARCHAR(max)

SET @Warning = 'WARNING: Unable to establish delete order for this table. ' + 'Possible conflicting constraints are listed in the next result set.'

-- 4. Select our results. 

SELECT TableName
	, Depth
	, CASE 
		WHEN Depth IS NULL
			THEN @Warning
		ELSE ''
		END AS 'Notes'
	, 'DELETE FROM [dbo].[' + TableName + ']' AS 'DeleteStatement'
FROM @Table
WHERE [@Table].TableName NOT LIKE 'View_%'
ORDER BY ISNULL(Depth, - 1), TableName

-- 5. Select foreign keys that prevent us from ordering tables

IF EXISTS (
		SELECT 1
		FROM @Table
		WHERE Depth IS NULL
		)
	SELECT *
		, CASE 
			WHEN PKTableName = FKTableName
				THEN 'Self - Referencing foreign key constraint'
			WHEN EXISTS (
					SELECT *
					FROM @Dependency d2
					WHERE d2.PKTableName = d.FKTableName
						AND d2.FKTableName = d.PKTableName
					)
				THEN 'Mutually dependent foreign key constraints on these tables'
			ELSE ''
			END AS Warning
	FROM @Dependency d
	WHERE PKTableName IN (
			SELECT TableName
			FROM @Table
			WHERE Depth IS NULL
			)
		AND FKTableName IN (
			SELECT TableName
			FROM @Table
			WHERE Depth IS NULL
			)
	ORDER BY Warning DESC
	
-- 6. What you do from here is up to you. If you have a simple schema you could 
-- execute the delete statements directly:
/*
if not exists (select 1 from @Table where Depth is null)
begin
	declare @sql varchar(max)
	set @sql = ''
	select @sql=@sql+'delete from [dbo].[' + TableName + ']' + @crlf
	from @Table
	order by Depth, TableName
	print 'Executing SQL:' + @crlf + @sql
	execute(@sql)
end
*/
-- In more complex cases you might need to copy the delete statements from 
-- the results window and add some additional filtering or deal manually with 
-- self-referencing constraints etc.
