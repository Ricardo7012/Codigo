
-- DATA AND LOG FILE SIZES
SELECT instance_name AS DatabaseName, 
       [Data File(s) Size (KB)], 
       [LOG File(s) Size (KB)], 
       [Log File(s) Used Size (KB)], 
       [Percent Log Used] 
FROM 
( 
   SELECT * 
   FROM sys.dm_os_performance_counters 
   WHERE counter_name IN 
   ( 
       'Data File(s) Size (KB)', 
       'Log File(s) Size (KB)', 
       'Log File(s) Used Size (KB)', 
       'Percent Log Used' 
   ) 
     AND instance_name not in ('_Total','mssqlsystemresource')
) AS Src 
PIVOT 
( 
   MAX(cntr_value) 
   FOR counter_name IN 
   ( 
       [Data File(s) Size (KB)], 
       [LOG File(s) Size (KB)], 
       [Log File(s) Used Size (KB)], 
       [Percent Log Used] 
   ) 
) AS pvt WHERE [LOG File(s) Size (KB)] >1000
