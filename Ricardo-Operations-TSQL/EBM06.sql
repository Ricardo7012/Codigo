
-- 06 CREATE STORED PROCEDURES 
---	Build Hospital and Hospital Entity Indexes and Null out date fields
USE [HSP_Supplemental]
GO
CREATE procedure [EBM].[BuildHospitalIndexes]
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
GO
/****** Object:  StoredProcedure [EBM].[BuildMemberIndexes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Build member indexes and null out date fields

CREATE procedure [EBM].[BuildMemberIndexes]
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
GO
/****** Object:  StoredProcedure [EBM].[BuildProviderIndexes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Build provider indexes and null out date fields

create procedure [EBM].[BuildProviderIndexes]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			01/24/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '01/24/2018 14:00 Version 1.00'
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

		update HSP_Supplemental.EBM.Providers
		set	   CorporationEffectiveDate = null
		where  CorporationEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Providers
		set	   CorporationExpirationDate = null
		where  CorporationExpirationDate = @HSPEndDate
			   or CorporationExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Providers
		set	   VendorEffectiveDate = null
		where  VendorEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Providers
		set	   VendorExpirationDate = null
		where  VendorExpirationDate = @HSPEndDate
			   or VendorExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Providers
		set	   ProviderOfficeEffectiveDate = null
		where  ProviderOfficeEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Providers
		set	   ProviderOfficeExpirationDate = null
		where  ProviderOfficeExpirationDate = @HSPEndDate
			   or ProviderOfficeExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Providers
		set	   PCMEffectiveDate = null
		where  PCMEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Providers
		set	   PCMExpirationDate = null
		where  PCMExpirationDate = @HSPEndDate
			   or PCMExpirationDate = @HSPEndDate2

		drop index if exists IX_ProviderId_ProviderLastUpdatedAt
			on HSP_Supplemental.EBM.Providers

		create nonclustered index IX_ProviderId_ProviderLastUpdatedAt
			on HSP_Supplemental.EBM.Providers
		(
			ProviderId
		   ,ProviderLastUpdatedAt
		)
			include
		(
			ProviderOfficeMapID
		   ,PCMLastUpdatedAt
		)

		drop index if exists CI_EntityId_LastUpdatedAt
			on HSP_Supplemental.EBM.Providers_OfficeMapCustomAttributes

		create clustered index CI_EntityId_LastUpdatedAt
			on HSP_Supplemental.EBM.Providers_OfficeMapCustomAttributes
		(
			EntityId
		   ,ValueLastUpdatedAt
		)

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[BuildRiskGroupIndexes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Build Risk Group Indexes and Null out date fields

create procedure [EBM].[BuildRiskGroupIndexes]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			01/22/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '01/22/2018 10:00 Version 1.00'
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

		alter table HSP_Supplemental.EBM.RiskGroups
		alter column EffectiveDate date null

		alter table HSP_Supplemental.EBM.RiskGroups
		alter column ExpirationDate date null

		alter table HSP_Supplemental.EBM.RiskGroups_HospitalMappings
		alter column EffectiveDate date null

		alter table HSP_Supplemental.EBM.RiskGroups_HospitalMappings
		alter column ExpirationDate date null

		update HSP_Supplemental.EBM.RiskGroups
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.RiskGroups
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.RiskGroups_HospitalMappings
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.RiskGroups_HospitalMappings
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[DropProcedureCodesModifier]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Drops the CPT codes modifier table

create procedure [EBM].[DropProcedureCodesModifier]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			01/25/2018	1.00	RGB		Created new procedure
		
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

		drop table if exists EBM.ProcedureCodes_Modifier

	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracAidCodes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Aid Code values

CREATE procedure [EBM].[ExportMediTracAidCodes]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/01/2017	1.02	RGB		Added code to read ExportConfiguration table to determine if export is already running
			11/03/2017	1.03	RGB		Removed all return of data information
			01/25/2018	1.04	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.04'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.AidCodes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.AidCodes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Aid Code'

		exec HSP.dbo.rr_ExportAidCodes @ReturnStatus = 'N'
											 ,@ColumnList = ''
											 ,@TableUsage = '|RECREATE|'
											 ,@ResultTableName = 'Hsp_Supplemental.EBM.AidCodes'

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Aid Code'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMeditracChecks]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [EBM].[ExportMeditracChecks]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	PS		Created new procedure
			02/14/2018	1.01	RGB		Reworked to conform to existing export/read standards
		
		*/

		declare @Version varchar(100) = '02/14/2018 08:30 Version 1.01'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Checks'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Checks is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Checks'

		declare @StartDate date = cast('1900-01-01' as date)
			   ,@EndDate date = cast('9999-12-31' as date)

		declare @TableName varchar(200) = 'Hsp_Supplemental.EBM.Checks'
			   ,@ColumnList varchar(2000) = 'CheckId,CheckNumber,CheckDate,CheckAmount,CreationDate,ProcessedDate,MethodOfPayment,CheckStatus,EntityType,VendorID,ProviderNumber,OfficeID,ClaimId,ClaimNumber,EIN,VendorName'

		exec HSP.dbo.rr_ExportCheckData @Usage = '|ONEDETAILLEVEL|'
											  ,@StartDate = @StartDate
											  ,@EndDate = @EndDate
											  ,@ShowCheckDeposits = 'Y'
											  ,@ReturnGroupInfo = 'Y'
											  ,@ReturnProviderInfo = 'Y'
											  ,@ReturnOfficeInfo = 'Y'
											  ,@ReturnVendorInfo = 'Y'
											  ,@ReturnAccountInfo = 'Y'
											  ,@SessionID = null
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = @ColumnList
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = @TableName

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Checks'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMeditracClaims]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [EBM].[ExportMeditracClaims]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	PS		Created new procedure
			01/04/2018	1.01	RGB		Reworked to conform to existing export/read standards
			01/16/2018	1.02	RGB		Omitted parameter to include member information
			01/18/2018	1.03	RGB		Added claim detail lines to export process
			01/25/2018	1.04	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
			02/14/2018	1.05	RGB		Removed @StartDate and @EndDate parameters
		
		*/

		declare @Version varchar(100) = '02/14/2018 08:30 Version 1.05'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Claims'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Claims is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Claims'

		declare @StartDate date = cast('1900-01-01' as date)
			   ,@EndDate date = cast('9999-12-31' as date)

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.Claims'
			   ,@Command varchar(200) = 'drop table if exists '

		declare @ColumnList varchar(2000) =
			'ClaimId,ClaimNumber,AdjustmentVersion,LastUpdatedAt,ServiceDateFrom,ServiceDateTo,DateReceived,SubscriberNumber,ProviderNumber,ProviderNPI,OfficeNumber,VendorNumber,VendorId,Status,EIN,PatientAccountNumber,TotalCharges,ClaimTotalPaid'

		exec HSP.dbo.rr_ExportClaimDataComplete @Usage = '|LatestClaims|'
													  ,@DateUsage = '|DateLastUpdatedAt|'
													  ,@PeriodStart = @StartDate
													  ,@PeriodEnd = @EndDate
													  ,@ReturnExplanations = 'Y'
													  ,@ReturnInstitutionalClaimData = 'Y'
													  ,@ReturnMemberInfo = 'Y'
													  ,@ReturnProviderInfo = 'Y'
													  ,@ReturnOfficeInfo = 'Y'
													  ,@ReturnVendorInfo = 'Y'
													  ,@ReturnCheckInfo = 'Y'
													  ,@ReturnReferenceCodesName = 'Y'
													  ,@ReturnReferenceCodesNameLength = 20
													  ,@ReturnDiagnosisCodes = 'Y'
													  ,@ReturnPendingExplanation = 'Y'
													  ,@SessionId = null
													  ,@ReturnStatus = 'N'
													  ,@ColumnList = @ColumnList
													  ,@TableUsage = '|RECREATE|'
													  ,@ResultTableName = @TableName

-- SQL Prompt formatting off
		set @sql =
			'use ' + @DatabaseName + '; ' 
			+ @Command + @TableName + '_ActionCodes; ' 
			+ @Command + @TableName + '_ClaimCARCsRARCs; ' 
			+ @Command + @TableName + '_ClaimCOBData; ' 
			+ @Command + @TableName + '_ClaimCOBDataDetails; ' 
			+ @Command + @TableName + '_ClaimCodes; '
			+ @Command + @TableName + '_ClaimMasterData; ' 
			+ @Command + @TableName + '_ClaimReimbursementLog; ' 
			+ @Command + @TableName + '_CustomAttributes; ' 
			+ @Command + @TableName + '_DocumentRequests; '
			+ @Command + @TableName + '_Explanations; '
			+ @Command + @TableName + '_Financials; '
			+ @Command + @TableName + '_InputBatches; '
			+ @Command + @TableName + '_Institutional; '
			+ @Command + @TableName + '_LockData; '
			+ @Command + @TableName + '_LongTermCareData; '
			+ @Command + @TableName + '_Medi_CalPharmacyData; '
			+ @Command + @TableName + '_OverridesFromTransform; '
			+ @Command + @TableName + '_Parameters; '
			+ @Command + @TableName + '_PCPInformation; '
			+ @Command + @TableName + '_PendedWorkData; '
			+ @Command + @TableName + '_Pharmacy; '
			+ @Command + @TableName + '_ReAdjudicationWizardJobs; '
			+ @Command + @TableName + '_ReinsuranceData; '
			+ @Command + @TableName + '_ScreeningVisitData; '
