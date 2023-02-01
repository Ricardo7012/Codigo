--02 DROP ROLE, SCHEMA, LOGIN AFTER ALL OWNED OBJECTS ARE DROPPED 
USE [HSP_Supplemental]
GO

DECLARE @RoleName sysname
set @RoleName = N'EBMRole'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END
DROP ROLE [EBMRole]
GO

USE [HSP_Supplemental]
GO
DROP SCHEMA [EBM]
GO
DROP USER [EbmUser]
GO
--DROP LOGIN
USE [master]
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'KILL ' + CONVERT(VARCHAR(11), session_id) + N';'
FROM sys.dm_exec_sessions
  WHERE 
  --[program_name] = N'app_name' AND
  login_name = N'EbmUser' 
  --AND last_request_start_time < DATEADD(HOUR, -5, SYSDATETIME());

EXEC sys.sp_executesql @sql;

GO
DROP LOGIN [EbmUser]
GO

USE [HSP]
GO
DROP USER [EbmUser]
GO


/***********************************************************
 *** DEV ONLY ***
***********************************************************/
USE [HSP]
GO
DROP USER [IEHP\ArchDevAdmin]
GO

USE [master]
GO
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'KILL ' + CONVERT(VARCHAR(11), session_id) + N';'
FROM sys.dm_exec_sessions
  WHERE 
  --[program_name] = N'app_name' AND
  login_name = N'IEHP\ArchDevAdmin' 
  --AND last_request_start_time < DATEADD(HOUR, -5, SYSDATETIME());

EXEC sys.sp_executesql @sql;

GO
DROP LOGIN [IEHP\ArchDevAdmin]
GO

/***********************************************************
 *** DEV ONLY ***
***********************************************************/