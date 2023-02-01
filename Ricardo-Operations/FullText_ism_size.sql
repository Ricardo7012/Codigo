SELECT @@Version AS ver 

SELECT   CONVERT(NUMERIC(38, 2), COUNT(*) * 8 / 1024.0) AS cached_data_mb,
         CONVERT(NUMERIC(38, 2), SUM(CONVERT(BIGINT, free_space_in_bytes)) / 1024. / 1024.) AS free_mb,
         CASE database_id
              WHEN 32767 THEN 'ResourceDb'
              ELSE DB_NAME(database_id)
         END AS database_name
FROM     sys.dm_os_buffer_descriptors
GROUP BY DB_NAME(database_id), database_id
ORDER BY cached_data_mb DESC;

sp_fulltext_service 'ism_size'

--To change the value to 16:
--sp_fulltext_service 'ism_size',@value=16

-- https://docs.microsoft.com/en-us/sql/relational-databases/search/improve-the-performance-of-full-text-indexes?view=sql-server-2016 

