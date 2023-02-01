
/*ENABLE DEDICATED ADMINISTRATIVE CONNECTION IN SQL 
SERVER USING TSQL*/
SELECT * FROM sys.configurations WHERE name = 'remote admin connections' ORDER BY name
USE MASTER
GO
sp_configure 'remote admin connections', 1 
GO
RECONFIGURE WITH OVERRIDE 
GO
SELECT * FROM sys.configurations WHERE name = 'remote admin connections' ORDER BY name
