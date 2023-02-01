USE [Accounting]
GO

DECLARE @RoleName SYSNAME

SET @RoleName = N'SQLUser'

BEGIN

	DECLARE @RoleMemberName SYSNAME

	DECLARE Member_Cursor CURSOR
	FOR
	SELECT [name]
	FROM sys.database_principals
	WHERE principal_id IN (
			SELECT member_principal_id
			FROM sys.database_role_members
			WHERE role_principal_id IN (
					SELECT principal_id
					FROM sys.database_principals
					WHERE [name] = @RoleName
						AND type = 'R'
					)
			)

	OPEN Member_Cursor;

	FETCH NEXT
	FROM Member_Cursor
	INTO @RoleMemberName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC sp_droprolemember @rolename = @RoleName,
			@membername = @RoleMemberName

		FETCH NEXT
		FROM Member_Cursor
		INTO @RoleMemberName
	END;

	CLOSE Member_Cursor;

	DEALLOCATE Member_Cursor;
END
GO

DROP ROLE [SQLUser]
GO

DROP USER [A91\SQLUserGroup]
GO
