use HSP_Supplemental
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracAidCodesTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'AidCodes'
					  )
			select top (0)
				   *
			into   EBMLastRun.AidCodes
			from   EBM.AidCodes

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracChecksTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'Checks'
					  )
			select top (0)
				   *
			into   EBMLastRun.Checks
			from   EBM.Checks

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracClaimsTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'Claims'
					  )
			select top (0)
				   *
			into   EBMLastRun.Claims
			from   EBM.Claims

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'ClaimsDetail'
					  )
			select top (0)
				   *
			into   EBMLastRun.ClaimsDetail
			from   EBM.ClaimsDetail

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'ClaimsDetail_Explanations'
					  )
			select top (0)
				   *
			into   EBMLastRun.ClaimsDetail_Explanations
			from   EBM.ClaimsDetail_Explanations

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracContractsTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'Contracts'
					  )
			select top (0)
				   *
			into   EBMLastRun.Contracts
			from   EBM.Contracts

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracDiagnosisCodesTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'DiagnosisCodes'
					  )
			select top (0)
				   *
			into   EBMLastRun.DiagnosisCodes
			from   EBM.DiagnosisCodes

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracHospitalsTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'Hospitals'
					  )
			select top (0)
				   *
			into   EBMLastRun.Hospitals
			from   EBM.Hospitals

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracMembersTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers
			from   EBM.EnrolledMembers

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_AidCodes'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_AidCodes
			from   EBM.EnrolledMembers_AidCodes

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_AlternateAddress'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_AlternateAddress
			from   EBM.EnrolledMembers_AlternateAddress

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_AssignedProviders'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_AssignedProviders
			from   EBM.EnrolledMembers_AssignedProviders

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_COBCustomAttributes'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_COBCustomAttributes
			from   EBM.EnrolledMembers_COBCustomAttributes

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_Languages'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_Languages
			from   EBM.EnrolledMembers_Languages

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_MemberCOBs'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_MemberCOBs
			from   EBM.EnrolledMembers_MemberCOBs

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_MemberCoverageDetails'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_MemberCoverageDetails
			from   EBM.EnrolledMembers_MemberCoverageDetails

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_MemberCustomAttributes'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_MemberCustomAttributes
			from   EBM.EnrolledMembers_MemberCustomAttributes

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_Reimbursements'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_Reimbursements
			from   EBM.EnrolledMembers_Reimbursements

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'EnrolledMembers_ResponsibleParties'
					  )
			select top (0)
				   *
			into   EBMLastRun.EnrolledMembers_ResponsibleParties
			from   EBM.EnrolledMembers_ResponsibleParties

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracProcedureCodesTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'ProcedureCodes'
					  )
			select top (0)
				   *
			into   EBMLastRun.ProcedureCodes
			from   EBM.ProcedureCodes

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.BuildMediTracProvidersTable
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			05/08/2018	1.00	RGB		Created new procedure
			05/09/2018	1.01	RGB		Modified to use new schema name
		
		*/
		declare @Version varchar(100) = '05/09/2018 09:00 Version 1.01'
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

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'Providers'
					  )
			select top (0)
				   *
			into   EBMLastRun.Providers
			from   EBM.Providers

		if not exists (
						  select *
						  from	 INFORMATION_SCHEMA.TABLES with (nolock)
						  where	 TABLE_SCHEMA = 'EBMLastRun'
								 and TABLE_NAME = 'Providers_OfficeMapCustomAttributes'
					  )
			select top (0)
				   *
			into   EBMLastRun.Providers_OfficeMapCustomAttributes
			from   EBM.Providers_OfficeMapCustomAttributes

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.CombineHospitalTables
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/25/2018	1.00	RGB		Created new procedure
		
		*/
		declare @Version varchar(100) = '05/25/2018 14:00 Version 1.00'
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
go
set ansi_nulls on
go
set quoted_identifier on
go

---	Exports the MediTrac Aid Code values

create procedure EBM.ExportMediTracAidCodes
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
			03/22/2018	1.05	RGB		Fixed error with LastExecution and PreviousExecution dates
			04/05/2018	1.06	RGB		Removed LastExecution and added CurrentExecution to update, when write lock engaged
			04/19/2018	1.07	RGB		Added logging of statistics for performance tracking
			04/24/2018	1.08	RGB		Modified logging of statistics for performance tracking
		
		*/

		declare @Version varchar(100) = '04/24/2018 07:00 Version 1.08'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Aid Code'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export aid codes'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Aid Code'

		exec HSP_MO.dbo.rr_ExportAidCodes @ReturnStatus = 'N'
											 ,@ColumnList = ''
											 ,@SessionID = null
											 ,@TableUsage = '|RECREATE|'
											 ,@ResultTableName = 'Hsp_Supplemental.EBM.AidCodes'

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
		where  ComponentName = 'Aid Code'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export aid codes'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ExportMeditracChecks
	@Showversion bit = 0
   ,@ShowReturn bit = 0
