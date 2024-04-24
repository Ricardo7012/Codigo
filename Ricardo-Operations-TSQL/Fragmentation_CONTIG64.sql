-- https://www.mssqltips.com/sqlservertip/3008/solving-sql-server-database-physical-file-fragmentation/
ALTER DATABASE [HSP] SET OFFLINE
GO
-- RUN CONTIG
ALTER DATABASE [HSP] SET ONLINE
GO
USE HSP
GO

SELECT COUNT(*) FROM HSP.dbo.MemberAidCodesHistory

DBCC CHECKTABLE('HSP.dbo.MemberAidCodesHistory')

   SELECT sample_ms,
          num_of_reads,
          num_of_bytes_read,
          io_stall_read_ms,
          num_of_writes,
          num_of_bytes_written,
          io_stall_write_ms,
          io_stall,
          size_on_disk_bytes
     FROM sys.dm_io_virtual_file_stats (DB_ID ('MemberAidCodesHistory'), 1)
