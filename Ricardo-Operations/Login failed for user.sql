/*

    This is script verifies which logins have sids that don’t match the correct
    sid defined on the machine/domain. 
   
    Simon Sabin (c) 2010
    http://sqlblogcasts.com/blogs/simons
 https://dba.stackexchange.com/questions/37564/login-failed-for-user-error-18456-severity-14-state-11
 http://sqlblog.com/blogs/aaron_bertrand/archive/2011/01/14/sql-server-v-next-denali-additional-states-for-error-18456.aspx
 http://sqlblogcasts.com/blogs/simons/archive/2011/02/01/solution-login-failed-for-user-x-reason-token-based-server-access-validation-failed-and-error-18456.aspx

*/
 

DECLARE cLogins CURSOR
FOR
    SELECT  name
    FROM    sys.server_principals
    WHERE   type_desc LIKE 'WINDOWS%'
      
OPEN cLogins
DECLARE @login VARCHAR(100)
FETCH cLogins INTO @login
WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            DECLARE @sql NVARCHAR(MAX);
            SET @sql = 'alter login ' + QUOTENAME(@login, '[') + ' with  name = ' + QUOTENAME(@login, '[')
            EXECUTE (@sql)
        END TRY
        BEGIN CATCH
            IF ERROR_NUMBER() = 15098
                PRINT @login
                    + ' failed validation with the system SID. This user/group account has been recreated. You will need to drop and recreate the login and associated database user accounts'
            ELSE
                PRINT @login + ' - ' + ERROR_MESSAGE() + ' (' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ')'
        END CATCH
        FETCH cLogins INTO @login
    END
DEALLOCATE cLogins

go