-- SQL Prompt formatting on

		exec (@sql)

		set @TableName = 'Hsp_Supplemental.EBM.ClaimsDetail'
		set @ColumnList =
			'ClaimId,ClaimNumber,LastUpdatedAt,MemberId,ProviderId,AdjustmentVersion,LineNumber,LineServiceDateFrom,LineServiceDateTo,ResultStatus,Status,ProcedureCode,ServiceUnits,Amount,AmtPatientLiability,AmtCovered,AmtDisallowed,AmtCopay,'
			+ 'Modifier,Modifier2,Modifier3,Modifier4,DiagnosisPtrs,DiagnosisPtr1,DiagnosisPtr2,DiagnosisPtr4,ProductCodeQualifier,ProductCode,ProductQuantity,ProductUnitOfMeasure,DiagnosisCode1,DiagnosisCode2,DiagnosisCode3,DiagnosisCode4,'
			+ 'DiagnosisCode5,DiagnosisCode6,DiagnosisCode7,DiagnosisCode8,DiagnosisCode9,DiagnosisCode10,DiagnosisCode11,DiagnosisCode12,DiagnosisCode13,DiagnosisCode14,DiagnosisCode15,DiagnosisCode16,DiagnosisCode17,DiagnosisCode18,'
			+ 'DiagnosisCode19,DiagnosisCode20,DiagnosisCode21,DiagnosisCode22,DiagnosisCode23,DiagnosisCode24,GroupLineOfBusiness,GroupLineOfBusinessName'

		exec HSP.dbo.rr_ExportClaimDataComplete @Usage = '|LatestClaimLines|'
													  ,@DateUsage = '|DateLastUpdatedAt|'
													  ,@PeriodStart = @StartDate
													  ,@PeriodEnd = @EndDate
													  ,@ReturnReferenceCodesName = 'Y'
													  ,@ReturnReferenceCodesNameLength = 20
													  ,@ReturnDiagnosisCodes = 'Y'
													  ,@SessionId = null
													  ,@ReturnStatus = 'N'
													  ,@ColumnList = @ColumnList
													  ,@TableUsage = '|RECREATE|'
													  ,@ResultTableName = @TableName

-- SQL Prompt formatting off
		set @sql =
			'use ' + @DatabaseName + '; ' 
			+ @Command + @TableName + '_ActionCodes; ' 
			+ @Command + @TableName + '_ClaimCARCsRARCs; ' 
			+ @Command + @TableName + '_ClaimCOBData; ' 
			+ @Command + @TableName + '_ClaimCOBDataDetails; ' 
			+ @Command + @TableName + '_ClaimCodes; '
			+ @Command + @TableName + '_ClaimMasterData; ' 
			+ @Command + @TableName + '_ClaimReimbursementLog; ' 
			+ @Command + @TableName + '_CustomAttributes; ' 
			+ @Command + @TableName + '_DocumentRequests; '
			+ @Command + @TableName + '_Explanations; '
			+ @Command + @TableName + '_Financials; '
			+ @Command + @TableName + '_InputBatches; '
			+ @Command + @TableName + '_Institutional; '
			+ @Command + @TableName + '_LockData; '
			+ @Command + @TableName + '_LongTermCareData; '
			+ @Command + @TableName + '_Medi_CalPharmacyData; '
			+ @Command + @TableName + '_OverridesFromTransform; '
			+ @Command + @TableName + '_Parameters; '
			+ @Command + @TableName + '_PCPInformation; '
			+ @Command + @TableName + '_PendedWorkData; '
			+ @Command + @TableName + '_Pharmacy; '
			+ @Command + @TableName + '_ReAdjudicationWizardJobs; '
			+ @Command + @TableName + '_ReinsuranceData; '
			+ @Command + @TableName + '_ScreeningVisitData; '
-- SQL Prompt formatting on

		exec (@sql)

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Claims'

		return 0
	end

GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracContracts]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Provider Contracts

CREATE procedure [EBM].[ExportMediTracContracts]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/03/2017	1.02	RGB		Added code to read ExportConfiguration table to determine if export is already running
			12/14/2017	1.03	RGB		Modified table to remove bogus dates and change to null
			01/25/2018	1.04	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.04'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Contracts'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Contracts is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Contract'

		declare @sql varchar(2000)

		exec HSP.dbo.rr_ExportContracts @ReturnAmbulatoryProcedureCodeGroupingExceptions = 'N'
											  ,@SessionID = null
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = ''
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = 'HSP_Supplemental.EBM.Contracts'

		set @sql = 'use HSP_Supplemental; drop table if exists HSP_Supplemental.EBM.Contracts_AmbulatoryProcedureCodeGroupingExceptions'

		exec (@sql)

		update HSP_Supplemental.EBM.Contracts
		set	   ContractEffectiveDate = null
		where  ContractEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Contracts
		set	   ContractExpirationDate = null
		where  ContractExpirationDate = @HSPEndDate
			   or ContractExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Contracts
		set	   FeeScheduleEffectiveDate = null
		where  FeeScheduleEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Contracts
		set	   FeeScheduleExpirationDate = null
		where  FeeScheduleExpirationDate = @HSPEndDate
			   or FeeScheduleExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Contracts
		set	   ContractFeeScheduleEffectiveDate = null
		where  ContractFeeScheduleEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Contracts
		set	   ContractFeeScheduleExpirationDate = null
		where  ContractFeeScheduleExpirationDate = @HSPEndDate
			   or ContractFeeScheduleExpirationDate = @HSPEndDate2

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Contract'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracCorporations]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Corporations

CREATE procedure [EBM].[ExportMediTracCorporations]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/03/2017	1.02	RGB		Added code to read ExportConfiguration table to determine if export is already running
			12/14/2017	1.03	RGB		Modified table to remove bogus dates and change to null
			01/25/2018	1.04	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.04'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Corporations'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Corporations is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Corporation'

		exec HSP.dbo.rr_ExportCorporationsAndDetails @Usage = '|NORMAL|'
														   ,@SessionID = 0
														   ,@ReturnStatus = 'N'
														   ,@ColumnList = ''
														   ,@TableUsage = '|RECREATE|'
														   ,@ResultTableName = 'HSP_Supplemental.EBM.Corporations'

		update HSP_Supplemental.EBM.Corporations
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Corporations
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Corporation'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracDiagnosisCodes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Diagnosis Codes

CREATE procedure [EBM].[ExportMediTracDiagnosisCodes]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			10/31/2017	1.02	RGB		Added columnlist to return only the two columns needed
			11/03/2017	1.03	RGB		Added code to read ExportConfiguration table to determine if export is already running
			11/09/2017	1.04	RGB		Modified column list to only export two columns
			01/25/2018	1.05	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.05'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.DiagnosisCodes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.DiagnosisCodes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Diagnosis Code'

		exec HSP.dbo.rr_ExportDiagnosisCodes @Usage = '|ALL|'
												   ,@SessionID = 0
												   ,@ReturnStatus = 'N'
												   ,@ColumnList = 'DiagnosisCode, Description, LastUpdatedAt'
												   ,@TableUsage = '|RECREATE|'
												   ,@ResultTableName = 'HSP_Supplemental.EBM.DiagnosisCodes'

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Diagnosis Code'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracGroups]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Groups

CREATE procedure [EBM].[ExportMediTracGroups]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/03/2017	1.02	RGB		Added code to read ExportConfiguration table to determine if export is already running
			12/06/2017	1.03	RGB		Added column list to export and removed XML for custom attributes
			01/25/2018	1.04	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.04'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Groups'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Groups is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Group'

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.Groups'
			   ,@Command varchar(200) = 'drop table if exists '

		exec HSP.dbo.rr_GetGroupData @Usage = '|GROUPALL|'
										   ,@SessionID = 0
										   ,@ReturnStatus = 'N'
										   ,@ColumnList = 'GroupId,ParentId,GroupNumber,GroupName,LOB,LOBName,LastUpdatedAt'
										   ,@TableUsage = '|RECREATE|'
										   ,@ResultTableName = 'HSP_Supplemental.EBM.Groups'
