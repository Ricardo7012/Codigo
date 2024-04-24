SELECT D.name
     , F.state_desc                               AS OnlineStatus
     , F.name                                     AS FileType
     , F.physical_name                            AS PhysicalFile
     , F.max_size -- -1 = File will grow until the disk is full.
     , F.size                                     AS [8-KBPages]
     , CAST(F.size AS BIGINT) * 8                 AS [SizeInBytes]
	 --, CAST((F.size * 8) AS BIGINT)               AS SizeInBytes
     --, CAST((F.size * 8) / 1024 AS BIGINT)        AS FileSizeMB
     --, CAST((F.size * 8) / 1024 / 1024 AS BIGINT) AS FileSizeGB
	 , (CONVERT(BIGINT, F.size) * 8 / 1048576) AS FileSizeMB 
	 , (CONVERT(BIGINT, F.size) * 8 / 1073741824) AS FileSizeGB
FROM sys.master_files        F
    INNER JOIN sys.databases D
        ON D.database_id = F.database_id
--WHERE D.name LIKE 'FPNA%'
--      OR D.name LIKE 'Cap%'
ORDER BY D.name;

