use HSP_Supplemental
go
set ansi_nulls on
go
set quoted_identifier on
go

---	Drops the CPT codes modifier table and alters fields and builds appropriate indexes

create procedure EBM.BuildProcedureCodesIndexes
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			01/25/2018	1.00	RGB		Created new procedure
			02/21/2018	1.01	RGB		Added alter of Effective and Expiration dates to nullable and build index on table and renamed procedure
		
		*/

		declare @Version varchar(100) = '01/25/2018 09:00 Version 1.00'
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

		drop table if exists EBM.ProcedureCodes_Modifier

		alter table HSP_Supplemental.EBM.ProcedureCodes
		alter column EffectiveDate date null

		alter table HSP_Supplemental.EBM.ProcedureCodes
		alter column ExpirationDate date null

		update HSP_Supplemental.EBM.ProcedureCodes
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.ProcedureCodes
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		drop index if exists IX_ProcedureCodes_LastUpdatedAt
			on HSP_Supplemental.EBM.ProcedureCodes

		create nonclustered index IX_ProcedureCodes_LastUpdatedAt
			on HSP_Supplemental.EBM.ProcedureCodes
		(
			ProcedureCode
		   ,LastUpdatedAt
		)

	end