-- SQL Prompt formatting off
			set @sql =
				'use ' + @DatabaseName + '; ' 
				+ @Command + @TableName + '_BillingEntities; ' 
				+ @Command + @TableName + '_Groups_COBActions; ' 
				+ @Command + @TableName + '_COBActions; ' 
				+ @Command + @TableName + '_Coverages; ' 
				+ @Command + @TableName + '_IDCardPackages; ' 
				+ @Command + @TableName + '_ImportLocations; '
				+ @Command + @TableName + '_MSPInformation; ' 
				+ @Command + @TableName + '_Reimbursements; ' 
				+ @Command + @TableName + '_ReinsurancePolicies; '
				+ @Command + @TableName + '_ServiceAreas;'
				+ @Command + @TableName + '_ServiceRestrictionPackages; '
				+ @Command + @TableName + '_TimelyFilings; '
				+ @Command + @TableName + '_UCRFeeSchedules; '
				+ @Command + @TableName + '_WorkersCompPolicies; '
-- SQL Prompt formatting on

		exec (@sql)

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Group'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracHospitals]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Hospitals

CREATE procedure [EBM].[ExportMediTracHospitals]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/03/2017	1.02	RGB		Added code to read ExportConfiguration table to determine if export is already running
			12/14/2017	1.03	RGB		Modified table to remove bogus dates and change to null
			01/26/2018	1.04	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
			01/29/2018	1.05	RGB		Combined hospital entity map extract
		
		*/

		declare @Version varchar(100) = '01/29/2018 08:00 Version 1.05'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Hospitals'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Hospitals is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Hospital'

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.Hospitals'
			   ,@Command varchar(200) = 'drop table if exists '

		exec HSP.dbo.rr_GetProviderData @Usage = '|ALL|'
											  ,@TimePeriod = '|ALLTIME|'
											  ,@Hospital = 'Y'
											  ,@DateUsage = '|ContractEffectiveWithinDateRange|'
											  ,@CustomAttributeEntity = 'PRV'
											  ,@SessionId = null
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = ''
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = @TableName
-- SQL Prompt formatting off
			set @sql =
				'use ' + @DatabaseName + '; ' 
				+ @Command + @TableName + '_AdditionalServices; '
				+ @Command + @TableName + '_CoveringGroups; '
				+ @Command + @TableName + '_ExceptionCapitationRates; '
				+ @Command + @TableName + '_ExceptionFeeSchedules; '
				+ @Command + @TableName + '_PanelMembers; '
				+ @Command + @TableName + '_ProviderSpecialtyMapping; '
				+ @Command + @TableName + '_SupervisedProviders; '
				+ @Command + @TableName + '_Supervisors;'
-- SQL Prompt formatting on
		exec (@sql)

		declare @AuxTableName varchar(200) = @TableName + '_EntityMap'

		exec HSP.dbo.rr_ExportHospitalEntityMap @SessionId = null
													  ,@ReturnStatus = 'N'
													  ,@ColumnList = ''
													  ,@TableUsage = '|RECREATE|'
													  ,@ResultTableName = @AuxTableName

		exec EBM.BuildHospitalIndexes

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Hospital'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracMembers]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Members and auxiliary tables

CREATE procedure [EBM].[ExportMediTracMembers]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			10/18/2017	1.02	RGB		Dropped ResponsibleParties and Reimbursements from list of tables returned
						1.03	RGB		Removed all references to refreshing and/or returning the data exported
						1.04	RGB		Reformatted to parameterize commands and added columnlist
			10/25/2017	1.05	RGB		Modified tables returned and dropped date parameters, in favor of TimePeriod
										Removed initial table drops
										Removed MemberCoverageDetails from final drop table list
			11/01/2017	1.06	RGB		Added code to read ExportConfiguration table to determine if export is already running
			11/14/2017	1.07	RGB		Remove Try/Catch and Transaction/Rollback/Commit as it fills up the log database and tempdb
			12/01/2017	1.08	RGB		Added Responsibile party table to list of tables required
										Added COB custom attributes export report to acquire the COB custom attributes information
										Added member custom attributes export report to acquire the member custom attributes information
			12/06/2017	1.09	RGB		Called BuildMemberIndexes as last step
			01/04/2018	1.10	RGB		Added county field to extracted values for enrolled members
			01/19/2018	1.11	RGB		Added member alternate addresses export
			01/22/2018	1.12	RGB		Changed procedure to call member export to new and improved version from HSP
			01/25/2018	1.13	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
			01/31/2018	1.14	RGB		Deleted the line that dropped Reimbursements table
			02/08/2018	1.15	RGB		Reverted to original export member procedure from HSP
		
		*/

		declare @Version varchar(100) = '02/08/2018 07:00 Version 1.15'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Member'

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.EnrolledMembers'
			   ,@Command varchar(200) = 'drop table if exists '
			   ,@MainColumnList varchar(2000) = 'ParentGroupNumber,LineOfBusinessName,DateFrom,DateTo,MemberID,SocialSecurityNumber,LastName,FirstName,MiddleName,NamePrefix,NameSuffix,'
												+ 'Address1,Address2,City,State,Zip,County,CountryCode,HomePhone,WorkPhone,CellPhone,Email,Gender,DateOfBirth,DateOfDeath,EthnicityName,HICN,MembersLastUpdatedAt,'
												+ 'MemberCoverageID,MemberNumber,MemberPolicyNumber,ProviderId,ProviderNumber,RiskGroupName,RiskGroupNumber,HospitalId,HospitalName,HospitalNumber,HospitalNPI,'
												+ 'PCPEffectiveDate,PCPExpirationDate,OfficeId,OfficeName,OfficeNumber,OfficeAddress1,OfficeAddress2,OfficeCity,OfficeState,OfficeZip,OfficeCountryCode,OfficeContactPhone,'
												+ 'ContractId,ContractName,BenefitCoverageId,BasePlanName,EffectiveDate,ExpirationDate,TerminationReasonName,BenefitCoveragesLastUpdatedAt,'
												+ 'GroupNumber,GroupName,ProductLineName,PCPProviderContractNumber'

		exec HSP.dbo.rr_ExportMembers_v2 @Usage = '|EnrolledMembers|'
											   ,@DateUsage = '|AllEffective|'
											   ,@TimePeriod = 'AllTime'
											   ,@ReturnSubscriberOnly = 'Y'
											   ,@ReturnOneDayTimeSlice = 'Y'
											   ,@ReturnPCPInfo = 'Y'
											   ,@IncludeMemberCOBs = 'Y'
											   ,@IncludeAidCodes = 'Y'
											   ,@IncludeLanguages = 'Y'
											   ,@IncludeMCD = 'Y'
											   ,@IncludeResponsibleParties = 'Y'
											   ,@IncludeReimbursements = 'Y'
											   ,@SessionId = null
											   ,@ReturnStatus = 'N'
											   ,@ColumnList = @MainColumnList
											   ,@TableUsage = '|RECREATE|'
											   ,@ResultTableName = @TableName

-- SQL Prompt formatting off
			set @sql =
				'use ' + @DatabaseName + '; ' 
				+ @Command + @TableName + '_Documentation; ' 
				+ @Command + @TableName + '_GroupCustomAttributes; ' 
				+ @Command + @TableName + '_InboundJobInfo; ' 
				+ @Command + @TableName + '_OutboundJobInfo; ' 
				+ @Command + @TableName + '_PreExistingConditions; '
				+ @Command + @TableName + '_Qualifiers; ' 
				+ @Command + @TableName + '_Riders; ' 
				+ @Command + @TableName + '_RiskGroups; '
				+ @Command + @TableName + '_COBCustomAttributes; '
				+ @Command + @TableName + '_MemberCustomAttributes; '
-- SQL Prompt formatting on

		exec (@sql)

		declare @AuxTableName varchar(200) = @TableName + '_COBCustomAttributes'
		declare @ColumnList varchar(100) = 'EntityID,AttributeName,AttributeValue,ValueLastUpdatedAt'

		exec HSP.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Member COB Map'
														   ,@Usage = '|VALUES|'
														   ,@SessionId = null
														   ,@ReturnStatus = 'N'
														   ,@ColumnList = @ColumnList
														   ,@TableUsage = '|RECREATE|'
														   ,@ResultTableName = @AuxTableName

		set @AuxTableName = @TableName + '_MemberCustomAttributes'

		exec HSP.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Member'
														   ,@Usage = '|VALUES|'
														   ,@SessionId = null
														   ,@ReturnStatus = 'N'
														   ,@ColumnList = @ColumnList
														   ,@TableUsage = '|RECREATE|'
														   ,@ResultTableName = @AuxTableName

		set @AuxTableName = @TableName + '_AlternateAddress'

		exec HSP.dbo.rr_ExportAlternateAddress @EntityTypeCode = 'MEM'
													 ,@SessionID = null
													 ,@ReturnStatus = 'N'
													 ,@ColumnList = ''
													 ,@TableUsage = '|RECREATE|'
													 ,@ResultTableName = @AuxTableName

		exec HSP_Supplemental.EBM.BuildMemberIndexes

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Member'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracProcedureCodes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Procedure Codes

