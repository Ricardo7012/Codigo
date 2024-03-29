USE [HSP]
GO
/****** Object:  StoredProcedure [dbo].[dl_CreateCompleteClaimsTable]    Script Date: 7/19/2018 3:55:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[dl_CreateCompleteClaimsTable](
@ReportStartDate		datetime = null,
@ReportEndDate			datetime = null,
@ResultTableName		VarChar(255) = null,
@Usage					VarChar(255) = null,
@GroupLOB				Description_t = null,
@AllTables				VarChar(255) = 'N',
@ReturnFinInfo			VarChar(255) = 'N',
@ClaimMasterVersion		VarChar(255) = null,
@ReturnClaimOverrides	VarChar(255) = 'Y',
@ClaimStatusNotIn		VarChar(255) = null,
@SourceTypeIn			VarChar(255) = null,
@MedimartDatabaseName	VarChar(255),
@MedimartJobId			Id_t = null,
@RunClaimLoad			Code_t = 'INC',
@LastActiveRowVersionNumberFrom bigint,
@LastActiveRowVersionNumberTo bigint,
@PrintOutputTextMsg		Varchar(1)	 = 'N')

--With Encryption
as
Begin

declare 
		@PeriodStart		datetime,
		@PeriodEnd			datetime,
		@TableUsage			VarChar(10),
		@StartTime			datetime,
		@PrintMessage		varchar(255),
		@MedimartJobDetailID Id_t,
		@TableRowCount		int


/*****  START IEHP CUSTOMIZATION  *****/
DECLARE @ReturnWorkGroupInfo VARCHAR(1)

--Work group info can only be returned with report usages: |LatestClaims| and |LatestClaimLines|
IF @Usage IN ('|LatestClaims|', '|LatestClaimLines|')
	SET @ReturnWorkGroupInfo = 'Y'
ELSE
	SET @ReturnWorkGroupInfo = 'N'
/*****  END IEHP CUSTOMIZATION  *****/


