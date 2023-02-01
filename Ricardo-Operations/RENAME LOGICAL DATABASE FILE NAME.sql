-- RENAME LOGICAL DATABASE FILE NAME
USE Medimart
GO
SELECT file_id, name AS logical_name, physical_name
FROM sys.database_files

USE [master];
GO
ALTER DATABASE Medimart MODIFY FILE ( NAME = _Data, NEWNAME = _Data );
GO
ALTER DATABASE Medimart MODIFY FILE ( NAME = _1, NEWNAME = _Data1 );
GO
ALTER DATABASE Medimart MODIFY FILE ( NAME = _Log, NEWNAME = _Log );
GO

