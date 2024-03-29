USE [HSP_Supplemental]
GO
/****** Object:  StoredProcedure [Integration].[GetChangesForHSPEntities]    Script Date: 8/1/2017 9:09:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		i4231
-- Create date: 8/02/2017
-- Description:	Purpose of this procedure is to track changes for provider contracts from HSP in a given time range to push into Network_Development
-- =============================================
ALTER PROCEDURE [Integration].[GetChangesForHSPEntities]
	@BeginTime Datetime, 
	@EndTime DateTime ,
	@GetChangesFor varchar(35) = 'Providers/Offices/Contracts'		
	 
AS
BEGIN
	SET NOCOUNT ON;


/**********************************PROVIDER CONTRACT CHANGES FROM HISTORY TABLE *******************************************************************************************************************************/

		IF(@GetChangesFor like '%Contracts%')
	BEGIN
		Select distinct 
			PCM.providerContractId,
			PCM.ContractId,
			PCM.VendorId,
			PCM.ProviderContractNumber,
			PCM.ProviderId,
			PCM.OfficeId,
			PCM.HospitalId as HospitalId,
			RG.RiskGroupNumber,
			PCM.ProviderContractSubclass,
			PCM.EffectiveDate,
		--	PCM.LastUpdatedAt,
			PCM.ProviderContractClass,
			PCM.PanelStatus
			From [HSP_MO].dbo.ProviderContractMap PCM with (nolock)
			left join [HSP_MO].dbo.RiskGroups RG with (nolock) on RG.RiskGroupId = PCM.RiskGroupId
			left join [HSP_MO].dbo.Providers P with (nolock) on P.provideriD = PCM.HospitalId and P.Hospital = 'Y'
			where (pcm.ExpirationDate is null or pcm.ExpirationDate > getdate())
			and (pcm.LastUpdatedAt between @BeginTime and @EndTime)

	END

/**********************************************************************************************************************************************************************************************************************************/


    
END