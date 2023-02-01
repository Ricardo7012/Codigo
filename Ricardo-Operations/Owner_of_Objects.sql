;WITH objects_cte
AS (SELECT o.name,
           o.type_desc,
           CASE
               WHEN o.principal_id IS NULL THEN
                   s.principal_id
               ELSE
                   o.principal_id
           END AS principal_id
    FROM sys.objects o
        INNER JOIN sys.schemas s
            ON o.schema_id = s.schema_id
    WHERE o.is_ms_shipped = 0
          AND o.type IN ( 'TT', 'FN', 'C', 'UQ', 'SQ', 'U', 'D', 'PK', 'S', 'IT', 'P','TF','PC','FT','V' ))
SELECT cte.name,
       cte.type_desc,
       dp.name
FROM objects_cte cte
    INNER JOIN sys.database_principals dp
        ON cte.principal_id = dp.principal_id
WHERE dp.name LIKE 'iehp\sqladmin%';

SELECT SUSER_SNAME(owner_sid)
FROM sys.databases
WHERE name LIKE 'iehp\sqladmin%';

--FN = SQL scalar function
--FS = Assembly (CLR) scalar-function
--FT = Assembly (CLR) table-valued function
--IF = SQL inline table-valued function
--P = SQL Stored Procedure
--PC = Assembly (CLR) stored-procedure
--TA = Assembly (CLR) DML trigger
--TF = SQL table-valued-function
--TR = SQL DML trigger
--U = Table (user-defined)
--V = View

--type	type_desc
--TT	TYPE_TABLE
--FN	SQL_SCALAR_FUNCTION
--C 	CHECK_CONSTRAINT
--UQ	UNIQUE_CONSTRAINT
--SQ	SERVICE_QUEUE
--U 	USER_TABLE
--D 	DEFAULT_CONSTRAINT
--PK	PRIMARY_KEY_CONSTRAINT
--S 	SYSTEM_TABLE
--IT	INTERNAL_TABLE
--P 	SQL_STORED_PROCEDURE
--TF	SQL_TABLE_VALUED_FUNCTION
--PC	CLR_STORED_PROCEDURE
--FT	CLR_TABLE_VALUED_FUNCTION
--SELECT DISTINCT type, type_desc FROM sys.objects
