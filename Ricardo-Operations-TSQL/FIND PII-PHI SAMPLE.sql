-- FIND PII-PHI SAMPLE
--:CONNECT HSP3S1A
USE HSP_IT_SB2
GO
SELECT DB_NAME()                AS [DB]
     , OBJECT_NAME(o.object_id) AS [Object]
     , c.name                   AS [Column]
FROM sys.columns     c
    JOIN sys.objects o
        ON c.object_id = o.object_id
WHERE o.type IN ( 'U', 'V' ) /* tables and views */
      AND
      (
          c.name LIKE '%mail%'
          OR c.name LIKE '%first%name%'
          OR c.name LIKE '%last%name%'
          OR c.name LIKE '%birth%'
		  OR c.name LIKE '%DateOfBirth%'
          OR c.name LIKE '%sex%'
          OR c.name LIKE '%address%'
          OR c.name LIKE '%phone%'
          OR c.name LIKE '%social%'
          OR c.name LIKE '%ssn%'
          OR c.name LIKE '%gender%'
      );
	  
-- https://www.mssqltips.com/sqlservertip/2409/identifying-pii-data-to-lock-down-in-sql-server-part-1-of-2/
-- https://www.mssqltips.com/sqlservertip/2412/locking-down-pii-data-in-sql-server-part-2-of-2/
-- https://www.stigviewer.com/stig/ms_sql_server_2014_database/2017-12-01/finding/V-67401 
-- https://docs.microsoft.com/en-us/sql/relational-databases/security/sql-data-discovery-and-classification?view=sql-server-ver15&tabs=t-sql
 
