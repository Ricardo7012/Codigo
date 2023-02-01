---- https://docs.microsoft.com/en-us/sql/relational-databases/performance-monitor/monitor-memory-usage?view=sql-server-ver15
---- MONITOR MEMORY USAGE
--SELECT (total_physical_memory_kb / 1024)     AS Total_OS_Memory_MB
--     , (total_physical_memory_kb / 1048576)     AS Total_OS_Memory_GB
--     , (available_physical_memory_kb / 1024) AS Available_OS_Memory_MB
--	 , (available_physical_memory_kb / 1048576) AS Available_OS_Memory_GB
--FROM sys.dm_os_sys_memory;

---- https://itectec.com/database/sql-server-sql-servers-total-server-memory-consumption-stagnant-for-months-with-64gb-more-available/
--SELECT (physical_memory_in_use_kb / 1024)      AS Memory_used_by_Sqlserver_MB
--     , (locked_page_allocations_kb / 1024)     AS Locked_pages_used_by_Sqlserver_MB
--     , (total_virtual_address_space_kb / 1024) AS Total_VAS_in_MB
--     , process_physical_memory_low
--     , process_virtual_memory_low
--FROM sys.dm_os_process_memory;

--SELECT sqlserver_start_time
--     , (committed_kb / 1024)        AS Total_Server_Memory_MB
--     , (committed_target_kb / 1024) AS Target_Server_Memory_MB
--FROM sys.dm_os_sys_info;

---- https://documentation.red-gate.com/sbu/troubleshooting/configuring-sql-server-memory
---- CHECK THE AMOUNT OF CONTIGUOUS MEMORY AVAILABLE IN BYTES
EXECUTE master..sqbmemory;
---- http://byteconvert.org/
/*
The grid provides information about the amount of memory available in the SQL Server memory space.

The key row in relation to SQL Backup is the "Free" row, and in particular the "maximum" value of this row.

The amount of memory used by a SQL Backup request will be based on three factors:
- The number of threads used (or the filecount value)
- The MAXTRANSFERSIZE value (defaults to 1MiB - 1048576)
- An internal value, which is related inversely to the number of threads (more threads means this value decreases).

These three values multiply together to give the required amount of memory.

For a MAXTRANSFERSIZE of 1 MiB:
- For 1 thread, the required amount of memory is 6MiB;
- For 2 threads, this value is 12MiB;
- For 32 threads, this value is 64MiB.

In the event this amount of memory is not available, SQL Backup will automatically retry with a MAXTRANSFERSIZE of half the previous value, down to a minimum of 65536 (64kiB).

If SQL Backup cannot execute on the smallest value (requires a minimum of 384kiB), it will exit out and be unable to run. By this stage the memory space is so fragmented that the simplest solution is to restart the SQL Server instance.

*/


-- TOTAL AVAIL MEMORY BYTES
-- https://www.johnsansom.com/sql-server-memory-configuration-determining-memtoleave-settings/
WITH VAS_Summary AS
(
    SELECT Size = VAS_Dump.Size,
    Reserved = SUM(CASE(CONVERT(INT, VAS_Dump.Base) ^ 0) WHEN 0 THEN 0 ELSE 1 END),
    Free = SUM(CASE(CONVERT(INT, VAS_Dump.Base) ^ 0) WHEN 0 THEN 1 ELSE 0 END)
    FROM
    (
        SELECT CONVERT(VARBINARY, SUM(region_size_in_bytes)) [Size],
            region_allocation_base_address [Base]
            FROM sys.dm_os_virtual_address_dump
        WHERE region_allocation_base_address <> 0
        GROUP BY region_allocation_base_address
        UNION
        SELECT
            CONVERT(VARBINARY, region_size_in_bytes) [Size],
            region_allocation_base_address [Base]
        FROM sys.dm_os_virtual_address_dump
        WHERE region_allocation_base_address = 0x0 ) AS VAS_Dump
        GROUP BY Size
    )
