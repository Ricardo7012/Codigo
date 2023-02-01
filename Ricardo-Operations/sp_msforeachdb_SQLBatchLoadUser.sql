
EXEC sp_MSforeachdb N'
IF N''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'', ''SSISDB'', ''LiteSpeedLocal'', ''DWBI5'')
BEGIN
USE [?];
ALTER USER SQLBatchLoadUser WITH LOGIN = SQLBatchLoadUser;
END;
';