CREATE procedure [EBM].[ExportMediTracProcedureCodes]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/03/2017	1.02	RGB		Added code to read ExportConfiguration table to determine if export is already running
			11/09/2017	1.03	RGB		Restricted column list to export to two columns
			11/16/2017	1.04	RGB		Added filter for only ICD10 procedure codes
			11/22/2017	1.05	RGB		Removed ICD10 filter, get all codes, add CodeType and LastUpdatedAt fields and then remove unneeded CodeType values (keeping only ICD10 and Custom)
			01/19/2018	1.06	RGB		Added CPT codes to list of available codes and removed transaction processing
			01/25/2018	1.07	RGB		Added CPT Modifier codes table to extract table
						1.08	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.08'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.ProcedureCodes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.ProcedureCodes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Procedure Code'

		exec HSP.dbo.rr_ExportProcedureCodes @Usage = '|ALL|'
												   ,@SessionID = 0
												   ,@ReturnStatus = 'N'
												   ,@ColumnList = 'ProcedureCode,Description,CodeType,LastUpdatedAt'
												   ,@TableUsage = '|RECREATE|'
												   ,@ResultTableName = 'HSP_Supplemental.EBM.ProcedureCodes'

		delete pc
		from   HSP_Supplemental.EBM.ProcedureCodes pc
		where  CodeType not in ('I10', 'CU', 'CP', 'RC')

		exec EBM.DropProcedureCodesModifier

		select Code as ModifierCode
			  ,Name as Description
			  ,LastUpdatedAt
		into   EBM.ProcedureCodes_Modifier
		from   HSP.dbo.ReferenceCodes with (nolock)
		where  Type = 'modifier'
			   and Subtype = 'modifier'
			   and (
					   ProductName is null
					   or ProductName = 'meditrac'
				   )

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Procedure Code'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracProviders]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Providers and associated tables

CREATE procedure [EBM].[ExportMediTracProviders]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/10/2017	1.00	RGB		Created new procedure
			10/11/2017	1.01	RGB		Added UpdatedOn to return table values since this date
			10/12/2017	1.02	RGB		Added TimePeriod (per HSP) to return all provider and contract information
			10/13/2017	1.03	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/03/2017	1.04	RGB		Added code to read ExportConfiguration table to determine if export is already running
			12/14/2017	1.05	RGB		Modified table to remove bogus dates and change to null
			01/04/2018	1.06	RGB		Added provider office map custom attributes to export process and added new indexes
			01/24/2018	1.07	RGB		Moved the alter/update/indexing to a separate script and removed transaction processing
			01/25/2018	1.08	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.08'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Providers'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Providers is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Provider'

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.Providers'
			   ,@Command varchar(200) = 'drop table if exists '

		exec HSP.dbo.rr_GetProviderData @Usage = '|ALL|'
											  ,@Hospital = 'N'
											  ,@TimePeriod = '|ALLTIME|'
											  ,@ReturnLanguage = 'ALL'
											  ,@DateUsage = '|ContractEffectiveWithinDateRange|'
											  ,@CustomAttributeEntity = 'PRV'
											  ,@SessionId = 0
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = ''
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = 'Hsp_Supplemental.EBM.Providers'
-- SQL Prompt formatting off
			set @sql =
				'use ' + @DatabaseName + '; ' 
				+ @Command + @TableName + '_AdditionalServices; '
				+ @Command + @TableName + '_CoveringGroups; '
				+ @Command + @TableName + '_ExceptionCapitationRates; '
				+ @Command + @TableName + '_ExceptionFeeSchedules; '
				+ @Command + @TableName + '_PanelMembers; '
				+ @Command + @TableName + '_ProviderSpecialtyMapping; '
				+ @Command + @TableName + '_SupervisedProviders; '
				+ @Command + @TableName + '_Supervisors;'
-- SQL Prompt formatting on
		exec (@sql)

		exec HSP.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Provider Office Map'
														   ,@Usage = '|VALUES|'
														   ,@SessionId = null
														   ,@ReturnStatus = 'N'
														   ,@ColumnList = 'EntityID,AttributeName,AttributeValue,ValueLastUpdatedAt'
														   ,@TableUsage = '|RECREATE|'
														   ,@ResultTableName = 'Hsp_Supplemental.EBM.Providers_OfficeMapCustomAttributes'

		exec HSP_Supplemental.EBM.BuildProviderIndexes

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Provider'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracRiskGroups]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Risk Groups

CREATE procedure [EBM].[ExportMediTracRiskGroups]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	RGB		Created new procedure
			10/13/2017	1.01	LBF		Added RefreshData and defaulted ReturnData and RefreshData to on
			11/03/2017	1.02	RGB		Added code to read ExportConfiguration table to determine if export is already running
			12/14/2017	1.03	RGB		Modified table to remove bogus dates and change to null
			01/22/2018	1.04	RGB		Added alternate address export to this export process
										Removed transaction processing
			01/26/2018	1.05	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/26/2018 06:30 Version 1.05'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.RiskGroups'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.RiskGroups is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Risk Group'

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.RiskGroups'
			   ,@Command varchar(200) = 'drop table if exists '

		exec HSP.dbo.rr_ExportRiskGroups @ReturnHospitalMappings = 'Y'
											   ,@Usage = '|GETRISKGROUPS|'
											   ,@SessionId = null
											   ,@ReturnStatus = 'N'
											   ,@ColumnList = ''
											   ,@TableUsage = '|RECREATE|'
											   ,@ResultTableName = @TableName
-- SQL Prompt formatting off
		set @sql =
			'use ' + @DatabaseName + '; ' 
			+ @Command + @TableName + '_AdditionalContacts; '
			+ @Command + @TableName + '_AlternateAddress; '
			+ @Command + @TableName + '_Attachments; '
			+ @Command + @TableName + '_CapitatedVendors; '
			+ @Command + @TableName + '_DelegatedServices; '
			+ @Command + @TableName + '_ReimbursementMappings; '
			+ @Command + @TableName + '_RiskGroupHistory; '
-- SQL Prompt formatting on
		exec (@sql)

		declare @AuxTableName varchar(200) = @TableName + '_AlternateAddress'

		exec HSP.dbo.rr_ExportAlternateAddress @EntityTypeCode = 'RKP'
													 ,@SessionID = 0
													 ,@ReturnStatus = 'N'
													 ,@ColumnList = ''
													 ,@TableUsage = '|RECREATE|'
													 ,@ResultTableName = @AuxTableName

		exec EBM.BuildRiskGroupIndexes

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Risk Group'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ExportMediTracVendors]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Exports the MediTrac Vendors

CREATE procedure [EBM].[ExportMediTracVendors]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/16/2017	1.00	RGB		Created new procedure
			11/03/2017	1.01	RGB		Added code to read ExportConfiguration table to determine if export is already running
			12/14/2017	1.02	RGB		Modified table to remove bogus dates and change to null
			01/26/2018	1.03	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
										Added export of alternate addresses
		
		*/

		declare @Version varchar(100) = '01/26/2018 06:30 Version 1.03'
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

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Vendors'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Vendors is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; export cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; export cancelled', 3

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,PreviousExecution = @LastJobRun
			  ,LastExecution = null
		where  ComponentName = 'Vendor'

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.Vendors'
			   ,@Command varchar(200) = 'drop table if exists '

		exec HSP.dbo.rr_ExportVendors @Usage = '|Normal|'
											,@SessionID = 0
											,@ReturnStatus = 'N'
											,@ColumnList = ''
											,@TableUsage = '|RECREATE|'
											,@ResultTableName = 'Hsp_Supplemental.EBM.Vendors'
-- SQL Prompt formatting off
			set @sql =
				'use ' + @DatabaseName + '; ' 
				+ @Command + @TableName + '_CheckOutput835Mappings; '
				+ @Command + @TableName + '_PaymentQualifierMappings;'
-- SQL Prompt formatting on
		exec (@sql)

		declare @AuxTableName varchar(200) = @TableName + '_AlternateAddress'

		exec HSP.dbo.rr_ExportAlternateAddress @EntityTypeCode = 'VEN'
													 ,@SessionID = null
													 ,@ReturnStatus = 'N'
													 ,@ColumnList = ''
													 ,@TableUsage = '|RECREATE|'
													 ,@ResultTableName = @AuxTableName

		update HSP_Supplemental.EBM.Vendors
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Vendors
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Vendors
		set	   PayToEffectiveDate = null
		where  PayToEffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Vendors
		set	   PayToExpirationDate = null
		where  PayToExpirationDate = @HSPEndDate
			   or PayToExpirationDate = @HSPEndDate2

		update HSP_Supplemental.EBM.Vendors_AlternateAddress
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.Vendors_AlternateAddress
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
			  ,LastExecution = @Now
		where  ComponentName = 'Vendor'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[GenerateSchemaStructure]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [EBM].[GenerateSchemaStructure]
	@Showversion BIT = 0
   ,@ShowReturn BIT = 0
   ,@TargetDataBase VARCHAR(50) = 'Ebm-Dev'
   ,@TargetSchema VARCHAR(30) = 'Meditrac' 
   ,@TargetTable VARCHAR(100) = 'EnrolledMembers'
   