SELECT SUM(CONVERT(BIGINT, Size) * Free)                 AS [Total avail mem, Bytes]
     , SUM(CONVERT(BIGINT, Size) * Free) / 1024          AS [Total avail mem, KB]
     , SUM(CONVERT(BIGINT, Size) * Free) / 1048576       AS [Total avail mem, MB]
     , SUM(CONVERT(BIGINT, Size) * Free) / 1073741824    AS [Total avail mem, GB]
     , SUM(CONVERT(BIGINT, Size) * Free) / 1099511627776 AS [Total avail mem, TB]
     , CAST(MAX(Size) AS BIGINT)                         AS [Max free size, Bytes]
     , CAST(MAX(Size) AS BIGINT) / 1024                  AS [Max free size, KB]
     , CAST(MAX(Size) AS BIGINT) / 1048576               AS [Max free size, MB]
     , CAST(MAX(Size) AS BIGINT) / 1073741824            AS [Max free size, GB]
     , CAST(MAX(Size) AS BIGINT) / 1099511627776         AS [Max free size, TB]
FROM VAS_Summary
WHERE Free <> 0;
-- https://docs.microsoft.com/en-us/archive/blogs/sqlserverfaq/incorrect-buffercount-data-transfer-option-can-lead-to-oom-condition
-- https://docs.microsoft.com/en-us/windows/win32/memory/memory-limits-for-windows-releases#memory-and-address-space-limits
-- https://docs.microsoft.com/en-us/windows-hardware/drivers/gettingstarted/virtual-address-spaces
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-sys-memory-transact-sql?view=sql-server-ver15
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-virtual-address-dump-transact-sql?view=sql-server-ver15
-- http://byteconvert.org/



-- https://docs.microsoft.com/en-us/archive/blogs/sqlserverfaq/incorrect-buffercount-data-transfer-option-can-lead-to-oom-condition
-- INCORRECT BUFFERCOUNT DATA TRANSFER OPTION CAN LEAD TO OOM CONDITION
DECLARE @MaxTransferSize BIGINT
      , @BufferCount     BIGINT
      , @DBName          VARCHAR(255)
      , @BackupDevices   BIGINT;

-- Default value is zero. Value to be provided in MB.
SET @MaxTransferSize = 2097152;
-- Default value is zero
SET @BufferCount = 2048;
-- Provide the name of the database to be backed up
SET @DBName = 'Member';
-- Number of disk devices that you are writing the backup to
SET @BackupDevices = 7;

DECLARE @DatabaseDeviceCount INT = 1;
--SELECT @DatabaseDeviceCount = COUNT(DISTINCT (SUBSTRING(physical_name, 1, CHARINDEX(physical_name, ':') + 1)))
--FROM sys.master_files
--WHERE database_id = DB_ID(@DBName)
      --AND type_desc <> 'LOG';
--SELECT @DBName
--SELECT @DatabaseDeviceCount

--IF @BufferCount = 0
	--SET @BufferCount += @BackupDevices 
    --SET @BufferCount += (2 * @DatabaseDeviceCount);
	SET @BufferCount = (@BackupDevices * (3 + 1)) + @BackupDevices + (2 * @DatabaseDeviceCount);

IF @MaxTransferSize = 0
    SET @MaxTransferSize = 1;

--SELECT 'Total buffer space (MB): ' + CAST((@BufferCount * @MaxTransferSize) AS VARCHAR(10)) AS xxx;
SELECT @DBName                                                AS DBName
     , CAST((@BufferCount * @MaxTransferSize) AS VARCHAR(10)) AS 'Total buffer space (MB)'
	 , CAST((@BufferCount * @MaxTransferSize /1024) AS VARCHAR(10)) AS 'Total buffer space (GB)'
	 , CAST((@BufferCount * @MaxTransferSize /1048576) AS VARCHAR(10)) AS 'Total buffer space (TB)'
     , @DatabaseDeviceCount AS [DatabaseDeviceCount]
	 , @MaxTransferSize                                       AS [MaxTransferSize]
     , @BufferCount                                           AS [BufferCount]
     , @BackupDevices                                         AS [BackupDevices];
-- https://dba.stackexchange.com/questions/128437/setting-buffercount-blocksize-and-maxtransfersize-for-backup-command
