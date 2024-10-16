use HSP_Supplemental
go
set quoted_identifier on
go

---	Build Hospital and Hospital Entity Indexes and Null out date fields

alter procedure EBM.BuildHospitalIndexes
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			01/29/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '01/29/2018 08:00 Version 1.00'
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

		declare @HSPStartDate datetime = cast('1900-01-01' as datetime)
			   ,@HSPEndDate datetime = cast('9999-12-31' as datetime)
			   ,@HSPEndDate2 datetime = cast('2099-12-31' as datetime)

		update HSP_Supplemental.EBM.Hospitals
		set	   CorporationEffectiveDate = null
		where  CorporationEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Hospitals
		set	   CorporationExpirationDate = null
		where  CorporationExpirationDate = @HSPEndDate
			   or CorporationExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Hospitals
		set	   VendorEffectiveDate = null
		where  VendorEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Hospitals
		set	   VendorExpirationDate = null
		where  VendorExpirationDate = @HSPEndDate
			   or VendorExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Hospitals
		set	   ProviderOfficeEffectiveDate = null
		where  ProviderOfficeEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Hospitals
		set	   ProviderOfficeExpirationDate = null
		where  ProviderOfficeExpirationDate = @HSPEndDate
			   or ProviderOfficeExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Hospitals
		set	   PCMEffectiveDate = null
		where  PCMEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Hospitals
		set	   PCMExpirationDate = null
		where  PCMExpirationDate = @HSPEndDate
			   or PCMExpirationDate = @HSPEndDate2

		alter table HSP_Supplemental.EBM.Hospitals_EntityMap
		alter column EffectiveDate date null

		alter table HSP_Supplemental.EBM.Hospitals_EntityMap
		alter column ExpirationDate date null

		update HSP_Supplemental.EBM.Hospitals_EntityMap
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Hospitals_EntityMap
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		return 0
	end
