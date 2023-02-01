USE [master];
RESTORE DATABASE [FPNA_Landmark] FROM DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA_Landmark.bak' WITH FILE = 1
   , MOVE N'Landmark_log'
     TO N'L:\Log\FPNA_Landmark_log.ldf'
   , NOUNLOAD
   , MAXTRANSFERSIZE=4194304
   , REPLACE
   , STATS = 1;
GO

USE [master]
RESTORE DATABASE [FPNA_FinDev] FROM  DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA_FinDev.bak' WITH  FILE = 1,  MOVE N'FinDev_Log' TO N'L:\Log\FPNA_FinDev_Log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO
USE [FPNA_FinDev]
GO
DBCC SHRINKFILE (N'FinDev_Log' , 10240)
GO

USE [master]
RESTORE DATABASE [FPNA_Capitation] FROM  DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA_Capitation.bak' WITH  FILE = 1,  MOVE N'FPNA_Capitation_log' TO N'L:\Log\FPNA_Capitation_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO

USE [master]
RESTORE DATABASE [FPNA] FROM  DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA.bak' WITH  FILE = 1,  MOVE N'FPNA_log' TO N'L:\Log\FPNA_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO

USE [master]
RESTORE DATABASE [FPNA_RDT] FROM  DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA_RDT.bak' WITH  FILE = 1,  MOVE N'RDT_log' TO N'L:\Log\FPNA_RDT_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO
USE [FPNA_RDT]
GO
DBCC SHRINKFILE (N'RDT_log' , 10240)
GO

USE [master]
RESTORE DATABASE [FPNA_820] FROM  DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA_820.bak' WITH  FILE = 1,  MOVE N'FPNA_820_log' TO N'L:\Log\FPNA_820_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO

USE [master]
RESTORE DATABASE [FPNA_Membership] FROM  DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA_Membership.bak' WITH  FILE = 1,  MOVE N'Membership_log' TO N'L:\Log\FPNA_Membership_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO

USE [master]
RESTORE DATABASE [FPNA_DSS] FROM  DISK = N'\\dbbkup\backups\Thursday\20191118_Titan_FPNA_DSS.bak' WITH  FILE = 1,  MOVE N'DSS_log' TO N'L:\Log\FPNA_DSS_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO
USE [FPNA_DSS]
GO
DBCC SHRINKFILE (N'DSS_log' , 10240)
GO

USE [master]
RESTORE DATABASE [FPNA_Membership] FROM  DISK = N'\\dbbkup\backups\Thursday\20191121_Titan_FPNA_Membership.bak' WITH  FILE = 1,  MOVE N'Membership_log' TO N'L:\Log\FPNA_Membership_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO
USE [FPNA_Membership]
GO
DBCC SHRINKFILE (N'Membership_log' , 10240)
GO

-- + 1TB HUGE MOVE TO NEW LUN
USE [master]
RESTORE DATABASE [FPNA_Actuarial] FROM  DISK = N'\\dbbkup\backups\Thursday\20191121_Titan_FPNA_Actuarial.bak' WITH  FILE = 1,  MOVE N'Actuarial' TO N'F:\Data\FPNA_Actuarial.mdf',  MOVE N'Actuarial_log' TO N'F:\Log\FPNA_Actuarial_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO
USE [FPNA_Actuarial]
GO
DBCC SHRINKFILE (N'Actuarial_log' , 10240)
GO

USE [master]
RESTORE DATABASE [Capitation] FROM  DISK = N'\\dbbkup\backups\Thursday\20191121_VEGA01_Capitation.bak' WITH  FILE = 1,  MOVE N'capitation_data' TO N'F:\Data\capitation_data.mdf',  MOVE N'Capitation_IDX' TO N'F:\Data\Capitation_IDX.mdf',  MOVE N'capitation_log' TO N'F:\Log\Capitation_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 1
GO
USE [Capitation]
GO
DBCC SHRINKFILE (N'capitation_log' , 10240)
GO

USE [FPNA]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA] TO [_system_admin]
GO

USE [FPNA_820]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_820] TO [_system_admin]
GO

USE [FPNA_Capitation]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_Capitation] TO [_system_admin]
GO

USE [FPNA_DSS]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_DSS] TO [_system_admin]
GO

USE [FPNA_FinDev]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_FinDev] TO [_system_admin]
GO

USE [FPNA_Landmark]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_Landmark] TO [_system_admin]
GO

USE [FPNA_RDT]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_RDT] TO [_system_admin]
GO

GO
USE [master]
GO
ALTER DATABASE [FPNA] SET RECOVERY SIMPLE WITH NO_WAIT
GO

USE [master]
GO
ALTER DATABASE [FPNA_FinDev] SET RECOVERY SIMPLE WITH NO_WAIT
GO

USE [FPNA_Actuarial]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_Actuarial] TO [_system_admin]
GO

USE [FPNA_Membership]
GO
ALTER AUTHORIZATION ON DATABASE::[FPNA_Membership] TO [_system_admin]
GO

USE [Capitation]
GO
ALTER AUTHORIZATION ON DATABASE::[Capitation] TO [_system_admin]
GO
USE [master]
GO
ALTER DATABASE [Capitation] SET RECOVERY SIMPLE WITH NO_WAIT
GO