AS
	set nocount on
	BEGIN
		/*
			Modification Log:
		
		*/
		declare @Version varchar(100) = '10/28/2017 7:00 Version 1.00'
		declare @ReturnValues table
			(
				ReturnCode int primary key not null
			   ,Reason varchar(200) not null
			)

		insert into @ReturnValues (
									  ReturnCode
									 ,Reason
								  )
		values (0, 'Normal Return')

		if @Showversion = 1
			begin
				select object_schema_name(@@PROCID) as SchemaName
					  ,object_name(@@PROCID) as ProcedureName
					  ,@Version as VersionInformation
				IF ISNULL(@ShowReturn, 0) = 0
					RETURN 0
			END

		if @ShowReturn = 1
			begin
				select *
				from   @ReturnValues
				RETURN 0
			END
			/***********************************************************************/

			--Get table structure

			DECLARE @TableStructureSql VARCHAR(MAX) = NULL, @TableType VARCHAR(MAX) = NULL, @procedure VARCHAR(MAX) = NULL, @TargeTableType VARCHAR(50) = @TargetTable+'Insert.Type', @TargetProcedure VARCHAR(50) = @TargetTable+'Insert'
            

			SET @TableStructureSql = 'Use ['+@TargetDataBase + ']'+ ' if exists (select * from INFORMATION_SCHEMA.Tables where Table_name = '+''''+@TargetTable+''''+' and table_schema = '+''''+@targetschema+''''+')'+ ' Drop table ['+ @targetschema+'].['+@TargetTable + '] '
			SET @TableStructureSql = @TableStructureSql + ' Create table ['+@targetschema+'].['+@TargetTable+'] ('
			SELECT @TableStructureSql = 	COALESCE(@TableStructureSql+' ','') +	struct
												FROM
												(	
											   SELECT
											   CASE WHEN character_maximum_length IS NOT NULL THEN column_name+' '+ data_type+'('+CAST(character_maximum_length AS VARCHAR(5)) +') '
											   +CASE WHEN IS_NULLABLE = 'YES' THEN 'Null' ELSE 'NOT NULL' END									   
											   +',' 
											   ELSE COLUMN_NAME+ ' ' + DATA_TYPE+','
											   END AS struct
											   FROM INFORMATION_SCHEMA.COLUMNS 
											   WHERE table_name = @TargetTable
											   ) AS myderivedTable

							SELECT SUBSTRING(@TableStructureSql,1,LEN(@TableStructureSql)-1)+', '+@TargetTable+'Key [Bigint] IDENTITY(1,1)'+')' AS TableSql, @TargetSchema+'.'+@TargetTable AS TableName
		
		/*******************GET TABLE TYPE********************************/

		SET @TableType = 'Use ['+@TargetDataBase + ']'+ ' if exists (select * from sys.Types where is_table_type = 1 and name = '+''''+@TargeTableType+''''+')'+ ' Drop Type ['+ @targetschema+'].['+@TargeTableType + '] '
			SET @TableType = @TableType + ' Create Type ['+@targetschema+'].['+@TargeTableType+'] AS TABLE ('
			SELECT @TableType = 	COALESCE(@TableType+' ','') +	struct
												FROM
												(	
											   SELECT
											   CASE WHEN character_maximum_length IS NOT NULL THEN column_name+' '+ data_type+'('+CAST(character_maximum_length AS VARCHAR(5)) +') '
											   +CASE WHEN IS_NULLABLE = 'YES' THEN 'Null' ELSE 'NOT NULL' END									   
											   +',' 
											   ELSE COLUMN_NAME+ ' ' + DATA_TYPE+','
											   END AS struct
											   FROM INFORMATION_SCHEMA.COLUMNS 
											   WHERE table_name = @TargetTable
											   ) AS myderivedTable

							SELECT SUBSTRING(@TableType,1,LEN(@TableType)-1)+')' AS TableTypeSql,@TargetSchema+'.'+@TargeTableType AS TypeName
			
		/**********************STORED PROCEUDRE***********************************************/

		DECLARE @dropCommand VARCHAR(200) = ''
		DECLARE @useDbCommand VARCHAR(50) = 'Use ['+@TargetDataBase+']'
		SET @procedure = 'Use ['+@TargetDataBase + ']'+ ' if exists (select 1 from sys.procedures where name ='+''''+@TargetProcedure+''''+')'+ ' Drop Procedure ['+ @targetschema+'].['+@TargetProcedure +'] '
		SET @dropCommand = @procedure
			SET @procedure =  'Create Procedure ['+@targetschema+'].['+@TargetProcedure +'] @source ['+@targetschema+'].['+@TargetProcedure+'.Type] READONLY as set nocount on insert into ['+@targetschema+'].['+@TargetTable+'] ('
			SELECT @procedure = 	COALESCE(@procedure+' ','') +	struct
												FROM
												(	
											   SELECT COLUMN_NAME+','
											   AS struct
											   FROM INFORMATION_SCHEMA.COLUMNS 
											   WHERE table_name = @TargetTable
											   ) AS myderivedTable

					SET @procedure = SUBSTRING(@procedure,1,LEN(@procedure)-1)+')' 
					SELECT @procedure+ ' Select * from @source' AS StoredProcSql, @TargetSchema+'.'+@TargetProcedure AS procedureName, @dropCommand AS DropProcedureSql, @useDbCommand AS UseDbSql


			END
GO
/****** Object:  StoredProcedure [EBM].[GetMediTracTables]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Get the tables and stored procedure names for MediTrac exports for any component

CREATE procedure [EBM].[GetMediTracTables]
	@ComponentName varchar(50) = null
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/20/2017	1.00	RGB		Created new procedure
		
		*/
		declare @Version varchar(100) = '10/20/2017 09:00 Version 1.00'
		declare @ReturnValues table
			(
				ReturnCode int primary key not null
			   ,Reason varchar(200) not null
			)

		insert into @ReturnValues (
									  ReturnCode
									 ,Reason
								  )
		values (0, 'Normal Return')

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

		select	 *
		from	 EBM.ExportConfiguration with (nolock)
		where	 @ComponentName is null
				 or ComponentName = @ComponentName
		order by ComponentName

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ProviderMapRead]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [EBM].[ProviderMapRead]
-- SourceDate is LastUpdatedAt?
as set nocount on

	-- must match EbmDb.diamond.[ProviderBridgeWrite.Type]

	select	DiamondID = SourceNumber,
			ProviderNPI = ProviderNPI,
			ProviderKey = cast(null as bigint)
	from	dbo.Conversion_Providers p
	where	SourceName LIKE 'JPROV%'
	and		isnull(ProviderNPI, '') != ''
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracAidCodes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members Aid Code resultset

CREATE procedure [EBM].[ReadMediTracAidCodes]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/25/2018	1.01	RGB		Removed transaction processing and added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.AidCodes with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.AidCodes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.AidCodes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.AidCodes'

		select *
		from   EBM.AidCodes with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.AidCodes'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracClaims]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Claims resultset

CREATE procedure [EBM].[ReadMediTracClaims]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/17/2018	1.01	RGB		Corrected table reference for schema only
			01/25/2018	1.02	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.02'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Claims with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Claims'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Claims is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Claims'

		select *
		from   EBM.Claims with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Claims'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracContracts]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Contracts resultset

CREATE procedure [EBM].[ReadMediTracContracts]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/25/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Contracts with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Contracts'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Contracts is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Contracts'

		select *
		from   EBM.Contracts with (nolock)
		where  @LastJobRun is null
			   or ContractLastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Contracts'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracCorporations]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Corporations resultset

CREATE procedure [EBM].[ReadMediTracCorporations]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/25/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Corporations with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Corporations'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Corporations is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Corporations'

		select *
		from   EBM.Corporations with (nolock)

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Corporations'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracDiagnosisCodes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Diagnosis Codes resultset

CREATE procedure [EBM].[ReadMediTracDiagnosisCodes]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/25/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.DiagnosisCodes with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.DiagnosisCodes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.DiagnosisCodes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.DiagnosisCodes'

		select *
		from   EBM.DiagnosisCodes with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.DiagnosisCodes'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracGroups]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Groups resultset

CREATE procedure [EBM].[ReadMediTracGroups]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/25/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Groups with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Groups'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Groups is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Groups'

		select *
		from   EBM.Groups with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Groups'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracHospitalEntityMap]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Hospital Entity Map resultset

CREATE procedure [EBM].[ReadMediTracHospitalEntityMap]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/29/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Hospitals_EntityMap with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Hospitals_EntityMap'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Hospitals_EntityMap is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Hospitals_EntityMap'

		select *
		from   EBM.Hospitals_EntityMap with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Hospitals_EntityMap'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracHospitals]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Hospitals resultset

