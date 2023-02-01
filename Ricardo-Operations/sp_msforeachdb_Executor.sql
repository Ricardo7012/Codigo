
DECLARE @sql1 varchar(1000)
SELECT @sql1 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb''
BEGIN
USE [?] 
CREATE ROLE [db_executor]
GRANT EXECUTE TO db_executor
CREATE USER [IEHP\PEDIMSSvc] FOR LOGIN [IEHP\PEDIMSSvc]
ALTER ROLE [db_owner] ADD MEMBER [IEHP\PEDIMSSvc]

CREATE USER [IEHP\_tallan] FOR LOGIN [IEHP\_tallan]
ALTER ROLE [db_owner] ADD MEMBER [IEHP\_tallan]

END'
PRINT @sql1 
EXEC sp_msforeachdb @sql1 
--PRINT @sql1 



