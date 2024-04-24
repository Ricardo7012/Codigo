/*
    Moves SQL TempDB files to designated location, and sizes them appropriately. If there are 
	multiple instances hosted on the same SQL Server, divide the drive size by the instance 
	count, and create folders for each instance name on the destination drive.

	Snippet is nuts and bolts for creating/moving to an isolated tempdb drive.
	After you run this, SQL Server must be restarted for it to take effect
*/
DECLARE @DriveSizeGB INT          = 40
        ,@FileCount  INT          = 9
        ,@RowID      INT
        ,@FileSize   VARCHAR(10)
        ,@DrivePath  VARCHAR(100) = 'T:\' + @@SERVICENAME + '\';

/* Converts GB to MB */
SELECT  @DriveSizeGB = @DriveSizeGB * 1000;

/* Splits size by the nine files */
SELECT  @FileSize = @DriveSizeGB / @FileCount;

/* Table to house requisite SQL statements that will modify the files to the standardized name, and size */
DECLARE @Command TABLE
(
    RowID    INT IDENTITY(1, 1)
    ,Command NVARCHAR(MAX)
);
INSERT INTO @Command (Command)
SELECT  'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],' + ' FILENAME = ''' + @DrivePath + f.name
        + CASE
              WHEN f.type = 1 THEN '.ldf'
              ELSE '.mdf'
          END + ''', SIZE = ' + @FileSize + ');'
FROM    sys.master_files AS f
WHERE   f.database_id = DB_ID(N'tempdb');
SET @RowID = @@ROWCOUNT

/* If there are less files than indicated in @FileCount, add missing lines as ADD FILE commands */
WHILE @RowID < @FileCount
BEGIN
	INSERT INTO @Command (Command)
	SELECT  'ALTER DATABASE tempdb ADD FILE (NAME = [temp' + CAST(@RowID AS VARCHAR) + '],' + ' FILENAME = ''' + @DrivePath + 'temp'+ CAST(@RowID AS VARCHAR)+'.mdf''' + ', SIZE='+@FileSize+');'
	SET @RowID = @RowID + 1
END

/* Execute each line to process */
WHILE @RowID > 0
BEGIN
	DECLARE @WorkingSQL NVARCHAR(MAX)

	SELECT	@WorkingSQL = Command
	FROM	@Command
	WHERE	RowID = @RowID

	EXEC (@WorkingSQL)
	SET @RowID = @RowID - 1
END