CREATE procedure [EBM].[ReadMediTracHospitals]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/29/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Hospitals with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Hospitals'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Hospitals is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Hospitals'

		select *
		from   EBM.Hospitals with (nolock)
		where  @LastJobRun is null
			   or ProviderLastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Hospitals'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberAidCodes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members Aid Code resultset

CREATE procedure [EBM].[ReadMediTracMemberAidCodes]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/17/2017	1.00	RGB		Created new procedure
			10/20/2017	1.01	RGB		Added SchemaOnly parameter
						1.02	RGB		Added check of IsInUse flag to determine if we can run or not
			11/03/2017	1.03	RGB		Moved schema only return information and took out restriction on data returned
			11/08/2017	1.04	RGB		Implemented Offset, RowCount and TotalRecords parameters to allow returning of data in a paged environment
			12/06/2017	1.05	RGB		Removed indexing
			01/29/2018	1.06	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.06'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.EnrolledMembers_AidCodes with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_AidCodes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_AidCodes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_AidCodes with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_AidCodes'
			end

		select	 *
		from	 EBM.EnrolledMembers_AidCodes with (nolock)
		where	 @LastJobRun is null
				 or LastUpdatedAt > @LastJobRun
		order by MemberId
				,EffectiveDate offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_AidCodes'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberAlternateAddress]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Member Alternate Address resultset

CREATE procedure [EBM].[ReadMediTracMemberAlternateAddress]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/09/2018	1.01	RGB		Added ability to "page" using offset
			01/19/2018	1.02	RGB		Changed to new table name
			01/29/2018	1.03	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.03'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.EnrolledMembers_AlternateAddress with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_AlternateAddress'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_AlternateAddress is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_AlternateAddress with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_AlternateAddress'
			end

		select	 *
		from	 EBM.EnrolledMembers_AlternateAddress with (nolock)
		where	 @LastJobRun is null
				 or LastUpdatedAt > @LastJobRun
		order by MemberId
				,EffectiveDate offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_AlternateAddress'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberAssignedProviders]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members Assigned Providers resultset

CREATE procedure [EBM].[ReadMediTracMemberAssignedProviders]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/17/2017	1.00	RGB		Created new procedure
			10/20/2017	1.01	RGB		Added SchemaOnly parameter
						1.02	RGB		Added check of IsInUse flag to determine if we can run or not
			11/01/2017	1.03	RGB		Changed check for date to PreviousExecution
			11/03/2017	1.04	RGB		Moved schema only return information and took out restriction on data returned
			11/08/2017	1.05	RGB		Implemented Offset, RowCount and TotalRecords parameters to allow returning of data in a paged environment
			12/06/2017	1.06	RGB		Removed indexing
			01/29/2018	1.07	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.07'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.EnrolledMembers_AssignedProviders with (nolock)
				return 0
			end

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_AssignedProviders'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_AssignedProviders is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_AssignedProviders with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_AssignedProviders'
			end

		select	 *
		from	 EBM.EnrolledMembers_AssignedProviders with (nolock)
		order by MemberID
				,EffectiveDate offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_AssignedProviders'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberCobCustomAttributes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members custom attributes resultset

CREATE procedure [EBM].[ReadMediTracMemberCobCustomAttributes]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			12/07/2017	1.00	RGB		Created new procedure
			01/29/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.01'
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

		if @SchemaOnly = 1
			select top (0)
				   *
			from   EBM.EnrolledMembers_COBCustomAttributes with (nolock)

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_COBCustomAttributes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_COBCustomAttributes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_COBCustomAttributes with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_COBCustomAttributes'
			end

		select	 *
		from	 EBM.EnrolledMembers_COBCustomAttributes with (nolock)
		where	 ValueLastUpdatedAt > @LastJobRun
				 or @LastJobRun is null
		order by EntityID
				,ValueLastUpdatedAt offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_COBCustomAttributes'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberCobs]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members Coordination of Benefits resultset

CREATE procedure [EBM].[ReadMediTracMemberCobs]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/17/2017	1.00	RGB		Created new procedure
			10/20/2017	1.01	RGB		Added SchemaOnly parameter
						1.02	RGB		Added check of IsInUse flag to determine if we can run or not
			11/01/2017	1.03	RGB		Changed check for date to PreviousExecution
			11/03/2017	1.04	RGB		Moved schema only return information and took out restriction on data returned
			11/08/2017	1.05	RGB		Implemented Offset, RowCount and TotalRecords parameters to allow returning of data in a paged environment
			12/06/2017	1.06	RGB		Removed indexing
			01/29/2018	1.07	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.07'
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

		if @SchemaOnly = 1
			select top (0)
				   *
			from   EBM.EnrolledMembers_MemberCOBs with (nolock)

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_MemberCOBs'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_MemberCOBs is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_MemberCOBs with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_MemberCOBs'
			end

		select	 *
		from	 EBM.EnrolledMembers_MemberCOBs with (nolock)
		where	 LastUpdatedAt > @LastJobRun
				 or @LastJobRun is null
		order by MemberId
				,EffectiveDate offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_MemberCOBs'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberCoverageDetails]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members Coverage Details resultset

CREATE procedure [EBM].[ReadMediTracMemberCoverageDetails]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/01/2017	1.00	RGB		Created new procedure
			11/03/2017	1.01	RGB		Moved schema only return information and took out restriction on data returned
			11/08/2017	1.02	RGB		Implemented Offset, RowCount and TotalRecords parameters to allow returning of data in a paged environment
			12/06/2017	1.03	RGB		Removed indexing
			01/29/2018	1.07	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.07'
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

		if @SchemaOnly = 1
			select top (0)
				   *
			from   EBM.EnrolledMembers_MemberCoverageDetails with (nolock)

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_MemberCoverageDetails'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_MemberCoverageDetails is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_MemberCoverageDetails with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_MemberCoverageDetails'
			end

		select	 *
		from	 EBM.EnrolledMembers_MemberCoverageDetails with (nolock)
		where	 LastUpdatedAt > @LastJobRun
				 or @LastJobRun is null
		order by MemberNumber
				,EffectiveDate offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_MemberCoverageDetails'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberCustomAttributes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members custom attributes resultset

CREATE procedure [EBM].[ReadMediTracMemberCustomAttributes]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			12/07/2017	1.00	RGB		Created new procedure
			01/29/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.01'
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

		if @SchemaOnly = 1
			select top (0)
				   *
			from   EBM.EnrolledMembers_MemberCustomAttributes with (nolock)

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_MemberCustomAttributes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_MemberCustomAttributes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_MemberCustomAttributes with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_MemberCustomAttributes'
			end

		select	 *
		from	 EBM.EnrolledMembers_MemberCustomAttributes with (nolock)
		where	 ValueLastUpdatedAt > @LastJobRun
				 or @LastJobRun is null
		order by EntityID
				,ValueLastUpdatedAt offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_MemberCustomAttributes'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberLanguages]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members Languages resultset

CREATE procedure [EBM].[ReadMediTracMemberLanguages]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/17/2017	1.00	RGB		Created new procedure
			10/20/2017	1.01	RGB		Added SchemaOnly parameter
						1.02	RGB		Added check of IsInUse flag to determine if we can run or not
			11/01/2017	1.03	RGB		Removed check for date of PreviousExecution
			11/03/2017	1.04	RGB		Moved schema only return information and took out restriction on data returned
			11/08/2017	1.05	RGB		Implemented Offset, RowCount and TotalRecords parameters to allow returning of data in a paged environment
			12/06/2017	1.06	RGB		Removed indexing
			01/29/2018	1.07	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/29/2018 09:30 Version 1.07'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.EnrolledMembers_Languages with (nolock)
				return 0
			end

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_Languages'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_Languages is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_Languages with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_Languages'
			end

		select	 *
		from	 EBM.EnrolledMembers_Languages with (nolock)
		order by EntityId offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_Languages'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberMain]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Enrolled Members main resultset

CREATE procedure [EBM].[ReadMediTracMemberMain]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/17/2017	1.00	RGB		Created new procedure
			10/20/2017	1.01	RGB		Added SchemaOnly parameter
						1.02	RGB		Added check of IsInUse flag to determine if we can run or not
			11/01/2017	1.03	RGB		Changed check for date to PreviousExecution
			11/03/2017	1.04	RGB		Moved schema only return information and took out restriction on data returned
			11/08/2017	1.05	RGB		Implemented Offset, RowCount and TotalRecords parameters to allow returning of data in a paged environment
			12/06/2017	1.06	RGB		Removed drop/create index
			01/25/2018	1.07	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.07'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.EnrolledMembers with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers is missing from Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers'

			end

		select	 *
		from	 EBM.EnrolledMembers with (nolock)
		where	 @LastJobRun is null
				 or MembersLastUpdatedAt > @LastJobRun
		order by MemberNumber
				,EffectiveDate offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberReimbursements]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Member Reimbursements resultset