as
	begin
		/*
			Modification Log:
			
			10/12/2017	1.00	PS		Created new procedure
			02/14/2018	1.01	RGB		Reworked to conform to existing export/read standards
			02/16/2018	1.02	RGB		Removed start and end date parameters from called procedure
			03/22/2018	1.03	RGB		Fixed error with LastExecution and PreviousExecution dates
			04/05/2018	1.04	RGB		Made changes for CurrentExecution and removed LastExecution field
			04/19/2018	1.05	RGB		Added logging of statistics for performance tracking
										Added PlaceOfService and PlaceOfServiceCode to column list
			04/24/2018	1.06	RGB		Modified logging of statistics for performance tracking
		
		*/

		declare @Version varchar(100) = '04/24/2018 07:00 Version 1.06'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Checks'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export checks'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Checks'

		declare @TableName varchar(200) = 'Hsp_Supplemental.EBM.Checks'
		declare @ColumnList varchar(2000) =
			'CheckId,CheckNumber,CheckDate,CheckAmount,CreationDate,ProcessedDate,MethodOfPayment,CheckStatus,EntityType,VendorID,ProviderNumber,'
			+ 'OfficeID,ClaimId,ClaimNumber,EIN,VendorName,LastUpdatedAt,PlaceOfService,PlaceOfServiceCode'

		exec HSP_MO.dbo.rr_ExportCheckData @Usage = '|ONEDETAILLEVEL|'
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
		where  ComponentName = 'Checks'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export checks'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ExportMeditracClaims
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
			02/27/2018	1.06	RGB		Added explanations to detail and removed deletion of Explanation table in detail extracts
			03/15/2018	1.07	RGB		Added FormType field to the list of fields extracted
			03/19/2018	1.08	RGB		Added ReturnGroupInfo parameter to detail line export
			03/22/2018	1.09	RGB		Fixed error with LastExecution and PreviousExecution dates
			03/28/2018	1.10	RGB		Added new fields to the claims header for risk group information and claims detail for contract information
			04/05/2018	1.11	RGB		Removed LastExecution and added CurrentExecution fields
			04/19/2018	1.12	RGB		Added logging of statistics for performance tracking
										Added new fields to column lists for detail extracts
			04/24/2018	1.13	RGB		Modified logging of statistics for performance tracking
		
		*/

		declare @Version varchar(100) = '04/24/2018 07:00 Version 1.13'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Claims'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export claims'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Claims'

		declare @StartDate date = cast('1900-01-01' as date)
			   ,@EndDate date = cast('9999-12-31' as date)

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.Claims'
			   ,@Command varchar(200) = 'drop table if exists '

		declare @ColumnList varchar(2000) =
			'ClaimId,ClaimNumber,AdjustmentVersion,LastUpdatedAt,ServiceDateFrom,ServiceDateTo,DateReceived,SubscriberNumber,ProviderNumber,ProviderNPI,OfficeNumber,'
			+ 'VendorNumber,VendorId,Status,EIN,PatientAccountNumber,TotalCharges,ClaimTotalPaid,FormType,PCPRiskGroupName,PCPRiskGroupNumber'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export claims headers'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_ExportClaimDataComplete @Usage = '|LatestClaims|'
													  ,@DateUsage = '|DateLastUpdatedAt|'
													  ,@PeriodStart = @StartDate
													  ,@PeriodEnd = @EndDate
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
													  ,@ReturnPCPInformation = 'Y'
													  ,@SessionId = null
													  ,@ReturnStatus = 'N'
													  ,@ColumnList = @ColumnList
													  ,@ResultsetName = 'MAIN'
													  ,@TableUsage = '|RECREATE|'
													  ,@ResultTableName = @TableName

		set @TableName = 'Hsp_Supplemental.EBM.ClaimsDetail'
		set @ColumnList =
			'ClaimId,ClaimNumber,LastUpdatedAt,MemberId,ProviderId,AdjustmentVersion,LineNumber,LineServiceDateFrom,LineServiceDateTo,ResultStatus,Status,ProcedureCode,ServiceUnits,'
			+ 'Amount,AmtPatientLiability,AmtCovered,AmtDisallowed,AmtCopay,Modifier,Modifier2,Modifier3,Modifier4,DiagnosisPtrs,DiagnosisPtr1,DiagnosisPtr2,DiagnosisPtr4,'
			+ 'ProductCodeQualifier,ProductCode,ProductQuantity,ProductUnitOfMeasure,DiagnosisCode1,DiagnosisCode2,DiagnosisCode3,DiagnosisCode4,DiagnosisCode5,DiagnosisCode6,'
			+ 'DiagnosisCode7,DiagnosisCode8,DiagnosisCode9,DiagnosisCode10,DiagnosisCode11,DiagnosisCode12,DiagnosisCode13,DiagnosisCode14,DiagnosisCode15,DiagnosisCode16,'
			+ 'DiagnosisCode17,DiagnosisCode18,DiagnosisCode19,DiagnosisCode20,DiagnosisCode21,DiagnosisCode22,DiagnosisCode23,DiagnosisCode24,GroupLineOfBusiness,GroupLineOfBusinessName,'
			+ 'ContractId,ContractName,ProviderContractId,PlaceOfService,AmtNotCovered,AmtCoinsurance,AmtCharged,AmtToPay,AmtDeductible,AmtWithhold'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export claims details'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_ExportClaimDataComplete @Usage = '|LatestClaimLines|'
													  ,@DateUsage = '|DateLastUpdatedAt|'
													  ,@PeriodStart = @StartDate
													  ,@PeriodEnd = @EndDate
													  ,@ReturnExplanations = 'Y'
													  ,@ReturnReferenceCodesName = 'Y'
													  ,@ReturnReferenceCodesNameLength = 20
													  ,@ReturnDiagnosisCodes = 'Y'
													  ,@ReturnGroupInfo = 'Y'
													  ,@SessionId = null
													  ,@ReturnStatus = 'N'
													  ,@ColumnList = @ColumnList
													  ,@TableUsage = '|RECREATE|'
													  ,@ResultTableName = @TableName

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export claims details'
			   ,sysdatetime())

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
		where  ComponentName = 'Claims'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export claims'
			   ,sysdatetime())

		return 0
	end

