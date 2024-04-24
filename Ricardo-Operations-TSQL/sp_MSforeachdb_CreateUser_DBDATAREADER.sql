--USE [master]
--CREATE LOGIN [iehp\i4682] FROM WINDOWS WITH DEFAULT_DATABASE=[master]

--CREATE USER
EXEC sp_MSforeachdb N'
IF N''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'')
BEGIN
	USE [?];
	CREATE USER [iehp\i4682] FOR LOGIN [iehp\i4682];
	ALTER ROLE db_datareader ADD MEMBER [iehp\i4682];
END;
';

--DROP
--EXEC sp_MSforeachdb N'
--IF N''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'')
--BEGIN
--	USE [?];
--	DROP USER  [iehp\i4682];
--END;
--';

--USE [master]
--DROP LOGIN [iehp\i4682]
