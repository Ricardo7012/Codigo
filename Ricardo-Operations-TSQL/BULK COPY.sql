--BULK COPY 

-- save below output in a bat file by executing below in SSMS in TEXT mode
-- clean up: create a bat file with this command --> del D:\BCP_OUT\*.dat 

select '"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\bcp.exe" '-- path to BCP.exe
        +  QUOTENAME(DB_NAME())+ '.'                                    -- Current Database
        +  QUOTENAME(SCHEMA_NAME(SCHEMA_ID))+'.'            
        +  QUOTENAME(name)  
        +  ' out D:\BCP_OUT\'                                           -- Path where BCP out files will be stored
        +  REPLACE(SCHEMA_NAME(schema_id),' ','') + '_' 
        +  REPLACE(name,' ','') 
        + '.dat -T -E -SSERVERNAME\INSTANCE -n'                         -- ServerName, -E will take care of Identity, -n is for Native Format
from sys.tables
where is_ms_shipped = 0 and name <> 'sysdiagrams'                       -- sysdiagrams is classified my MS as UserTable and we dont want it
and schema_name(schema_id) <> 'some_schema_exclude'                     -- Optional to exclude any schema 
order by schema_name(schema_id)                         



--- Execute this on the destination server.database from SSMS.
--- Make sure the change the @Destdbname and the bcp out path as per your environment.

declare @Destdbname sysname
set @Destdbname = 'destination_database_Name'               -- Destination Database Name where you want to Bulk Insert in
select 'BULK INSERT '                                       -- Remember Tables **must** be present on destination Database
        +  QUOTENAME(@Destdbname)+ '.'
        +  QUOTENAME(SCHEMA_NAME(SCHEMA_ID))+'.' 
        +  QUOTENAME(name) 
        + ' from ''D:\BCP_OUT\'                             -- Change here for bcp out path
        +  REPLACE(SCHEMA_NAME(schema_id),' ','') + '_'
        +  REPLACE(name,' ','') 
        +'.dat'' 
        with (
        KEEPIDENTITY,
        DATAFILETYPE = ''native'',  
        TABLOCK
        )'  + char(10) 
        + 'print ''Bulk insert for '+REPLACE(SCHEMA_NAME(schema_id),' ','') + '_'+  REPLACE(name,' ','')+' is done... '''+ char(10)+'go' 
from sys.tables
where is_ms_shipped = 0 and name <> 'sysdiagrams'           -- sysdiagrams is classified my MS as UserTable and we dont want it
and schema_name(schema_id) <> 'some_schema_exclude'         -- Optional to exclude any schema 
order by schema_name(schema_id)
--
