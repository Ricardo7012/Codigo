-- List MAXDOP Settings
SET NOCOUNT ON

DECLARE @CoreCount INT

SET @CoreCount = 0

DECLARE @NumaNodes INT
-- See if xp_cmdshell is enabled, so we can try to 
-- use PowerShell to determine the real core count
DECLARE @T TABLE (
	NAME VARCHAR(255),
	minimum INT,
	maximum INT,
	config_value INT,
	run_value INT
	)

INSERT INTO @T
EXEC sp_configure 'xp_cmdshell'

DECLARE @cmdshellEnabled BIT

SET @cmdshellEnabled = 0

SELECT @cmdshellEnabled = 1
FROM @T
WHERE run_value = 1

IF @cmdshellEnabled = 1
BEGIN
	CREATE TABLE #cmdshell (txt VARCHAR(255))

	INSERT INTO #cmdshell (txt)
	EXEC xp_cmdshell 'powershell -OutputFormat Text -NoLogo -Command "& {Get-WmiObject -namespace "root\CIMV2" -class Win32_Processor -Property NumberOfCores} | select NumberOfCores"'

	SELECT @CoreCount = CONVERT(INT, LTRIM(RTRIM(txt)))
	FROM #cmdshell
	WHERE ISNUMERIC(LTRIM(RTRIM(txt))) = 1

	DROP TABLE #cmdshell
END

IF @CoreCount = 0
BEGIN
	-- Could not use PowerShell to get the corecount, use SQL Server's 
	-- unreliable number.  For machines with hyperthreading enabled
	-- this number is (typically) twice the physical core count.
	SET @CoreCount = (
			SELECT i.cpu_count
			FROM sys.dm_os_sys_info i
			)
END

SET @NumaNodes = (
		SELECT MAX(c.memory_node_id) + 1
		FROM sys.dm_os_memory_clerks c
		WHERE memory_node_id < 64
		)

DECLARE @MaxDOP INT

-- 3/4 of Total Cores in Machine
SET @MaxDOP = @CoreCount * 0.75

-- if @MaxDOP is greater than the per NUMA node
-- Core Count, set @MaxDOP = per NUMA node core count
IF @MaxDOP > (@CoreCount / @NumaNodes)
	SET @MaxDOP = (@CoreCount / @NumaNodes) * 0.75
--    Reduce @MaxDOP to an even number 
SET @MaxDOP = @MaxDOP - (@MaxDOP % 2)

-- Cap MAXDOP at 8, according to Microsoft
IF @MaxDOP > 8
	SET @MaxDOP = 8

PRINT 'Suggested MAXDOP = ' + CAST(@MaxDOP AS VARCHAR(max))
