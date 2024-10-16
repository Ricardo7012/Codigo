use HSP_Supplemental
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapProvidersTables
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/09/2018	1.00	RGB		Created new procedure
		
		*/
		declare @Version varchar(100) = '05/09/2018 13:00 Version 1.00'
		declare @ReturnValues table
			(
				ReturnCode int primary key not null
			   ,Reason varchar(200) not null
			)

		insert into @ReturnValues (
									  ReturnCode
									 ,Reason
								  )
		values (0
			   ,'Normal Return')

		if @Showversion = 1
			begin
				select object_schema_name(@@PROCID) as SchemaName
					  ,object_name(@@PROCID) as ProcedureName
					  ,@Version as VersionInformation
				if isnull(@ShowReturn, 0) = 0
					return 0
			end

		if @ShowReturn = 1
			begin
				select *
				from   @ReturnValues
				return 0
			end

		set nocount on

		drop table if exists EBMLastRun.Providers

		select *
		into   EBMLastRun.Providers
		from   EBM.Providers with (nolock)

		drop table if exists EBMLastRun.Providers_OfficeMapCustomAttributes

		select *
		into   EBMLastRun.Providers_OfficeMapCustomAttributes
		from   EBM.Providers_OfficeMapCustomAttributes with (nolock)

		return 0
	end
go
