use HSP_Supplemental
go
set ansi_nulls on
go
set quoted_identifier on
go

alter procedure EBM.ResetExportConfiguration
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
			03/23/2018	1.07	RGB		Removed Groups and Vendors export and added Claims_Explanations table to claims export
			04/04/2018	1.08	RGB		Reorganized table to add CurrentExecution and drop LastExecution and StoredProcedureName fields
			06/14/2018	1.09	RGB		Added back Vendors and Risk Groups; alphabetized list for easier maintenance
			07/18/2018	1.10	RGB		Added Events extract
			11/06/2018	1.11	RGB		Added Events Custom Attribute History table to events extract
										Added read uncommitted
			11/08/2018	1.12	RGB		Added duplicate entity table to member extract
			12/03/2018	1.13	RGB		Removed duplicate entity table
		
		*/

        set transaction isolation level read uncommitted

        declare @Version varchar(100) = '12/03/2018 07:30 Version 1.13'
        declare @ReturnValues table
            (
                ReturnCode int primary key not null
               ,Reason varchar(200) not null
            )

        insert into @ReturnValues
            (
                ReturnCode
               ,Reason
            )
        values
            (
                0
               ,'Normal Return'
            )

        if @Showversion = 1
            begin
                select  object_schema_name(@@PROCID) as SchemaName
                       ,object_name(@@PROCID) as ProcedureName
                       ,@Version as VersionInformation
                if isnull(@ShowReturn, 0) = 0
                    return 0
            end

        if @ShowReturn = 1
            begin
                select  *
                from    @ReturnValues
                return 0
            end

        set nocount on

        if @OverrideInUseFlag = 0
            begin
                declare @InUseCount int
                select  @InUseCount = count(1)
                from    EBM.ExportConfiguration
                where   IsWriteLocked = 1
                        or  IsReadLocked = 1

                if isnull(@InUseCount, 0) > 0
                    throw 51000, 'There are currently running extracts specified in EBM.Exportconfiguration and the OverrideInUseFlag is false', 1
            end
        else if @ValidateOverrideFlag = 0
            throw 51001, 'ValidateOverrideFlag is not set; ignoring OverrideInUseFlag setting', 2

        truncate table EBM.ExportConfiguration

-- SQL Prompt formatting off
		insert into EBM.ExportConfiguration (
												ComponentName
											   ,TableName
											   ,PreviousExecution
											   ,CurrentExecution
											   ,IsWriteLocked
											   ,IsReadLocked
											)
		values ('Aid Code', 'EBM.AidCodes', null, null, 0, 0)
			  ,('Checks', 'EBM.Checks', null, null, 0, 0)
			  ,('Claims', 'EBM.Claims', null, null, 0, 0)
			  ,('Claims', 'EBM.ClaimsDetail', null, null, 0, 0)
			  ,('Claims', 'EBM.ClaimsDetail_Explanations', null, null, 0, 0)
			  ,('Contract', 'EBM.Contracts', null, null, 0, 0)
			  ,('Corporation', 'EBM.Corporations', null, null, 0, 0)
			  ,('Diagnosis Code', 'EBM.DiagnosisCodes', null, null, 0, 0)
			  ,('Event', 'EBM.Events', null, null, 0, 0)
			  ,('Event', 'EBM.EventsCustomAttributeHistory', null, null, 0, 0)
			  ,('Hospital', 'EBM.Hospitals', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_AidCodes', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_AssignedProviders', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_Languages', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_MemberCOBs', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_MemberCoverageDetails', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_MemberCustomAttributes', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_COBCustomAttributes', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_AlternateAddress', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_Reimbursements', null, null, 0, 0)
			  ,('Member', 'EBM.EnrolledMembers_ResponsibleParties', null, null, 0, 0)
			  --,('Group', 'EBM.Groups', null, null, 0, 0)
			  ,('Procedure Code', 'EBM.ProcedureCodes', null, null, 0, 0)
			  --,('Procedure Code', 'EBM.ProcedureCodes_Modifier', null, null, 0, 0)
			  ,('Provider', 'EBM.Providers', null, null, 0, 0)
			  ,('Provider', 'EBM.Providers_OfficeMapCustomAttributes', null, null, 0, 0)
			  ,('Risk Group', 'EBM.RiskGroups', null, null, 0, 0)
			  ,('Risk Group', 'EBM.RiskGroups_HospitalMapping', null, null, 0, 0)
			  ,('Risk Group', 'EBM.RiskGroups_AlternateAddress', null, null, 0, 0)
			  ,('Vendor', 'EBM.Vendors', null, null, 0, 0)
			  ,('Vendor', 'EBM.Vendor_AlternateAddress', null, null, 0, 0)
-- SQL Prompt formatting on

        return 0

    end

