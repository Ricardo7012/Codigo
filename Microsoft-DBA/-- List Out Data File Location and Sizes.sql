-- List Out Data File Location and Sizes

DECLARE @database_id INT
DECLARE @database_name SYSNAME
DECLARE @sql_string NVARCHAR(2000)
DECLARE @file_size TABLE (
	[database_name] [sysname] NULL
	, [groupid] [smallint] NULL
	, [groupname] SYSNAME NULL
	, [fileid] [smallint] NULL
	, [file_size] [decimal](12, 2) NULL
	, [space_used] [decimal](12, 2) NULL
	, [free_space] [decimal](12, 2) NULL
	, [name] [sysname] NOT NULL
	, [filename] [nvarchar](260) NOT NULL
	)

SELECT TOP 1 @database_id = database_id
	, @database_name = NAME
FROM sys.databases
WHERE database_id > 0
ORDER BY database_id

WHILE @database_name IS NOT NULL
BEGIN
	SET @sql_string = 'USE ' + QUOTENAME(@database_name) + CHAR(10)
	SET @sql_string = @sql_string + 'SELECT
                                        DB_NAME()
                                        ,sysfilegroups.groupid
                                        ,sysfilegroups.groupname
                                        ,fileid
                                        ,convert(decimal(12,2),round(sysfiles.size/128.000,2)) as file_size
                                        ,convert(decimal(12,2),round(fileproperty(sysfiles.name,''SpaceUsed'')/128.000,2)) as space_used
                                        ,convert(decimal(12,2),round((sysfiles.size-fileproperty(sysfiles.name,''SpaceUsed''))/128.000,2)) as free_space
                                        ,sysfiles.name
                                        ,sysfiles.filename
                                    FROM sys.sysfiles
                                    LEFT OUTER JOIN sys.sysfilegroups
                                        ON sysfiles.groupid = sysfilegroups.groupid'

	INSERT INTO @file_size
	EXEC sp_executesql @sql_string

	--Grab next database
	SET @database_name = NULL

	SELECT TOP 1 @database_id = database_id
		, @database_name = NAME
	FROM sys.databases
	WHERE database_id > @database_id
	ORDER BY database_id
END

--File Sizes
SELECT database_name AS 'DB Name'
	, groupid AS 'Group ID'
	, ISNULL(groupname, 'TLOG') AS 'Group Name'
	, fileid AS 'File ID'
	, NAME AS 'Name'
	, file_size AS 'File Size'
	, space_used AS 'Space Used'
	, free_space AS 'Free Space'
	, FILENAME AS 'File Name'
FROM @file_size

--File Group Sizes
SELECT database_name AS 'DB Name'
	, groupid AS 'Group ID'
	, ISNULL(groupname, 'TLOG') AS 'Group Name'
	, SUM(file_size) AS 'File Size'
	, SUM(space_used) AS 'Space Used'
	, SUM(free_space) AS 'Free Space'
FROM @file_size
GROUP BY database_name
	, groupid
	, groupname