if @RunClaimLoad = 'INC'
	begin

		-- start MedimartJobDetail
		exec dl_StartEndMedimartJobDetails
		@MedimartDatabaseName			= @MedimartDatabaseName,
		@ProcedureName					= 'dl_CreateCompleteClaimsTable',
		@MedimartJobId					= @MedimartJobId,
		@PeriodStartDate				= @PeriodStart,
		@PeriodEndDate					= @PeriodEnd,
		@TableName						= @ResultTableName,
		@StartOrEnd						= 'STR', -- start
		@MedimartJobDetailId			= @MedimartJobDetailId out
		

		If @PrintOutputTextMsg = 'Y'
		begin
			select @PrintMessage =	'PeriodStartDate: ' + convert(varchar,@PeriodStart,101) + 
									' PeriodEndDate: ' + convert(varchar,@PeriodEnd,101) +
									' StartTime: ' + convert(varchar,getdate(),108) +
									' TableName: ' + @ResultTableName

			RAISERROR(@PrintMessage,0,1) WITH NOWAIT
		end
	
		Select @StartTime = getdate(), @TableUsage = '|APPEND|'
	
		exec rr_ExportClaimDataComplete
		@ReturnStatus = 'N', 
		@Usage= @Usage, 
		@ClaimMasterVersion= @ClaimMasterVersion,
		@DateUsage='|Incremental|', 
		@GroupLOB = @GroupLOB,
		@ReturnExplanations=@AllTables, 
		@ReturnActionCodes=@AllTables,
		@ReturnInstitutionalClaimData=@AllTables, 
		@ReturnFinancialInformation=@ReturnFinInfo,
		@ReturnDocumentRequests = @AllTables, 
		@ReturnPCPInformation = @AllTables,
		@ReturnPendedWorkData = @AllTables,
		@ReturnLockData = @AllTables,
		@ReturnReportParameters = @AllTables,
		@ReturnClaimCodes = @AllTables,
		@ReturnClaimMasterData = @AllTables,
		@ReturnInputBatches = @AllTables,
		@ReturnClaimReimbursementLog = @AllTables,
		@ReturnClaimCOB = @AllTables,
		@SourceTypeIn = @SourceTypeIn,
		@ClaimStatusNotIn = @ClaimStatusNotIn,
		@GroupRepricing='SAG', --'N', Changed by IEHP:  Eric Huang
		@CalculateAging='CI',
		@AgingDateUsage='BDO', 
		@Interval='1', 
		@CalculateAging2='CR', 
		@AgingDateUsage2='BDO', 
		@Interval2='1', 
		@ReturnGroupInfo='N', 
		@ReturnMemberInfo='N', 
		@ReturnProviderInfo='N', 
		@ReturnOfficeInfo='N', 
		@ReturnVendorInfo='Y', 
		@ReturnCheckInfo='Y', 
		@ReturnUserNames='Y', 
		@ReturnReferenceCodesName='N', 
		@ReturnReferenceCodesNameLength='50', 
		@ReturnDiagnosisCodes='Y', 
		@ReturnClaimAdditionalInfo='Y', 
		@ReturnPendingExplanation='N', 
		@ReturnHighestActionCode='Y',
		@ReturnClaimOverrides = @ReturnClaimOverrides,
		@ReturnReAdjudicationWizardJobData=@AllTables,
		@TableUsage = @TableUsage,
		@ReturnWorkGroupInfo = @ReturnWorkGroupInfo, --Added by IEHP:  Eric Huang
		@ResultTableName = @ResultTableName,
		@LastActiveRowVersionNumberFrom = @LastActiveRowVersionNumberFrom,
		@LastActiveRowVersionNumberTo = @LastActiveRowVersionNumberTo

		If @PrintOutputTextMsg = 'Y'
		begin
			select @PrintMessage =	'StartDate: ' + convert(varchar,@PeriodStart,101) + 
									' EndDate: ' + convert(varchar,@PeriodEnd,101) +
									' StartTime: ' + convert(varchar,@StartTime,108) +
									' EndTime: ' + convert(varchar,getdate(),108) + 
									' Ran For: ' + Convert(VarChar(50),dateDiff(minute,@StartTime,getdate())) + 'Minute(s)'

			RAISERROR(@PrintMessage,0,1) WITH NOWAIT
		end
		
			-- get Table Rowcount
			exec dl_GetTableRowCount
			@TableName						= @ResultTableName,			-- Medimart db name already appended
			@TableRowCount					= @TableRowCount out


			-- end MedimartJobDetail
			exec dl_StartEndMedimartJobDetails
			@MedimartDatabaseName			= @MedimartDatabaseName,
			@TableRowCount					= @TableRowCount,
			@StartOrEnd						= 'END', -- start
			@MedimartJobDetailId			= @MedimartJobDetailId

	end

