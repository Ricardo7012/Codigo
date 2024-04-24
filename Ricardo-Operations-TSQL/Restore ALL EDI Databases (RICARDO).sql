SET STATISTICS TIME, IO ON
PRINT GETDATE()
PRINT @@SERVERNAME
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12TA1] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12TA1]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12TA1.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [X12TA1] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12999] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12999]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12999.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [X12999] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X124010] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X124010]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X124010.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [X124010] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12277CA] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12277CA]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12277CA.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [X12277CA] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12837P] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12837P]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12837P.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [X12837P] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12837I] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12837I]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12837I.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [X12837I] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [MemberDoc] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [MemberDoc]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\MemberDoc.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [MemberDoc] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [EdiManagementBlob] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [EdiManagementBlob]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\EdiManagementBlob.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [EdiManagementBlob] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [HspMember] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [HspMember]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\HspMember.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [HspMember] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [EdiManagementHub] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [EdiManagementHub]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\EdiManagementHub.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [EdiManagementHub] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12834] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12834]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12834.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [X12834] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [Member] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Member]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\Member.bak'
WITH FILE = 1,
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 5;
ALTER DATABASE [Member] SET MULTI_USER;
GO
PRINT GETDATE()
PRINT @@SERVERNAME
SET STATISTICS TIME, IO OFF
GO


/*******************************************************************************
IF IN AN AG GROUP 

https://www.mssqltips.com/sqlservertip/5194/automate-refresh-of-a-sql-server-database-that-is-part-of-an-availability-group/

*******************************************************************************/
--USE [master]
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [EdiManagementHub];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [HspMember];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [Member];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [MemberDoc] ;
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [X12277CA];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [X124010];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [X12834];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [X12837I];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [X12837P] ;
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [X12999];
--GO
--ALTER AVAILABILITY GROUP [PVHAGEDI01] REMOVE DATABASE [X12TA1];
--GO
