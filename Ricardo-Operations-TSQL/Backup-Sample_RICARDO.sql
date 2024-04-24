SELECT GETDATE(), @@SERVERNAME
SET STATISTICS TIME, IO ON;
GO
DBCC TRACEON(3004, 3051, 3212, 3014, 3605, 1816, -1); --TO BE USED ONLY FOR DEBUGGING
GO
PRINT 'START DT: ' + (CONVERT(VARCHAR(24), GETDATE(), 121));
GO

--WE PURPOSELY DID NOT ADD EXTENSION .BAK SO IT DOES NOT GET DELETED WITH CLEANUP JOB
BACKUP DATABASE [EBM]
TO  DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM.bak' 
WITH NOFORMAT
   , NOINIT
   , NAME = N'testing duration...'
   , SKIP
   , NOREWIND
   , NOUNLOAD
   , COMPRESSION
   , MAXTRANSFERSIZE=4194304
   , BUFFERCOUNT = 2048 -- 6144 
   , BLOCKSIZE = 65536
   --, COPY_ONLY -- **** MUST BE COPY_ONLY TO NOT BREAK THE CHAIN ****
   , STATS = 1;
GO

SELECT GETDATE(), @@SERVERNAME
SET STATISTICS TIME, IO OFF





SELECT GETDATE(), @@SERVERNAME
SET STATISTICS TIME, IO ON

--WE PURPOSELY DID NOT ADD EXTENSION .BAK SO IT DOES NOT GET DELETED WITH CLEANUP JOB
BACKUP DATABASE [EBM]
--TO DISK = 'NUL:' -- THE IDEAL BACKUP RATE IS DETERMINED BY BACKING THE DATABASE TO A ‘NUL’ TARGET
TO  
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_01.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_02.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_03.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_04.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_05.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_06.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_07.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_08.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_09.bak', 
DISK = N'\\dtsqlbkups\qvsqllit01backups\Red-Gate\Non-Production\VEGADEV\EBM_10.bak'
WITH NOFORMAT
   , NOINIT
   , NAME = N'testing duration...'
   , SKIP
   , NOREWIND
   , NOUNLOAD
   , COMPRESSION
   , MAXTRANSFERSIZE=4194304
   , BUFFERCOUNT = 2048 -- 6144 
   , BLOCKSIZE = 65536
   --, COPY_ONLY -- **** MUST BE COPY_ONLY TO NOT BREAK THE CHAIN ****
   , STATS = 1;
GO

SELECT GETDATE(), @@SERVERNAME
DBCC TRACEOFF(3004, 3051, 3212, 3014, 3605, 1816, -1);
GO
SET STATISTICS TIME, IO OFF;
GO


--MAXTRANSFERSIZE = { maxtransfersize | @ maxtransfersize_variable } Specifies the largest 
--unit of transfer in bytes to be used between SQL Server and the backup media. 
--The possible values are multiples of 65536 bytes (64 KB) ranging up to 4194304 bytes (4 MB).

--BUFFERCOUNT = { buffercount | @buffercount_variable } Specifies the total number of I/O buffers 
--to be used for the backup operation. You can specify any positive integer; however, large numbers 
--of buffers might cause "out of memory" errors because of inadequate virtual address space in the 
--Sqlservr.exe process.
--The total space used by the buffers is determined by: BUFFERCOUNT * MAXTRANSFERSIZE.

--BLOCKSIZE = { blocksize | @blocksize_variable } Specifies the physical block size, in bytes. 
--The supported sizes are 512, 1024, 2048, 4096, 8192, 16384, 32768, and 65536 (64 KB) bytes. 
--The default is 65536 for tape devices and 512 otherwise. Typically, this option is unnecessary because 
--BACKUP automatically selects a block size that is appropriate to the device. 
--Explicitly stating a block size overrides the automatic selection of block size.



