--RENAME A DATABASE

SELECT name, physical_name AS CurrentLocation, state_desc FROM sys.master_files ORDER BY physical_name

USE master;  
GO  
ALTER DATABASE HSP  
	Modify Name = HSP_MO ;  
GO


USE HSP_MO;

-- Changing logical names
ALTER DATABASE HSP_MO MODIFY FILE (NAME = HSP, NEWNAME = HSP_MO);
ALTER DATABASE HSP_MO MODIFY FILE (NAME = HSP_log, NEWNAME = HSP_MO_log);

SELECT name, physical_name AS CurrentLocation, state_desc FROM sys.master_files ORDER BY physical_name
