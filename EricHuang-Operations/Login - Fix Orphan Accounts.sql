-- First, make sure that this is the problem. This will lists the orphaned users:
    EXEC sp_change_users_login 'Report'

-- If you want to match the one that is already on the SQL Server, fix it by doing:
--	EXEC sp_change_users_login 'Update_One', ['username'], ['username']


-- If you already have a login id and password for this user, fix it by doing:
--    EXEC sp_change_users_login 'Auto_Fix', ['user']


-- If you want to create a new login id and password for this user, fix it by doing:
--    EXEC sp_change_users_login 'Auto_Fix', ['user'], ['login'], ['password']



DECLARE @uname SYSNAME,
	@namealso SYSNAME

DECLARE usercur_1 CURSOR
FOR
SELECT [name]
FROM sys.sysusers
WHERE islogin = 1
	AND [name] NOT IN (
		'dbo',
		'guest',
		'INFORMATION_SCHEMA',
		'sys',
		'sa'
		)
	--AND [name] NOT LIKE 'hs\%'
	AND isntname = 0
	AND isntuser = 0 
	AND isntgroup = 0

OPEN usercur_1

FETCH NEXT
FROM usercur_1
INTO @uname

WHILE @@fetch_status = 0
BEGIN
	IF @uname IS NOT NULL
		AND @uname IN (
			SELECT [name]
			FROM master.sys.syslogins
			)
	BEGIN
		EXEC sp_change_users_login 'Update_One',
			@uname,
			@uname;

		PRINT @uname + ' has been fixed'
	END

	FETCH NEXT
	FROM usercur_1
	INTO @uname
END

CLOSE usercur_1

DEALLOCATE usercur_1