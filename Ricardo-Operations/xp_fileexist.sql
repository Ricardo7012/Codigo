USE master
GO
SET NOCOUNT ON 

DECLARE @ServiceAcct sysname, @Path as varchar(256)
SET @Path = '\\dtsqlbkups\qvsqllit01backups\NonProduction\HSP2S1A'

EXECUTE  dbo.xp_instance_regread
    @rootkey      = N'HKEY_LOCAL_MACHINE',
    @key          = N'SYSTEM\CurrentControlSet\Services\MSSQLServer',
    @value_name   = N'ObjectName',
    @value        = @ServiceAcct OUTPUT

--EXECUTE AS LOGIN = @ServiceAcct;
EXEC master.dbo.xp_fileexist @Path

EXECUTE       master.dbo.xp_instance_regread
              @rootkey      = N'HKEY_LOCAL_MACHINE',
              @key          = N'SYSTEM\CurrentControlSet\Services\SQLServerAgent',
              @value_name   = N'ObjectName',
              @value        = @ServiceAcct OUTPUT

SELECT @ServiceAcct

EXECUTE AS LOGIN = @ServiceAcct;
EXEC master.dbo.xp_fileexist @Path


--BACKUP DATABASE [WPC_837I]
--TO  DISK = N'\\sysstorage\jupiterarchive\Misc\WPC_837I\WPC_837I.bak'
--WITH NOFORMAT
--   , NOINIT
--   , NAME = N'WPC_837I-Full Database Backup'
--   , SKIP
--   , NOREWIND
--   , NOUNLOAD
--   , COMPRESSION
--   , STATS = 1;
--GO