create procedure [EBM].[ReadMediTracMemberReimbursements]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			02/01/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '02/01/2018 08:30 Version 1.00'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.EnrolledMembers_Reimbursements with (nolock)
				return 0
			end

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit

		select @IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_Reimbursements'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_Reimbursements is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.EnrolledMembers_Reimbursements'

		select *
		from   EBM.EnrolledMembers_Reimbursements with (nolock)

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.EnrolledMembers_Reimbursements'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracMemberResponsibleParties]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Member Responsible Parties resultset

create procedure [EBM].[ReadMediTracMemberResponsibleParties]
	@SchemaOnly bit = 0		 ---	Return the schema only
   ,@Offset int = 0			 ---	Number of records to skip
   ,@RowCount int = 5000	 ---	Number of records to return
   ,@TotalRecords int output ---	Total number of records in the table
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			02/05/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '02/05/2018 07:30 Version 1.00'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.EnrolledMembers_ResponsibleParties with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@RowsRead int

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.EnrolledMembers_ResponsibleParties'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.EnrolledMembers_ResponsibleParties is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @Offset = 0
			begin
				if @IsReadLocked = 1
					throw 51002, 'Read job is currently running; read cancelled', 3

				select @TotalRecords = count(1)
				from   EBM.EnrolledMembers_ResponsibleParties with (nolock)

				if @TotalRecords is null
					set @TotalRecords = 0

				update EBM.ExportConfiguration
				set	   IsReadLocked = 1
				where  TableName = 'EBM.EnrolledMembers_ResponsibleParties'
			end

		select	 *
		from	 EBM.EnrolledMembers_ResponsibleParties with (nolock)
		where	 @LastJobRun is null
				 or LastUpdatedAt > @LastJobRun
		order by MemberId
				,EffectiveDate offset @Offset rows fetch next @RowCount rows only

		set @RowsRead = @@ROWCOUNT

		if @RowsRead = 0
		   or @RowsRead < @RowCount
			update EBM.ExportConfiguration
			set	   IsReadLocked = 0
			where  TableName = 'EBM.EnrolledMembers_ResponsibleParties'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracProcedureCodes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Procedure Codes resultset

CREATE procedure [EBM].[ReadMediTracProcedureCodes]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			11/22/2017	1.01	RGB		Modified list of fields to return
			01/25/2018	1.02	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.02'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.ProcedureCodes with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.ProcedureCodes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.ProcedureCodes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.ProcedureCodes'

		select ProcedureCode
			  ,Description
		from   EBM.ProcedureCodes with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.ProcedureCodes'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracProcedureCodesModifiers]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac procedure code modifiers resultset

CREATE procedure [EBM].[ReadMediTracProcedureCodesModifiers]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			01/25/2018	1.00	RGB		Created new procedure
			01/26/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/26/2018 06:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.ProcedureCodes_Modifier with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.ProcedureCodes_Modifier'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.ProcedureCodes_Modifier is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.ProcedureCodes_Modifier'

		select *
		from   EBM.ProcedureCodes_Modifier with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.ProcedureCodes_Modifier'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracProviders]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---	Read MediTrac Providers resultset

CREATE procedure [EBM].[ReadMediTracProviders]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/25/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/25/2018 13:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Providers with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Providers'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Providers is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Providers'

		select *
		from   EBM.Providers with (nolock)
		where  @LastJobRun is null
			   or ProviderLastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Providers'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracProvidersOfficeMapCustomAttributes]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac ProvidersOfficeMapCustomAttributes resultset

CREATE procedure [EBM].[ReadMediTracProvidersOfficeMapCustomAttributes]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			01/04/2018	1.00	RGB		Created new procedure
			01/24/2018	1.01	RGB		Corrected table name
			01/26/2018	1.02	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/26/2018 08:00 Version 1.02'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Providers_OfficeMapCustomAttributes with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Providers_OfficeMapCustomAttributes'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Providers_OfficeMapCustomAttributes is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Providers_OfficeMapCustomAttributes'

		select *
		from   EBM.Providers_OfficeMapCustomAttributes with (nolock)
		where  @LastJobRun is null
			   or ValueLastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Providers_OfficeMapCustomAttributes'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracRiskGroupAlternateAddress]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Risk Group Alternate Address resultset

CREATE procedure [EBM].[ReadMediTracRiskGroupAlternateAddress]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/22/2018	1.01	RGB		Changed table name to match export procedure
			01/26/2018	1.02	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/26/2018 08:30 Version 1.02'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.RiskGroups_AlternateAddress with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.RiskGroups_AlternateAddress'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.RiskGroups_AlternateAddress is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.RiskGroups_AlternateAddress'

		select *
		from   EBM.RiskGroups_AlternateAddress with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.RiskGroups_AlternateAddress'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracRiskGroupHospitalMapping]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Risk Group Hospital Mapping resultset

CREATE procedure [EBM].[ReadMediTracRiskGroupHospitalMapping]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			02/08/2018	1.01	RGB		Reworked procedure to implement IsReadLocked and IsWriteLocked flags
		
		*/
		declare @Version varchar(100) = '02/08/2017 07:00 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.RiskGroups_HospitalMappings with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.RiskGroups_HospitalMappings'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.RiskGroups_HospitalMappings is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.RiskGroups_HospitalMappings'

		select *
		from   EBM.RiskGroups_HospitalMappings with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.RiskGroups_HospitalMappings'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracRiskGroups]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Risk Groups resultset

CREATE procedure [EBM].[ReadMediTracRiskGroups]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/26/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/26/2018 06:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.RiskGroups with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.RiskGroups'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.RiskGroups is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.RiskGroups'

		select *
		from   EBM.RiskGroups with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.RiskGroups'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracVendorAlternateAddress]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Vendor Alternate Address resultset

CREATE procedure [EBM].[ReadMediTracVendorAlternateAddress]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/26/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/26/2018 08:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Vendors_AlternateAddress with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Vendors_AlternateAddress'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Vendors_AlternateAddress is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Vendors_AlternateAddress'

		select *
		from   EBM.Vendors_AlternateAddress with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Vendors_AlternateAddress'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ReadMediTracVendors]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Read MediTrac Vendors resultset

CREATE procedure [EBM].[ReadMediTracVendors]
	@SchemaOnly bit = 0 ---	Return the schema only
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			11/03/2017	1.00	RGB		Created new procedure
			01/26/2018	1.01	RGB		Added checks for IsWriteLocked and set IsReadLocked
		
		*/

		declare @Version varchar(100) = '01/26/2018 06:30 Version 1.01'
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

		if @SchemaOnly = 1
			begin
				select top (0)
					   *
				from   EBM.Vendors with (nolock)
				return 0
			end

		declare @LastJobRun datetime
			   ,@IsWriteLocked bit
			   ,@IsReadLocked bit

		select @LastJobRun = LastExecution
			  ,@IsWriteLocked = IsWriteLocked
			  ,@IsReadLocked = IsReadLocked
		from   EBM.ExportConfiguration with (nolock)
		where  TableName = 'EBM.Vendors'

		if @IsReadLocked is null
		   or @IsWriteLocked is null
			throw 51000, 'Table name EBM.Vendors is missing from EBM.Exportconfiguration', 1

		if @IsWriteLocked = 1
			throw 51001, 'Export job is currently running; read cancelled', 2

		if @IsReadLocked = 1
			throw 51002, 'Read job is currently running; read cancelled', 3

		update EBM.ExportConfiguration
		set	   IsReadLocked = 1
		where  TableName = 'EBM.Vendors'

		select *
		from   EBM.Vendors with (nolock)
		where  @LastJobRun is null
			   or LastUpdatedAt > @LastJobRun

		update EBM.ExportConfiguration
		set	   IsReadLocked = 0
		where  TableName = 'EBM.Vendors'

		return 0
	end
GO
/****** Object:  StoredProcedure [EBM].[ResetExportConfiguration]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Resets the export configuration table

CREATE procedure [EBM].[ResetExportConfiguration]
	@OverrideInUseFlag bit = 0
   ,@ValidateOverrideFlag bit = 0
   ,@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			01/24/2018	1.00	RGB		Created new procedure
						1.01	RGB		Added additional verify flag and added a new table entry
			01/25/2018	1.02	RGB		Added @ValidateOverrideFlag to serve as a double check user wants to ignore running application extracts
						1.03	RGB		Changed IsInUse to IsWriteLocked and added IsReadLocked to ExportConfiguration table
			01/29/2018	1.04	RGB		Changed Hospital extract to include hospital entity map
			02/01/2018	1.05	RGB		Added Reimbursements to the member extract
			02/05/2018	1.06	RGB		Added Responsible Parties to the member extract
		
		*/

		declare @Version varchar(100) = '02/05/2018 07:30 Version 1.06'
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

		if @OverrideInUseFlag = 0
			begin
				declare @InUseCount int
				select @InUseCount = count(1)
				from   EBM.ExportConfiguration with (nolock)
				where  IsWriteLocked = 1
					   or IsReadLocked = 1

				if isnull(@InUseCount, 0) > 0
					throw 51000, 'There are currently running extracts specified in EBM.Exportconfiguration and the OverrideInUseFlag is false', 1
			end
		else if @ValidateOverrideFlag = 0
			throw 51001, 'ValidateOverrideFlag is not set; ignoring OverrideInUseFlag setting', 2

		truncate table EBM.ExportConfiguration

