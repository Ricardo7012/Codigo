USE HSP
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER procedure rr_ExportClaimDataComplete_ARCHDEV
(
	@SessionId 						Id_t 		   = null,
	
	@Usage							StringMedium_t = '|INIT|',
	@DateUsage						StringMedium_t = null,
	@PeriodStart					Date_t		   = null,
	@PeriodEnd						Date_t		   = null,
	@BaseTime 						Date_t 		   = null,		
	@TimePeriod 					StringShort_t  = null,	
	
	@FilterResultsetsBy				Code_t		   = null,  -- 'EXP','AC','FIN','LCK','AEX','AAC','AFI','ALC' Explanations, ActionCodes, Financials, Locks
	@ExplanationAbbreviation		StringShort_t  = null, 
	@ActionCode						Code_t		   = null,
	@ExplanationClass				Code_t		   = null,
	@ExplanationSubClass			Code_t		   = null, 
	@RecordType						Code_t		   = null,  
	@RecordTypeIn					StringMedium_t = null,  
	@RecordTypeNotIn				StringMedium_t = null,  
	@RecordStatus					Code_t		   = null,
	@RecordStatusIn					StringMedium_t = null,  
	@RecordStatusNotIn				StringMedium_t = null,
	@PreEstimateUsage				StringMedium_t = null,
	
	-- Filters On Claims, Claim_Master Table
	@ClaimMasterVersion				Code_t         = null,  -- Initial Adjudication, Initial Perfect Claim, Initial Closed Version
	@FormType						Code_t 		   = null,
	@FormSubtype					Code_t 		   = null, 
	@ClaimType						Code_t		   = null,
	@ClaimStatus					Code_t		   = null,
	@ClaimStatusIn					StringMedium_t = null,
	@ClaimStatusNotIn				StringMedium_t = null,
	@ClaimProcessingStatus			Code_t		   = null,
	@ClaimProcessingStatusIn		StringMedium_t = null,
	@ClaimProcessingStatusNotIn		StringMedium_t = null,
	@ClaimNumber					ClaimNumber_t  = null,
	@PaymentClass					Code_t		   = null, 
	@ClaimCategoryName				Name_t		   = null,
	@ClaimExplanationAbbreviation   StringShort_t  = null,	
	@MinimumTotalCharges			Money_t		   = null,		
	@UpdatedByName					Name_t		   = null,	   
	@UpdatedByDepartment			Name_t		   = null,
	@AssignmentOfBenefits		    Code_t		   = null,	
	@AdjustmentReasonCode			Code_t		   = null,
	@SuppressPayment				Code_t		   = null,

	-- Fl035772
	@WorkGroupID					id_t = null,
		
	-- Filters On Claim_Details, Claim_Results Table
	@ProcedureCode					ProcedureCode_t= null,
	@ProductCode					ProcedureCode_t= null,
	@PlaceOfService					Code_t		   = null,
	@MinimumLineCharges				Money_t		   = null,
	
	@ServiceCategoryName			Name_t		   = null,
	@FeeScheduleName				Name_t		   = null,
	@PlanName						Name_t		   = null,	
	@ContractName					Name_t		   = null,
	@AuthorizationNumber			REFNumber_t	   = null,  
	@OverrideUsed					Code_t		   = null,	
	@BenefitCategoryId				Id_t		   = null,
	
	-- Filters On InputBatches Table
	@SourceType						varchar(8)     = null,
	@SourceTypeIn					StringMedium_t = null,  
	@SourceTypeNotIn				StringMedium_t = null,  
	@SourceNumber					REFNumber_t	   = null,
	@ExternalBatchNumber			RefNumber_t	   = null,
	@InputBatchClass				varchar(64)    = null,
	@InputBatchSubClass             varchar(64)    = null,
	
	-- Filters For Entities
	@GroupNumber					REFNumber_t    = null,  
	@GroupNumberMask				StringMedium_t = null,
	@GroupLOB						Description_t  = null,
	@GroupProductLine				Description_t  = null,
	@GroupCoverage					Description_t  = null,
	@GroupProductType				Description_t  = null,
	@GroupRepricing					Code_t		   = null,	
	@CompanyName					Name_t		   = null,
	
	@MemberNumber					REFNumber_t	   = null,
	@SubscriberNumber				REFNumber_t	   = null,
	
	@ProviderNumber					REFNumber_t	   = null,
	@ProviderSpecialtyCategoryName	Name_t		   = null,  
	@ProviderSpecialtySubCategoryName	Name_t	   = null,
	@ProviderSpecialtyID			ID_t		   = null,
	
	@RiskGroupID					ID_t		   = null,
	@RiskGroupClass					Code_t			= null,
	@RiskGroupSubClass				Code_t			= null,
	
	@OfficeNumber					REFNumber_t	   = null,
	@OfficeZip						PostalCode_t   = null,
	@OfficeRegion					Code_t		   = null,
	@OfficeCounty					County_t	   = null,
	@OfficeState					State_t		   = null,		
	@OfficeCountryCode				REFNumber_t	   = null,	
	
	@VendorNumber					REFNumber_t	   = null,
	@EIN							RefNumber_t	   = null,
	
	@CaseNumber						REFNumber_t	   = null,

	@LockReason						Code_t		   = null,
	@LockClass						Code_t		   = null,
	@LockSubClass					Code_t		   = null,

	@ReAdjudicationWizardJobId		Id_t		   = null,
	@ReAdjudicationWizardJobClass	Code_t		   = null,
	@ReAdjudicationWizardJobSubClass	Code_t		   = null,
						
	-- Secondary Reultset Parameters
	@ReturnExplanations				Code_t		   = 'N',
	@ExplanationUsage				StringMedium_t = null,
	@ReturnActionCodes				Code_t		   = 'N',
	@ReturnInstitutionalClaimData	Code_t		   = 'N',
	@ReturnInstitutionalAuthInfo	Code_t		   = 'N',
	@ReturnFinancialInformation		Code_t		   = 'N', -- N, R, RD
	@ReturnClaimCodes				Code_t		   = 'N',
	@ReturnReportParameters			Code_t		   = 'N', 
	@ReturnClaimMasterData			Code_t		   = 'N',
	@ReturnClaimReimbursementLog	Code_t		   = 'N',
	@ReturnInputBatches				Code_t		   = 'N',
	@ReturnDocumentRequests			Code_t		   = 'N',
	@ReturnPCPInformation           Code_t		   = 'N',
	@ReturnPendedWorkData           Code_t		   = 'N',
	@ReturnReinsuranceData          Code_t		   = 'N',	
	@ReturnOverridesFromTransform	Code_t		   = 'N',
	@ReturnPharmacyData				Code_t		   = 'N',
	@ReturnLTCData					Code_t		   = 'N',
	@ReturnScreeningData			Code_t		   = 'N',
	@ReturnMedi_CalPharmacyData		Code_t		   = 'N',
	@ReturnLockData					Code_t		   = 'N',
	@ReturnReAdjudicationWizardJobData	YesNo_t	   = 'N',

	-- Parameters for Update Statements
	@ReturnClaimOverrides			Code_t		   = 'N',
	@ReturnClaimAdditionalInfo		Code_t		   = 'N',
	@ReturnPendingExplanation		Code_t		   = 'N',	
	@ReturnHighestActionCode		Code_t		   = 'N',	
	@ReturnPreEstimateReview		Code_t		   = 'N',
	@ReturnDiagnosisCodes			Code_t		   = 'N',
	@ReturnGroupInfo				Code_t		   = 'N',
	@ReturnMemberInfo				Code_t		   = 'N',
	@ReturnProviderInfo				Code_t		   = 'N',
	@ReturnOfficeInfo				Code_t		   = 'N',
	@ReturnVendorInfo				Code_t		   = 'N',
	@ReturnCheckInfo				Code_t		   = 'N',
	@ReturnWorkGroupInfo			Code_t		   = 'N',
	@ReturnTierItemInfo             Code_t		   = 'N',
	
	@ReturnUserNames				Code_t		   = 'N',
	@ReturnReferenceCodesName		Code_t		   = 'N',
	@ReturnReferenceCodesNameLength int			   = 20,
	@ReturnClaimCOB					Code_t		   = 'N',
	
	@CalculateAging					Code_t		   = null,  
	@AgingDateUsage					Code_t         = 'BDO',
	@Interval						int 		   = 5,		
	
	@CalculateAging2				Code_t		   = null,  
	@AgingDateUsage2				Code_t         = 'BDO',
	@Interval2						int 		   = 5,		

	@XMLCustomAttributes			YesNo_t		   = NULL,
	@SelectedAttribute1				ID_t		   = NULL,
	@SelectedAttribute2				ID_t		   = NULL,
	@SelectedAttribute3				ID_t		   = NULL,
	@SelectedAttribute4				ID_t		   = NULL,
	@SelectedAttribute5				ID_t		   = NULL,		
	@SelectedAttribute6				ID_t		   = NULL,
	@SelectedAttribute7				ID_t		   = NULL,
	@SelectedAttribute8				ID_t		   = NULL,
	@SelectedAttribute9				ID_t		   = NULL,
	@SelectedAttribute10			ID_t		   = NULL,	
	@CustomAttributeAsOfDate		Date_t		   = NULL,

	@ReturnStatus					YesNo_t		  = 'Y',
	@TableUsage						StringShort_t = null,
	@ResultTableName				Description_t = null,
	@ResultsetName					Description_t = null,
	@UserReportID					ID_t		  = null,
	@ColumnList						varchar(max) = null,
	@ReferringPreestimate			YesNo_t		  = null,
	@EmergencyReferral				YesNo_t		  = null,
	@SpecialtyCategory				Id_t		  = null,
	@SpecialtySubcategory			StringMedium_t= null,

	/*Added code for incremental*/
	@LastActiveRowVersionNumberFrom	bigint	=		null,
	@LastActiveRowVersionNumberTo		bigint	=		null,

	@Debug						int = 0
)

with encryption
as
begin

/*
© 1996-2017 Health Solutions Plus, Inc. All Rights Reserved.THIS IS LICENSED MATERIAL.
ONLY LICENSED PERSONS AND ENTITIES ARE ALLOWED TO POSSESS EITHER THE ORIGINAL OR ANY COPY OF 
THE LICENSED MATERIAL WITHOUT THE PERMISSION OF THE LICENSOR, HEALTH SOLUTIONS PLUS, INC.  The source code, whether in
human readable, machine readable, or compiled form (“Code”) and all algorithms, data structures and database schemas are
the confidential and proprietary trade secrets of Health Solutions Plus, Inc. its successors or assigns, and they are not
to be reproduced by any means, modified, stored, displayed, disseminated in any form by any means, or disclosed to
employees or third parties except as specifically permitted in the Source Code License Agreement between Health Solutions
Plus, Inc. and Code Licensee or other entity, (“License”).  USE, REPRODUCTION OR DISCLOSURE OF THE CODE, OR OF THE
CONFIDENTIAL OR PROPRIETARY TRADE SECRET INFORMATION CONTAINED THEREIN, EXCEPT AS STRICTLY PERMITTED BY THE LICENSE IS
UNLAWFUL, AND WILL SUBJECT THE VIOLATOR TO CIVIL DAMAGES AND PENALTIES OR CRIMINAL PENALTIES IN ACCORDANCE WITH STATE AND
FEDERAL LAWS.
Support for this code is provided by HSP Tech Support at (631)271-7682 during the hours of 9:00 AM to 5:00PM EST.
THIS NOTICE IS NOT TO BE REMOVED FROM THE CODE UNDER ANY CIRCUMSTANCES AND MUST BE INCLUDED IN ANY COPIES WHICH MAY BE MADE
BY LICENSEE.
*/

set nocount on

-- HSP-30423
-- Set transaction isolation level to read uncommitted to allow dirty reads, and prevent deadlocks
-- The scope is the current sp. When the sp terminates the isolation level reverts to its previous setting
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 1 - ' + convert(varchar,GETDATE(),121) 
		end
	
declare @Status 	int,
		@Rowcount	int,
		@Error		int,
		@Total		int,
		@internal	int,
		@UserId		Id_t,
		@UserMsg	StringLong_t,
		@LogMsg		StringLong_t,
		@ProductName StringMedium_t, 
		@ProcedureName StringMedium_t, 
		@ProcedureStep int,
		
		@SQLMain								varchar(max),		-- dynamic sql for returning data from the main resultset
		@SQLExplanations						varchar(max),
		@SQLActionCodes							varchar(max),
		@SQLInstitutional						varchar(max),
		@SQLFinancials							varchar(max),
		@SQLClaimCodes							varchar(max),
		@SQLCustomAttributes					varchar(max),
		@SQLParameters							varchar(max),
		@SQLAttr								varchar(max),
		@SQLClaimMasterData						varchar(max),
		@SQLClaimReimbursementLog				varchar(max),
		@SQLInputBatches						varchar(max),
		@SQLDocumentRequests					varchar(max),
		@SQLPCPInformation						varchar(max),
		@SQLPendedWorkData						varchar(max),
		@SQLReinsuranceData						varchar(max),		
		@SQLOverridesFromTransform				varchar(max),
		@SQLPharmacy							varchar(max),
		@SQLClaimCOBData						varchar(max),
		@SQLClaimCOBDataDetails					varchar(max),
		@SQLClaimCARCsRARCs						varchar(max),
		@SQLLongTermCare						varchar(max),
		@SQLScreeningVisit						varchar(max),
		@SQLMedi_CalPharmacy					varchar(max),
		@SQLLockData							varchar(max),
		@SqlReAdjudicationWizardJobs				varchar(max),

		@SecondaryResultTableName				Description_t,
		@SysOptEntityAttrValues					StringMedium_t,
		@ClaimXmlProcUsage						stringMedium_t,
		
		@InsertClause varchar(max),
		@SelectClause varchar(max),
		@FromClause varchar(max),
		@FromClause_C varchar(max),
		@FromClause_CD varchar(max),
		@FromClause_I varchar(max),
		@FromClause_CR varchar(max),
		@FromClause_CO varchar(max),
		@FromClause_CEM varchar(max),
		@FromClause_ACM varchar(max),
		@FromClause_ALC varchar(max),
		@FromClause_R varchar(max),
		@FromClause_MCR varchar(max),
		@WhereClause varchar(max),
		@WhereClauseReAdjudicationWizardDetails			varchar(max) = '',
		@WhereClauseReAdjudicationWizardDetailsHistory	varchar(max) = '',
		@WhereClause_IncrementalClaims varchar(max) = '',
		@OrderByClause varchar(max),
		@FinDSQLInsert	varchar(max),		-- dynamic sql for claim financials resultset
		@FinDSQLSelect	varchar(max),		-- dynamic sql for claim financials resultset
		@FinDSQLFrom	varchar(max),		-- dynamic sql for claim financials resultset
		@FinDSQLWhere	varchar(max),		-- dynamic sql for claim financials resultset
		@FinDSQLInsert2	varchar(max),		-- dynamic sql for claim financials resultset
		@FinDSQLSelect2	varchar(max),		-- dynamic sql for claim financials resultset
		@FinDSQLFrom2	varchar(max),		-- dynamic sql for claim financials resultset
		@ScreeningSQLInsert				varchar(max),	-- dynamic sql for screening visit resultset
		@ScreeningSQLSelect				varchar(max),	-- dynamic sql for screening visit resultset
		@ScreeningSQLFrom				varchar(max),	-- dynamic sql for screening visit resultset
		@ScreeningSQLWhere				varchar(max),	-- dynamic sql for screening visit resultset
		@Medi_CalPharmacySQLInsert		varchar(max),	-- dynamic sql for Medi-Cal Pharmacy resultset
		@Medi_CalPharmacySQLSelect		varchar(max),	-- dynamic sql for Medi-Cal Pharmacy resultset
		@Medi_CalPharmacySQLFrom		varchar(max),	-- dynamic sql for Medi-Cal Pharmacy resultset
		@Medi_CalPharmacySQLWhere		varchar(max),	-- dynamic sql for Medi-Cal Pharmacy resultset
		@Lock_SQLInsert					varchar(max),	-- dynamic sql for LockData resultset
		@Lock_SQLSelect					varchar(max),	-- dynamic sql for LockData resultset
		@Lock_SQLFrom					varchar(max),	-- dynamic sql for LockData resultset
		@Lock_SQLWhere					varchar(max),	-- dynamic sql for LockData resultset
		@Lock_SQLOrderBy				varchar(max),	-- dynamic sql for LockData resultset
		@SqlRetrieveReAdjudicationWizardJobs	nvarchar(max),
		@SqlRetrieveReAdjudicationWizardJobsParamDefinition nvarchar(max),
		
		@ProviderId ID_t,
		@OfficeId	ID_t,
		@VendorId	ID_t,
		@GroupId	ID_t,
		@CompanyId	ID_t,
		@CaseId		ID_t,
		@AuthorizationID ID_t,
		@UpdatedById ID_t,
		@UpdatedByDeptId Id_t,
		@InvalidReferenceCode Code_t,
		@ClaimExplanationId	ID_t,
		@ExplanationId		ID_t,
		@ActionCodeId		ID_t,
		@ServiceCategoryId	ID_t,
		@FeeScheduleId		ID_t,
		@PlanId				ID_t,
		@ProviderContractId	ID_t,
		@ContractID			ID_t,
		@ReAdjudicationWizardJobNumber	RefNumber_t = null,
		
		@ProviderSpecialtyCategoryId	ID_t, 
		@ProviderSpecialtySubCategoryId	ID_t,
		@ProviderSpecialtyName			Name_t,
		@ClaimCategoryCode				Code_t,
		@GroupLOBCode					Code_t,
		@GroupProductLineCode			Code_t,
		@GroupCoverageCode				Code_t,
		@GroupProductTypeCode			Code_t,
		
		-- for aging
		@Range1 			StringShort_t,
		@Range2 			StringShort_t,
		@Range3	 			StringShort_t,
		@Range4 			StringShort_t,
		@Range5 			StringShort_t,
		@Range6 			StringShort_t,
		@Range7 			StringShort_t,
		@LengthOfString		int,
		@ValuetoSubtract 	int,
		@Value				int,
		@ReturnCustomAttributes YesNo_t,
		@DebugCustomAttributes int,
		@SpecialtySubcategoryId	Id_t,


		@SQLClosedClaim varchar(max),
		@SQLClosedClaim_InsertClause varchar(max),
		@SQLClosedClaim_SelectClause varchar(max),
		@SQLClosedClaim_FromClause varchar(max),
		@SQLClosedClaim_WhereClause varchar(max),
		@ErrorMsg			ErrorMsg_t,
		@FullRowCount			int,
		@PermittedCount			int,
		@RestrictedCount		int,
		
		@CTEClaimAgingSQL	varchar(max),
		@UPDATEAgingSQL		varchar(max),
		@DeleteClaimIdsSQL	varchar(max) = ''

select 	@Status 	= 0,
		@Rowcount	= 0,
		@Error		= 0,
		@ProcedureName = 'rr_ExportClaimDataComplete',
		@ProcedureStep = 0,
		
		@SysOptEntityAttrValues = dbo.ff_GetSysOptionValue('MEDITRAC','CLAIMENTITYATTRIBUTES',null),
		
		@InsertClause = '',
		@SelectClause = '',
		@FromClause	  = '',
		@FromClause_C   = '',
		@FromClause_CD  = '', 
		@FromClause_I	= '',
		@FromClause_CR	= '',
		@FromClause_CO	= '',
		@FromClause_CEM = '',
		@FromClause_ACM = '',
		@FromClause_ALC = '',
		@FromClause_R   = '',
		@FromClause_MCR = '',
		@WhereClause  = '',
		@InvalidReferenceCode = '',
		@ValuetoSubtract = 1,
		@ReturnCustomAttributes = case when @SelectedAttribute1 is not null or @SelectedAttribute2 is not null or 
			@SelectedAttribute3 is not null or @SelectedAttribute4 is not null or @SelectedAttribute5 is not null or
			@SelectedAttribute6 is not null or @SelectedAttribute7 is not null or @SelectedAttribute8 is not null or 
			@SelectedAttribute9 is not null or @SelectedAttribute10 is not null then 'Y' else 'N' end,
		@ReturnReAdjudicationWizardJobData = isnull( nullif( @ReturnReAdjudicationWizardJobData, '' ), 'N' ),
		@FullRowCount			= 0,
		@PermittedCount			= 0,
		@RestrictedCount		= 0
		
-- Check Session		
if @ReturnStatus = 'Y' 
	begin
		exec @internal = ii_CheckSession
							@SessionId = @SessionId,
							@UserId = @UserId out,
							@ErrorMsg = @LogMsg out,
							@ProductName = @ProductName out
		
					select @error = @@ERROR
					if @error != 0
						begin
							select	@UserMsg = 'Your SessionId is invalid.',
									@LogMsg = 'Call to ii_CheckSession failed: ' + ISNULL(@LogMsg,'') 
							raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
							goto ServerErrorExit
						end
					else if @internal <> 0
						begin
							select	@UserMsg = case when @internal = 1 then ISNULL(@LogMsg,'') else 'Error when the session is being validated' end,
									@LogMsg = 'ii_CheckSession returned: ' + ISNULL(@LogMsg,'') 
							raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
							goto ServerErrorExit
						end
	end -- if @ReturnStatus = 'Y'
		
---*******************************************************************************************************************
--- Main ResultSet Declaration
---
--- Actual Tables: Claims, Claim_Master, Claim_Details, Claim_Results, and InputBatches 
---
---*******************************************************************************************************************

create table #ResultSet
(
	-- Claims
	ClaimId	Id_t			not null,
	AdjustmentVersion		int	null,
	ClaimNumber				ClaimNumber_t	null,
	FormType				Code_t	null,
	FormTypeName			Name_t	null, 
	FormSubtype				Code_t	null,
	FormSubtypeName			Name_t	null, 
	ClaimType				Code_t	null,
	ServiceDateFrom			Date_t	null,
	ServiceDateTo			Date_t	null,
	EntryDateTime           Date_t	null, 
	DateReceived			Date_t	null,
	MemberId				Id_t	null,
	MemberCoverageId		Id_t	null,
	
	SubscriberContractId	Id_t	null,
	SubscriberId			Id_t	null,
	GroupId					Id_t	null,
	ProviderId				Id_t	null,
	OfficeId				Id_t	null,
	VendorId				Id_t	null,
	Status					Code_t	null,
	StatusName				Description_t null,
	InputBatchID			int		null,
	ClosedDate				Date_t	null,
	DateEOBPrinted			Date_t	null,
	DateESTPrinted			Date_t	null,
	Date837Exported			Date_t	null,
	DateEncounterExported	Date_t	null,
	ProcessingStatus		Code_t	null,
	ProcessingStatusName	Description_t null,
	ClosedVersion			int		null,
	InitialAdjudicationVersion	int	null,		
	InitialAdjudicationDate Date_t  null,
	InitialReadyToCloseDate	Date_t	null,
	AdjudicationActionCodes	char	null,	
	PaymentActionCodes		char	null,	
	CategoryI				char	null,
	CategoryII				char	null,
	CategoryIII				char	null,				
	InitialClaimEditingVersion	int	null,
	ClaimExplanationId		Id_t null,
	ClaimExplanationAbbreviation StringShort_t null,
	ClaimCategoryCode		Code_t null,
	ClaimCategoryName		Name_t null,

	--Claim_Master
	ExternalClaimNumber		REFNumber_t	null,
	ExternalReferralNumber	REFNumber_t	null,
	ExternalAuthorizationNumber		REFNumber_t	null, 
	AdjustmentReason		StringMedium_t	null,
	CaseID					Id_t	null,
	CaseNumber				REFNumber_t null,
	ClaimStatus				Code_t	null,		
	PatientAccountNumber	varchar(20)	null,
	TotalCharges			Money_t	null,
	SourceType				varchar(8)	null,
	AssignmentBenefits		varchar(2)	null,
	SuppressPayment			Code_t	null,
	BilledCurrency			Code_t	null,
	BilledCurrencyName		Description_t	null,
	PaymentClass			Code_t	null,
	PaymentClassName		Description_t	null,
	EOBAction				Code_t	null,
	EOBActionName			Description_t	null,
	InterestOnAdjustments	Code_t			null,
	InterestOnAdjustmentsName Description_t	null,
	AdjustmentReasonCode	Code_t	null,
	AdjustmentReasonCodeName Description_t	null,
	OffWorkDateFrom			Date_t null,
	OffWorkDateTo			Date_t null,
	HospitalDateFrom		Date_t null,
	HospitalDateTo			Date_t null,
	OutsideLab				YesNo_t null,
	LabCharges				Money_t null,
	Remarks					StringMedium_t null,
	AmountPaid				Money_t null,
	ClaimTotalProviderPaid	Money_t null,
	ClaimTotalMemberPaid	Money_t null,
	ClaimTotalPaid          Money_t null,
	BalanceDue				Money_t null,
	ReferringProviderId		Id_t null,
	RefPhysicianName		varchar(90) null,
	RefPhysicianNumber		REFNumber_t null,
	RefPhysicianNumberQualifier Code_t null,
	RefPhysicianNumber2		REFNumber_t null,
	RefPhysicianNumberQualifier2 Code_t null,
	EmploymentRelated       YesNo_t null,
	AutoAccident			YesNo_t null,
	EpisodeDate				Date_t null,
	PriorEpisodeDate		Date_t null,
	AutoAccidentState		State_t null,
	CleanedDate				Date_t	null,
	AdjustedClosedDate		Date_t	null,
	ReferringPreestimate				YesNo_t null,
	ProviderSpecialtyCategoryID			Id_t null,
	ProviderSpecialtyCategoryName		Name_t null,
	ProviderSpecialtySubCategoryID		Id_t null,
	ProviderSpecialtySubCategoryName	Name_t null,
	EmergencyReferral					YesNo_t null,
	ReferringOfficeId					Id_t null,
	ReferringProviderName				varchar(90) null,
	ReferringProviderNumber				REFNumber_t null,
	ReferringProviderNumberQualifier	Code_t null,
	ReferringProviderNumber2			REFNumber_t null,
	ReferringProviderNumberQualifier2	Code_t null,
	DelayReason							Code_t null,
	ClaimSOC							Money_t null,
	GracePeriod							int null,
	ReallocateClaimLevelAmounts         Code_t null,
	CreateFinancialRecord				Code_t null,
	CreateInformationalAdjustment		Code_t null,
	DateProcessed						Date_t null,

	--Dental
	MissingTeethInfo		StringMedium_t null,
	Radiograph				char(1) null,
	RadiographCount			int null,
	RadiographReferenceNumber REFNumber_t null,
	Orthodontics			char(1) null,
	OrthodonticsTotalMonths	int null,
	DateAppliancePlaced		Date_t null,
	MonthsRemaining			int null,
	Prosthesis				Code_t null,
	PriorPlacementDate		Date_t null,
	--Repricing claims
	RepricedTotalAmount		money null,
	RepricedFeeCode			Code_t null,
	RepricedRejectCode		Code_t null,
	--MCCI claims - which fields
	AmtNegotiated			Money_t null,
	AmtMaximumAllowable		Money_t null,
	NegotiatedDiscountType  Code_t null,
	NegotiatedDiscountValue Money_t null,
	NetDays					int null,
	LastUpdatedBy			Id_t null,
	LastUpdatedByName       Name_t null,
	LastUpdatedAt			Date_t null,
	DepartmentID			Id_t null,
	DepartmentName			Name_t null,
	COBIndicatorCode		Code_t null,
	COBIndicator			Description_t null,
	
	-- Claim_Details
	LineNumber				int	    null,
	LineServiceDateFrom		Date_t	null,
	LineServiceDateTo		Date_t	null,
	PlaceOfService			Code_t	null,
	TypeOfService			Code_t	null,
	ProcedureCode			ProcedureCode_t	null,
	Modifier				Code_t	null,
	Modifier2				Code_t	null,
	Modifier3				Code_t	null,
	Modifier4				Code_t	null,
	AdjProcedureCode		ProcedureCode_t	null,
	AdjModifier				Code_t	null,
	AdjPlaceOfService		Code_t	null,
	DiagnosisPtrs			StringShort_t null,
	DiagnosisPtr1			varchar(2) null,
	DiagnosisPtr2			varchar(2) null,
	DiagnosisPtr3			varchar(2) null,
	DiagnosisPtr4			varchar(2) null,
	Amount					Money_t	null,
	BilledCurrencyAmount	decimal(30,10) null, --Money_Extended_t	null,
	AmountMaximumAllowed	Money_t	null,
	AmtRepriced				Money_t	null,
	FeeCode					Code_t	null,
	RepricingOrganizationNumber varchar(50) null,
	UnitType				Code_t	null,
	ServiceUnits			real	null,
	EPSDTPlan				YesNo_t	null,
	EMG						YesNo_t	null,
	PrimaryFeeAllowed		Money_t	null,
	COB						Money_t	null,
	SOC						Money_t null,
	ProductCodeQualifier	Code_t null,
	ProductCode				ProcedureCode_t null,
	ProductQuantity			real null,
	ProductUnitOfMeasure	Code_t null,
	Description				StringMedium_t	null,
	HCPCSRates				ProcedureCode_t	null,
	Tooth					Code_t	null,
	Surface					varchar(10)	null,
	Quadrant				Code_t	null,
	AdjUnitType				Code_t	null,
	AdjServiceUnits			real	null,
	ClaimEditingStatus		Code_t	null,
	ClaimPricingService		Code_t	null,
	SuppliedUCR				Money_t	null,
	LineAuthorizationNumber			REFNumber_t		  null,
	LineAuthorizationNumberType		Code_t			  null,
	OtherCoverageCode				Code_t			  null,
	LevelOfService					Code_t			  null,
	RestrictionsMetIndicator		Code_t			  null,
	
	-- Claim_Results
	AllowedUnits			Real_t	null, 
	AmtCharged				Money_t	null,
	AmtDeferred				Money_t	null,
	AmtPatientLiability		Money_t	null,
	AmtNotCovered			Money_t	null,
	AmtCovered				Money_t	null,
	AmtDisallowed			Money_t	null,
	AmtOverContract			Money_t	null,
	AmtFeeAllowed			Money_t	null,
	AmtReduction			Money_t	null,
	AmtDiscount				Money_t	null,
	AmtWithhold				Money_t	null,
	AmtEligible				Money_t	null,
	AmtCopay				Money_t	null,
	AmtCoinsurance			Money_t	null,
	AmtDeductible			Money_t	null,
	AmtCOB					Money_t	null,
	AmtSOC					Money_t	null,
	AmtStopLoss				Money_t	null,
	AmtExceedMax			Money_t	null,
	VisitsCovered			int		null,
	AmtPrevPaidProv			Money_t	null,
	AmtToPay				Money_t	null,
	AmtToPayMember			Money_t	null,
	ClaimLineTotalPaid		Money_t null,
	ExplanationId			Id_t	null,
	PlanId					Id_t	null,
	PlanName				Name_t  null,
	AuthorizationId			Id_t	null,
	AuthorizationNumber		REFNumber_t	null,
	ReferralId				Id_t	null,
	ReferralNumber			REFNumber_t	null,
	ServiceCategoryId		Id_t	null,
	ServiceCategoryName 	Name_t	null,
	ServiceCategoryClass	Description_t	null,  
	ServiceCategorySubClass	Description_t	null,
	LiabilityLevelId		Id_t	null,
	LiabilityLevelName 		Name_t null,
	LiabilityPackageId		Id_t	null,
	LiabilityPackageName 	Name_t null,
	ProviderContractId		Id_t null,
	ContractId				Id_t	null,
	ContractName			Name_t	null,
	ContractType			Code_t  null,
	ContractTypeName        Description_t null,
	FeeScheduleId			Id_t	null,
	FeeScheduleName			Name_t null,
	FeeScheduleDetailId		Id_t	null,
	ReimbursementId			Id_t	null,
	ReimbursementName		Name_t null,
	BenefitCategoryId		Id_t	null,
	BenefitCategoryName		Name_t null,
	ResultStatus			Code_t	null,		
	ResultStatusName		Description_t null, 
	ResultDescription		StringMedium_t	null,
	AmtUCR	Money_t	null,
	ContractFeeScheduleMapId	Id_t	null,
	ExchangeRate			decimal(30,10) null,  --Money_Extended_t	null,
	DenialAction			Code_t	null,
	DenialActionName		Description_t null,
	Negotiated				Code_t	null,
	NegotiatedName			Description_t null,
	PreEstimateClaimID		Id_t	null,
	PreEstimateLineNumber	int	null,
	ModifierReductionScheduleDetailId	Id_t	null,
	AmtOutOfPocket			Money_t	null,
	AuthorizationVersion	int null,
	AuthServiceLineNumber	int	null,
	AuthServiceDetailLineNumber	int	null,
	AdjReviewExplanationID  Id_t null,
	AmtProviderPenalty		Money_t	null,
	AmtMemberPenalty		Money_t	null,
	AmtPrevPaidMember		Money_t	null,
	StepDownLiabilityStepNumber	int	null,
	AmtMoneyLimitApplied	Money_t	null,
	OverrideUsed			Code_t null,
	OverrideUsedName		Description_t null,
	BenefitCoverageID		ID_t null,
	BenefitCoverageEffectiveDate Date_t null,
	BenefitCoverageExpirationDate Date_t null,
	AmtEpisode				 Money_t	null,
	EpisodeAuthorizationId	 Id_t		null,
	EpisodeAuthorizationNumber REFNumber_t	null,
	ModifierReductionScheduleID			Id_t	null,
	ModifierReductionScheduleName			Name_t NULL,
	SalesTaxRateID			 Id_t null,
	SalesTaxAmount			 Money_t null,
	RiskGroupDelegatedServiceID		id_t			null,


	-- Claim_Overrides
	OverrideServiceCategoryId	Id_t null,
	OverrideServiceRestriction	YesNo_t null,
	OverrideLateFiling	YesNo_t null,
	OverrideDuplicateChecking	YesNo_t null,
	OverridePreEstimateNeeded	YesNo_t null,
	OverrideDeductibleAmt	Money_t null,
	OverrideCoinsuranceAmt	Money_t null,
	OverrideCoPaymentAmt	Money_t null,
	OverrideOtherPatientAmt	Money_t null,
	OverrideDenyClaim	YesNo_t null,
	OverrideExplanationId	Id_t null,
	OverrideExplanationId2	Id_t null,
	OverrideExplanationId3	Id_t null,
	OverrideServiceDateReplacedWith	Date_t null,
	OverrideReferralNeeded	YesNo_t null,
	OverrideDenialOfRelatedProcedures	YesNo_t null,
	OverridePreExisting	YesNo_t null,
	OverrideAuthorizationNeeded	YesNo_t null,
	OverridePrimaryCareRestriction	YesNo_t null,
	OverrideCOBProcessing YesNo_t null,
	OverrideDelegatedRule YesNo_t null,
	OverrideGlobalFee	Code_t null,
	OverridePaymentClassWith	Code_t null,
	OverrideSuppressPaymentWith	Code_t null,
	OverrideClaimEditing	YesNo_t null,
	OverrideClaimPricing	YesNo_t null,
	OverrideDenialAction	Code_t null,
	OverrideMedicalCaseReview	YesNo_t null,
	OverrideContractId	Id_t null,
	OverrideLiabilityLevelId	Id_t null,
	OverrideBenefitCategoryId	Id_t null,
	OverrideAllowedAmount	Money_t null,
	OverrideAmtToPay	Money_t null,
	OverrideAmtToPayMember	Money_t null,
	OverrideAmtCoPay	Money_t null,
	OverrideAmtCoInsurance	Money_t null,
	OverrideAmtDeductible	Money_t null,
	OverrideAmtPatientLiability	Money_t null,
	OverrideAmtOutOfPocket	Money_t null,
	OverrideMaxVisits	real null,
	OverrideMaxUnits	real null,
	OverrideMaxDollars	Money_t null,
	OverrideLiabilityPackageIdHistory	Id_t null,
	OverrideAmtToPenalizeMember	Money_t null,
	OverrideAmtToPenalizeProvider	Money_t null,
	OverrideStepDownLiabilityStepNumber	int null,
	OverrideAmtMoneyLimitApplied	Money_t null,
	OverrideEpisodeAuthorizationId	Id_t	null,
	OverrideAmtPreExistingApplied	Money_t null,
	OverrideAllowedUnits		    real    null,
	OverrideSalesTaxRate			decimal(30,10)	null,
	OverrideSalesTaxAmount			Money_t	null,
	OverrideFilingDate				Date_t  null,
	OverrideFilingReductionAmount   Money_t null,
	OverrideGender					Gender_t null,
	OverrideDOB						Date_t	 null,
	OverrideRelationshipCode		Code_t	 null,
    OverrideWithholdPercentage		Money_t	 null, 
	OverrideWithholdAmount			Money_t  null,	

	-- InputBatches
	LocationID				Id_t	null,
	InputBatchStatus		Code_t	null,
	SourceName				Name_t	null,
	SourceNumber			varchar(16)	null,
	DateScanned				Date_t	null,
	DateInput				Date_t	null,
	ControlNumber			REFNumber_t	null,
	ExternalBatchNumber		StringShort_t	null,
	InputBatchClass			varchar(64) null,
	InputBatchSubClass      varchar(64) null,

	-- EDI
	EDIJobNumber			REFNumber_t	null,
	EDIExternalFileName		StringMedium_t null,
	
	-- Claim Codes
	DiagnosisCode1			varchar(10)	null,
	DiagnosisCode2			varchar(10)	null,
	DiagnosisCode3			varchar(10)	null,
	DiagnosisCode4			varchar(10)	null,
	DiagnosisCode5			varchar(10)	null,
	DiagnosisCode6			varchar(10)	null,
	DiagnosisCode7			varchar(10)	null,
	DiagnosisCode8			varchar(10)	null,
	DiagnosisCode9			varchar(10)	null,
	DiagnosisCode10			varchar(10)	null,
	DiagnosisCode11			varchar(10)	null,
	DiagnosisCode12			varchar(10)	null,
	DiagnosisCode13			varchar(10)	null,
	DiagnosisCode14			varchar(10)	null,
	DiagnosisCode15			varchar(10)	null,
	DiagnosisCode16			varchar(10)	null,
	DiagnosisCode17			varchar(10)	null,
	DiagnosisCode18			varchar(10)	null,
	DiagnosisCode19			varchar(10)	null,
	DiagnosisCode20			varchar(10)	null,
	DiagnosisCode21			varchar(10)	null,
	DiagnosisCode22			varchar(10)	null,
	DiagnosisCode23			varchar(10)	null,
	DiagnosisCode24			varchar(10)	null,
	PrincipalDiagnosisCode	varchar(10)	null,

	DiagnosisCodeQual1		Code_t		null,
	DiagnosisCodeQual2		Code_t		null,
	DiagnosisCodeQual3		Code_t		null,
	DiagnosisCodeQual4		Code_t		null,
	DiagnosisCodeQual5		Code_t		null,
	DiagnosisCodeQual6		Code_t		null,
	DiagnosisCodeQual7		Code_t		null,
	DiagnosisCodeQual8		Code_t		null,
	DiagnosisCodeQual9		Code_t		null,
	DiagnosisCodeQual10		Code_t		null,
	DiagnosisCodeQual11		Code_t		null,
	DiagnosisCodeQual12		Code_t		null,
	DiagnosisCodeQual13		Code_t		null,
	DiagnosisCodeQual14		Code_t		null,
	DiagnosisCodeQual15		Code_t		null,
	DiagnosisCodeQual16		Code_t		null,
	DiagnosisCodeQual17		Code_t		null,
	DiagnosisCodeQual18		Code_t		null,
	DiagnosisCodeQual19		Code_t		null,
	DiagnosisCodeQual20		Code_t		null,
	DiagnosisCodeQual21		Code_t		null,
	DiagnosisCodeQual22		Code_t		null,
	DiagnosisCodeQual23		Code_t		null,
	DiagnosisCodeQual24		Code_t		null,
	PrincipalDiagQualifier	Code_t		null,	

	POAIndicator1			Code_t		null,
	POAIndicator2			Code_t		null,
	POAIndicator3			Code_t		null,
	POAIndicator4			Code_t		null,
	POAIndicator5			Code_t		null,
	POAIndicator6			Code_t		null,
	POAIndicator7			Code_t		null,
	POAIndicator8			Code_t		null,	
	POAIndicator9			Code_t		null,
	POAIndicator10			Code_t		null,
	POAIndicator11			Code_t		null,
	POAIndicator12			Code_t		null,
	POAIndicator13			Code_t		null,
	POAIndicator14			Code_t		null,
	POAIndicator15			Code_t		null,
	POAIndicator16			Code_t		null,		
	POAIndicator17			Code_t		null,
	POAIndicator18			Code_t		null,
	POAIndicator19			Code_t		null,
	POAIndicator20			Code_t		null,
	POAIndicator21			Code_t		null,
	POAIndicator22			Code_t		null,
	POAIndicator23			Code_t		null,
	POAIndicator24			Code_t		null,					
	PrincipalPOAIndicator	Code_t		null,

	-- Pending Explanation for claims in perfect claim
	PendingExplanationID	Id_t null,
	PendingExplanationAbbreviation StringShort_t null,
	PendingStatus			Code_t null,
	PendingDate				Date_t null,
	PendingDescription		varchar(255) null,  -- for now return only 255 characters
				
	-- Highest Action Code, ActionCodes, ClaimActionCodeMap
	HighestActionCodeId		Id_t   null,
	HighestActionCode		Code_t null,
	HighestActionCodeName	Name_t null,
	--HighestActionCodeEntityType Code_t null,  -- Need to left join to EntityActionCodeMap, Do we need this?
	HighestActionCodePrecedence int null,
	HighestActionCodeExplanationId	Id_t null,		
	
	--PreEstimateReview
	PreEstimateReviewStatus			Code_t null,
	PreEstimateReviewStatusName		Description_t null,
	PreEstimateReviewAdjustmentVersion int null,
	PreEstimateReviewExplanationID	Id_t null,
	PreEstimateReviewExplanationAbbreviation StringShort_t null,
	PreEstimateReviewedBy			Id_t null,
	PreEstimateReviewedByName		Name_t null,
	PreEstimateReviewedAt			date_t null,
	
	-- Applied Claims for PreEstimate
	AppliedClaimID					Id_t NULL,
	AppliedClaimNumber				ClaimNumber_t NULL,		
	AppliedClaimLineNumber			int	NULL,
	AppliedClaimProcessingStatus	Code_t NULL,
	AppliedClaimServiceDate			Date_t	NULL,
	AppliedClaimLineStatus			Code_t	NULL,
	AppliedClaimAmountToPay			Money_t	NULL,
	AppliedClaimAmountToPayMember	Money_t	NULL,
	AppliedClaimAmountCopay			Money_t NULL,

	-- Groups Columns
	GroupNumber						REfNumber_t null,
	GroupName						Name_t	null,
	GroupType						Code_t	null,
	GroupLineOfBusiness				Code_t null,
	GroupLineOfBusinessName			Description_t null,
	GroupProductLine				Code_t null,
	GroupProductLineName			Description_t null,
	GroupCoverage					Code_t null,
	GroupCoverageName				Description_t null,
	GroupProductType				Code_t null,
	GroupProductTypeName			Description_t null,
	ParentGroupId					Id_t    null,
	ParentGroupName					Name_t  null,
	ParentGroupNumber				REfNumber_t null,
	CompanyId						Id_t    null,
	CompanyName						Name_t  null,
		
	-- 	Members Columns
	MemberNumber  					REFNumber_t	null,
	MemberPolicyNumber				REFNumber_t	null,
	MemberLastName					LastName_t	null,
	MemberFirstName					FirstName_t	null,
	MemberMiddleName				MiddleName_t null,
	MemberDateOfBirth				Date_t		null,
	MemberAddress1					Address_t	null,
	MemberAddress2					Address_t	null,
	MemberCity						City_t null,
	MemberState						State_t null,
	MemberCounty					County_t null,
	MemberZip						PostalCode_t	null,
	MemberZipSearch					PostalCode_t	null,
	MemberRegion					Code_t		null,
	MemberRegionName				Description_t	null,
	SubscriberNumber				REFNumber_t	NULL,
	SubscriberLastName				LastName_t	null,
	SubscriberFirstName				FirstName_t	null,
	TierItemId					    Id_t	null,
	TierItemName					Name_t  null,
	TierAsOfDate					Date_t  null,
	RelationshipCode				Code_t  null,
	RelationshipName				Description_t null,	
			
	-- 	Providers Columns
	ProviderNumber					REFNumber_t	null,
	ProviderType					Code_t		null,
	ProviderLastName				Name_t		null,
	ProviderFirstName				FirstName_t	null,
	ProviderNPI						REFNumber_t null,					
	ProviderContractNumber			REFNumber_t null,
	
	-- Offices Columns
	OfficeName						Name_t		null,
	OfficeNumber					REFNumber_t	null,
	OfficeNPI						REFNumber_t null,	
	OfficeAddress1					Address_t	null,
	OfficeAddress2					Address_t	null,
	OfficeCity						City_t	null,
	OfficeState						State_t	null,
	OfficeZip						PostalCode_t	null,
	OfficeZipSearch					PostalCode_t	null,
	OfficeRegion					Code_t			null,
	OfficeRegionName				Description_t	null,
	OfficeCounty					County_t	null,
	OfficeCountryCode				REFNumber_t 	null,
	OfficePhone						Phone_t		null,

	-- 	Vendors Columns
	VendorNumber					REFNumber_t	null,
	VendorName						Name_t		null,
	VendorNPI						REFNumber_t null,	
	VendorAddress1 					Address_t 	null,
	VendorAddress2 					Address_t 	null,
	VendorCity 						City_t 		null,
	VendorState 					State_t 	null,
	VendorZip 						PostalCode_t 	null,
	VendorCountryCode				REFNumber_t 	null,

	-- Corporation Columns
	CorporationId					Id_t		null,
	EIN								REFNumber_t	null,
	EINType							Code_t		null,
	EINTypeName						Name_t		null,
	
	-- Pended Work Columns
	PendedWorkID					Id_t		null, 	
	WorkGroupID						Id_t		null,    
	WorkGroupName					Name_t		null,
	WorkGroupAbbreviation			StringShort_t null,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
	AssignmentTypeCode				Code_t		null,
	AssignmentType					Description_t null,	
	DateAssigned					Date_t		null,
			
	-- Aging
	AgingRange						StringShort_t 	null,
	DaysAging						int 			null,
	AgingRange2						StringShort_t 	null,
	DaysAging2						int 		null,
	
	ColumnList						YesNo_T NULL,
	
	-- Referring Office Columns
	ReferringOfficeName				Name_t		null,
	ReferringOfficeNumber			REFNumber_t	null,
	ReferringOfficeNPI				REFNumber_t null,	
	ReferringOfficeAddress1			Address_t	null,
	ReferringOfficeAddress2			Address_t	null,
	ReferringOfficeCity				City_t	null,
	ReferringOfficeState			State_t	null,
	ReferringOfficeZip				PostalCode_t	null,
	ReferringOfficeZipSearch		PostalCode_t	null,
	ReferringOfficeRegion			Code_t			null,
	ReferringOfficeRegionName		Description_t	null,
	ReferringOfficeCounty			County_t	null,
	ReferringOfficeCountryCode		REFNumber_t 	null,

	--Member Provider Map (PCP) Columns
	MemberProviderMapId				Id_t			null,
	PCPContractId					Id_t			null,
	PCPContractName					Name_t			null,
	PCPProviderId					Id_t			null,
	PCPOfficeId						Id_t			null,
	PCPRiskGroupId					Id_t			null,
	PCPHospitalId					Id_t			null,
	PCPEffectiveDate				Date_t			null,
	PCPExpirationDate				Date_t			null,
	PCPPrecedence					Code_t			null,
	PCPPrecedenceName				Name_t			null,
	PCPLastName						Name_t			null,
	PCPFirstName					FirstName_t		null,
	PCPProviderNumber				REFNumber_t		null,
	PCPOfficeNumber					REFNumber_t		null,
	PCPOfficeName					Name_t			null,
	PCPOfficeAddress				Address_t		null,
	PCPOfficeAddress2				Address_t		null,
	PCPOfficeCity					City_t			null,
	PCPOfficeState					State_t			null,
	PCPOfficeZip					PostalCode_t	null,
	PCPRiskGroupName				Name_t			null,
	PCPRiskGroupNumber				REFNumber_t		null,
	PCPRiskGroupClass				Code_t			null,
	PCPRiskGroupSubclass			Code_t			null,
	PCPRiskGroupClassName			Description_t	null,
	PCPRiskGroupSubclassName		Description_t	null,
	PCPHospitalName					StringMedium_t	null,
	PCPHospitalNumber				RefNumber_t		null,
	PCPHospitalNPI					RefNumber_t		null,
			
	PCPProviderContractNumber		RefNumber_t		null
			
)



---*******************************************************************************************************************
--- Secondary ResultSet Declaration
---
--- Actual Tables: ClaimExplanationMap, ClaimActionCodeMap, ClaimCodes, ClaimMaterData Records
---
---*******************************************************************************************************************
Create table #ResultSet_Explanations
(
	RowId							Id_t			not null,
	ClaimId							Id_t			not null,	
	AdjustmentVersion				int				not null,	
	Line							int				null,		
	Parameter1						StringMedium_t	null,	
	Parameter2						StringMedium_t	null,	
	Parameter3						StringMedium_t	null,	
	Parameter4						StringMedium_t	null,	
	Parameter5						StringMedium_t	null,	
	DateProcessed					Date_t			null,	
	Queue							int				null,		
	Override						YesNo_t			null,	
	ExplanationID					Id_t			null,	
	Abbreviation					StringShort_t	null,  	
	ExplanationCode					StringShort_t	null,  	
	Explanation						StringLong_t	null,		
	SortKey							Real			null,		
	ExplanationPrecedence			real			null,		
	Severity 						Code_t		  	null,  		
	SeverityName 					Description_t  	null,  		
	DenialCategory					Code_t			null,
	DenialCategoryName				Description_t	null,
	DenialAction					Code_t			null,
	DenialActionName				Description_t	null,
	AdjActionCodeID					ID_t			null,
	AdjActionCode					Code_t			null,
	AdjActionCodeName				Description_t	null,
	AllowDenial						Code_t			null,
	AllowDenialName					Description_t	null,
	ExplanationCategoryId			Id_t			null,		
	ExplanationCategoryType			Code_t			null,		
	AllowUserExplanation			YesNo_t			null,		
	ExplanationCategoryTypeName		Description_t	null,		
	ExplanationCategoryName			Name_t			null,  				
	ExplanationCategoryPrecedence	real			null,
	ExplanationClass				Code_t			null,
	ExplanationClassName			Description_t   null,
	ExplanationSubClass				Code_t			null,
	ExplanationSubClassName			Description_t   null,		
	ProductName						StringShort_t	null,
	ExplanationEntityId				Id_T			Null,
	EntityTypeId						Id_T		Null,
	EntityId							Id_t		Null,
	Entity							Description_t	null,
	LastUpdatedAt					date_t			null,		
	LastUpdatedBy					Id_t			not null,	
	LastUpdatedByName				Name_t			null,
	InputBatchId					Id_t			null,
	MappedExplanationCategoryName	Name_t			null,
	AllowInformationLevel			YesNo_t			null
)

Create table #ResultSet_ActionCodes
(	
	ClaimActionCodeMapId	Id_t			not null,
	ActionCodeId			Id_t			not null,
	ActionCodeType			Code_t			not null,
	ActionCodeTypeName		Name_t			null,
	ActionCode				Code_t			not null,
	ActionCodeName			Name_t			null,
	Precedence				int				null,		
	AllowOverride			YesNo_t			not null,
	ClaimId					Id_t			not null,
	AdjustmentVersion		int 			not null,
	LineNumber 				int 			null,
	Overridden				Code_t			not null,
	OverrideReason			StringMedium_t	null, 
	ActionEntityMapId		Id_t			null,
	EffectiveDate			Date_t			null,
	ExpirationDate			Date_t			null,
	DateType				Code_t			null,
	DateTypeName			Description_t	null,
	EntityType				StringMedium_t	null,
	InitialVersionApplied	int				null,
	InitialDateApplied		Date_t			null,
	LastUpdatedBy			Id_t			not null,
	LastUpdatedByName		Name_t			null,
	LastUpdatedAt			Date_t	 		not null,
	OverridePermissionId	Id_t			null,
	ClaimHasActionCodes		YesNo_t 		null,
	ProductName				StringShort_t	not null,
	AddedFrom				Code_t			null,
	AddedFromName			Description_t	null,
	ActionCodeExplanationId	Id_t			null,
	Owner					varchar(8)		null
)

Create table #ResultSet_Institutional
(
	ClaimID					Id_t		not null,				
	AdjustmentVersion		int 		not null,	
	TypeOfBill				varchar(5)  null,
	StatementCoversFrom		Date_t		null,		
	StatementCoversTo		Date_t		null,		
	StatementCoversDays		real		null,
	RequestedDays			real		null,
	ApprovedDays			real		null,	
	AuthorizationID			ID_t		null,
	AuthorizationVersion	int			null,
	AuthorizationNumber		REFNumber_t null,
	AUthorizationLineNumber int			null,
	AdmissionDate			Date_t		null,
	AdmissionHour			varchar(6)	null,	
	TypeOfAdmission			varchar(1)	null,	
	SourceOfAdmission		varchar(1)	null,		
	DischargeHour			varchar(6)	null,		
	PatientStatus			varchar(2)	null,		
	AcceptAssignment		YesNo_t		null,		
	AssignmentBenefits		varchar(2)	null,	
	PriorPayments			Money_t		null,		
	EstAmountDue			Money_t		null,		
	ProcedureCodeType		varchar(1)	null,		
	ProviderSignature		varchar(1)	null,		
	TreatAuthCodes			varchar(18)	null,		
	EmploymentStatusCode	varchar(1)	null,
	OtherProviderId1		Id_t		null,		
	OtherPhysicianNumber1				REFNumber_t	null,	
	OtherPhysicianNumberQualifier1		Code_t	null,		
	OtherPhysicianName1					varchar(90)	null,
	OtherProviderId2		Id_t		null,	
	OtherPhysicianNumber2				REFNumber_t	null,	
	OtherPhysicianNumberQualifier2		Code_t	null,		
	OtherPhysicianName2					varchar(90)	null,
	AttendingProviderId		Id_t		null,	
	AttendingPhysicianNumber 			REFNumber_t	null,	
	AttendingPhysicianNumberQualifier	Code_t	null,	
	AttendingPhysicianName				varchar(90)	null,
	OperatingProviderId		Id_t		null,
	OperatingPhysicianNumber 			REFNumber_t	null,
	OperatingPhysicianNumberQualifier	Code_t	null,	
	OperatingPhysicianName				varchar(90)	null,
	
	MedicalRecordNumber	    varchar(20) null, 
	PrincipalProcedureCode	ProcedureCode_t NULL ,
	PrincipalProcedureDate	date_t			NULL ,
	PrincipalProcedureQual	Code_t			null,
	PrincipalDiagnosisCode	ProcedureCode_t NULL ,
	PrincipalDiagnosisQual	Code_t			null,
	PrincipalPOAIndicator	Code_t			null,
	AdmittingDiagnosisCode	ProcedureCode_t NULL ,
	AdmittingDiagnosisQual	Code_t			null,
	ECode					ProcedureCode_t NULL ,
	ECodeQual				Code_t			null,
	DRG						ProcedureCode_t NULL ,
	ConditionCode1			ProcedureCode_t NULL ,
	ConditionCode2			ProcedureCode_t NULL ,
	ConditionCode3			ProcedureCode_t NULL ,
	ConditionCode4			ProcedureCode_t NULL ,
	ConditionCode5			ProcedureCode_t NULL ,
	ConditionCode6			ProcedureCode_t NULL ,
	ConditionCode7			ProcedureCode_t NULL ,
	ConditionCode8			ProcedureCode_t NULL ,
	ConditionCode9			ProcedureCode_t NULL ,
	OccurrenceCode1			ProcedureCode_t NULL ,
	OccurrenceDateFrom1		date_t NULL ,
	OccurrenceDateTo1		date_t NULL ,
	OccurrenceCode2			ProcedureCode_t NULL ,
	OccurrenceDateFrom2		date_t NULL ,
	OccurrenceDateTo2		date_t NULL ,
	OccurrenceCode3			ProcedureCode_t NULL ,
	OccurrenceDateFrom3		date_t NULL ,
	OccurrenceDateTo3		date_t NULL ,
	OccurrenceCode4			ProcedureCode_t NULL ,
	OccurrenceDateFrom4		date_t NULL ,
	OccurrenceDateTo4		date_t NULL ,
	OccurrenceCode5			ProcedureCode_t NULL ,
	OccurrenceDateFrom5		date_t NULL ,
	OccurrenceDateTo5		date_t NULL ,
	OccurrenceCode6			ProcedureCode_t NULL ,
	OccurrenceDateFrom6		date_t NULL ,
	OccurrenceDateTo6		date_t NULL ,
	OccurrenceCode7			ProcedureCode_t NULL ,
	OccurrenceDateFrom7		date_t NULL ,
	OccurrenceDateTo7		date_t NULL ,
	OccurrenceCode8			ProcedureCode_t NULL ,
	OccurrenceDateFrom8		date_t NULL ,
	OccurrenceDateTo8		date_t NULL ,
	OccurrenceCode9			ProcedureCode_t NULL ,
	OccurrenceDateFrom9		date_t NULL ,
	OccurrenceDateTo9		date_t NULL ,
	ValueCode1				ProcedureCode_t NULL ,
	ValueAmount1			money_t NULL ,
	ValueCode2				ProcedureCode_t NULL ,
	ValueAmount2			money_t NULL ,
	ValueCode3				ProcedureCode_t NULL ,
	ValueAmount3			money_t NULL ,
	ValueCode4				ProcedureCode_t NULL ,
	ValueAmount4			money_t NULL ,
	ValueCode5				ProcedureCode_t NULL ,
	ValueAmount5			money_t NULL ,
	ValueCode6				ProcedureCode_t NULL ,
	ValueAmount6			money_t NULL ,
	ValueCode7				ProcedureCode_t NULL ,
	ValueAmount7			money_t NULL ,
	ValueCode8				ProcedureCode_t NULL ,
	ValueAmount8			money_t NULL ,
	ValueCode9				ProcedureCode_t NULL ,
	ValueAmount9			money_t NULL ,
	ValueCode10				ProcedureCode_t NULL ,
	ValueAmount10			money_t NULL ,
	ValueCode11				ProcedureCode_t NULL ,
	ValueAmount11			money_t NULL ,
	ValueCode12				ProcedureCode_t NULL ,
	ValueAmount12			money_t NULL ,
	DiagnosisCode1			ProcedureCode_t NULL ,
	DiagnosisCode2			ProcedureCode_t NULL ,
	DiagnosisCode3			ProcedureCode_t NULL ,
	DiagnosisCode4			ProcedureCode_t NULL ,
	DiagnosisCode5			ProcedureCode_t NULL ,
	DiagnosisCode6			ProcedureCode_t NULL ,
	DiagnosisCode7			ProcedureCode_t NULL ,
	DiagnosisCode8			ProcedureCode_t NULL ,
	DiagnosisCode9			ProcedureCode_t NULL ,
	DiagnosisCode10			ProcedureCode_t	null,
	DiagnosisCode11			ProcedureCode_t	null,
	DiagnosisCode12			ProcedureCode_t null,
	DiagnosisCode13			ProcedureCode_t	null,
	DiagnosisCode14			ProcedureCode_t	null,
	DiagnosisCode15			ProcedureCode_t	null,
	DiagnosisCode16			ProcedureCode_t	null,
	DiagnosisCode17			ProcedureCode_t	null,
	DiagnosisCode18			ProcedureCode_t	null,
	DiagnosisCode19			ProcedureCode_t	null,
	DiagnosisCode20			ProcedureCode_t	null,
	DiagnosisCode21			ProcedureCode_t	null,
	DiagnosisCode22			ProcedureCode_t	null,
	DiagnosisCode23			ProcedureCode_t	null,
	DiagnosisCode24			ProcedureCode_t	null,
	DiagnosisCodeQual1		Code_t		null,
	DiagnosisCodeQual2		Code_t		null,
	DiagnosisCodeQual3		Code_t		null,
	DiagnosisCodeQual4		Code_t		null,
	DiagnosisCodeQual5		Code_t		null,
	DiagnosisCodeQual6		Code_t		null,
	DiagnosisCodeQual7		Code_t		null,
	DiagnosisCodeQual8		Code_t		null,
	DiagnosisCodeQual9		Code_t		null,
	DiagnosisCodeQual10		Code_t		null,
	DiagnosisCodeQual11		Code_t		null,
	DiagnosisCodeQual12		Code_t		null,
	DiagnosisCodeQual13		Code_t		null,
	DiagnosisCodeQual14		Code_t		null,
	DiagnosisCodeQual15		Code_t		null,
	DiagnosisCodeQual16		Code_t		null,
	DiagnosisCodeQual17		Code_t		null,
	DiagnosisCodeQual18		Code_t		null,
	DiagnosisCodeQual19		Code_t		null,
	DiagnosisCodeQual20		Code_t		null,
	DiagnosisCodeQual21		Code_t		null,
	DiagnosisCodeQual22		Code_t		null,
	DiagnosisCodeQual23		Code_t		null,
	DiagnosisCodeQual24		Code_t		null,
	POAIndicator1			Code_t		null,
	POAIndicator2			Code_t		null,
	POAIndicator3			Code_t		null,
	POAIndicator4			Code_t		null,
	POAIndicator5			Code_t		null,
	POAIndicator6			Code_t		null,
	POAIndicator7			Code_t		null,
	POAIndicator8			Code_t		null,
	POAIndicator9			Code_t		null,
	POAIndicator10			Code_t		null,
	POAIndicator11			Code_t		null,
	POAIndicator12			Code_t		null,
	POAIndicator13			Code_t		null,
	POAIndicator14			Code_t		null,
	POAIndicator15			Code_t		null,
	POAIndicator16			Code_t		null,			
	POAIndicator17			Code_t		null,
	POAIndicator18			Code_t		null,
	POAIndicator19			Code_t		null,
	POAIndicator20			Code_t		null,
	POAIndicator21			Code_t		null,
	POAIndicator22			Code_t		null,
	POAIndicator23			Code_t		null,
	POAIndicator24			Code_t		null,						
	ProcedureCode1			ProcedureCode_t NULL ,
	ProcedureDate1			date_t NULL ,
	ProcedureCodeQual1		Code_t		null,
	ProcedureCode2			ProcedureCode_t NULL ,
	ProcedureDate2			date_t NULL ,
	ProcedureCodeQual2		Code_t		null,
	ProcedureCode3			ProcedureCode_t NULL ,
	ProcedureDate3			date_t NULL ,
	ProcedureCodeQual3		Code_t		null,
	ProcedureCode4			ProcedureCode_t NULL ,
	ProcedureDate4			date_t NULL ,
	ProcedureCodeQual4		Code_t		null,
	ProcedureCode5			ProcedureCode_t NULL ,
	ProcedureDate5			date_t NULL ,
	ProcedureCodeQual5		Code_t		null,
	ProcedureCode6			ProcedureCode_t NULL ,
	ProcedureDate6			date_t NULL ,
	ProcedureCodeQual6		Code_t		null,
	ProcedureCode7			ProcedureCode_t NULL ,
	ProcedureDate7			date_t NULL ,
	ProcedureCodeQual7		Code_t		null,
	ProcedureCode8			ProcedureCode_t NULL ,
	ProcedureDate8			date_t NULL ,
	ProcedureCodeQual8		Code_t		null,
	ProcedureCode9			ProcedureCode_t NULL ,
	ProcedureDate9			date_t NULL,
	ProcedureCodeQual9		Code_t		null,
	PatientReasonForVisit1			ProcedureCode_t	null,
	PatientReasonForVisit1Qual		Code_t		null,
	PatientReasonForVisit2			ProcedureCode_t	null,
	PatientReasonForVisit2Qual		Code_t		null,
	PatientReasonForVisit3			ProcedureCode_t	null,
	PatientReasonForVisit3Qual		Code_t		null,
)

Create table #ResultSet_Financials
(
	ClaimID				Id_t	not null,
	AdjustmentVersion	int		null,
	RecordID 			Id_t    not null,
	RecordStatus		Code_t  not null,
	RecordStatusName	Description_t null,
	RecordAmount		Money_T not null,
	RecordType 			Code_t  not null,
	RecordTypeName		Description_t null,
	EntityType			Code_t  null,
	EntityTypeName		Description_t null,
	CreationDate		Date_t	not null,
	ProcessedDate		Date_t  null,

	RecordDetailID		 ID_t		null,
	ItemType			 Code_t		null,
	ItemTypeName		 Description_t	null,
	ItemID				 ID_t		null,
	RecordDetailAmount	 Money_t	null,
		
	CheckDate			Date_t 	null,
	CheckAmount 		Money_T null,
	CheckNumber			RefNumber_T null,
	CheckRecordType		Code_t null,
	CheckRecordTypeName Description_t null,
	WriteOffReasonCode  Code_t null,
	WriteOffReason		Description_t null
)

Create Table #ResultSet_ClaimCodes
(
	ClaimID				Id_t	null,
	AdjustmentVersion	int		null,
	Sequence			int		null,
	CodeType			StringShort_t	null,
	Code				ProcedureCode_t null,
	CodeQualifier		Code_t	null,
	POAIndicator		Code_t  null,
	CodeDescription		StringLong_t  null,
	DateRecorded		Date_t	null,
	DateThrough			Date_t	null,
	Amount				Money_t null,
	FieldNumber			Code_t  null
)

Create Table #ResultSet_CustomAttributes
(
	ClaimID				Id_t	null
)

Create table #ResultSet_Parameters
(
	Usage							StringMedium_t null,
	DateUsage						StringMedium_t null,
	PeriodStart						Date_t null,
	PeriodEnd						Date_t null,
	BaseTime 						Date_t null,
	TimePeriod 						StringShort_t null,	
	
	FilterResultsetsBy				Code_t null,
	ExplanationAbbreviation			StringShort_t null, 
	ActionCode						Code_t null, 
	RecordType						Code_t null,  
	RecordTypeIn					StringMedium_t null,  
	RecordTypeNotIn					StringMedium_t null,
	RecordStatus					Code_t null,
	RecordStatusIn					StringMedium_t null,
	RecordStatusNotIn				StringMedium_t null,
	PreEstimateUsage				StringMedium_t null,
	
	-- Filters On Claims, Claim_Master Table
	ClaimMasterVersion				Code_t null, 
	FormType						Code_t null,
	FormSubtype						Code_t null,  
	ClaimType						Code_t null,
	ClaimStatus						Code_t null,
	ClaimStatusIn					StringMedium_t null,
	ClaimStatusNotIn				StringMedium_t null,
	ClaimProcessingStatus			Code_t null,
	ClaimProcessingStatusIn			StringMedium_t null,
	ClaimProcessingStatusNotIn		StringMedium_t null,
	ClaimNumber						ClaimNumber_t null,
	PaymentClass					Code_t null, 
	ClaimCategoryName				Name_t null,
	ClaimExplanationAbbreviation    StringShort_t null,	
	MinimumTotalCharges				Money_t null,	
	UpdatedByName					Name_t null,
	UpdatedByDepartment				Name_t null,	
	AssignmentOfBenefits		    Code_t null,	
	SourceType						varchar(8)    null,
	SourceTypeIn					StringMedium_t null,  
	SourceTypeNotIn					StringMedium_t null, 
	AdjustmentReasonCode			Code_t		  null,
	SuppressPayment					Code_t		  null,
	
	-- Filters On Claim_Details, Claim_Results Table
	ProcedureCode					ProcedureCode_t null,
	ProductCode						ProcedureCode_t null,
	PlaceOfService					Code_t		    null,
	MinimumLineCharges				Money_t		    null,
	ServiceCategoryName				Name_t		    null,
	FeeScheduleName					Name_t		    null,
	PlanName						Name_t		    null,	
	ContractName					Name_t		    null,
	AuthorizationNumber				REFNumber_t	    null,  
	OverrideUsed					Code_t			null,	 
	
	-- Filters On InputBatches Table
	SourceNumber					REFNumber_t null,
	ExternalBatchNumber				RefNumber_t null,
	InputBatchClass					varchar(64) null,
	InputBatchSubClass				varchar(64) null,
	
	-- Filters For Entities
	GroupNumber						REFNumber_t null,
	GroupNumberMask					StringMedium_t null,
	GroupLOB						Description_t null,
	GroupProductLine				Description_t null,
	GroupCoverage					Description_t null,
	GroupProductType				Description_t null,
	GroupRepricing					Code_t null,
	CompanyName						Name_t null,
	
	MemberNumber					REFNumber_t null,
	SubscriberNumber				REFNumber_t null,
	
	ProviderNumber					REFNumber_t null,
	ProviderSpecialtyCategoryName	Name_t null,
	ProviderSpecialtySubCategoryName	Name_t null,
	ProviderSpecialtyName			Name_t null,
	
	OfficeNumber					REFNumber_t null,
	OfficeZip						PostalCode_t null,
	OfficeRegion					Code_t null,
	OfficeCounty					County_t null,
	OfficeState						State_t null,
	OfficeCountryCode				REFNumber_t null,
	
	VendorNumber					REFNumber_t null,
	EIN								RefNumber_t null,
	
	-- Fl035772
	WorkGroupID						id_t null,
	
	CaseNumber						REFNumber_t null,

	LockReason						Code_t null,
	LockClass						Code_t null,
	LockSubClass					Code_t null,

	ReAdjudicationWizardJobNumber	RefNumber_t null,
	ReAdjudicationWizardJobClass		Code_t null,
	ReAdjudicationWizardJobSubClass	Code_t null,

	-- Secondary Resultset Parameters
	ReturnExplanations				Code_t null,
	ExplanationUsage				StringMedium_t null,
	ReturnActionCodes				Code_t null,
	ReturnInstitutionalClaimData	Code_t null,
	ReturnInstitutionalAuthInfo		Code_t null,
	ReturnFinancialInformation		Code_t null,
	ReturnClaimCodes				Code_t null,
	ReturnReportParameters			Code_t null,
	ReturnClaimMasterData			Code_t null,
	ReturnClaimReimbursementLog		Code_t null,
	ReturnDocumentRequests			Code_t null,
	ReturnPCPInformation			Code_t null,
	ReturnPendedWorkData			Code_t null,
	ReturnReinsuranceData			Code_t null,	
	ReturnOverridesFromTransform	Code_t null,
	ReturnPharmacyData				Code_t null,
	ReturnLockData					Code_t null,
	ReturnReAdjudicationWizardJobData YesNo_t null,

	-- Parameters for Update Statements
	ReturnClaimOverrides			Code_t null,
	ReturnClaimAdditionalInfo		Code_t null,
	ReturnPendingExplanation		Code_t null,
	ReturnHighestActionCode			Code_t null,
	ReturnPreEstimateReview			Code_t null, 
	ReturnDiagnosisCodes			Code_t null,
	ReturnGroupInfo					Code_t null,
	ReturnMemberInfo				Code_t null,
	ReturnProviderInfo				Code_t null,
	ReturnOfficeInfo				Code_t null,
	ReturnVendorInfo				Code_t null,
	ReturnCheckInfo					Code_t null,
	ReturnWorkGroupInfo				Code_t null,
	
	ReturnUserNames					Code_t null,
	ReturnReferenceCodesName		Code_t null,
	ReturnReferenceCodesNameLength  int null,
	
	CalculateAging					Code_t null,
	AgingDateUsage					Code_t null,
	Interval						int null, 
	CalculateAging2					Code_t null,
	AgingDateUsage2					Code_t null,
	Interval2						int null,
	
	XMLCustomAttributes				YesNo_t NULL,
	SelectedAttribute1				ID_t NULL,
	SelectedAttribute2				ID_t NULL,
	SelectedAttribute3				ID_t NULL,
	SelectedAttribute4				ID_t NULL,
	SelectedAttribute5				ID_t NULL,		
	SelectedAttribute6				ID_t NULL,
	SelectedAttribute7				ID_t NULL,
	SelectedAttribute8				ID_t NULL,
	SelectedAttribute9				ID_t NULL,
	SelectedAttribute10				ID_t NULL,	
	CustomAttributeAsOfDate			Date_t NULL
)

create table #ResultSet_ClaimMasterData
(
	ClaimID							Id_t			not null,
	AdjustmentVersion				Id_t			not null,
	PCPNumber						REFNumber_t		null,
	CarrierName						Name_t			null,
	CarrierAddress					Address_t		null,
	CarrierCity						City_t			null,
	CarrierState					State_t			null,
	CarrierZip						PostalCode_t	null,
	InsuredNumber					REFNumber_t		null,
	InsuredName1					Name_t			null,
	InsuredLastName					LastName_t		null,		
	InsuredFirstName				FirstName_t		null,
	InsuredMiddleName				MiddleName_t	null,
	InsuredAddress1					Address_t		null,
	InsuredAddress2					Address_t		null,
	InsuredCity1					City_t			null,
	InsuredCounty1 					County_t		null,
	InsuredState1					State_t			null,
	InsuredZip1						PostalCode_t	null,
	InsuredCountryCode1				REFNumber_t		null,
	InsuredZipCodeId1				Id_t			null,
	InsuredPhone1					Phone_t			null,
	InsuredGroupNumber1				REFNumber_t		null,
	InsuredBirthDate1				Date_t			null,
	InsuredEmployer1				Name_t			null,
	InsuredSex1						Gender_t		null,
	InsurancePlanName1				Name_t			null,
	SubscriberPolicyNumber			REFNumber_t		null,
	InsuredName2					Name_t			null,
	InsuredGroupNumber2				REFNumber_t		null,
	InsuredBirthDate2				Date_t			null,
	InsuredEmployer2				Name_t			null,
	InsuredEmplAddress2				Address_t		null,
	InsuredEmplStatus				Code_t			null,
	SubscriberEmployer				Name_t			null,
	SubscriberEmplAddress			Address_t		null,
	InsuredSex2						Gender_t		null,
	InsurancePlanName2				Name_t			null,
	MemberNumber					REFNumber_t		null,
	PatientName						Name_t			null,
	PatientLastName					LastName_t		null,
	PatientFirstName				FirstName_t		null,
	PatientMiddleName				MiddleName_t	null,
	PatientBirthDate				Date_t			null,
	PatientSex						Gender_t		null,
	PatientAddress					Address_t		null,
	PatientAddress2					Address_t		null,
	PatientCity						City_t			null,
	PatientCounty 					County_t		null,
	PatientState					State_t			null,
	PatientZip						PostalCode_t	null,
	PatientCountryCode				REFNumber_t		null,
	PatientZipCodeId				Id_t			null,
	PatientPhone					Phone_t			null,
	RelationshipCode				Code_t			null,
	PatientEmployerName				Name_t			null,
	PatientEmployerAddress			Address_t		null,
	PatientMaritalStatus			YesNo_t			null,
	PatientEmplStatus				Code_t			null,
	InjuryDescription				Description_t	null,
	AccidentDescription				Description_t	null,
	ProviderNPI						REFNumber_t		null,
	ProviderIDNumber				REFNumber_t		null,
	ProviderPhone					Phone_t			null,
	ProviderLastName				Name_t			null,
	ProviderFirstName				FirstName_t		null,
	ProviderMiddleName				MiddleName_t	null,
	ProviderSuffix					Suffix_t		null,
	ProviderAddress					Address_t		null,
	ProviderAddress2				Address_t		null,
	ProviderCity					City_t			null,
	ProviderCounty 					County_t		null,
	ProviderState					State_t			null,
	ProviderZip						PostalCode_t	null,
	ProviderCountryCode				REFNumber_t		null,
	ProviderZipCodeId				Id_t			null,
	TaxNumber						REFNumber_t		null,
	VendorName 						Name_t			null,
	VendorAddress1					Address_t		null,
	VendorAddress2 					Address_t		null,
	VendorCity 						City_t			null,
	VendorCounty 					County_t		null,
	VendorState 					State_t			null,
	VendorZip 						PostalCode_t 	null,
	VendorCountryCode				REFNumber_t		null,
	VendorZipCodeId					Id_t			null,
	FacilityName 					Name_t 			NULL,
	FacilityAddress1 				Address_t		null,
	FacilityAddress2 				Address_t		null,
	FacilityCity 					City_t			null,
	FacilityCounty 					County_t		null,
	FacilityState 					State_t			null,
	FacilityZip 					PostalCode_t	null,
	FacilityCountryCode				REFNumber_t		null,
	FacilityZipCodeId				Id_t			null,
	PayToAddress1 					Address_t		null,
	PayToAddress2 					Address_t		null,
	PayToCity 						City_t			null,
	PayToCounty 					County_t		null,
	PayToState 						State_t			null,
	PayToZip 						PostalCode_t	null,
	PayToCountryCode				REFNumber_t		null,
	PayToZipCodeId					Id_t			null,			
	ProviderLicense					REFNumber_t		null,
	PlaceOfTreatment				Code_t			null,
	ReasonForReplacement			Description_t	null,
	DateOfPriorPlacement			Date_t			null,
	TaxType							Code_t			null,
	MaxAllowable					Money_t			null,
	Deductible						Money_t			null,
	CarrierPercentage				Real_t			null,
	PatientPays						Money_t			null,
	ProviderInfo					StringMedium_t	null,
	FacilityInfo					StringMedium_t	null,
	PayToInfo						StringMedium_t	null,
	VendorInfo						StringMedium_t	null,
	CoveredDays						int				null,
	NonCoveredDays					int				null,
	CoInsuranceDays					int				null,
	LifeTimeReserveDays				int				null,
	InternalControlNumber			REFNumber_t		null,
	ReleaseInformation				YesNo_t			null,
	EmployerLocation				Address_t		null,
	SendTo							StringShort_t	null,
	AdditionalInfo					varchar(2000)	null,
	AdditionalPayerNumber			REFNumber_t		null,
	ProviderNumber					REFNumber_t		null,
	VendorNumber					REFNumber_t		null,
	PayerIdentification				StringMedium_t	null
)

create table #ResultSet_ClaimReimbursementLog
(
	LogID						ID_t not null,
	ClaimID						ID_t not null,
	AdjustmentVersion			int not null,
	LineNumber					int not null,
	ReimbursementID				ID_t not null,
	ReimbursementName			Name_t null,
	ReimbursementEntityRowID	ID_t not null,
	EntityTypeCode				Code_t null,
	EntityType					Description_t null,
	Precedence					real not null,
	ResultCode					Code_t not null,
	Result						Description_t null,
	ResultDescription			varchar(2000) null,
	ContractID					ID_t null,
	ContractName				Name_t null,
	RepricedFeeCode				Code_t null,
	RepricedFeeCodeName			Description_t null,
	RepricedRejectCode			Code_t null,
	RepricedRejectCodeName		Description_t null,
	AmtRepriced					Money_t null,	
	LineRepricedFeeCode			Code_t null,
	LineRepricedFeeCodeName		Description_t null,
	SuppliedUCR					Money_t null,
	RepricingOrganizationNumber	varchar(50) null,
	Reconsider						Code_t not null,
	LastUpdatedByID				ID_t not null,
	LastUpdatedBy				Name_t null,
	LastUpdatedAt				Date_t not null
)

create table #ResultSet_InputBatches
(
	InputBatchID                            int                 not null,
	LocationID                              Id_t                not null,
	InputBatchStatus                        Code_t              not null,
	InputBatchStatusName					Description_t		null,
	SourceType                              varchar(3)          not null,
	SourceTypeName							Description_t		null,
	SourceName                              Name_t              not null,
	SourceNumber                            varchar(16)         not null,
	DateReceived                            Date_t              not null,
	DateScanned                             Date_t              not null,
	DateInput                               Date_t              not null,
	ControlNumber                           REFNumber_t         not null,
	Class                                   varchar(64)         null,
	SubClass                                varchar(64)         null,
	ExternalBatchNumber                     StringShort_t       null,
	DocumentCount                           int                 null,
	AutotriageCount                         int                 null,
	DoneDirectory                           StringLong_t        not null,
	InputErrorMessage                       StringLong_t        null,
	FormType                                Code_t              null,
	FormTypeName							Description_t		null,
	FormSubtype                             Code_t              null,
	FormSubtypeName							Description_t		null,
	Priority                                real                null,
	OwnerID                                 int                 null,
	LastUpdatedAt                           Date_t              not null,
	LastUpdatedByID                         Id_t				not null,
	LastUpdatedBy							Name_t				null,
	NoMemberIssue							int					null,
	NoProviderIssue							int					null,
	NoOthersIssue							int					null,
	TOTAL   								int					null,
	ADA2000     							int					null,
	HCFA1500    							int					null,
	UB92        							int					null,
	VerifiedADA2000     					int					null,
	VerifiedHCFA1500    					int					null,
	VerifiedUB92        					int					null,
	TotalVerified							int					null,
	EDIADA2000     							int					null,
	EDIHCFA1500    							int					null,
	EDIUB92        							int					null,
	TotalEDI								int					null,
)


create table #ResultSet_DocumentRequests
(
	DocumentRequestId				  Id_t				null,
	RequestNumber					  REFNumber_t		null,
	DocumentType					  Code_t			null,
	DocumentTypeName				  Description_t		null,
	EntityType						  Code_t			null,
	EntityTypeName					  Description_t		null,	
	ClaimId							  Id_t				null,
	AdjustmentVersion				  int				null,	
	RecordId						  Id_t				null,
	PostingRecordId					  Id_t				null,
	JobId							  Id_t				null,
	JobDetailId						  Id_t				null,
	Notes							  StringMedium_t	null,	
	Status							  Code_t			null,
	StatusName						  Description_t		null,
	RequestedAt						  Date_t			null,
	RequestedByID					  Id_t				null,
	RequestedBy						  Name_t			null,
	FulfilledAt						  Date_t			null,
	FulfilledByID					  Id_t				null,
	FulfilledBy						  Name_t			null,
	SuppressionReason				  Code_t			null,	
	SuppressionReasonName			  Description_t		null,
	OriginalFulfillmentMethod		  Code_t			null,
	OriginalFulfillmentMethodName	  Description_t		null,
	FulfillmentMethod				  Code_t			null,
	FulfillmentMethodName			  Description_t		null,
	Email							  Email_t			null,
	Fax								  Phone_t			null,
	FulfillmentID					  StringMedium_t	null,
	FulfillmentStatus				  Code_t			null,
	FulfillmentStatusName			  Description_t		null,
	Retries							  int				null,
	TotalNumberOfPages				  int				null,
	AttemptedFulfillmentDate		  Date_t			null,
	FulfillmentNotes				  varchar(1000)		null,
	ClaimRedirectAddressId			  Id_t				null,
	ClaimRedirectAddressName		  Name_t			null,
	RiskGroupId						  Id_t				null,
	RiskGroupName					  Name_t			null,
	LastUpdatedAt					  Date_t			null,
	LastUpdatedByID					  ID_t				null,
	LastUpdatedBy					  Name_t			null
)

create table #ResultSet_PCPInformation    
(
	MemberProviderMapId		Id_t			null,
	MemberId				Id_t			null,
	SubscriberContractId    Id_t			null,
	ContractId				Id_t			null,
	ContractName			Name_t			null,
	ProviderId				Id_t			null,
	OfficeId				Id_t			null,
	RiskGroupId				Id_t			null,
	HospitalId				Id_t			null,
	EffectiveDate			Date_t			null,
	ExpirationDate			Date_t			null,
	Precedence				Code_t			null,
	PrecedenceName			Name_t			null,
	LastName				Name_t			null,
	FirstName			    FirstName_t		null,
	ProviderNumber          REFNumber_t		null,
	OfficeNumber			REFNumber_t		null,
	OfficeName				Name_t			null,
	OfficeAddress			Address_t		null,
	OfficeAddress2			Address_t		null,
	OfficeCity				City_t			null,
	OfficeState				State_t			null,
	OfficeZip				PostalCode_t	null,
	RiskGroupName			Name_t			null,
	RiskGroupNumber			REFNumber_t		null,
	RiskGroupClass			Code_t			null,
	RiskGroupSubclass		Code_t			null,
	RiskGroupClassName		Description_t	null,
	RiskGroupSubclassName	Description_t	null,
	HospitalName			StringMedium_t	null,
	HospitalNumber			RefNumber_t		null,
	HospitalNPI				RefNumber_t		null,
	ProviderContractNumber	RefNumber_t		null
)

create table #ResultSet_PendedWorkData   
(
	EntityId				Id_t			null,
	WorkGroupId				Id_t			null,
	WorkGroupName			Name_t			null,
	AssignmentTypeCode		Code_t			null,
	AssignmentType			Description_t	null,	
	OriginalDateAssigned	Date_t			null,
	DateAssigned			Date_t			null,
	AssignedToID			Id_t			null,
	AssignedToUser			Name_t			null,
	AssignmentReasonCode	Code_t			null,
	AssignmentReasonName	Description_t	null,
	AssignmentReasonNotes	StringMedium_t	null,
	DateToWork				Date_t			null,
	DateDue					Date_t			null,
	PreviousWorkGroupID		Id_t			null,
	PreviousWorkGroupName	Name_t			null,
	FirstTimeAddedToWorkGroup	Code_t		null,
	WorkGroupAbbreviation   StringShort_t	null,
	LockEdited			    YesNo_t			null,
	LastUpdatedBy			Name_t			null,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
	LastUpdatedAt           Date_t		not null,
	History					YesNo_t		not null --this column indicates whether data is from history table or current table
)

create table #ResultSet_ReinsuranceData 
(
	ReinsuranceUtilizationId			Id_t,
	ReinsurancePolicyId					Id_t,
	ReinsurancePolicyNumber				REFNumber_t,
	ReinsurancePolicyName				Name_t,
	ClaimId								Id_t					null,
	AdjustmentVersion					int						null,
	CheckId								Id_t					null,
	PostingRecordId						Id_t,
	PostingRecordAmount					Money_t					not null, 
	AmtApplied							Money_t					not null,
	AmtAggregate						Money_t					not null,
	AmtExcluded							Money_t					not null,
	AmtAggregateExcluded				Money_t					not null,
	FundingAmount						Money_t					null,
	UtilizationType						Code_t					not null,
	UtilizationTypeName					Description_t			not null,
	UtilizationStatus					Code_t					not null,
	UtilizationStatusName				Description_t			null,
	FundingType							Code_t					null,
	FundingTypeName						Description_t			null,
	FundingStatus						Code_t					null,
	FundingStatusName					Description_t			null,
	PaidDate							Date_t					null,
	ProcessedDate						Date_t					null,
	LastUpdatedAt						Date_t,
	LastUpdatedById						Id_t,
	LastUpdatedBy						Name_t,
	ReinsurancePolicyMemberMapId		Id_t					null,
		
	-- this flag indicates whether or not the utilization was manually updated- that is,
	-- if there is a history row for it
	ManuallyUpdated						Code_t					not null default 'N',

	OverrideDeductibleAction			Code_t					null,
	Notes								StringLong_t			null,
	
	FulfillmentType						Code_t					null,
	FulfillmentTypeName					Description_t			null,
	JobNumber							REFNumber_t				null,
	JobStatus							Code_t					null,
	JobStatusName						Description_t			null
)

create table #ResultSet_OverridesFromTransform
(
ClaimId									Id_t		null,
AdjustmentVersion						int			null,
LineNumber								int			null,
ServiceCategoryId						Id_t		null,
OverrideServiceRestriction				YesNo_t		null,
OverrideLateFiling						YesNo_t		null,
OverrideDuplicateChecking				YesNo_t		null,
OverridePreEstimateNeeded				YesNo_t		null,
DeductibleAmt							Money_t		null,
CoinsuranceAmt							Money_t		null,
CoPaymentAmt							Money_t		null,
OtherPatientAmt							Money_t		null,
DenyClaim								YesNo_t		null,
ExplanationId							Id_t		null,
ServiceDateReplacedWith					Date_t		null,
LastUpdatedBy							Id_t		null,
LastUpdatedAt							Date_t		null,
OverrideReferralNeeded					YesNo_t		null,
OverrideDenialOfRelatedProcedures		YesNo_t		null,					
OverridePreExisting						YesNo_t		null,
OverrideAuthorizationNeeded				YesNo_t		null,
OverridePrimaryCareRestriction			YesNo_t		null,
OverrideGlobalFee						Code_t		null,
OverridePaymentClassWith				Code_t		null,
OverrideSuppressPaymentWith				Code_t		null,
OverrideClaimEditing					YesNo_t		null,
OverrideClaimPricing					YesNo_t		null,
OverrideDenialAction					Code_t		null,
OverrideMedicalCaseReview				YesNo_t		null,
ExplanationId2							Id_t		null,
ExplanationId3							Id_t		null,
OverrideContractId						Id_t		null,
OverrideLiabilityLevelId				Id_t		null,
OverrideBenefitCategoryId				Id_t		null,
OverrideAllowedAmount					Money_t		null,
OverrideAmtToPay						Money_t		null,
OverrideAmtToPayMember					Money_t		null,
OverrideAmtCoPay						Money_t		null,
OverrideAmtCoInsurance					Money_t		null,
OverrideAmtDeductible					Money_t		null,
OverrideAmtPatientLiability				Money_t		null,
OverrideAmtOutOfPocket					Money_t		null,
OverrideMaxVisits						real		null,
OverrideMaxUnits						real		null,
OverrideMaxDollars						Money_t		null,
OverrideLiabilityPackageIdHistory		Id_t		null,
OverrideAmtToPenalizeMember				Money_t		null,
OverrideAmtToPenalizeProvider			Money_t		null,
OverrideStepDownLiabilityStepNumber		int			null,
OverrideAmtMoneyLimitApplied			Money_t		null,
OverrideEpisodeAuthorizationId			Id_t		null,
OverrideAmtPreExistingApplied			Money_t		null,
OverrideAllowedUnits					real		null,
OverrideCOBProcessing					YesNo_t		null,
OverrideDelegatedRule					YesNo_t		null,
OverrideSalesTaxRate					decimal(30,10) null,
OverrideSalesTaxAmount					Money_t		null,
OverrideGender							Gender_t	null,
OverrideDOB								Date_t		null,
OverrideRelationshipCode				Code_t		null, 
OverrideWithholdPercentage				Money_t		null, 
OverrideWithholdAmount					Money_t		null,
PreAdjudicationTransform				YesNo_t		null,
PostAdjudicationTransform				YesNo_t		null,
Disabled								YesNo_t		null
)

Create table #ResultSet_Pharmacy
(
	ClaimID								  Id_t                not null,
	AdjustmentVersion					  int                 not null,
	LineNumber							  int                 not null,
	PrescriberID						  Id_t				  null,
	PrescriberNumber					  REFNumber_t         null,
	PrescriberNumberQualifier			  Code_t			  null,
	PharmacistID						  Id_t				  null,
	PharmacistNumber					  REFNumber_t         null,
	PharmacistNumberQualifier			  Code_t			  null,
	PrescriptionNumber					  REFNumber_t         null,
	PrescriptionNumberQualifier			  Code_t			  null,
	RefillNumber						  int				  null,
	DateWritten							  Date_t			  null,
	SubmissionClarificationCode			  Code_t			  null,
	PrescriptionOrigin					  Code_t			  null,
	PharmacyServiceType					  Code_t			  null,
	SpecPackIndicator					  Code_t			  null,
	DaysSupply							  int				  null,
	DispenseAsWritten					  Code_t			  null,
	ReasonForServiceCode				  Code_t			  null,
	ProfessionalServiceCode				  Code_t			  null,
	ResultOfServiceCode					  Code_t			  null,
	LevelOfEffortCode					  Code_t			  null,
	DosageFormCode						  Code_t			  null,
	DispensingUnit						  Code_t			  null,
	RouteOfAdministrationCode			  Code_t			  null,
	IngredientComponentCount			  int				  null,
	CompoundCode						  Code_t			  null,
	UsualAndCustomaryCharge				  Money_t			  null,
	BasisOfCost							  Code_t			  null,
	IngredientTotalCharges				  Money_t			  null,
	DispensingFeeSubmitted				  Money_t			  null,
	ProfessionalServiceFeeSubmitted		  Money_t			  null,
	IncentiveAmountSubmitted			  Money_t			  null,
	OtherAmountSubmitted				  Money_t			  null,
	ProcessForApprovedIngredients		  Code_t			  null
)

	create table #ResultSet_ClaimCOBData
		(
			ClaimID					id_t	not null,
			AdjustmentVersion		int     not null,  
			COBIndicator			Code_t	not null,
			RemittanceDate			Date_t  null,
			AmtBilled				Money_t	null,
			AmtAllowed				Money_t	null,
			AmtDeductible			Money_t	null,
			AmtCopay				Money_t	null,
			AmtCoinsurance			Money_t	null,
			AmtOtherPatientLiability Money_t null,
			AmtRemainingPatientLiability Money_t null,
			AmtPaid					Money_t	null,
			AmtSequestration		Money_t null,
			AmtContractAdjustment	Money_t	null,
			AmtDenied				Money_t null,
			AmtNonCovered			Money_t	null,
			PayerId					Id_t	null,
			PayerNumberQualifier	Code_t  NULL,
			PayerNumber				RefNumber_t NULL,
			PayerName				Name_t null,
			RelationshipToSubscriberCode Code_t null,
			RelationShipToSubscriber Description_t null,
			PayerGroupNumber		RefNumber_t	null,
			PayerEmpName			Name_t	null,
			InsuranceTypeCode		Code_t	null,
			ClaimFilingIndicatorCode Code_t	null,
			PolicyHolderFirstName	FirstName_t null,
			PolicyHolderLastName	LastName_t null,
			PolicyHolderMiddleName	MiddleName_t null,
			PayerMemberNumber		RefNumber_t null,
			PolicyHolderAddress1	Address_t null,
			PolicyHolderAddress2	Address_t null,
			PolicyHolderCity		City_t null,
			PolicyHolderState		State_t null,
			PolicyHolderZip			PostalCode_t null,
			PolicyHolderCountryCode	Code_t null,
			PolicyHolderCountry		Description_t null,
			PolicyHolderSSN			IDNumber_t null,
			PayerAddress1			Address_t null,
			PayerAddress2			Address_t null,
			PayerCity				City_t null,
			PayerState				State_t	null,
			PayerZip				PostalCode_t null,
			PayerCountryCode		Code_t null,
			PayerCountry			Description_t null
		)

	create table #ResultSet_ClaimCOBDataDetails
		(
			ClaimID					id_t	not null,
			AdjustmentVersion		int     not null,  
			LineNumber				int		not null,
			COBIndicator			Code_t	not null,
			RemittanceDate			Date_t  null,
			AmtBilled				Money_t	null,
			AmtAllowed				Money_t	null,
			AmtDeductible			Money_t	null,
			AmtCopay				Money_t	null,
			AmtCoinsurance			Money_t	null,
			AmtOtherPatientLiability Money_t null,
			AmtRemainingPatientLiability Money_t null,
			AmtPaid					Money_t	null,
			AmtSequestration		Money_t null,
			AmtContractAdjustment	Money_t	null,
			AmtDenied				Money_t null,
			AmtNonCovered			Money_t	null
		)

	Create table #ResultSet_ClaimCARCsRARCs
	(
		ClaimId							Id_t			not null,	
		AdjustmentVersion				int				not null,	
		LineNumber						int				null,	
		ExplanationCategoryName			Name_t			null, 	
		AdjustmentReasonOrRemark		StringShort_t	null, 
		Explanation						StringLong_t	null,	
		ExplanationCode					StringShort_t	null,  	 	
		GroupCode						StringMedium_t	null,	
		Amount							StringMedium_t	null
	)

	Create table #ResultSet_LongTermCareData
	(
		--LongTermCare_Master table fields
		LongTermCareId					Id_t			not null,
		DocumentId						Id_t			not null,
		ExternalClaimNumber				REFNumber_t		not null,
		InputBatchId					Id_t			not null,
		ProviderNumber					REFNumber_t		null,
		ZipCode							PostalCode_t	null,
		ProviderId						Id_t			null,
		OfficeId						Id_t			null,
		VendorId						Id_t			null,
		DateBilled						Date_t			null,
		Signed							YesNo_t			null,
		--LongTermCare_Details table fields
		LineNumber						Id_t			not null,
		Deleted							YesNo_t			not null,	
		ClaimId							Id_t			null,	
		MemberNumber					REFNumber_t		null,
		MemberId						Id_t			null,
		MemberCoverageId				Id_t			null,
		ExternalAuthorizationNumber		REFNumber_t		null,
		AuthorizationId					Id_t			null,
		MedicalRecordNumber				varchar(20)		null,
		AttendingPhysician				REFNumber_t		null,
		AttendingPhysicianId			Id_t			null,
		BillingLimitExceptions			Code_t			null,
		ServiceDateFrom					Date_t			null,
		ServiceDateTo					Date_t			null,
		ProcedureCode					ProcedureCode_t	null,
		PrimaryDiagnosisCode			ProcedureCode_t	null,
		PatientStatus					Code_t			null,
		GrossAmount						Money_t			null,
		PatientLiability_MedicareDeduct	Money_t			null,
		MedicareType					Code_t			null,
		OtherCoverage					Money_t			null,
		NetAmountBilled					Money_t			null,
		Attachments						YesNo_t			null,
		CG								Code_t			null,
		PointOfEligibility				Code_t			null,
		WaiveBilling					Code_t			null,
		ProcessingStatus				Code_t			not null,
		LastUpdatedAt					Date_t			not null,
		LastUpdatedBy					Id_t			not null
	)

	create table #ResultSet_ScreeningVisitData
	(
		--ScreeningVisit_Master table fields
		ScreeningVisitId							Id_t				not null,	
		ScreeningFormName							Code_t				not null,
		DocumentId									Id_t				not null,
		ExternalClaimNumber							RefNumber_t			not null,
		InputBatchId								Id_t				not null,
		ProcessingStatus							Code_t				not null,
		ClaimId										Id_t				null,
		PatientLastName								LastName_t			null,
		PatientFirstName							FirstName_t			null,
		PatientMiddleName							MiddleName_t		null,
		PatientBirthDate							Date				null,
		PatientSex									Gender_t			null,
		Age											tinyint				null,
		PatientLocation								Code_t				null,
		MemberNumber								RefNumber_t			null,
		MemberId									Id_t				null,
		MemberCoverageId							Id_t				null,									
		NextCHDPExam								Date				null,
		ScreeningRecheck							YesNo_t             null,
		PriorScreeningDate							Date_t				null,                                                     
		ResponsiblePartyLastName					LastName_t			null,
		ResponsiblePartyFirstName					FirstName_t			null,
		ResponsiblePartyAddress1					Address_t			null,
		ResponsiblePartyAddress2					Address_t			null,
		ResponsiblePartyCity						City_t				null,
		ResponsiblePartyState						Code_t				null,
		ResponsiblePartyZip							Zip_t				null,
		EthnicityCode								Code_t				null,
		DateOfService								Date_t				null,
		HeightInInches								decimal(38,2)		null,
		WeightLbs									smallint			null,
		WeightOzs									tinyint				null,
		BMIPercent									tinyint				null,
		BloodPressureSystolic						smallint			null,
		BloodPressureDiastolic						smallint			null,
		Hemoglobin									decimal(38,1)		null,
		Hematocrit									tinyint				null,
		BirthWeightLbs								tinyint				null,
		BirthWeightOzs								tinyint				null,
		PatientVisit								code_t				null,
		TypeOfScreen								code_t				null,
		TotalCharges								Money_t				null,
		ProviderNumber								RefNumber_t			null,
		EIN											RefNumber_t			null,
		ZipCode										PostalCode_t		null,
		ProviderId									Id_t				null,
		OfficeId									Id_t				null,
		VendorId									Id_t				null,
		PlaceOfService								Code_t				null,
		ReferredToLastName1							LastName_t			null,
		ReferredToFirstName1						FirstName_t         null,                                        
		ReferredToPhone1							Phone_t				null,
		ReferredToLastName2							LastName_t			null,
		ReferredToFirstName2						FirstName_t			null,
		ReferredToPhone2							Phone_t				null,
		Comments									varchar(3000)		null,
		BloodLeadReferral							YesNo_t				null,
		DentalReferral								YesNo_t				null,
		FosterChild									YesNo_t				null,
		DiagnosisCode1								HealthCareCode_t	null,
		DiagnosisCode2								HealthCareCode_t	null,
		DiagnosisCode3								HealthCareCode_t	null,
		DiagnosisCode4								HealthCareCode_t	null,
		DiagnosisCode5								HealthCareCode_t	null,
		DiagnosisCode6								HealthCareCode_t	null,
		ExposedToTobacco							YesNo_t				null,
		UsesTobacco									YesNo_t				null,
		CounseledAboutTobacco						YesNo_t				null,
		EnrolledInWIC								YesNo_t				null,
		ReferredToWIC								YesNo_t				null,
		PartialScreen								YesNo_t				null,
		CoveredByMediCal							YesNo_t				null,
		CoveredByCHDPOnly							YesNo_t				null,
		DateBilled									Date				null,
		Signed										YesNo_t				null,
		NumberOfPages								StringMedium_t		null,
		MedicalRecordNumber							varchar(20)			null,
		LastUpdatedAt								Date_t				not null,
		LastUpdatedBy								Id_t				not null,
		OverriddenFlag								YesNo_t				null,
		OverriddenBy								Id_t				null,
		OverriddenByName							Name_t				null,
		OverriddenAt								Date_t				null,
		--ScreeningVisit_Details table fields
		DetailType									Code_t				null,
		Code										Code_t				null,
		Description									StringMedium_t		null,
		ProblemStatus								Code_t				null,
		FollowUpCode1								Code_t				null,
		FollowUpCode1b								Code_t				null,
		FollowUpCode2								Code_t				null,
		FollowUpCode2b								Code_t				null,
		VaccineStatus								Code_t				null,
		Amount										Money_t				null
	)

	create table #ResultSet_Medi_CalPharmacyData
	(
		--PharmacyEntry_Master table fields
		PharmacyEntryId			Id_t				not null,
		DocumentId				Id_t				not null,
		ExternalClaimNumber		RefNumber_t			not null,
		InputBatchId			Id_t				not null,
		ProcessingStatus		Code_t				not null,
		ClaimId					Id_t				null,
		ProviderNumber			RefNumber_t			null,
		ZipCode					PostalCode_t		null,
		ProviderId				Id_t				null,
		OfficeId				Id_t				null,
		VendorId				Id_t				null,
		MemberNumber			RefNumber_t			null,
		MemberId				Id_t				null,
		MemberCoverageId		Id_t				null,
		MedicareStatus			Code_t				null,
		PlaceOfService			Code_t				null,
		MedicalRecordNumber		varchar(20)			null,
		BillingLimitExceptions	Code_t				null,
		Attachments				YesNo_t				null,
		DateBilled				Date_t				null,
		DischargeDate			Date_t				null,
		TotalAmount				Money_t				null,
		ShareOfCost				Money_t				null,
		CG						Code_t				null,
		PointOfEligibility		Code_t				null,
		WaiveBilling			Code_t				null,
		Signed					YesNo_t				null,
		LastUpdatedAt			Date_t				not null,
		LastUpdatedBy			Id_t				not null,
		--PharmacyEntry_Details table fields
		LineNumber					int					null,
		PrescriptionNumber			REFNumber_t			null,
		ServiceDateFrom				Date_t				null,
		ProductQuantity				real				null,
		Code1Met					Code_t				null,
		DaysSupply					int					null,
		BasisOfCost					Code_t				null,
		ProductCodeQualifier		Code_t				null,
		ProductCode					ProcedureCode_t		null,
		PrescriberNumberQualifier	Code_t				null,
		PrescriberNumber			RefNumber_t			null,
		DiagnosisCode1				ProcedureCode_t		null,
		DiagnosisCode2				ProcedureCode_t		null,
		BilledAmount				money_t				null,
		COB							money_t				null,
		OtherCoverageCode			Code_t				null,	
		AuthorizationNumber			RefNumber_t			null,
		AuthorizationId				Id_t				null,
		CompoundCode				Code_t				null
	)

	create table #ResultSet_LockData
	(
		LockId														Id_t				not null,
		EntityId													Id_t				not null,
		EntityNumber												ClaimNumber_t		null,
		EntityType													Code_t				not null,
		EntityTypeName												Description_t		null,
		LockNumber													REFNumber_t			not null,
		Description													StringMedium_t		null,
		Reason														Code_t				not null,
		ReasonName													Description_t		null,
		ExternalNumber												StringMedium_t		null,	
		Class														Code_t				null,
		ClassName													Description_t		null,
		SubClass													Code_t				null,
		SubClassName												Description_t		null,
		EffectiveDate												Date_t				not null,
		ExpirationDate												Date_t				not null,
		AddedBy														Id_t				not null,
		AddedByName													Name_t				null,
		AddedAt														Date_t				not null,
		LastUpdatedBy												Id_t				not null,
		LastUpdatedByName											Name_t				null,
		LastUpdatedAt												Date_t				not null
	)

	create table #ResultSet_ReAdjudicationWizardJobs (
		JobId					Id_t
		, JobNumber				RefNumber_t
		, JobName				Name_t
		, JobDescription		StringMedium_t		null
		, JobType				Code_t
		, JobTypeName			Description_t		null
		, JobStep				Code_t
		, JobStepName			Description_t		null
		, ProcessingStatus		Code_t
		, ProcessingStatusName	Description_t		null
		, CreatedAt				Date_t
		, CreatedBy				Id_t
		, CreatedByName			Name_t
		, CompletedAt			Date_t				null		
		, Class					Code_t				null
		, ClassName				Description_t		null
		, SubClass				Code_t				null
		, SubClassName			Description_t		null
		, LastUpdatedBy			Id_t	
		, LastUpdatedByName		Name_t
		, LastUpdatedAt			Date_t

		-- Details
		, ClaimId				Id_t
		, LineNumber			int					null
		, AdjustmentVersion		int					
		, DetailStatus			Code_t				
		, DetailStatusName		Description_t		
		, ProcessedAt			Date_t				null
	)

---*******************************************************************************************************************
--- Temp table Declaration
---
---
---*******************************************************************************************************************

create table #MemberCoverages(MemberCoverageID Id_t)
	
create table #Providers(ProviderID	 Id_t)
	
create table #Offices(OfficeID Id_t,Distance real)

create table #Vendors(VendorId	Id_t)

create table #Groups(GroupID  ID_t)

create table #ReportDistinctClaimIds(ClaimID ID_t)
		
create table #ClaimStatusInclusion(ClaimStatus Code_t)
create table #ClaimStatusExclusion(ClaimStatus Code_t)

create table #ClaimProcessStatusInclusion(ClaimProcessStatus Code_t)		
create table #ClaimProcessStatusExclusion(ClaimProcessStatus Code_t)		

create table #RecordTypeInclusion(RecordType Code_t)		
create table #RecordTypeExclusion(RecordType Code_t)	

create table #RecordStatusInclusion(RecordStatus Code_t)		
create table #RecordStatusExclusion(RecordStatus Code_t)	

create table #SourceTypeInclusion(SourceType Code_t)		
create table #SourceTypeExclusion(SourceType Code_t)	

create table #UpdatedByUsers(UserID Id_t)	

create table #ExplanationFilter(ExplanationId Id_t)

/*added for incremental*/
create table #IncrementalClaimIds(ClaimId ID_t)

/*added for performance*/
create table #ReferenceCodes(Code Code_t, Name Description_t, Description varchar(2000),Type StringShort_t, Subtype StringShort_t)

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 2 - ' + convert(varchar,GETDATE(),121) 
		end

---*******************************************************************************************************************
--- Build Dynamic SQL that Selects the columns from the main resultset at the end of the procedure
---*******************************************************************************************************************
if 'CST' = (select ReportType from UserReports where UserReportID = @UserReportID)
	begin
		-- if ReportType is 'Custom' (CST), then use ii_BuildReportingDynamicSQL_V2, which
		-- uses the user-defined SQLString value from UserReports for @sql.
		exec @internal = ii_BuildReportingDynamicSQL_V2
							@UserReportID = @UserReportID,
							@TableUsage = @TableUsage,
							@ResultTableName = @ResultTableName,
							@ReportSQL = @SQLMain out,
							@ErrorMsg = @LogMsg out

		select @error = @@error
		if @error != 0
			begin
				select @UserMsg = 'The Dynamic SQL Build failed',
					   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed'
				raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
				goto AppErrorExit
			end -- if @error != 0
		else if @internal != 0
			begin
				select @UserMsg = 'The Dynamic SQL Build encountered an error',
					   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error: ' + @LogMsg
				raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
				goto AppErrorExit
			end -- else if @internal != 0
			
	end -- if 'CST' = (select ReportType...
else
	begin

		-- if ReportType is 'Standard' (STD) or NULL, then use ii_BuildReportingDynamicSQL_ARCHDEV, which
		-- builds a value for @sql based upon @ColumnList and the custom attributes
		exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
							@ResultSetName = '#ResultSet',
							@ColumnList = @ColumnList,
							@TableUsage = @TableUsage,
							@ResultTableName = @ResultTableName,
							@ReportSQL = @SQLMain out,
							@ErrorMsg = @LogMsg out
		
		select @error = @@error
		if @error != 0
			begin
				select @ProcedureStep = 1,
					   @UserMsg = 'The Dynamic SQLMain Build failed',
					   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLMain'
				raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
				goto AppErrorExit
			end -- if @error != 0
		else if @internal != 0
			begin
				select @ProcedureStep = 1,
					   @UserMsg = 'The Dynamic SQLMain Build encountered an error',
					   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLMain: ' + @LogMsg
				raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
				goto AppErrorExit
			end -- else if @internal != 0
			
	end -- else (if 'CST' = (select ReportType...)	
	
--------------------------------------------------------------------
-- Now builds dynamic sql for secondary resultsets
--------------------------------------------------------------------	

select @SecondaryResultTableName = @ResultTableName + '_Explanations'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_Explanations',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLExplanations out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLExplanations Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLExplanations'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLExplanations Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLExplanations: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0
			
select @SecondaryResultTableName = @ResultTableName + '_ActionCodes'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ActionCodes',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLActionCodes out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLActionCodes Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLActionCodes'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLActionCodes Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLActionCodes: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

select @SecondaryResultTableName = @ResultTableName + '_Institutional'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_Institutional',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLInstitutional out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLInstitutional Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLInstitutional'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLInstitutional Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLInstitutional: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0
			
select @SecondaryResultTableName = @ResultTableName + '_Financials'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_Financials',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLFinancials out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLFinancials Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLFinancials'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLFinancials Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLFinancials: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0
	
select @SecondaryResultTableName = @ResultTableName + '_ClaimCodes'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ClaimCodes',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLClaimCodes out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCodes Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLClaimCodes'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCodes Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLClaimCodes: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

-- Here the SQL is created for Init usage and creating reporting system table
-- It will be updated later if the dataset is returning custom attributes
select @SecondaryResultTableName = @ResultTableName + '_CustomAttributes'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_CustomAttributes',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLCustomAttributes out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLCustomAttributes Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLCustomAttributes'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLCustomAttributes Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLCustomAttributes: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0
				
select @SecondaryResultTableName = @ResultTableName + '_Parameters'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_Parameters',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLParameters out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLParameters'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLParameters: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0
	
select @SecondaryResultTableName = @ResultTableName + '_ClaimMasterData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ClaimMasterData',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLClaimMasterData out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLClaimMasterData'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLClaimMasterData: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0
	
select @SecondaryResultTableName = @ResultTableName + '_ClaimReimbursementLog'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ClaimReimbursementLog',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLClaimReimbursementLog out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLClaimReimbursementLog'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLClaimReimbursementLog: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0	


select @SecondaryResultTableName = @ResultTableName + '_InputBatches'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_InputBatches',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLInputBatches out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLInputBatches'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLInputBatches: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0	

select @SecondaryResultTableName = @ResultTableName + '_DocumentRequests'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_DocumentRequests',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLDocumentRequests out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLDocumentRequests'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLDocumentRequests: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0	

select @SecondaryResultTableName = @ResultTableName + '_PCPInformation'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_PCPInformation',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLPCPInformation out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLPCPInformation'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLPCPInformation: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0	

select @SecondaryResultTableName = @ResultTableName + '_PendedWorkData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_PendedWorkData',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLPendedWorkData out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLPendedWorkData'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLPendedWorkData: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0	

select @SecondaryResultTableName = @ResultTableName + '_ReinsuranceData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ReinsuranceData',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLReinsuranceData out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLReinsuranceData'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLReinsuranceData: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0	

select @SecondaryResultTableName = @ResultTableName + '_OverridesFromTransform'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_OverridesFromTransform',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLOverridesFromTransform out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLOverridesFromTransform'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLOverridesFromTransform: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0	
	

select @SecondaryResultTableName = @ResultTableName + '_Pharmacy'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_Pharmacy',
					@ColumnList = null,
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLPharmacy out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLPharmacy Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLPharmacy'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLPharmacy Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLPharmacy: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0


select @SecondaryResultTableName = @ResultTableName + '_ClaimCOBData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ClaimCOBData',
					@ColumnList = null,
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLClaimCOBData out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCOBData Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLClaimCOBData'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCOBData Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLClaimCOBData: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0


select @SecondaryResultTableName = @ResultTableName + '_ClaimCOBDataDetails'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ClaimCOBDataDetails',
					@ColumnList = null,
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLClaimCOBDataDetails out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCOBDataDetails Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLClaimCOBDataDetails'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCOBDataDetails Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLClaimCOBDataDetails: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

select @SecondaryResultTableName = @ResultTableName + '_ClaimCARCsRARCs'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ClaimCARCsRARCs',
					@ColumnList = null,
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLClaimCARCsRARCs out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCARCsRARCs  Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLClaimCARCsRARCs '
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLClaimCARCsRARCs  Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLClaimCARCsRARCs : ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

select @SecondaryResultTableName = @ResultTableName + '_LongTermCareData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_LongTermCareData',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLLongTermCare out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLLongTermCareData Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLLongTermCareData'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLLongTermCareData Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLLongTermCareData: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

select @SecondaryResultTableName = @ResultTableName + '_ScreeningVisitData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_ScreeningVisitData',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLScreeningVisit out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLScreeningVisit Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLScreeningVisit'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLScreeningVisit Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLScreeningVisit: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

select @SecondaryResultTableName = @ResultTableName + '_Medi_CalPharmacyData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_Medi_CalPharmacyData',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLMedi_CalPharmacy out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLMedi_CalPharmacy Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLMedi_CalPharmacy'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLMedi_CalPharmacy Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLMedi_CalPharmacy: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

select @SecondaryResultTableName = @ResultTableName + '_LockData'   -- could be null, does not insert into permanent table when null

exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
					@ResultSetName = '#ResultSet_LockData',
					@ColumnList = null,		-- return all columns
					@TableUsage = @TableUsage,
					@ResultTableName = @SecondaryResultTableName,
					@ReportSQL = @SQLLockData out,
					@ErrorMsg = @LogMsg out

select @error = @@error
if @error != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build failed',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLLockData'
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- if @error != 0
else if @internal != 0
	begin
		select @ProcedureStep = 1,
			   @UserMsg = 'The Dynamic SQLParameters Build encountered an error',
			   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLLockData: ' + @LogMsg
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end -- else if @internal != 0

begin try
	select @SecondaryResultTableName = @ResultTableName + '_ReAdjudicationWizardJobs'

	exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
						@ResultSetName = '#ResultSet_ReAdjudicationWizardJobs'
						, @ColumnList = null		-- return all columns
						, @TableUsage = @TableUsage
						, @ResultTableName = @SecondaryResultTableName
						, @ReportSQL = @SqlReAdjudicationWizardJobs out
						, @ErrorMsg = @LogMsg out

	if @internal <> 0
	begin
		select @ProcedureStep = 1
				, @UserMsg = 'The Dynamic SqlReAdjudicationWizardJobs Build encountered an error'
				, @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SqlReAdjudicationWizardJobs: ' + isnull( @LogMsg, '' )
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto AppErrorExit
	end
end try
begin catch
	select @ProcedureStep = 1
			, @UserMsg = 'The Dynamic SqlReAdjudicationWizardJobs Build encountered an error'
			, @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SqlReAdjudicationWizardJobs: ' + isnull( @LogMsg, '' )
	raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
	goto AppErrorExit
end catch

	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select @SQLMain as '@SQLMain'
			select @SQLExplanations as '@SQLExplanations'
			select @SQLActionCodes as '@SQLActionCodes'
			select @SQLInstitutional as '@SQLInstitutional'
			select @SQLFinancials as '@SQLFinancials'
			select @SQLClaimCodes as '@SQLClaimCodes'
			select @SQLCustomAttributes as '@SQLCustomAttributes'
			select @SQLParameters as '@SQLParameters'
			select @SQLClaimMasterData as '@SQLClaimMasterData'
			select @SQLClaimReimbursementLog as '@SQLClaimReimbursementLog'
			select @SQLInputBatches as '@SQLInputBatches'
			select @SQLDocumentRequests as 'SQLDocumentRequests'
			select @SQLPCPInformation as 'SQLPCPInformation'
			select @SQLPendedWorkData as 'SQLPendedWorkData'
			select @SQLReinsuranceData as 'SQLReinsuranceData'			
			select @SQLOverridesFromTransform as 'SQLOverridesFromTransform'
			select @SQLPharmacy as '@SQLPharmacy'
			select @SQLLongTermCare as '@SQLLongTermCare'
			select @SQLScreeningVisit as '@SQLScreeningVisit'
			select @SQLMedi_CalPharmacy	as '@SQLMedi-CalPharmacy'
			select @SQLLockData as 'SQLLockData'
			select @SqlReAdjudicationWizardJobs as '@SqlReAdjudicationWizardJobs'
		end

If isnull(@SysOptEntityAttrValues,'') != '' 
	begin

		-- build sql to return entity attrbutes stamped on the claims in the 2nd RS
		exec @internal = ii_BuildReportingDynamicSQL_ClaimAttributes
			@ResultTableName = '#ReportDistinctClaimIds',
			@TableUsage = @TableUsage,
			@Debug		= @Debug,
			@ReportSQL = @SQLAttr out,
			@ErrorMsg = @UserMsg out

			select @error = @@error
			
			if @error != 0
				begin
					select @ProcedureStep = 1,
						   @UserMsg = 'The Dynamic SQL Build failed.[ClaimEntityAttributes]',
						   @LogMsg = 'ii_BuildReportingDynamicSQL_ClaimAttributes failed.'
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto AppErrorExit
				end -- if @error != 0
			else if @internal != 0
				begin
					select @ProcedureStep = 1
					select @LogMsg = 'ii_BuildReportingDynamicSQL_ClaimAttributes encountered an error: ' + isnull(@UserMsg,'')
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					if @internal = 1 goto BusinessErrorExit
					else if @internal = 2 goto ServerErrorExit
					else if @internal = 3 goto AppErrorExit
				end -- else if @internal != 0	
	end
				
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select @SQLAttr as '@SQLAttr'
		end
		
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 3 - ' + convert(varchar,GETDATE(),121) 
		end
		
---
--- If the usage text passed in reads '|init|' then pass back a blank resultset
---
  if charindex('|INIT|', @Usage) != 0
    begin
      goto NormalExit
    end	



---*******************************************************************************************************************
--- Build Dynamic SQL Insert and Select clause. 
---
---
---*******************************************************************************************************************

If @Usage in ('|LatestClaims|','|AllClaimVersions|','|LatestClaimLines|','|AllClaimLinesAndVersions|')
	begin 	
		-- Claims  
		select @InsertClause = @InsertClause + 'ClaimId,AdjustmentVersion,ClaimNumber,FormType,FormSubtype,ClaimType,ServiceDateFrom,ServiceDateTo,EntryDateTime,DateReceived'
							+ ',MemberId,MemberCoverageId,SubscriberContractId,SubscriberId,GroupId,ProviderId,OfficeId,VendorId,Status'
							+ ',InputBatchID,ClosedDate,DateESTPrinted,Date837Exported,DateEncounterExported'
							+ ',ProcessingStatus,ClosedVersion,InitialAdjudicationVersion,InitialAdjudicationDate,InitialReadyToCloseDate'
							+ ',AdjudicationActionCodes,PaymentActionCodes,CategoryI,CategoryII,CategoryIII,InitialClaimEditingVersion,ClaimExplanationId,ClaimCategoryCode'

		if @Usage in ('|LatestClaims|','|LatestClaimLines|')
			begin
				select @InsertClause = @InsertClause + ',DateEOBPrinted'
			end
			
		-- Claim_Master
		select @InsertClause = @InsertClause + ',ExternalClaimNumber,ExternalReferralNumber,ExternalAuthorizationNumber,AdjustmentReason,CaseID,ClaimStatus,PatientAccountNumber,TotalCharges'
							  + ',SourceType,AssignmentBenefits,SuppressPayment,BilledCurrency,PaymentClass'
							  + ',EOBAction,InterestOnAdjustments,AdjustmentReasonCode'
							  + ',OffWorkDateFrom,OffWorkDateTo,HospitalDateFrom,HospitalDateTo,OutsideLab,LabCharges,Remarks'
							  + ',AmountPaid,BalanceDue,ReferringProviderId,RefPhysicianName,RefPhysicianNumber,RefPhysicianNumberQualifier'
							  + ',RefPhysicianNumber2,RefPhysicianNumberQualifier2,EmploymentRelated,AutoAccident,EpisodeDate,PriorEpisodeDate'
							  + ',AutoAccidentState,CleanedDate,AdjustedClosedDate,MissingTeethInfo,Radiograph,RadiographCount,RadiographReferenceNumber'
							  + ',Orthodontics,OrthodonticsTotalMonths,DateAppliancePlaced,MonthsRemaining,Prosthesis,PriorPlacementDate'
							  + ',RepricedTotalAmount,RepricedFeeCode,RepricedRejectCode,AmtNegotiated,AmtMaximumAllowable'
							  + ',NegotiatedDiscountType,NegotiatedDiscountValue,NetDays,COBIndicatorCode,LastUpdatedBy,LastUpdatedAt,ReferringPreestimate'
							  + ',ProviderSpecialtyCategoryID,ProviderSpecialtySubCategoryID,EmergencyReferral,ReferringOfficeId,ReferringProviderName,ReferringProviderNumber,ReferringProviderNumberQualifier'
							  + ',ReferringProviderNumber2,ReferringProviderNumberQualifier2,DelayReason,ClaimSOC,GracePeriod,ReallocateClaimLevelAmounts,CreateFinancialRecord,CreateInformationalAdjustment,DateProcessed'
							
		-- InputBatches
		select @InsertClause = @InsertClause + ',LocationID,InputBatchStatus,SourceName,SourceNumber,DateScanned,DateInput,ControlNumber,ExternalBatchNumber, InputBatchClass, InputBatchSubClass'

		---------------------------------------------------------------------------------------------------------------------------------------------------
		---
		---------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- Claims  
		select @SelectClause = @SelectClause + 'C.ClaimId,CM.AdjustmentVersion,C.ClaimNumber,C.FormType,C.FormSubtype,C.ClaimType,C.ServiceDateFrom,C.ServiceDateTo,C.EntryDateTime,C.DateReceived'
							+ ',CM.MemberId,CM.MemberCoverageId,CM.SubscriberContractId,CM.SubscriberId,CM.GroupId,CM.ProviderId,CM.OfficeId,CM.VendorId,C.Status'
							+ ',C.InputBatchID,C.ClosedDate,C.DateESTPrinted,C.Date837Exported,C.DateEncounterExported'
							+ ',C.ProcessingStatus,C.ClosedVersion,C.InitialAdjudicationVersion,C.InitialAdjudicationDate,C.InitialReadyToCloseDate'
							+ ',C.AdjudicationActionCodes,C.PaymentActionCodes,C.CategoryI,C.CategoryII,C.CategoryIII,C.InitialClaimEditingVersion,C.ExplanationId,C.ClaimCategoryCode'
			
		if @Usage in ('|LatestClaims|','|LatestClaimLines|')
			begin
				select @SelectClause = @SelectClause + ',C.DateEOBPrinted'
			end

		-- Claim_Master
		select @SelectClause = @SelectClause + ',CM.ExternalClaimNumber,CM.ExternalReferralNumber,CM.AuthorizationNumber,CM.AdjustmentReason,CM.CaseID,CM.ClaimStatus,CM.PatientAccountNumber,CM.TotalCharges'
							  + ',CM.SourceType,CM.AssignmentBenefits,CM.SuppressPayment,CM.BilledCurrency,CM.PaymentClass'
							  + ',CM.EOBAction,CM.InterestOnAdjustments,CM.AdjustmentReasonCode'	
							  + ',CM.OffWorkDateFrom,CM.OffWorkDateTo,CM.HospitalDateFrom,CM.HospitalDateTo,CM.OutsideLab,CM.LabCharges,CM.Remarks'
							  + ',CM.AmountPaid,CM.BalanceDue,CM.ReferringProviderId,CM.RefPhysicianName,CM.RefPhysicianNumber,CM.RefPhysicianNumberQualifier'
							  + ',CM.RefPhysicianNumber2,CM.RefPhysicianNumberQualifier2,CM.EmploymentRelated,CM.AutoAccident,CM.EpisodeDate,CM.PriorEpisodeDate'
							  + ',CM.AutoAccidentState,CM.CleanedDate,CM.AdjustedClosedDate,CM.MissingTeethInfo,CM.Radiograph,CM.RadiographCount,CM.RadiographReferenceNumber'
							  + ',CM.Orthodontics,CM.OrthodonticsTotalMonths,CM.DateAppliancePlaced,CM.MonthsRemaining,CM.Prosthesis,CM.PriorPlacementDate'
							  + ',CM.RepricedTotalAmount,CM.RepricedFeeCode,CM.RepricedRejectCode,CM.AmtNegotiated,CM.AmtMaximumAllowable'
							  + ',CM.NegotiatedDiscountType,CM.NegotiatedDiscountValue,CM.NetDays,CM.COBIndicator,CM.LastUpdatedBy,CM.LastUpdatedAt,CM.ReferringPreestimate'	
							  + ',CM.ProviderSpecialtyCategoryID,CM.ProviderSpecialtySubCategoryID,CM.EmergencyReferral,CM.ReferringOfficeId,CM.RefPhysicianName,CM.RefPhysicianNumber,CM.RefPhysicianNumberQualifier'
							  + ',CM.RefPhysicianNumber2,CM.RefPhysicianNumberQualifier2,CM.DelayReason,CM.SOC,CM.GracePeriod,CM.ReallocateClaimLevelAmounts,CM.CreateFinancialRecord,CM.CreateInformationalAdjustment,CM.DateProcessed'
		-- InputBatches
		select @SelectClause = @SelectClause + ',I.LocationID,I.InputBatchStatus,I.SourceName,I.SourceNumber,I.DateScanned,I.DateInput,I.ControlNumber,I.ExternalBatchNumber, I.Class, I.SubClass'

	end
	
-- 
-- Append Claim Details Level Columns
--
If @Usage in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
	begin
					
		-- Claim_Details
		select @InsertClause = @InsertClause + ',LineNumber,PlaceOfService,TypeOfService,ProcedureCode,Modifier,Modifier2,Modifier3,Modifier4'
							  + ',AdjProcedureCode,AdjModifier,AdjPlaceOfService,DiagnosisPtrs,DiagnosisPtr1,DiagnosisPtr2,DiagnosisPtr3,DiagnosisPtr4,Amount,BilledCurrencyAmount,AmountMaximumAllowed,AmtRepriced,FeeCode,RepricingOrganizationNumber,UnitType'
							  + ',ServiceUnits,EPSDTPlan,EMG,PrimaryFeeAllowed,COB,SOC,ProductCodeQualifier,ProductCode,ProductQuantity,ProductUnitOfMeasure'
							  + ',Description,HCPCSRates,Tooth,Surface,Quadrant,AdjUnitType,AdjServiceUnits,ClaimEditingStatus,ClaimPricingService,SuppliedUCR'
							  + ',LineAuthorizationNumber,LineAuthorizationNumberType,OtherCoverageCode,LevelOfService,RestrictionsMetIndicator'
							  + ',LineServiceDateFrom,LineServiceDateTo'
																  


		-- Claim_Results
		select @InsertClause = @InsertClause + ',AllowedUnits,AmtCharged,AmtDeferred,AmtPatientLiability,AmtNotCovered,AmtCovered,AmtDisallowed,AmtOverContract,AmtFeeAllowed,AmtReduction'
							  + ',AmtDiscount,AmtWithhold,AmtEligible,AmtCopay,AmtCoinsurance,AmtDeductible,AmtCOB,AmtSOC,AmtStopLoss,AmtExceedMax,VisitsCovered,AmtPrevPaidProv'
							  + ',AmtToPay,AmtToPayMember,ClaimLineTotalPaid,ExplanationId,PlanId,AuthorizationId,ReferralId,ServiceCategoryId'
							  + ',LiabilityLevelId,LiabilityPackageId,ProviderContractId,ContractId,FeeScheduleId,FeeScheduleDetailId,ReimbursementId,BenefitCategoryId'
							  + ',ResultStatus,ResultDescription,AmtUCR,ContractFeeScheduleMapId,ExchangeRate,DenialAction,Negotiated'
							  + ',PreEstimateClaimID,PreEstimateLineNumber,ModifierReductionScheduleDetailId,AmtOutOfPocket,AuthorizationVersion,AuthServiceLineNumber,AuthServiceDetailLineNumber'
							  + ',AdjReviewExplanationID,AmtProviderPenalty,AmtMemberPenalty,AmtPrevPaidMember,StepDownLiabilityStepNumber,AmtMoneyLimitApplied,OverrideUsed,BenefitCoverageID'
							  + ',AmtEpisode,EpisodeAuthorizationId,SalesTaxRateId,SalesTaxAmount,RiskGroupDelegatedServiceID'

		  
		If @ReturnClaimOverrides = 'Y'
		  begin
			-- Claim_Overrides
			select @InsertClause = @InsertClause + ',OverrideServiceCategoryId,OverrideServiceRestriction,OverrideLateFiling,OverrideDuplicateChecking'
		  						 + ',OverridePreEstimateNeeded,OverrideDeductibleAmt,OverrideCoinsuranceAmt,OverrideCoPaymentAmt,OverrideOtherPatientAmt'
		  						 + ',OverrideDenyClaim,OverrideExplanationId,OverrideExplanationId2,OverrideExplanationId3,OverrideServiceDateReplacedWith'
		  						 + ',OverrideReferralNeeded,OverrideDenialOfRelatedProcedures,OverridePreExisting,OverrideAuthorizationNeeded'
		  						 + ',OverridePrimaryCareRestriction,OverrideCOBProcessing,OverrideDelegatedRule,OverrideGlobalFee,OverridePaymentClassWith,OverrideSuppressPaymentWith,OverrideClaimEditing,OverrideClaimPricing'
		  						 + ',OverrideDenialAction,OverrideMedicalCaseReview,OverrideContractId,OverrideLiabilityLevelId,OverrideBenefitCategoryId'
		  						 + ',OverrideAllowedAmount,OverrideAmtToPay,OverrideAmtToPayMember,OverrideAmtCoPay,OverrideAmtCoInsurance,OverrideAmtDeductible'
		  						 + ',OverrideAmtPatientLiability,OverrideAmtOutOfPocket,OverrideMaxVisits,OverrideMaxUnits,OverrideMaxDollars'
		  						 + ',OverrideLiabilityPackageIdHistory,OverrideAmtToPenalizeMember,OverrideAmtToPenalizeProvider,OverrideStepDownLiabilityStepNumber'
		  						 + ',OverrideAmtMoneyLimitApplied,OverrideAmtPreExistingApplied,OverrideEpisodeAuthorizationId,OverrideAllowedUnits'
								 + ',OverrideSalesTaxRate,OverrideSalesTaxAmount,OverrideFilingDate,OverrideFilingReductionAmount,OverrideGender,OverrideDOB,OverrideRelationshipCode'
								 + ',OverrideWithholdPercentage,OverrideWithholdAmount' 
		  end
	
		---------------------------------------------------------------------------------------------------------------------------------------------------
		---
		---------------------------------------------------------------------------------------------------------------------------------------------------

		-- Claim_Details
		select @SelectClause = @SelectClause + ',CD.LineNumber,CD.PlaceOfService,CD.TypeOfService,CD.ProcedureCode,CD.Modifier,CD.Modifier2,CD.Modifier3,CD.Modifier4'
					 		  + ',CD.AdjProcedureCode,CD.AdjModifier,CD.AdjPlaceOfService,CD.DiagnosisPtrs,DiagnosisPtr1,DiagnosisPtr2,DiagnosisPtr3,DiagnosisPtr4,CD.Amount,CD.BilledCurrencyAmount,CD.AmountMaximumAllowed,CD.AmtRepriced,CD.FeeCode,CD.RepricingOrganizationNumber,CD.UnitType'
							  + ',CD.ServiceUnits,CD.EPSDTPlan,EMG,CD.PrimaryFeeAllowed,CD.COB,CD.SOC,CD.ProductCodeQualifier,CD.ProductCode,CD.ProductQuantity,CD.ProductUnitOfMeasure'
							  + ',CD.Description,CD.HCPCSRates,CD.Tooth,CD.Surface,CD.Quadrant,CD.AdjUnitType,CD.AdjServiceUnits,CD.ClaimEditingStatus,CD.ClaimPricingService,CD.SuppliedUCR'
							  + ',CD.AuthorizationNumber,CD.AuthorizationNumberType,CD.OtherCoverageCode,CD.LevelOfService,CD.RestrictionsMetIndicator'
							  + ',CD.ServiceDateFrom,CD.ServiceDateTo'
			

		-- Claim_Results
		select @SelectClause = @SelectClause + ',CR.AllowedUnits,CR.AmtCharged,CR.AmtDeferred,CR.AmtPatientLiability,CR.AmtNotCovered,CR.AmtCovered,CR.AmtDisallowed,CR.AmtOverContract,CR.AmtFeeAllowed,CR.AmtReduction'
							  + ',CR.AmtDiscount,CR.AmtWithhold,CR.AmtEligible,CR.AmtCopay,CR.AmtCoinsurance,CR.AmtDeductible,CR.AmtCOB,CR.AmtSOCApplied, CR.AmtStopLoss,CR.AmtExceedMax,CR.VisitsCovered,CR.AmtPrevPaidProv'
							  + ',isnull(CR.AmtToPay,0),isnull(CR.AmtToPayMember,0),isnull(CR.AmtToPay,0) + isnull(CR.AmtToPayMember,0),CR.ExplanationId,CR.PlanId,CR.AuthorizationId,CR.ReferralId,CR.ServiceCategoryId'
							  + ',CR.LiabilityLevelId,CR.LiabilityPackageId,Cr.ProviderContractId,CR.ContractId,CR.FeeScheduleId,CR.FeeScheduleDetailId,CR.ReimbursementId,CR.BenefitCategoryId'
							  + ',CR.Status,CR.Description,CR.AmtUCR,CR.ContractFeeScheduleMapId,CR.ExchangeRate,CR.DenialAction,CR.Negotiated'
							  + ',CR.PreEstimateClaimID,CR.PreEstimateLineNumber,CR.ModifierReductionScheduleDetailId,CR.AmtOutOfPocket,CR.AuthorizationVersion,CR.AuthServiceLineNumber,CR.AuthServiceDetailLineNumber'
							  + ',CR.AdjReviewExplanationID,CR.AmtProviderPenalty,CR.AmtMemberPenalty,CR.AmtPrevPaidMember,CR.StepDownLiabilityStepNumber,CR.AmtMoneyLimitApplied,CR.OverrideUsed,CR.BenefitCoverageID'
							  + ',CR.AmtEpisode, CR.EpisodeAuthorizationId,CR.SalesTaxRateId,CR.SalesTaxAmount, CR.RiskGroupDelegatedServiceID'


		If @ReturnClaimOverrides = 'Y'
		  begin
			-- Claim_Overrides
			select @SelectClause = @SelectClause + ',CO.ServiceCategoryId,CO.OverrideServiceRestriction,CO.OverrideLateFiling,CO.OverrideDuplicateChecking'
	  							 + ',CO.OverridePreEstimateNeeded,CO.DeductibleAmt,CO.CoinsuranceAmt,CO.CoPaymentAmt,CO.OtherPatientAmt'
	  							 + ',CO.DenyClaim,CO.ExplanationId,CO.ExplanationId2,CO.ExplanationId3,CO.ServiceDateReplacedWith'
	  							 + ',CO.OverrideReferralNeeded,CO.OverrideDenialOfRelatedProcedures,CO.OverridePreExisting,CO.OverrideAuthorizationNeeded'
	  							 + ',CO.OverridePrimaryCareRestriction,CO.OverrideCOBProcessing,CO.OverrideDelegatedRule,CO.OverrideGlobalFee,CO.OverridePaymentClassWith,CO.OverrideSuppressPaymentWith,CO.OverrideClaimEditing,CO.OverrideClaimPricing'
	  							 + ',CO.OverrideDenialAction,CO.OverrideMedicalCaseReview,CO.OverrideContractId,CO.OverrideLiabilityLevelId,CO.OverrideBenefitCategoryId'
	  							 + ',CO.OverrideAllowedAmount,CO.OverrideAmtToPay,CO.OverrideAmtToPayMember,CO.OverrideAmtCoPay,CO.OverrideAmtCoInsurance,CO.OverrideAmtDeductible'
	  							 + ',CO.OverrideAmtPatientLiability,CO.OverrideAmtOutOfPocket,CO.OverrideMaxVisits,CO.OverrideMaxUnits,CO.OverrideMaxDollars'
	  							 + ',CO.OverrideLiabilityPackageIdHistory,CO.OverrideAmtToPenalizeMember,CO.OverrideAmtToPenalizeProvider,CO.OverrideStepDownLiabilityStepNumber'
	  							 + ',CO.OverrideAmtMoneyLimitApplied,CO.OverrideAmtPreExistingApplied,CO.OverrideEpisodeAuthorizationId,CO.OverrideAllowedUnits'
								 + ',CO.OverrideSalesTaxRate,CO.OverrideSalesTaxAmount, CO.OverrideFilingDate, CO.OverrideFilingReductionAmount,CO.OverrideGender,CO.OverrideDOB,CO.OverrideRelationshipCode'
								 + ',CO.OverrideWithholdPercentage,CO.OverrideWithholdAmount' 
		  end

	end
else -- else If @Usage NOT in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
	begin
		-- Here check for parameters that requires the claim line level usages
		If @ReturnPreEstimateReview = 'Y'
		  begin
			select @UserMsg = 'The Return PreEstimate Review can only be used with report usages: |LatestClaimLines| and |AllClaimLinesAndVersions|.'
			select @LogMsg = 'The Return PreEstimate Review can only be used with report usages: |LatestClaimLines| and |AllClaimLinesAndVersions|.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
	end
			

---*******************************************************************************************************************
--- Build Dynamic SQL join clause. 
---
---
---*******************************************************************************************************************

If @Usage = '|LatestClaims|' 
	begin
		select @FromClause_C = ' Claims C Inner Join Claim_Master CM on C.ClaimID = CM.ClaimID and C.AdjustmentVersion = CM.AdjustmentVersion'
		select @FromClause_I = ' Inner Join InputBatches I on C.InputBatchId = I.InputBatchId'
									
		select @OrderByClause = 'C.ClaimId,CM.AdjustmentVersion'
	end
Else If @Usage = '|AllClaimVersions|' 
	begin
		select @FromClause_C = ' Claims C Inner Join Claim_Master CM on C.ClaimID = CM.ClaimID'
		select @FromClause_I = ' Inner Join InputBatches I on C.InputBatchId = I.InputBatchId'
		
		select @OrderByClause = 'C.ClaimId,CM.AdjustmentVersion'
	end
Else If @Usage = '|LatestClaimLines|' 
	begin
		select @FromClause_C  = ' Claims C Inner Join Claim_Master CM on C.ClaimID = CM.ClaimID and C.AdjustmentVersion = CM.AdjustmentVersion'
		select @FromClause_CD = ' Left Outer Join Claim_Details CD on C.ClaimID = CD.ClaimID and CM.AdjustmentVersion = CD.AdjustmentVersion'
		select @FromClause_I  = ' Inner Join InputBatches I on C.InputBatchId = I.InputBatchId'

		select @FromClause_CR = ' Left Outer Join Claim_Results CR on C.ClaimID = CR.ClaimID and CD.AdjustmentVersion = CR.AdjustmentVersion'
							  + ' and CD.LineNumber = CR.LineNumber'
	
		If @ReturnClaimOverrides = 'Y'
			begin
				select @FromClause_CO = ' Left Outer Join Claim_Overrides CO on C.ClaimID = CO.ClaimID and CD.AdjustmentVersion = CO.AdjustmentVersion'
									  + ' and CD.LineNumber = CO.LineNumber'
			end
			
		select @OrderByClause = 'C.ClaimId,CM.AdjustmentVersion,CD.LineNumber'
	end
Else If @Usage = '|AllClaimLinesAndVersions|' 
	begin
		select @FromClause_C = ' Claims C Inner Join Claim_Master CM on C.ClaimID = CM.ClaimID'
		select @FromClause_CD = ' Left Outer Join Claim_Details CD on C.ClaimID = CD.ClaimID and CM.AdjustmentVersion = CD.AdjustMentVersion'
		select @FromClause_I  = ' Inner Join InputBatches I on C.InputBatchId = I.InputBatchId'

		select @FromClause_CR = ' Left Outer Join Claim_Results CR on C.ClaimID = CR.ClaimID and CD.AdjustmentVersion = CR.AdjustmentVersion'
							  + ' and CD.LineNumber = CR.LineNumber'

		If @ReturnClaimOverrides = 'Y'
			begin
				select @FromClause_CO = ' Left Outer Join Claim_Overrides CO on C.ClaimID = CO.ClaimID and CD.AdjustmentVersion = CO.AdjustmentVersion'
									  + ' and CD.LineNumber = CO.LineNumber'
			end
			
		select @OrderByClause = 'C.ClaimId,CM.AdjustmentVersion,CD.LineNumber'
	end
Else 
	begin
		select @UserMsg = 'Invalid Report Usage: ' + isnull(@Usage,'NULL')
		select @LogMsg = 'Invalid Report Usage: ' + isnull(@Usage,'NULL')
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 4 - ' + convert(varchar,GETDATE(),121) 
		end

---
---  Parameter FilterClaimsBy
---	


	If isnull(@ExplanationClass,'') != '' and (@FilterResultsetsBy not in ('EXP','AXP')or @FilterResultsetsBy is null)
		begin
			select @UserMsg = 'Explanation Class should be used only when FilterResultsetby parameter is set to ''Main Resultset by Explanation'' or ''All Resultset by Explanation''.'
			select @LogMsg = 'Explanation Class should be used only when FilterResultsetby parameter is set to ''Main Resultset by Explanation'' or ''All Resultset by Explanation''.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		end
	If isnull(@ExplanationSubClass,'') != '' and (@FilterResultsetsBy not in ('EXP','AXP')or @FilterResultsetsBy is null)
		begin
			select @UserMsg = 'Explanation SubClass should be used only when FilterResultsetby parameter is set to ''Main Resultset by Explanation'' or ''All Resultset by Explanation''.'
			select @LogMsg = 'Explanation SubClass should be used only when FilterResultsetby parameter is set to ''Main Resultset by Explanation'' or ''All Resultset by Explanation''.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		end
	if @ReAdjudicationWizardJobId is not null and (@FilterResultsetsBy not in ('ARJ', 'RBJ') or @FilterResultsetsBy is null)
	begin
		select @UserMsg = 'The Re-Adjudication Batch Job filter can be used only when the "Filter ResultSets By" filter is set to ''Main Resultset by Re-Adjudication Batch Jobs'' or ''All Resultsets by Re-Adjudication Batch Jobs''.'
			, @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
	if @ReAdjudicationWizardJobClass is not null and (@FilterResultsetsBy not in ('ARJ', 'RBJ') or @FilterResultsetsBy is null)
	begin
		select @UserMsg = 'The Re-Adjudication Batch Job Class filter can be used only when the "Filter ResultSets By" filter is set to ''Main Resultset by Re-Adjudication Batch Jobs'' or ''All Resultsets by Re-Adjudication Batch Jobs''.'
			, @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
	if @ReAdjudicationWizardJobSubClass is not null and (@FilterResultsetsBy not in ('ARJ', 'RBJ') or @FilterResultsetsBy is null)
	begin
		select @UserMsg = 'The Re-Adjudication Batch Job Sub-Class filter can be used only when the "Filter ResultSets By" filter is set to ''Main Resultset by Re-Adjudication Batch Jobs'' or ''All Resultsets by Re-Adjudication Batch Jobs''.'
			, @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
	if @DateUsage = '|DateProcessedAt|' and (@FilterResultsetsBy not in ('ARJ', 'RBJ') or @FilterResultsetsBy is null)
	begin
		select @UserMsg = 'The |DateProcessedAt| Date Usage can be used only when the "Filter ResultSets By" filter is set to ''Main Resultset by Re-Adjudication Batch Jobs'' or ''All Resultsets by Re-Adjudication Batch Jobs''.'
			, @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
/*added for incremental*/
	if @DateUsage = '|Incremental|' and (((@LastActiveRowVersionNumberFrom is null) and (@PeriodStart is null or @PeriodEnd is null)) or ((@LastActiveRowVersionNumberFrom is not null) and (@PeriodStart is not null or @PeriodEnd is not null)))
	begin
		select @UserMsg = 'The |Incremental| Date Usage can be used only be used with the ''Last Active Version Number From'' and/or ''Last Active Version Number To '' filter set or ''Period Start'' date and ''Period End'' date set.'
			, @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit

	end
	if @DateUsage = '|Incremental|' and (@LastActiveRowVersionNumberFrom is null and @LastActiveRowVersionNumberTo is not null) 
	begin
		select @UserMsg = 'For The |Incremental| Date Usage, ''Last Active Version Number From'' must be supplied if ''Last Active Version Number To '' filter set is set.'
			, @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit

	end

If @FilterResultsetsBy in ('EXP','AXP')			-- Main Resultset by Explanation, All Resultsets by Explanation
	begin
		-- need distinct to eliminate dup rows from the right outer join
		select @SelectClause = 'distinct ' + @SelectClause
		
		
		if @ExplanationAbbreviation is null and @ExplanationClass is null and @ExplanationSubClass is null
			begin
				select @UserMsg = 'Please specify Explanation Abbreviation, Explanation Class or Explanation SubClass.'
				select @LogMsg = 'Please specify Explanation Abbreviation, Explanation Class or Explanation SubClass.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
				goto BusinessErrorExit
			end 
		else if (isnull(@ExplanationAbbreviation,'') != '' and isnull(@ExplanationClass,'') != '')
		or	(isnull(@ExplanationAbbreviation,'') != '' and isnull(@ExplanationSubClass,'') != '')
		or	(isnull(@ExplanationClass,'') != '' and isnull(@ExplanationSubClass,'') != '')
		
		begin
				select @UserMsg = 'Please select only one filter from either Explanation Abbreviation, Explanation Class or Explanation SubClass.'
				select @LogMsg = 'Please select only one filter from either Explanation Abbreviation, Explanation Class or Explanation SubClass.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
				goto BusinessErrorExit
		end
		
		If isnull(@ExplanationAbbreviation,'') != ''
			begin
				if not exists (select 1 from Explanations where Abbreviation = @ExplanationAbbreviation)
					begin
						select @UserMsg = 'Explanation Abbreviation ' + ISNULL(@ExplanationAbbreviation,'NULL') + ' is invalid.'
						select @LogMsg = 'Explanation Abbreviation ' + ISNULL(@ExplanationAbbreviation,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
						goto BusinessErrorExit
					end
				else
					begin
						insert into #ExplanationFilter (Explanationid)
						select explanationid from Explanations where Abbreviation = @ExplanationAbbreviation
					end	
			end

		If isnull(@ExplanationClass,'') != ''
				begin
							insert into #ExplanationFilter (Explanationid)
							select explanationid from Explanations where ExplanationClass  = @ExplanationClass
				end
		
		If isnull(@ExplanationSubClass,'') != ''
				begin
							insert into #ExplanationFilter (Explanationid)
							select explanationid from Explanations where ExplanationSubClass  = @ExplanationSubClass
				end			
			
			
		select @FromClause_CEM = ' right outer join ClaimExplanationMap CEM on C.ClaimId = CEM.ClaimId and CM.AdjustmentVersion = CEM.AdjustmentVersion'
								 + ' and   CEM.ExplanationID in (select explanationid from #ExplanationFilter) '   


	end
Else If @FilterResultsetsBy in ('AC','AAC')		-- Main resultset by action code, All resultset by action code
	begin
		-- need distinct to eliminate dup rows from the right outer join
		select @SelectClause = 'distinct ' + @SelectClause
		
		If isnull(@ActionCode,'') != ''
			begin
				select @ActionCodeId = ActionCodeId
					from ActionCodes
					where ActionCode = @ActionCode
				
				select @Rowcount = @@ROWCOUNT
				If @Rowcount = 1 
					begin
						select @FromClause_ACM = ' right outer join ClaimActionCodeMap ACM on C.ClaimId = ACM.ClaimId and CM.AdjustmentVersion = ACM.AdjustmentVersion'
										       + ' and ACM.ActionCodeId = ' + isnull(convert(varchar,@ActionCodeId),-1)    --- join to line number for line level usages????
						if @ReturnActionCodes = 'YN'
							select @FromClause_ACM = @FromClause_ACM + ' and ACM.Overridden=''N'''
					end
				else
					begin
						select @UserMsg = 'Action Code ' + ISNULL(@ActionCode,'NULL') + ' is invalid.'
						select @LogMsg = 'Action Code ' + ISNULL(@ActionCode,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				select @UserMsg = 'Please specify Action Code.'
				select @LogMsg = 'Please specify Action Code.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
				goto BusinessErrorExit
			end 
	end
Else If @FilterResultsetsBy in ('FIN','AFI')	-- Main Resultset by Financials, All Resultset by Financials
	begin
		-- need distinct to eliminate dup rows from the right outer join
		select @SelectClause = 'distinct ' + @SelectClause
	
		select @FromClause_R = ' right outer join Records R on C.ClaimId = R.ReferenceNumber' 
		
		-- Errors out if two of the three values are filled out 
		If (isnull(@RecordType,'') + ISNULL(@RecordTypeIn,'') + ISNULL(@RecordTypeNotIn,'')) 
					not in (isnull(@RecordType,''),ISNULL(@RecordTypeIn,''),ISNULL(@RecordTypeNotIn,''))
			begin
				select @UserMsg = 'Only one of the following parameters can be specified: RecordType,RecordTypeIn,RecordTypeNotIn'
				select @LogMsg = 'Only one of the following parameters can be specified: RecordType,RecordTypeIn,RecordTypeNotIn'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
		
		If isnull(@RecordType,'') != ''
			begin
				select @FromClause_R = @FromClause_R + ' and R.RecordType = ' + ''''+isnull(convert(varchar,@RecordType),'')+''''  
			end
		else If ISNULL(@RecordTypeIn,'') != ''
			begin
				Insert Into #RecordTypeInclusion
				select left(Element,3) from dbo.ff_SplitString(',',@RecordTypeIn)

				-- Now check the codes in reference codes table
				If exists(select 1 from #RecordTypeInclusion)
					begin
						Select top 1 @InvalidReferenceCode = RS.RecordType 
							from #RecordTypeInclusion RS 
								where RS.RecordType not in (select Code from ReferenceCodes where Type ='ClaimCompleteDataReport' and Subtype ='RecordType')
								
						select @Rowcount = @@ROWCOUNT	
						If @Rowcount = 0
							begin
								select @FromClause_R = @FromClause_R + ' and R.RecordType in (select RecordType from #RecordTypeInclusion)' 	
							end
						else	
							begin
								select @UserMsg = 'Record type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								select @LogMsg = 'Record type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
								goto BusinessErrorExit
							end
					end
				else
					begin
						select @UserMsg = 'Record type inclusion is invalid.'
						select @LogMsg = 'Record type inclusion is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else If ISNULL(@RecordTypeNotIn,'') != ''
			begin
				
				Insert Into #RecordTypeExclusion
				select left(Element,3) from dbo.ff_SplitString(',',@RecordTypeNotIn)

				-- Now check the codes in reference codes table
				If exists(select 1 from #RecordTypeExclusion)
					begin
						Select top 1 @InvalidReferenceCode = RS.RecordType 
							from #RecordTypeExclusion RS 
								where RS.RecordType not in (select Code from ReferenceCodes where Type ='ClaimCompleteDataReport' and Subtype ='RecordType')
								
						select @Rowcount = @@ROWCOUNT		
						If @Rowcount = 0
							begin
								--- Insert all record types minus exclusive ones into #RecordTypeInclusion table
								Insert Into #RecordTypeInclusion
								select Code 
								  From ReferenceCodes 
								    where Type ='ClaimCompleteDataReport' and Subtype ='RecordType'
								    
								EXCEPT 
								
								select RecordType from #RecordTypeExclusion
								
								select @FromClause_R = @FromClause_R + ' and R.RecordType in (select RecordType from #RecordTypeInclusion)' 	
							end
						else	
							begin
								select @UserMsg = 'Record type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								select @LogMsg = 'Record type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
								goto BusinessErrorExit
							end
					end
				else
					begin
						select @UserMsg = 'Record type exclusion is invalid.'
						select @LogMsg = 'Record type exclusion is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				-- if record type not specified, get all the record types for claims
				select @FromClause_R = @FromClause_R + ' and R.RecordType in (select Code From ReferenceCodes where Type =''ClaimCompleteDataReport'' and Subtype =''RecordType'')' 
			end 
		
		-- Errors out if two of the three values are filled out 
		If (isnull(@RecordStatus,'') + ISNULL(@RecordStatusIn,'') + ISNULL(@RecordStatusNotIn,'')) 
					not in (isnull(@RecordStatus,''),ISNULL(@RecordStatusIn,''),ISNULL(@RecordStatusNotIn,''))
			begin
				select @UserMsg = 'Only one of the following parameters can be specified: RecordStatus,RecordStatusIn,RecordStatusNotIn'
				select @LogMsg = 'Only one of the following parameters can be specified: RecordStatus,RecordStatusIn,RecordStatusNotIn'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
			
		If isnull(@RecordStatus,'') != ''
			begin
				select @FromClause_R = @FromClause_R + ' and R.RecordStatus = ' + ''''+isnull(convert(varchar,@RecordStatus),'')+''''  
			end
		else If ISNULL(@RecordStatusIn,'') != ''
			begin
				Insert Into #RecordStatusInclusion
				select left(Element,3) from dbo.ff_SplitString(',',@RecordStatusIn)

				-- Now check the codes in reference codes table
				If exists(select 1 from #RecordStatusInclusion)
					begin
						Select top 1 @InvalidReferenceCode = RS.RecordStatus 
							from #RecordStatusInclusion RS 
								where RS.RecordStatus not in (select Code from ReferenceCodes where Type ='RecordStatus')
								
						select @Rowcount = @@ROWCOUNT	
						If @Rowcount = 0
							begin
								select @FromClause_R = @FromClause_R + ' and R.RecordStatus in (select RecordStatus from #RecordStatusInclusion)' 	
							end
						else	
							begin
								select @UserMsg = 'Record Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								select @LogMsg = 'Record Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
								goto BusinessErrorExit
							end
					end
				else
					begin
						select @UserMsg = 'Record status inclusion is invalid.'
						select @LogMsg = 'Record status inclusion is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else If ISNULL(@RecordStatusNotIn,'') != ''
			begin
				
				Insert Into #RecordStatusExclusion
				select left(Element,3) from dbo.ff_SplitString(',',@RecordStatusNotIn)

				-- Now check the codes in reference codes table
				If exists(select 1 from #RecordStatusExclusion)
					begin
						Select top 1 @InvalidReferenceCode = RS.RecordStatus 
							from #RecordStatusExclusion RS 
								where RS.RecordStatus not in (select Code from ReferenceCodes where Type ='RecordStatus')
								
						select @Rowcount = @@ROWCOUNT		
						If @Rowcount = 0
							begin
								select @FromClause_R = @FromClause_R + ' and R.RecordStatus not in (select RecordStatus from #RecordStatusExclusion)' 	
							end
						else	
							begin
								select @UserMsg = 'Record Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								select @LogMsg = 'Record Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
								raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
								goto BusinessErrorExit
							end
					end
				else
					begin
						select @UserMsg = 'Record status exclusion is invalid.'
						select @LogMsg = 'Record status exclusion is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				-- if record status not specified, filter out voided records 
				select @FromClause_R = @FromClause_R + ' and R.RecordStatus != ''V''' 
			end	
	end
else if @FilterResultsetsBy in ('LCK','ALC')	-- Main Resultset by Locks, All Resultsets by Locks
	begin
		-- need distinct to eliminate dup rows from the right outer join
		select @SelectClause = 'distinct ' + @SelectClause

		select @FromClause_ALC = ' right outer join Locks L on C.ClaimId = L.EntityId and L.EntityType = ''CLM'''

		if isnull(@LockReason, '') != ''
			begin
				select @FromClause_ALC = @FromClause_ALC + ' and L.Reason = ''' + @LockReason + ''''
			end
		else if isnull(@LockClass, '') != ''
			begin
				select @FromClause_ALC = @FromClause_ALC + ' and L.Class = ''' + @LockClass + ''''
			end
		if isnull(@LockSubClass, '') != ''
			begin
				select @FromClause_ALC = @FromClause_ALC + ' and L.SubClass = ''' + @LockSubClass + ''''
			end
		
		if isnull(@LockReason, '') = '' and isnull(@LockClass, '') = '' and isnull(@LockSubClass, '') = ''
			begin
				select @UserMsg = 'Please specify Lock Reason, Lock Class or Lock SubClass.'
				select @LogMsg = 'Please specify Lock Reason, Lock Class or Lock SubClass.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
				goto BusinessErrorExit
			end
	end
else if @FilterResultsetsBy in ('ARJ', 'RBJ')  -- ARJ = Both resultsets by the passed in re-adjudication batch job, RBJ = only the main resultset by the passed in job
begin

	if @ReAdjudicationWizardJobId is null and isnull( @ReAdjudicationWizardJobClass, '' ) = '' and isnull( @ReAdjudicationWizardJobSubClass, '' ) = ''
	begin
		select @UserMsg = 'Please specify the Re-Adjudication Wizard Job Number, Job Class or Job Sub-Class to filter by.'
			, @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
		goto BusinessErrorExit
	end

	if @ReAdjudicationWizardJobId is not null
	begin
		-- Let's get the JobNumber so we can report it in the parameters ResultSet
		set @ReAdjudicationWizardJobNumber = ( select JobNumber from ReAdjudicationWizardJobs where JobId = @ReAdjudicationWizardJobId )

		if @ReAdjudicationWizardJobNumber is null
		begin
			select @UserMsg = 'Re-Adjudication Wizard Job with number ' + right( replicate( '0', 10 ) + @ReAdjudicationWizardJobId, 10 ) + ' does not exist.'
				, @LogMsg = @UserMsg
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		end

	end

	select @WhereClauseReAdjudicationWizardDetails = ' select 1 
													   from ReAdjudicationWizardJobDetails JD 
													   inner join ReAdjudicationWizardJobs Jobs
													       on JD.JobId = Jobs.JobId 
												       where JD.ClaimId = C.ClaimId '
			, @WhereClauseReAdjudicationWizardDetailsHistory =  '  select 1 
																   from ReAdjudicationWizardJobDetailsHistory JDH 
																   inner join ReAdjudicationWizardJobs Jobs
																	   on JDH.JobId = Jobs.JobId 
																   where JDH.ClaimId = C.ClaimId '

	if @Usage in ( '|LatestClaimLines|', '|AllClaimLinesAndVersions|' )
	begin
		select @WhereClauseReAdjudicationWizardDetails = @WhereClauseReAdjudicationWizardDetails + ' and ( JD.LineNumber is null or CD.LineNumber = JD.LineNumber ) '
				, @WhereClauseReAdjudicationWizardDetailsHistory = @WhereClauseReAdjudicationWizardDetailsHistory+ ' and ( JDH.LineNumber is null or CD.LineNumber = JDH.LineNumber ) '
	end

	if @ReAdjudicationWizardJobId is not null
	begin
		select @WhereClauseReAdjudicationWizardDetails = @WhereClauseReAdjudicationWizardDetails +  ' and Jobs.JobId = ' + convert( varchar, @ReAdjudicationWizardJobId )
				, @WhereClauseReAdjudicationWizardDetailsHistory = @WhereClauseReAdjudicationWizardDetailsHistory +  ' and Jobs.JobId = ' + convert( varchar, @ReAdjudicationWizardJobId )
	end

	if @ReAdjudicationWizardJobClass is not null
	begin
		select @WhereClauseReAdjudicationWizardDetails = @WhereClauseReAdjudicationWizardDetails + ' and Jobs.Class = ' + quotename( @ReAdjudicationWizardJobClass, '''' ) 
				, @WhereClauseReAdjudicationWizardDetailsHistory = @WhereClauseReAdjudicationWizardDetailsHistory + ' and Jobs.Class = ' + quotename( @ReAdjudicationWizardJobClass, '''' ) 
	end

	if @ReAdjudicationWizardJobSubClass is not null
	begin
		select @WhereClauseReAdjudicationWizardDetails = @WhereClauseReAdjudicationWizardDetails + ' and Jobs.SubClass = ' + quotename( @ReAdjudicationWizardJobSubClass, '''' ) 
				, @WhereClauseReAdjudicationWizardDetailsHistory = @WhereClauseReAdjudicationWizardDetailsHistory + ' and Jobs.SubClass = ' + quotename( @ReAdjudicationWizardJobSubClass, '''' ) 
	end

	-- we'll modify the WhereClause if the usage is different than '|DateProcessedAt|' because that usage will need
	-- to add the desired time ranges.
	-- add an ' and ' because all other time ranges will add directly to the where clause without adding the 'and'
	if @DateUsage <> '|DateProcessedAt|'
	begin
		select @WhereClause = @WhereClause + ' exists ( ' + @WhereClauseReAdjudicationWizardDetails + ' union ' + @WhereClauseReAdjudicationWizardDetailsHistory + ' ) '
		select @WhereClause = @WhereClause + ' and '
	end

end

	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select @InsertClause as '@InsertClause'		
			select @SelectClause as '@SelectClause'		
			select @FromClause_C as '@FromClause_C'
			select @FromClause_CD as '@FromClause_CD'
			select @FromClause_I as '@FromClause_I'
			select @FromClause_CR as '@FromClause_CR'
			select @FromClause_CO as '@FromClause_CO'
			select @FromClause_CEM as '@FromClause_CEM'
			select @FromClause_ACM as '@FromClause_ACM'
			select @FromClause_ALC as '@FromClause_ALC'
			select @FromClause_R as '@FromClause_R'
			select @FromClause_MCR as '@FromClause_MCR'
			select @WhereClause as '@WhereClause'
		end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 5 - ' + convert(varchar,GETDATE(),121) 
		end

---*******************************************************************************************************************
--- Build Dynamic SQL Where Clause. 
---
---
---*******************************************************************************************************************

if @TimePeriod in ('THISWEEK', 'LASTWEEK', 'THISMONTH', 'LASTMONTH', 'ALLTIME')
	begin
		exec ii_GetDateOffsets 
				@BaseTime = @BaseTime,	-- Base Time is today if it's null
				@Usage = @TimePeriod, 
				@PeriodStart = @PeriodStart out, 
				@PeriodEnd = @PeriodEnd out
	end 
	

/* Added for incremental */
If @DateUsage != '|Incremental|' or (@DateUsage = '|Incremental|' and @PeriodStart is not null and @PeriodEnd is not null)
	begin
		if @PeriodStart is null or @PeriodEnd is null
			begin
				select @UserMsg = 'Period Start/Period End, or Time Period is required.'
				select @LogMsg = 'Period Start/Period End, or Time Period is required.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end

		-- 	adjust time
		select @PeriodStart = convert(varchar, @PeriodStart,101)  + ' 00:00:00',
				@PeriodEnd = convert(varchar, @PeriodEnd,101)  + ' 23:59:59'
	end

If @DateUsage = '|DateReceived|'
	begin
		select @WhereClause = @WhereClause + ' C.DateReceived between ' + isnull(''''+convert(varchar,@PeriodStart)+'''','null') + ' and ' + isnull(''''+convert(varchar,@PeriodEnd)+'''','null')
		
		select @OrderByClause = 'C.DateReceived,' + @OrderByClause
	end
Else If @DateUsage = '|ServiceDate|'
	begin
		If @Usage in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @WhereClause = @WhereClause + ' CD.ServiceDateFrom between ' + isnull(''''+convert(varchar,@PeriodStart)+'''','null') + ' and ' + isnull(''''+convert(varchar,@PeriodEnd)+'''','null')
    		
			select @OrderByClause = 'CD.ServiceDateFrom,' + @OrderByClause
		  end
		else
		  begin
			select @WhereClause = @WhereClause + ' C.ServiceDateFrom between ' + isnull(''''+convert(varchar,@PeriodStart)+'''','null') + ' and ' + isnull(''''+convert(varchar,@PeriodEnd)+'''','null')
    		
			select @OrderByClause = 'C.ServiceDateFrom,' + @OrderByClause
		  end
	end
Else If @DateUsage = '|DateClosed|'
	begin
		select @WhereClause = @WhereClause + ' C.ClosedDate between ' + isnull(''''+convert(varchar,@PeriodStart)+'''','null') + ' and ' + isnull(''''+convert(varchar,@PeriodEnd)+'''','null')
		
		select @OrderByClause = 'C.ClosedDate,' + @OrderByClause
	end
Else If @DateUsage = '|DateLastUpdatedAt|'
	begin
		select @WhereClause = @WhereClause + ' CM.LastUpdatedAt between ' + isnull(''''+convert(varchar,@PeriodStart)+'''','null') + ' and ' + isnull(''''+convert(varchar,@PeriodEnd)+'''','null')
		
		select @OrderByClause = 'CM.LastUpdatedAt,' + @OrderByClause
	end
Else if @DateUsage = '|DateProcessedAt|'
	begin
		select @WhereClauseReAdjudicationWizardDetails = @WhereClauseReAdjudicationWizardDetails + ' and JD.ProcessedAt between ' + quotename( @PeriodStart, '''' ) + ' and ' + quotename( @PeriodEnd, '''') 
				, @WhereClauseReAdjudicationWizardDetailsHistory = @WhereClauseReAdjudicationWizardDetailsHistory + ' and JDH.ProcessedAt between ' + quotename( @PeriodStart, '''' ) + ' and ' + quotename( @PeriodEnd, '''') 

		select @WhereClause = @WhereClause + ' exists ( ' + @WhereClauseReAdjudicationWizardDetails + ' union ' + @WhereClauseReAdjudicationWizardDetailsHistory + ' ) '

		select @OrderByClause = 'CM.DateProcessed, ' + @OrderByClause
	end
Else if @DateUsage != '|Incremental|' /* Added for incremental */
	begin
		select @UserMsg = 'Invalid Date Usage: ' + isnull(@DateUsage,'NULL')
		select @LogMsg = 'Invalid Date Usage: ' + isnull(@DateUsage,'NULL')
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end



--- ******************************************************************************************************************
--- Claim Level Parameters. Filter Claims table
--- ******************************************************************************************************************	


/* Validate Form Subtype.    
 */
if (isnull(@FormSubtype,'') != '')
	begin
	if (isnull(@FormType,'') = '')
		begin
		select @UserMsg = 'Form Subtype may be specified only if Form Type is specified.'
		select @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
		end
	else if (not exists (select 1 from ReferenceCodes where Type = 'FormSubtype' and Code = @FormSubtype and Subtype = @FormType))
		begin
		select @UserMsg = 'Form Subtype is invalid for Form Type.'
		select @LogMsg = @UserMsg
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)
		end
	end

If isnull(@FormType,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and C.FormType = ' + ''''+convert(varchar,@FormType)+''''	-- convert to varchar to change datatype of 1st argument
	end 

if (isnull(@FormSubtype,'') != '')   
	begin
		select @WhereClause = @WhereClause + ' and C.FormSubtype = ' + '''' + convert(varchar,@FormSubtype) + ''''
	end 
	
If isnull(@ClaimType,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and C.ClaimType = ' + ''''+convert(varchar,@ClaimType)+''''		
	end 
	
If ISNULL(@ClaimNumber, '') != ''
	begin
		if exists (select ClaimId from Claims where ClaimNumber = @ClaimNumber)
			begin
				select @WhereClause = @WhereClause + ' and C.ClaimNumber = ' + ''''+convert(varchar,@ClaimNumber)+''''	
			end
		Else
		    begin
				select @UserMsg = 'Claim Number ' + isnull(@ClaimNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Claim Number ' + isnull(@ClaimNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
	
-- Errors out if two of the three values are filled out 
If (isnull(@ClaimStatus,'') + ISNULL(@ClaimStatusIn,'') + ISNULL(@ClaimStatusNotIn,'')) 
	not in (isnull(@ClaimStatus,''),ISNULL(@ClaimStatusIn,''),ISNULL(@ClaimStatusNotIn,''))
	begin
		select @UserMsg = 'Only one of the following parameters can be specified: ClaimStatus,ClaimStatusIn,ClaimStatusNotIn'
		select @LogMsg = 'Only one of the following parameters can be specified: ClaimStatus,ClaimStatusIn,ClaimStatusNotIn'
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
			
If isnull(@ClaimStatus,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and CM.ClaimStatus = ' + ''''+convert(varchar,@ClaimStatus)+''''		
	end
else If ISNULL(@ClaimStatusIn,'') != ''
	begin
		
		Insert Into #ClaimStatusInclusion
		select left(Element,3) from dbo.ff_SplitString(',',@ClaimStatusIn)

			------------------------------------------
			---- Debug -------------------------------
			------------------------------------------
			If @Debug > 1
			  begin
			    select 'select * from #ClaimStatusInclusion'
				select * from #ClaimStatusInclusion 
			  end
			
		-- Now check the codes in reference codes table
		If exists(select 1 from #ClaimStatusInclusion)
			begin
				Select top 1 @InvalidReferenceCode = CS.ClaimStatus 
					from #ClaimStatusInclusion CS 
						where CS.ClaimStatus not in (select Code from ReferenceCodes where Type ='ClaimStatus')
						
				select @Rowcount = @@ROWCOUNT	
				If @Rowcount = 0
					begin
						select @WhereClause = @WhereClause + ' and CM.ClaimStatus in (select ClaimStatus from #ClaimStatusInclusion)' 
					end
				else	
					begin
						select @UserMsg = 'Claim Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						select @LogMsg = 'Claim Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				select @UserMsg = 'Claim status inclusion is invalid.'
				select @LogMsg = 'Claim status inclusion is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
else If ISNULL(@ClaimStatusNotIn,'') != ''
	begin
		
		Insert Into #ClaimStatusExclusion
		select left(Element,3) from dbo.ff_SplitString(',',@ClaimStatusNotIn)
		
			------------------------------------------
			---- Debug -------------------------------
			------------------------------------------
			If @Debug > 1
			  begin
			    select 'select * from #ClaimStatusExclusion'
				select * from #ClaimStatusExclusion
			  end

		-- Now check the codes in reference codes table
		If exists(select 1 from #ClaimStatusExclusion)
			begin
				Select top 1 @InvalidReferenceCode = CS.ClaimStatus 
					from #ClaimStatusExclusion CS 
						where CS.ClaimStatus not in (select Code from ReferenceCodes where Type ='ClaimStatus')
						
				select @Rowcount = @@ROWCOUNT		
				If @Rowcount = 0
					begin
						select @WhereClause = @WhereClause + ' and CM.ClaimStatus not in (select ClaimStatus from #ClaimStatusExclusion)'
					end
				else	
					begin
						select @UserMsg = 'Claim Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						select @LogMsg = 'Claim Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				select @UserMsg = 'Claim status exclusion is invalid.'
				select @LogMsg = 'Claim status exclusion is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
	
-- Errors out if two of the three values are filled out 
If (isnull(@ClaimProcessingStatus,'') + ISNULL(@ClaimProcessingStatusIn,'') + ISNULL(@ClaimProcessingStatusNotIn,'')) 
	not in (isnull(@ClaimProcessingStatus,''),ISNULL(@ClaimProcessingStatusIn,''),ISNULL(@ClaimProcessingStatusNotIn,''))
	begin
		select @UserMsg = 'Only one of the following parameters can be specified: ClaimProcessingStatus,ClaimProcessingStatusIn,ClaimProcessingStatusNotIn'
		select @LogMsg = 'Only one of the following parameters can be specified: ClaimProcessingStatus,ClaimProcessingStatusIn,ClaimProcessingStatusNotIn'
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
	 
If isnull(@ClaimProcessingStatus,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and C.ProcessingStatus = ' + ''''+convert(varchar,@ClaimProcessingStatus)+''''	
	end 
else If ISNULL(@ClaimProcessingStatusIn,'') != ''
	begin
		
		Insert Into #ClaimProcessStatusInclusion
		select left(Element,3) from dbo.ff_SplitString(',',@ClaimProcessingStatusIn)
		
			------------------------------------------
			---- Debug -------------------------------
			------------------------------------------
			If @Debug > 1
			  begin
			    select 'select * from #ClaimProcessStatusInclusion'
				select * from #ClaimProcessStatusInclusion
			  end

		-- Now check the codes in reference codes table
		If exists(select 1 from #ClaimProcessStatusInclusion)
			begin
				Select top 1 @InvalidReferenceCode = CS.ClaimProcessStatus 
					from #ClaimProcessStatusInclusion CS 
						where CS.ClaimProcessStatus not in (select Code from ReferenceCodes where Type ='ClaimProcessingStatus')
						
				select @Rowcount = @@ROWCOUNT
				If @Rowcount = 0
					begin
						select @WhereClause = @WhereClause + ' and C.ProcessingStatus in (select ClaimProcessStatus from #ClaimProcessStatusInclusion)' 	
					end
				else	
					begin
						select @UserMsg = 'Claim Processing Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						select @LogMsg = 'Claim Processing Status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				select @UserMsg = 'Claim processing status inclusion is invalid.'
				select @LogMsg = 'Claim processing status inclusion is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
else If ISNULL(@ClaimProcessingStatusNotIn,'') != ''
	begin
		
		Insert Into #ClaimProcessStatusExclusion
		select left(Element,3) from dbo.ff_SplitString(',',@ClaimProcessingStatusNotIn)
		
			------------------------------------------
			---- Debug -------------------------------
			------------------------------------------
			If @Debug > 1
			  begin
			    select 'select * from #ClaimProcessStatusExclusion'
				select * from #ClaimProcessStatusExclusion
			  end

		-- Now check the codes in reference codes table
		If exists(select 1 from #ClaimProcessStatusExclusion)
			begin
				Select top 1 @InvalidReferenceCode = CS.ClaimProcessStatus 
					from #ClaimProcessStatusExclusion CS 
						where CS.ClaimProcessStatus not in (select Code from ReferenceCodes where Type ='ClaimProcessingStatus')
						
				select @Rowcount = @@ROWCOUNT		
				If @Rowcount = 0
					begin
						select @WhereClause = @WhereClause + ' and C.ProcessingStatus not in (select ClaimProcessStatus from #ClaimProcessStatusExclusion)' 	
					end
				else	
					begin
						select @UserMsg = 'Claim processing status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						select @LogMsg = 'Claim processing status ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				select @UserMsg = 'Claim processing status exclusion is invalid.'
				select @LogMsg = 'Claim processing status exclusion is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
	
If isnull(@PaymentClass,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and C.PaymentClass = ' + ''''+convert(varchar,@PaymentClass)+''''	
	end 

If ISNULL(@ClaimCategoryName,'') != ''
	begin
		select @ClaimCategoryCode = Code
		  from ReferenceCodes 
		    where Type = 'ClaimCategories' and Name = @ClaimCategoryName
		
		select @Rowcount = @@ROWCOUNT		
		If @Rowcount != 1
			begin
				select @UserMsg = 'Claim category name ' + ISNULL(@ClaimCategoryName,'NULL') + ' is invalid.'
				select @LogMsg = 'Claim category name ' + ISNULL(@ClaimCategoryName,'NULL') + ' is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit	
			end    
		    
		select @WhereClause = @WhereClause + ' and C.ClaimCategoryCode = ' + ''''+convert(varchar,@ClaimCategoryCode)+''''	
	end
		
If ISNULL(@ClaimExplanationAbbreviation,'') != ''
	begin
		select @ClaimExplanationId = ExplanationId
		  from Explanations 
		  where Abbreviation = @ClaimExplanationAbbreviation
		  
		select @Rowcount = @@ROWCOUNT
		If @Rowcount = 1
			begin
				select @WhereClause = @WhereClause + ' and C.ExplanationID = ' + isnull(convert(varchar,@ClaimExplanationId),'-1') 
			end
		else
			begin
				select @UserMsg = 'Claim Explanation Abbreviation ' + isnull(@ClaimExplanationAbbreviation,'NULL') + ' is invalid.'
				select @LogMsg = 'Claim Explanation Abbreviation ' + isnull(@ClaimExplanationAbbreviation,'NULL') + ' is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
	

	
--- ******************************************************************************************************************
--- Claim Level Parameters. Filter Claim_Master table
--- ******************************************************************************************************************	

If ISNULL(@ClaimMasterVersion,'') = 'ADJ'		-- Initial Adjudication Version
	begin
		select @WhereClause = @WhereClause + ' and C.InitialAdjudicationVersion = CM.AdjustmentVersion' 
	end
else If ISNULL(@ClaimMasterVersion,'') = 'TRI'  -- Initial Perfect Claim Version
	begin
		select @WhereClause = @WhereClause + ' and CM.AdjustmentVersion = 1' 
	end
else If ISNULL(@ClaimMasterVersion,'') = 'CLD'  -- Initial Closed Version
	begin
		select @WhereClause = @WhereClause + ' and CM.AdjustmentVersion = C.ClosedVersion' 
	end
--else If ISNULL(@ClaimMasterVersion,'') = ''  -- DO NOTHING 

-- Errors out if UpdatedByName and UpdatedByDepartment are both filled out
If ISNULL(@UpdatedByName,'') != '' and ISNULL(@UpdatedByDepartment,'') != ''
	begin
		select @UserMsg = 'Only one of the following parameters can be specified: UpdatedByName,UpdatedByDepartment'
		select @LogMsg = 'Only one of the following parameters can be specified: UpdatedByName,UpdatedByDepartment'
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end

If ISNULL(@UpdatedByName,'') != ''
	begin
		select @UpdatedById = UserId
		  from Users 
		  where Username = @UpdatedByName
		  
		select @Rowcount = @@ROWCOUNT
		If @Rowcount = 1
			begin
				select @WhereClause = @WhereClause + ' and CM.LastUpdatedBy = ' + isnull(convert(varchar,@UpdatedById),'-1') 
			end
		else
			begin
				select @UserMsg = 'Update By Name ' + isnull(@UpdatedByName,'') + ' is invalid.'
				select @LogMsg = 'Update By Name ' + isnull(@UpdatedByName,'') + ' is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
Else If ISNULL(@UpdatedByDepartment,'') != ''
	begin
		select @UpdatedByDeptId = DeptID
		  from Departments
		  where DeptName = @UpdatedByDepartment
		  
		select @Rowcount = @@ROWCOUNT
		If @Rowcount = 1
			begin
				Insert Into #UpdatedByUsers
				select UserID 
				  from Users
				  where DeptID = @UpdatedByDeptId
					and UserStatus = '2'  -- active users only
				
				select @Rowcount = @@ROWCOUNT
				If @Rowcount = 0
					begin
						select @UserMsg = 'Department does not have any active users.'
						select @LogMsg = 'Department does not have any active users.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
					
				select @WhereClause = @WhereClause + ' and CM.LastUpdatedBy in (select UserId from #UpdatedByUsers)'
			end
		else
			begin
				select @UserMsg = 'Update By Department ' + isnull(@UpdatedByDepartment,'') + ' is invalid.'
				select @LogMsg = 'Update By Department ' + isnull(@UpdatedByDepartment,'') + ' is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
	
If isnull(@MinimumTotalCharges,0.00) > 0.00
	begin
		select @WhereClause = @WhereClause + ' and CM.TotalCharges >= ' + convert(varchar,@MinimumTotalCharges)
	end
	
If isnull(@AssignmentOfBenefits,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and CM.AssignmentBenefits = ' + ''''+convert(varchar,@AssignmentOfBenefits)+''''
	end
If isnull(@ReferringPreestimate,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and CM.ReferringPreestimate = ' + ''''+convert(varchar,@ReferringPreestimate)+''''
	end	
If isnull(@EmergencyReferral,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and CM.EmergencyReferral = ' + ''''+convert(varchar,@EmergencyReferral)+''''
	end	
	
If isnull(@SpecialtyCategory,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and CM.ProviderSpecialtyCategoryId = ' + ''''+convert(varchar,@SpecialtyCategory)+''''
	end	
If isnull(@SpecialtySubcategory,'') != ''
	begin
		 select @SpecialtySubcategoryId = ProviderSpecialtyCategoryID
			from ProviderSpecialtyCategories
			where CategoryName = @SpecialtySubcategory
				and isnull(ParentId, 0) != 0  -- sub category
			
		SELECT @ROWCOUNT = @@ROWCOUNT
		If @Rowcount != 1
		  begin
			select @UserMsg = 'Provider Specialty Subcategory Name ' + isnull(@SpecialtySubcategory,'NULL') + ' does not exist.'
			select @LogMsg = 'Provider Specialty Subcategory Name ' + isnull(@SpecialtySubcategory,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		else
		  begin
			select @WhereClause = @WhereClause + ' and CM.ProviderSpecialtySubCategoryId = ' + ''''+convert(varchar,@SpecialtySubcategoryId)+''''
		  end
	end
If isnull(@AdjustmentReasonCode,'') != ''
	begin
		If not exists(select 1 from ReferenceCodes where Code = @AdjustmentReasonCode and Type = 'AdjustmentReasonCodes')
			begin
				select @UserMsg = 'Adjustment Reason Code ' + isnull(@AdjustmentReasonCode,'') + ' is invalid.'
				select @LogMsg = 'Adjustment Reason Code ' + isnull(@AdjustmentReasonCode,'') + ' is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
			
		select @WhereClause = @WhereClause + ' and CM.AdjustmentReasonCode = ' + ''''+convert(varchar,@AdjustmentReasonCode)+''''
	end
	
If isnull(@SuppressPayment,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and CM.SuppressPayment = ' + ''''+convert(varchar,@SuppressPayment)+''''
	end	


 --FL035772

If @WorkGroupID is not null and isnull(@Usage,'') not in ('|LatestClaims|','|LatestClaimLines|')
  begin
	select @UserMsg = 'Work group filter can only be used with report usages: |LatestClaims| and |LatestClaimLines|.'
	select @LogMsg = 'Work group filter can only be used with report usages: |LatestClaims| and |LatestClaimLines|.'
	raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
	goto BusinessErrorExit
  end	
  
If ISNULL(@WorkGroupID,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and exists(select 1 from PendedWork PW where PW.EntityType = ''CLM'' and C.ClaimID = PW.EntityID and PW.WorkGroupID = ' + convert(varchar,@WorkGroupID) + ')'

	end		
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select @InsertClause as '@InsertClause'		
			select @SelectClause as '@SelectClause'		
			select @FromClause_C as '@FromClause_C'
			select @FromClause_CD as '@FromClause_CD'
			select @FromClause_I as '@FromClause_I'
			select @FromClause_CR as '@FromClause_CR'
			select @FromClause_CO as '@FromClause_CO'
			select @FromClause_CEM as '@FromClause_CEM'
			select @FromClause_ACM as '@FromClause_ACM'
			select @FromClause_ALC as '@FromClause_ALC'
			select @FromClause_R as '@FromClause_R'
			select @FromClause_MCR as '@FromClause_MCR'
			select @WhereClause as '@WhereClause'
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 6 - ' + convert(varchar,GETDATE(),121) 
		end


--- *****************************************************************************************
--- Claim Line Level Parameters. Filter Claim_Details, and Claim_Results tables
--- *****************************************************************************************	
	
If isnull(@ProcedureCode,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Procedure Code is insufficient for the report usage.'
			select @LogMsg = 'Procedure Code is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
			
		If not exists(select 1 from ProcedureCodes where ProcedureCode = @ProcedureCode)
		  begin
			select @UserMsg = 'Procedure Code ' + isnull(@ProcedureCode,'NULL') + ' does not exist.'
			select @LogMsg = 'Procedure Code ' + isnull(@ProcedureCode,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @WhereClause = @WhereClause + ' and CD.ProcedureCode = ' + '''' + @ProcedureCode + ''''
	end

If isnull(@ProductCode,'') != ''
	begin
		-- Check the report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Product Code is insufficient for the report usage.'
			select @LogMsg = 'Product Code is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
			
		If not exists(select 1 from ProductCodes where ProductCode = @ProductCode)
		  begin
			select @UserMsg = 'Product Code ' + isnull(@ProductCode,'NULL') + ' does not exist.'
			select @LogMsg = 'Product Code ' + isnull(@ProductCode,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @WhereClause = @WhereClause + ' and CD.ProductCode = ' + '''' + @ProductCode + ''''
	end
	
If isnull(@PlaceOfService,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Place Of Service is insufficient for the report usage.'
			select @LogMsg = 'Place Of Service is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
			
		If not exists(select 1 from ReferenceCodes where Code = @PlaceOfService and Type = 'PLACEOFSERVICE')
		  begin
			select @UserMsg = 'Place Of Service ' + isnull(@PlaceOfService,'NULL') + ' does not exist.'
			select @LogMsg = 'Place Of Service ' + isnull(@PlaceOfService,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
				
		select @WhereClause = @WhereClause + ' and CD.PlaceOfService = ' + '''' + @PlaceOfService + ''''
	end
	
If isnull(@MinimumLineCharges,0.00) > 0.00 
	begin	
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Minimum Line Charge is insufficient for the report usage.'
			select @LogMsg = 'Minimum Line Charge is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @WhereClause = @WhereClause + ' and CD.Amount >= ' + convert(varchar,@MinimumLineCharges)
	end
	
If isnull(@ServiceCategoryName,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Service Category Name is insufficient for the report usage.'
			select @LogMsg = 'Service Category Name is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		
		select @ServiceCategoryID = ServiceCategoryID
			from Servicecategories
				where ServiceCategoryName = @ServiceCategoryName

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount != 1
		  begin
			select @UserMsg = 'Service Category ' + isnull(@ServiceCategoryName,'NULL') + ' does not exist.'
			select @LogMsg = 'Service Category ' + isnull(@ServiceCategoryName,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		
		select @WhereClause = @WhereClause + ' and CR.ServiceCategoryID = ' + CONVERT(varchar,@ServiceCategoryID)
	end

If isnull(@FeeScheduleName,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Fee Schedule Name is insufficient for the report usage.'
			select @LogMsg = 'Fee Schedule Name is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
	
		select @FeeScheduleID = FeeScheduleID
			from FeeSchedule
				where FeeName = @FeeScheduleName

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount != 1
		  begin
			select @UserMsg = 'Fee Schedule ' + isnull(@FeeScheduleName,'NULL') + ' does not exist.'
			select @LogMsg = 'Fee Schedule ' + isnull(@FeeScheduleName,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @WhereClause = @WhereClause + ' and CR.FeeScheduleID = ' + CONVERT(varchar,@FeeScheduleID)
	end
	
If isnull(@PlanName,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Plan Name is insufficient for the report usage.'
			select @LogMsg = 'Plan Name is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @PlanID = PlanID
		from BasePlans
			where PlanName = @PlanName

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount != 1
		  begin
			select @UserMsg = 'Base Plan ' + isnull(@PlanName,'NULL') + ' does not exist.'
			select @LogMsg = 'Base Plan ' + isnull(@PlanName,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @WhereClause = @WhereClause + ' and CR.PlanID = ' + CONVERT(varchar,@PlanID)
	end
	
If isnull(@ContractName,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Contract Name is insufficient for the report usage.'
			select @LogMsg = 'Contract Name is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @ContractID = ContractID
		  from Contracts
			where ContractName = @ContractName

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount != 1
		  begin
			select @UserMsg = 'Contract ' + isnull(@ContractName,'NULL') + ' does not exist.'
			select @LogMsg = 'Contract ' + isnull(@ContractName,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @WhereClause = @WhereClause + ' and CR.ContractID = ' + CONVERT(varchar,@ContractID)
	end
	
If isnull(@AuthorizationNumber,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Authroization Number is insufficient for the report usage.'
			select @LogMsg = 'Authroization Number is insufficient for the report usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @AuthorizationID = AuthorizationID
		  from Authorizations
			where AuthorizationNumber = @AuthorizationNumber

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount != 1
		  begin
			select @UserMsg = 'Authorization Number ' + isnull(@AuthorizationNumber,'NULL') + ' does not exist.'
			select @LogMsg = 'Authorization Number ' + isnull(@AuthorizationNumber,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		select @WhereClause = @WhereClause + ' and CR.AuthorizationID = ' + CONVERT(varchar,@AuthorizationID)
	end

If isnull(@OverrideUsed,'') != ''
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Override Used parameter cannot be set if |LatestClaims| or |AllClaimVersions| report usage is selected.'
			select @LogMsg = 'Override Used parameter cannot be set if |LatestClaims| or |AllClaimVersions| report usage is selected.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		    
		select @WhereClause = @WhereClause + ' and CR.OverrideUsed = ''' + @OverrideUsed + ''''
	end	

If @BenefitCategoryId is not null
	begin
		-- Check The report usage to make sure it goes to claim line level
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'Benefit Category parameter cannot be set if |LatestClaims| or |AllClaimVersions| report usage is selected.'
			select @LogMsg = 'Benefit Category parameter cannot be set if |LatestClaims| or |AllClaimVersions| report usage is selected.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end

		if exists (select 1 from BenefitCategories Where ParentID = @BenefitCategoryId)
			begin

				create table #benefitCategories(BenefitCategoryIds Id_t)
				;with cte_HSPBenefitCategories (BenefitCategoryId, ParentId, CTELevel) as
				(
					select B.BnfCategoryID, B.ParentID, 1
					from BenefitCategories B
					where ParentID = @BenefitCategoryId
		
					union all
		
					select B.BnfCategoryID, B.ParentID, Cte.CTELevel + 1
					from BenefitCategories B inner join cte_HSPBenefitCategories Cte 
								on B.ParentID = Cte.BenefitCategoryId

				)
				insert into #benefitCategories(BenefitCategoryIds) 
				select c.BenefitCategoryId from BenefitCategories b Inner Join cte_HSPBenefitCategories c on b.BnfCategoryID = c.BenefitCategoryId

				select @WhereClause = @WhereClause + ' and exists (select 1 from #benefitCategories B where B.BenefitCategoryIds = CR.BenefitCategoryId) '
			end
		else
			begin

				select @WhereClause = @WhereClause + ' and CR.BenefitCategoryId = ' + convert(varchar(10),@BenefitCategoryId) + ' '

			end
		    
	end	
	
	if isnull(@ReturnPCPInformation,'N') = 'N' and (isnull(@riskgroupid,'') != '' or isnull(@RiskGroupClass,'') != '' or isnull(@RiskGroupSubClass,'') != '')
		begin
			select 	@ProcedureStep = 1,
					@UserMsg = 'Risk Group Filters can only be used when ReturnPCPInformation Parameter is set to Yes',
					@LogMsg = 'Risk Group Filters can only be used when ReturnPCPInformation Parameter is set to Yes'
			raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1) 
			goto BusinessErrorExit
		end	
--- *****************************************************************************************
--- Input Batches Parameters. 
--- *****************************************************************************************	
-- Errors out if two of the three values are filled out 
If (isnull(@SourceType,'') + ISNULL(@SourceTypeIn,'') + ISNULL(@SourceTypeNotIn,'')) 
	not in (isnull(@SourceType,''),ISNULL(@SourceTypeIn,''),ISNULL(@SourceTypeNotIn,''))
	begin
		select @UserMsg = 'Only one of the following parameters can be specified: SourceType,SourceTypeIn,SourceTypeNotIn'
		select @LogMsg = 'Only one of the following parameters can be specified: SourceType,SourceTypeIn,SourceTypeNotIn'
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
		goto BusinessErrorExit
	end
	
If isnull(@SourceType,'') != ''
	begin
		select @WhereClause = @WhereClause + ' and CM.SourceType = ' + ''''+convert(varchar,@SourceType)+''''
	end
Else If ISNULL(@SourceTypeIn,'') != ''
	begin
		Insert Into #SourceTypeInclusion
		select left(Element,3) from dbo.ff_SplitString(',',@SourceTypeIn)

		-- Now check the codes in reference codes table
		If exists(select 1 from #SourceTypeInclusion)
			begin
				Select top 1 @InvalidReferenceCode = RS.SourceType 
					from #SourceTypeInclusion RS 
						where RS.SourceType not in (select Code from ReferenceCodes where Type ='ClaimCompleteDataReport' and Subtype ='SourceType')
						
				select @Rowcount = @@ROWCOUNT	
				If @Rowcount = 0
					begin
						select @WhereClause = @WhereClause + ' and I.SourceType in (select SourceType from #SourceTypeInclusion)' 	
					end
				else	
					begin
						select @UserMsg = 'Source type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						select @LogMsg = 'Source type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				select @UserMsg = 'Source type inclusion is invalid.'
				select @LogMsg = 'Source type inclusion is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
Else If ISNULL(@SourceTypeNotIn,'') != ''
	begin
		
		Insert Into #SourceTypeExclusion
		select left(Element,3) from dbo.ff_SplitString(',',@SourceTypeNotIn)

		-- Now check the codes in reference codes table
		If exists(select 1 from #SourceTypeExclusion)
			begin
				Select top 1 @InvalidReferenceCode = RS.SourceType 
					from #SourceTypeExclusion RS 
						where RS.SourceType not in (select Code from ReferenceCodes where Type ='ClaimCompleteDataReport' and Subtype ='SourceType')
						
				select @Rowcount = @@ROWCOUNT		
				If @Rowcount = 0
					begin
						select @WhereClause = @WhereClause + ' and I.SourceType not in (select SourceType from #SourceTypeExclusion)' 	
					end
				else	
					begin
						select @UserMsg = 'Source type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						select @LogMsg = 'Source type ' + ISNULL(@InvalidReferenceCode,'NULL') + ' is invalid.'
						raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
						goto BusinessErrorExit
					end
			end
		else
			begin
				select @UserMsg = 'Source type exclusion is invalid.'
				select @LogMsg = 'Source type exclusion is invalid.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
	end
	
If isnull(@SourceNumber,'') != ''
	begin
		If not exists(select 1 from InputBatches where SourceNumber = @SourceNumber)
			begin
				select @UserMsg = 'Source Number ' + isnull(@SourceNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Source Number ' + isnull(@SourceNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
		
		select @WhereClause = @WhereClause + ' and I.SourceNumber = ' + ''''+convert(varchar,@SourceNumber)+''''	
	end
	
If isnull(@ExternalBatchNumber,'') != ''
	begin
		If not exists(select 1 from InputBatches where ExternalBatchNumber = @ExternalBatchNumber)
			begin
				select @UserMsg = 'External Batch Number ' + isnull(@ExternalBatchNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'External Batch Number ' + isnull(@ExternalBatchNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
			
		select @WhereClause = @WhereClause + ' and I.ExternalBatchNumber = ' + ''''+convert(varchar,@ExternalBatchNumber)+''''		
	end 

If isnull(@InputBatchClass,'') != ''
	begin
		If not exists(select 1 from InputBatches where Class = @InputBatchClass)
			begin
				select @UserMsg = 'Input Batch Class ' + isnull(@InputBatchClass,'NULL') + ' does not exist.'
				select @LogMsg = @UserMsg
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
			
		select @WhereClause = @WhereClause + ' and I.Class = ' + ''''+convert(varchar,@InputBatchClass)+''''		
	end 

If isnull(@InputBatchSubclass,'') != ''
	begin
		If not exists(select 1 from InputBatches where Subclass = @InputBatchSubclass)
			begin
				select @UserMsg = 'Input Batch Subclass ' + isnull(@InputBatchSubclass,'NULL') + ' does not exist.'
				select @LogMsg = @UserMsg
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			end
			
		select @WhereClause = @WhereClause + ' and I.Subclass = ' + ''''+convert(varchar,@InputBatchSubclass)+''''		
	end 

	
If @PreEstimateUsage != '|NONE|'
	begin
	
		If isnull(@Usage,'') not in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		  begin
			select @UserMsg = 'The Pre Estimate Usage can only be used with report usages: |LatestClaimLines| and |AllClaimLinesAndVersions|.'
			select @LogMsg = 'The Pre Estimate Usage can only be used with report usages: |LatestClaimLines| and |AllClaimLinesAndVersions|.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
		  
		If isnull(@ClaimType,'') != 'EST'
		  begin
			select @UserMsg = 'Claim Type must be ''Estimate(EST)'' for PreEstimate Usage.'
			select @LogMsg = 'Claim Type must be ''Estimate(EST)'' for PreEstimate Usage.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end 
	end 
ELSE
	BEGIN
		IF @ClaimType = 'EST'
			BEGIN
				select @UserMsg = 'Pre Estimate Usage cannot be set to None with Claim Type set to Estimate.'
				select @LogMsg = @UserMsg
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
			END
	END

---
--- Check to make sure that the report usage is for the latest version of the claim if attempting to return the work group information.
---	
If isnull(@ReturnWorkGroupInfo,'N') = 'Y' and isnull(@Usage,'') not in ('|LatestClaims|','|LatestClaimLines|')
  begin
	select @UserMsg = 'Work group info can only be returned with report usages: |LatestClaims| and |LatestClaimLines|.'
	select @LogMsg = 'Work group info can only be returned with report usages: |LatestClaims| and |LatestClaimLines|.'
	raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
	goto BusinessErrorExit
  end	

	
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select @InsertClause as '@InsertClause'		
			select @SelectClause as '@SelectClause'		
			select @FromClause_C as '@FromClause_C'
			select @FromClause_CD as '@FromClause_CD'
			select @FromClause_I as '@FromClause_I'
			select @FromClause_CR as '@FromClause_CR'
			select @FromClause_CO as '@FromClause_CO'
			select @FromClause_CEM as '@FromClause_CEM'
			select @FromClause_ACM as '@FromClause_ACM'
			select @FromClause_ALC as '@FromClause_ALC'
			select @FromClause_R as '@FromClause_R'
			select @FromClause_MCR as '@FromClause_MCR'
			select @WhereClause as '@WhereClause'
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 7 - ' + convert(varchar,GETDATE(),121) 
		end
	
--- *****************************************************************************************
--- Claim Entities Parameters. 
--- *****************************************************************************************
if isnull(@MemberNumber,'') != ''
	begin
		Insert into #MemberCoverages
		Select MemberCoverageID 
		  from MemberCoverages
			where MemberNumber = @MemberNumber

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount > 0
			begin
				select @WhereClause = @WhereClause + ' and C.MemberCoverageID in (select MemberCoverageID from #MemberCoverages)'
			end
		Else
		    begin
				select @UserMsg = 'Member Number ' + isnull(@MemberNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Member Number ' + isnull(@MemberNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
Else if isnull(@SubscriberNumber,'') != ''
	begin
		Insert into #MemberCoverages
		Select MC.MemberCoverageID 
		  from MemberCoverages SMC, SubscriberContracts SC, MemberCoverages MC
			where SMC.MemberNumber = @SubscriberNumber
				and SMC.SubscriberContractId = SC.SubscriberContractID
				and SMC.MemberId = SC.MemberId
				and SC.SubscriberContractID = MC.SubscriberContractId

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount > 0
			begin
				select @WhereClause = @WhereClause + ' and C.MemberCoverageID in (select MemberCoverageID from #MemberCoverages)'
			end
		Else
		    begin
				select @UserMsg = 'Subscriber Number ' + isnull(@MemberNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Subscriber Number ' + isnull(@MemberNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
	
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select 'select * from #MemberCoverages'		
			select * from #MemberCoverages
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 8 - ' + convert(varchar,GETDATE(),121) 
		end
	
if isnull(@GroupNumber,'') != ''
	begin
		Select @GroupID = GroupID From Groups where GroupNumber = @GroupNumber

		SELECT @ROWCOUNT = @@ROWCOUNT

		If @Rowcount != 1
		  begin
			select @UserMsg = 'Group Number ' + isnull(@GroupNumber,'NULL') + ' does not exist.'
			select @LogMsg = 'Group Number ' + isnull(@GroupNumber,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end

		--Get groups under this parent group	
		insert into #Groups(GroupID)
		select GroupId 
			from dbo.ff_GetSubgroups(@GroupId)			-- function also returns the group id itself
	end
else if ISNULL(@GroupNumberMask,'') != ''
	begin
		insert into #Groups
		  select G.GroupID
			 from Groups G
			where G.GroupNumber like @GroupNumberMask
			
		SELECT @ROWCOUNT = @@ROWCOUNT

		If @Rowcount = 0
		  begin
			select @UserMsg = 'Group Number Mask ' + isnull(@GroupNumberMask,'NULL') + ' does not exist.'
			select @LogMsg = 'Group Number Mask ' + isnull(@GroupNumberMask,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
	end
else If ISNULL(@CompanyName,'') != ''
	begin
		select @CompanyId = CompanyId from Companies where CompanyName = @CompanyName
		
		SELECT @ROWCOUNT = @@ROWCOUNT

		If @Rowcount != 1
		  begin
			select @UserMsg = 'Company Number ' + isnull(@CompanyName,'NULL') + ' does not exist.'
			select @LogMsg = 'Company Number ' + isnull(@CompanyName,'NULL') + ' does not exist.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end

		--Get groups under this parent group	
		insert into #Groups(GroupID)
		select GroupId 
			from Groups		
				where CompanyId = @CompanyId
							
		SELECT @ROWCOUNT = @@ROWCOUNT

		If @Rowcount = 0
		  begin
			select @UserMsg = 'Cannot find any group for the given company.'
			select @LogMsg = 'Cannot find any group for the given company.'
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
			goto BusinessErrorExit
		  end
						
	end

	if isnull(@GroupLOB,'') != ''
		begin
			select @GroupLOBCode = Code
			  from ReferenceCodes 
				where Type = 'LineOfBusiness' and Name = @GroupLOB
			
			select @Rowcount = @@ROWCOUNT		
			If @Rowcount != 1
				begin
					select @UserMsg = 'Group LOB ' + ISNULL(@GroupLOB,'NULL') + ' is invalid.'
					select @LogMsg = 'Group LOB ' + ISNULL(@GroupLOB,'NULL') + ' is invalid.'
					raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
					goto BusinessErrorExit	
				end   
		end 
	if isnull(@GroupProductLine,'') != ''
		begin
			select @GroupProductLineCode = Code
			  from ReferenceCodes 
				where Type = 'ProductLine' and Name = @GroupProductLine
			
			select @Rowcount = @@ROWCOUNT		
			If @Rowcount != 1
				begin
					select @UserMsg = 'Group Product Line ' + ISNULL(@GroupProductLine,'NULL') + ' is invalid.'
					select @LogMsg = 'Group Product Line ' + ISNULL(@GroupProductLine,'NULL') + ' is invalid.'
					raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
					goto BusinessErrorExit	
				end   
		end 
	if isnull(@GroupCoverage,'') != ''
		begin
			select @GroupCoverageCode = Code
			  from ReferenceCodes 
				where Type = 'Coverage' and Name = @GroupCoverage
			
			select @Rowcount = @@ROWCOUNT		
			If @Rowcount != 1
				begin
					select @UserMsg = 'Group Coverage ' + ISNULL(@GroupCoverage,'NULL') + ' is invalid.'
					select @LogMsg = 'Group Coverage ' + ISNULL(@GroupCoverage,'NULL') + ' is invalid.'
					raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
					goto BusinessErrorExit	
				end   
		end 
	if isnull(@GroupProductType,'') != ''
		begin
			select @GroupProductTypeCode = Code
			  from ReferenceCodes 
				where Type = 'ProductType' and Name = @GroupProductType
			
			select @Rowcount = @@ROWCOUNT		
			If @Rowcount != 1
				begin
					select @UserMsg = 'Group Product Type ' + ISNULL(@GroupProductType,'NULL') + ' is invalid.'
					select @LogMsg = 'Group Product Type ' + ISNULL(@GroupProductType,'NULL') + ' is invalid.'
					raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
					goto BusinessErrorExit	
				end   
		end
		
	---
	--- If the Group Repricing flag is set to "Show All Groups", then we don't want to filter what gets returned.
	---
	if @GroupRepricing = 'SAG'
	  select @GroupRepricing = null		 

	-- If #Groups already populated from other parameters, filter them by these parameters again.
	-- Else start from all groups
	If exists (select 1 from #Groups)
		begin
			delete from #Groups
			  where not exists(select 1 from Groups G where G.GroupId = #Groups.GroupID
										and isnull(G.LOB,'') = isnull(@GroupLOBCode,isnull(G.LOB,''))
										and isnull(G.ProductLineCode,'') = isnull(@GroupProductLineCode,isnull(G.ProductLineCode,''))
										and isnull(G.CoverageCode,'') = isnull(@GroupCoverageCode,isnull(G.CoverageCode,''))
										and isnull(G.ProductType,'') = isnull(@GroupProductTypeCode,isnull(G.ProductType,''))	
										and	isnull(G.Repricing,'') = isnull(@GroupRepricing,isnull(G.Repricing,'')))	 
												
		end
	else IF ( (@GroupLOBCode is not null) or (@GroupProductLine is not null) or (@GroupCoverageCode is not null) or
			(@GroupProductTypeCode is not null) or (@GroupRepricing is not null) )
		begin
			insert into #Groups
			select GroupId
			  from Groups 
			  where isnull(LOB,'') = isnull(@GroupLOBCode,isnull(LOB,'')) 
			    and isnull(ProductLineCode,'') = isnull(@GroupProductLineCode,isnull(ProductLineCode,''))  
			    and isnull(CoverageCode,'') = isnull(@GroupCoverageCode,isnull(CoverageCode,''))  
			    and isnull(ProductType,'') = isnull(@GroupProductTypeCode,isnull(ProductType,'')) 
				and isnull(Repricing,'') = isnull(@GroupRepricing,isnull(Repricing,'')) 

			-- Check if #groups table is now empty
			If not exists(select 1 from #Groups)
				begin
					select @UserMsg = 'Cannot find group for the given group information.'
					select @LogMsg = 'Cannot find group for the given group information.'
					raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
					goto BusinessErrorExit
				end

		end
		
	If exists(select 1 From #Groups)
		begin
			select @WhereClause = @WhereClause + ' and C.GroupId in (select GroupId from #Groups)'
		end
	
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select 'select * from #Groups'		
			select * from #Groups
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 9 - ' + convert(varchar,GETDATE(),121) 
		end
	
if isnull(@ProviderNumber,'') != ''
	begin
		select @ProviderId = ProviderId 
		  from Providers
			where ProviderNumber = @ProviderNumber

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount = 1
			begin
				select @WhereClause = @WhereClause + ' and C.ProviderId = ' + CONVERT(varchar, @ProviderId)
			end
		Else
		    begin
				select @UserMsg = 'Provider Number ' + isnull(@ProviderNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Provider Number ' + isnull(@ProviderNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
else If @ProviderSpecialtyID is not null or isnull(@ProviderSpecialtySubCategoryName,'') != '' or isnull(@ProviderSpecialtyCategoryName,'') != ''
	begin
		
		If @ProviderSpecialtyID is not null 
		  begin
			select @ProviderSpecialtyName = SpecialtyName
				from ProviderSpecialties
				where ProviderSpecialtyID = @ProviderSpecialtyID
				
			SELECT @ROWCOUNT = @@ROWCOUNT
			If @Rowcount != 1
			  begin
				select @UserMsg = 'Provider Specialty does not exist.'
				select @LogMsg = 'Provider Specialty ID ' + convert(varchar(10), @ProviderSpecialtyID) + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			  end
		   end
		 
		If isnull(@ProviderSpecialtySubCategoryName,'') != ''
		  begin
			 select @ProviderSpecialtySubCategoryId = ProviderSpecialtyCategoryID
				from ProviderSpecialtyCategories
				where CategoryName = @ProviderSpecialtySubCategoryName
					and isnull(ParentId, 0) != 0  -- sub category
				
			SELECT @ROWCOUNT = @@ROWCOUNT
			If @Rowcount != 1
			  begin
				select @UserMsg = 'Provider Specialty SubCategory Name ' + isnull(@ProviderSpecialtySubCategoryName,'NULL') + ' does not exist.'
				select @LogMsg = 'Provider Specialty SubCategory Name ' + isnull(@ProviderSpecialtySubCategoryName,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			  end
		  end
		  
		If isnull(@ProviderSpecialtyCategoryName,'') != ''
		  begin
			select @ProviderSpecialtyCategoryId = ProviderSpecialtyCategoryID
				from ProviderSpecialtyCategories
				where CategoryName = @ProviderSpecialtyCategoryName
					and isnull(ParentId, 0) = 0  -- top category
				
			SELECT @ROWCOUNT = @@ROWCOUNT
			If @Rowcount != 1
			  begin
				select @UserMsg = 'Provider Specialty Category Name ' + isnull(@ProviderSpecialtyCategoryName,'NULL') + ' does not exist.'
				select @LogMsg = 'Provider Specialty Category Name ' + isnull(@ProviderSpecialtyCategoryName,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
			  end
		  end
		
		insert into #Providers
		  select ProviderID 
		  from ff_ReturnProviderIDs (null, null, null, null, null,@ProviderSpecialtyID, @ProviderSpecialtySubCategoryID, @ProviderSpecialtyCategoryID, 
								null, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
			where ProviderID > 0		-- ff function returns 1 row with provider id -1 if insufficient parameters are passed in

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount > 0
			begin
				select @WhereClause = @WhereClause + ' and C.ProviderId in (Select ProviderId from #Providers)'
			end
		Else
		    begin
				select @UserMsg = 'Cannot find any provider for the given provider Specialty.'
				select @LogMsg = 'Cannot find any provider for the given provider Specialty.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
	
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select 'select * from #Providers'		
			select * from #Providers
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 10 - ' + convert(varchar,GETDATE(),121) 
		end
	
if isnull(@OfficeNumber,'') != ''
	begin
		select @OfficeId = OfficeId 
		  from Offices
			where OfficeNumber = @OfficeNumber

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount = 1
			begin
				select @WhereClause = @WhereClause + ' and C.OfficeId = ' + CONVERT(varchar, @OfficeId)
			end
		Else
		    begin
				select @UserMsg = 'Office Number ' + isnull(@OfficeNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Office Number ' + isnull(@OfficeNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
else if isnull(@OfficeZip,'')!= '' Or isnull(@OfficeRegion,'')!= '' Or isnull(@OfficeCounty,'')!= '' Or isnull(@OfficeState,'')!= '' Or isnull(@OfficeCountryCode,'')!= ''
	begin
		insert into #Offices
		select *
		  from ff_ReturnOfficeIDs
				(null,null,null,null,null,null,null,null,@OfficeZip,null,@OfficeRegion,null,@OfficeCounty,@OfficeState,@OfficeCountryCode,null,null,null,0)
		    where OfficeID != -1		
					
		select @Rowcount = @@rowcount

		If @Rowcount > 1
			begin
				select @WhereClause = @WhereClause + ' and C.OfficeId in (Select OfficeID from #Offices) '
			end
		Else
		    begin
				select @UserMsg = 'Cannot find any office for the given office information.'
				select @LogMsg = 'Cannot find any office for the given office information.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
	
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select 'select * from #Offices'		
			select * from #Offices
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 11 - ' + convert(varchar,GETDATE(),121) 
		end
	
if isnull(@VendorNumber,'') != ''
	begin
		select @VendorId = VendorId 
		  from Vendors
			where VendorNumber = @VendorNumber

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount = 1
			begin
				select @WhereClause = @WhereClause + ' and C.VendorId = ' + CONVERT(varchar, @VendorId)
			end
		Else
		    begin
				select @UserMsg = 'Vendor Number ' + isnull(@VendorNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Vendor Number ' + isnull(@VendorNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
else if @EIN is not null
	begin
	
		insert into #Vendors ( VendorId )
		select V.VendorId
		  from Vendors V, Corporations C
		  where V.CorporationId = C.CorporationId
			and C.EIN = @EIN
			
		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount > 0
			begin
				select @WhereClause = @WhereClause + ' and C.VendorId in (select VendorID from #Vendors)' 
			end
		Else
		    begin
				select @UserMsg = 'Cannot find any vendor for the given EIN.'
				select @LogMsg = 'Cannot find any vendor for the given EIN: ' + ISNULL(@EIN,'NULL')
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end
	
	
	
	
	
	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select 'select * from #Vendors'		
			select * from #Vendors
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 12 - ' + convert(varchar,GETDATE(),121) 
		end

if isnull(@CaseNumber,'') != ''
	begin
		select @CaseID = CaseId 
		  from Cases
			where CaseNumber = @CaseNumber

		SELECT @ROWCOUNT = @@ROWCOUNT
	
		If @Rowcount = 1
			begin
				select @WhereClause = @WhereClause + ' and C.CaseId = ' + CONVERT(varchar, @CaseID)
			end
		Else
		    begin
				select @UserMsg = 'Case Number ' + isnull(@CaseNumber,'NULL') + ' does not exist.'
				select @LogMsg = 'Case Number ' + isnull(@CaseNumber,'NULL') + ' does not exist.'
				raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, -1, @rowcount, 1)                                                                                                                                                                                                                                                                                                                                                      
				goto BusinessErrorExit
		    end
	end

if @Debug = 1
begin
	print N'SP Step 12.5 - ' + convert( varchar, GETDATE(), 121 ) 
end 

	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
			select @InsertClause as '@InsertClause'		
			select @SelectClause as '@SelectClause'		
			select @FromClause_C as '@FromClause_C'
			select @FromClause_CD as '@FromClause_CD'
			select @FromClause_I as '@FromClause_I'
			select @FromClause_CR as '@FromClause_CR'
			select @FromClause_CO as '@FromClause_CO'
			select @FromClause_CEM as '@FromClause_CEM'
			select @FromClause_ACM as '@FromClause_ACM'
			select @FromClause_ALC as '@FromClause_ALC'
			select @FromClause_R as '@FromClause_R'
			select @FromClause_MCR as '@FromClause_MCR'
			select @WhereClause as '@WhereClause'
		end
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 13 - ' + convert(varchar,GETDATE(),121) 
		end







/* Added for incremental */
if (@DateUsage = '|Incremental|' and @PeriodStart is not null and @PeriodEnd is not null) or @LastActiveRowVersionNumberFrom is not null
	begin
		if (@PeriodStart is not null and @PeriodEnd is not null) or @LastActiveRowVersionNumberTo is not null
			begin
				if (@PeriodStart is not null and @PeriodEnd is not null)
					begin
						select @LastActiveRowVersionNumberFrom = min(LastActiveRowVersionNumber)
							from LastActiveRowVersionNumbers 
						   where DateOfLastActiveRowVersionNumber >= @PeriodStart

						select @LastActiveRowVersionNumberTo = max(LastActiveRowVersionNumber)
							from LastActiveRowVersionNumbers 
						   where DateOfLastActiveRowVersionNumber <= @PeriodEnd
					end


				insert #IncrementalClaimIds (ClaimId)
				(select ClaimId	
					from Claims
				where LastActiveRowVersionNumber between @LastActiveRowVersionNumberFrom and @LastActiveRowVersionNumberTo
				union
				select ClaimId	
					from Claim_Master
				where LastActiveRowVersionNumber between @LastActiveRowVersionNumberFrom and @LastActiveRowVersionNumberTo
				union
				select ClaimId	
					from ClaimActionCodeMap
				where LastActiveRowVersionNumber between @LastActiveRowVersionNumberFrom and @LastActiveRowVersionNumberTo
				union
				select ReferenceNumber	
					from Records
				where LastActiveRowVersionNumber between @LastActiveRowVersionNumberFrom and @LastActiveRowVersionNumberTo and RecordType in ('AIA', 'AIP', 'IP', 'ECA', 'CA', 'A', 'MPD', 'RPC', 'RPA', 'INF')
				union
				select EntityId	
					from Locks
				where LastActiveRowVersionNumber between @LastActiveRowVersionNumberFrom and @LastActiveRowVersionNumberTo and EntityType = 'CLM'
				union
				select EntityID
					from PendedWork 
				where LastActiveRowVersionNumber between @LastActiveRowVersionNumberFrom and @LastActiveRowVersionNumberTo and EntityType = 'CLM')
			end
		else
			begin
				insert #IncrementalClaimIds (ClaimId)
				(select ClaimId	
					from Claims
				where LastActiveRowVersionNumber >= @LastActiveRowVersionNumberFrom
				union
				select ClaimId	
					from Claim_Master
				where LastActiveRowVersionNumber >= @LastActiveRowVersionNumberFrom
				union
				select ClaimId	
					from ClaimActionCodeMap
				where LastActiveRowVersionNumber >= @LastActiveRowVersionNumberFrom
				union
				select ReferenceNumber	
					from Records
				where LastActiveRowVersionNumber >= @LastActiveRowVersionNumberFrom and RecordType in ('AIA', 'AIP', 'IP', 'ECA', 'CA', 'A', 'MPD', 'RPC', 'RPA', 'INF')
				union
				select EntityId	
					from Locks
				where LastActiveRowVersionNumber >= @LastActiveRowVersionNumberFrom and EntityType = 'CLM'
				union
				select EntityID
					from PendedWork 
				where LastActiveRowVersionNumber >= @LastActiveRowVersionNumberFrom and EntityType = 'CLM')
			end

		--------------------------------------------------------------
		------ Debug -------------------------------------------------
		--------------------------------------------------------------
		If @Debug > 1
			begin
				select 'select count(*) from #IncrementalClaimIds'		
				select count(*) from #IncrementalClaimIds
			end

		select @WhereClause =  ' C.ClaimId in (select ClaimId from #IncrementalClaimIds) ' + @WhereClause 

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 13.1 - ' + convert(varchar,GETDATE(),121) 
		end


	end

--- *****************************************************************************************
--- Execute the dynamic sql to populate #ResultSet
---
---
--- *****************************************************************************************

	select @FromClause = @FromClause_C + @FromClause_CD + @FromClause_I + @FromClause_CR + @FromClause_CO 
					   + @FromClause_CEM + @FromClause_ACM + @FromClause_ALC + @FromClause_R + @FromClause_MCR

	--------------------------------------------------------------
	------ Debug -------------------------------------------------
	--------------------------------------------------------------
	If @Debug > 1
		begin
				
			select 'Complete Dynamic SQL for Main Resultset'		
			select 'Insert Into #Resultset(' 
					+ @InsertClause + ')'
					+ ' Select ' + @SelectClause 
					+ ' From ' + @FromClause 
					+ ' Where ' + @WhereClause
					+ ' Order by ' + @OrderByClause
		end
		
	
exec ('Insert Into #Resultset(' 
		+ @InsertClause + ')'
	    + ' Select ' + @SelectClause 
		+ ' From ' + @FromClause 
		+ ' Where ' + @WhereClause
		+ ' Order by ' + @OrderByClause
		)
		
select @error = @@error

if @error != 0
	begin
		select @UserMsg = 'Error retrieving Claim Complete Data. Contact your system administrator.'
		select @LogMsg = 'Insert into #Resultset failed.'  
		raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
		goto ServerErrorExit
	end

	
-- Update DateEOBPrinted
if @Usage in ('|AllClaimVersions|','|AllClaimLinesAndVersions|')
	begin
		update R
			set DateEOBPrinted = DR.FulfilledAt
		  from #resultset R
			inner join DocumentRequests DR on R.ClaimId = DR.ClaimId and R.AdjustmentVersion = DR.AdjustmentVersion and DR.DocumentType='EOB' and DR.Status = 'PRT'
	end
		
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 14 - ' + convert(varchar,GETDATE(),121) 
		end
		

exec @internal = ii_CheckEntityAccess
					@EntityType		= '|GRP|MEM|',
					@UserId			= @UserId,
					@ResultSetTable	= '#ResultSet',
					@ProductName	= @ProductName,
					@SessionId		= @SessionId,
					@ProcedureName	= @ProcedureName,
					@UserReportID	= @UserReportID,
					@Flag			= @Debug,
					@TotalCount		= @FullRowCount		out,
					@PermittedCount	= @PermittedCount	out,
					@RestrictedCount= @RestrictedCount	out,	
					@ErrorMsg		= @ErrorMsg out	
				
				select @error = @@error

				if @error != 0
				  begin
					select @UserMsg = 'Could not check entity based access. Contact your system administrator.'
					select @LogMsg = 'Call to ii_CheckEntityAccess failed.'  
					raiserror (65500, 17, 1, @ProductName, @ProcedureName, 5, @UserMsg, @LogMsg, @SessionId, @error, -1, -1)
					goto ServerErrorExit
				  end
				else if @internal != 0
				  begin
					select @UserMsg = @ErrorMsg 
					select @LogMsg = 'ii_CheckEntityAccess returned error.' + @ErrorMsg       
					raiserror(65500,1,1,@ProductName,@ProcedureName, 5,@UserMsg,@LogMsg,@SessionID,@error,1,1) 
					if @internal = 1 
					  goto BusinessErrorExit
					else if @internal = 2
					  goto ServerErrorExit
					else if @internal = 3
					  goto AppErrorExit
				  end

	
--- *****************************************************************************************
--- Secondary resultsets. 
---
---
--- *****************************************************************************************
If @ReturnReferenceCodesName = 'Y'
	begin
		insert #ReferenceCodes (Code, Name, Description, Type, Subtype)
		select Code, Case when @ReturnReferenceCodesNameLength is null then Name else LEFT(Name, @ReturnReferenceCodesNameLength) end, Description, Type, Subtype 
			from ReferenceCodes 
		where Type in (	
						-- Main Resultset
						'CLAIMSTATUS',
						'ClaimCategories',
						'ClaimProcessingStatus',
						'PaymentClass',
						'LINEOFBUSINESS',
						'ProductLine',
						'Coverage',
						'ProductType',
						'CURRENCY',
						'EOBAction',
						'InterestOnAdjustments',
						'AdjustmentReasonCodes',
						'DenialAction',
						'Negotiated',
						'Region',
						'EINType',
						'PreEstimateReview',
						'OverrideUsed',
						'AssignmentType',
						'COBIndicator',
						'CONTRACTTYPE',
						'RELATIONSHIPCODE',
						'FORMTYPE',
						'FORMSUBTYPE',
						-- #ResultSet_Explanations
						'Severity',
						'ExplanationCategoryType',
						'DenialCategory',
						'DenialAction',
						'AllowDenial',
						'ExplanationClass',
						'ExplanationSubClass',
						-- #ResultSet_ActionCodes
						'ActionCodeAddedFrom',
						-- #ResultSet_Financials
						'RECORDSTATUS',
						'RECORDTYPE',
						'RECORDENTITY',
						'ItemType'
					)

		insert #ReferenceCodes (Code, Name, Description, Type, Subtype)
		select Code, Name, Description, Type, Subtype 
			from ReferenceCodes 
		where Type in (	
						'ActionCode'
					  )




	end

If @ReturnExplanations = 'Y'
	begin
		If @FilterResultsetsBy = 'AXP'  -- All by Explanation, return only the sepecified explanation
			begin
				Insert Into #ResultSet_Explanations (
						RowId,ClaimId,AdjustmentVersion,Line,Parameter1,Parameter2,Parameter3,Parameter4,Parameter5,DateProcessed,Queue,
						Override,ExplanationID,Abbreviation,ExplanationCode,Explanation,SortKey,ExplanationPrecedence,Severity,
						ExplanationCategoryId,ExplanationCategoryName,ExplanationCategoryPrecedence,ExplanationCategoryType,AllowUserExplanation,
						ExplanationEntityId,EntityTypeId,EntityId,ProductName,ExplanationClass,ExplanationSubclass,LastUpdatedAt,LastUpdatedBy, AllowInformationLevel)

				select  CE.RowID,CE.ClaimId,CE.AdjustmentVersion,CE.LineNumber,CE.Parameter1,CE.Parameter2,CE.Parameter3,CE.Parameter4,CE.Parameter5,CE.DateProcessed,isnull(CE.Queue,0),
						CE.Override,CE.ExplanationID,E.Abbreviation,E.ExplanationCode,E.Explanation,E.SortKey,E.Precedence,E.Severity,
						E.ExplanationCategoryId,EC.ExplanationCategoryName,EC.Precedence,EC.ExplanationCategoryType,EC.AllowUserExplanation,
						CE.ExplanationEntityId,CE.EntityTypeId,CE.EntityId,EC.ProductName,E.ExplanationClass,E.ExplanationSubclass,CE.LastUpdatedAt,CE.LastUpdatedBy, E.AllowInformationLevel
				  from ClaimExplanationMap CE
					inner join Explanations E on CE.ExplanationId = E.ExplanationId
					inner join ExplanationCategories EC on EC.ExplanationCategoryId = E.ExplanationCategoryId
				  where E.ExplanationId in (select explanationid from #ExplanationFilter) 
				  and exists (select 1 from #ResultSet RS where RS.ClaimId = CE.ClaimId and Rs.AdjustmentVersion = CE.AdjustmentVersion)
			end
		else
			begin
				If @ExplanationUsage = '|ReturnSeverityErrorOnly|'
					begin
						Insert Into #ResultSet_Explanations (
								RowId,ClaimId,AdjustmentVersion,Line,Parameter1,Parameter2,Parameter3,Parameter4,Parameter5,DateProcessed,Queue,
								Override,ExplanationID,Abbreviation,ExplanationCode,Explanation,SortKey,ExplanationPrecedence,Severity,
								DenialCategory,DenialAction,AdjActionCodeID,AdjActionCode,AdjActionCodeName,AllowDenial,
								ExplanationCategoryId,ExplanationCategoryName,ExplanationCategoryPrecedence,ExplanationCategoryType,AllowUserExplanation,
								ExplanationEntityId,EntityTypeId,EntityId,ProductName,ExplanationClass,ExplanationSubclass,LastUpdatedAt,LastUpdatedBy, AllowInformationLevel)

						select  CE.RowID,CE.ClaimId,CE.AdjustmentVersion,CE.LineNumber,CE.Parameter1,CE.Parameter2,CE.Parameter3,CE.Parameter4,CE.Parameter5,CE.DateProcessed,isnull(CE.Queue,0),
								CE.Override,CE.ExplanationID,E.Abbreviation,E.ExplanationCode,E.Explanation,E.SortKey,E.Precedence,E.Severity,
								E.DenialCategory,E.DenialAction,E.AdjActionCodeID,AC.ActionCode,AC.ActionCodeName,E.AllowDenial,
								E.ExplanationCategoryId,EC.ExplanationCategoryName,EC.Precedence,EC.ExplanationCategoryType,EC.AllowUserExplanation,
								CE.ExplanationEntityId,CE.EntityTypeId,CE.EntityId,EC.ProductName,E.ExplanationClass,E.ExplanationSubclass,CE.LastUpdatedAt,CE.LastUpdatedBy, AllowInformationLevel
						  from ClaimExplanationMap CE
							inner join Explanations E on CE.ExplanationId = E.ExplanationId and E.Severity = 'E'
							inner join ExplanationCategories EC on EC.ExplanationCategoryId = E.ExplanationCategoryId
							left outer join ActionCodes AC on E.AdjActionCodeID = AC.ActionCodeId
							where exists (select 1 from #ResultSet RS where RS.ClaimId = CE.ClaimId and Rs.AdjustmentVersion = CE.AdjustmentVersion)
					end
				else if @ExplanationUsage = '|ReturnAdjudicationReviewOnly|'
					begin
						Insert Into #ResultSet_Explanations (
								RowId,ClaimId,AdjustmentVersion,Line,Parameter1,Parameter2,Parameter3,Parameter4,Parameter5,DateProcessed,Queue,
								Override,ExplanationID,Abbreviation,ExplanationCode,Explanation,SortKey,ExplanationPrecedence,Severity,
								DenialCategory,DenialAction,AdjActionCodeID,AdjActionCode,AdjActionCodeName,AllowDenial,
								ExplanationCategoryId,ExplanationCategoryName,ExplanationCategoryPrecedence,ExplanationCategoryType,AllowUserExplanation,
								ExplanationEntityId,EntityTypeId,EntityId,ProductName,ExplanationClass,ExplanationSubclass,LastUpdatedAt,LastUpdatedBy, AllowInformationLevel)

						select  CE.RowID,CE.ClaimId,CE.AdjustmentVersion,CE.LineNumber,CE.Parameter1,CE.Parameter2,CE.Parameter3,CE.Parameter4,CE.Parameter5,CE.DateProcessed,isnull(CE.Queue,0),
								CE.Override,CE.ExplanationID,E.Abbreviation,E.ExplanationCode,E.Explanation,E.SortKey,E.Precedence,E.Severity,
								E.DenialCategory,E.DenialAction,E.AdjActionCodeID,AC.ActionCode,AC.ActionCodeName,E.AllowDenial,
								E.ExplanationCategoryId,EC.ExplanationCategoryName,EC.Precedence,EC.ExplanationCategoryType,EC.AllowUserExplanation,
								CE.ExplanationEntityId,CE.EntityTypeId,CE.EntityId,EC.ProductName,E.ExplanationClass,E.ExplanationSubclass,CE.LastUpdatedAt,CE.LastUpdatedBy, AllowInformationLevel
						  from ClaimExplanationMap CE
							inner join Explanations E on CE.ExplanationId = E.ExplanationId and E.AdjActionCodeID is not null and E.AdjudicationErrorActionCode in ('JCC','CLC')
							inner join ExplanationCategories EC on EC.ExplanationCategoryId = E.ExplanationCategoryId
							inner join ActionCodes AC on E.AdjActionCodeID = AC.ActionCodeId
							where CE.Override = 'N'
							and exists (select 1 from #ResultSet RS where RS.ClaimId = CE.ClaimId and Rs.AdjustmentVersion = CE.AdjustmentVersion)
					end
				else
					begin
						Insert Into #ResultSet_Explanations (
								RowId,ClaimId,AdjustmentVersion,Line,Parameter1,Parameter2,Parameter3,Parameter4,Parameter5,DateProcessed,Queue,
								Override,ExplanationID,Abbreviation,ExplanationCode,Explanation,SortKey,ExplanationPrecedence,Severity,
								DenialCategory,DenialAction,AdjActionCodeID,AdjActionCode,AdjActionCodeName,AllowDenial,
								ExplanationCategoryId,ExplanationCategoryName,ExplanationCategoryPrecedence,ExplanationCategoryType,AllowUserExplanation,
								ExplanationEntityId,EntityTypeId,EntityId,ProductName,ExplanationClass,ExplanationSubclass,LastUpdatedAt,LastUpdatedBy, AllowInformationLevel)

						select  CE.RowID,CE.ClaimId,CE.AdjustmentVersion,CE.LineNumber,CE.Parameter1,CE.Parameter2,CE.Parameter3,CE.Parameter4,CE.Parameter5,CE.DateProcessed,isnull(CE.Queue,0),
								CE.Override,CE.ExplanationID,E.Abbreviation,E.ExplanationCode,E.Explanation,E.SortKey,E.Precedence,E.Severity,
								E.DenialCategory,E.DenialAction,E.AdjActionCodeID,AC.ActionCode,AC.ActionCodeName,E.AllowDenial,
								E.ExplanationCategoryId,EC.ExplanationCategoryName,EC.Precedence,EC.ExplanationCategoryType,EC.AllowUserExplanation,
								CE.ExplanationEntityId,CE.EntityTypeId,CE.EntityId,EC.ProductName,E.ExplanationClass,E.ExplanationSubclass,CE.LastUpdatedAt,CE.LastUpdatedBy, AllowInformationLevel
						  from ClaimExplanationMap CE
							inner join Explanations E on CE.ExplanationId = E.ExplanationId
							inner join ExplanationCategories EC on EC.ExplanationCategoryId = E.ExplanationCategoryId
							left outer join ActionCodes AC on E.AdjActionCodeID = AC.ActionCodeId
							where exists (select 1 from #ResultSet RS where RS.ClaimId = CE.ClaimId and Rs.AdjustmentVersion = CE.AdjustmentVersion)
					end					
			end

		---	update explanations with entity
		update rse set rse.Entity = e.EntityName from #ResultSet_Explanations rse inner join Entities e on rse.EntityTypeId = e.EntityId

		update rse set rse.Entity = rse.Entity + ' (' + dc.diagnosiscode + ')'
		from #ResultSet_Explanations rse Inner Join DiagnosisCodes dc on rse.entityid = dc.DiagnosisCodeID
		where rse.Entity = 'Diagnosis Codes'

		update rse set rse.Entity = rse.Entity + ' (' + pc.ProcedureCode + ')'
		from #ResultSet_Explanations rse Inner Join Procedurecodes pc on rse.entityid = pc.ProcedureCodeID
		where rse.Entity = 'Procedure Codes'

		update rse set rse.Entity = rse.Entity + ' (' + dc.ProductCode + ')'
		from #ResultSet_Explanations rse Inner Join ProductCodes dc on rse.entityid = dc.ProductCodeId
		where rse.Entity = 'Product Codes'

		/*
		update #ResultSet_Explanations set Explanation = replace(Explanation, '<PARAM1>', isnull(Parameter1, ''))
		update #ResultSet_Explanations set Explanation = replace(Explanation, '<PARAM2>', isnull(Parameter2, ''))
		update #ResultSet_Explanations set Explanation = replace(Explanation, '<PARAM3>', isnull(Parameter3, ''))
		update #ResultSet_Explanations set Explanation = replace(Explanation, '<PARAM4>', isnull(Parameter4, ''))
		update #ResultSet_Explanations set Explanation = replace(Explanation, '<PARAM5>', isnull(Parameter5, ''))			
		*/
		---
		--- update explanations with parameter values...Do this in one pass so where not updating the same field for all the rows 5 times.
		---
		update #ResultSet_Explanations set Explanation = replace(
															replace(
																replace(
																	replace(
																		replace(Explanation,'<PARAM5>',isnull(Parameter5,'')),
																	'<PARAM4>', isnull(Parameter4, '')),
																'<PARAM3>',isnull(Parameter3,'')),
															'<PARAM2>',isnull(Parameter2,'')),
														'<PARAM1>',isnull(Parameter1,''))

				
		--update #ResultSet_Explanations 
		--set LastUpdatedByName = isnull(u.Username,null)
		--from #ResultSet_Explanations e, Users u
		--where e.LastUpdatedBy = u.UserID
						
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 15 - ' + convert(varchar,GETDATE(),121) 
		end
	
If @ReturnActionCodes = 'Y'
	begin
		If @FilterResultsetsBy = 'AAC'  -- All by Action Code, return only the sepecified Action code
			begin
				insert into #ResultSet_ActionCodes 
				(
						ClaimActionCodeMapId,	
						ActionCodeId,				ActionCodeType,				ActionCode,
						ActionCodeName,				Precedence,					AllowOverride,
						ClaimId,					AdjustmentVersion,			LineNumber,
						Overridden,					OverrideReason,				ActionEntityMapId,		
						EffectiveDate,				ExpirationDate,				DateType,
						InitialVersionApplied,		InitialDateApplied,			Owner,
						ClaimHasActionCodes,		OverridePermissionId,		ProductName,			AddedFrom,
						LastUpdatedBy,				LastUpdatedAt,				ActionCodeExplanationId
				)
				select 	CAM.ClaimActionCodeMapId,	
						A.ActionCodeId,				A.ActionCodeType,			A.ActionCode,
						A.ActionCodeName,			A.Precedence,				A.AllowOverride,
						CAM.ClaimID,				CAM.AdjustmentVersion,		CAM.LineNumber,		
						CAM.Overridden,				CAM.OverrideReason,			CAM.ActionEntityMapId,
						AEM.EffectiveDate,			AEM.ExpirationDate,			AEM.DateType,
						CAM.InitialVersionApplied,	CAM.InitialDateApplied,		A.Owner,
						'N',						A.OverridePermissionId,		A.ProductName,			CAM.AddedFrom,
						CAM.LastUpdatedBy,			CAM.LastUpdatedAt,			CAM.ExplanationId
				  from 
					(
						select distinct ClaimId, AdjustmentVersion
						from #ResultSet
					)RS	
					inner join ClaimActionCodeMap CAM on RS.ClaimId = CAM.ClaimID and RS.AdjustmentVersion = CAM.AdjustmentVersion
					inner join ActionCodes A on CAM.ActionCodeId = A.ActionCodeId
					left join ActionEntityMap AEM on CAM.ActionEntityMapId = AEM.ActionEntityMapId
				  where A.ActionCodeId = @ActionCodeId

			end
		else
			begin
				insert into #ResultSet_ActionCodes 
				(
						ClaimActionCodeMapId,	
						ActionCodeId,				ActionCodeType,				ActionCode,
						ActionCodeName,				Precedence,					AllowOverride,
						ClaimId,					AdjustmentVersion,			LineNumber,
						Overridden,					OverrideReason,				ActionEntityMapId,
						EffectiveDate,				ExpirationDate,				DateType,
						InitialVersionApplied,		InitialDateApplied,			Owner,
						ClaimHasActionCodes,		OverridePermissionId,		ProductName,			AddedFrom,
						LastUpdatedBy,				LastUpdatedAt,				ActionCodeExplanationId
				)
				select 	CAM.ClaimActionCodeMapId,	
						A.ActionCodeId,				A.ActionCodeType,			A.ActionCode,
						A.ActionCodeName,			A.Precedence,				A.AllowOverride,
						CAM.ClaimID,				CAM.AdjustmentVersion,		CAM.LineNumber,		
						CAM.Overridden,				CAM.OverrideReason,			CAM.ActionEntityMapId,
						AEM.EffectiveDate,			AEM.ExpirationDate,			AEM.DateType,
						CAM.InitialVersionApplied,	CAM.InitialDateApplied,		A.Owner,					
						'N',						A.OverridePermissionId,		A.ProductName,			CAM.AddedFrom,
						CAM.LastUpdatedBy,			CAM.LastUpdatedAt,			CAM.ExplanationId
				  from 
					(
						select distinct ClaimId, AdjustmentVersion
						from #ResultSet
					)RS	
					inner join ClaimActionCodeMap CAM on RS.ClaimId = CAM.ClaimID and RS.AdjustmentVersion = CAM.AdjustmentVersion
					inner join ActionCodes A on CAM.ActionCodeId = A.ActionCodeId
					left join ActionEntityMap AEM on CAM.ActionEntityMapId = AEM.ActionEntityMapId

			end

	update RS
	   set EntityType = AEM.EntityType
	  from #ResultSet_ActionCodes RS, ActionEntityMap AEM
	 where RS.ActionEntityMapId = AEM.ActionEntityMapId
	   and RS.ActionEntityMapId is not null
	   
	end

--This option will allow users to only return those action codes that have not been overridden.	
If @ReturnActionCodes = 'YN'
	begin
		If @FilterResultsetsBy = 'AAC'  -- All by Action Code, return only the sepecified Action code
			begin
				insert into #ResultSet_ActionCodes 
				(
						ClaimActionCodeMapId,	
						ActionCodeId,				ActionCodeType,				ActionCode,
						ActionCodeName,				Precedence,					AllowOverride,
						ClaimId,					AdjustmentVersion,			LineNumber,
						Overridden,					OverrideReason,				ActionEntityMapId,
						EffectiveDate,				ExpirationDate,				DateType,
						InitialVersionApplied,		InitialDateApplied,			Owner,
						ClaimHasActionCodes,		OverridePermissionId,		ProductName,			AddedFrom,
						LastUpdatedBy,				LastUpdatedAt,				ActionCodeExplanationId
				)
				select 	CAM.ClaimActionCodeMapId,	
						A.ActionCodeId,				A.ActionCodeType,			A.ActionCode,
						A.ActionCodeName,			A.Precedence,				A.AllowOverride,
						CAM.ClaimID,				CAM.AdjustmentVersion,		CAM.LineNumber,		
						CAM.Overridden,				CAM.OverrideReason,			CAM.ActionEntityMapId,
						AEM.EffectiveDate,			AEM.ExpirationDate,			AEM.DateType,
						CAM.InitialVersionApplied,	CAM.InitialDateApplied,		A.Owner,
						'N',						A.OverridePermissionId,		A.ProductName,			CAM.AddedFrom,
						CAM.LastUpdatedBy,			CAM.LastUpdatedAt,			CAM.ExplanationId
				  from 
					(
						select distinct ClaimId, AdjustmentVersion
						from #ResultSet
					)RS	
					inner join ClaimActionCodeMap CAM on RS.ClaimId = CAM.ClaimID and RS.AdjustmentVersion = CAM.AdjustmentVersion
					inner join ActionCodes A on CAM.ActionCodeId = A.ActionCodeId
					left join ActionEntityMap AEM on CAM.ActionEntityMapId = AEM.ActionEntityMapId
				  where A.ActionCodeId = @ActionCodeId and CAM.Overridden = 'N'
			end
		else
			begin
				insert into #ResultSet_ActionCodes 
				(
						ClaimActionCodeMapId,	
						ActionCodeId,				ActionCodeType,				ActionCode,
						ActionCodeName,				Precedence,					AllowOverride,
						ClaimId,					AdjustmentVersion,			LineNumber,
						Overridden,					OverrideReason,				ActionEntityMapId,
						EffectiveDate,				ExpirationDate,				DateType,
						InitialVersionApplied,		InitialDateApplied,			Owner,
						ClaimHasActionCodes,		OverridePermissionId,		ProductName,			AddedFrom,
						LastUpdatedBy,				LastUpdatedAt,				ActionCodeExplanationId
				)
				select 	CAM.ClaimActionCodeMapId,	
						A.ActionCodeId,				A.ActionCodeType,			A.ActionCode,
						A.ActionCodeName,			A.Precedence,				A.AllowOverride,
						CAM.ClaimID,				CAM.AdjustmentVersion,		CAM.LineNumber,		
						CAM.Overridden,				CAM.OverrideReason,			CAM.ActionEntityMapId,
						AEM.EffectiveDate,			AEM.ExpirationDate,			AEM.DateType,
						CAM.InitialVersionApplied,	CAM.InitialDateApplied,		A.Owner,
						'N',						A.OverridePermissionId,		A.ProductName,			CAM.AddedFrom,
						CAM.LastUpdatedBy,			CAM.LastUpdatedAt,			CAM.ExplanationId
				  from 
					(
						select distinct ClaimId, AdjustmentVersion
						from #ResultSet
					)RS	
					inner join ClaimActionCodeMap CAM on RS.ClaimId = CAM.ClaimID and RS.AdjustmentVersion = CAM.AdjustmentVersion
					inner join ActionCodes A on CAM.ActionCodeId = A.ActionCodeId
					left join ActionEntityMap AEM on CAM.ActionEntityMapId = AEM.ActionEntityMapId
					where CAM.Overridden = 'N'
			end

	update RS
	   set EntityType = AEM.EntityType
	  from #ResultSet_ActionCodes RS, ActionEntityMap AEM
	 where RS.ActionEntityMapId = AEM.ActionEntityMapId
	   and RS.ActionEntityMapId is not null

	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 16 - ' + convert(varchar,GETDATE(),121) 
		end
	
If @ReturnInstitutionalClaimData = 'Y'
	begin
		Insert into #ResultSet_Institutional (
			ClaimID,
			AdjustmentVersion,
			PrincipalProcedureCode,
			PrincipalProcedureDate,
			PrincipalProcedureQual,
			PrincipalDiagnosisCode,
			PrincipalDiagnosisQual,
			PrincipalPOAIndicator,
			AdmittingDiagnosisCode,
			AdmittingDiagnosisQual,
			ECode,
			ECodeQual,
			DRG,
			ConditionCode1,
			ConditionCode2,
			ConditionCode3,
			ConditionCode4,
			ConditionCode5,
			ConditionCode6,
			ConditionCode7,
			ConditionCode8,
			ConditionCode9,
			OccurrenceCode1,
			OccurrenceDateFrom1,
			OccurrenceDateTo1,
			OccurrenceCode2,
			OccurrenceDateFrom2,
			OccurrenceDateTo2,
			OccurrenceCode3,
			OccurrenceDateFrom3,
			OccurrenceDateTo3,
			OccurrenceCode4,
			OccurrenceDateFrom4,
			OccurrenceDateTo4,
			OccurrenceCode5,
			OccurrenceDateFrom5,
			OccurrenceDateTo5,
			OccurrenceCode6,
			OccurrenceDateFrom6,
			OccurrenceDateTo6,
			OccurrenceCode7,
			OccurrenceDateFrom7,
			OccurrenceDateTo7,
			OccurrenceCode8,
			OccurrenceDateFrom8,
			OccurrenceDateTo8,
			OccurrenceCode9,
			OccurrenceDateFrom9,
			OccurrenceDateTo9,
			ValueCode1,
			ValueAmount1,
			ValueCode2,
			ValueAmount2,
			ValueCode3,
			ValueAmount3,
			ValueCode4,
			ValueAmount4,
			ValueCode5,
			ValueAmount5,
			ValueCode6,
			ValueAmount6,
			ValueCode7,
			ValueAmount7,
			ValueCode8,
			ValueAmount8,
			ValueCode9,
			ValueAmount9,
			ValueCode10,
			ValueAmount10,
			ValueCode11,
			ValueAmount11,
			ValueCode12,
			ValueAmount12,
			DiagnosisCode1,
			DiagnosisCode2,
			DiagnosisCode3,
			DiagnosisCode4,
			DiagnosisCode5,
			DiagnosisCode6,
			DiagnosisCode7,
			DiagnosisCode8,
			DiagnosisCode9,
			DiagnosisCode10,
			DiagnosisCode11,
			DiagnosisCode12,
			DiagnosisCode13,
			DiagnosisCode14,
			DiagnosisCode15,
			DiagnosisCode16,
			DiagnosisCode17,
			DiagnosisCode18,
			DiagnosisCode19,
			DiagnosisCode20,
			DiagnosisCode21,
			DiagnosisCode22,
			DiagnosisCode23,
			DiagnosisCode24,
			DiagnosisCodeQual1,
			DiagnosisCodeQual2,
			DiagnosisCodeQual3,
			DiagnosisCodeQual4,
			DiagnosisCodeQual5,
			DiagnosisCodeQual6,
			DiagnosisCodeQual7,
			DiagnosisCodeQual8,
			DiagnosisCodeQual9,	
			DiagnosisCodeQual10,	
			DiagnosisCodeQual11,
			DiagnosisCodeQual12,
			DiagnosisCodeQual13,
			DiagnosisCodeQual14,
			DiagnosisCodeQual15,
			DiagnosisCodeQual16,
			DiagnosisCodeQual17,
			DiagnosisCodeQual18,
			DiagnosisCodeQual19,
			DiagnosisCodeQual20,
			DiagnosisCodeQual21,
			DiagnosisCodeQual22,
			DiagnosisCodeQual23,
			DiagnosisCodeQual24,
			POAIndicator1,
			POAIndicator2,
			POAIndicator3,
			POAIndicator4,
			POAIndicator5,
			POAIndicator6,
			POAIndicator7,
			POAIndicator8,
			POAIndicator9,
			POAIndicator10,
			POAIndicator11,
			POAIndicator12,
			POAIndicator13,
			POAIndicator14,
			POAIndicator15,
			POAIndicator16,
			POAIndicator17,
			POAIndicator18,
			POAIndicator19,
			POAIndicator20,
			POAIndicator21,
			POAIndicator22,
			POAIndicator23,
			POAIndicator24,
			ProcedureCode1,
			ProcedureDate1,
			ProcedureCodeQual1,
			ProcedureCode2,
			ProcedureDate2,
			ProcedureCodeQual2,
			ProcedureCode3,
			ProcedureDate3,
			ProcedureCodeQual3,
			ProcedureCode4,
			ProcedureDate4,
			ProcedureCodeQual4,
			ProcedureCode5,
			ProcedureDate5,
			ProcedureCodeQual5,
			ProcedureCode6,
			ProcedureDate6,
			ProcedureCodeQual6,
			ProcedureCode7,
			ProcedureDate7,
			ProcedureCodeQual7,
			ProcedureCode8,
			ProcedureDate8,
			ProcedureCodeQual8,
			ProcedureCode9,
			ProcedureDate9,
			ProcedureCodeQual9,
			PatientReasonForVisit1,
			PatientReasonForVisit1Qual,
			PatientReasonForVisit2,
			PatientReasonForVisit2Qual,
			PatientReasonForVisit3,
			PatientReasonForVisit3Qual
			)
		select
			RS.ClaimID,
			RS.AdjustmentVersion,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PRINPROCCODE' then CC.Code else NULL end), --PrincipalProcedureCode,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PRINPROCCODE' then CC.DateRecorded else NULL end), --PrincipalProcedureDate,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PRINPROCCODE' then CC.DiagnosisCodeQualifier else NULL end), --PrincipalProcedureQual,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PRINDIAGCODE' then CC.Code else NULL end), --PrincipalDiagnosisCode,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PRINDIAGCODE' then CC.DiagnosisCodeQualifier else NULL end), --PrincipalDiagnosisQual,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PRINDIAGCODE' then CC.POAIndicator else NULL end), --PrincipalPOAIndicator			
			MAX(case when CC.sequence = 1 and CC.CodeType = 'ADMDIAGCODE' then CC.Code else NULL end), --AdmittingDiagnosisCode,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'ADMDIAGCODE' then CC.DiagnosisCodeQualifier else NULL end), --AdmittingDiagnosisQual,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'ECODE' then CC.Code else NULL end), --ECode,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'ECode' then CC.DiagnosisCodeQualifier else NULL end), --ECodeQual,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'DRG' then CC.Code else NULL end), --DRG,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode1,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode2,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode3,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode4,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode5,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode6,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode7,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode8,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'CONDITION' then CC.Code else NULL end), --ConditionCode9,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode1,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom1,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo1,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode2,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom2,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo2,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode3,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom3,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo3,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode4,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom4,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo4,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode5,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom5,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo5,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode6,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom6,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo6,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode7,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom7,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo7,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode8,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom8,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo8,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'OCCURRENCE' then CC.Code else NULL end), --OccurrenceCode9,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'OCCURRENCE' then CC.DateRecorded else NULL end), --OccurrenceDateFrom9,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'OCCURRENCE' then CC.DateThrough else NULL end), --OccurrenceDateTo9,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode1,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount1,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode2,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount2,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode3,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount3,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode4,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount4,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode5,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount5,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode6,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount6,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode7,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount7,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode8,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount8,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode9,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount9,
			MAX(case when CC.sequence = 10 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode10,
			MAX(case when CC.sequence = 10 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount10,
			MAX(case when CC.sequence = 11 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode11,
			MAX(case when CC.sequence = 11 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount11,
			MAX(case when CC.sequence = 12 and CC.CodeType = 'VALUE' then CC.Code else NULL end), --ValueCode12,
			MAX(case when CC.sequence = 12 and CC.CodeType = 'VALUE' then CC.Amount else NULL end), --ValueAmount12,
			
			MAX(case when CC.sequence = 1 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode1,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode2,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode3,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode4,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode5,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode6,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode7,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode8,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode9,
			MAX(case when CC.sequence = 10 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode10,
			MAX(case when CC.sequence = 11 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode11,
			MAX(case when CC.sequence = 12 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode12,
			MAX(case when CC.sequence = 13 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode13,
			MAX(case when CC.sequence = 14 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode14,
			MAX(case when CC.sequence = 15 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode15,
			MAX(case when CC.sequence = 16 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode16,
			MAX(case when CC.sequence = 17 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode17,
			MAX(case when CC.sequence = 18 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode18,
			MAX(case when CC.sequence = 19 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode19,
			MAX(case when CC.sequence = 20 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode20,
			MAX(case when CC.sequence = 21 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode21,
			MAX(case when CC.sequence = 22 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode22,
			MAX(case when CC.sequence = 23 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode23,
			MAX(case when CC.sequence = 24 and CC.CodeType = 'DIAGNOSIS' then CC.Code else NULL end), --DiagnosisCode24,
			
			MAX(case when CC.sequence = 1 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 2 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 3 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 4 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 5 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 6 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 7 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 8 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 9 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 10 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 11 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 12 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 13 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 14 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 15 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 16 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 17 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 18 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 19 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 20 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 21 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 22 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 23 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			MAX(case when CC.sequence = 24 and CC.CodeType = 'DIAGNOSIS' then CC.DiagnosisCodeQualifier else NULL end), 
			
			MAX(case when CC.sequence = 1 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 2 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 3 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 4 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 5 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 6 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 7 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 8 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 9 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 10 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 11 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 12 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 13 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 14 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 15 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 16 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 17 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 18 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 19 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 20 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 21 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 22 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 23 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 
			MAX(case when CC.sequence = 24 and CC.CodeType = 'DIAGNOSIS' then CC.POAIndicator else NULL end), 

			MAX(case when CC.sequence = 1 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode1,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate1,
			MAX(case when CC.sequence = 1 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual11,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode2,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate2,
			MAX(case when CC.sequence = 2 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual12,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode3,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate3,
			MAX(case when CC.sequence = 3 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual13,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode4,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate4,
			MAX(case when CC.sequence = 4 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual14,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode5,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate5,
			MAX(case when CC.sequence = 5 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual15,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode6,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate6,
			MAX(case when CC.sequence = 6 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual6,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode7,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate7,
			MAX(case when CC.sequence = 7 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual17,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode8,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end), --ProcedureDate8,
			MAX(case when CC.sequence = 8 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual18,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'PROCEDURE' then CC.Code else NULL end), --ProcedureCode9,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'PROCEDURE' then CC.DateRecorded else NULL end),  --ProcedureDate9,
			MAX(case when CC.sequence = 9 and CC.CodeType = 'PROCEDURE' then CC.DiagnosisCodeQualifier else NULL end), --ProcedureCodeQual19

			MAX(case when CC.FieldNumber = '70A' and CC.CodeType = 'PATIENTREASONFORVISIT' then left(CC.Code,10) end),	--PatientReasonForVisit1
			MAX(case when CC.FieldNumber = '70A' and CC.CodeType = 'PATIENTREASONFORVISIT' then CC.DiagnosisCodeQualifier end),	--PatientReasonForVisit1Qual
			MAX(case when CC.FieldNumber = '70B' and CC.CodeType = 'PATIENTREASONFORVISIT' then left(CC.Code,10) end),	--PatientReasonForVisit2
			MAX(case when CC.FieldNumber = '70B' and CC.CodeType = 'PATIENTREASONFORVISIT' then CC.DiagnosisCodeQualifier end),	--PatientReasonForVisit2Qual
			MAX(case when CC.FieldNumber = '70C' and CC.CodeType = 'PATIENTREASONFORVISIT' then left(CC.Code,10) end),	--PatientReasonForVisit3
			MAX(case when CC.FieldNumber = '70C' and CC.CodeType = 'PATIENTREASONFORVISIT' then CC.DiagnosisCodeQualifier end)	--PatientReasonForVisit3Qual
		from
		--FL057302 : commenting below block because it doesnt seem like we need to perform partition and generate sequence column. This column is already present in Claim_Codes table.
		 -- (
			--select CodeType, Code, DateRecorded, DiagnosisCodeQualifier, POAIndicator, CC1.Amount, DateThrough, CC1.ClaimId, CC1.AdjustmentVersion,
			--row_number() over(partition by CC1.ClaimId,CC1.AdjustmentVersion,CodeType order by Sequence) As sequence 
			--From  Claim_Codes CC1,  #ResultSet RS  where RS.FormType = 'UB' and RS.ClaimId = CC1.ClaimID and RS.AdjustmentVersion = CC1.AdjustmentVersion 
			
		 -- ) CC,
		 Claim_Codes CC,
		  #ResultSet RS
		  where RS.FormType = 'UB' and RS.ClaimId = CC.ClaimID and RS.AdjustmentVersion = CC.AdjustmentVersion 
		  group by RS.ClaimID, RS.AdjustmentVersion

		Update #ResultSet_Institutional
		  set TypeOfBill = CM.TypeOfBill,
			  StatementCoversFrom = CM.StatementCoversFrom,		
			  StatementCoversTo	= CM.StatementCoversTo,
			  StatementCoversDays = DATEDIFF(day,CM.StatementCoversFrom,CM.StatementCoversTo) + 1,
		  	  AdmissionDate = CM.AdmissionDate,
		  	  AdmissionHour	= CM.AdmissionHour,	
			  TypeOfAdmission	= CM.TypeOfAdmission,	
			  SourceOfAdmission	= CM.SourceOfAdmission,		
			  DischargeHour		= CM.DischargeHour,
			  PatientStatus		= CM.PatientStatus,
		 	  AcceptAssignment	= CM.AcceptAssignment,
			  AssignmentBenefits = CM.AssignmentBenefits,
			  PriorPayments		= CM.PriorPayments,
			  EstAmountDue		= CM.EstAmountDue,
		 	  ProcedureCodeType	= CM.ProcedureCodeType,	
			  ProviderSignature	= CM.ProviderSignature,
			  TreatAuthCodes	= CM.TreatAuthCodes,
			  EmploymentStatusCode = CM.EmploymentStatusCode,
			  OtherProviderId1	= CM.OtherProviderId,	
			  OtherPhysicianNumber1	= CM.OtherPhysicianNumber1,
		      OtherPhysicianNumberQualifier1 = CM.OtherPhysicianNumberQualifier1,	
			  OtherPhysicianName1 =	CM.OtherPhysicianName1,
			  OtherProviderId2	= CM.OtherProviderId2,
			  OtherPhysicianNumber2 = CM.OtherPhysicianNumber2,				
			  OtherPhysicianNumberQualifier2 = CM.OtherPhysicianNumberQualifier2,	
			  OtherPhysicianName2 =	CM.OtherPhysicianName2,
			  AttendingProviderId	= CM.AttendingProviderId,
			  AttendingPhysicianNumber = CM.AttendingPhysicianNumber,			
			  AttendingPhysicianNumberQualifier = CM.AttendingPhysicianNumberQualifier,	
			  AttendingPhysicianName = CM.AttendingPhysicianName,
			  OperatingProviderId = CM.OperatingProviderId,
			  OperatingPhysicianNumber = CM.OperatingPhysicianNumber,		
			  OperatingPhysicianNumberQualifier = CM.OperatingPhysicianNumberQualifier, 	
			  OperatingPhysicianName = CM.OperatingPhysicianName,
			  MedicalRecordNumber = CM.MedicalRecordNumber
			from Claim_Master CM
			where #ResultSet_Institutional.ClaimID = CM.ClaimID
			  and #ResultSet_Institutional.AdjustmentVersion = CM.AdjustmentVersion

			/********************************************************************************
			Next 4 Updates to grab Provider Number & Provider's First Name from Providers
			table for cases we don't have the info within the Claim_Master table
			********************************************************************************/
			Update RSI
			Set 
				AttendingPhysicianNumber = ISNULL(AttendingPhysicianNumber, P.ProviderNumber),
				AttendingPhysicianName = ISNULL(AttendingPhysicianName, P.LastName + ', ' +P.FirstName)
			From #ResultSet_Institutional RSI
					Inner Join Providers P On RSI.AttendingProviderId = P.ProviderID

			Update RSI
			Set 
				OperatingPhysicianNumber = ISNULL(OperatingPhysicianNumber, P.ProviderNumber),
				OperatingPhysicianName = ISNULL(OperatingPhysicianName, P.LastName + ', ' +P.FirstName)
			From #ResultSet_Institutional RSI
					Inner Join Providers P On RSI.OperatingProviderId = P.ProviderID	
					
			Update RSI
			Set 
				OtherPhysicianNumber1 = ISNULL(OtherPhysicianNumber1, P.ProviderNumber),
				OtherPhysicianName1 = ISNULL(OtherPhysicianName1, P.LastName + ', ' +P.FirstName)
			From #ResultSet_Institutional RSI
					Inner Join Providers P On RSI.OtherProviderId1 = P.ProviderID

			Update RSI
			Set 
				OtherPhysicianNumber2 = ISNULL(OtherPhysicianNumber2, P.ProviderNumber),
				OtherPhysicianName2 = ISNULL(OtherPhysicianName2, P.LastName + ', ' +P.FirstName)
			From #ResultSet_Institutional RSI
					Inner Join Providers P On RSI.OtherProviderId2 = P.ProviderID		
			  
		--------------------------------------------------
		---- TIME STAMP-----------------------------------
		--------------------------------------------------
		If @Debug > 0
			begin
				print N'SP Step 16.1 - ' + convert(varchar,GETDATE(),121) 
			end
			
		If @ReturnInstitutionalAuthInfo = 'Y'
			begin
			
				Create Table #InpatientAuth
				(
					ClaimId					Id_t,
					AdjustmentVersion		int,
					AuthorizationId			Id_t,
					AuthorizationVersion	int,
					AuthorizationNumber		REFNumber_t null,
					AuthorizationLineNumber int null,
					RequestedMaxVisits		real null,
					ApprovedMaxVisits		real null
				)
				
				insert into #InpatientAuth
				(
					ClaimId,
					AdjustmentVersion,
					AuthorizationId,
					AuthorizationVersion,
					AuthorizationNumber,
					AuthorizationLineNumber,
					RequestedMaxVisits,
					ApprovedMaxVisits
				)
				select distinct
					I.ClaimID,
					I.AdjustmentVersion,
					A.AuthorizationID,
					AM.Version,
					A.AuthorizationNumber,
					AM.LineNumber,
					AM.RequestedMaxVisits,
					AM.ApprovedMaxVisits
				from #ResultSet_Institutional I 
				  inner join Claim_Results CR on I.ClaimID = CR.ClaimId and I.AdjustmentVersion = CR.AdjustmentVersion
				  inner join Authorizations A on CR.AuthorizationId = A.AuthorizationID
				  inner join AuthorizationServicesMaster AM on A.AuthorizationID = AM.AuthorizationID
															and CR.AuthServiceLineNumber = AM.LineNumber
															and CR.AuthorizationVersion = AM.Version
					where I.TypeOfBill between '111' and '119' -- inpatient claims only

						--------------------------------------------------
						---- TIME STAMP-----------------------------------
						--------------------------------------------------
						If @Debug > 0
							begin
								print N'SP Step 16.2 - ' + convert(varchar,GETDATE(),121) 
							end
					
						--------------------------------------------------------------
						------ Debug -------------------------------------------------
						--------------------------------------------------------------
						If @Debug > 1
							begin
								select 'select * from #InpatientAuth'
								select * from #InpatientAuth
							end
							
				-- Ideally, One claim should only hit one Authorization and Authorization Services Master line.
				Update #ResultSet_Institutional
				  Set RequestedDays = A.RequestedMaxVisits,
					  ApprovedDays = A.ApprovedMaxVisits,
					  AuthorizationID = A.AuthorizationID,
					  AuthorizationVersion = A.AuthorizationVersion,
					  AuthorizationNumber = A.AuthorizationNumber,
					  AUthorizationLineNumber = A.AuthorizationLineNumber
					From #InpatientAuth A
					 Where #ResultSet_Institutional.ClaimId = A.ClaimId
						and #ResultSet_Institutional.AdjustmentVersion = A.AdjustmentVersion 
						
			end -- end of If @ReturnInstitutionalAuthInfo = 'Y'
		
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 17 - ' + convert(varchar,GETDATE(),121) 
		end

If @ReturnFinancialInformation in ('R','RD') -- Records, RecordDetails
	begin
		
		select @FinDSQLInsert = 'ClaimID,AdjustmentVersion,RecordID,RecordStatus,RecordAmount'
						      +',RecordType,EntityType,CreationDate,ProcessedDate'
		
		select @FinDSQLSelect =  'RS.ClaimID,R.AdjustmentVersion,R.RecordID,R.RecordStatus,R.Amount'
						      +',R.RecordType,R.EntityType,R.CreationDate,R.ProcessedDate'

		select @FinDSQLFrom = '(select distinct ClaimId from #ResultSet)RS'	-- Derived Table
							 +' inner join Records R on RS.ClaimId = R.ReferenceNumber'
									+' and R.RecordType in (select Code From ReferenceCodes where Type =''ClaimCompleteDataReport'' and Subtype =''RecordType'')' 
		
		If @FilterResultsetsBy = 'AFI'  -- Filter All by Financials, return only the sepecified records
		  begin
		    -- RecordType
			If isnull(@RecordType,'') != ''
			  begin
				select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordType = ' + ''''+CONVERT(varchar,@RecordType)+''''
			  end 
			else if exists(select 1 from #RecordTypeInclusion)
			  begin
				select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordType in (select RecordType from #RecordTypeInclusion)'
			  end
			else if exists(select 1 from #RecordTypeExclusion)
			  begin
				select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordType not in (select RecordType from #RecordTypeExclusion)'
			  end
			  
			-- RecordStatus
			If isnull(@RecordStatus,'') != ''
			  begin
				select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordStatus = ' + ''''+CONVERT(varchar,@RecordStatus)+''''
			  end 
			else if exists(select 1 from #RecordStatusInclusion)
			  begin
				select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordStatus in (select RecordStatus from #RecordStatusInclusion)'
			  end
			else if exists(select 1 from #RecordStatusExclusion)
			  begin
				select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordStatus not in (select RecordStatus from #RecordStatusExclusion)'
			  end
			else
			  begin
				-- If Record status is not specified, filter out voided records
				select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordStatus !=''V''' 
			  end
		  end
		else
		  begin
			-- If Record status is not specified, filter out voided records
			select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordStatus !=''V''' 
		  end

		---
		--- We need to do two separate inserts for record details.
		--- The first insert joins to Claim_Details in order to generate a "fake" detail for those claim lines
		---	paying $0.  The second insert is for interest penalty records, since their details are not specific to claim lines.
		---
		If @ReturnFinancialInformation = 'RD'	 
		  begin
			select @FinDSQLInsert = @FinDSQLInsert + ',RecordDetailID,ItemType,ItemID,RecordDetailAmount'
			select @FindSQLInsert2 = @FindSQLInsert
			select @FinDSQLSelect2 = @FinDSQLSelect + ',RD.RecordDetailID,RD.ItemType,RD.ItemID, RD.TotalAmount'			
			select @FinDSQLSelect = @FinDSQLSelect + ',RD.RecordDetailID,RD.ItemType,CD.LineNumber,isnull(RD.TotalAmount,0.00)'
			select @FinDSQLFrom2 = @FinDSQLFrom + ' and R.RecordType in (''AIA'',''AIP'',''IP'') left join RecordDetails RD on R.RecordID = RD.RecordID'			
			select @FinDSQLFrom = @FinDSQLFrom + ' and R.RecordType in (''ECA'',''CA'',''A'',''MPD'',''RPC'',''RPA'',''INF'')'
			select @FinDSQLFrom = @FinDSQLFrom + ' left join Claim_Details CD on RS.ClaimID = CD.ClaimID and CD.AdjustmentVersion = R.AdjustmentVersion'
			select @FinDSQLFrom = @FinDSQLFrom + ' left join RecordDetails RD on R.RecordID = RD.RecordID and CD.LineNumber = RD.ItemID'			
		  end
		  
				--------------------------------------------------------------
				------ Debug -------------------------------------------------
				--------------------------------------------------------------
				If @Debug > 1
					begin
						select 'Complete Dynamic SQL for #ResultSet_Financials Resultset'		
						select 'Insert Into #ResultSet_Financials(' 
											 + @FinDSQLInsert + ')'
								+ ' Select ' + @FinDSQLSelect 
								  + ' From ' + @FinDSQLFrom 
						select 'Insert Into #ResultSet_Financials(' 
											 + @FinDSQLInsert2 + ')'
								+ ' Select ' + @FinDSQLSelect2 
								  + ' From ' + @FinDSQLFrom2 								  
					end
		
		Exec('Insert Into #ResultSet_Financials(' 
							 + @FinDSQLInsert + ')'
				+ ' Select ' + @FinDSQLSelect 
				  + ' From ' + @FinDSQLFrom)
				  
		if @FindSQLInsert2 is not null
		  begin
			Exec('Insert Into #ResultSet_Financials(' 
								 + @FinDSQLInsert2 + ')'
					+ ' Select ' + @FinDSQLSelect2 
					  + ' From ' + @FinDSQLFrom2)		  
		  end
			
		--select distinct ClaimId from #ResultSet		  
		-- select ('Insert Into #ResultSet_Financials(' 
		--					 + @FinDSQLInsert + ')'
		--		+ ' Select ' + @FinDSQLSelect 
		--		  + ' From ' + @FinDSQLFrom)
		
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 18 - ' + convert(varchar,GETDATE(),121) 
		end

If @ReturnClaimCodes = 'Y'
	begin
		Insert Into #ResultSet_ClaimCodes(
					ClaimID, AdjustmentVersion, Sequence, CodeType, Code, CodeQualifier,
					POAIndicator, DateRecorded, DateThrough, Amount, FieldNumber
			)
			select  
					CC.ClaimID, CC.AdjustmentVersion, CC.Sequence, CC.CodeType, CC.Code, CC.DiagnosisCodeQualifier, 
					CC.POAIndicator, CC.DateRecorded, CC.DateThrough, CC.Amount, CC.FieldNumber
			from(
				select distinct ClaimId, AdjustmentVersion
				from #ResultSet
			)RS
			inner join Claim_Codes CC on RS.ClaimId = CC.ClaimID and RS.AdjustmentVersion = CC.AdjustmentVersion 
			
		--------------------------------------------------
		---- TIME STAMP-----------------------------------
		--------------------------------------------------
		If @Debug > 0
			begin
				print N'SP Step 18.1 - ' + convert(varchar,GETDATE(),121) 
			end
		
		--*******************************************************************************************************	
		-- 
		-- Update Code Description from either diagnosis codes or procedure codes table based on the code type.
		--*******************************************************************************************************
		--
		--ECODE				-- DC
		--PROCEDURE			-- PC
		--ADMDIAGCODE		-- DC
		--CONDITION			-- Informational, Not in any table
		--PRINDIAGCODE		-- DC
		--VALUE				-- Informational, Not in any table
		--DIAGNOSIS			-- DC
		--PRINPROCCODE		-- PC
		--DRG				-- PC
		--OCCURRENCE		-- Informational, Not in any table
		--*******************************************************************************************************
		
		Update #ResultSet_ClaimCodes
			set CodeDescription = DC.Description
			from DiagnosisCodes DC
			where #ResultSet_ClaimCodes.Code = DC.DiagnosisCode				
			  and #ResultSet_ClaimCodes.CodeType in ('ECODE','ADMDIAGCODE','PRINDIAGCODE','DIAGNOSIS', 'PATIENTREASONFORVISIT')
			  and ISNULL(#ResultSet_ClaimCodes.CodeQualifier, '') = ISNULL(DC.CodeType, '')
			  
		Update #ResultSet_ClaimCodes
			set CodeDescription = PC.Description
			from ProcedureCodes PC
			where #ResultSet_ClaimCodes.Code = PC.ProcedureCode
			  and #ResultSet_ClaimCodes.CodeType in ('PROCEDURE','PRINPROCCODE','DRG')		
					
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 18.2 - ' + convert(varchar,GETDATE(),121) 
		end
		
If @ReturnCustomAttributes = 'Y'
	begin
		-- #ResultSet_CustomAttributes temp table is created for building the dynamic sql 
		-- in order to return the claim custom attributes in a separate table.
		-- The dynamic sql will join the #custom attributes with #Report custom attributes on claim id
	
		-- populate #ResultSet_CustomAttributes temp table if the parameter is set to Yes
		Insert Into #ResultSet_CustomAttributes(ClaimID)
		  Select distinct ClaimID
			From #ResultSet 
		    
		-- this temp table is needed for the ii_BuildReportingDynamicSQL_ARCHDEV call
		create table #ReportCustomAttributes
		(
			EntityID			ID_t			not null,
			AttributeValue1		StringLong_t	null,
			AttributeValue2		StringLong_t	null,
			AttributeValue3		StringLong_t	null,
			AttributeValue4		StringLong_t	null,
			AttributeValue5		StringLong_t	null,
			AttributeValue6		StringLong_t	null,
			AttributeValue7		StringLong_t	null,
			AttributeValue8		StringLong_t	null,
			AttributeValue9		StringLong_t	null,
			AttributeValue10	StringLong_t	null
		)
		create index byEntityID on #ReportCustomAttributes(EntityID)
			
		insert into #ReportCustomAttributes (EntityID)
		  select distinct ClaimID 
		    from #ResultSet
		    
		select @SecondaryResultTableName = @ResultTableName + '_CustomAttributes'   -- could be null, does not insert into permanent table when null
		
		-- Debug custom attributes when the debug flag > 1. 1 is used for debugging time stamp
		select @DebugCustomAttributes = case when @Debug > 1 then 1 else 0 end
		
		exec @internal = ii_BuildReportingDynamicSQL_ARCHDEV
							@ResultSetName = '#ResultSet_CustomAttributes',
							@ResultSetIndexName = null,
							@EntityIdName = 'ClaimID',
							@AttributeEntityType = 'CLA',  -- Claims
							@AsOfDate	  = @CustomAttributeAsOfDate,
							@AttributeID1 = @SelectedAttribute1,
							@AttributeID2 = @SelectedAttribute2,
							@AttributeID3 = @SelectedAttribute3,
							@AttributeID4 = @SelectedAttribute4,
							@AttributeID5 = @SelectedAttribute5,
							@AttributeID6 = @SelectedAttribute6,
							@AttributeID7 = @SelectedAttribute7,
							@AttributeID8 = @SelectedAttribute8,
							@AttributeID9 = @SelectedAttribute9,
							@AttributeID10 = @SelectedAttribute10,
							@ColumnList = null,
							@TableUsage = @TableUsage,
							@XMLCustomAttributes = @XMLCustomAttributes,
							@ResultTableName = @SecondaryResultTableName,
							@DebugFlag = @DebugCustomAttributes,
							@ReportSQL = @SQLCustomAttributes out,
							@ErrorMsg = @LogMsg out

		select @error = @@error
		if @error != 0
			begin
				select @ProcedureStep = 1,
					   @UserMsg = 'The Dynamic SQLCustomAttributes Build failed',
					   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV failed for SQLCustomAttributes'
				raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
				goto AppErrorExit
			end -- if @error != 0
		else if @internal != 0
			begin
				select @ProcedureStep = 1,
					   @UserMsg = 'The Dynamic SQLCustomAttributes Build encountered an error',
					   @LogMsg = 'ii_BuildReportingDynamicSQL_ARCHDEV encountered an error for SQLCustomAttributes: ' + @LogMsg
				raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
				goto AppErrorExit
			end -- else if @internal != 0
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 18.3 - ' + convert(varchar,GETDATE(),121) 
		end
		
If @ReturnReportParameters = 'Y'
	begin
		Insert Into #ResultSet_Parameters(
					Usage,DateUsage,PeriodStart,PeriodEnd,BaseTime,TimePeriod,FilterResultsetsBy,ExplanationAbbreviation,ActionCode,
					RecordType,RecordTypeIn,RecordTypeNotIn,RecordStatus,RecordStatusIn,RecordStatusNotIn,PreEstimateUsage,ClaimMasterVersion,
					FormType,FormSubtype,ClaimType, 
					ClaimStatus,ClaimStatusIn,ClaimStatusNotIn,ClaimProcessingStatus,ClaimProcessingStatusIn,ClaimProcessingStatusNotIn,ClaimNumber,
					PaymentClass,ClaimCategoryName,ClaimExplanationAbbreviation,MinimumTotalCharges,UpdatedByName,UpdatedByDepartment,
					AssignmentOfBenefits,SourceType,SourceTypeIn,SourceTypeNotIn,AdjustmentReasonCode,SuppressPayment,
					ProcedureCode,ProductCode,PlaceOfService,MinimumLineCharges,ServiceCategoryName,FeeScheduleName,PlanName,ContractName,AuthorizationNumber,  
					SourceNumber,ExternalBatchNumber,InputBatchClass , InputBatchSubclass,
					GroupNumber,GroupNumberMask,GroupLOB,GroupProductLine,GroupCoverage,GroupProductType,GroupRepricing,CompanyName,
					MemberNumber,SubscriberNumber,ProviderNumber,ProviderSpecialtyCategoryName,ProviderSpecialtySubCategoryName,
					ProviderSpecialtyName,OfficeNumber,OfficeZip,OfficeRegion,OfficeCounty,OfficeState,OfficeCountryCode,
					VendorNumber,EIN,WorkGroupID,CaseNumber,ReturnExplanations,ExplanationUsage,ReturnActionCodes,ReturnInstitutionalClaimData,
					ReturnInstitutionalAuthInfo,ReturnFinancialInformation,ReturnClaimCodes,ReturnReportParameters, ReturnClaimMasterData,
					ReturnClaimOverrides,ReturnClaimAdditionalInfo,ReturnPendingExplanation,ReturnHighestActionCode,ReturnPreEstimateReview,
					ReturnDiagnosisCodes,ReturnGroupInfo,ReturnMemberInfo,ReturnProviderInfo,ReturnOfficeInfo,ReturnVendorInfo,ReturnCheckInfo,
					ReturnUserNames,ReturnReferenceCodesName,ReturnReferenceCodesNameLength, ReturnWorkGroupInfo, ReturnClaimReimbursementLog,
					ReturnDocumentRequests, ReturnPCPInformation,ReturnPendedWorkData,ReturnReinsuranceData,ReturnOverridesFromTransform,ReturnPharmacyData,
					ReturnLockData,
					ReturnReAdjudicationWizardJobData,
					LockReason,LockClass,LockSubClass,
					ReAdjudicationWizardJobNumber,
					ReAdjudicationWizardJobClass,
					ReAdjudicationWizardJobSubClass,
					CalculateAging,AgingDateUsage,Interval,CalculateAging2,AgingDateUsage2,Interval2,OverrideUsed,
					XMLCustomAttributes,SelectedAttribute1,SelectedAttribute2,SelectedAttribute3,SelectedAttribute4,SelectedAttribute5,		
					SelectedAttribute6,SelectedAttribute7,SelectedAttribute8,SelectedAttribute9,SelectedAttribute10,CustomAttributeAsOfDate
			)
			select 
					@Usage,@DateUsage,@PeriodStart,@PeriodEnd,@BaseTime,@TimePeriod,@FilterResultsetsBy,@ExplanationAbbreviation,@ActionCode,
					@RecordType,@RecordTypeIn,@RecordTypeNotIn,@RecordStatus,@RecordStatusIn,@RecordStatusNotIn,@PreEstimateUsage,@ClaimMasterVersion,
					@FormType,@FormSubtype,@ClaimType, 
					@ClaimStatus,@ClaimStatusIn,@ClaimStatusNotIn,@ClaimProcessingStatus,@ClaimProcessingStatusIn,@ClaimProcessingStatusNotIn,@ClaimNumber,
					@PaymentClass,@ClaimCategoryName,@ClaimExplanationAbbreviation,@MinimumTotalCharges,@UpdatedByName,@UpdatedByDepartment,
					@AssignmentOfBenefits,@SourceType,@SourceTypeIn,@SourceTypeNotIn,@AdjustmentReasonCode,@SuppressPayment,
					@ProcedureCode,@ProductCode,@PlaceOfService,@MinimumLineCharges,@ServiceCategoryName,@FeeScheduleName,@PlanName,@ContractName,@AuthorizationNumber,  
					@SourceNumber,@ExternalBatchNumber,@InputBatchClass , @InputBatchSubclass,
					@GroupNumber,@GroupNumberMask,@GroupLOB,@GroupProductLine,@GroupCoverage,@GroupProductType,@GroupRepricing,@CompanyName,
					@MemberNumber,@SubscriberNumber,@ProviderNumber,@ProviderSpecialtyCategoryName,@ProviderSpecialtySubCategoryName,
					@ProviderSpecialtyName,@OfficeNumber,@OfficeZip,@OfficeRegion,@OfficeCounty,@OfficeState,@OfficeCountryCode,
					@VendorNumber,@EIN,@WorkGroupID,@CaseNumber,@ReturnExplanations,@ExplanationUsage,@ReturnActionCodes,@ReturnInstitutionalClaimData,
					@ReturnInstitutionalAuthInfo,@ReturnFinancialInformation,@ReturnClaimCodes,@ReturnReportParameters, @ReturnClaimMasterData,
					@ReturnClaimOverrides,@ReturnClaimAdditionalInfo,@ReturnPendingExplanation,@ReturnHighestActionCode,@ReturnPreEstimateReview,
					@ReturnDiagnosisCodes,@ReturnGroupInfo,@ReturnMemberInfo,@ReturnProviderInfo,@ReturnOfficeInfo,@ReturnVendorInfo,@ReturnCheckInfo,
					@ReturnUserNames,@ReturnReferenceCodesName,@ReturnReferenceCodesNameLength, @ReturnWorkGroupInfo, @ReturnClaimReimbursementLog,
					@ReturnDocumentRequests, @ReturnPCPInformation,@ReturnPendedWorkData,@ReturnReinsuranceData,@ReturnOverridesFromTransform,@ReturnPharmacyData,
					@ReturnLockData,
					@ReturnReAdjudicationWizardJobData,
					@LockReason,@LockClass,@LockSubClass,
					@ReAdjudicationWizardJobNumber,
					@ReAdjudicationWizardJobClass,
					@ReAdjudicationWizardJobSubClass,
					@CalculateAging,@AgingDateUsage,@Interval,@CalculateAging2,@AgingDateUsage2,@Interval2,@OverrideUsed,
					@XMLCustomAttributes,@SelectedAttribute1,@SelectedAttribute2,@SelectedAttribute3,@SelectedAttribute4,@SelectedAttribute5,		
					@SelectedAttribute6,@SelectedAttribute7,@SelectedAttribute8,@SelectedAttribute9,@SelectedAttribute10,@CustomAttributeAsOfDate
	end
	

--- *****************************************************************************************
--- Update Resultset columns
---
--- *****************************************************************************************

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 19 - ' + convert(varchar,GETDATE(),121) 
		end
		


		
If @ReturnPendingExplanation = 'Y'
	begin
	
		Update #ResultSet
			Set PendingExplanationID = PC.QueueId,
				PendingExplanationAbbreviation = E.Abbreviation,
				PendingStatus = PC.Status,
				PendingDate = PC.LastUpdatedAt,
				PendingDescription = CEM.Description
			from PendedClaims PC, ClaimExplanationMap CEM, Explanations E
			where #ResultSet.ClaimId = PC.ClaimId
				and #ResultSet.AdjustmentVersion = PC.AdjustmentVersion
				and PC.ClaimId = CEM.ClaimId and PC.AdjustmentVersion = CEM.AdjustmentVersion and PC.QueueId = CEM.ExplanationId
				and CEM.ExplanationId = E.ExplanationId
					
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 20 - ' + convert(varchar,GETDATE(),121) 
		end

If @ReturnHighestActionCode = 'Y'
	begin

		Update #ResultSet 
			set HighestActionCodeId		= AC.ActionCodeId,
				HighestActionCode		= AC.ActionCode,
				HighestActionCodeName	= AC.ActionCodeName,
				--HighestActionCodeEntityType
				HighestActionCodePrecedence = AC.Precedence,
				HighestActionCodeExplanationId = CAM.ExplanationId
			from ClaimActionCodeMap CAM, ActionCodes AC		
			where #Resultset.ClaimId = CAM.ClaimId 
			and #Resultset.AdjustmentVersion = CAM.AdjustmentVersion	
			and CAM.ActionCodeId = AC.ActionCodeId
			and isnull(AC.Precedence,0) >= (select MAX(isnull(Precedence,0))		-- Precedence is nullable on ActionCodes table
											from ClaimActionCodeMap CAM2, ActionCodes AC2		
												where CAM2.ClaimID = CAM.ClaimID and CAM2.AdjustmentVersion = CAM.AdjustmentVersion
													and CAM2.ActionCodeId = AC2.ActionCodeId)
					
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 21 - ' + convert(varchar,GETDATE(),121) 
		end
		
If @ReturnPreEstimateReview = 'Y'
	begin
		-- PreEstimateReview table does not have one row per adjustment version
		-- so just get the highest adjust version and the version is smaller than the version in #result set		
		update #ResultSet
		  set PreEstimateReviewStatus = PER.ReviewStatus,
			  PreEstimateReviewAdjustmentVersion = PER.AdjustmentVersion,
			  PreEstimateReviewedBy = PER.LastUpdatedBy,
			  PreEstimateReviewedAt = PER.LastUpdatedAt,
			  PreEstimateReviewExplanationID = PER.ExplanationID,
			  PreEstimateReviewExplanationAbbreviation = E.Abbreviation,
			  PreEstimateReviewStatusName = PreEstimateReviewStatusName.Name
			from PreEstimateReview PER 
			left outer join Explanations E on Per.ExplanationId = E.ExplanationId
			outer apply (
							select RC.Name [Name]
							from #ReferenceCodes RC
							where RC.Type ='PreEstimateReview' and RC.Code = PER.ReviewStatus
						) PreEstimateReviewStatusName

			  where #ResultSet.ClaimType = 'EST'
				and #ResultSet.ClaimID = PER.ClaimID 
			    and #ResultSet.LineNumber = PER.LineNumber 
			    and PER.AdjustmentVersion = (select max(PER2.AdjustmentVersion) from PreEstimateReview PER2
												where PER2.ClaimID = #ResultSet.ClaimID 
													and PER2.LineNumber = #ResultSet.LineNumber
													and PER2.AdjustmentVersion <= #ResultSet.AdjustmentVersion)
													
	end
	
If @ReturnDiagnosisCodes = 'Y'
	begin

		-- Update Diagnosis Codes for HCFA and UB claims
		update #Resultset
			set DiagnosisCode1 = left(CC.Code,10), DiagnosisCodeQual1 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 1
		
		update #Resultset
			set DiagnosisCode2 = left(CC.Code,10), DiagnosisCodeQual2 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 2
		
		update #Resultset
			set DiagnosisCode3 = left(CC.Code,10), DiagnosisCodeQual3 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 3
		
		update #Resultset
			set DiagnosisCode4 = left(CC.Code,10), DiagnosisCodeQual4 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 4
		
		update #Resultset
			set DiagnosisCode5 = left(CC.Code,10), DiagnosisCodeQual5 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 5
		
		update #Resultset
			set DiagnosisCode6 = left(CC.Code,10), DiagnosisCodeQual6 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 6
		
		update #Resultset
			set DiagnosisCode7 = left(CC.Code,10), DiagnosisCodeQual7 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 7
		
		update #Resultset
			set DiagnosisCode8 = left(CC.Code,10), DiagnosisCodeQual8 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 8
		
		update #Resultset
			set DiagnosisCode9 = left(CC.Code,10), DiagnosisCodeQual9 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 9
		
		update #Resultset
			set DiagnosisCode10 = left(CC.Code,10), DiagnosisCodeQual10 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 10
		
		update #Resultset
			set DiagnosisCode11 = left(CC.Code,10), DiagnosisCodeQual11 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 11
		
		update #Resultset
			set DiagnosisCode12 = left(CC.Code,10), DiagnosisCodeQual12 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 12
		
		update #Resultset
			set DiagnosisCode13 = left(CC.Code,10), DiagnosisCodeQual13 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 13
		
		update #Resultset
			set DiagnosisCode14 = left(CC.Code,10), DiagnosisCodeQual14 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 14
		
		update #Resultset
			set DiagnosisCode15 = left(CC.Code,10), DiagnosisCodeQual15 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 15
		
		update #Resultset
			set DiagnosisCode16 = left(CC.Code,10), DiagnosisCodeQual16 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 16
		
		update #Resultset
			set DiagnosisCode17 = left(CC.Code,10), DiagnosisCodeQual17 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 17
		
		update #Resultset
			set DiagnosisCode18 = left(CC.Code,10), DiagnosisCodeQual18 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 18
		
		update #Resultset
			set DiagnosisCode19 = left(CC.Code,10), DiagnosisCodeQual19 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 19
		
		update #Resultset
			set DiagnosisCode20 = left(CC.Code,10), DiagnosisCodeQual20 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 20
		
		update #Resultset
			set DiagnosisCode21 = left(CC.Code,10), DiagnosisCodeQual21 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 21
		
		update #Resultset
			set DiagnosisCode22 = left(CC.Code,10), DiagnosisCodeQual22 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 22
		
		update #Resultset
			set DiagnosisCode23 = left(CC.Code,10), DiagnosisCodeQual23 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 23
		
		update #Resultset
			set DiagnosisCode24 = left(CC.Code,10), DiagnosisCodeQual24 = CC.DiagnosisCodeQualifier 
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'DIAGNOSIS'
			and CC.Sequence = 24
			

				
		-- update PrincipalDiagnosisCode for UB Claims
		update #Resultset
			set PrincipalDiagnosisCode = left(CC.Code,10), PrincipalDiagQualifier = CC.DiagnosisCodeQualifier  
			from Claim_Codes CC 
			where CC.ClaimID = #Resultset.ClaimId 
			and CC.AdjustmentVersion = #Resultset.AdjustmentVersion 
			and CC.CodeType = 'PRINDIAGCODE'
			and CC.Sequence = 1
			and #Resultset.FormType = 'UB'
		
		
	end	

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 22 - ' + convert(varchar,GETDATE(),121) 
		end
	
If @ReturnClaimAdditionalInfo = 'Y'
	begin
	
		update #Resultset 
		 set ClaimExplanationAbbreviation = E.Abbreviation
		 from Explanations E
		  where #Resultset.ClaimExplanationId = E.ExplanationId
	
		update #Resultset
		 set AuthorizationNumber = A.AuthorizationNumber
		 from Authorizations A 
		  where #Resultset.AuthorizationId = A.AuthorizationID
		  
		update #ResultSet
		   set EpisodeAuthorizationNumber = A.AuthorizationNumber
		  from Authorizations A
		 where #ResultSet.EpisodeAuthorizationId = A.AuthorizationID
		 
		update #Resultset 
		 set #Resultset.CaseNumber = C.CaseNumber
		 from #Resultset R, Cases C
		  where R.CaseID = C.CaseID
  
		update #Resultset 
		 set PlanName = P.PlanName
		from BasePlans P
		where #Resultset.PlanId = P.PlanId
		
		update #Resultset set
		ServiceCategoryName = S.ServiceCategoryName,
		ServiceCategoryClass = RC.Name,
		ServiceCategorySubClass = (
									select RC2.Name 
									from ReferenceCodes RC2 with (nolock)
									where RC2.Type = 'SERVICECATEGORYSUBCLASS'
									and RC2.Subtype = RC.Name
									and RC2.Code = S.SubClass
								  )
		from #Resultset inner join ServiceCategories S
			on #Resultset.ServiceCategoryId = S.ServiceCategoryId
		left outer join ReferenceCodes RC with (nolock)
			on RC.Type = 'SERVICECATEGORYCLASS'
			and RC.Code = S.Class
	
		update #Resultset 
		 set ReferralNumber = R.ReferralNumber
		from Referrals R
		where #Resultset.ReferralId = R.ReferralID
	
		update #Resultset 
		 set LiabilityLevelName = BS.Name
		from BenefitStructures BS
		where #Resultset.LiabilityLevelId = BS.StructureId
	
		update #Resultset 
		 set LiabilityPackageName = BS.Name
		from #Resultset R, BenefitStructures BS
		where R.LiabilityPackageId = BS.StructureId
	
		update #Resultset 
		 set ReimbursementName = BS.Name
		from BenefitStructures BS
		where #Resultset.ReimbursementId = BS.StructureId
		
		update #Resultset 
		 set ContractName = C.ContractName,
		     ContractType = C.ContractType,
			 ContractTypeName = ContractTypeName.Name
		from Contracts C
			outer apply (
							select RC.Name [Name]
							from #ReferenceCodes RC
							where RC.Type = 'CONTRACTTYPE' and RC.Code = C.ContractType
						) ContractTypeName
		where #Resultset.ContractID = C.ContractID
	
		update #Resultset 
		 set FeeScheduleName = F.FeeName
		from FeeSchedule F
		where #Resultset.FeeScheduleId = F.FeeScheduleId

		update #Resultset 
		 set BenefitCategoryName = B.BnfCategoryName
		from BenefitCategories B
		where #Resultset.BenefitCategoryId = B.BnfCategoryId

		Update #Resultset
		 set ReferringOfficeName		= O.OfficeName, 
			 ReferringOfficeNumber		= O.OfficeNumber,
			 ReferringOfficeNPI			= O.NPI,
			 ReferringOfficeAddress1	= O.Address1,
			 ReferringOfficeAddress2	= O.Address2,
			 ReferringOfficeCity		= O.City,
			 ReferringOfficeState		= O.State,
			 ReferringOfficeZip			= O.Zip,
			 ReferringOfficeZipSearch	= O.ZipSearch,
			 ReferringOfficeCounty		= O.County
		from Offices O
		  where #Resultset.ReferringOfficeId = O.OfficeId 
		  			
		Update #ResultSet
		 set ReferringOfficeRegion = ZC.Region
		 from ZipCodes ZC 
		   where ZC.Zip = #ResultSet.ReferringOfficeZipSearch
		
		Update #ResultSet
		 set ProviderSpecialtyCategoryName = PS.CategoryName
		 from ProviderSpecialtyCategories PS
		   where PS.ProviderSpecialtyCategoryID = #ResultSet.ProviderSpecialtyCategoryID
		  
		Update #ResultSet
		 set ProviderSpecialtySubCategoryName = PS.CategoryName
		 from ProviderSpecialtyCategories PS
		   where PS.ProviderSpecialtyCategoryID = #ResultSet.ProviderSpecialtySubCategoryID


	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 23 - ' + convert(varchar,GETDATE(),121) 
		end

If @ReturnGroupInfo = 'Y'
	begin
		Update #ResultSet
		 Set GroupNumber		 = G.GroupNumber,
			 GroupName			 = G.GroupName,
			 GroupType			 = G.GroupType,
			 GroupLineOfBusiness = G.LOB,
			 GroupProductLine	 = G.ProductLineCode,
			 GroupCoverage		 = G.CoverageCode,
	         GroupProductType	 = G.ProductType,
			 ParentGroupId       = G.ParentId,
			 CompanyId			 = G.CompanyId,
			 CompanyName         = C.CompanyName,
			 GroupLineOfBusinessName = GroupLineOfBusinessName.Name,
			 GroupProductLineName = GroupProductLineName.Name,
			 GroupCoverageName = GroupCoverageName.Name,
			 GroupProductTypeName = GroupProductTypeName.Name
		  From Groups G
				join Companies C on G.CompanyID = C.CompanyID
				outer apply (
								select RC.Name [Name]
								from #ReferenceCodes RC	
								where RC.Type = 'LINEOFBUSINESS' and G.LOB = RC.Code
							) GroupLineOfBusinessName
				outer apply (
								select RC.Name [Name]
								from #ReferenceCodes RC	
								where RC.Type = 'ProductLine' and G.ProductLineCode = RC.Code
							) GroupProductLineName
				outer apply (
								select RC.Name [Name]
								from #ReferenceCodes RC	
								where RC.Type = 'Coverage' and G.CoverageCode = RC.Code
							) GroupCoverageName
 				outer apply (
								select RC.Name [Name]
								from #ReferenceCodes RC	
								where RC.Type = 'ProductType' and G.ProductType = RC.Code
							) GroupProductTypeName
		  Where #ResultSet.GroupId = G.GroupId 

		  update R
		   set ParentGroupNumber = G.GroupNumber,
			   ParentGroupName = G.GroupName
		  From #ResultSet R inner join Groups G on R.ParentGroupId = G.GroupID
	end
				
If @ReturnMemberInfo = 'Y'
	begin
		Update #ResultSet
		 Set MemberNumber  		= MC.MemberNumber,
			 MemberPolicyNumber	= MC.PolicyNumber,
			 RelationshipCode   = MC.RelationshipCode,
			 MemberLastName		= M.LastName,
			 MemberFirstName	= M.FirstName,
			 MemberMiddleName   = M.MiddleName,
			 MemberDateOfBirth  = M.DateOfBirth,
			 MemberAddress1		= M.Address1,
			 MemberAddress2		= M.Address2,
			 MemberCity			= M.City,
			 MemberState		= M.State,
			 MemberCounty		= M.County,
			 MemberZip			= M.Zip,
			 MemberZipSearch	= M.ZipSearch,
			 RelationshipName	= RelationshipName.Name
		  From MemberCoverages MC
				join Members M on MC.MemberId = M.MemberID
				outer apply (
								select RC.Name [Name]
								from #ReferenceCodes RC
								where RC.Type = 'RELATIONSHIPCODE' and RC.Code = MC.RelationshipCode
							) RelationshipName
		  Where MC.MemberCoverageID = #ResultSet.MemberCoverageId
			
		Update #ResultSet
		 set MemberRegion = ZC.Region,
			 MemberRegionName = MemberRegionName.Name
		 from ZipCodes ZC 
			outer apply (
							select RC.Name [Name]
							from #ReferenceCodes RC
							where RC.Type ='Region' and RC.Code = ZC.Region
						) MemberRegionName
		 where ZC.Zip = #ResultSet.MemberZipSearch
			
		Update 
			#ResultSet
		set 
			SubscriberFirstName = M.FirstName,
			SubscriberLastName 	= M.LastName,
			SubscriberNumber    = MC.MemberNumber
		from 
			MemberCoverages MC, Members M, MemberCoverages MCD
		where 
			#ResultSet.SubscriberContractId = MC.SubscriberContractID
		and 
			MC.RelationshipCode = '18' 
		and 
			MCD.MemberCoverageID = #ResultSet.MemberCoverageID
		and 
			MCD.BasePlanID = MC.BasePlanID
		and 
			MC.MemberId = M.MemberID
	end

if @ReturnTierItemInfo = 'Y'
	begin
		update #Resultset 
		 set BenefitCoverageEffectiveDate = BC.EffectiveDate,
			 BenefitCoverageExpirationDate = BC.ExpirationDate,
			 TierItemId = BC.TierItemId,
			 TierAsOfDate = BC.TierAsOfDate
		from BenefitCoverages BC
		where #Resultset.BenefitCoverageID = BC.BenefitCoverageId
		
		update #ResultSet
		  set TierItemId = BCH.TierItemID,
			  TierAsOfDate = BCH.TierAsOfDate
		    from BenefitCoveragesHistory BCH
			  where #ResultSet.TierAsOfDate <= #ResultSet.ServiceDateFrom
			    and BCH.BenefitCoverageId = #Resultset.BenefitCoverageId
				and BCH.ChangeDate = (select max(ChangeDate) from BenefitCoveragesHistory H2
														where BCH.BenefitCoverageId = H2.BenefitCoverageId 
															and H2.ChangeType = 'TRC' and H2.TierAsOfDate <= #ResultSet.ServiceDateFrom)

		update #ResultSet
		  set TierItemName = BS.Name
		    from BenefitStructures BS
			  where TierItemId = BS.StructureID
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 24 - ' + convert(varchar,GETDATE(),121) 
		end

If @ReturnProviderInfo = 'Y'
	begin
	
		Update #Resultset
		 set ProviderNumber		= P.ProviderNumber,
			 ProviderType		= P.ProviderType,
			 ProviderLastName	= P.LastName,
			 ProviderFirstName	= P.FirstName,
			 ProviderNPI	    = P.NPI
		  from Providers P
			where #Resultset.ProviderID = P.ProviderID
			
		Update #Resultset
		 set ProviderContractNumber	= PCM.ProviderContractNumber
		  from ProviderContractMap PCM
			where #Resultset.ProviderID = PCM.ProviderId
				and #Resultset.ContractId = PCM.ContractId
				and #Resultset.OfficeId = PCM.OfficeID
	end
	
If @ReturnOfficeInfo = 'Y'
	begin
	
		Update #Resultset
		 set OfficeName		= O.OfficeName, 
			 OfficeNumber	= O.OfficeNumber,
			 OfficeNPI	    = O.NPI,
			 OfficeAddress1	= O.Address1,
			 OfficeAddress2	= O.Address2,
			 OfficeCity		= O.City,
			 OfficeState	= O.State,
			 OfficeZip		= O.Zip,
			 OfficeZipSearch= O.ZipSearch,
			 OfficeCounty	= O.County,
			 OfficePhone    = O.ContactPhone
		from Offices O
		  where #Resultset.OfficeId = O.OfficeId 
		  			
		Update #ResultSet
		 set OfficeRegion	  = ZC.Region,
			 OfficeRegionName = OfficeRegionName.Name
		 from ZipCodes ZC 
			outer apply (
							select RC.Name [Name]
							from #ReferenceCodes RC
							where RC.Type ='Region' and RC.Code = ZC.Region
						) OfficeRegionName

		   where ZC.Zip = #ResultSet.OfficeZipSearch
		 
	end
	
If @ReturnVendorInfo = 'Y'
	begin
		
		Update #Resultset
		 set VendorNumber		 = V.VendorNumber,
			 VendorName			 = V.VendorName,
			 VendorNPI			 = V.NPI,
			 VendorAddress1 	 = V.Address1,
			 VendorAddress2 	 = V.Address2,
			 VendorCity 		 = V.City,
			 VendorState 		 = V.State,
			 VendorZip 			 = V.Zip,
			 VendorCountryCode	 = V.CountryCode,
			 -- Corporation Columns
			 CorporationId		 = C.CorporationId,
			 EIN				 = C.EIN,
			 EINType			 = C.EINType,
			 EINTypeName		 = EINTypeName.Name
		from Vendors V, Corporations C
			outer apply (
							select RC.Name [Name]
							from #ReferenceCodes RC
							where RC.Type ='EINType' and RC.Code = C.EINType
						) EINTypeName
		  where #Resultset.VendorId = V.VendorId
		    and V.CorporationId = C.CorporationId
  	
	end
	
If @ReturnWorkGroupInfo = 'Y'
	begin
		
		Update #Resultset
		 set PendedWorkID		= PW.PendedWorkID,
			 WorkGroupID		= PW.WorkGroupID,
			 AssignmentTypeCode = PW.AssignmentTypeCode,
			 DateAssigned		= PW.DateAssigned,
			 AssignmentType		= AssignmentType.Name
		from PendedWork PW
			outer apply (
							select RC.Name [Name]
							from #ReferenceCodes RC
							where RC.Type ='AssignmentType' and RC.Code = PW.AssignmentTypeCode	
						) AssignmentType
		  where PW.EntityType = 'CLM'
		    and #Resultset.ClaimID = PW.EntityID
		    
		---
		--- Update the Work Group fields
		---        
		update RS
		  set RS.WorkGroupName = WG.WorkGroupName,
			  RS.WorkGroupAbbreviation = WG.WorkGroupAbbreviation
			from #ResultSet RS, WorkGroups WG				
			  where RS.WorkGroupID = WG.WorkGroupID				    
  	
	end	

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 25 - ' + convert(varchar,GETDATE(),121) 
		end
		
If @ReturnCheckInfo = 'Y'
	begin
	   
	    Update #ResultSet_Financials
	     set Checkdate = C.DateCreated,
			 CheckNumber = C.CheckNumber,
			 CheckAmount = C.Amount,
			 CheckRecordType = R.RecordType,
			 WriteOffReasonCode = C.WriteOffReason
 		 from Checks C, Records R, RecordDetails RD
			where R.RecordType in ( 'PS','PR','WO') and R.ReferenceNumber = C.CheckID and R.RecordStatus != 'V'
				and RD.ITemID = #ResultSet_Financials.RecordID and RD.RecordID = R.RecordID
				
		update F
		  set F.CheckRecordTypeName = RC.Name
			from #ResultSet_Financials F, ReferenceCodes RC
			  where F.CheckRecordType = RC.Code
				and RC.Type = 'RecordType' and Subtype = 'cash'

		update F
	       set F.WriteOffReason = R.Name
	      from #ResultSet_Financials F, ReferenceCodes R
	     where R.Code = F.WriteOffReasonCode
	       and R.Type = 'WriteOffReason'
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 26 - ' + convert(varchar,GETDATE(),121) 
		end
		
	-- return Modifier reduction 	
	update RS
		set RS.ModifierReductionScheduleName = MRS.Name,
			RS.ModifierReductionScheduleID = MRS.ModifierReductionScheduleId 
	    from #ResultSet RS,	 ModifierReductionScheduleDetails MRSD,ModifierReductionSchedules  MRS
	    where RS.ModifierReductionScheduleDetailId= MRSD.ModifierReductionScheduleDetailId 
	    and MRS.ModifierReductionScheduleId = MRSD.ModifierReductionScheduleId 

	update R
		set 
			RefPhysicianName = P.LastName + ', ' + P.FirstName,
			ReferringProviderName = P.LastName + ', ' + P.FirstName
		from #ResultSet R Inner Join Providers P On R.ReferringProviderId = P.ProviderID

     
	 -- update Input Date and Date Scanned for claims keyed in using the system created input batch
	 update R
		set
			DateInput = C.InitialAdjudicationDate,
			DateScanned = C.InitialAdjudicationDate
		from #ResultSet R Inner join Claims C on R.ClaimId = C.ClaimId 
		                  inner join InputBatches I on R.InputBatchID = I.InputBatchID
			where I.SourceName = 'System Claim Batch'
	    
	 --update R 
		--set	R.ClaimTotalProviderPaid = (select Sum(Isnull(AmtToPay,0))
		--									from Claim_Results CR
		--										where R.ClaimID = CR.ClaimID 
		--										  and R.AdjustmentVersion = CR.AdjustmentVersion),
		--	R.ClaimTotalMemberPaid = (select Sum(Isnull(AmtToPayMember,0))
		--									from Claim_Results CR
		--										where R.ClaimID = CR.ClaimID 
		--										  and R.AdjustmentVersion = CR.AdjustmentVersion),
		--	R.ClaimLineTotalPaid = (select isnull(R.AmtToPay,0) + isnull(R.AmtToPayMember,0)
		--								from Claim_Results CR
		--									where R.ClaimID = CR.ClaimID
		--									  and R.AdjustmentVersion = CR.AdjustmentVersion
		--									  and R.LineNumber = CR.LineNumber)
		--from #Resultset R

	If @Usage in ('|LatestClaimLines|','|AllClaimLinesAndVersions|')
		begin
			;with cte_gettotals
			as
			(
			select 
			claimid,
			adjustmentversion,
			linenumber,
			ClaimTotalProviderPaid,
			ClaimTotalMemberPaid,
			ClaimTotalPaid,
			ClaimLineTotalPaid,
			sum(AmtToPayMember) over (partition by claimid, adjustmentversion) NewClaimTotalMemberPaid,
			sum(AmtToPay) over (partition by claimid, adjustmentversion) NewClaimTotalProviderPaid 
			from #ResultSet )
			update cte_gettotals
				set ClaimTotalProviderPaid = isnull(NewClaimTotalProviderPaid,0),
					ClaimTotalMemberPaid = isnull(NewClaimTotalMemberPaid,0),
					ClaimTotalPaid = isnull(NewClaimTotalProviderPaid,0) + isnull(NewClaimTotalMemberPaid,0),
					ClaimLineTotalPaid = isnull(ClaimLineTotalPaid,0)
		
		end
	else
		begin
			;with cte_gettotals
				as
				(
				select 
				r.claimid,
				r.adjustmentversion,
				r.ClaimTotalProviderPaid,
				r.ClaimTotalMemberPaid,
				r.ClaimTotalPaid,
				r.ClaimLineTotalPaid,
				sum(isnull(cr.AmtToPayMember,0)) over (partition by r.claimid, r.adjustmentversion) NewClaimTotalMemberPaid,
				sum(isnull(cr.AmtToPay,0)) over (partition by r.claimid, r.adjustmentversion) NewClaimTotalProviderPaid
				from #ResultSet r left outer join Claim_Results cr
						on r.claimid = cr.claimid
						and r.adjustmentversion = cr.adjustmentversion
				)
				update cte_gettotals
					set ClaimTotalProviderPaid = isnull(NewClaimTotalProviderPaid,0),
						ClaimTotalMemberPaid = isnull(NewClaimTotalMemberPaid,0),
						ClaimTotalPaid = isnull(NewClaimTotalProviderPaid,0) + isnull(NewClaimTotalMemberPaid,0),
						ClaimLineTotalPaid = isnull(ClaimLineTotalPaid,0)		
		end


	IF @ClaimType = 'EST'
		BEGIN   
			update R
				set R.AppliedClaimID = CR.ClaimID, R.AppliedClaimNumber = C.ClaimNumber, AppliedClaimLineNumber = CR.LineNumber,
					AppliedClaimProcessingStatus = C.ProcessingStatus, AppliedClaimServiceDate = CR.ServiceDateFrom, AppliedClaimLineStatus = CR.Status,
					AppliedClaimAmountToPay = CR.AmtToPay, AppliedClaimAmountToPayMember = CR.AmtToPayMember, AppliedClaimAmountCopay = CR.AmtCopay
				from #ResultSet R inner join Claim_Results CR on R.ClaimID = CR.PreEstimateClaimID and R.LineNumber = CR.PreEstimateLineNumber
									inner join Claims C on C.ClaimID = CR.ClaimID and C.AdjustmentVersion = CR.AdjustmentVersion

			If @PreEstimateUsage = '|ReturnPreEstimateLinesWithClaims|'
				begin
					Delete From #ResultSet Where AppliedClaimID is null		
				end
			Else If @PreEstimateUsage = '|ReturnPreEstimateLinesWithoutClaims|'
				begin
					Delete From #ResultSet Where AppliedClaimID is not null	
				end 

			Select @Total = Count(*) From #ResultSet
		END
	    	
If @ReturnReferenceCodesName = 'Y'
	begin
	
	    -------------------------------------------
		-- Main Resultset
		-------------------------------------------
		Update #Resultset
			set StatusName = StatusName.Name,
			ResultStatusName = ResultStatusName.Name,
			ClaimCategoryName = ClaimCategoryName.Name,
			ProcessingStatusName = ProcessingStatusName.Name,
			PaymentClassName = PaymentClassName.Name,
			BilledCurrencyName = BilledCurrencyName.Name,
			EOBActionName = EOBActionName.Name,
			InterestOnAdjustmentsName = InterestOnAdjustmentsName.Name,
			AdjustmentReasonCodeName = AdjustmentReasonCodeName.Name,
			DenialActionName = DenialActionName.Name,
			NegotiatedName = NegotiatedName.Name,
			OverrideUsedName = OverrideUsedName.Name,
			COBIndicator = COBIndicator.Name,
			FormTypeName = FormTypeName.Name,
			FormSubtypeName = FormSubtypeName.Name
		from #ResultSet
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'CLAIMSTATUS' and RC.Code = #ResultSet.Status
		) StatusName
		outer apply (  		
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'CLAIMSTATUS' and RC.Code = #ResultSet.ResultStatus
		) ResultStatusName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ClaimCategories' and RC.Code = #ResultSet.ClaimCategoryCode
		) ClaimCategoryName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ClaimProcessingStatus' and RC.Code = #ResultSet.ProcessingStatus
		) ProcessingStatusName
		outer apply (			
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'PaymentClass' and #ResultSet.Paymentclass = RC.Code
		) PaymentClassName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'CURRENCY' and #ResultSet.BilledCurrency = RC.Code
		) BilledCurrencyName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'EOBAction' and #ResultSet.EOBAction = RC.Code
		) EOBActionName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'InterestOnAdjustments' and RC.SubType = 'InterestOnAdjustments'
			and #ResultSet.InterestOnAdjustments = RC.Code
		) InterestOnAdjustmentsName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'AdjustmentReasonCodes' and RC.Code = #ResultSet.AdjustmentReasonCode
		) AdjustmentReasonCodeName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'DenialAction' and RC.Code = #ResultSet.DenialAction		
		) DenialActionName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'Negotiated' and RC.Code = #ResultSet.Negotiated
		) NegotiatedName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type ='OverrideUsed' and RC.Code = #ResultSet.OverrideUsed
		) OverrideUsedName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'COBIndicator' and RC.Code = #ResultSet.COBIndicatorCode
		) COBIndicator
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'FORMTYPE' and RC.Code = #ResultSet.FormType
		) FormTypeName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'FORMSUBTYPE' and RC.Code = #ResultSet.FormSubtype
		) FormSubtypeName


		
	    -------------------------------------------
		-- #ResultSet_Explanations
		-------------------------------------------		
		Update #ResultSet_Explanations
			set	SeverityName = SeverityName.Name,
			ExplanationCategoryTypeName = ExplanationCategoryTypeName.Name,
			DenialCategoryName = DenialCategoryName.Name,
			DenialActionName = DenialActionName.Name,
			AllowDenialName = AllowDenialName.Name,
			ExplanationClassName = ExplanationClassName.Name,
			ExplanationSubClassName = ExplanationSubClassName.Name
		from #ResultSet_Explanations
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'Severity' and RC.Code = #ResultSet_Explanations.Severity
		) SeverityName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ExplanationCategoryType' and RC.Code = #ResultSet_Explanations.ExplanationCategoryType
		) ExplanationCategoryTypeName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'DenialCategory' and RC.Code = #ResultSet_Explanations.DenialCategory
		) DenialCategoryName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'DenialAction' and RC.Code = #ResultSet_Explanations.DenialAction
		) DenialActionName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'AllowDenial' and RC.Code = #ResultSet_Explanations.AllowDenial
		) AllowDenialName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ExplanationClass' and RC.Code = #ResultSet_Explanations.ExplanationClass
		) ExplanationClassName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ExplanationSubClass' and RC.Code = #ResultSet_Explanations.ExplanationSubClass
		) ExplanationSubClassName
		
	    -------------------------------------------
		-- #ResultSet_ActionCodes
		-------------------------------------------  
		update #ResultSet_ActionCodes
	     set ActionCodeTypeName = case when ActionCodeType = 'SYS' then 'Adjudication'
								       when ActionCodeType = 'USR' then 'Payment' end,
			 AddedFromName = AddedFromName.Name,
			DateTypeName = DateTypeName.Name
		from #ResultSet_ActionCodes
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ActionCodeAddedFrom' and RC.Subtype = 'ActionCodeAddedFrom' and RC.Code =  #ResultSet_ActionCodes.AddedFrom
		) AddedFromName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ItemType' and RC.Type = 'ActionCode' and  RC.SubType = 'DateType' and RC.Code = #ResultSet_ActionCodes.DateType
		) DateTypeName
		
								
		-------------------------------------------
		-- #ResultSet_Financials
		-------------------------------------------    
		update #ResultSet_Financials
			set	RecordStatusName = RecordStatusName.Name,
			RecordTypeName = RecordTypeName.Name,
			EntityTypeName = EntityTypeName.Name,
			ItemTypeName = ItemTypeName.Name
		from #ResultSet_Financials
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'RECORDSTATUS' and RC.Code = #ResultSet_Financials.RecordStatus
		) RecordStatusName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'RECORDTYPE' and RC.Code = #ResultSet_Financials.RecordType
		) RecordTypeName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'RECORDENTITY' and RC.Subtype in ('CLAIMCHECKS','REPRICING') and RC.Code = #ResultSet_Financials.EntityType
		) EntityTypeName
		outer apply (
			select RC.Name [Name]
			from #ReferenceCodes RC
			where RC.Type = 'ItemType' and RC.Code = #ResultSet_Financials.ItemType
		) ItemTypeName
		   
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 27 - ' + convert(varchar,GETDATE(),121) 
		end
	
If @ReturnUserNames = 'Y'
	begin
		
		update RS
		set RS.LastUpdatedByName = U.FullName,
			RS.DepartmentID	= U.DeptID,
			RS.DepartmentName = D.DeptName
		from #Resultset RS, Users U, Departments D
		where RS.LastUpdatedBy = U.UserID
		  and U.DeptID = D.DeptID
		
		update RS
		set RS.PreEstimateReviewedByName = U.FullName
		from #ResultSet RS, Users U
		where RS.PreEstimateReviewedBy = U.UserID
		
		update RS
		set RS.LastUpdatedByName = U.FullName
		from #ResultSet_Explanations RS, Users U
		where RS.LastUpdatedBy = U.UserID
	
		update RS
		set RS.LastUpdatedByName = U.FullName
		from #ResultSet_ActionCodes RS, Users U
		where RS.LastUpdatedBy = U.UserID
		
	end
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 28 - ' + convert(varchar,GETDATE(),121) 
		end
		
--**********************************************************************************************
-- Calculate aging
---
----TR	Today's Date - Date Received
----TL	Today's Date - Last Updated At
----IR	Initial Adjudication Date - Date Received
----CR	Date Closed - Date Received
----CI	Date Closed - Initial Adjudication Date
----CC	Date Closed - Cleaned Date
--**********************************************************************************************


If isnull(@CalculateAging,'') != ''
  begin
		
	--- Calucluate aging differently based on the usage
	---
	
	If @CalculateAging = 'TR'  ----TR	Today's Date - Date Received
	  begin
		If isnull(@AgingDateUsage,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.DateReceived, GETDATE()) 

			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(DateReceived), 112)) Date1, convert(int, convert(varchar, GETDATE(), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging = DATEDIFF(DAY,#Resultset.DateReceived, GETDATE())
		  end
	  end
	else If @CalculateAging = 'TL' ----TL	Today's Date - Last Updated At
	  begin
		If isnull(@AgingDateUsage,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.LastUpdatedAt, GETDATE()) 

			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(LastUpdatedAt), 112)) Date1, convert(int, convert(varchar, GETDATE(), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging = DATEDIFF(DAY,#Resultset.LastUpdatedAt, GETDATE())
		  end
	  end 
	else If @CalculateAging = 'IR' ----IR	Initial Adjudication Date - Date Received
	  begin
		If isnull(@AgingDateUsage,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.DateReceived, #ResultSet.InitialAdjudicationDate) 
			
			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(DateReceived), 112)) Date1, convert(int, convert(varchar, min(InitialAdjudicationDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging = DATEDIFF(DAY,#Resultset.DateReceived, #ResultSet.InitialAdjudicationDate)
		  end
	  end 
	else If @CalculateAging = 'CR' ----CR	Date Closed - Date Received
	  begin
		If isnull(@AgingDateUsage,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.DateReceived, #Resultset.ClosedDate) 

			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(DateReceived), 112)) Date1, convert(int, convert(varchar, min(ClosedDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging = DATEDIFF(DAY,#Resultset.DateReceived, #Resultset.ClosedDate)
		  end
	  end 
	else If @CalculateAging = 'CI' ----CI	Date Closed - Initial Adjudication Date
	  begin
		If isnull(@AgingDateUsage,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.InitialAdjudicationDate, #Resultset.ClosedDate) 

			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(InitialAdjudicationDate), 112)) Date1, convert(int, convert(varchar, min(ClosedDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging = DATEDIFF(DAY,#Resultset.InitialAdjudicationDate, #Resultset.ClosedDate)
		  end
	  end 
	else If @CalculateAging = 'CC' ----CC	Date Closed - Cleaned Date
	  begin
		If isnull(@AgingDateUsage,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.CleanedDate, #Resultset.ClosedDate) 
			
			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(CleanedDate), 112)) Date1, convert(int, convert(varchar, min(ClosedDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging = DATEDIFF(DAY,#Resultset.CleanedDate, #Resultset.ClosedDate)
		  end
	  end 
	  
	If isnull(@AgingDateUsage,'') = 'BDO'  -- Business Days Only, use the ff function
		begin

			select @UPDATEAgingSQL = @CTEClaimAgingSQL +
									 ',cte_businessDays
									  as
									  (
									  select Claimid, isnull(count(*),0) DaysAging
									  from cte_claimaging cc
										inner join periods p on PeriodId > Date1 and PeriodId <= Date2 and DayType=''WORKDAY''
									  group by claimid
									  )
									  update R
										set R.DaysAging = BD.DaysAging
									  from #Resultset R
										inner join cte_businessDays BD on R.ClaimId = BD.ClaimId
									 '


			exec (@UPDATEAgingSQL)
		end


	If @Interval is null select @Interval = 5
	
	select @LengthOfString = len(convert(varchar,@Interval * 6))

	select @Value = 0
	select @Range1 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Value + @Interval),@LengthOfString)
	select @Value = @Interval + 1

	select @Range2 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval * 2),@LengthOfString)
	select @Value = @Interval + @Value

	select @Range3 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval * 3),@LengthOfString)
	select @Value = @Interval + @Value

	select @Range4 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval * 4),@LengthOfString)
	select @Value = @Interval + @Value

	select @Range5 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval * 5),@LengthOfString)
	select @Value = @Interval + @Value

	select @Range6 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval * 6),@LengthOfString)
	select @Value = @Interval + @Value

	select @Range7 = 'Over ' + convert(varchar, @Value -1)
	  
	update #Resultset 
	 set AgingRange = CASE
						WHEN abs((DaysAging-@ValuetoSubtract))/@Interval =0 then @Range1
						WHEN (DaysAging-@ValuetoSubtract)/@Interval =1 then @Range2
						WHEN (DaysAging-@ValuetoSubtract)/@Interval =2 then @Range3
						WHEN (DaysAging-@ValuetoSubtract)/@Interval =3 then @Range4
						WHEN (DaysAging-@ValuetoSubtract)/@Interval =4 then @Range5
						WHEN (DaysAging-@ValuetoSubtract)/@Interval =5 then @Range6
						WHEN (DaysAging-@ValuetoSubtract)/@Interval > 5 then @Range7
						else null 
					  END
	
  end 

-- Calculate aging 2  
If isnull(@CalculateAging2,'') != ''
  begin
		
	--- Calucluate aging differently based on the usage
	---
	
	If @CalculateAging2 = 'TR'  ----TR	Today's Date - Date Received
	  begin
		If isnull(@AgingDateUsage2,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging2 = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.DateReceived, GETDATE()) 


			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(DateReceived), 112)) Date1, convert(int, convert(varchar, GETDATE(), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage2 = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging2 = DATEDIFF(DAY,#Resultset.DateReceived, GETDATE())
		  end
	  end
	else If @CalculateAging2 = 'TL' ----TL	Today's Date - Last Updated At
	  begin
		If isnull(@AgingDateUsage2,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging2 = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.LastUpdatedAt, GETDATE()) 


			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(LastUpdatedAt), 112)) Date1, convert(int, convert(varchar, GETDATE(), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage2 = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging2 = DATEDIFF(DAY,#Resultset.LastUpdatedAt, GETDATE())
		  end
	  end 
	else If @CalculateAging2 = 'IR' ----IR	Initial Adjudication Date - Date Received
	  begin
		If isnull(@AgingDateUsage2,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging2 = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.DateReceived, #ResultSet.InitialAdjudicationDate) 


			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(DateReceived), 112)) Date1, convert(int, convert(varchar, min(InitialAdjudicationDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage2 = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging2 = DATEDIFF(DAY,#Resultset.DateReceived, #ResultSet.InitialAdjudicationDate)
		  end
	  end 
	else If @CalculateAging2 = 'CR' ----CR	Date Closed - Date Received
	  begin
		If isnull(@AgingDateUsage2,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging2 = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.DateReceived, #Resultset.ClosedDate) 


			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(DateReceived), 112)) Date1, convert(int, convert(varchar, min(ClosedDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage2 = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging2 = DATEDIFF(DAY,#Resultset.DateReceived, #Resultset.ClosedDate)
		  end
	  end 
	else If @CalculateAging2 = 'CI' ----CI	Date Closed - Initial Adjudication Date
	  begin
		If isnull(@AgingDateUsage2,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging2 = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.InitialAdjudicationDate, #Resultset.ClosedDate) 

			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(InitialAdjudicationDate), 112)) Date1, convert(int, convert(varchar, min(ClosedDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage2 = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging2 = DATEDIFF(DAY,#Resultset.InitialAdjudicationDate, #Resultset.ClosedDate)
		  end
	  end 
	else If @CalculateAging2 = 'CC' ----CC	Date Closed - Cleaned Date
	  begin
		If isnull(@AgingDateUsage2,'') = 'BDO'  -- Business Days Only, use the ff function
		  begin
			--update #Resultset 
			--	set	DaysAging2 = dbo.ff_DateDiffBusinessDays_V2 (#Resultset.CleanedDate, #Resultset.ClosedDate) 


			select @CTEClaimAgingSQL =
			';with cte_claimAging as
			(
			select ClaimId, convert(int, convert(varchar, min(CleanedDate), 112)) Date1, convert(int, convert(varchar, min(ClosedDate), 112)) Date2
			from #Resultset
			group by Claimid
			)'

		  end
		else If @AgingDateUsage2 = 'IBD' -- Include non-Business Days, use datediff
		  begin
			update #Resultset 
				set	DaysAging2 = DATEDIFF(DAY,#Resultset.CleanedDate, #Resultset.ClosedDate)
		  end
	  end 
	  
	If isnull(@AgingDateUsage2,'') = 'BDO'  -- Business Days Only, use the ff function
		begin

			select @UPDATEAgingSQL = @CTEClaimAgingSQL +
									 ',cte_businessDays
									  as
									  (
									  select Claimid, isnull(count(*),0) DaysAging
									  from cte_claimaging cc
										inner join periods p on PeriodId > Date1 and PeriodId <= Date2 and DayType=''WORKDAY''
									  group by claimid
									  )
									  update R
										set R.DaysAging2 = BD.DaysAging
									  from #Resultset R
										inner join cte_businessDays BD on R.ClaimId = BD.ClaimId
									 '


			exec (@UPDATEAgingSQL)
		end

	If @Interval2 is null select @Interval2 = 5
	
	select @LengthOfString = len(convert(varchar,@Interval2 * 6))

	select @Value = 0
	select @Range1 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Value + @Interval2),@LengthOfString)
	select @Value = @Interval2 + 1

	select @Range2 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval2 * 2),@LengthOfString)
	select @Value = @Interval2 + @Value

	select @Range3 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval2 * 3),@LengthOfString)
	select @Value = @Interval2 + @Value

	select @Range4 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval2 * 4),@LengthOfString)
	select @Value = @Interval2 + @Value

	select @Range5 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval2 * 5),@LengthOfString)
	select @Value = @Interval2 + @Value

	select @Range6 = right(replicate('0',@LengthOfString) + convert(varchar, @Value),@LengthOfString) + '-' + right(replicate('0',@LengthOfString) + convert(varchar, @Interval2 * 6),@LengthOfString)
	select @Value = @Interval2 + @Value

	select @Range7 = 'Over ' + convert(varchar, @Value -1)
	  
	update #Resultset 
	 set AgingRange2 = CASE
						WHEN abs((DaysAging2-@ValuetoSubtract))/@Interval2 =0 then @Range1
						WHEN (DaysAging2-@ValuetoSubtract)/@Interval2 =1 then @Range2
						WHEN (DaysAging2-@ValuetoSubtract)/@Interval2 =2 then @Range3
						WHEN (DaysAging2-@ValuetoSubtract)/@Interval2 =3 then @Range4
						WHEN (DaysAging2-@ValuetoSubtract)/@Interval2 =4 then @Range5
						WHEN (DaysAging2-@ValuetoSubtract)/@Interval2 =5 then @Range6
						WHEN (DaysAging2-@ValuetoSubtract)/@Interval2 > 5 then @Range7
						else null 
					  END
	
  end 

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 29 - ' + convert(varchar,GETDATE(),121) 
		end
	
-- If System Option is turned on, return stamped custom attributes on the claims. 
-- Needs distinct claimIds to do the join correctly.
If isnull(@SysOptEntityAttrValues,'') != '' 
	begin

		insert into #ReportDistinctClaimIds (ClaimID)
			select distinct ClaimID from #ResultSet
			  			  
				
				
	end  -- end of If isnull(@SysOptEntityAttrValues,'') != ''
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 30 - ' + convert(varchar,GETDATE(),121) 
		end
		
If @ReturnClaimMasterData = 'Y'
	begin
		
		insert into #ResultSet_ClaimMasterData (
			ClaimID,					AdjustmentVersion,			PCPNumber,					CarrierName,				CarrierAddress,
			CarrierCity,				CarrierState,				CarrierZip,					InsuredNumber,				InsuredName1,
			InsuredLastName,			InsuredFirstName,			InsuredMiddleName,			InsuredAddress1,			InsuredAddress2,
			InsuredCity1,				InsuredCounty1,				InsuredState1,				InsuredZip1,				InsuredCountryCode1,
			InsuredZipCodeId1,			InsuredPhone1,				InsuredGroupNumber1,		InsuredBirthDate1,			InsuredEmployer1,
			InsuredSex1,				InsurancePlanName1,			InsuredName2,				InsuredGroupNumber2,
			InsuredBirthDate2,			InsuredEmployer2,			InsuredEmplAddress2,		InsuredEmplStatus,			SubscriberEmployer,
			SubscriberEmplAddress,		InsuredSex2,				InsurancePlanName2,			MemberNumber,				PatientName,
			PatientLastName,			PatientFirstName,			PatientMiddleName,			PatientBirthDate,			PatientSex,
			PatientAddress,				PatientAddress2,			PatientCity,				PatientCounty,				PatientState,
			PatientZip,					PatientCountryCode,			PatientZipCodeId,			PatientPhone,				RelationshipCode,
			PatientEmployerName,		PatientEmployerAddress,		PatientMaritalStatus,		PatientEmplStatus,			InjuryDescription,
			AccidentDescription,		ProviderNPI,				ProviderIDNumber,			ProviderPhone,				ProviderLastName,
			ProviderFirstName,			ProviderMiddleName,			ProviderSuffix,				ProviderAddress,			ProviderAddress2,
			ProviderCity,				ProviderCounty,				ProviderState,				ProviderZip,				ProviderCountryCode,
			ProviderZipCodeId,			TaxNumber,					VendorName,					VendorAddress1,				VendorAddress2,
			VendorCity,					VendorCounty,				VendorState,				VendorZip,					VendorCountryCode,
			VendorZipCodeId,			FacilityName,				FacilityAddress1,			FacilityAddress2,			FacilityCity,
			FacilityCounty,				FacilityState,				FacilityZip,				FacilityCountryCode,		FacilityZipCodeId,
			PayToAddress1,				PayToAddress2,				PayToCity,					PayToCounty,				PayToState,
			PayToZip,					PayToCountryCode,			PayToZipCodeId,				ProviderLicense,			PlaceOfTreatment,
			ReasonForReplacement,		DateOfPriorPlacement,		TaxType,					MaxAllowable,				Deductible,
			CarrierPercentage,			PatientPays,				ProviderInfo,				FacilityInfo,				PayToInfo,
			VendorInfo,					CoveredDays,				NonCoveredDays,				CoInsuranceDays,			LifeTimeReserveDays,
			InternalControlNumber,		ReleaseInformation,			EmployerLocation,			SendTo,						AdditionalInfo,
			AdditionalPayerNumber,		ProviderNumber,				VendorNumber,				SubscriberPolicyNumber,		PayerIdentification)
		select		
			CM.ClaimID,					CM.AdjustmentVersion,		CM.PCPNumber,				CM.CarrierName,				CM.CarrierAddress,
			CM.CarrierCity,				CM.CarrierState,			CM.CarrierZip,				CM.InsuredNumber,			CM.InsuredName1,
			CM.InsuredLastName,			CM.InsuredFirstName,		CM.InsuredMiddleName,		CM.InsuredAddress1,			CM.InsuredAddress2,
			CM.InsuredCity1,			CM.InsuredCounty1,			CM.InsuredState1,			CM.InsuredZip1,				CM.InsuredCountryCode1,
			CM.InsuredZipCodeId1,		CM.InsuredPhone1,			CM.InsuredGroupNumber1,		CM.InsuredBirthDate1,		CM.InsuredEmployer1,
			CM.InsuredSex1,				CM.InsurancePlanName1,		CM.InsuredName2,			CM.InsuredGroupNumber2,
			CM.InsuredBirthDate2,		CM.InsuredEmployer2,		CM.InsuredEmplAddress2,		CM.InsuredEmplStatus,		CM.SubscriberEmployer,
			CM.SubscriberEmplAddress,	CM.InsuredSex2,				CM.InsurancePlanName2,		CM.MemberNumber,			CM.PatientName,
			CM.PatientLastName,			CM.PatientFirstName,		CM.PatientMiddleName,		CM.PatientBirthDate,		CM.PatientSex,
			CM.PatientAddress,			CM.PatientAddress2,			CM.PatientCity,				CM.PatientCounty,			CM.PatientState,
			CM.PatientZip,				CM.PatientCountryCode,		CM.PatientZipCodeId,		CM.PatientPhone,			CM.RelationshipCode,
			CM.PatientEmployerName,		CM.PatientEmployerAddress,	CM.PatientMaritalStatus,	CM.PatientEmplStatus,		CM.InjuryDescription,
			CM.AccidentDescription,		CM.ProviderNPI,				CM.ProviderIDNumber,		CM.ProviderPhone,			CM.ProviderLastName,
			CM.ProviderFirstName,		CM.ProviderMiddleName,		CM.ProviderSuffix,			CM.ProviderAddress,			CM.ProviderAddress2,
			CM.ProviderCity,			CM.ProviderCounty,			CM.ProviderState,			CM.ProviderZip,				CM.ProviderCountryCode,
			CM.ProviderZipCodeId,		CM.TaxNumber,				CM.VendorName,				CM.VendorAddress1,			CM.VendorAddress2,
			CM.VendorCity,				CM.VendorCounty,			CM.VendorState,				CM.VendorZip,				CM.VendorCountryCode,
			CM.VendorZipCodeId,			CM.FacilityName,			CM.FacilityAddress1,		CM.FacilityAddress2,		CM.FacilityCity,
			CM.FacilityCounty,			CM.FacilityState,			CM.FacilityZip,				CM.FacilityCountryCode,		CM.FacilityZipCodeId,
			CM.PayToAddress1,			CM.PayToAddress2,			CM.PayToCity,				CM.PayToCounty,				CM.PayToState,
			CM.PayToZip,				CM.PayToCountryCode,		CM.PayToZipCodeId,			CM.ProviderLicense,			CM.PlaceOfTreatment,
			CM.ReasonForReplacement,	CM.DateOfPriorPlacement,	CM.TaxType,					CM.MaxAllowable,			CM.Deductible,
			CM.CarrierPercentage,		CM.PatientPays,				CM.ProviderInfo,			CM.FacilityInfo,			CM.PayToInfo,
			CM.VendorInfo,				CM.CoveredDays,				CM.NonCoveredDays,			CM.CoInsuranceDays,			CM.LifeTimeReserveDays,
			CM.InternalControlNumber,	CM.ReleaseInformation,		CM.EmployerLocation,		CM.SendTo,					CM.AdditionalInfo,
			CM.AdditionalPayerNumber,	CM.ProviderNumber,			CM.VendorNumber,			CM.SubscriberPolicyNumber,	CM.PayerIdentification
		from 
			(
			select distinct ClaimId
			from #ResultSet
			)RS	
			inner join Claim_Master_Data CM 
				    on CM.ClaimID = RS.ClaimId
				   and CM.AdjustmentVersion = (select MIN(CM2.AdjustmentVersion) 
												 from Claim_Master_Data CM2 
												where CM2.ClaimID = RS.ClaimId)
	   
	end
	
if @ReturnClaimReimbursementLog = 'Y'
	begin
	    insert into #ResultSet_ClaimReimbursementLog(LogID,
				  								     ClaimID,
												     AdjustmentVersion,
												     LineNumber,
												     ReimbursementID,
												     ReimbursementEntityRowID,
												     Precedence,
												     ResultCode,
												     ContractID,
												     RepricedFeeCode,
												     RepricedRejectCode,
													 AmtRepriced,					
													 LineRepricedFeeCode,			
													 SuppliedUCR,					
													 RepricingOrganizationNumber,
												     Reconsider,
												     LastUpdatedByID,
												     LastUpdatedAt)
											  select CRS.LogID,
												     CRS.ClaimID,
												     CRS.AdjustmentVersion,
												     CRS.LineNumber,
												     CRS.ReimbursementID,
												     CRS.ReimbursementEntityRowID,
												     CRS.Precedence,
												     CRS.ResultCode,
												     CRS.ContractID,
												     CRS.RepricedFeeCode,
												     CRS.RepricedRejectCode,
													 CRS.AmtRepriced,					
													 CRS.LineRepricedFeeCode,			
													 CRS.SuppliedUCR,					
													 CRS.RepricingOrganizationNumber,
												     CRS.Reconsider,						   
												     CRS.LastUpdatedBy,
												     CRS.LastUpdatedAt
											    from ClaimReimbursementSelectionLog CRS	
											      where exists(select 1 from #ResultSet RS
																 where RS.ClaimID = CRS.ClaimID
																   and RS.AdjustmentVersion = CRS.AdjustmentVersion)
																	   
		  ---
		  --- Update the LastUpdatedBy
		  ---
		  update RS
		    set RS.LastUpdatedBy = U.FullName
			  from #ResultSet_ClaimReimbursementLog RS inner join Users U on RS.LastUpdatedByID = U.UserID
		    
		  ---
		  --- Update the Result
		  ---
		  update RS
		    set RS.Result = RC.Name,
			    RS.ResultDescription = RC.Description
			  from #ResultSet_ClaimReimbursementLog RS inner join ReferenceCodes RC on RS.ResultCode = RC.Code and RC.Type = 'ReimbursementSelectionResult'

		  ---
		  --- Update the Reimbursement Name
		  ---
		  update RS
		    set RS.ReimbursementName = BS.Name
			  from #ResultSet_ClaimReimbursementLog RS inner join BenefitStructures BS on RS.ReimbursementID = BS.StructureID

	     ---
		  --- Update the Reimbursement Entity Type
		  ---
		  update RS
		    set RS.EntityTypeCode = REM.EntityType
			  from #ResultSet_ClaimReimbursementLog RS inner join ReimbursementEntityMap REM on RS.ReimbursementEntityRowID = REM.RowID
		    
		  update RS
		    set RS.EntityType = RC.Name
			  from #ResultSet_ClaimReimbursementLog RS inner join ReferenceCodes RC on RS.EntityTypeCode = RC.Code and RC.Type = 'ReimbursementEntityType'
		    
		  ---
		  --- Update the repriced fields
		  ---
		  update RS
		    set RS.RepricedFeeCodeName = RC.Name
			  from #ResultSet_ClaimReimbursementLog RS inner join ReferenceCodes RC on RS.RepricedFeeCode = RC.Code and RC.Type = 'REPRICE FEECODE'
		    
		  update RS
		    set RS.RepricedRejectCodeName = RC.Name
			  from #ResultSet_ClaimReimbursementLog RS inner join ReferenceCodes RC on RS.RepricedRejectCode = RC.Code and RC.Type = 'REJECTREASON' and RC.Subtype = 'Repricing'
		
		  update RS
		    set RS.LineRepricedFeeCodeName = RC.Name
			  from #ResultSet_ClaimReimbursementLog RS inner join ReferenceCodes RC on RS.LineRepricedFeeCode = RC.Code and RC.Type = 'REPRICE FEECODE'
				
		  ---
		  --- Get the Contract Name
		  ---
		  update RS
		    set RS.ContractName = C.ContractName
			  from #ResultSet_ClaimReimbursementLog RS inner join Contracts C on RS.ContractID = C.ContractID			
			
		end	-- if @ReturnClaimReimbursementLog = 'Y
	
	
if @ReturnDocumentRequests = 'Y'
	begin
	    insert into #ResultSet_DocumentRequests
					  (    
						  DocumentRequestId,
						  RequestNumber,
						  DocumentType,
						  EntityType,
						  ClaimId,
						  AdjustmentVersion,
						  RecordId,
						  PostingRecordId,
						  JobId,
						  JobDetailId,
						  Notes,
						  Status,
						  RequestedAt,
						  RequestedByID,
						  FulfilledAt,
						  FulfilledByID,
						  SuppressionReason,
						  OriginalFulfillmentMethod,
						  FulfillmentMethod,
						  Email,
						  Fax,
						  FulfillmentID,
						  FulfillmentStatus,
						  Retries,
						  TotalNumberOfPages,
						  AttemptedFulfillmentDate,
						  FulfillmentNotes,
						  ClaimRedirectAddressId,		
						  RiskGroupId,
						  LastUpdatedAt,
						  LastUpdatedByID
					  )
				  select  D.DocumentRequestId,
						  D.RequestNumber,
						  D.DocumentType,
						  D.EntityType,
						  D.ClaimId,
						  D.AdjustmentVersion,
						  D.RecordId,
						  D.PostingRecordId,
						  D.JobId,
						  D.JobDetailId,
						  D.Notes,
						  D.Status,
						  D.RequestedAt,
						  D.RequestedBy,
						  D.FulfilledAt,
						  D.FulfilledBy,
						  D.SuppressionReason,
						  D.OriginalFulfillmentMethod,
						  D.FulfillmentMethod,
						  D.Email,
						  D.Fax,
						  D.FulfillmentID,
						  D.FulfillmentStatus,
						  D.Retries,
						  D.TotalNumberOfPages,
						  D.AttemptedFulfillmentDate,
						  D.FulfillmentNotes,
						  D.ClaimRedirectAddressId,		
						  D.RiskGroupId,
						  D.LastUpdatedAt,
						  D.LastUpdatedBy
				    from DocumentRequests D	
				      where exists(select 1 from #ResultSet RS
									 where RS.ClaimID = D.ClaimID)

			update R
				set RiskGroupName = RG.RiskGroupName
			  from #ResultSet_DocumentRequests R inner join RiskGroups RG on R.RiskGroupId = RG.RiskGroupId

			update R
				set ClaimRedirectAddressName = AA.Name
			  from #ResultSet_DocumentRequests R inner join AlternateAddress AA on R.ClaimRedirectAddressId = AA.AlternateAddressID

		  update RS
		    set RS.RequestedBy = U.FullName
			  from #ResultSet_DocumentRequests RS inner join Users U on RS.RequestedByID = U.UserID

		  update RS
		    set RS.FulfilledBy = U.FullName
			  from #ResultSet_DocumentRequests RS inner join Users U on RS.FulfilledByID = U.UserID

		  update RS
		    set RS.LastUpdatedBy = U.FullName
			  from #ResultSet_DocumentRequests RS inner join Users U on RS.LastUpdatedByID = U.UserID

		  update RS
		    set RS.StatusName = RC.Name
			  from #ResultSet_DocumentRequests RS inner join ReferenceCodes RC on RS.Status = RC.Code
				 and RC.Type = 'DocumentRequestStatus' and RC.Subtype='DocumentRequestStatus'

		  update RS
		    set RS.DocumentTypeName = RC.Name
			  from #ResultSet_DocumentRequests RS inner join ReferenceCodes RC on RS.DocumentType = RC.Code
				 and RC.Type = 'DocumentType' and RC.Subtype='Other'

		 update RS
		  set RS.SuppressionReasonName = RC.Name
			from #ResultSet_DocumentRequests RS inner join ReferenceCodes RC on RS.SuppressionReason = RC.Code
			  and RC.Type = 'SuppressionReason'

		 update RS
		  set RS.EntityTypeName = RC.Name
			from #ResultSet_DocumentRequests RS inner join ReferenceCodes RC on RS.EntityType = RC.Code
			  and RC.Type = 'DocumentEntityType' and RC.Subtype = 'DocumentEntityType'

		 update RS
		  set RS.OriginalFulfillmentMethodName = RC.Name
			from #ResultSet_DocumentRequests RS inner join ReferenceCodes RC on RS.OriginalFulfillmentMethod = RC.Code
			  and RC.Type = 'FulfillmentMethod' and RC.Subtype = 'FulfillmentMethod'

		 update RS
		  set RS.FulfillmentMethodName = RC.Name
			from #ResultSet_DocumentRequests RS inner join ReferenceCodes RC on RS.FulfillmentMethod = RC.Code
			  and RC.Type = 'FulfillmentMethod' and RC.Subtype = 'FulfillmentMethod'

		 update RS
		  set RS.FulfillmentStatusName = RC.Name
			from #ResultSet_DocumentRequests RS inner join ReferenceCodes RC on RS.FulfillmentStatus = RC.Code
			  and RC.Type = 'FulfillmentStatus'
	
	end -- end of @ReturnDocumentRequests = 'Y'
	
	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 31 - ' + convert(varchar,GETDATE(),121) 
		end

	if @ReturnInputBatches = 'Y'
		begin

			insert into #ResultSet_InputBatches
			(
				InputBatchID,
				LocationID,
				InputBatchStatus,
				InputBatchStatusName,
				SourceType,
				SourceTypeName,
				SourceName,
				SourceNumber,
				DateReceived,
				DateScanned,
				DateInput,
				ControlNumber,
				Class,
				SubClass,
				ExternalBatchNumber,
				DocumentCount,
				AutotriageCount,
				DoneDirectory,
				InputErrorMessage,
				FormType,
				FormTypeName,
				FormSubtype,
				FormSubtypeName,				
				Priority,
				OwnerID,
				LastUpdatedAt,
				LastUpdatedByID,
				LastUpdatedBy
			)
			select
				I.InputBatchID,
				I.LocationID,
				I.InputBatchStatus,
				InputBatchStatus.Name,
				I.SourceType,
				SourceType.Name,
				I.SourceName,
				I.SourceNumber,
				I.DateReceived,
				I.DateScanned,
				I.DateInput,
				I.ControlNumber,
				I.Class,
				I.SubClass,
				I.ExternalBatchNumber,
				I.DocumentCount,
				I.AutotriageCount,
				I.DoneDirectory,
				I.InputErrorMessage,
				I.FormType,
				FormType.Name,
				I.FormSubtype,
				FormSubtype.Name,
				I.Priority,
				I.OwnerID,
				I.LastUpdatedAt,
				I.LastUpdatedBy,
				Users.FullName
			from InputBatches I
			outer apply
			(
				select Name
				from ReferenceCodes RC
				where RC.Code = I.SourceType
				  and RC.Type = 'SourceTypes'
			) SourceType
			outer apply
			(
				select Name
				from ReferenceCodes RC
				where RC.Code = I.FormType
				  and RC.Type = 'FormType'
			) FormType
			outer apply
			(
				select Name
				from ReferenceCodes RC
				where RC.Code = I.FormSubtype
				  and RC.Type = 'FormSubType'
			) FormSubType
			outer apply
			(
				select Name
				from ReferenceCodes RC
				where RC.Code = I.InputBatchStatus
				  and RC.Type = 'INPUTBATCHSTATUS'
			) InputBatchStatus
			outer apply
			(
				select fullname
				from Users U
				where I.LastUpdatedBy = U.UserId
			) Users
			where exists (select 1 from #ResultSet R where I.InputBatchId = R.InputBatchID)
			
			---
			--- Add input batch id into the Explanations Resultset....
			---
			update E
			set E.InputBatchId = R.InputBatchID,
			E.MappedExplanationCategoryName =	case 
													when E.ExplanationCategoryName = 'Member' then 'Member'
													when E.ExplanationCategoryName in ('Provider','Vendor','Provider Picking') then 'Provider'
													else 'Other'
												end
			from #ResultSet_Explanations E inner join #ResultSet R
				on E.ClaimId = R.ClaimId

			update I
				set I.NoMemberIssue = Counts.NoMemberIssue,
				I.NoProviderIssue = Counts.NoProviderIssue,
				I.NoOthersIssue = Counts.NoOthersIssue,

				I.ADA2000 = Counts.VERDEN + Counts.EDIDEN,
				I.HCFA1500 = Counts.VERHCF + Counts.EDIHCF,
				I.UB92 = Counts.VERUB + Counts.EDIUB,

				I.VerifiedADA2000 = Counts.VERDEN,
				I.VerifiedHCFA1500 = Counts.VERHCF,
				I.VerifiedUB92 = Counts.VERUB,

				I.EDIADA2000 = Counts.EDIDEN,
				I.EDIHCFA1500 = Counts.EDIHCF,
				I.EDIUB92 = Counts.EDIUB,

				I.TotalVerified = Counts.VERDEN + Counts.VERHCF + Counts.VERUB,
				I.TotalEDI = Counts.EDIDEN + Counts.EDIHCF + Counts.EDIUB,

				I.Total =	(Counts.VERDEN + Counts.VERHCF + Counts.VERUB) + 
							(Counts.EDIDEN + Counts.EDIHCF + Counts.EDIUB)

			from #ResultSet_InputBatches  I
			 inner join
			(
				select 	
					IssueCounts.InputBatchID,
					Sum(abs(IssueCounts.NoMemberIssue)) as 'NoMemberIssue',
					Sum(abs(IssueCounts.NoProviderIssue)) as 'NoProviderIssue',
					Sum(abs(IssueCounts.NoOthersIssue)) as 'NoOthersIssue',

					Sum(IssueCounts.VERDEN) as 'VERDEN',
					Sum(IssueCounts.VERHCF) as 'VERHCF',
					Sum(IssueCounts.VERUB) as 'VERUB',

					Sum(IssueCounts.EDIDEN) as 'EDIDEN',
					Sum(IssueCounts.EDIHCF) as 'EDIHCF',
					Sum(IssueCounts.EDIUB) as 'EDIUB'

				from 
				(
					---
					--- This needs to handle the following cases to get the positive counts (No issues of specific types for the claim which is determined by the explanation categories on explanations present on the claim):
					---		if there were no severe explanations at all for the claim... 1 gets returned by isnull
					---		if there were no severe explanations for that claim and category (or set of categories)... -1 gets returned which will be turned into 1 by the abs() above
					---		if there were severe explanations for that claim and category... 0 gets returned so that claim will be marked as having that type of issue 
					--- max() is being used so we only count the whether or not the claim has or does not have the issue once later on when the sum is taken for the inputbatch.
					--- this is done because there could be multiple explanations on a given claim that meet a condition.
					select R.InputBatchId,
							isnull(max(case when E.MappedExplanationCategoryName = 'Member' then 0 else -1 end),1) as 'NoMemberIssue',
							isnull(max(case when E.MappedExplanationCategoryName = 'Provider' then 0 else -1 end),1) as 'NoProviderIssue',
							isnull(max(case when E.MappedExplanationCategoryName = 'Other' then 0 else -1 end),1) as 'NoOthersIssue',

							max (CASE WHEN R.FormType = 'DEN' and R.SourceType <> 'EDI' THEN 1 ELSE 0 END) as 'VERDEN',
							max (CASE WHEN R.FormType = 'HCF' and R.SourceType <> 'EDI' THEN 1 ELSE 0 END) as 'VERHCF',
							max (CASE WHEN R.FormType = 'UB' and R.SourceType <> 'EDI' THEN 1 ELSE 0 END) as 'VERUB',

							max (CASE WHEN R.FormType = 'DEN' and R.SourceType = 'EDI' THEN 1 ELSE 0 END) as 'EDIDEN',
							max (CASE WHEN R.FormType = 'HCF' and R.SourceType = 'EDI' THEN 1 ELSE 0 END) as 'EDIHCF',
							max (CASE WHEN R.FormType = 'UB' and R.SourceType = 'EDI' THEN 1 ELSE 0 END) as 'EDIUB'

					from  #ResultSet R left outer join #ResultSet_Explanations E
						on E.ClaimId = R.ClaimId
						and E.AdjustmentVersion = 1
					group By R.InputBatchId, R.ClaimId
				) IssueCounts
				group by IssueCounts.InputBatchID
			) Counts
			on  Counts.InputBatchId = I.InputBatchId

		end -- if @ReturnInputBatches = 'Y'

	if @ReturnPCPInformation = 'Y'
		begin

			insert into #ResultSet_PCPInformation
			(
				MemberProviderMapId,
				MemberId,
				SubscriberContractId,
				ContractId,
				ContractName,
				ProviderId,
				OfficeId,
				RiskGroupId,
				HospitalId,
				EffectiveDate,
				ExpirationDate,
				Precedence,
				ProviderNumber,
				LastName,
				FirstName,
				OfficeNumber,
				OfficeName,
				OfficeAddress,
				OfficeAddress2,
				OfficeCity,
				OfficeState,
				OfficeZip,
				RiskGroupName,
				RiskGroupNumber,
				RiskGroupClass,
				RiskGroupSubclass,
				HospitalName,
				HospitalNumber,
				HospitalNPI
			)
			select
				MPM.MemberProviderId,
				MPM.MEmberID,
				MPM.SubscriberContractID,
				MPM.ContractID,
				C.ContractName,
				MPM.ProviderId,
				MPM.OfficeId,
				MPM.RiskGroupID,
				MPM.HospitalID,
				MPM.EffectiveDate,
				MPM.ExpirationDate,
				MPM.Precedence,
				P.ProviderNumber,
				P.LastName,
				P.FirstName,
				O.OfficeNumber,
				O.OfficeName,
				O.Address1,
				O.Address2,
				O.City,
				O.State,
				O.Zip,
				RG.RiskGroupName,
				RG.RiskGroupNumber,
				RG.RiskGroupClass,
				RG.RiskGroupSubclass,
				isnull(P2.FirstName + ' ','') + P2.LastName,
				P2.ProviderNumber,
				P2.NPI
			from MemberProviderMap MPM	inner join Providers P on MPM.ProviderId = P.ProviderID
										inner join Offices O on MPM.OfficeID = O.OfficeID
										inner join Contracts C on MPM.ContractID = C.ContractId
										left outer join RiskGroups RG on MPM.RiskGroupID = RG.RiskGroupID
										left outer join Providers P2 on MPM.HospitalID = P2.ProviderID and P2.Hospital = 'Y'
			where exists(select 1 from #ResultSet RS
					where RS.MemberId = MPM.MEmberID
						and RS.SubscriberContractId = MPM.SubscriberContractID)

			if @RiskGroupId is not null
				begin
					delete from #ResultSet_PCPInformation where isnull(RiskGroupId,'') != @RiskGroupId
				end
			if @RiskGroupClass is not null
				begin
					delete from #ResultSet_PCPInformation where isnull(RiskGroupClass,'') != @RiskGroupClass
				end
			if @RiskGroupSubClass is not null
				begin
					delete from #ResultSet_PCPInformation where isnull(RiskGroupSubclass,'') != @RiskGroupSubClass
				end
			
			update R
			  set PrecedenceName = RC.Name
			from ReferenceCodes RC, #ResultSet_PCPInformation R 
			where RC.Type = 'PRIMARYCOVERAGE' and RC.Code = R.Precedence

			update RS
				set RS.RiskGroupClassName = R.Name
			from #ResultSet_PCPInformation RS inner join ReferenceCodes R on R.Code = RS.RiskGroupClass and R.Type = 'RiskGroupClass' and R.Subtype = 'RiskGroupClass'

			update RS
				set RS.RiskGroupSubclassName = R.Name
			from #ResultSet_PCPInformation RS inner join ReferenceCodes R on R.Code = RS.RiskGroupSubclass and R.Type = 'RiskGroupSubclass' and R.Subtype = 'RiskGroupSubclass'

			--get provider contract number
			update R
				set R.ProviderContractNumber = PCM.ProviderContractNumber
			from #ResultSet_PCPInformation R, ProviderContractMap PCM
			where
			R.ProviderID = PCM.ProviderID
			and PCM.ContractID = R.ContractId
			and (PCM.OfficeID is null or R.OfficeID = PCM.OfficeID)
			and (
					(R.RiskGroupId is null and PCM.RiskGroupID is null) 
					or (R.RiskGroupId is not null and PCM.RiskGroupID is not null and R.RiskGroupId = PCM.RiskGroupID)
				)
			and (
					(R.HospitalID is null and PCM.HospitalId is null) 
					or (R.HospitalId is not null and PCM.HospitalId is not null and R.HospitalId = PCM.HospitalId)
				)
			and PCM.AllowPanelAssignment = 'Y'
			and (
					(GETDATE() between PCM.EffectiveDate and PCM.ExpirationDate)
					or (R.ExpirationDate between PCM.EffectiveDate and PCM.ExpirationDate)
				)

			--Update main resultset with the PCP of the service date
			Update R
				set R.MemberProviderMapId		=	PCP.MemberProviderMapId,
					R.PCPContractId				=	PCP.ContractId,
					R.PCPContractName			=	PCP.ContractName,
					R.PCPProviderId				=	PCP.ProviderId,
					R.PCPOfficeId				=	PCP.OfficeId,
					R.PCPRiskGroupId			=	PCP.RiskGroupId,
					R.PCPHospitalId				=	PCP.HospitalId,
					R.PCPEffectiveDate			=	PCP.EffectiveDate,
					R.PCPExpirationDate			=	PCP.ExpirationDate,
					R.PCPPrecedence				=	PCP.Precedence,
					R.PCPPrecedenceName			=	PCP.PrecedenceName,
					R.PCPLastName				=	PCP.LastName,
					R.PCPFirstName				=	PCP.FirstName,
					R.PCPProviderNumber			=	PCP.ProviderNumber,
					R.PCPOfficeNumber			=	PCP.OfficeNumber,
					R.PCPOfficeName				=	PCP.OfficeName,
					R.PCPOfficeAddress			=	PCP.OfficeAddress,
					R.PCPOfficeAddress2			=	PCP.OfficeAddress2,
					R.PCPOfficeCity				=	PCP.OfficeCity,
					R.PCPOfficeState			=	PCP.OfficeState,
					R.PCPOfficeZip				=	PCP.OfficeZip,
					R.PCPRiskGroupName			=	PCP.RiskGroupName,
					R.PCPRiskGroupNumber		=	PCP.RiskGroupNumber,
					R.PCPRiskGroupClass			=	PCP.RiskGroupClass,
					R.PCPRiskGroupSubclass		=	PCP.RiskGroupSubclass,
					R.PCPRiskGroupClassName		=	PCP.RiskGroupClassName,
					R.PCPRiskGroupSubclassName	=	PCP.RiskGroupSubclassName,
					R.PCPHospitalName			=	PCP.HospitalName,
					R.PCPHospitalNumber			=	PCP.HospitalNumber,
					R.PCPHospitalNPI			=	PCP.HospitalNPI,
					R.PCPProviderContractNumber =	PCP.ProviderContractNumber
			from #ResultSet R inner join #ResultSet_PCPInformation PCP on R.SubscriberContractId = PCP.SubscriberContractId
																	  and R.MemberId = PCP.MemberID
																	  and R.ServiceDateFrom between PCP.EffectiveDate and PCP.ExpirationDate
																	  and PCP.Precedence = 'P'
																	  and PCP.EffectiveDate != PCP.ExpirationDate

		end

	if @ReturnPendedWorkData = 'Y'
		begin

			insert into #ResultSet_PendedWorkData
			(
				EntityId,
				WorkGroupId,
				WorkGroupName,
				AssignmentTypeCode,
				AssignmentType,
				OriginalDateAssigned,
				DateAssigned,
				AssignedToID,
				AssignedToUser,
				AssignmentReasonCode,
				AssignmentReasonName,
				AssignmentReasonNotes,
				DateToWork,
				DateDue,
				PreviousWorkGroupID,
				PreviousWorkGroupName,
				FirstTimeAddedToWorkGroup,
				LockEdited,
				LastUpdatedBy,
				LastUpdatedAt,
				History
			)
				select
				EntityId,
				PW.WorkGroupId,
				W1.WorkGroupName,
				PW.AssignmentTypeCode,
				RC1.Name, --'AssignmentType'
				OriginalDateAssigned,
				PW.DateAssigned,
				AssignedToID,
				FullName, --'AssignedToUser',
				AssignmentReasonCode,
				RC2.Name, --'AssignmentReasonName',
				AssignmentReasonNotes,
				DateToWork,
				DateDue,
				PreviousWorkGroupID,
				W2.WorkGroupName, --'PreviousWorkGroupName',
				FirstTimeAddedToWorkGroup,
				PW.LockEdited,
				PW.LastUpdatedBy,
				PW.LastUpdatedAt,
				'N' --History column
			from #Resultset RS inner join PendedWork PW on RS.claimid=PW.entityid and PW.entitytype='CLM'
				left outer join Users U on PW.assignedtoid=U.userid 
				left outer join WorkGroups W1 on PW.workgroupid=W1.workgroupid
				left outer join WorkGroups W2 on W2.workgroupid=PW.PreviousWorkGroupID
				left outer join ReferenceCodes RC1 on RC1.type='assignmenttype' and RC1.code=PW.AssignmentTypeCode
				left outer join ReferenceCodes RC2 on PW.AssignmentReasonCode=RC2.code and RC2.type='assignmentreason' and RC2.Subtype='claims'

				UNION

				select
				EntityId,
				PW.WorkGroupId,
				W1.WorkGroupName,
				PW.AssignmentTypeCode,
				RC1.Name, --'AssignmentType'
				OriginalDateAssigned,
				PW.DateAssigned,
				AssignedToID,
				FullName, --'AssignedToUser',
				AssignmentReasonCode,
				RC2.Name, --'AssignmentReasonName',
				AssignmentReasonNotes,
				DateToWork,
				DateDue,
				PreviousWorkGroupID,
				W2.WorkGroupName, --'PreviousWorkGroupName',
				FirstTimeAddedToWorkGroup,
				PW.LockEdited,
				PW.LastUpdatedBy,
				PW.LastUpdatedAt,
				'Y' --History column
			from #Resultset RS inner join PendedWorkHistory PW on RS.claimid=PW.entityid and PW.entitytype='CLM'
				left outer join Users U on PW.assignedtoid=U.userid 
				left outer join WorkGroups W1 on PW.workgroupid=W1.workgroupid
				left outer join WorkGroups W2 on W2.workgroupid=PW.PreviousWorkGroupID
				left outer join ReferenceCodes RC1 on RC1.type='assignmenttype' and RC1.code=PW.AssignmentTypeCode
				left outer join ReferenceCodes RC2 on PW.AssignmentReasonCode=RC2.code and RC2.type='assignmentreason' and RC2.Subtype='claims'
				 order by DateAssigned desc

			--- Update the Work Group fields        
			update RS
			  set RS.WorkGroupAbbreviation = WG.WorkGroupAbbreviation
				from #ResultSet_PendedWorkData RS inner join WorkGroups WG				
				   on RS.WorkGroupID = WG.WorkGroupID

			--- Update the LastUpdatedBy field
			update RS
			  set RS.LastUpdatedBy = U.FullName
				from #ResultSet_PendedWorkData RS inner join Users U
				  on RS.LastUpdatedBy = U.UserID

		end -- if @@ReturnPendedWorkData = 'Y'

	if @ReturnReinsuranceData = 'Y'
		begin

			insert into #ResultSet_ReinsuranceData
			(
				ReinsuranceUtilizationId,
				ReinsurancePolicyId,
				ReinsurancePolicyNumber,
				ReinsurancePolicyName,
				PostingRecordId,   
				PostingRecordAmount, 
				ClaimId,
				AdjustmentVersion, 
				CheckId,
				AmtApplied,
				AmtAggregate,
				AmtAggregateExcluded,
				AmtExcluded,
				FundingAmount,
				UtilizationType,
				UtilizationTypeName,
				UtilizationStatus,
				UtilizationStatusName,
				FundingType,
				FundingTypeName,
				FundingStatus,
				FundingStatusName,
				PaidDate,
				ProcessedDate,
				LastUpdatedAt,
				LastUpdatedById,
				LastUpdatedBy,
				ReinsurancePolicyMemberMapId,
				ManuallyUpdated,
				OverrideDeductibleAction,
				Notes
			)
				select 
				RU.ReinsuranceUtilizationId,
				RU.ReinsurancePolicyId,
				RP.ReinsurancePolicyNumber,
				RP.ReinsurancePolicyName,
				RU.PostingRecordId,
				R.Amount, -- PostingRecordAmount 
				RU.Claimid,
				R.AdjustmentVersion,
				RU.CheckId,
				RU.AmtApplied,
				RU.AmtAggregate,
				RU.AmtAggregateExcluded,
				RU.AmtExcluded,				
				RU.FundingAmount,
				RU.UtilizationType,
				RC4.Name, --UtilizationTypeName
				RU.UtilizationStatus,
				RC1.Name, --UtilizationStatusName
				RU.FundingType,
				RC2.Name, --FundingTypeName
				RU.FundingStatus,
				RC3.Name, --FundingStatusName
				RU.PaidDate,
				RU.ProcessedDate,
				RU.LastUpdatedAt,
				RU.LastUpdatedBy,
				U.FullName, --LastUpdatedBy
				ReinsurancePolicyMemberMapId,
				RU.ManuallyUpdated,				
				RU.OverrideDeductibleAction,
				RU.Notes
			from #Resultset RS inner join ReinsuranceUtilizations RU on RS.claimid=RU.claimid
					left outer join ReferenceCodes RC1 on RC1.code=RU.UtilizationStatus and RC1.type='ReinsuranceUtilizationStatus'
					left outer join ReferenceCodes RC2 on RC2.code=RU.FundingType and RC2.type='ReinsuranceFundingType'
					left outer join ReferenceCodes RC3 on RC3.code=RU.FundingStatus and RC3.type='ReinsuranceFundingStatus'
					left outer join ReferenceCodes RC4 on RC4.code=RU.UtilizationType and RC4.type='ReinsuranceUtilizationType'
					left outer join Users U on U.UserID=RU.LastUpdatedBy
					left outer join ReinsurancePolicy RP on RP.ReinsurancePolicyId=RU.ReinsurancePolicyID
					inner join Records R on RU.PostingRecordID = R.RecordID  

			update RS
				set FulfillmentType = PWJ.FulfillmentType,
					JobNumber = PWJ.JobNumber,
					JobStatus = PWJ.ProcessingStatus
				from #ResultSet_ReinsuranceData RS
					inner join Checks CK on CK.CheckId = RS.CheckId
					inner join PaymentWizardJobs PWJ on PWJ.JobId = CK.JobId
		
			update RS
				set RS.FulfillmentTypeName = RC.Name
				from #ResultSet_ReinsuranceData RS inner join ReferenceCodes RC
					on RS.FulfillmentType = RC.Code
						and RC.Type = 'Fulfillment'
						and RC.Subtype = 'Fulfillment'
		
			update RS
				set RS.JobStatusName = RC.Name
				from #ResultSet_ReinsuranceData RS inner join ReferenceCodes RC
					on RS.JobStatus = RC.Code
						and RC.Type = 'PaymentWizardJobStatus'

		end -- if @ReturnReinsuranceData = 'Y'

	if @ReturnOverridesFromTransform = 'Y'
		begin
			insert into #ResultSet_OverridesFromTransform
			(
			ClaimId								,
			AdjustmentVersion					,
			LineNumber							,
			ServiceCategoryId					,
			OverrideServiceRestriction			,
			OverrideLateFiling					,
			OverrideDuplicateChecking			,
			OverridePreEstimateNeeded			,
			DeductibleAmt						,
			CoinsuranceAmt						,
			CoPaymentAmt						,
			OtherPatientAmt						,
			DenyClaim							,
			ExplanationId						,
			ServiceDateReplacedWith				,
			LastUpdatedBy						,
			LastUpdatedAt						,
			OverrideReferralNeeded				,
			OverrideDenialOfRelatedProcedures	,		
			OverridePreExisting					,
			OverrideAuthorizationNeeded			,
			OverridePrimaryCareRestriction		,
			OverrideGlobalFee					,
			OverridePaymentClassWith			,
			OverrideSuppressPaymentWith			,
			OverrideClaimEditing				,
			OverrideClaimPricing				,
			OverrideDenialAction				,
			OverrideMedicalCaseReview			,
			ExplanationId2						,
			ExplanationId3						,
			OverrideContractId					,
			OverrideLiabilityLevelId			,
			OverrideBenefitCategoryId			,
			OverrideAllowedAmount				,
			OverrideAmtToPay					,
			OverrideAmtToPayMember				,
			OverrideAmtCoPay					,
			OverrideAmtCoInsurance				,
			OverrideAmtDeductible				,
			OverrideAmtPatientLiability			,
			OverrideAmtOutOfPocket				,
			OverrideMaxVisits					,
			OverrideMaxUnits					,
			OverrideMaxDollars					,
			OverrideLiabilityPackageIdHistory	,
			OverrideAmtToPenalizeMember			,
			OverrideAmtToPenalizeProvider		,
			OverrideStepDownLiabilityStepNumber	,
			OverrideAmtMoneyLimitApplied		,
			OverrideEpisodeAuthorizationId		,
			OverrideAmtPreExistingApplied		,
			OverrideAllowedUnits				,
			OverrideCOBProcessing				,
			OverrideDelegatedRule				,
			OverrideSalesTaxRate				,
			OverrideSalesTaxAmount				,
			OverrideGender						, 
			OverrideDOB							, 
			OverrideRelationshipCode			,
			OverrideWithholdPercentage			, 
			OverrideWithholdAmount				,
			PreAdjudicationTransform			,
			PostAdjudicationTransform			,
			Disabled							
			)
			select
			CT.ClaimId								,
			CT.AdjustmentVersion					,
			CT.LineNumber							,
			CT.ServiceCategoryId					,
			CT.OverrideServiceRestriction			,
			CT.OverrideLateFiling					,
			CT.OverrideDuplicateChecking			,
			CT.OverridePreEstimateNeeded			,
			CT.DeductibleAmt						,
			CT.CoinsuranceAmt						,
			CT.CoPaymentAmt							,
			CT.OtherPatientAmt						,
			CT.DenyLine								,
			CT.ExplanationId						,
			CT.ServiceDateReplacedWith				,
			CT.LastUpdatedBy						,
			CT.LastUpdatedAt						,
			CT.OverrideReferralNeeded				,
			CT.OverrideDenialOfRelatedProcedures	,	
			CT.OverridePreExisting					,
			CT.OverrideAuthorizationNeeded			,
			CT.OverridePrimaryCareRestriction		,
			CT.OverrideGlobalFee					,
			CT.OverridePaymentClassWith				,
			CT.OverrideSuppressPaymentWith			,
			CT.OverrideClaimEditing					,
			CT.OverrideClaimPricing					,
			CT.OverrideDenialAction					,
			CT.OverrideMedicalCaseReview			,
			CT.ExplanationId2						,
			CT.ExplanationId3						,
			CT.OverrideContractId					,
			CT.OverrideLiabilityLevelId				,
			CT.OverrideBenefitCategoryId			,
			CT.OverrideAllowedAmount				,
			CT.OverrideAmtToPay						,
			CT.OverrideAmtToPayMember				,
			CT.OverrideAmtCoPay						,
			CT.OverrideAmtCoInsurance				,
			CT.OverrideAmtDeductible				,
			CT.OverrideAmtPatientLiability			,
			CT.OverrideAmtOutOfPocket				,
			CT.OverrideMaxVisits					,
			CT.OverrideMaxUnits						,
			CT.OverrideMaxDollars					,
			CT.OverrideLiabilityPackageIdHistory	,
			CT.OverrideAmtToPenalizeMember			,
			CT.OverrideAmtToPenalizeProvider		,
			CT.OverrideStepDownLiabilityStepNumber	,
			CT.OverrideAmtMoneyLimitApplied			,
			CT.OverrideEpisodeAuthorizationId		,
			CT.OverrideAmtPreExistingApplied		,
			CT.OverrideAllowedUnits					,
			CT.OverrideCOBProcessing				,
			CT.OverrideDelegatedRule				,
			CT.OverrideSalesTaxRate					,
			CT.OverrideSalesTaxAmount				,
			CT.OverrideGender						, 
			CT.OverrideDOB							, 
			CT.OverrideRelationshipCode				,
			CT.OverrideWithholdPercentage			, 
			CT.OverrideWithholdAmount				,
			CT.PreAdjudicationTransform				,
			CT.PostAdjudicationTransform			,
			Disabled							
			from 
			(
				select distinct ClaimId, AdjustmentVersion
				from #ResultSet
			)RS	
			inner join Claim_Overrides_Transform CT on CT.ClaimId=RS.ClaimId and CT.AdjustmentVersion = RS.AdjustmentVersion

		end

	if exists (select 1 from #ResultSet R inner join EDIJobs E on R.InputBatchID = E.InputBatchId)
		begin
			update R
			set EDIJobNumber = E.EDIJobNumber,
				EDIExternalFileName = F.ExternalFileName
			from #ResultSet R inner join EDIJobs E on R.InputBatchID = E.InputBatchId
				inner join EDIFiles F on E.EDIFileId = F.EDIFileID
		end
		
  if @ReturnPharmacyData = 'Y'
	  begin
		insert into #ResultSet_Pharmacy
					  (
						ClaimID,
						AdjustmentVersion,
						LineNumber,
						PrescriberID,
						PrescriberNumber,
						PrescriberNumberQualifier,
						PharmacistID,
						PharmacistNumber,
						PharmacistNumberQualifier,
						PrescriptionNumber,
						PrescriptionNumberQualifier,
						RefillNumber,
						DateWritten,
						SubmissionClarificationCode,
						PrescriptionOrigin,
						PharmacyServiceType,
						SpecPackIndicator,
						DaysSupply,
						DispenseAsWritten,
						ReasonForServiceCode,
						ProfessionalServiceCode,
						ResultOfServiceCode,
						LevelOfEffortCode,
						DosageFormCode,
						DispensingUnit,
						RouteOfAdministrationCode,
						IngredientComponentCount,
						CompoundCode,
						UsualAndCustomaryCharge,
						BasisOfCost,
						IngredientTotalCharges,
						DispensingFeeSubmitted,
						ProfessionalServiceFeeSubmitted,
						IncentiveAmountSubmitted,
						OtherAmountSubmitted,
						ProcessForApprovedIngredients
					  )
				  select  
						Rx.ClaimID,
						Rx.AdjustmentVersion,
						Rx.LineNumber,
						Rx.PrescriberID,
						Rx.PrescriberNumber,
						Rx.PrescriberNumberQualifier,
						Rx.PharmacistID,
						Rx.PharmacistNumber,
						Rx.PharmacistNumberQualifier,
						Rx.PrescriptionNumber,
						Rx.PrescriptionNumberQualifier,
						Rx.RefillNumber,
						Rx.DateWritten,
						Rx.SubmissionClarificationCode,
						Rx.PrescriptionOrigin,
						Rx.PharmacyServiceType,
						Rx.SpecPackIndicator,
						Rx.DaysSupply,
						Rx.DispenseAsWritten,
						Rx.ReasonForServiceCode,
						Rx.ProfessionalServiceCode,
						Rx.ResultOfServiceCode,
						Rx.LevelOfEffortCode,
						Rx.DosageFormCode,
						Rx.DispensingUnit,
						Rx.RouteOfAdministrationCode,
						Rx.IngredientComponentCount,
						Rx.CompoundCode,
						Rx.UsualAndCustomaryCharge,
						Rx.BasisOfCost,
						Rx.IngredientTotalCharges,
						Rx.DispensingFeeSubmitted,
						Rx.ProfessionalServiceFeeSubmitted,
						Rx.IncentiveAmountSubmitted,
						Rx.OtherAmountSubmitted,
						Rx.ProcessForApprovedIngredients
			from  Claim_Details_Rx Rx 
				inner join #Resultset RS on RS.ClaimId = Rx.ClaimID and RS.AdjustmentVersion = Rx.AdjustmentVersion 
					and RS.LineNumber = Rx.LineNumber and RS.FormType = 'Rx' 

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 32 - ' + convert(varchar,GETDATE(),121) 
		end

	end

	if @ReturnClaimCOB = 'Y'
		begin
			insert into #ResultSet_ClaimCOBData(
					ClaimID,
					AdjustmentVersion,
					COBIndicator,
					RemittanceDate,
					AmtBilled,
					AmtAllowed,
					AmtDeductible,
					AmtCopay,
					AmtSequestration,
					AmtCoinsurance,
					AmtOtherPatientLiability,
					AmtRemainingPatientLiability,
					AmtPaid,
					AmtContractAdjustment,
					AmtDenied,
					AmtNonCovered,
					PayerId,
					PayerNumberQualifier,
					PayerNumber,
					RelationshipToSubscriberCode,
					PayerGroupNumber,
					PayerEmpName,
					InsuranceTypeCode,
					ClaimFilingIndicatorCode,
					PolicyHolderFirstName,
					PolicyHolderLastName,
					PolicyHolderMiddleName,
					PayerMemberNumber,
					PolicyHolderAddress1,
					PolicyHolderAddress2,
					PolicyHolderCity,
					PolicyHolderState,
					PolicyHolderZip,
					PolicyHolderCountryCode,
					PolicyHolderSSN,
					PayerName,
					PayerAddress1,
					PayerAddress2,
					PayerCity,
					PayerState,
					PayerZip,
					PayerCountryCode)
			select CC.ClaimID,
					CC.AdjustmentVersion,
					CC.COBIndicator,
					CC.RemittanceDate,
					CC.AmtBilled,
					CC.AmtAllowed,
					CC.AmtDeductible,
					CC.AmtCopay,
					CC.AmtSequestration,
					CC.AmtCoinsurance,
					CC.AmtOtherPatientLiability,
					CC.AmtRemainingPatientLiability,
					CC.AmtPaid,
					CC.AmtContractAdjustment,
					CC.AmtDenied,
					CC.AmtNonCovered,
					CC.PayerId,
					CC.PayerNumberQualifier,
					CC.PayerNumber,
					CC.RelationshipToSubscriberCode,
					CC.PayerGroupNumber,
					CC.PayerEmpName,
					CC.InsuranceTypeCode,
					CC.ClaimFilingIndicatorCode,
					CC.PolicyHolderFirstName,
					CC.PolicyHolderLastName,
					CC.PolicyHolderMiddleName,
					CC.PayerMemberNumber,
					CC.PolicyHolderAddress1,
					CC.PolicyHolderAddress2,
					CC.PolicyHolderCity,
					CC.PolicyHolderState,
					CC.PolicyHolderZip,
					CC.PolicyHolderCountryCode,
					CC.PolicyHolderSSN,
					CC.PayerName,
					CC.PayerAddress1,
					CC.PayerAddress2,
					CC.PayerCity,
					CC.PayerState,
					CC.PayerZip,
					CC.PayerCountryCode
		from ClaimCOBData CC 
		where exists(select 1 from #Resultset C where CC.ClaimId = C.ClaimId and CC.AdjustmentVersion = C.AdjustmentVersion)

		update R
		set PayerName = P.PayerName
		from #ResultSet_ClaimCOBData R inner join Payers P on R.PayerId = P.PayerId

		update R
		set RelationshipToSubscriber = RC.Name
		from #ResultSet_ClaimCOBData R inner join ReferenceCodes RC on R.RelationshipToSubscriberCode = RC.Code
		where RC.type = 'RELATIONSHIPCODE'

		update R
		set PolicyHolderCountry = C.CountryName
		from #ResultSet_ClaimCOBData R inner join Countries C on R.PolicyHolderCountryCode = C.CountryCode

		update R
		set PayerCountry = C.CountryName
		from #ResultSet_ClaimCOBData R inner join Countries C on R.PayerCountryCode = C.CountryCode

		insert into #ResultSet_ClaimCOBDataDetails(
					ClaimID,
					LineNumber,
					AdjustmentVersion,
					COBIndicator,
					RemittanceDate,
					AmtBilled,
					AmtAllowed,
					AmtDeductible,
					AmtCopay,
					AmtSequestration,
					AmtCoinsurance,
					AmtOtherPatientLiability,
					AmtRemainingPatientLiability,
					AmtPaid,
					AmtContractAdjustment,
					AmtDenied,
					AmtNonCovered)
			select CC.ClaimID,
					CC.LineNumber,
					CC.AdjustmentVersion,
					CC.COBIndicator,
					CC.RemittanceDate,
					CC.AmtBilled,
					CC.AmtAllowed,
					CC.AmtDeductible,
					CC.AmtCopay,
					CC.AmtSequestration,
					CC.AmtCoinsurance,
					CC.AmtOtherPatientLiability,
					CC.AmtRemainingPatientLiability,
					CC.AmtPaid,
					CC.AmtContractAdjustment,
					CC.AmtDenied,
					CC.AmtNonCovered
			from ClaimCOBDataDetails CC inner join #Resultset C  
				on CC.ClaimId = C.ClaimId and CC.AdjustmentVersion = C.AdjustmentVersion and CC.LineNumber = C.LineNumber

		Insert Into #ResultSet_ClaimCARCsRARCs (
				ClaimId,	
				AdjustmentVersion,	
				LineNumber,	
				ExplanationCategoryName	, 	
				AdjustmentReasonOrRemark, 
				Explanation	,	
				ExplanationCode,  	 	
				GroupCode,	
				Amount)
		select  ClaimId,CE.AdjustmentVersion,CE.LineNumber,
				EC.ExplanationCategoryName, E.Abbreviation,E.Explanation, E.ExplanationCode,
				CE.Parameter2,CE.Parameter3
			from ClaimExplanationMap CE
			inner join Explanations E on CE.ExplanationId = E.ExplanationId
			inner join ExplanationCategories EC on EC.ExplanationCategoryId = E.ExplanationCategoryId
			where exists (select 1 from #ResultSet RS where RS.ClaimId = CE.ClaimId and Rs.AdjustmentVersion = CE.AdjustmentVersion)
				  and (EC.ExplanationCategoryName = 'ADJUSTMENTREASON' or EC.ExplanationCategoryName = 'REMARK')
				  	  
	end

	--------------------------------------------------
	---- TIME STAMP-----------------------------------
	--------------------------------------------------
	If @Debug > 0
		begin
			print N'SP Step 33 - ' + convert(varchar,GETDATE(),121) 
		end

if @ReturnLTCData = 'Y'
	begin
		Insert Into #ResultSet_LongTermCareData( LongTermCareId,   DocumentId,				ExternalClaimNumber,		InputBatchId,			ProviderNumber,
												ZipCode,			ProviderId,				OfficeId,					VendorId,				DateBilled,
												Signed,				LineNumber,					Deleted,	
												ClaimId,			MemberNumber,			MemberId,					MemberCoverageId,		ExternalAuthorizationNumber,
												AuthorizationId,	MedicalRecordNumber,	AttendingPhysician,			AttendingPhysicianId,	BillingLimitExceptions,
												ServiceDateFrom,	ServiceDateTo,			ProcedureCode,				PrimaryDiagnosisCode,	PatientStatus,
												GrossAmount,		PatientLiability_MedicareDeduct,					MedicareType,			OtherCoverage,			NetAmountBilled,
												Attachments,		CG,
												PointOfEligibility,	WaiveBilling,			ProcessingStatus,			LastUpdatedAt,			LastUpdatedBy)
		select  
					M.LongTermCareId,		M.DocumentId,				M.ExternalClaimNumber,		M.InputBatchId,			M.ProviderNumber,
					M.ZipCode,				M.ProviderId,				M.OfficeId,					M.VendorId,				M.DateBilled,
					M.Signed,				D.LineNumber,				D.Deleted,	
					D.ClaimId,				D.MemberNumber,				D.MemberId,					D.MemberCoverageId,		D.ExternalAuthorizationNumber,
					D.AuthorizationId,		D.MedicalRecordNumber,		D.AttendingPhysician,		D.AttendingPhysicianId,	D.BillingLimitExceptions,
					D.ServiceDateFrom,		D.ServiceDateTo,			D.ProcedureCode,			D.PrimaryDiagnosisCode,	D.PatientStatus,
					D.BilledAmount,			D.ShareOfCostAmount,		D.MedicareType,				D.OtherCoverage,		D.NetAmountBilled,
					D.Attachments,			D.CG,
					D.PointOfEligibility,	D.WaiveBilling,				D.ProcessingStatus,			M.LastUpdatedAt,		M.LastUpdatedBy
			from(
				select distinct ClaimId
				from #ResultSet where FormType = 'UB' and FormSubtype = 'LTC')RS
			inner join LongTermCare_Details D on RS.ClaimId = D.ClaimID
			inner join LongTermCare_Master M on D.LongTermCareId = M.LongTermCareId

	end

if @ReturnScreeningData in ('R', 'RD')
	begin
			select @ScreeningSQLInsert = 'ScreeningVisitId,	ScreeningFormName,DocumentId,ExternalClaimNumber,InputBatchId,ProcessingStatus'
											+',ClaimId,PatientLastName,PatientFirstName,PatientMiddleName,PatientBirthDate,PatientSex,Age,PatientLocation'
											+',MemberNumber,MemberId,MemberCoverageId,NextCHDPExam,ScreeningRecheck,PriorScreeningDate,ResponsiblePartyLastName'
											+',ResponsiblePartyFirstName,ResponsiblePartyAddress1,ResponsiblePartyAddress2,ResponsiblePartyCity,ResponsiblePartyState'
											+',ResponsiblePartyZip,EthnicityCode,DateOfService,HeightInInches,WeightLbs,WeightOzs,BMIPercent,BloodPressureSystolic'
											+',BloodPressureDiastolic,Hemoglobin,Hematocrit,BirthWeightLbs,BirthWeightOzs,PatientVisit,TypeOfScreen,TotalCharges'
											+',ProviderNumber,EIN,ZipCode,ProviderId,OfficeId,VendorId,PlaceOfService,ReferredToLastName1,ReferredToFirstName1,ReferredToPhone1'
											+',ReferredToLastName2,ReferredToFirstName2,ReferredToPhone2,Comments,BloodLeadReferral,DentalReferral,FosterChild,DiagnosisCode1'
											+',DiagnosisCode2,DiagnosisCode3,DiagnosisCode4,DiagnosisCode5,DiagnosisCode6,ExposedToTobacco,UsesTobacco,CounseledAboutTobacco'
											+',EnrolledInWIC,ReferredToWIC,PartialScreen,CoveredByMediCal,CoveredByCHDPOnly,DateBilled,Signed'
											+',NumberOfPages,MedicalRecordNumber,LastUpdatedAt,LastUpdatedBy,OverriddenFlag,OverriddenAt,OverriddenBy'
		
			select @ScreeningSQLSelect =  'M.ScreeningVisitId,M.ScreeningFormName,M.DocumentId,M.ExternalClaimNumber,M.InputBatchId,M.ProcessingStatus'
											+',M.ClaimId,M.PatientLastName,M.PatientFirstName,M.PatientMiddleName,M.PatientBirthDate,M.PatientSex,M.Age,M.PatientLocation'
											+',M.MemberNumber,M.MemberId,M.MemberCoverageId,M.NextCHDPExam,M.ScreeningRecheck,M.PriorScreeningDate,M.ResponsiblePartyLastName'
											+',M.ResponsiblePartyFirstName,M.ResponsiblePartyAddress1,M.ResponsiblePartyAddress2,M.ResponsiblePartyCity,M.ResponsiblePartyState'
											+',M.ResponsiblePartyZip,M.EthnicityCode,M.DateOfService,M.HeightInInches,M.WeightLbs,M.WeightOzs,M.BMIPercent,M.BloodPressureSystolic'
											+',M.BloodPressureDiastolic,M.Hemoglobin,M.Hematocrit,M.BirthWeightLbs,M.BirthWeightOzs,M.PatientVisit,M.TypeOfScreen,M.TotalCharges'
											+',M.ProviderNumber,M.EIN,M.ZipCode,M.ProviderId,M.OfficeId,M.VendorId,M.PlaceOfService,M.ReferredToLastName1,M.ReferredToFirstName1,M.ReferredToPhone1'
											+',M.ReferredToLastName2,M.ReferredToFirstName2,M.ReferredToPhone2,M.Comments,M.BloodLeadReferral,M.DentalReferral,M.FosterChild,M.DiagnosisCode1'
											+',M.DiagnosisCode2,M.DiagnosisCode3,M.DiagnosisCode4,M.DiagnosisCode5,M.DiagnosisCode6,M.ExposedToTobacco,M.UsesTobacco,M.CounseledAboutTobacco'
											+',M.EnrolledInWIC,M.ReferredToWIC,M.PartialScreen,M.CoveredByMediCal,M.CoveredByCHDPOnly,M.DateBilled,M.Signed'
											+',M.NumberOfPages,M.MedicalRecordNumber,M.LastUpdatedAt,M.LastUpdatedBy,OverriddenFlag,OverriddenAt,OverriddenBy'

			select @ScreeningSQLFrom = '(select distinct ClaimId from #ResultSet where FormType = ''HCF'' and FormSubtype = ''BR'') RS'
									+' inner join ScreeningVisit_Master M on RS.ClaimId = M.ClaimId'
			
		
		--Get details if user selected the option to return data with details
		If @ReturnScreeningData = 'RD'	 
		  begin
			select @ScreeningSQLInsert = @ScreeningSQLInsert  +',DetailType,Code,Description,ProblemStatus,FollowUpCode1,FollowUpCode1b,FollowUpCode2'
																+',FollowUpCode2b,VaccineStatus,Amount'
			
			select @ScreeningSQLSelect = @ScreeningSQLSelect + ',D.DetailType,D.Code,D.Description,D.ProblemStatus,D.FollowUpCode1,D.FollowUpCode1b,D.FollowUpCode2'
																+',D.FollowUpCode2b,D.VaccineStatus,D.Amount'
																						
			select @ScreeningSQLFrom = @ScreeningSQLFrom + ' inner join ScreeningVisit_Details D on M.ScreeningVisitId = D.ScreeningVisitId'		
		  end
		  
				--------------------------------------------------------------
				------ Debug -------------------------------------------------
				--------------------------------------------------------------
				If @Debug > 0
					begin
						select 'Complete Dynamic SQL for #ResultSet_ScreeningVisitData Resultset'		
						select 'Insert Into #ResultSet_ScreeningVisitData(' 
											 + @ScreeningSQLInsert + ')'
								+ ' Select ' + @ScreeningSQLSelect 
								  + ' From ' + @ScreeningSQLFrom 								  
					end
		
		Exec('Insert Into #ResultSet_ScreeningVisitData(' 
							 + @ScreeningSQLInsert + ')'
				+ ' Select ' + @ScreeningSQLSelect 
				  + ' From ' + @ScreeningSQLFrom)
		update 
			RS
		set 
			RS.OverriddenByName = U.FullName
		from 
			#ResultSet_ScreeningVisitData RS inner join Users U
			on RS.OverriddenBy = U.UserID

	end

if @ReturnMedi_CalPharmacyData in ('R', 'RD')
	begin
			select @Medi_CalPharmacySQLInsert = 'PharmacyEntryId,DocumentId,ExternalClaimNumber,InputBatchId,ProcessingStatus,ClaimId,ProviderNumber'
											+',ZipCode,ProviderId,OfficeId,VendorId,MemberNumber,MemberId,MemberCoverageId,MedicareStatus,PlaceOfService'
											+',MedicalRecordNumber,BillingLimitExceptions,Attachments,DateBilled,DischargeDate,TotalAmount,ShareOfCost'
											+',CG,PointOfEligibility,WaiveBilling,Signed,LastUpdatedAt,LastUpdatedBy'
		
			select @Medi_CalPharmacySQLSelect =  'M.PharmacyEntryId,M.DocumentId,M.ExternalClaimNumber,M.InputBatchId,M.ProcessingStatus,M.ClaimId,M.ProviderNumber'
											+',M.ZipCode,M.ProviderId,M.OfficeId,M.VendorId,M.MemberNumber,M.MemberId,M.MemberCoverageId,M.MedicareStatus,M.PlaceOfService'
											+',M.MedicalRecordNumber,M.BillingLimitExceptions,M.Attachments,M.DateBilled,M.DischargeDate,M.TotalAmount,M.ShareOfCost'
											+',M.CG,M.PointOfEligibility,M.WaiveBilling,M.Signed,M.LastUpdatedAt,M.LastUpdatedBy'

			select @Medi_CalPharmacySQLFrom = '(select distinct ClaimId from #ResultSet where FormType = ''RX'' and FormSubtype = ''301'')RS'
									+' inner join PharmacyEntry_Master M on RS.ClaimId = M.ClaimId'
			
		
		--Get details if user selected the option to return data with details
		If @ReturnMedi_CalPharmacyData = 'RD'	 
		  begin
			select @Medi_CalPharmacySQLInsert = @Medi_CalPharmacySQLInsert  + ',LineNumber,PrescriptionNumber,ServiceDateFrom,ProductQuantity,Code1Met,DaysSupply'
																			+',BasisOfCost,ProductCodeQualifier,ProductCode,PrescriberNumberQualifier,PrescriberNumber'
																			+',DiagnosisCode1,DiagnosisCode2,BilledAmount,COB,OtherCoverageCode,AuthorizationNumber'
																			+',AuthorizationId,CompoundCode'
			
			select @Medi_CalPharmacySQLSelect = @Medi_CalPharmacySQLSelect + ',D.LineNumber,D.PrescriptionNumber,D.ServiceDateFrom,D.ProductQuantity,D.Code1Met,D.DaysSupply'
																			+',D.BasisOfCost,D.ProductCodeQualifier,D.ProductCode,D.PrescriberNumberQualifier,D.PrescriberNumber'
																			+',D.DiagnosisCode1,D.DiagnosisCode2,D.BilledAmount,D.COB,D.OtherCoverageCode,D.AuthorizationNumber'
																			+',D.AuthorizationId,D.CompoundCode'
																						
			select @Medi_CalPharmacySQLFrom = @Medi_CalPharmacySQLFrom + ' inner join PharmacyEntry_Details D on M.PharmacyEntryId = D.PharmacyEntryId'		
		  end
		  
				--------------------------------------------------------------
				------ Debug -------------------------------------------------
				--------------------------------------------------------------
				If @Debug > 0
					begin
						select 'Complete Dynamic SQL for #ResultSet_Medi_CalPharmacyData Resultset'		
						select 'Insert Into #ResultSet_Medi_CalPharmacyData(' 
											 + @Medi_CalPharmacySQLInsert + ')'
								+ ' Select ' + @Medi_CalPharmacySQLSelect 
								  + ' From ' + @Medi_CalPharmacySQLFrom 								  
					end
		
		Exec('Insert Into #ResultSet_Medi_CalPharmacyData(' 
							 + @Medi_CalPharmacySQLInsert + ')'
				+ ' Select ' + @Medi_CalPharmacySQLSelect 
				  + ' From ' + @Medi_CalPharmacySQLFrom)

	end

if @ReturnLockData = 'Y'
	begin
		select @Lock_SQLInsert =
			'insert into #ResultSet_LockData
				(
					EntityNumber,
					LockId,
					EntityId,
					EntityType,
					LockNumber,
					Description,
					Reason,
					ExternalNumber,
					Class,
					SubClass,
					EffectiveDate,
					ExpirationDate,
					AddedBy,
					AddedAt,
					LastUpdatedBy,
					LastUpdatedAt
				)
			'

		select @Lock_SQLSelect = 
			'select
				 	distinct RS.ClaimNumber,
					L.LockId,
					L.EntityId,
					L.EntityType,
					L.LockNumber,
					L.Description,
					L.Reason,
					L.ExternalNumber,
					L.Class,
					L.SubClass,
					L.EffectiveDate,
					L.ExpirationDate,
					L.AddedBy,
					L.AddedAt,
					L.LastUpdatedBy,
					L.LastUpdatedAt
			'

		select @Lock_SQLFrom = 
			'from Locks L inner join #ResultSet RS
					on L.EntityId = RS.ClaimId and L.EntityType = ''CLM''
			'

		if @FilterResultsetsBy = 'ALC'		-- All Resultsets by Locks
			begin
				select @Lock_SQLWhere =
					'where
						1 = 1' +
					case when @LockReason is null then '' else ' and L.Reason = ''' + @LockReason + '''' end +
					case when @LockClass is null then '' else ' and L.Class = ''' + @LockClass + '''' end +
					case when @LockSubClass is null then '' else ' and L.SubClass = ''' + @LockSubClass + '''' end
			end
		else
			begin
				select @Lock_SQLWhere = ''
			end

		select @Lock_SQLOrderBy = '
								   order by RS.ClaimNumber asc, L.LockNumber asc'

								if @Debug > 0
									begin
										select
											'Dynamic SQL for #ResultSet_LockData',
											@Lock_SQLInsert + @Lock_SQLSelect + @Lock_SQLFrom + @Lock_SQLWhere + @Lock_SQLOrderBy
									end

		exec (@Lock_SQLInsert + @Lock_SQLSelect + @Lock_SQLFrom + @Lock_SQLWhere + @Lock_SQLOrderBy)
			
								-- check for errors
								set @error = @@error
								if @error != 0
									begin
										select @UserMsg = 'Error executing dynamic SQL for the LockData result set. Contact your system administrator.'
										select @LogMsg = 'Error executing dynamic SQL for the #ResultSet_LockData result set.'
										raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
										goto ServerErrorExit
									end

		-- get value for EntityTypeName field
		update RS
		set RS.EntityTypeName = RC.Name
		from #ResultSet_LockData RS inner join ReferenceCodes RC
			on RS.EntityType = RC.Code
		where
			RC.Type = 'LockEntityType' and
			RC.Subtype = 'LockEntityType'

		-- get value for ReasonName field
		update RS
		set RS.ReasonName = RC.Name
		from #ResultSet_LockData RS inner join ReferenceCodes RC
			on RS.Reason = RC.Code
		where
			RC.Type = 'LockReason' and
			RC.Subtype = 'LockReason'

		-- get value for ClassName field
		update RS
		set RS.ClassName = RC.Name
		from #ResultSet_LockData RS inner join ReferenceCodes RC
			on RS.Class = RC.Code
		where
			RC.Type = 'LockClass' and
			RC.Subtype = 'LockClass'

		-- get value for SubClassName field
		update RS
		set RS.SubClassName = RC.Name
		from #ResultSet_LockData RS inner join ReferenceCodes RC
			on RS.SubClass = RC.Code
		where
			RC.Type = 'LockSubClass' and
			RC.Subtype = 'LockSubClass'
		
		-- get value for AddedByName field
		update RS
		set RS.AddedByName = U.FullName
		from #ResultSet_LockData RS inner join Users U
			on RS.AddedBy = U.UserID
		
		-- get value for LastUpdatedByName field
		update RS
		set RS.LastUpdatedByName = U.FullName
		from #ResultSet_LockData RS inner join Users U
			on RS.LastUpdatedBy = U.UserID
	end --of: if @ReturnLockData = 'Y'

if @ReturnReAdjudicationWizardJobData = 'Y'
	begin
		select @SqlRetrieveReAdjudicationWizardJobs = 'insert into #ResultSet_ReAdjudicationWizardJobs (
					JobId
					, JobNumber
					, JobName
					, JobDescription
					, JobType
					, JobTypeName
					, JobStep
					, JobStepName
					, ProcessingStatus
					, ProcessingStatusName
					, CreatedAt
					, CreatedBy
					, CreatedByName
					, CompletedAt
					, Class
					, ClassName
					, SubClass
					, SubClassName
					, LastUpdatedBy
					, LastUpdatedByName
					, LastUpdatedAt
					, ClaimId
					, LineNumber
					, AdjustmentVersion
					, DetailStatus
					, DetailStatusName
					, ProcessedAt
				)
				select Jobs.JobId
					, JobNumber
					, JobName
					, JobDescription
					, JobType
					, JobTypeRC.Name
					, JobStep
					, JobStepRC.Name
					, ProcessingStatus
					, ProcessingStatusRC.Name
					, Jobs.CreatedAt
					, Jobs.CreatedBy
					, U1.FullName
					, CompletedAt
					, Jobs.Class
					, ClassRC.Name
					, Jobs.SubClass
					, SubClassRC.Name
					, Jobs.LastUpdatedBy
					, U2.FullName
					, Jobs.LastUpdatedAt
					, Details.ClaimId
					, Details.LineNumber
					, Details.AdjustmentVersion
					, Details.DetailStatus
					, Details.DetailStatusName
					, Details.ProcessedAt
				from ReAdjudicationWizardJobs Jobs
					inner join (
								 select distinct JobId, JD.ClaimId, JD.LineNumber, JD.AdjustmentVersion, DetailStatus, [DetailStatusName] = DetailStatusRC.Name, ProcessedAt
								 from ReAdjudicationWizardJobDetails JD 
									inner join #ResultSet R 
										on JD.ClaimId = R.ClaimId
											and JD.AdjustmentVersion = R.AdjustmentVersion
									left outer join ReferenceCodes DetailStatusRC
										on DetailStatusRC.Code = JD.DetailStatus 
											and DetailStatusRC.[Type] = ''ReAdjudicateWizJobDetailStatus''
								 union all
								 select distinct JobId, JDH.ClaimId, JDH.LineNumber, JDH.AdjustmentVersion, DetailStatus, [DetailStatusName] = DetailStatusRC.Name, ProcessedAt
								 from ReAdjudicationWizardJobDetailsHistory JDH 
									inner join #ResultSet R 
										on JDH.ClaimId = R.ClaimId
											and JDH.AdjustmentVersion = R.AdjustmentVersion
									left outer join ReferenceCodes DetailStatusRC
										on DetailStatusRC.Code = JDH.DetailStatus 
											and DetailStatusRC.[Type] = ''ReAdjudicateWizJobDetailStatus''
							   ) Details
						on Details.JobId = Jobs.JobId
					inner join Users U1 
						on Jobs.CreatedBy = U1.UserID
					inner join Users U2 
						on Jobs.LastUpdatedBy = U2.UserID
					inner join ReferenceCodes JobTypeRC 
						on JobTypeRC.Code = Jobs.JobType and JobTypeRC.[Type] = ''ReAdjudicationWizardJobType''
					inner join ReferenceCodes ProcessingStatusRC 
						on ProcessingStatusRC.Code = Jobs.ProcessingStatus and ProcessingStatusRC.[Type] = ''ReAdjudicationWizardJobStatus''
					inner join ReferenceCodes JobStepRC 
						on JobStepRC.Code = Jobs.JobStep and JobStepRC.[Type] = ''ReAdjudicationWizardJobStep''
					left outer join ReferenceCodes ClassRC 
						on ClassRC.Code = Jobs.Class and ClassRC.[Type] = ''ReAdjudicationWizardJobClass''
					left outer join ReferenceCodes SubClassRC 
						on SubClassRC.Code = Jobs.SubClass and SubClassRC.[Type] = ''ReAdjudicationWizardJobSubClass''
				where 1 = 1
		'

		if @FilterResultsetsBy = 'ARJ'
		begin
			if @ReAdjudicationWizardJobId is not null
			begin
				select @SqlRetrieveReAdjudicationWizardJobs = @SqlRetrieveReAdjudicationWizardJobs + ' and Jobs.JobId = @ReAdjudicationWizardJobId '
			end

			if isnull( @ReAdjudicationWizardJobClass, '' ) <> ''
			begin
				select @SqlRetrieveReAdjudicationWizardJobs = @SqlRetrieveReAdjudicationWizardJobs + ' and Jobs.Class = @ReAdjudicationWizardJobClass '
			end

			if isnull( @ReAdjudicationWizardJobSubClass, '' ) <> ''
			begin
				select @SqlRetrieveReAdjudicationWizardJobs = @SqlRetrieveReAdjudicationWizardJobs + ' and Jobs.SubClass = @ReAdjudicationWizardJobSubClass '
			end

			if @DateUsage = '|DateProcessedAt|'
			begin
				select @SqlRetrieveReAdjudicationWizardJobs = @SqlRetrieveReAdjudicationWizardJobs + ' and Details.ProcessedAt between @PeriodStart and @PeriodEnd '
			end
		end

		select @SqlRetrieveReAdjudicationWizardJobsParamDefinition = '@ReAdjudicationWizardJobId Id_t, @ReAdjudicationWizardJobClass Code_t, @ReAdjudicationWizardJobSubClass Code_t, @PeriodStart Date_t, @PeriodEnd Date_t'

		if @Debug > 1
		begin
			select [Debug Message] = 'Sql to retrieve the Re-Adjudication batch jobs.'
				, [@SqlRetrieveReAdjudicationWizardJobs] = @SqlRetrieveReAdjudicationWizardJobs
		end

		begin try

			exec sp_executesql @SqlRetrieveReAdjudicationWizardJobs, @SqlRetrieveReAdjudicationWizardJobsParamDefinition
					, @ReAdjudicationWizardJobId = @ReAdjudicationWizardJobId
					, @ReAdjudicationWizardJobClass = @ReAdjudicationWizardJobClass
					, @ReAdjudicationWizardJobSubClass = @ReAdjudicationWizardJobSubClass
					, @PeriodStart = @PeriodStart
					, @PeriodEnd = @PeriodEnd

		end try
		begin catch
			if @Debug > 1
			begin
				select [Debug Message] = dbo.ff_GetSQLErrorInfo(@ProcedureName)
			end

			select @UserMsg = 'An error occurred while retrieving the Re-Adjudication batch Job data.'
				, @LogMsg = dbo.ff_GetSQLErrorInfo(@ProcedureName)
				, @error = error_number()
			raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, @error, -1, -1)
			goto ServerErrorExit
		end catch
	end

end --of: stored procedure

NormalExit:
	select @status = 0
    if @ReturnStatus = 'Y'
		begin
			select @Total = COUNT(*) from #Resultset
			If isnull(@SysOptEntityAttrValues,'') = ''	
				begin		
					select 'Status' = @status, 'Total' = @Total, 'TotalResultsets' = 25,
					'Resultset1' = 'Main', 'Resultset2' = 'Explanations', 'Resultset3' = 'ActionCodes',
					'Resultset4' = 'Institutional', 'Resultset5' = 'Financials', 'Resultset6' = 'ClaimCodes', 
					'Resultset7' = 'CustomAttributes','Resultset8' = 'Parameters', 'Resultset9' = 'ClaimMasterData',
					'Resultset10' = 'ClaimReimbursementLog', 'Resultset11' = 'InputBatches','Resultset12' = 'DocumentRequests',
					'Resultset13' = 'PCPInformation','Resultset14' = 'PendedWorkData','Resultset15' = 'ReinsuranceData', 'Resultset16' = 'OverridesFromTransform',
					'Resultset17' = 'Pharmacy', 'Resultset18' = 'ClaimCOBData','Resultset19' = 'ClaimCOBDataDetails','Resultset20' = 'ClaimCARCsRARCs', 
					'Resultset21' = 'LongTermCare', 'Resultset22' = 'ScreeningVisit', 'Resultset23' = 'Medi-CalPharmacy', 'Resultset24' = 'LockData',
					'Resultset25' = 'ReAdjudicationWizardJobs'
				end
			else
				begin
					select 'Status' = @status, 'Total' = @Total, 'TotalResultsets' = 26,
					'Resultset1' = 'Main', 'Resultset2' = 'Explanations', 'Resultset3' = 'ActionCodes',
					'Resultset4' = 'Institutional', 'Resultset5' = 'Financials', 'Resultset6' = 'ClaimCodes', 
					'Resultset7' = 'CustomAttributes', 'Resultset8' = 'EntityAttributes', 'Resultset9' = 'Parameters', 'Resultset10' = 'ClaimMasterData',
					'Resultset11' = 'ClaimReimbursementLog', 'Resultset12' = 'InputBatches','Resultset13' = 'DocumentRequests',
					'Resultset14' = 'PCPInformation','Resultset15' = 'PendedWorkData','Resultset16' = 'ReinsuranceData', 'Resultset17' = 'OverridesFromTransform',
					'Resultset18' = 'Pharmacy', 'Resultset18' = 'ClaimCOBData','Resultset19' = 'ClaimCOBDataDetails','Resultset20' = 'ClaimCARCsRARCs',
					'Resultset21' = 'LongTermCare', 'Resultset22' = 'ScreeningVisit', 'Resultset23' = 'Medi-CalPharmacy', 'Resultset24' = 'LockData',
					'Resultset25' = 'ReAdjudicationWizardJobs'
				end 
		end 
	
	If (@ResultsetName is null or @ResultsetName = 'Main')
		begin
		
			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @DeleteClaimIdsSQL = 'delete ' + @ResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLMain)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLMain failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
			
	If (@ResultsetName is null or @ResultsetName = 'Explanations') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_Explanations'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLExplanations)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Explanations. Contact your system administrator.'
					select @LogMsg = 'Execute SQLExplanations failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
			
	If (@ResultsetName is null or @ResultsetName = 'ActionCodes') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ActionCodes'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLActionCodes)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Action Codes. Contact your system administrator.'
					select @LogMsg = 'Execute SQLActionCodes failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
			
	If (@ResultsetName is null or @ResultsetName = 'Institutional') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_Institutional'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLInstitutional)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Institutional Claim Data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLInstitutional failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
			
	If (@ResultsetName is null or @ResultsetName = 'Financials') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_Financials'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLFinancials)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Financials. Contact your system administrator.'
					select @LogMsg = 'Execute SQLFinancials failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
			
	If (@ResultsetName is null or @ResultsetName = 'ClaimCodes') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ClaimCodes'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLClaimCodes)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Codes. Contact your system administrator.'
					select @LogMsg = 'Execute SQLClaimCodes failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
	
		--------------------------------------------------
		---- TIME STAMP-----------------------------------
		--------------------------------------------------
		If @Debug > 0
			begin
				print N'SP Step 50 - ' + convert(varchar,GETDATE(),121) 
			end
			
	If (@ResultsetName is null or @ResultsetName = 'CustomAttributes') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_CustomAttributes'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLCustomAttributes)
			
			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Custom Attributes. Contact your system administrator.'
					select @LogMsg = 'Execute SQLCustomAttributes failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
		
		--------------------------------------------------
		---- TIME STAMP-----------------------------------
		--------------------------------------------------
		If @Debug > 0
			begin
				print N'SP Step 51 - ' + convert(varchar,GETDATE(),121) 
			end
		
    
    If (@ResultsetName is null or @ResultsetName = 'ENTITYATTRIBUTES') and isnull(@SysOptEntityAttrValues,'') != '' 
		begin
	    

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ENTITYATTRIBUTES'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLAttr)

			select @error = @@error

			if @error != 0
			begin
			  select @UserMsg = 'Error retrieving Claim Entity Attributes. Contact your system administrator.'
			  select @LogMsg = 'Execute SQLAttr failed.'  
			  raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
			  goto ServerErrorExit
			end
			
		end
		
	If (@ResultsetName is null or @ResultsetName = 'Parameters') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_Parameters'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName 
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLParameters)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Report Parameters. Contact your system administrator.'
					select @LogMsg = 'Execute SQLParameters failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end	
		
	If (@ResultsetName is null or @ResultsetName = 'ClaimMasterData') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ClaimMasterData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLClaimMasterData)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Master Data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLClaimMasterData failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
    
	If (@ResultsetName is null or @ResultsetName = 'ClaimReimbursementLog') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ClaimReimbursementLog'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLClaimReimbursementLog)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Reimbursement Log. Contact your system administrator.'
					select @LogMsg = 'Execute SQLClaimReimbursementLog failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end    
    
		If (@ResultsetName is null or @ResultsetName = 'InputBatches') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_InputBatches'
					print ('start append to ' + @SecondaryResultTableName)
					print (getdate())
					select @DeleteClaimIdsSQL = 'delete I from ' + @SecondaryResultTableName + ' I where exists (select 1 from #ResultSet R where I.InputBatchId = R.InputBatchID)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SqlInputBatches)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Input Batches. Contact your system administrator.'
					select @LogMsg = 'Execute SQLInputBatches failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'DocumentRequests') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_DocumentRequests'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLDocumentRequests)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Document Requests. Contact your system administrator.'
					select @LogMsg = 'Execute SQLDocumentRequests failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end     

	If (@ResultsetName is null or @ResultsetName = 'PCPInformation')
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_PCPInformation'
					select @DeleteClaimIdsSQL = 'delete PCP from ' + @SecondaryResultTableName + ' PCP where exists(select 1 from #ResultSet RS where RS.MemberId = PCP.MEmberID and RS.SubscriberContractId = PCP.SubscriberContractID)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLPCPInformation)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving PCP Informatin. Contact your system administrator.'
					select @LogMsg = 'Execute SQLPCPInformation failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'PendedWorkData') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_PendedWorkData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where EntityId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLPendedWorkData)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Pended Work Data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLPendedWorkData failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
	end

	If (@ResultsetName is null or @ResultsetName = 'ReinsuranceData') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ReinsuranceData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLReinsuranceData)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Reinsurance Data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLReinsuranceData failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
	end
		
	If (@ResultsetName is null or @ResultsetName = 'OverridesFromTransform') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_OverridesFromTransform'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLOverridesFromTransform)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Overrides From Transform. Contact your system administrator.'
					select @LogMsg = 'Execute SQLOverridesFromTransform failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end		
	end 

	If (@ResultsetName is null or @ResultsetName = 'Pharmacy')
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_Pharmacy'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLPharmacy)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Pharmacy Claim Data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLPharmacy failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'ClaimCOBData')
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ClaimCOBData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLClaimCOBData)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim COB Data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLClaimCOBData failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'ClaimCOBDataDetails')
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ClaimCOBDataDetails'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLClaimCOBDataDetails)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim COB Data Details. Contact your system administrator.'
					select @LogMsg = 'Execute SQLClaimCOBDataDetails failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'ClaimCARCsRARCs')
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ClaimCARCsRARCs'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLClaimCARCsRARCs)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim CARCs and RARCs. Contact your system administrator.'
					select @LogMsg = 'Execute SQLClaimCARCsRARCs failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'LongTermCare') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_LongTermCareData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLLongTermCare)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Long Term Care information. Contact your system administrator.'
					select @LogMsg = 'Execute @SQLLongTermCare failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'ScreeningVisit') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_ScreeningVisitData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLScreeningVisit)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Screening Visit information. Contact your system administrator.'
					select @LogMsg = 'Execute @SQLScreeningVisit failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end
	
	If (@ResultsetName is null or @ResultsetName = 'Medi-CalPharmacy') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_Medi_CalPharmacyData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLMedi_CalPharmacy)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Claim Medi-Cal Pharmacy information. Contact your system administrator.'
					select @LogMsg = 'Execute @SQLMedi-CalPharmacy failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
		end

	If (@ResultsetName is null or @ResultsetName = 'LockData') 
		begin

			if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
				begin
					select @SecondaryResultTableName = @ResultTableName + '_LockData'
					select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where EntityId in (select ClaimId from #IncrementalClaimIds)'
					exec (@DeleteClaimIdsSQL)
				end

			exec (@SQLLockData)

			select @error = @@error

			if @error != 0
				begin
					select @UserMsg = 'Error retrieving Lock data. Contact your system administrator.'
					select @LogMsg = 'Execute SQLLockData failed.'  
					raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
					goto ServerErrorExit
				end
	end
	
	If (@ResultsetName is not null and @ResultsetName = 'ClosedClaims')
		begin 
			--
			-- DO NOT ANY COLUMNS TO THIS RESULTSET
			-- this is intended to mimic the original rr_DisplayClosedClaims resultset
			--
			select @SQLClosedClaim_InsertClause = 'INSERT #Resultset_ClosedClaims ' 
				+ '(PeriodStart,PeriodEnd,OfficeStateSearch,OfficeCountySearch,OfficeZipSearch,OfficeRegionSearch,OfficeCountryCodeSearch,'
				+ 'ClaimId,AdjustmentVersion,ClaimNumber,GroupId,SubscriberContractId,MemberID,VendorID,ProviderID,OfficeID,MemberCoverageId,'
				+ 'DateReceived,DateEOBPrinted,ClaimStatus,ClaimType,FormType,DateEncounterExported,ClosedDate,AdjustedClosedDate,ClosedVersion,'
				+ 'InputBatchID,ClaimExplanationId,ClaimExplanationAbbreviation,InitialAdjudicationVersion,AdjudicationActionCodes,PaymentActionCodes,'
				+ 'CategoryI,CategoryII,CategoryIII,TotalCharges,TotalRepricedAmount,BilledCurrency,BilledCurrencyName,ExternalClaimNumber,PatientAccountNumber,'
				+ 'CleanedDate,SourceType,PaymentClass,PaymentClassName,SuppressPayment,InitialAdjudicationDate,RecordID,RecordStatus,'
				+ 'RecordAmount,RecordType,EntityType,'
				+ 'CheckDate,CheckAmount,CheckNumber,GroupNumber,GroupName,GroupType,GroupLineOfBusinessCode,GroupLineOfBusiness,'
				+ 'ContractName,SubscriberNumber,SubscriberName,'
				+ 'ContractId,NetworkId,NetworkName,LineStatus,AmountPaid,AmountMemberPaid,AmountCoPay,AmountCoInsurance,AmountDeductible,AmountUCR,'
				+ 'AmountFeeAllowed,'
				+ 'ClaimTotalProviderPaid,'
				+ 'ClaimTotalMemberPaid,'
				+ 'DenialActionCode,DenialAction,NegotiatedCode,Negotiated,ExplanationId,ExplanationCode,Abbreviation,'
				+ 'LineNumber,AmtCharged,BilledCurrencyAmount,ExchangeRate,ProcedureCode,Tooth,Surface,AmountRepriced,SuppliedUCR,ServiceDateTo,ServiceDateFrom,'
				+ 'ModifierCode,Modifier,'
				+ 'Modifier2Code,Modifier2,'
				+ 'Modifier3Code,Modifier3,'
				+ 'Modifier4Code,Modifier4,'
				+ 'PlaceOfServiceCode,PlaceOfService,'
				+ 'TypeOfServiceCode,TypeOfService,'
				+ 'DiagnosisCodePointers,COB,'
				+ 'DefaultInputBatch,'
				+ 'WebClaim,'
				+ 'DiagnosisCode1,DiagnosisCode2,DiagnosisCode3,DiagnosisCode4,DiagnosisCode5,DiagnosisCode6,DiagnosisCode7,DiagnosisCode8,DiagnosisCode9,'
				+ 'DiagnosisCode10,DiagnosisCode11,DiagnosisCode12,DiagnosisCode13,DiagnosisCode14,DiagnosisCode15,DiagnosisCode16,'
				+ 'DiagnosisCode17,DiagnosisCode18,DiagnosisCode19,DiagnosisCode20,DiagnosisCode21,DiagnosisCode22,DiagnosisCode23,DiagnosisCode24,'
				+ 'DiagnosisCodeQual1,DiagnosisCodeQual2,DiagnosisCodeQual3,DiagnosisCodeQual4,DiagnosisCodeQual5,DiagnosisCodeQual6,DiagnosisCodeQual7,'
				+ 'DiagnosisCodeQual8,DiagnosisCodeQual9,DiagnosisCodeQual10,DiagnosisCodeQual11,DiagnosisCodeQual12,DiagnosisCodeQual13,DiagnosisCodeQual14,'
				+ 'DiagnosisCodeQual15,DiagnosisCodeQual16,DiagnosisCodeQual17,DiagnosisCodeQual18,DiagnosisCodeQual19,DiagnosisCodeQual20,DiagnosisCodeQual21,'
				+ 'DiagnosisCodeQual22,DiagnosisCodeQual23,DiagnosisCodeQual24,'
				+ 'POAIndicator1,POAIndicator2,POAIndicator3,POAIndicator4,POAIndicator5,POAIndicator6,POAIndicator7,POAIndicator8,POAIndicator9,'
				+ 'POAIndicator10,POAIndicator11,POAIndicator12,POAIndicator13,POAIndicator14,POAIndicator15,POAIndicator16,POAIndicator17,'
				+ 'POAIndicator18,POAIndicator19,POAIndicator20,POAIndicator21,POAIndicator22,POAIndicator23,POAIndicator24,'
				+ 'PrincipalDiagnosisCode,PrincipalDiagQualifier,PrincipalPOAIndicator,AdmittingDiagnosisCode,AdmittingDiagQualifier,ECode,ECodeQualifier,'
				+ 'MemberNumber,MemberName,MemberPolicyNumber,ProviderName,ProviderNumber,'
				+ 'ProviderType,ProviderContractNumber,'
				+ 'ProviderPrimarySpecialty,'
				+ 'ProviderSpecialtyCategoryID,ProviderSpecialtyCategoryName,ProviderSpecialtySubCategoryID,ProviderSpecialtySubCategoryName,'
				+ 'ProviderSpecialtyID,ProviderSpecialtyName,'
				+ 'VendorNumber,VendorName,CorporationId,PaymentCurrency,'
				+ 'PaymentCurrencyName,'
				+ 'EIN,OfficeName,OfficeNumber,OfficeAddress,OfficeCity,OfficeState,'
				+ 'OfficeZip,OfficeRegion,OfficeRegionName,OfficeCounty,OfficeCountryName,ServiceCategoryId,ServiceCategoryName,ServiceCategoryClass,ServiceCategorySubClass,'
				+ 'LiabilityLevelId,LiabilityLevelName,LiabilityPackageId,LiabilityPackageName,FeeScheduleId,FeeScheduleName,ReimbursementId,ReimbursementName,'
				+ 'PlanId,PlanName,'
				+ 'LineOfBusiness,'
				+ 'ProductType,'
				+ 'ProductLine,'
				+ 'BenefitCategoryId,BenefitCategoryName,AuthorizationId,AuthorizationNumber,'
				+ 'AuthServiceLineNumber,AuthServiceDetailLineNumber,CaseID,CaseNumber,ColumnList)'

			select @SQLClosedClaim_SelectClause = 'select '  
				+ 'RP.PeriodStart,RP.PeriodEnd,RS.OfficeState,RS.OfficeCounty,RS.OfficeZipSearch,RS.OfficeRegion,RS.OfficeCountryCode,'
				+ 'RS.ClaimId,RS.AdjustmentVersion,RS.ClaimNumber,RS.GroupId,RS.SubscriberContractId,RS.MemberId,RS.VendorId,RS.ProviderId,RS.OfficeId,RS.MemberCoverageId,'
				+ 'RS.DateReceived,RS.DateEOBPrinted,RS.ClaimStatus,RS.ClaimType,RS.FormType,RS.DateEncounterExported,RS.ClosedDate,RS.AdjustedClosedDate,RS.ClosedVersion,'
				+ 'RS.InputBatchID,RS.ClaimExplanationId,RS.ClaimExplanationAbbreviation,RS.InitialAdjudicationVersion,RS.AdjudicationActionCodes,RS.PaymentActionCodes,'
				+ 'RS.CategoryI,RS.CategoryII,RS.CategoryIII,RS.TotalCharges,RS.RepricedTotalAmount,RS.BilledCurrency,RS.BilledCurrencyName,RS.ExternalClaimNumber,RS.PatientAccountNumber,'
				+ 'RS.CleanedDate,RS.SourceType,RS.PaymentClass,RS.PaymentClassName,RS.SuppressPayment,RS.InitialAdjudicationDate,RF.RecordID,RF.RecordStatus,'
				+ 'RF.RecordAmount,RF.RecordType, RF.EntityType,'
				+ 'RF.CheckDate,RF.CheckAmount, RF.CheckNumber,RS.GroupNumber,RS.GroupName,RS.GroupType,RS.GroupLineOfBusiness,RS.GroupLineOfBusinessName,'
				+ 'RS.ContractName,RS.SubscriberNumber,RS.SubscriberFirstName + '' '' + RS.SubscriberLastName,'
				+ 'RS.ContractId,'''','''',RS.ResultStatus,RS.AmtToPay,RS.AmtToPayMember,RS.AmtCopay,RS.AmtCoinsurance,RS.AmtDeductible,RS.AmtUCR,'
				+ 'RS.AmtFeeAllowed,'
				+ 'ClaimTotalProviderPaid,'
				+ 'ClaimTotalMemberPaid,'
				+ 'RS.DenialAction,RS.DenialActionName,RS.Negotiated,RS.NegotiatedName,RS.ExplanationId,isnull(E.ExplanationCode,''''),isnull(E.Abbreviation,''''),'
				+ 'RS.LineNumber,RS.AmtCharged,RS.BilledCurrencyAmount,RS.ExchangeRate,RS.ProcedureCode,RS.Tooth,RS.Surface,RS.AmtRepriced,RS.SuppliedUCR,RS.ServiceDateTo,RS.ServiceDateFrom,'
				+ 'RS.Modifier,(select RC.Name	from  ReferenceCodes RC where RS.Modifier = RC.Code and RC.Type = ''Modifier''),'
				+ 'RS.Modifier2,(select RC.Name	from  ReferenceCodes RC where RS.Modifier2 = RC.Code and RC.Type = ''Modifier''),'
				+ 'RS.Modifier3,(select RC.Name	from  ReferenceCodes RC where RS.Modifier3 = RC.Code and RC.Type = ''Modifier''),'
				+ 'RS.Modifier4,(select RC.Name	from  ReferenceCodes RC where RS.Modifier4 = RC.Code and RC.Type = ''Modifier''),'
				+ 'RS.PlaceOfService,(select RC.Name from ReferenceCodes RC  where RS.PlaceOfService = RC.Code and RC.Type = ''PlaceOfService'' and RC.SubType = ''PlaceOfService''),'
				+ 'RS.TypeOfService,(select TypeOfService = RC.Name from ReferenceCodes RC where RS.TypeOfService = RC.Code and RC.Type = ''TypeOfService''),' 
				+ 'RS.DiagnosisPtrs,RS.COB,'
				+ '(select case RS.InputBatchID when I.InputBatchID then ''Y'' else ''N'' end from InputBatches I where SourceName = ''System Claim Batch'' and InputBatchStatus = ''OPN''),'
				+ '(select case RS.SourceType when ''WEB'' then ''Y'' else ''N'' end),'
				+ 'RS.DiagnosisCode1,RS.DiagnosisCode2,RS.DiagnosisCode3,RS.DiagnosisCode4,RS.DiagnosisCode5,RS.DiagnosisCode6,RS.DiagnosisCode7,RS.DiagnosisCode8,RS.DiagnosisCode9,'
				+ 'RS.DiagnosisCode10,RS.DiagnosisCode11,RS.DiagnosisCode12,RS.DiagnosisCode13,RS.DiagnosisCode14,RS.DiagnosisCode15,RS.DiagnosisCode16,'
				+ 'RS.DiagnosisCode17,RS.DiagnosisCode18,RS.DiagnosisCode19,RS.DiagnosisCode20,RS.DiagnosisCode21,RS.DiagnosisCode22,RS.DiagnosisCode23,RS.DiagnosisCode24,'
				+ 'RS.DiagnosisCodeQual1,RS.DiagnosisCodeQual2,RS.DiagnosisCodeQual3,RS.DiagnosisCodeQual4,RS.DiagnosisCodeQual5,RS.DiagnosisCodeQual6,RS.DiagnosisCodeQual7,'
				+ 'RS.DiagnosisCodeQual8,RS.DiagnosisCodeQual9,RS.DiagnosisCodeQual10,RS.DiagnosisCodeQual11,RS.DiagnosisCodeQual12,RS.DiagnosisCodeQual13,RS.DiagnosisCodeQual14,'
				+ 'RS.DiagnosisCodeQual15,RS.DiagnosisCodeQual16,RS.DiagnosisCodeQual17,RS.DiagnosisCodeQual18,RS.DiagnosisCodeQual19,RS.DiagnosisCodeQual20,RS.DiagnosisCodeQual21,'
				+ 'RS.DiagnosisCodeQual22,RS.DiagnosisCodeQual23,RS.DiagnosisCodeQual24,'
				+ 'RS.POAIndicator1,RS.POAIndicator2,RS.POAIndicator3,RS.POAIndicator4,RS.POAIndicator5,RS.POAIndicator6,RS.POAIndicator7,RS.POAIndicator8,RS.POAIndicator9,'
				+ 'RS.POAIndicator10,RS.POAIndicator11,RS.POAIndicator12,RS.POAIndicator13,RS.POAIndicator14,RS.POAIndicator15,RS.POAIndicator16,RS.POAIndicator17,'
				+ 'RS.POAIndicator18,RS.POAIndicator19,RS.POAIndicator20,RS.POAIndicator21,RS.POAIndicator22,RS.POAIndicator23,RS.POAIndicator24,'
				+ 'RI.PrincipalDiagnosisCode,RI.PrincipalDiagnosisQual,RI.PrincipalPOAIndicator,RI.AdmittingDiagnosisCode,RI.AdmittingDiagnosisQual,RI.ECode,RI.ECodeQual,'
				+ 'RS.MemberNumber,RS.MemberFirstName + '' '' + RS.MemberLastName,RS.MemberPolicyNumber,RS.ProviderFirstName + '' '' + RS.ProviderLastName,RS.ProviderNumber,'
				+ 'RS.ProviderType,RS.ProviderContractNumber,'
				+ '(select top 1 PS.SpecialtyName from ProviderSpecialtyMap PSM, ProviderSpecialties PS where RS.ProviderId = PSM.ProviderId and PSM.SpecialtyId = PS.ProviderSpecialtyId and case when PrimarySpecialty = ''Y'' then 1 when PrimarySpecialty = ''N'' then 0 else PrimarySpecialty end = 1),' 
				+ 'RS.ProviderSpecialtyCategoryID,RS.ProviderSpecialtyCategoryName,RS.ProviderSpecialtySubCategoryID,RS.ProviderSpecialtySubCategoryName,'
				+ isnull(convert(varchar(10),@ProviderSpecialtyID),'NULL') +',RP.ProviderSpecialtyName,'
				+ 'RS.VendorNumber,RS.VendorName,RS.CorporationId,(select V.PaymentCurrency from Vendors V where V.VendorId = RS.VendorId),'
				+ '(select  RC.Name from  ReferenceCodes RC, Vendors V where RC.Type = ''CURRENCY'' and RC.SubType = ''CURRENCY'' and V.PaymentCurrency = RC.Code and V.VendorId = RS.VendorId),'
				+ 'RS.EIN,RS.OfficeName,RS.OfficeNumber,RS.OfficeAddress1,RS.OfficeCity,RS.OfficeState,'
				+ 'RS.OfficeZip,RS.OfficeRegion,RS.OfficeRegionName,RS.OfficeCounty,RS.OfficeCountryCode,RS.ServiceCategoryId,RS.ServiceCategoryName,RS.ServiceCategoryClass,RS.ServiceCategorySubClass,'
				+ 'RS.LiabilityLevelId,RS.LiabilityLevelName,RS.LiabilityPackageId,RS.LiabilityPackageName,RS.FeeScheduleId,RS.FeeScheduleName,RS.ReimbursementId,RS.ReimbursementName,'
				+ 'RS.PlanId,RS.PlanName,'
				+ '(Select RC.Description from ReferenceCodes RC, BasePlans P Where P.PlanId = RS.PlanId And RC.type = ''LINEOFBUSINESS'' And RC.SUBTYPE = ''LINEOFBUSINESS'' And RC.CODE = P.LineOfBusinessCode),'
				+ '(Select RC.Description from ReferenceCodes RC, BasePlans P Where P.PlanId = RS.PlanId And RC.type = ''PRODUCTTYPE'' And RC.SUBTYPE = ''PRODUCTTYPE'' And RC.CODE = P.ProductType),'
				+ '(Select RC.Description from referencecodes RC, BasePlans P Where P.PlanId = RS.PlanId And RC.type = ''PRODUCTLINE'' And RC.SUBTYPE = ''PRODUCTLINE'' And RC.CODE = P.ProductLineCode),'
				+ 'RS.BenefitCategoryId,RS.BenefitCategoryName,RS.AuthorizationId,RS.AuthorizationNumber,'
				+ 'RS.AuthServiceLineNumber,RS.AuthServiceDetailLineNumber,RS.CaseID,RS.CaseNumber,RS.ColumnList '

			select @SQLClosedClaim_FromClause = ' from #ResultSet RS ' 
				+ ' left outer join #ResultSet_Financials RF on RS.ClaimId = RF.ClaimId and RF.AdjustmentVersion = RS.AdjustmentVersion and RF.RecordType in (''CA'', ''A'',''MPD'') '
				+ ' left outer join #ResultSet_Institutional RI on RI.ClaimId = RS.ClaimId and RI.AdjustmentVersion = RS.AdjustmentVersion '
				+ ' left outer join #ResultSet_Parameters RP on 1=1 '
				+ ' left outer join Explanations E on RS.ExplanationID = E.ExplanationID '
				+ ' outer apply (select Sum(Isnull(AmtToPay,0)) [Amount] from #ResultSet CR where RS.ClaimID = CR.ClaimID	and RS.AdjustmentVersion = CR.AdjustmentVersion) [ClaimTotalProviderPaid] '
				+ ' outer apply (select Sum(Isnull(AmtToPayMember,0)) [Amount] from Claim_Results CR where RS.ClaimID = CR.ClaimID and RS.AdjustmentVersion = CR.AdjustmentVersion) [ClaimTotalMemberPaid] '

								If @Debug > 1
									begin
										select @SQLClosedClaim_InsertClause as '@SQLClosedClaim_InsertClause'
										select @SQLClosedClaim_SelectClause as '@SQLClosedClaim_SelectClause'
										select @SQLClosedClaim_FromClause as '@SQLClosedClaim_FromClause'
									end

			exec (@SQLClosedClaim_InsertClause + @SQLClosedClaim_SelectClause + @SQLClosedClaim_FromClause)

								-- check for errors
								select @error = @@error
								if @error != 0
									begin
										select @UserMsg = 'Error retrieving ClosedClaim Information. Contact your system administrator.'
										select @LogMsg = 'Execute SQLClosedClaim failed.'  
										raiserror(65500,1,1,@ProductName,@ProcedureName,@ProcedureStep,@UserMsg,@LogMsg,@SessionID,@error,@rowcount,1)
										goto ServerErrorExit
									end

			-- *****************************************************************
			-- get up to 4 coverage mappings
			-- *****************************************************************
			if exists (select 1 from #Resultset_ClosedClaims)
				begin
					-- get 1st coverage mapping
					update RS
					set RS.Coverage					= case DT.RowNumber when 1 then DT.Code else RS.Coverage end,
						RS.CoverageName				= case DT.RowNumber when 1 then DT.Name else RS.CoverageName end
					from #Resultset_ClosedClaims RS
						inner join	(
										select
											ERCM.EntityID,
											RC.Code,
											RC.Name,
											row_number() over (partition by ERCM.EntityID order by ERCM.EntityReferenceCodeMapID desc) as RowNumber
										from ReferenceCodes RC
											inner join EntityReferenceCodeMap ERCM
												on RC.ReferenceCodeID = ERCM.ReferenceCodeID and ERCM.EntityType = 'Base Plan' and ERCM.ReferenceCodeType = 'Coverage' and ERCM.ReferenceCodeSubType = 'Coverage'
									) DT
							on RS.PlanID = DT.EntityID
					where DT.RowNumber = 1

					-- get 2nd coverage mapping
					update RS
					set RS.Coverage2				= case DT.RowNumber when 2 then DT.Code else RS.Coverage2 end,
						RS.Coverage2Name			= case DT.RowNumber when 2 then DT.Name else RS.Coverage2Name end
					from #Resultset_ClosedClaims RS
						inner join	(
										select
											ERCM.EntityID,
											RC.Code,
											RC.Name,
											row_number() over (partition by ERCM.EntityID order by ERCM.EntityReferenceCodeMapID desc) as RowNumber
										from ReferenceCodes RC
											inner join EntityReferenceCodeMap ERCM
												on RC.ReferenceCodeID = ERCM.ReferenceCodeID and ERCM.EntityType = 'Base Plan' and ERCM.ReferenceCodeType = 'Coverage' and ERCM.ReferenceCodeSubType = 'Coverage'
									) DT
							on RS.PlanID = DT.EntityID
					where DT.RowNumber = 2

					-- get 3rd coverage mapping
					update RS
					set RS.Coverage3				= case DT.RowNumber when 3 then DT.Code else RS.Coverage3 end,
						RS.Coverage3Name			= case DT.RowNumber when 3 then DT.Name else RS.Coverage3Name end
					from #Resultset_ClosedClaims RS
						inner join	(
										select
											ERCM.EntityID,
											RC.Code,
											RC.Name,
											row_number() over (partition by ERCM.EntityID order by ERCM.EntityReferenceCodeMapID desc) as RowNumber
										from ReferenceCodes RC
											inner join EntityReferenceCodeMap ERCM
												on RC.ReferenceCodeID = ERCM.ReferenceCodeID and ERCM.EntityType = 'Base Plan' and ERCM.ReferenceCodeType = 'Coverage' and ERCM.ReferenceCodeSubType = 'Coverage'
									) DT
							on RS.PlanID = DT.EntityID
					where DT.RowNumber = 3

					-- get 4th coverage mapping
					update RS
					set RS.Coverage4				= case DT.RowNumber when 4 then DT.Code else RS.Coverage4 end,
						RS.Coverage4Name			= case DT.RowNumber when 4 then DT.Name else RS.Coverage4Name end
					from #Resultset_ClosedClaims RS
						inner join	(
										select
											ERCM.EntityID,
											RC.Code,
											RC.Name,
											row_number() over (partition by ERCM.EntityID order by ERCM.EntityReferenceCodeMapID desc) as RowNumber
										from ReferenceCodes RC
											inner join EntityReferenceCodeMap ERCM
												on RC.ReferenceCodeID = ERCM.ReferenceCodeID and ERCM.EntityType = 'Base Plan' and ERCM.ReferenceCodeType = 'Coverage' and ERCM.ReferenceCodeSubType = 'Coverage'
									) DT
							on RS.PlanID = DT.EntityID
					where DT.RowNumber = 4
				end --of: if exists (select 1 from #Resultset_ClosedClaims)
		end

	if @ResultsetName is null or @ResultsetName = 'ReAdjudicationWizardJobs'
	begin try

		if @TableUsage = '|APPEND|' and @DateUsage = '|Incremental|'
			begin
				select @SecondaryResultTableName = @ResultTableName + '_ReAdjudicationWizardJobs'
				select @DeleteClaimIdsSQL = 'delete ' + @SecondaryResultTableName + ' where ClaimId in (select ClaimId from #IncrementalClaimIds)'
				exec (@DeleteClaimIdsSQL)
				end

		exec (@SQLReAdjudicationWizardJobs)
	end try
	begin catch
		select @UserMsg = 'An error occurred while retrieving the Job data. Contact your system administrator.'
			, @LogMsg = dbo.ff_GetSQLErrorInfo(@ProcedureName)
			, @error = error_number()
		raiserror (65500, 1, 1, @ProductName, @ProcedureName, @ProcedureStep, @UserMsg, @LogMsg, @SessionId, @error, -1, -1)
		goto ServerErrorExit
	end catch

  return @status

BusinessErrorExit:
  select @status = 1
  select 'Status' = @status, 'ErrorMsg' = @UserMsg
  return @status

ServerErrorExit:
  select @status = 2
  select 'Status' = @status, 'ErrorMsg' = @UserMsg
  return @status

AppErrorExit:
  select @status = 3
  select 'Status' = @status, 'ErrorMsg' = @UserMsg
  return @status


GO

