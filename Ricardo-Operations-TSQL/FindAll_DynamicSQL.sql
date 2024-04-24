--  DynamicExec.sql
--  Script to identify cases of dynamic code execution in sql.
USE HSP
GO
SELECT @@ServerName AS SERVERNAME
     , sm.object_id
     , OBJECT_NAME(sm.object_id)
     , o.type
     , o.type_desc
     , sm.definition
FROM sys.sql_modules sm
    JOIN sys.objects o
        ON sm.object_id = o.object_id
WHERE (
          UPPER(definition) LIKE '%SP_EXECUTESQL%'
          OR REPLACE(UPPER(definition), ' ', '') LIKE '%EXEC(%'
          OR REPLACE(UPPER(definition), ' ', '') LIKE '%EXECUTE(%'
      )
      AND UPPER(definition) NOT LIKE '%EXECUTE AS%';