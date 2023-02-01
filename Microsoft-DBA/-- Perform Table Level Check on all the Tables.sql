-- Perform Table Level Check on all the Tables

SET NOCOUNT ON;
SET ANSI_PADDING ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

-- declare table to store table names
-- in SQL 2005 you can use table variables
-- if you do not need or want to store the data you can store it in a table
-- variable instead of a temporary table
DECLARE @tablenames TABLE (TableName VARCHAR(255));

-- populate table with tablenames
INSERT INTO @tablenames
SELECT NAME
FROM sys.objects
-- additional filters can be set to narrow table selection
WHERE ([type] = N'U');

-- Declare a cursor to loop through table
DECLARE tablenames INSENSITIVE SCROLL CURSOR
FOR
SELECT TableName
FROM @tablenames;

-- Open the cursor.
OPEN tablenames

-- declare variables
DECLARE @curtablename AS VARCHAR(255);
DECLARE @cmd AS VARCHAR(1024);

-- Loop through all the tables
WHILE (1 = 1)
BEGIN
	FETCH NEXT
	FROM tablenames
	INTO @curtablename;

	IF @@fetch_status <> 0
		BREAK;

	-- run the command
	SET @cmd = 'DBCC CHECKTABLE ([' + rtrim(@curtablename) + '])';

	EXEC (@cmd)

	PRINT @cmd + CHAR(10) + CHAR(13);
END

-- Close cursor
CLOSE tablenames;

DEALLOCATE tablenames;
