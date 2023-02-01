-- Check Tempdb Configuration
-- Please see supporting document

WITH
TempdbDataFile AS
(
SELECT  size,
        max_size,
        growth,
        is_percent_growth,
        AVG(CAST(size AS decimal(18,4))) OVER() AS AvgSize,
        AVG(CAST(max_size AS decimal(18,4))) OVER() AS AvgMaxSize,
        AVG(CAST(growth AS decimal(18,4))) OVER() AS AvgGrowth
FROM tempdb.sys.database_files 
WHERE   type_desc = 'ROWS'
        AND
        state_desc = 'ONLINE'
)
SELECT  CASE WHEN (SELECT scheduler_count FROM sys.dm_os_sys_info) 
                  BETWEEN COUNT(1) 
                      AND COUNT(1) * 2
             THEN 'YES'
             ELSE 'NO'
        END
        AS 'Multiple Data Files',
        CASE SUM(CASE size WHEN AvgSize THEN 1 ELSE 0 END) 
             WHEN COUNT(1) THEN 'YES'
             ELSE 'NO'
        END AS 'Equal Size',
        CASE SUM(CASE max_size WHEN AvgMaxSize THEN 1 ELSE 0 END) 
             WHEN COUNT(1) THEN 'YES' 
             ELSE 'NO' 
        END AS 'Equal Max Size',
        CASE SUM(CASE growth WHEN AvgGrowth THEN 1 ELSE 0 END) 
             WHEN COUNT(1) THEN 'YES'
             ELSE 'NO'
        END AS 'Equal Growth',
        CASE SUM(CAST(is_percent_growth AS smallint)) 
             WHEN 0 THEN 'YES'
             ELSE 'NO'
        END AS 'No Files With Percent Growth' 
FROM TempdbDataFile;