go
set ansi_nulls on
go
set quoted_identifier on
go

---	Exports the MediTrac Provider Contracts

create procedure EBM.ExportMediTracContracts
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
			03/22/2018	1.05	RGB		Fixed error with LastExecution and PreviousExecution dates
			04/05/2018	1.06	RGB		Removed LastExecution and added CurrentExecution fields
			04/19/2018	1.07	RGB		Added logging of statistics for performance tracking
			04/24/2018	1.08	RGB		Modified logging of statistics for performance tracking
		
		*/

		declare @Version varchar(100) = '04/24/2018 07:00 Version 1.08'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Contract'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export contracts'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Contract'

		exec HSP_MO.dbo.rr_ExportContracts @ReturnAmbulatoryProcedureCodeGroupingExceptions = 'N'
											  ,@SessionID = null
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = ''
											  ,@ResultSetName = 'MAIN'
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = 'HSP_Supplemental.EBM.Contracts'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting date reformatting for contracts'
			   ,sysdatetime())

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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed date reformatting for contracts'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
		where  ComponentName = 'Contract'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export contracts'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

---	Exports the MediTrac Diagnosis Codes

create procedure EBM.ExportMediTracDiagnosisCodes
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
			02/21/2018	1.06	RGB		Added EffectiveDate and ExpirationDate to the list of returned columns and added new procedure to fix dates and indexes
			03/22/2018	1.07	RGB		Fixed error with LastExecution and PreviousExecution dates
			04/05/2018	1.08	RGB		Removed LastExecution and added CurrentExecution fields
			04/19/2018	1.09	RGB		Added logging of statistics for performance tracking
			04/24/2018	1.10	RGB		Modified logging of statistics for performance tracking
			05/18/2018	1.11	RGB		Changed stored procedure call to modify dates
		
		*/

		declare @Version varchar(100) = '05/18/2018 10:00 Version 1.11'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Diagnosis Code'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export diagnosis code'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Diagnosis Code'

		exec HSP_MO.dbo.rr_ExportDiagnosisCodes @Usage = '|ALL|'
												   ,@SessionID = 0
												   ,@ReturnStatus = 'N'
												   ,@ColumnList = 'DiagnosisCode, Description, EffectiveDate, ExpirationDate, LastUpdatedAt'
												   ,@TableUsage = '|RECREATE|'
												   ,@ResultTableName = 'HSP_Supplemental.EBM.DiagnosisCodes'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting reformat dates diagnosis code'
			   ,sysdatetime())

		exec EBM.ModifyFieldsDiagnosisCodes

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed reformat dates diagnosis code'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
		where  ComponentName = 'Diagnosis Code'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export diagnosis code'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

