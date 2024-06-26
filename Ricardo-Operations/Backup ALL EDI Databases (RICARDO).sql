USE master
GO
SELECT GETDATE(), @@SERVERNAME

SET STATISTICS TIME ON
SET STATISTICS IO ON
 
--COPY_ONLY!! https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/copy-only-backups-sql-server 
BACKUP DATABASE [EdiManagementBlob] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\EdiManagementBlob.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [EdiManagementHub] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\EdiManagementHub.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [HspMember] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\HspMember.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [Member] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\Member.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [MemberDoc] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\MemberDoc.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [X12277CA] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12277CAaaa.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [X124010] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X124010.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [X12834] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12834.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [X12837I] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12837I.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [X12837P] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12837P.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [X12999] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12999.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO

BACKUP DATABASE [X12TA1] TO DISK = N'\\dtsqlbkups\qvsqllit01backups\Production\PVSQLEDI01\X12TA1.me' 
WITH  
DESCRIPTION = 'FOR MONTH END'
, COPY_ONLY --COPY_ONLY!! 
, NOFORMAT
, INIT
, NAME = N'FULL COPY_ONY FOR MONTH END'
, SKIP
, NOREWIND
, NOUNLOAD
, MAXTRANSFERSIZE=4194304
, BUFFERCOUNT = 2048
, COMPRESSION
, STATS = 10
GO



SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SELECT GETDATE(), @@SERVERNAME