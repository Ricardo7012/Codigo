-- VAS Memory in SQL Server

SELECT vadump.Size AS 'Size'
	, Reserved = SUM(CASE (CONVERT(INT, vadump.base) ^ 0)
			WHEN 0
				THEN 0
			ELSE 1
			END)
	, Free = SUM(CASE (CONVERT(INT, vadump.base) ^ 0x0)
			WHEN 0
				THEN 1
			ELSE 0
			END)
FROM (
	SELECT CONVERT(VARBINARY, SUM(region_size_in_bytes)) AS 'Size'
		, region_allocation_base_address AS 'Base'
	FROM sys.dm_os_virtual_address_dump
	WHERE region_allocation_base_address <> 0x0
	GROUP BY region_allocation_base_address
	
	UNION
	
	(
		SELECT CONVERT(VARBINARY, region_size_in_bytes)
			, region_allocation_base_address
		FROM sys.dm_os_virtual_address_dump
		WHERE region_allocation_base_address = 0x0
		)
	) AS VaDump
GROUP BY size