---	Exports the MediTrac Hospitals

create procedure EBM.ExportMediTracHospitals
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
			03/16/2018	1.06	RGB		Modified hospital extract to include all hospitals, based on extract parameters provided by HSP
										Removed EntityMap table (don't think we need it)
			04/05/2018	1.07	RGB		Removed LastExecution and added CurrentExecution fields
			04/19/2018	1.08	RGB		Added logging of statistics for performance tracking
			04/24/2018	1.09	RGB		Modified logging of statistics for performance tracking
			05/17/2018	1.10	RGB		Included specific column list for hospital and provider information only
			05/25/2018	1.11	RGB		Added new fields to column list
						1.12	RGB		Combined providers only with providers and offices to generate a complete hospital table
			05/30/2018	1.13	RGB		Added new fields to column list
		
		*/

		declare @Version varchar(100) = '05/30/2018 08:30 Version 1.13'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Hospital'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export hospitals'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Hospital'

		declare @TableName varchar(200) = 'Hsp_Supplemental.EBM.HospitalsProvidersAndOffices'
		declare @ColumnList varchar(2000) =
			'ProviderNumber,ProviderLastName,ProviderType,ProviderTypeName,ProviderEmail,ProviderNPI,ProviderMedicareId,ProviderMedicaidId,ShowInPrintedDirectory,'
			+ 'ShowInWebDirectory,ProviderLastUpdatedAt,ProviderEntityType,Hospital,ProviderSpecialtyPrimary,ProviderSpecialtyPrimaryTaxonomyCode,ProviderSpecialtyPrimaryAltCode1,'
			+ 'ProviderSpecialtyOther,ProviderSpecialtyOtherTaxonomyCode,ProviderSpecialtyOtherAltCode1,PrimaryLicenseNumber,PrimaryState,OfficeId,ProviderOfficeEffectiveDate,ProviderOfficeExpirationDate,'
			+ 'PrimarySpecialtyId,PrimaryLanguageCode,LanguagePrimary,ProviderId,OfficeAddress1,OfficeAddress2,OfficeCity,OfficeState,OfficeZip,OfficeName,OfficeNPI,OfficeNumberOfPhysicians,'
			+ 'OfficeWheelchairAccess,OfficeAvailableAfterHours,OfficeContactName,OfficeContactEmail,OfficeContactPhone,OfficeContactExt,OfficeContactFax,OfficeNumber,'
			+ 'SundayStart,SundayEnd,MondayStart,MondayEnd,TuesdayStart,TuesdayEnd,WednesdayStart,WednesdayEnd,ThursdayStart,ThursdayEnd,FridayStart,FridayEnd,SaturdayStart,SaturdayEnd'
		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export providers and offices'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_GetProviderData @Usage = '|PROVIDERSANDOFFICES|'
											  ,@ProviderSpecialtyCategoryID = '30'	  --Facility
											  ,@ProviderSpecialtySubCategoryID = '35' --Hospital
											  ,@ReturnLanguage = 'PRM'
											  ,@DateUsage = '|ContractEffectiveWithinDateRange|'
											  ,@CustomAttributeEntity = 'PRV'
											  ,@ResultsetName = 'MAIN'
											  ,@SessionId = null
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = @ColumnList
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = @TableName

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export providers and offices'
			   ,sysdatetime())

		set @TableName = 'Hsp_Supplemental.EBM.HospitalsProvidersOnly'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export providers only'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_GetProviderData @Usage = '|PROVIDERSONLY|'
											  ,@ProviderSpecialtyCategoryID = '30'	  --Facility
											  ,@ProviderSpecialtySubCategoryID = '35' --Hospital
											  ,@ReturnLanguage = 'PRM'
											  ,@DateUsage = '|ContractEffectiveWithinDateRange|'
											  ,@CustomAttributeEntity = 'PRV'
											  ,@ResultsetName = 'MAIN'
											  ,@SessionId = null
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = @ColumnList
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = @TableName

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export providers only'
			   ,sysdatetime())

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting combining of hospital records'
			   ,sysdatetime())

		exec EBM.CombineHospitalTables

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed combining of hospital records'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
		where  ComponentName = 'Hospital'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export hospitals'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ExportMediTracMembers
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
			03/07/2018	1.16	RGB		Added ActiveMemberSince to member export fields
			03/22/2018	1.17	RGB		Fixed error with LastExecution and PreviousExecution dates
			04/05/2018	1.18	RGB		Removed LastExecution and added CurrentExecution fields
			04/19/2018	1.19	RGB		Added logging of statistics for performance tracking
										Added parameter to member extract for @ReturnResponsibleParty = 'NO', as per HSP
			04/24/2018	1.20	RGB		Modified logging of statistics for performance tracking
			04/26/2018	1.21	RGB		Changed logging text for export statistics
			05/08/2018	1.22	RGB		Changed stored procedure to modify dates for start/stop and drop unneeded columns
		
		*/

		declare @Version varchar(100) = '05/18/2018 14:00 Version 1.22'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Member'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export members'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Member'

		declare @sql varchar(2000)
			   ,@DatabaseName varchar(200) = 'Hsp_Supplemental'
			   ,@TableName varchar(200) = 'Hsp_Supplemental.EBM.EnrolledMembers'
			   ,@Command varchar(200) = 'drop table if exists '
		declare @MainColumnList varchar(2000) =
			'ParentGroupNumber,LineOfBusinessName,DateFrom,DateTo,MemberID,SocialSecurityNumber,LastName,FirstName,MiddleName,NamePrefix,NameSuffix,'
			+ 'Address1,Address2,City,State,Zip,County,CountryCode,HomePhone,WorkPhone,CellPhone,Email,Gender,DateOfBirth,DateOfDeath,EthnicityName,HICN,MembersLastUpdatedAt,'
			+ 'MemberCoverageID,MemberNumber,MemberPolicyNumber,ProviderId,ProviderNumber,RiskGroupName,RiskGroupNumber,HospitalId,HospitalName,HospitalNumber,HospitalNPI,'
			+ 'PCPEffectiveDate,PCPExpirationDate,OfficeId,OfficeName,OfficeNumber,OfficeAddress1,OfficeAddress2,OfficeCity,OfficeState,OfficeZip,OfficeCountryCode,OfficeContactPhone,'
			+ 'ContractId,ContractName,BenefitCoverageId,BasePlanName,EffectiveDate,ExpirationDate,TerminationReasonName,BenefitCoveragesLastUpdatedAt,'
			+ 'GroupNumber,GroupName,ProductLineName,PCPProviderContractNumber,ActiveMemberSince'

		exec HSP_MO.dbo.rr_ExportMembers_v2 @Usage = '|EnrolledMembers|'
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
											   ,@ReturnResponsibleParty = 'NO'
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
			   ,@ExtractName
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
			   ,@ExtractName
			   ,'Starting export member COB entity custom attributes'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Member COB Map'
														   ,@Usage = '|VALUES|'
														   ,@SessionId = null
														   ,@ReturnStatus = 'N'
														   ,@ColumnList = @ColumnList
														   ,@TableUsage = '|RECREATE|'
														   ,@ResultTableName = @AuxTableName

		set @AuxTableName = @TableName + '_MemberCustomAttributes'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export member entity custom attributes'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Member'
														   ,@Usage = '|VALUES|'
														   ,@SessionId = null
														   ,@ReturnStatus = 'N'
														   ,@ColumnList = @ColumnList
														   ,@TableUsage = '|RECREATE|'
														   ,@ResultTableName = @AuxTableName

		set @AuxTableName = @TableName + '_AlternateAddress'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export member alternate addresses'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_ExportAlternateAddress @EntityTypeCode = 'MEM'
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
			   ,@ExtractName
			   ,'Starting member date reformatting'
			   ,sysdatetime())

		exec HSP_Supplemental.EBM.ModifyFieldsMember

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed member date reformatting'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
		where  ComponentName = 'Member'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export members'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