else
	begin
		declare ClaimCursor cursor Local Fast_Forward for
		Select P.dateValue, Dateadd(d,-1,(dateadd(m,1,P.DateValue)))
		From Periods P
		where P.DayOfMonth = 1
		and P.DateValue >= @ReportStartDate and
				P.DateValue <= @ReportEndDate
		order by P.DateValue

		open ClaimCursor
		fetch next from ClaimCursor
		into @PeriodStart, @PeriodEnd
		while @@Fetch_Status = 0
		begin

		If @PeriodStart != @ReportStartDate 
		begin
		Select @TableUsage = '|APPEND|'
		end
		else
		begin
		Select @TableUsage = '|CREATE|'
		end

			-- start MedimartJobDetail
			exec dl_StartEndMedimartJobDetails
			@MedimartDatabaseName			= @MedimartDatabaseName,
			@ProcedureName					= 'dl_CreateCompleteClaimsTable',
			@MedimartJobId					= @MedimartJobId,
			@PeriodStartDate				= @PeriodStart,
			@PeriodEndDate					= @PeriodEnd,
			@TableName						= @ResultTableName,
			@StartOrEnd						= 'STR', -- start
			@MedimartJobDetailId			= @MedimartJobDetailId out

		If @PrintOutputTextMsg = 'Y'
		begin
			select @PrintMessage =	'PeriodStartDate: ' + convert(varchar,@PeriodStart,101) + 
									' PeriodEndDate: ' + convert(varchar,@PeriodEnd,101) +
									' StartTime: ' + convert(varchar,getdate(),108) +
									' TableName: ' + @ResultTableName

			RAISERROR(@PrintMessage,0,1) WITH NOWAIT
		end
	
		Select @StartTime = getdate()
	
		exec rr_ExportClaimDataComplete
		@ReturnStatus = 'N', 
		@Usage= @Usage, 
		@ClaimMasterVersion= @ClaimMasterVersion,
		@DateUsage='|DateReceived|', 
		@PeriodStart=@PeriodStart, 
		@PeriodEnd=@PeriodEnd, 
		@GroupLOB = @GroupLOB,
		@ReturnExplanations=@AllTables, 
		@ReturnActionCodes=@AllTables,
		@ReturnInstitutionalClaimData=@AllTables, 
		@ReturnFinancialInformation=@ReturnFinInfo,
		@ReturnDocumentRequests = @AllTables, 
		@ReturnPCPInformation = @AllTables,
		@ReturnPendedWorkData = @AllTables,
		@ReturnLockData = @AllTables,
		@ReturnReportParameters = @AllTables,
		@ReturnClaimCodes = @AllTables,
		@ReturnClaimMasterData = @AllTables,
		@ReturnInputBatches = @AllTables,
		@ReturnClaimReimbursementLog = @AllTables,
		@ReturnClaimCOB = @AllTables,
		@SourceTypeIn = @SourceTypeIn,
		@ClaimStatusNotIn = @ClaimStatusNotIn,
		@GroupRepricing='SAG', --'N', Changed by IEHP:  Eric Huang
		@CalculateAging='CI',
		@AgingDateUsage='BDO', 
		@Interval='1', 
		@CalculateAging2='CR', 
		@AgingDateUsage2='BDO', 
		@Interval2='1', 
		@ReturnGroupInfo='N', 
		@ReturnMemberInfo='N', 
		@ReturnProviderInfo='N', 
		@ReturnOfficeInfo='N', 
		@ReturnVendorInfo='Y', 
		@ReturnCheckInfo='Y', 
		@ReturnUserNames='Y', 
		@ReturnReferenceCodesName='N', 
		@ReturnReferenceCodesNameLength='50', 
		@ReturnDiagnosisCodes='Y', 
		@ReturnClaimAdditionalInfo='Y', 
		@ReturnPendingExplanation='N', 
		@ReturnHighestActionCode='Y',
		@ReturnWorkGroupInfo = @ReturnWorkGroupInfo, --Added by IEHP:  Eric Huang
		@ReturnClaimOverrides = @ReturnClaimOverrides,
		@ReturnReAdjudicationWizardJobData=@AllTables,
		@TableUsage = @TableUsage,
		@ResultTableName = @ResultTableName

		If @PrintOutputTextMsg = 'Y'
		begin
			select @PrintMessage =	'StartDate: ' + convert(varchar,@PeriodStart,101) + 
									' EndDate: ' + convert(varchar,@PeriodEnd,101) +
									' StartTime: ' + convert(varchar,@StartTime,108) +
									' EndTime: ' + convert(varchar,getdate(),108) + 
									' Ran For: ' + Convert(VarChar(50),dateDiff(minute,@StartTime,getdate())) + 'Minute(s)'

			RAISERROR(@PrintMessage,0,1) WITH NOWAIT
		end
		
			-- get Table Rowcount
			exec dl_GetTableRowCount
			@TableName						= @ResultTableName,			-- Medimart db name already appended
			@TableRowCount					= @TableRowCount out


			-- end MedimartJobDetail
			exec dl_StartEndMedimartJobDetails
			@MedimartDatabaseName			= @MedimartDatabaseName,
			@TableRowCount					= @TableRowCount,
			@StartOrEnd						= 'END', -- start
			@MedimartJobDetailId			= @MedimartJobDetailId
	
		fetch next from ClaimCursor
		into @PeriodStart, @PeriodEnd
		end --- end while

		close ClaimCursor
		deallocate ClaimCursor
	end
end