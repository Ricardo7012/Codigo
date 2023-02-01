-- Temp Script for TempDB Ratio to CPU

USE [master]
GO

DECLARE @cpu_count INT
DECLARE @file_count INT
DECLARE @logical_name SYSNAME
DECLARE @file_name NVARCHAR(520)
DECLARE @physical_name NVARCHAR(520)
DECLARE @alter_command NVARCHAR(max)

SELECT @physical_name = physical_name
FROM tempdb.sys.database_files
WHERE NAME = 'tempdev'

SELECT @file_count = COUNT(*)
FROM tempdb.sys.database_files
WHERE type_desc = 'ROWS'

SELECT @cpu_count = cpu_count
FROM sys.dm_os_sys_info

IF @cpu_count > 7

WHILE @file_count < @cpu_count
BEGIN
	
--	SELECT @logical_name = 'tempdev' + '_' + CAST(@file_count AS NVARCHAR)
	SELECT @logical_name = 'tempdev' + CAST(@file_count AS NVARCHAR)
	SELECT @file_name = REPLACE(@physical_name, 'tempdb.mdf', @logical_name + '.ndf')
	SELECT @alter_command = 'ALTER DATABASE [tempdb] ADD FILE (NAME = N''' + @logical_name + ''', FILENAME = N''' + @file_name + ''', SIZE = 2048MB, FILEGROWTH = 0MB)'

	PRINT @alter_command

	-- EXEC sp_executesql @alter_command

	SELECT @file_count = @file_count + 1
END
