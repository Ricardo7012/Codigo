select name,is_trustworthy_on from sys.databases 

USE [master]
GO
GRANT EXTERNAL ACCESS ASSEMBLY TO [SQLBatchLoadUser]
GO
GRANT EXTERNAL ACCESS ASSEMBLY TO [SQLiConnectUser]
GO
--GRANT EXTERNAL ACCESS ASSEMBLY TO [SQLEDIMSUser02]
GO
REVOKE EXTERNAL ACCESS ASSEMBLY TO [HSP_dbo]
GO

USE [master]
GO
REVOKE UNSAFE ASSEMBLY TO [SQLBatchLoadUser]
GO
REVOKE UNSAFE ASSEMBLY TO [SQLiConnectUser]
GO
--REVOKE UNSAFE ASSEMBLY TO [SQLEDIMSUser03]
GO
GRANT UNSAFE ASSEMBLY TO [HSP_dbo]
GO


SELECT pr.name, pe.permission_name
FROM sys.server_principals pr
INNER JOIN sys.server_permissions pe
ON pr.principal_id = pe.grantee_principal_id
WHERE pe.permission_name = 'EXTERNAL ACCESS ASSEMBLY'

SELECT pr.name, pe.permission_name
FROM sys.server_principals pr
INNER JOIN sys.server_permissions pe
ON pr.principal_id = pe.grantee_principal_id
WHERE pe.permission_name = 'UNSAFE ASSEMBLY'

SELECT name,is_trustworthy_on from sys.databases 

DECLARE @sql1 varchar(1000)
SELECT @sql1 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb'' AND ''?'' <> ''HSPLicensing''
BEGIN
USE [?] 
ALTER DATABASE [?] SET TRUSTWORTHY ON;
END'
PRINT @sql1 
EXEC sp_msforeachdb @sql1 
--PRINT @sql1
