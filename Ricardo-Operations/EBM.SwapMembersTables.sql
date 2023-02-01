use HSP_Supplemental
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapMembersTables
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

		drop table if exists EBMLastRun.EnrolledMembers

		select *
		into   EBMLastRun.EnrolledMembers
		from   EBM.EnrolledMembers with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_AidCodes

		select *
		into   EBMLastRun.EnrolledMembers_AidCodes
		from   EBM.EnrolledMembers_AidCodes with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_AlternateAddress

		select *
		into   EBMLastRun.EnrolledMembers_AlternateAddress
		from   EBM.EnrolledMembers_AlternateAddress with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_AssignedProviders

		select *
		into   EBMLastRun.EnrolledMembers_AssignedProviders
		from   EBM.EnrolledMembers_AssignedProviders with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_COBCustomAttributes

		select *
		into   EBMLastRun.EnrolledMembers_COBCustomAttributes
		from   EBM.EnrolledMembers_COBCustomAttributes with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_MemberCOBs

		select *
		into   EBMLastRun.EnrolledMembers_MemberCOBs
		from   EBM.EnrolledMembers_MemberCOBs with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_MemberCoverageDetails

		select *
		into   EBMLastRun.EnrolledMembers_MemberCoverageDetails
		from   EBM.EnrolledMembers_MemberCoverageDetails with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_MemberCustomAttributes

		select *
		into   EBMLastRun.EnrolledMembers_MemberCustomAttributes
		from   EBM.EnrolledMembers_MemberCustomAttributes with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_Reimbursements

		select *
		into   EBMLastRun.EnrolledMembers_Reimbursements
		from   EBM.EnrolledMembers_Reimbursements with (nolock)

		drop table if exists EBMLastRun.EnrolledMembers_ResponsibleParties

		select *
		into   EBMLastRun.EnrolledMembers_ResponsibleParties
		from   EBM.EnrolledMembers_ResponsibleParties with (nolock)

		return 0
	end
go
