-- https://docs.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-my-permissions-transact-sql?view=sql-server-ver15
SELECT *
FROM fn_my_permissions('iehp\NDReadOnly', 'USER');
GO
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-database-role-members-transact-sql?view=sql-server-ver15
DECLARE @dbname VARCHAR(50);
DECLARE @statement NVARCHAR(MAX);

DECLARE db_cursor CURSOR LOCAL FAST_FORWARD FOR
SELECT name
FROM master.sys.databases
WHERE name NOT IN ( 'master', 'msdb', 'model', 'tempdb' )
      AND state_desc = 'online';
OPEN db_cursor;
FETCH NEXT FROM db_cursor
INTO @dbname;
WHILE @@Fetch_Status = 0
    BEGIN

        SELECT @statement
            = N'use ' + @dbname + N';'
              + N'SELECT
ServerName=@@servername, dbname=db_name(db_id()),p.name as UserName, p.type_desc as TypeOfLogin, pp.name as PermissionLevel, pp.type_desc as TypeOfRole 
FROM sys.database_role_members roles
JOIN sys.database_principals p ON roles.member_principal_id = p.principal_id
JOIN sys.database_principals pp ON roles.role_principal_id = pp.principal_id
where p.name=''iehp\NDReadOnly''';
        EXEC sp_executesql @statement;

        FETCH NEXT FROM db_cursor
        INTO @dbname;
    END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