-- SQL Prompt formatting off
		insert into EBM.ExportConfiguration (
												ComponentName
											   ,StoredProcedureReadName
											   ,TableName
											   ,PreviousExecution
											   ,LastExecution
											   ,IsWriteLocked
											   ,IsReadLocked
											)
		values ('Member', 'EBM.ReadMediTracMemberMain', 'EBM.EnrolledMembers', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberAidCodes', 'EBM.EnrolledMembers_AidCodes', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberAssignedProviders', 'EBM.EnrolledMembers_AssignedProviders', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberLanguages', 'EBM.EnrolledMembers_Languages', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberCobs', 'EBM.EnrolledMembers_MemberCOBs', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberCoverageDetails', 'EBM.EnrolledMembers_MemberCoverageDetails', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberCustomAttributes', 'EBM.EnrolledMembers_MemberCustomAttributes', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberCobCustomAttributes', 'EBM.EnrolledMembers_COBCustomAttributes', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberAlternateAddress', 'EBM.EnrolledMembers_AlternateAddress', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberReimbursements', 'EBM.EnrolledMembers_Reimbursements', null, null, 0, 0)
			  ,('Member', 'EBM.ReadMediTracMemberResponsibleParties', 'EBM.EnrolledMembers_ResponsibleParties', null, null, 0, 0)
			  ,('Aid Code', 'EBM.ReadMediTracAidCodes', 'EBM.AidCodes', null, null, 0, 0)
			  ,('Contract', 'EBM.ReadMediTracContracts', 'EBM.Contracts', null, null, 0, 0)
			  ,('Corporation', 'EBM.ReadMediTracCorporations', 'EBM.Corporations', null, null, 0, 0)
			  ,('Diagnosis Code', 'EBM.ReadMediTracDiagnosisCodes', 'EBM.DiagnosisCodes', null, null, 0, 0)
			  ,('Group', 'EBM.ReadMediTracGroups', 'EBM.Groups', null, null, 0, 0)
			  ,('Hospital', 'EBM.ReadMediTracHospitals', 'EBM.Hospitals', null, null, 0, 0)
			  ,('Hospital', 'EBM.ReadMediTracHospitalEntityMap', 'EBM.Hospitals_EntityMap', null, null, 0, 0)
			  ,('Procedure Code', 'EBM.ReadMediTracProcedureCodes', 'EBM.ProcedureCodes', null, null, 0, 0)
			  ,('Procedure Code', 'EBM.ReadMediTracProcedureCodesModifiers', 'EBM.ProcedureCodes_Modifier', null, null, 0, 0)
			  ,('Provider', 'EBM.ReadMediTracProviders', 'EBM.Providers', null, null, 0, 0)
			  ,('Provider', 'EBM.ReadMediTracProvidersOfficeMapCustomAttributes', 'EBM.Providers_OfficeMapCustomAttributes', null, null, 0, 0)
			  ,('Risk Group', 'EBM.ReadMediTracRiskGroups', 'EBM.RiskGroups', null, null, 0, 0)
			  ,('Risk Group', 'EBM.ReadMediTracRiskGroupHospitalMapping', 'EBM.RiskGroups_HospitalMapping', null, null, 0, 0)
			  ,('Risk Group', 'EBM.ReadMediTracRiskGroupAlternateAddress', 'EBM.RiskGroups_AlternateAddress', null, null, 0, 0)
			  ,('Vendor', 'EBM.ReadMediTracVendors', 'EBM.Vendors', null, null, 0, 0)
			  ,('Vendor', 'EBM.ReadMediTracVendorAlternateAddress', 'EBM.Vendor_AlternateAddress', null, null, 0, 0)
			  ,('Claims', 'EBM.ReadMediTracClaims', 'EBM.Claims', null, null, 0, 0)
			  ,('Claims', 'EBM.ReadMediTracClaimsDetail', 'EBM.ClaimsDetail', null, null, 0, 0)
			  ,('Checks', 'EBM.ReadMediTracChecks', 'EBM.Checks', null, null, 0, 0)
-- SQL Prompt formatting on

		return 0

	end

GO
/****** Object:  StoredProcedure [EBM].[TypeLookupDelete]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Resets the type lookup table

create procedure [EBM].[TypeLookupDelete]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			02/13/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '02/13/2018 09:00 Version 1.00'
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

		if exists (
					  select *
					  from	 HSP_Supplemental.INFORMATION_SCHEMA.TABLES
					  where	 TABLE_SCHEMA = N'EBM'
							 and TABLE_NAME = N'TypeLookup'
				  )
			begin
				alter table EBM.TypeLookup set (system_versioning = off)
				drop table if exists EBM.TypeLookup
				drop table if exists EBM.TypeLookupHistory
			end

		create table EBM.TypeLookup
			(
				Category varchar(99) null
			   ,Code varchar(99) null
			   ,Description varchar(1999) null
			   ,TypeLookupKey bigint identity(1, 1) not null
			   ,SysStartTime datetime2(7) generated always as row start not null
			   ,SysEndTime datetime2(7) generated always as row end not null
			   ,constraint PK_TypeLookup
					primary key clustered (TypeLookupKey asc)
					with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [PRIMARY]
			   ,period for system_time(SysStartTime, SysEndTime)
			) on [PRIMARY]
		with (system_versioning = on (history_table = EBM.TypeLookupHistory))
	end
GO
/****** Object:  StoredProcedure [EBM].[TypeLookupReset]    Script Date: 2/15/2018 1:35:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---	Resets the type lookup table

create procedure [EBM].[TypeLookupReset]
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			01/29/2018	1.00	RGB		Created new procedure
			02/13/2018	1.01	RGB		Moved from EBM to Supplemental and P2P process will copy to EBM
		
		*/

		declare @Version varchar(100) = '02/13/2018 09:00 Version 1.01'
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

		exec EBM.TypeLookupDelete

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'MemberAddress'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'alternateaddresstype'
						   and Subtype = 'member'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )
					union
					select 'MemberAddress'
						  ,'Primary Address'
						  ,'Primary Address in demographics'

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'Ethnicity'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'ethnicity'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'Gender'
						  ,Name
						  ,null
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'gender'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'Prefix'
						  ,Name
						  ,null
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'salut'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select distinct
						   'Race'
						  ,ea.AttributeValue
						  ,rtrim(ltrim(right(ea.AttributeValue, len(ea.AttributeValue) - charindex('-', ea.AttributeValue))))
					from   HSP_IT_SB2.dbo.EntityAttributes ea with (nolock)
						   join HSP_IT_SB2.dbo.CustomAttributes ca with (nolock)
								on ca.AttributeID = ea.AttributeID
					where  ca.AttributeName = 'race'
						   and ea.EntityType = 'Members'


		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select distinct
						   'SpokenLanguage'
						  ,Name
						  ,null
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'language'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'State'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'state'
						   and Subtype = 'us'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'Suffix'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'suffix'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
		values ('WrittenLanguage'
			   ,'English'
			   ,null)
			  ,('WrittenLanguage'
			   ,'Spanish'
			   ,null)

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
		values ('ProviderAddress'
			   ,'Primary'
			   ,'Primary address')
			  ,('ProviderAddress'
			   ,'Office'
			   ,'Office address')

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'ProviderContract'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'contracttype'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
		values ('ProviderPhone'
			   ,'After Hours'
			   ,'After hours phone')
			  ,('ProviderPhone'
			   ,'Fax'
			   ,'Fax phone')
			  ,('ProviderPhone'
			   ,'Office'
			   ,'Office phone')
			  ,('ProviderPhone'
			   ,'Primary'
			   ,'Primary phone')

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
		values ('MemberPhone'
			   ,'Home'
			   ,'Home phone')
			  ,('MemberPhone'
			   ,'Work'
			   ,'Work phone')
			  ,('MemberPhone'
			   ,'Cell'
			   ,'Cell phone')

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'Provider'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'providertype'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'Specialty'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'specialty'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'Vendor'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'vendortype'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'CorporationEin'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'eintype'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'ResponsibleParty'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'Responsible Party'
						   and Subtype = 'Responsible Party'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'AlternateMediaFormat'
						  ,Name
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'alternative format'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )

		insert into EBM.TypeLookup (
									   Category
									  ,Code
									  ,Description
								   )
					select 'RiskGroupClass'
						  ,left(Name, 3)
						  ,Description
					from   HSP_IT_SB2.dbo.ReferenceCodes with (nolock)
					where  Type = 'RiskGroupClass'
						   and (
								   ProductName is null
								   or ProductName = 'MediTrac'
							   )
						   and Name <> 'Default Risk Group Class'

	end
GO
