USE [HSP]
GO
/****** Object:  StoredProcedure [IEHP\c1230].[iehp_MakeCustomPreAdjudicationXML]    Script Date: 10/17/2017 2:27:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[iehp_MakeCustomPreAdjudicationXML]
(
	@ClaimID		ID_t,
	@UserXMLData	XML		out
)
as
begin

	set nocount on

	declare @ProviderID			ID_t,
			@MemberCoveageID	ID_t,
			@ProviderXML		XML,
			@CaseXML			XML

	select @ProviderID = ProviderID,
		   @MemberCoveageID = MemberCoverageId
	  from Claims C
	    where ClaimID = @ClaimID

	Create Table #CustomAttributes 
	(
		AttributeName		Name_t			null,
		AttributeValue		StringLong_t	null
	)

    create table #Case
	(
		CaseID				ID_t				null,
		CaseType			Code_t				null,
		CaseNumber			REFNumber_t			null,
		EffectiveDate		Date_t				null,
		ExpirationDate		Date_t				null,
		CaseStatusCode		Code_t				null,
		ExternalCaseNumber	REFNumber_t			null
	)

	create table #CaseDiagnosis 
	(	
		CaseID					ID_t				null,
		DiagnosisCodeID			ID_t				null,
		DiagnosisCode			HealthCareCode_t	null,
		DiagnosisName			StringMedium_t		null,
		QualifierCode			Code_t				null,
		QualifierCodeName		Description_t		null,
		CodeType				Code_t 				null,
		EffectiveDate			Date_t				null,
		ExpirationDate			Date_t				null
	)


	insert into #CustomAttributes
		(
			AttributeName,
			AttributeValue
		)
	select
			A.AttributeName,
			E.AttributeValue
	from CustomAttributes A
		inner join EntityAttributes E 
			on A.AttributeId = E.AttributeId
				and E.EntityId = @ProviderId
				and E.EntityType = 'Providers'


	insert into #Case
		(
			CaseID,
			CaseType,
			CaseNumber,
			EffectiveDate,
			ExpirationDate,
			CaseStatusCode,
			ExternalCaseNumber
		)
		select
				C.CaseID,
				C.CaseType,
				C.CaseNumber,
				C.EffectiveDate,
				C.ExpirationDate,
				CD.CaseStatus,
				CD.ExternalCaseNumber
		from Case_Details_Medical CD
			inner join Cases C
				on C.CaseID = CD.CaseID
					and C.AdjustmentVersion = CD.AdjustmentVersion
					and C.CaseType = 'MM'
		where CD.MemberCoverageID = @MemberCoveageID
	

			
	insert into #CaseDiagnosis 
		( 
			CaseID,
			DiagnosisCodeID,
			QualifierCode
		)
	select
		D.CaseID,
		D.DiagnosisCodeID,
		D.QualifierCode 
	from CaseDiagnosis D
		inner join #Case C
			on C.CaseID = D.CaseID

	update RS
		set RS.DiagnosisCode = DC.DiagnosisCode,
			RS.DiagnosisName = DC.DiagnosisName,
			RS.CodeType = DC.CodeType,
			RS.EffectiveDate	= DC.EffectiveDate,
			RS.ExpirationDate = DC.ExpirationDate
		from #CaseDiagnosis RS 
			inner join DiagnosisCodes DC 
				on RS.DiagnosisCodeID = DC.DiagnosisCodeID

	update RS
			set	RS.QualifierCodeName = RC.Name
			from #CaseDiagnosis RS 
				inner join ReferenceCodes RC 
					on RS.QualifierCode = RC.Code
			where RC.Type = 'DIAGNOSISQUALIFIER'
				and RC.SubType = 'DIAGNOSISQUALIFIER'

	begin try

		set @ProviderXML = (
							select (
										select CustomAttribute.AttributeName,
											   AttributeValue as AttributeValue
										from #CustomAttributes CustomAttribute for xml path('CustomAttribute'), Root('CustomAttributes'), elements xsinil, type
									)
							for xml path('Provider'), elements xsinil, type)
		
		set @CaseXML = (
						select (
									select C.CaseID as CaseID,
											C.CaseType as CaseType,
											C.CaseNumber as CaseNumber,
											convert(varchar, EffectiveDate, 101) as EffectiveDate,
											convert(varchar, ExpirationDate, 101) as ExpirationDate,
											C.CaseStatusCode as CaseStatusCode,
											C.ExternalCaseNumber as ExternalCaseNumber,
											(
												select
													D.DiagnosisCodeID as DiagnosisCodeID,
													D.DiagnosisCode as DiagnosisCode,
													D.DiagnosisName as DiagnosisName,
													D.QualifierCode as QualifierCode,
													D.QualifierCodeName as QualifierCodeName,
													D.CodeType as CodeType,
													convert(varchar, EffectiveDate, 101) as EffectiveDate,
													convert(varchar, ExpirationDate, 101) as ExpirationDate
												 from #CaseDiagnosis D
												 where D.CaseId = C.CaseId
												 for xml path('Diagnosis'), Root('DiagnosisCodes'), elements xsinil, type
											)
									from #Case C for xml path('Case'), Root('Cases'), elements xsinil, type
								)
						for xml path('CaseInfo'), elements xsinil, type)

		set @UserXMLData = (select @ProviderXML, @CaseXML for xml path('IEHPCustom'))

	end try
	begin catch	
		set @UserXMLData = '<IEHPCustom />'
	end catch;

end