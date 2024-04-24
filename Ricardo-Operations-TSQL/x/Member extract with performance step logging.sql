use HSP_Supplemental
go

declare @sql varchar(2000)
	   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
	   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.EnrolledMembers'
	   ,@Command varchar(200) = 'drop table if exists '
	   ,@RunId uniqueidentifier = newid()

declare @MainColumnList varchar(2000) =
	'ParentGroupNumber,LineOfBusinessName,DateFrom,DateTo,MemberID,SocialSecurityNumber,LastName,FirstName,MiddleName,NamePrefix,NameSuffix,'
	+ 'Address1,Address2,City,State,Zip,County,CountryCode,HomePhone,WorkPhone,CellPhone,Email,Gender,DateOfBirth,DateOfDeath,EthnicityName,HICN,MembersLastUpdatedAt,'
	+ 'MemberCoverageID,MemberNumber,MemberPolicyNumber,ProviderId,ProviderNumber,RiskGroupName,RiskGroupNumber,HospitalId,HospitalName,HospitalNumber,HospitalNPI,'
	+ 'PCPEffectiveDate,PCPExpirationDate,OfficeId,OfficeName,OfficeNumber,OfficeAddress1,OfficeAddress2,OfficeCity,OfficeState,OfficeZip,OfficeCountryCode,OfficeContactPhone,'
	+ 'ContractId,ContractName,BenefitCoverageId,BasePlanName,EffectiveDate,ExpirationDate,TerminationReasonName,BenefitCoveragesLastUpdatedAt,'
	+ 'GroupNumber,GroupName,ProductLineName,PCPProviderContractNumber'

declare @HSPStartDate datetime = cast('1900-01-01' as datetime)
	   ,@HSPEndDate datetime = cast('9999-12-31' as datetime)
	   ,@HSPEndDate2 datetime = cast('2099-12-31' as datetime)
	   ,@HSPStartDateOnly date = cast('1900-01-01' as date)
	   ,@HSPEndDateOnly date = cast('9999-12-31' as date)
	   ,@HSPEndDateOnly2 date = cast('2099-12-31' as date)

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Starting export enrolled members'
	   ,sysdatetime())

exec HSP_Prime.dbo.rr_ExportMembers_v2 @Usage = '|EnrolledMembers|'
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

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Completed export enrolled members'
	   ,sysdatetime())

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

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Starting export member COB entity custom attributes'
	   ,sysdatetime())

exec HSP_Prime.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Member COB Map'
												  ,@Usage = '|VALUES|'
												  ,@SessionId = null
												  ,@ReturnStatus = 'N'
												  ,@ColumnList = @ColumnList
												  ,@TableUsage = '|RECREATE|'
												  ,@ResultTableName = @AuxTableName

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Completed export member COB entity custom attributes'
	   ,sysdatetime())

set @AuxTableName = @TableName + '_MemberCustomAttributes'

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Starting export member entity custom attributes'
	   ,sysdatetime())

exec HSP_Prime.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Member'
												  ,@Usage = '|VALUES|'
												  ,@SessionId = null
												  ,@ReturnStatus = 'N'
												  ,@ColumnList = @ColumnList
												  ,@TableUsage = '|RECREATE|'
												  ,@ResultTableName = @AuxTableName

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Completed export member entity custom attributes'
	   ,sysdatetime())

set @AuxTableName = @TableName + '_AlternateAddress'

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Starting export member alternate addresses'
	   ,sysdatetime())

exec HSP_Prime.dbo.rr_ExportAlternateAddress @EntityTypeCode = 'MEM'
											,@SessionID = null
											,@ReturnStatus = 'N'
											,@ColumnList = ''
											,@TableUsage = '|RECREATE|'
											,@ResultTableName = @AuxTableName

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Completed export member alternate addresses'
	   ,sysdatetime())

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Starting date reformatting'
	   ,sysdatetime())

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

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Completed date reformatting'
	   ,sysdatetime())

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Starting table indexing'
	   ,sysdatetime())

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

drop index if exists IX_MemberId_EffectiveDate_LastUpdatedAt
	on HSP_Supplemental.EBM.EnrolledMembers_AidCodes

create nonclustered index IX_MemberId_EffectiveDate_LastUpdatedAt
	on HSP_Supplemental.EBM.EnrolledMembers_AidCodes
(
	MemberId
   ,EffectiveDate
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

insert into HSP_Supplemental.EBM.ExtractRunStatistics (
														  RunId
														 ,ExtractName
														 ,StepInformation
														 ,StepTime
													  )
values (@RunId
	   ,'Member'
	   ,'Completed table indexing'
	   ,sysdatetime())