---	Exports the MediTrac Procedure Codes

create procedure EBM.ExportMediTracProcedureCodes
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
			02/16/2018	1.09	RGB		Removed linked server connection
			02/21/2018	1.10	RGB		Added EffectiveDate and ExpirationDate to columns returned and HX to list of codes to keep and changed external procedure to call for indexes, etc.
			03/22/2018	1.11	RGB		Fixed error with LastExecution and PreviousExecution dates
			04/05/2018	1.12	RGB		Removed LastExecution and added CurrentExecution fields; removed modifier codes table extract
			04/19/2018	1.13	RGB		Added logging of statistics for performance tracking
			04/24/2018	1.14	RGB		Modified logging of statistics for performance tracking
			05/18/2018	1.15	RGB		Changed stored procedure name to alter dates for start/stop
		
		*/

		declare @Version varchar(100) = '05/18/2018 14:00 Version 1.15'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Procedure Code'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export procedure codes'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Procedure Code'

		exec HSP_MO.dbo.rr_ExportProcedureCodes @Usage = '|ALL|'
												   ,@SessionID = 0
												   ,@ReturnStatus = 'N'
												   ,@ColumnList = 'ProcedureCode,Description,CodeType,EffectiveDate,ExpirationDate,LastUpdatedAt'
												   ,@TableUsage = '|RECREATE|'
												   ,@ResultTableName = 'HSP_Supplemental.EBM.ProcedureCodes'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting procedure codes table cleanup'
			   ,sysdatetime())

		delete pc
		from   HSP_Supplemental.EBM.ProcedureCodes pc
		where  CodeType not in ('I10', 'CU', 'CP', 'RC', 'HX')

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting procedure codes date reformatting'
			   ,sysdatetime())

		exec EBM.ModifyFieldsProcedureCodes

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed procedure codes date reformatting'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
		where  ComponentName = 'Procedure Code'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export procedure codes'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ExportMediTracProviders
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
			03/16/2018	1.09	RGB		Removed parameter to exclude hospitals, so we get ALL providers
			03/22/2018	1.10	RGB		Fixed error with LastExecution and PreviousExecution dates
			04/05/2018	1.11	RGB		Removed LastExecution and added CurrentExecution fields
			04/19/2018	1.12	RGB		Added logging of statistics for performance tracking
			04/24/2018	1.13	RGB		Modified logging of statistics for performance tracking
			05/18/2018	1.14	RGB		Modified stored procedure call to update start/stop dates
			05/24/2018	1.15	RGB		Added column list to provider extract
			05/30/2018	1.16	RGB		Updated column list
		
		*/

		declare @Version varchar(100) = '05/30/2018 08:30 Version 1.16'
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

		declare @IsWriteLocked bit
			   ,@IsReadLocked bit
			   ,@Now datetime = getdate()
			   ,@RunId uniqueidentifier = newid()
			   ,@ExtractName varchar(50) = 'Provider'

		select @IsWriteLocked = IsWriteLocked
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

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export providers'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 1
			  ,CurrentExecution = @Now
		where  ComponentName = 'Provider'

		declare @ColumnList varchar(4000) =
			'CorporationEIN,CorporationOtherName,CorporationLegalName,CorporationAddress1,CorporationAddress2,CorporationCity,CorporationState,CorporationZip,'
			+ 'CorporationContactName,CorporationContactPhone,CorporationContactExt,CorporationContactEmail,CorporationId,CorporationEffectiveDate,CorporationExpirationDate,CorporationEINType,'
			+ 'GroupNumber,VendorAccountNumber,VendorNumber,VendorName,VendorAddress1,VendorAddress2,VendorCity,VendorState,VendorZip,VendorContactName,VendorContactPhone,VendorContactExt,'
			+ 'VendorContactEmail,VendorLocation,VendorType,VendorTypeName,VendorEffectiveDate,VendorExpirationDate,VendorNPI,ProviderNumber,ProviderLastName,ProviderFirstName,ProviderMiddleInitial,'
			+ 'ProviderType,ProviderTypeName,ProviderDEANumber,ProviderUPIN,ProviderNPI,ProviderMedicareId,ProviderMedicaidId,ProviderFederalId,ProviderEmail,ProviderSex,ProviderMaidenName,'
			+ 'ProviderBirthplace,ProviderDateOfBirth,ProviderSSNumber,ProviderNationality,ProviderCitizenship,ShowInPrintedDirectory,ShowInWebDirectory,ProviderNCPDPNumber,ProviderSuffix,'
			+ 'ProviderCredentialDate,ProviderNextCredentialDate,ProviderLastCredentialDate,PrimaryState,PrimaryLicenseNumber,ProviderEntityType,ProviderDirectoryListingName,Hospital,'
			+ 'ProviderSpecialtyPrimary,ProviderSpecialtyPrimaryTaxonomyCode,ProviderSpecialtyPrimaryAltCode1,ProviderSpecialtyPrimaryAltCode2,ProviderSpecialtyOther,ProviderSpecialtyOtherTaxonomyCode,'
			+ 'ProviderSpecialtyOtherAltCode1,ProviderSpecialtyOtherAltCode2,PrimarySpecialtyId,PatientGender,ProviderOfficeMapId,PrimaryOffice,ProviderSundayStart,ProviderSundayEnd,ProviderMondayStart,'
			+ 'ProviderMondayEnd,ProviderTuesdayStart,ProviderTuesdayEnd,ProviderWednesdayStart,ProviderWednesdayEnd,ProviderThursdayStart,ProviderThursdayEnd,ProviderFridayStart,ProviderFridayEnd,'
			+ 'ProviderSaturdayStart,ProviderSaturdayEnd,OfficeNumber,OfficeName,OfficeAddress1,OfficeAddress2,OfficeCity,OfficeState,OfficeZip,OfficeContactName,OfficeContactPhone,OfficeContactExt,'
			+ 'OfficeContactEmail,OfficeContactFax,OfficeWheelchairAccess,OfficeAvailableAfterHours,OfficeNumberOfPhysicians,OfficeNPI,ProviderOfficeEffectiveDate,ProviderOfficeExpirationDate,'
			+ 'SundayStart,SundayEnd,MondayStart,MondayEnd,TuesdayStart,TuesdayEnd,WednesdayStart,WednesdayEnd,ThursdayStart,ThursdayEnd,FridayStart,FridayEnd,SaturdayStart,SaturdayEnd,'
			+ 'ProviderId,VendorId,ContractId,ContractName,ContractNumber,ContractType,ContractTypeName,OfficeId,PCMEffectiveDate,PCMExpirationDate,ProviderContractNumber,ProviderContractId,PanelStatus,'
			+ 'PanelSize,AssignedPanelSize,PanelAgeFrom,PanelAgeTo,PanelDescription,PanelDescriptionName,PanelGender,PanelGenderName,RiskGroupId,RiskGroupName,RiskGroupNumber,HospitalId,'
			+ 'HospitalName,HospitalNumber,HospitalNPI,TerminationReason,TerminationReasonName,RiskGroupClass,RiskGroupClassName,ProviderTitle,ProviderTitle2,STP,ProviderCredentialingStatus'

		exec HSP_MO.dbo.rr_GetProviderData @Usage = '|ALL|'
											  ,@TimePeriod = '|ALLTIME|'
											  ,@ReturnLanguage = 'ALL'
											  ,@DateUsage = '|ContractEffectiveWithinDateRange|'
											  ,@CustomAttributeEntity = 'PRV'
											  ,@SessionId = 0
											  ,@ReturnStatus = 'N'
											  ,@ColumnList = @ColumnList
											  ,@ResultsetName = 'MAIN'
											  ,@TableUsage = '|RECREATE|'
											  ,@ResultTableName = 'Hsp_Supplemental.EBM.Providers'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting export provider office custom attributes'
			   ,sysdatetime())

		exec HSP_MO.dbo.rr_ExportEntityCustomAttributes @EntityType = 'Provider Office Map'
														   ,@Usage = '|VALUES|'
														   ,@SessionId = null
														   ,@ReturnStatus = 'N'
														   ,@ColumnList = 'EntityID,AttributeName,AttributeValue,ValueLastUpdatedAt'
														   ,@TableUsage = '|RECREATE|'
														   ,@ResultTableName = 'Hsp_Supplemental.EBM.Providers_OfficeMapCustomAttributes'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Starting provider date reformatting and index building'
			   ,sysdatetime())

		exec HSP_Supplemental.EBM.ModifyFieldsProvider

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed provider date reformatting and index building'
			   ,sysdatetime())

		update EBM.ExportConfiguration
		set	   IsWriteLocked = 0
		where  ComponentName = 'Provider'

		insert into HSP_Supplemental.EBM.ExtractRunStatistics (
																  RunId
																 ,ExtractName
																 ,StepInformation
																 ,StepTime
															  )
		values (@RunId
			   ,@ExtractName
			   ,'Completed export providers'
			   ,sysdatetime())

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ModifyFieldsDiagnosisCodes
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/18/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '05/18/2018 10:00 Version 1.00'
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

		alter table HSP_Supplemental.EBM.DiagnosisCodes
		alter column EffectiveDate date null

		alter table HSP_Supplemental.EBM.DiagnosisCodes
		alter column ExpirationDate date null

		update HSP_Supplemental.EBM.DiagnosisCodes
		set	   EffectiveDate = null
		where  EffectiveDate = @HSPStartDate

		update HSP_Supplemental.EBM.DiagnosisCodes
		set	   ExpirationDate = null
		where  ExpirationDate = @HSPEndDate
			   or ExpirationDate = @HSPEndDate2

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ModifyFieldsMember
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/18/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '05/18/2018 14:00 Version 1.00'
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

		alter table EBM.EnrolledMembers_MemberCoverageDetails
		alter column EffectiveDate datetime null

		alter table EBM.EnrolledMembers_MemberCoverageDetails
		alter column ExpirationDate datetime null

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

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ModifyFieldsProcedureCodes
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/18/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '05/18/2018 14:00 Version 1.00'
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

	end
