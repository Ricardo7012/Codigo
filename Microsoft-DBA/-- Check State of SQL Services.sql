-- Check State of SQL Services

EXEC master.dbo.xp_servicecontrol 'QUERYSTATE'
	, 'MSSQLServer'

EXEC master.dbo.xp_servicecontrol 'QUERYSTATE'
	, 'SQLServerAgent'

EXEC master.dbo.xp_servicecontrol 'QUERYSTATE'
	, 'SQLBrowser'
