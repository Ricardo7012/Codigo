-- SERVERNAME: QVSQLEDI01
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
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\X12TA1.me'
WITH FILE = 1,
	 MOVE 'X12TA1' to 'E:\Data\X12TA1.mdf',
	 MOVE 'X12TA1_log' to 'E:\Log\X12TA1_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [X12TA1] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12999] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12999]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\X12999.me'
WITH FILE = 1,
	 MOVE 'X12999' to 'E:\Data\X12999.mdf',
	 MOVE 'X12999_log' to 'E:\Log\X12999_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [X12999] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X124010] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X124010]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\X124010.me'
WITH FILE = 1,
	 MOVE 'X124010' to 'E:\Data\X124010.mdf',
	 MOVE 'X124010_log' to 'E:\Log\X124010_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [X124010] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12277CA] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12277CA]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\X12277CA.me'
WITH FILE = 1,
	 MOVE 'X12277CA' to 'E:\Data\X12277CA.mdf',
	 MOVE 'X12277CA_log' to 'E:\Log\X12277CA_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [X12277CA] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12837P] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12837P]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\X12837P.me'
WITH FILE = 1,
	 MOVE 'X12837P' to 'E:\Data\X12837P.mdf',
	 MOVE 'X12837P_log' to 'E:\Log\X12837P_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [X12837P] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12837I] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12837I]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\X12837I.me'
WITH FILE = 1,
	 MOVE 'X12837I' to 'E:\Data\X12837I.mdf',
	 MOVE 'X12837I_log' to 'E:\Log\X12837I_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [X12837I] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [MemberDoc] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [MemberDoc]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\MemberDoc.me'
WITH FILE = 1,
	 MOVE 'MemberDoc' to 'E:\Data\MemberDoc.mdf',
	 MOVE 'MemberDoc_log' to 'E:\Log\MemberDoc_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [MemberDoc] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
EXEC sys.sp_configure N'filestream access level', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
*******************************************************************************/
USE [master];
ALTER DATABASE [EdiManagementBlob] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [EdiManagementBlob]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\EdiManagementBlob.me'
WITH FILE = 1,
	 --MOVE N'EdiManagementBlob_data' to N'E:\Data\EdiManagementBlob.mdf',
	 --MOVE N'EdiManagementBlob_log' to N'E:\Log\EdiManagementBlob_log.ldf',
	 --MOVE N'EdiManagementBlob_AppResources' TO N'F:\Data\EdiManagementBlob_AppResources',
     --MOVE N'EdiManagementBlob_Transmissions' TO N'F:\Data\EdiManagementBlob_Transmissions',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [EdiManagementBlob] SET MULTI_USER;
GO

/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [EdiManagementHub] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [EdiManagementHub]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\EdiManagementHub.me'
WITH FILE = 1,
	 MOVE 'EdiManagementHub' to 'E:\Data\EdiManagementHub.mdf',
	 MOVE 'EdiManagementHub_log' to 'E:\Log\EdiManagementHub_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [EdiManagementHub] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [HspMember] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [HspMember]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\HspMember.me'
WITH FILE = 1,
	 MOVE 'HspMember' to 'E:\Data\HspMember.mdf',
	 MOVE 'HspMember_log' to 'E:\Log\HspMember_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [HspMember] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [X12834] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [X12834]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\X12834.me'
WITH FILE = 1,
	 MOVE 'X12834' to 'E:\Data\X12834.mdf',
	 MOVE 'X12834_log' to 'E:\Log\X12834_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
ALTER DATABASE [X12834] SET MULTI_USER;
GO
/******************************************************************************
RESTORE
*******************************************************************************/
USE [master];
ALTER DATABASE [Member] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [Member]
FROM DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI02\Member.me'
WITH FILE = 1,
	 MOVE 'Member' to 'E:\Data\Member.mdf',
	 MOVE 'Member_log' to 'E:\Log\Member_log.ldf',
     NOUNLOAD,
     REPLACE,
	 MAXTRANSFERSIZE=4194304,
	 BUFFERCOUNT=2048,
     STATS = 1;
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
