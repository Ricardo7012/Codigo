-- List Reports Folders

SELECT CASE RSCatalog.Type
		WHEN 1
			THEN 'Folder'
		ELSE 'Report'
		END AS [Type]
	, RSCatalog.Path
	, RSCatalog.NAME AS Report
	, Users.UserName
	, Roles.RoleName
-- *
FROM [dbo].[Catalog] RSCatalog
INNER JOIN [dbo].[PolicyUserRole] PolicyUserRole
	ON RSCatalog.PolicyID = PolicyUserRole.PolicyID
INNER JOIN [dbo].[Roles] Roles
	ON PolicyUserRole.RoleID = Roles.RoleID
INNER JOIN [dbo].[Users] Users
	ON PolicyUserRole.UserID = Users.UserID
WHERE RSCatalog.Type IN (
		1
		, 2
		)
ORDER BY RSCatalog.Path
	, RSCatalog.NAME
	, Users.UserName