go
set ansi_nulls on
go
set quoted_identifier on
go

create procedure EBM.ModifyFieldsProvider
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/18/2018	1.00	RGB		Created new procedure
		
		*/

		declare @Version varchar(100) = '05/18/2018 14:00 Version 1.00'
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

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go

---	Resets the export configuration table

create procedure EBM.ResetExportConfiguration
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
		
		*/

		declare @Version varchar(100) = '04/05/2018 07:00 Version 1.08'
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
											   ,TableName
											   ,PreviousExecution
											   ,CurrentExecution
											   ,IsWriteLocked
											   ,IsReadLocked
											)
		values ('Member', 'EBM.EnrolledMembers', null, null, 0, 0)
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
			  ,('Aid Code', 'EBM.AidCodes', null, null, 0, 0)
			  ,('Contract', 'EBM.Contracts', null, null, 0, 0)
			  ,('Corporation', 'EBM.Corporations', null, null, 0, 0)
			  ,('Diagnosis Code', 'EBM.DiagnosisCodes', null, null, 0, 0)
			  --,('Group', 'EBM.Groups', null, null, 0, 0)
			  ,('Hospital', 'EBM.Hospitals', null, null, 0, 0)
			  ,('Procedure Code', 'EBM.ProcedureCodes', null, null, 0, 0)
			  --,('Procedure Code', 'EBM.ProcedureCodes_Modifier', null, null, 0, 0)
			  ,('Provider', 'EBM.Providers', null, null, 0, 0)
			  ,('Provider', 'EBM.Providers_OfficeMapCustomAttributes', null, null, 0, 0)
			  ,('Risk Group', 'EBM.RiskGroups', null, null, 0, 0)
			  ,('Risk Group', 'EBM.RiskGroups_HospitalMapping', null, null, 0, 0)
			  --,('Risk Group', 'EBM.RiskGroups_AlternateAddress', null, null, 0, 0)
			  --,('Vendor', 'EBM.Vendors', null, null, 0, 0)
			  --,('Vendor', 'EBM.Vendor_AlternateAddress', null, null, 0, 0)
			  ,('Claims', 'EBM.Claims', null, null, 0, 0)
			  ,('Claims', 'EBM.ClaimsDetail', null, null, 0, 0)
			  ,('Claims', 'EBM.ClaimsDetail_Explanations', null, null, 0, 0)
			  ,('Checks', 'EBM.Checks', null, null, 0, 0)
