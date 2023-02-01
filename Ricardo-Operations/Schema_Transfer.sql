ALTER AUTHORIZATION ON SCHEMA::[IEHP\i3394] TO DBO;
Drop User [IEHP\i3394];

USE [HSP_CT]
GO
DROP SCHEMA [IEHP\i3394]
GO

SELECT * FROM sys.objects 
WHERE schema_id = SCHEMA_ID('dbo')  -- DBO = 1
ORDER BY name;

SELECT * FROM sys.objects 
WHERE name = 'uu_LoadClaimCheckServiceAssembly' 
AND schema_id = SCHEMA_ID('IEHP\i3394');


SELECT * FROM sys.objects 
WHERE schema_id = 10  -- DBO = 1
ORDER BY name;
GO
ALTER SCHEMA dbo TRANSFER [dbo].[uu_LoadClaimCheckServiceAssembly];
GO
SELECT * FROM sys.objects 
WHERE schema_id = 10  -- DBO = 1
ORDER BY name;
GO

SELECT 'ALTER SCHEMA dbo TRANSFER ' + s.Name + '.' + o.Name
FROM sys.Objects o
INNER JOIN sys.Schemas s on o.schema_id = s.schema_id
WHERE s.Name = 'IEHP\i3394'
And (o.Type = 'U' Or o.Type = 'P' Or o.Type = 'V')

