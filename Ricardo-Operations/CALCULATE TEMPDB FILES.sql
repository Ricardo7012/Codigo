-- CALCULATE TEMPDB FILES
--This is the rule which script follows-
--•	For <= 8 cores 
--•	Tempdb data files = # of cores
--•	For > 8 cores 
--•	8 Tempdb data files

DECLARE @ProcessorCount varchar(4),
              @FilesToAdd tinyint,
              @MaxTempDBFileThreshold tinyint,
              @MinProcsRequired tinyint,
              @DivideProcsBy tinyint,
              @i tinyint,
              @TempDbDataDir varchar(255),
              @TempDbFileName varchar(20),
              @TempDbDataFileSize varchar(10),
              @TempDbLogFileSize varchar(10),
              @TempDbDataFileGrowth varchar(10),
              @TempDbLogFileGrowth varchar(10),
              @Sql varchar(max)

-- Set any parameters here - default of 5GB per file, 1GB growth increments 
set @TempDbDataFileSize = '5000MB'
set @TempDbLogFileSize = '1024MB'
set @TempDbDataFileGrowth = '1024MB'
set @TempDbLogFileGrowth = '1024MB'
set @MaxTempDBFileThreshold = 8  -- max number of tempdb files allowed
set @DivideProcsBy = 2  -- default at half number of procs - 1 for 1 per core, 4 for 1/4, 2 for 1/2, etc.
set @MinProcsRequired = 2  -- minimum threshold for procs before we start adding tempdb files

-- Read the registry to get # of procs
exec xp_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'NUMBER_OF_PROCESSORS', @ProcessorCount output

set @ProcessorCount = cast(rtrim(ltrim(@ProcessorCount)) as tinyint)

-- Get the location where tempdb was placed in install
set @TempDbDataDir = (select reverse(replace(reverse(physical_name),substring(reverse(physical_name),1,charindex('\',reverse(physical_name))-1),'')) as TempDbDataDir 
                                          from sys.master_files where name = 'tempdev')

-- Size the tempdb data/log files and set fixed filegrowth
set @Sql = 'alter database tempdb modify file (name = tempdev, size = ' + @TempDbDataFileSize + ', maxsize = unlimited, filegrowth = ' + @TempDbDataFileGrowth + ');'
print @Sql
--exec(@Sql)
set @Sql = 'alter database tempdb modify file (name = templog, size = ' + @TempDbLogFileSize + ', maxsize = unlimited, filegrowth = ' + @TempDbLogFileGrowth + ');'
print @Sql
--exec(@Sql)

if @ProcessorCount > @MinProcsRequired
begin

       set @FilesToAdd = case when @ProcessorCount > @MaxTempDBFileThreshold then (@MaxTempDBFileThreshold - 1) else (@ProcessorCount / @DivideProcsBy) - 1 end
       set @i = 1

       while @i <= @FilesToAdd
       begin
              
              set @TempDbFileName = 'tempdev0' + cast((@i + 1) as char(1))
              
              if not exists (select name from sys.master_files where database_id = 2 and name = @TempDbFileName)
                     begin
                           set @Sql = 'alter database tempdb add file (name = ''' + @TempDbFileName + ''', filename = ''' + @TempDbDataDir + @TempDbFileName + '.ndf'', 
                                                size = ' + @TempDbDataFileSize + ', maxsize = unlimited, filegrowth = ' + @TempDbDataFileGrowth + ');'
              
                           --print @Sql
                           exec(@Sql)
                     end
       set @i = @i + 1
       end
       
end
else
begin
       print 'Additional tempdb files not needed based on available number of processor cores.'
end
