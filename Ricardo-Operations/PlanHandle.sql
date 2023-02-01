USE [HSP_CT]
GO

SELECT * FROM [dbo].[ZipCodes]
GO

DECLARE @Stmt Varchar(MAX) = 'SELECT * FROM [dbo].[ZipCodes]'

SELECT plan_handle, st.text  
FROM sys.dm_exec_cached_plans   
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st  
WHERE text LIKE N'' +@Stmt +'%';  
