EXEC sys.sp_change_users_login @Action = 'Update_one', -- varchar(10)
    @UserNamePattern = 'HSP_dbo', -- sysname
    @LoginName = 'HSP_dbo' -- sysname

SELECT owner_sid FROM sys.databases where name = 'HSP_Prime';

SELECT sid from sys.database_principals WHERE name = 'HSP_dbo';

USE HSP_Prime;
go
DROP USER HSP_dbo;
ALTER AUTHORIZATION ON DATABASE::hsp_prime TO [HSP_dbo];

USE HSP_SB
GO
ALTER USER SQLBatchLoadUser WITH LOGIN = SQLBatchLoadUser;
GO
