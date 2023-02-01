--METHOD 1
DBCC SQLPERF('LOGSPACE');
--METHOD 2
EXEC sys.sp_databases;
	--SIZE OF DATABASE, IN KILOBYTES.
GO
--METHOD 3
SELECT  [TYPE] = A.type_desc
       ,[FILE_Name] = A.name
       ,[FILEGROUP_NAME] = fg.name
       ,[File_Location] = A.physical_name
       ,[FILESIZE_MB] = CONVERT(DECIMAL(10, 2), A.size / 128.0)
       ,[USEDSPACE_MB] = CONVERT(DECIMAL(10, 2), A.size / 128.0 - ( ( size
                                                              / 128.0 )
                                                              - CAST(FILEPROPERTY(A.name,
                                                              'SPACEUSED') AS INT)
                                                              / 128.0 ))
       ,[FREESPACE_MB] = CONVERT(DECIMAL(10, 2), A.size / 128.0
        - CAST(FILEPROPERTY(A.name, 'SPACEUSED') AS INT) / 128.0)
       ,[FREESPACE_%] = CONVERT(DECIMAL(10, 2), ( ( A.size / 128.0
                                                    - CAST(FILEPROPERTY(A.name,
                                                              'SPACEUSED') AS INT)
                                                    / 128.0 ) / ( A.size
                                                              / 128.0 ) )
        * 100)
       ,[AutoGrow] = 'By ' + CASE is_percent_growth
                               WHEN 0
                               THEN CAST(growth / 128 AS VARCHAR(10))
                                    + ' MB -'
                               WHEN 1 THEN CAST(growth AS VARCHAR(10)) + '% -'
                               ELSE ''
                             END + CASE max_size
                                     WHEN 0 THEN 'DISABLED'
                                     WHEN -1 THEN ' Unrestricted'
                                     ELSE ' Restricted to '
                                          + CAST(max_size / ( 128 * 1024 ) AS VARCHAR(10))
                                          + ' GB'
                                   END
        + CASE is_percent_growth
            WHEN 1 THEN ' [autogrowth by percent, BAD setting!]'
            ELSE ''
          END
FROM    sys.database_files A
        LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id
ORDER BY A.type DESC
       ,A.name; 

-- DO NOT DO THIS IN PROD
-- 1. PERFORM A FULL BACKUP -- IF SIMPLE RECOVERY MODEL STOP HERE
BACKUP DATABASE [HSP_CT] TO DISK='NUL:';
-- 2. BACKUP T-LOG -- ONLY IF FULL RECOVERY MODEL
BACKUP LOG [HSP_CT] TO DISK='NUL:';

--METHOD 4

declare @svrName varchar(255)
declare @sql varchar(400)
--by default it will take the current server name, we can the set the server name as well
set @svrName = @@SERVERNAME
set @sql = 'wmic logicaldisk get size,freespace,caption' --'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@svrName,'''') + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'
--creating a temporary table
CREATE TABLE #output
(line varchar(255))
--inserting disk name, total space and free space value in to temporary table

insert #output
EXEC xp_cmdshell @sql

select @svrName, * from #output

--script to retrieve the values in MB from PS Script output
select @svrName as zxz, rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
   ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
   (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float),0) as 'capacity(MB)'
   ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
   (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float),0) as 'freespace(MB)'
from #output
where line like '[A-Z][:]%'
order by drivename
--script to retrieve the values in GB from PS Script output
select @svrName as zxz, rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
   ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,
   (CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float)/1024,0) as 'capacity(GB)'
   ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,
   (CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float) /1024 ,0)as 'freespace(GB)'
from #output
where line like '[A-Z][:]%'
order by drivename
--script to drop the temporary table
drop table #output
