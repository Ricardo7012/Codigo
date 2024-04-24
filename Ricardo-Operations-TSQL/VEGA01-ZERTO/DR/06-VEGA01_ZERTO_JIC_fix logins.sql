
/***********************************************************************
SINCE ZERTO DOES IT'S JOB WITH AD REPLICATION THIS WON'T BE NEEDED. 

DO THIS AS A TEMP MEASURE UNTIL WE HAVE F DRIVE AND SUPPORTING SERVERS AS WELL

DO NOT DO THIS WHEN WE ARE FAILING BACK FROM LV 
************************************************************************/
Declare @max int, @counter int = 1, @Sql varchar(max), @counter2 int, @max2 int, @Login varchar(128)
, @Error varchar(max), @DB varchar(512)
drop table if exists #Log
drop table if exists #DB
drop table if exists #Logins

create table #Log ( Logins varchar(128), DB varchar(256), StatusID int, [Messages] varchar(1024) )
create table #logins ( ID int identity(1,1) Primary key, Logins varchar(256) )
insert into  #Logins ( Logins )
values 
('EbmUser')
,('CIAUser')
,('LoggingUser')
,('IEHPBusinessApp')
,('web_prov')
,('webapi')
,('Behavioral_Health')
,('medhokuser')
,('ProviderSearchUser')
,('Sitecore82')


select [Name], row_number() over ( order by [Name] ) rowid
into #DB
from sys.databases
where database_id > 4
and [state] = 0
set @max = @@ROWCOUNT

while @counter <= @max
begin

	select	@DB = [Name]
	from	#DB
	where	rowid = @counter

	set @counter2 = 1
	select @max2 = ( select max(ID) from #logins )
	while @counter2 <= @max2
	begin

		select	@login = Logins
		from	#logins
		where	ID = @counter2

		select	@sql = 'Use [' + @DB + ']
						if exists ( select 1 from sys.database_principals where [type] = ''s'' and [Name] = ''' + @login + ''' )
						Begin
							exec sp_change_users_login ''Update_One'',''' + @login + ''', ''' + @login + '''
						End
						'
		from	#logins
		where	ID = @counter2

		begin try
			print (@sql)
			exec (@sql)

			insert into #Log ( logins, DB, StatusID, [Messages] )
			values (@Login, @DB,1,'Successful')
		end try
		begin catch
			set @error = ERROR_MESSAGE()
			insert into #Log ( logins, DB, StatusID, [Messages] )
			values (@Login, @DB,2,@Error)
		end catch
		set @counter2 = @counter2 + 1

	End

	set @counter = @counter + 1

end

select *
from #Log

