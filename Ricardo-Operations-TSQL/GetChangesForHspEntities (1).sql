USE [HSP_Supplemental]
GO

/****** Object:  StoredProcedure [Integration].[GetChangesForHSPEntities]    Script Date: 2/14/2018 2:14:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		i4231
-- Create date: 3/22/2017
-- Description:	Purpose of this procedure is to track changes for providers, offices and provider contracts from HSP in a given time range to push into Network_Development
-- =============================================
CREATE PROCEDURE [Integration].[GetChangesForHSPEntities]
	@BeginTime DATETIME, 
	@EndTime DATETIME ,
	@GetChangesFor VARCHAR(35) = 'Providers/Offices/Contracts',
	@Environment VARCHAR(10) = 'HSP'		
	 
AS
BEGIN
	SET NOCOUNT ON;



/**********************************PROVIDER CONTRACT CHANGES FROM OFFICE HISTORY TABLE *******************************************************************************************************************************/

		IF(@GetChangesFor LIKE '%Contracts%')
	BEGIN
		SELECT DISTINCT 
			PCM.providerContractId,
			PCM.ContractId,
			PCM.VendorId,
			PCM.ProviderContractNumber,
			PCM.ProviderId,
			PCM.OfficeId,
			PCM.HospitalId AS HospitalId,
			RG.RiskGroupNumber,
			PCM.ProviderContractSubclass,
			PCM.EffectiveDate,
		--	PCM.LastUpdatedAt,
			PCM.ProviderContractClass,
			PCM.PanelStatus
			FROM HSP.dbo.ProviderContractMap PCM WITH (NOLOCK)
			LEFT JOIN HSP.dbo.RiskGroups RG WITH (NOLOCK) ON RG.RiskGroupId = PCM.RiskGroupId
			LEFT JOIN HSP.dbo.Providers P WITH (NOLOCK) ON P.provideriD = PCM.HospitalId AND P.Hospital = 'Y'
			WHERE (pcm.ExpirationDate IS NULL OR pcm.ExpirationDate > GETDATE())
			AND (pcm.LastUpdatedAt BETWEEN @BeginTime AND @EndTime) AND PCM.ProviderContractNumber IS NOT NULL

	END

/**********************************************************************************************************************************************************************************************************************************/


    
END
GO


