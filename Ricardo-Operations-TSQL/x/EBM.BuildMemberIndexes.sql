use HSP_Supplemental
go
set quoted_identifier on
go

---	Build member indexes and null out date fields

alter procedure EBM.BuildMemberIndexes
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			12/06/2017	1.00	RGB		Created new procedure
			12/07/2017	1.01	RGB		Modified indexes and types generated
			12/13/2017	1.02	RGB		Added update statements to change date fields to null, where necessary
			01/17/2018	1.03	RGB		Changed order of updates and indexing
			01/19/2018	1.04	RGB		Added fields for alternate address table
			01/31/2018	1.05	RGB		Added columns to drop from MemberAidCodes and MemberCoverageDetails
			02/02/2018	1.06	RGB		Added ResponsibleParties table fields and indexes
			02/09/2018	1.07	RGB		Altered columns for member aid codes to allow nulls for Effective and Expiration Dates
		
		*/

		declare @Version varchar(100) = '02/09/2018 09:30 Version 1.07'
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
			   ,@HSPStartDateOnly date = cast('1900-01-01' as date)
			   ,@HSPEndDateOnly date = cast('9999-12-31' as date)
			   ,@HSPEndDateOnly2 date = cast('2099-12-31' as date)

		alter table EBM.EnrolledMembers_AidCodes
		drop column MemberAidCodeId
			,SubscriberContractId
			,AidCodeId
			,AidCodeName
			,AidCodeAndName
			,AidCodeDescription
			,AidCodeClass
			,AidCodeClassName
			,AidCodeSubClass
			,AidCodeSubClassName
			,AidCodeCategory
			,AidCodeCategoryName
			,AidCodeSubCategory
			,AidCodeSubCategoryName
			,Benefits
			,SOC
			,LastUpdatedBy
			,LastUpdatedByName

		alter table EBM.EnrolledMembers_MemberCoverageDetails
		drop column MemberCoverageDetailsId
			,PlanCoverageDescription
			,BenefitCode
			,StatusCode
			,SOCStatusName
			,LastUpdatedBy

		update HSP_Supplemental.EBM.EnrolledMembers
		set	   DateFrom = null
		where  DateFrom = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers
		set	   DateTo = null
		where  DateTo = @HSPEndDate
			   or DateTo = @HSPEndDate2

		update HSP_Supplemental.EBM.EnrolledMembers
		set	   PCPEffectiveDate = null
		where  PCPEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers
		set	   PCPExpirationDate = null
		where  PCPExpirationDate = @HSPEndDate
			   or PCPExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.EnrolledMembers
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		alter table EBM.EnrolledMembers_AidCodes
		alter column EffectiveDate date null

		alter table EBM.EnrolledMembers_AidCodes
		alter column ExpirationDate date null

		update HSP_Supplemental.EBM.EnrolledMembers_AidCodes
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDateOnly

		update HSP_Supplemental.EBM.EnrolledMembers_AidCodes
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDateOnly
			   or ExpirationDate = @HSPEndDateOnly2

		update HSP_Supplemental.EBM.EnrolledMembers_AssignedProviders
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers_AssignedProviders
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.EnrolledMembers_MemberCOBs
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers_MemberCOBs
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.EnrolledMembers_MemberCoverageDetails
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers_MemberCoverageDetails
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.EnrolledMembers_ResponsibleParties
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers_ResponsibleParties
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.EnrolledMembers_AlternateAddress
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers_AlternateAddress
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		alter table HSP_Supplemental.EBM.EnrolledMembers_Reimbursements
		alter column EffectiveDate date null

		update HSP_Supplemental.EBM.EnrolledMembers_Reimbursements
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.EnrolledMembers_Reimbursements
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		drop index if exists IX_MemberNumber_EffectiveDate
			on HSP_Supplemental.EBM.EnrolledMembers

		create nonclustered index IX_MemberNumber_EffectiveDate
			on HSP_Supplemental.EBM.EnrolledMembers
		(
			MemberNumber
		   ,EffectiveDate
		)

		drop index if exists IX_MemberID_MembersLastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers

		create nonclustered index IX_MemberID_MembersLastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers
		(
			MemberID
		   ,MembersLastUpdatedAt
		)
			include
		(
			MemberNumber
		   ,EffectiveDate
		   ,ExpirationDate
		   ,BenefitCoveragesLastUpdatedAt
		   ,MemberCoverageID
		)

		drop index if exists IX_MemberId_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_AidCodes

		create nonclustered index IX_MemberId_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_AidCodes
		(
			MemberId
		   ,LastUpdatedAt
		)

		drop index if exists IX_MemberID_EffectiveDate
			on HSP_Supplemental.EBM.EnrolledMembers_AssignedProviders

		create nonclustered index IX_MemberID_EffectiveDate
			on HSP_Supplemental.EBM.EnrolledMembers_AssignedProviders
		(
			MemberID
		   ,EffectiveDate
		)

		drop index if exists IX_MemberId_EffectiveDate_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCOBs

		create nonclustered index IX_MemberId_EffectiveDate_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCOBs
		(
			MemberId
		   ,EffectiveDate
		   ,LastUpdatedAt
		)

		drop index if exists IX_MemberNumber_EffectiveDate
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCoverageDetails

		create nonclustered index IX_MemberNumber_EffectiveDate
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCoverageDetails
		(
			MemberNumber
		   ,EffectiveDate
		)

		drop index if exists IX_LastUpdatedAt_MemberCoverageId
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCoverageDetails

		create nonclustered index IX_LastUpdatedAt_MemberCoverageId
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCoverageDetails
		(
			LastUpdatedAt
		   ,MemberCoverageId
		)
			include
		(
			MemberNumber
		   ,EffectiveDate
		)

		drop index if exists CI_EntityId
			on HSP_Supplemental.EBM.EnrolledMembers_Languages

		create clustered index CI_EntityId
			on HSP_Supplemental.EBM.EnrolledMembers_Languages (EntityId)

		drop index if exists CI_EntityId_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCustomAttributes

		create clustered index CI_EntityId_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_MemberCustomAttributes
		(
			EntityID
		   ,ValueLastUpdatedAt
		)

		drop index if exists CI_EntityId_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_COBCustomAttributes

		create clustered index CI_EntityId_LastUpdatedAt
			on HSP_Supplemental.EBM.EnrolledMembers_COBCustomAttributes
		(
			EntityID
		   ,ValueLastUpdatedAt
		)

		drop index if exists IX_LastUpdatedAt_EntityType_MemberId
			on HSP_Supplemental.EBM.EnrolledMembers_AlternateAddress

		create nonclustered index IX_LastUpdatedAt_EntityType_MemberId
			on HSP_Supplemental.EBM.EnrolledMembers_AlternateAddress
		(
			LastUpdatedAt
		   ,EntityType
		   ,MemberId
		)
			include
		(
			PrimaryEntityIdentifier
		   ,AlternateAddressType
		   ,EffectiveDate
		   ,ExpirationDate
		)

		drop index if exists IX_LastUpdatedAt_MemberId
			on HSP_Supplemental.EBM.EnrolledMembers_ResponsibleParties

		create nonclustered index IX_LastUpdatedAt_MemberId
			on HSP_Supplemental.EBM.EnrolledMembers_ResponsibleParties
		(
			LastUpdatedAt
		   ,MemberId
		)
			include
		(
			GroupNumber
		   ,MemberNumber
		   ,EffectiveDate
		   ,ExpirationDate
		)

		return 0
	end
