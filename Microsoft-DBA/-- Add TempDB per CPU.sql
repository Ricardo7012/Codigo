-- Add TempDB per CPU
USE [master]
GO

DECLARE @Cpu_Count INT
DECLARE @File_Count INT
DECLARE @Logical_Name SYSNAME
DECLARE @File_Name NVARCHAR(520)
DECLARE @Physical_Name NVARCHAR(520)
DECLARE @Size INT
DECLARE @Max_Size INT
DECLARE @Growth INT
DECLARE @Alter_Command NVARCHAR(max)
DECLARE @FilePerCPU DECIMAL(5, 2)

--------------------------------------------------
-- Add *  .25 here to add --- 1 --- file for every 4 cpu's
-- Add *  .50 here to add --- 2 --- files for every 4 cpu's
-- Add * 1.00 here to add --- 4 --- files for every 4 cpu's
--------------------------------------------------
SET @FilePerCPU = 1.00
--------------------------------------------------

SELECT @Physical_Name = physical_name
	, @Size = size / 128
	, @Max_Size = max_size / 128
	, @Growth = growth / 128
FROM tempdb.sys.database_files
WHERE NAME = 'tempdev'

SELECT @File_Count = COUNT(*)
FROM tempdb.sys.database_files
WHERE type_desc = 'ROWS'

SELECT @Max_Size = size / 128
FROM tempdb.sys.database_files
WHERE NAME = 'tempdev'

SELECT @Cpu_Count = cpu_count
FROM sys.dm_os_sys_info

WHILE @File_Count < @Cpu_Count * @FilePerCPU
BEGIN
	SELECT @Logical_Name = 'tempdev_' + CAST(@File_Count AS NVARCHAR)

	SELECT @File_Name = REPLACE(@Physical_Name, 'tempdb.mdf', @Logical_Name + '.ndf')

	SELECT @Alter_Command = 'ALTER DATABASE [tempdb] ADD FILE ( NAME =N''' + @Logical_Name + ''', FILENAME =N''' + @File_Name + ''', SIZE = ' + CAST(@Size AS NVARCHAR) + 'MB, MAXSIZE = ' + CAST(@Max_Size AS NVARCHAR) + 'MB, FILEGROWTH = ' + CAST(@Growth AS NVARCHAR) + 'MB )'

	PRINT 'Added Additional TempDB File ' + @Logical_Name

	EXEC sp_executesql @Alter_Command

	SELECT @File_Count = @File_Count + 1
END