-- SQL Prompt formatting on

		return 0

	end

go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapAidCodesTables
	@Showversion bit = 0
   ,@ShowReturn bit = 0
with execute as owner
as
	begin
		/*
			Modification Log:
			
			05/09/2018	1.00	RGB		Created new procedure
		
		*/
		declare @Version varchar(100) = '05/09/2018 12:00 Version 1.00'
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

		drop table if exists EBMLastRun.AidCodes

		select *
		into   EBMLastRun.AidCodes
		from   EBM.AidCodes with (nolock)

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapChecksTables
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

		drop table if exists EBMLastRun.Checks

		select *
		into   EBMLastRun.Checks
		from   EBM.Checks with (nolock)

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapClaimsTables
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

		drop table if exists EBMLastRun.Claims

		select *
		into   EBMLastRun.Claims
		from   EBM.Claims with (nolock)

		drop table if exists EBMLastRun.ClaimsDetail

		select *
		into   EBMLastRun.ClaimsDetail
		from   EBM.ClaimsDetail with (nolock)

		drop table if exists EBMLastRun.ClaimsDetail_Explanations

		select *
		into   EBMLastRun.ClaimsDetail_Explanations
		from   EBM.ClaimsDetail_Explanations with (nolock)

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapContractsTables
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

		drop table if exists EBMLastRun.Contracts

		select *
		into   EBMLastRun.Contracts
		from   EBM.Contracts with (nolock)

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapDiagnosisCodesTables
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

		drop table if exists EBMLastRun.DiagnosisCodes

		select *
		into   EBMLastRun.DiagnosisCodes
		from   EBM.DiagnosisCodes with (nolock)

		return 0
	end
go
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapHospitalsTables
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

		drop table if exists EBMLastRun.Hospitals

		select *
		into   EBMLastRun.Hospitals
		from   EBM.Hospitals with (nolock)

		return 0
	end
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
set ansi_nulls on
go
set quoted_identifier on
go
create procedure EBM.SwapProcedureCodesTables
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

		drop table if exists EBMLastRun.ProcedureCodes

		select *
		into   EBMLastRun.ProcedureCodes
		from   EBM.ProcedureCodes with (nolock)

		return 0
	end
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
