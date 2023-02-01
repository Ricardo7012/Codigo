-- Calculate SQL Server Memory

SET NOCOUNT ON;

DECLARE @Instancename VARCHAR(50)
DECLARE @MaxMem INT
DECLARE @MaxRamServer INT
DECLARE @sql VARCHAR(MAX)
DECLARE @SQLVersion TINYINT

SELECT @SQLVersion = @@MicrosoftVersion / 0x01000000;-- Get major version 

IF @SQLVersion >= 11
BEGIN
	EXEC sp_executesql N'set @MaxRamServer= (select physical_memory_kb / 1024 from sys.dm_os_sys_info)'
		, N'@MaxRamServer int OUTPUT'
		, @MaxRamServer = @MaxRamServer OUTPUT;

	PRINT '--Total Memory on the Server (MB):' + CAST(@MaxRamServer AS VARCHAR(10));
END;
ELSE IF @SQLVersion IN (
		10
		, 9
		)
BEGIN
	EXEC sp_executesql N'set @MaxRamServer= (select physical_memory_in_bytes / 1024 / 1024 from sys.dm_os_sys_info)'
		, N'@MaxRamServer int OUTPUT'
		, @MaxRamServer = @MaxRamServer OUTPUT;

	PRINT '--Total Memory on the Server (MB):' + CAST(@MaxRamServer AS VARCHAR(10));
END;
ELSE
BEGIN
	PRINT 'Script supports SQL Server 2005 or later.';

	RETURN;
END;

SET @MaxMem = CASE 
		/*When the RAM is Less than or equal to 2GB*/
		WHEN @MaxRamServer <= 1024 * 2
			THEN @MaxRamServer - 512
				/*When the RAM is Less than or equal to 4GB*/
		WHEN @MaxRamServer <= 1024 * 4
			THEN @MaxRamServer - 1024
				/*When the RAM is Less than or equal to 16GB*/
		WHEN @MaxRamServer <= 1024 * 16
			THEN @MaxRamServer - 1024 - CEILING((@MaxRamServer - 4096) / (4.0 * 1024)) * 1024
				/*When the RAM is Greater than or equal to 16GB*/
		WHEN @MaxRamServer > 1024 * 16
			THEN @MaxRamServer - 4096 - CEILING((@MaxRamServer - 1024 * 16) / (8.0 * 1024)) * 1024
		END;
SET @sql = 'EXEC sp_configure ''Show Advanced Options'',1


RECONFIGURE WITH OVERRIDE


EXEC sp_configure ''max server memory'',' + CONVERT(VARCHAR(6), @MaxMem) + '


RECONFIGURE WITH OVERRIDE;'

PRINT (@sql);-- Go to Message TAB to get the configuration script 

SELECT @MaxMem AS [OptimalMAXMemory];
