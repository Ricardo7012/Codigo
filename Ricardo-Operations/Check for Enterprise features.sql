-- https://www.mssqltips.com/sqlservertip/3079/downgrade-from-sql-server-enterprise-edition-to-standard-edition/
-- https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2017?view=sql-server-ver15
-- https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2016?view=sql-server-ver15
-- Check for Enterprise features
SELECT @@ServerName AS SERVERNAME, @@Version AS VER
SELECT * FROM sys.dm_db_persisted_sku_features
