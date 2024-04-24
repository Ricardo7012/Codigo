EXEC sp_MSForEachDB 'USE [?]; PRINT ''?''; select * from sys.objects where schema_id = (select principal_id from sys.database_principals where name = ''HSP_dbo'')'

EXEC sp_MSForEachDB 'USE [?]; PRINT ''?''; select * from sysobjects where uid = (select uid from sysusers where name = ''HSP_dbo'')'

select * from sys.database_principals
select * from sys.objects 

SELECT USER_ID('HSP_dbo') AS prin_id;

SELECT  *, OBJECT_NAME(object_id)
FROM    sys.sql_modules
--WHERE execute_as_principal_id IS NOT NULL
--WHERE   execute_as_principal_id = USER_ID('HSP_dbo')
ORDER BY execute_as_principal_id DESC
