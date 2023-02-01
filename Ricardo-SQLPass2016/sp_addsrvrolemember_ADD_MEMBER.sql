/*ADD LOGIN AS A MEMBER OF sysadmin SERVER ROLE.*/
EXEC master..sp_addsrvrolemember @loginame = N'', @rolename = N'sysadmin'
GO
