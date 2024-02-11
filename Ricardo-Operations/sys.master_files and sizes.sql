-- sys.master_files
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
go
SET STATISTICS TIME, IO ON;
GO
--:CONNECT Titan
use master;
go
select @@servername                                                  as VM
	 , d.[name] as DatabaseName
     , mf.[name] as LogicalName
     , [size]                                                        as [8KB-pages]
     , convert(decimal(12, 2), (sum([size] * 8.00)))                 as [KB]
     , convert(decimal(12, 2), (sum([size] * 8.00) / 1024.00))       as [MB]
     , convert(decimal(12, 2), (sum([size] * 8.00) / 1048576.00))    as [GB]
     , convert(decimal(12, 2), (sum([size] * 8.00) / 1073741824.00)) as [TB]
     , physical_name
from sys.master_files mf
	JOIN sys.databases d ON d.database_id = mf.database_id
    and mf.[state] <> 6 --= OFFLINE
    and mf.database_id > 4 --= NOT SYSTEM DBS
GROUP BY
    mf.physical_name
    , d.[name]
    , mf.[name]
    , mf.[size]
ORDER BY 
    d.[name] ASC;

SET STATISTICS TIME, IO OFF;
GO

-- where d.[name] not in
--       (
--           select DBName from dbo.DBBackupExclusion
--       )
--       and d.[name] not like 'VERSQL_%'
--       and d.[name] not like 'MARS_%'
--       and d.[name] not like 'BIZSQLB1_%'
--       and d.[name] not like 'VENUS_%'
--       and d.[name] not like 'pcce_%'
--       and d.[name] not like 'IEHPHARSQL_%'
--       and d.[name] not like 'TALLAN04_%'
--       and d.[name] not like 'PVSQLEDI04_%'
--       and d.[name] not like '%HEDIS_EDI834Audit_20181227%'
--       and d.[name] not like '%TDS_Processing%'
-- 	  and d.[name] not in
--           (
--               select [name]
--               from VEGA01.master.sys.databases
--               where database_id > 4
--                     and [name] <> 'Dwbi3'
--                     and [name] <> 'DB_Admin'
--           )
--       and mf.[state] <> 6 --OFFLINE 
--       and mf.database_id > 4  --SYSTEM DBS
-- group by physical_name
--        , d.[name]
-- 	   , mf.[name]
--        , [size]
-- order by d.[name] ASC;

