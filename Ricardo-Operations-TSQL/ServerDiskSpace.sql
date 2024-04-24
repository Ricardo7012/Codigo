--Create SQL Server Disk Space Report for All Servers
-- https://www.mssqltips.com/sqlservertip/5040/create-sql-server-disk-space-report-for-all-servers/ 

SET STATISTICS TIME ON
SET STATISTICS IO ON 

/*
Specifies that statements can read rows that have been modified by other transactions but not yet committed.
Transactions running at the READ UNCOMMITTED level do not issue shared locks to prevent other transactions 
from modifying data read by the current transaction. READ UNCOMMITTED transactions are also not blocked by 
exclusive locks that would prevent the current transaction from reading rows that have been modified but not 
committed by other transactions. When this option is set, it is possible to read uncommitted modifications, 
which are called dirty reads. 
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
USE master;
GO

CREATE TABLE #Temp
(
[Server] [varchar] (128) NULL,
[Database] [varchar] (128) NULL,
[File Name] [sys].[sysname] NOT NULL,
[Type] [varchar] (60) NULL,
[Path] [varchar] (260) NULL,
[File Size] [varchar] (53) NULL,
[File Used Space] [varchar] (53) NULL,
[File Free Space] [varchar] (53) NULL,
[% Free File Space] [varchar] (51) NULL,
[Autogrowth] [varchar] (53) NULL,
[volume_mount_point] [varchar] (256) NULL,
[Total Volume Size] [varchar] (53) NULL,
[Free Space] [varchar] (53) NULL,
[% Free] [varchar] (51) NULL
)

EXEC sp_MSforeachdb ' USE [?];
INSERT INTO #Temp
SELECT  @@SERVERNAME [Server] ,
        DB_NAME() [Database] ,
        MF.name [File Name] ,
        MF.type_desc [Type] ,
        MF.physical_name [Path] ,
        CAST(CAST(MF.size / 128.0 AS DECIMAL(15, 2)) AS VARCHAR(50)) + '' MB'' [File Size] ,
        CAST(CONVERT(DECIMAL(10, 2), MF.size / 128.0 - ( ( size / 128.0 ) - CAST(FILEPROPERTY(MF.name, ''SPACEUSED'') AS INT) / 128.0 )) AS VARCHAR(50)) + '' MB'' [File Used Space] ,
        CAST(CONVERT(DECIMAL(10, 2), MF.size / 128.0 - CAST(FILEPROPERTY(MF.name, ''SPACEUSED'') AS INT) / 128.0) AS VARCHAR(50)) + '' MB'' [File Free Space] ,
        CAST(CONVERT(DECIMAL(10, 2), ( ( MF.size / 128.0 - CAST(FILEPROPERTY(MF.name, ''SPACEUSED'') AS INT) / 128.0 ) / ( MF.size / 128.0 ) ) * 100) AS VARCHAR(50)) + ''%'' [% Free File Space] ,
        IIF(MF.growth = 0, ''N/A'', CASE WHEN MF.is_percent_growth = 1 THEN CAST(MF.growth AS VARCHAR(50)) + ''%'' 
                                    ELSE CAST(MF.growth / 128 AS VARCHAR(50)) + '' MB''
                                    END) [Autogrowth] ,
        VS.volume_mount_point ,
        CAST(CAST(VS.total_bytes / 1024. / 1024 / 1024 AS DECIMAL(20, 2)) AS VARCHAR(50))
        + '' GB'' [Total Volume Size] ,
        CAST(CAST(VS.available_bytes / 1024. / 1024 / 1024 AS DECIMAL(20, 2)) AS VARCHAR(50))
        + '' GB'' [Free Space] ,
        CAST(CAST(VS.available_bytes / CAST(VS.total_bytes AS DECIMAL(20, 2))
        * 100 AS DECIMAL(20, 2)) AS VARCHAR(50)) + ''%'' [% Free]
FROM    sys.database_files MF
        CROSS APPLY sys.dm_os_volume_stats(DB_ID(''?''), MF.file_id) VS
'

SELECT * FROM #Temp
 
DROP TABLE #Temp

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;