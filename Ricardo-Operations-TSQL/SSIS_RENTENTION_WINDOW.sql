-- https://www.mssqltips.com/sqlservertip/3307/managing-the-size-of-the-sql-server-ssis-catalog-database/
-- SSISDB Managing the size of the SQL Server SSIS catalog database
-- https://devjef.wordpress.com/2015/02/11/avoid-a-big-ssisdb-by-logging-less/

SELECT 
	*
FROM SSISDB.internal.catalog_properties

exec sp_spaceused

USE [SSISDB]
GO
--UPDATE [internal].[catalog_properties]
--   SET [property_value] = 14
-- WHERE property_name = 'RETENTION_WINDOW'
--GO
SELECT @@ServerName
GO
