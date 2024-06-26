use HSP_Supplemental
go
set ansi_nulls on
go
set quoted_identifier on
go
alter procedure EBM.CombineHospitalTables
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/25/2018	1.00	RGB		Created new procedure
			06/01/2018	1.01	RGB		Modified to include only one (1) hospital from providers and providers with offices
		
		*/
		declare @Version varchar(100) = '06/01/2018 09:00 Version 1.01'
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

		drop table if exists EBM.Hospitals
		drop table if exists EBM.CombinedHospitals

		select *
		into   EBM.CombinedHospitals
		from   (
				   select *
				   from	  EBM.HospitalsProvidersAndOffices with (nolock)
				   union
				   select *
				   from	  EBM.HospitalsProvidersOnly with (nolock)
			   ) hosp
		--	   
		;
		with onlyone
		  as
			  (
				  select   ProviderId
				  from	   EBM.CombinedHospitals with (nolock)
				  group by ProviderId
				  having   count(1) = 1
			  )
			,havetwo
		  as
			  (
				  select   ProviderId
				  from	   EBM.CombinedHospitals with (nolock)
				  group by ProviderId
				  having   count(1) = 2
			  )
		select hpo.*
		into EBM.Hospitals
		from   EBM.HospitalsProvidersOnly hpo with (nolock)
			   join onlyone oo
					on oo.ProviderId = hpo.ProviderId
		union
		select hpao.*
		from   EBM.HospitalsProvidersAndOffices hpao with (nolock)
			   join havetwo
					on havetwo.ProviderId = hpao.ProviderId

		return 0
	end
