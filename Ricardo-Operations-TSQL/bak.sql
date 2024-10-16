USE [master];
ALTER DATABASE [HSP] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [HSP]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1A\HSP.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [HSP] SET MULTI_USER;

GO

USE [master];
ALTER DATABASE [HSPLicensing] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [HSPLicensing]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\HSP1S1A\HSPLicensing.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [HSPLicensing] SET MULTI_USER;

GO