--ge+Mein!n0wB@ck

USE [master]
GO
/****** Object:  Login [server\backupadmin]    Script Date: 05/04/2011 11:21:31 ******/
CREATE LOGIN [server\backupadmin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
EXEC master..sp_addsrvrolemember @loginame = N'server\backupadmin', @rolename = N'sysadmin'
GO



--
SELECT
	* 
FROM sys.server_permissions 
WHERE grantee_principal_id = 
(SELECT principal_id FROM sys.server_principals WHERE name = N'DOMAIN\user')


