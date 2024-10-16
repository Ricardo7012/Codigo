USE [HSP_Supplemental]
GO
/****** Object:  StoredProcedure [Peak].[usp_Populate_PeakMemberEligibility]    Script Date: 2/21/2018 3:16:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [Peak].[usp_Populate_PeakMemberEligibility]
    (
      --@HSPDatabase VARCHAR(20) ,
      @PeakEligibilityDate VARCHAR(10)='01/01/1900' 
      
    )
AS
    BEGIN
/*===============================================================================================
Author  : Jack Han
Create Date : 3/8/2017
Description : Prepare data for all the members' eligibility who are pulled after specified month
Replace Access Query 
-- 008_MonthlyEligibility_001
* Synonym:        Synonym created for using HSP_IT_SB database objects as syn.objectname on 07/21/2017 -Sacha
Modification history:
02/01/2018 Hima Changed code to pull provider phone and fax numbers from custom attributes of provider office mapping
=================================================================================================*/
        SET NOCOUNT ON;
        SET XACT_ABORT,
        QUOTED_IDENTIFIER,
        ANSI_NULLS,
        ANSI_PADDING,
        ANSI_WARNINGS,
        ARITHABORT,
        CONCAT_NULL_YIELDS_NULL ON;
        SET NUMERIC_ROUNDABORT OFF;

        DECLARE @Mark CHAR(30) = REPLACE(NEWID(), '-', '');
        DECLARE @localTran BIT= @@TRANCOUNT;


        IF @localTran > 0
            SAVE TRANSACTION @Mark;
        ELSE
            BEGIN TRANSACTION;

        BEGIN TRY
	  
   DECLARE @TODAY DATE; 
            SELECT  @TODAY = CONVERT(DATE, GETDATE());

            DECLARE @PeakEligibilityDateBegin DATE;
            SELECT  @PeakEligibilityDateBegin = CONVERT(DATE, @PeakEligibilityDate);

		WITH providercontact AS
		    (
			  SELECT ProviderID,
			         OfficeID,
					 [A].[Provider Office Phone],
					 [Provider Office Fax]
              FROM 
              (
                 SELECT ca.AttributeName,pom.OfficeID,pom.ProviderID,ea.AttributeValue 
                 FROM syn.EntityAttributes ea
                 INNER JOIN syn.CustomAttributes ca ON ea.AttributeID=ca.AttributeID
                 INNER JOIN syn.ProviderOfficeMap pom ON pom.ProviderOfficeMapID=ea.EntityID
                 WHERE entitytype='POM' AND attributename IN ('Provider Office Phone','Provider Office Fax')
               ) pvt
               PIVOT 
               (
                MAX(Attributevalue) FOR AttributeName IN ([Provider Office Phone],[Provider Office Fax])
                ) A
			)
        
		SELECT DISTINCT
			MC.MemberNumber       AS MemberID
		   ,M.HICN                AS HICN
		   ,CONVERT(VARCHAR(50), FORMAT(M.DateOfBirth, 'M/d/yyyy H:mm:ss'))       AS MemberDOB
		   ,M.FirstName           AS MemberFirst
		   ,M.LastName            AS MemberLast
		   ,M.MiddleName          AS MemberMiddle
		   ,M.Gender              AS Gender
		   ,M.Address1            AS MemberAddress
		   ,M.Address2            AS MemberAddress2
		   ,M.City                AS MemberCity
		   ,M.Zip                 AS MemberZip
		   ,M.State               AS MemberState
		   ,CASE WHEN (M.CellPhone IS NOT NULL AND LEN(M.CellPhone)=10 AND M.CellPhone NOT IN ('9999999999','0000000000') ) THEN M.CellPhone
				 ELSE M.HomePhone END AS MemberPhone
           ,CASE WHEN (M.CellPhone IS NOT NULL AND LEN(M.CellPhone)=10 AND M.CellPhone NOT IN ('9999999999','0000000000') )
							     AND (M.Homephone IS NOT NULL AND LEN(M.Homephone)=10 AND M.Homephone NOT IN ('9999999999','0000000000') ) THEN M.HomePhone
								 ELSE M.WorkPhone END AS MemberAlternate 
		   --,CASE WHEN COALESCE(M.CellPhone,'') NOT IN ('0000000000','9999999999') AND LEN(COALESCE(M.CellPhone,''))=10 THEN M.CellPhone
		   --      WHEN COALESCE(M.HomePhone,'') NOT IN ('0000000000','9999999999') AND LEN(COALESCE(M.HomePhone,''))=10 THEN M.HomePhone
				 --WHEN COALESCE(M.WorkPhone,'') NOT IN ('0000000000','9999999999') AND LEN(COALESCE(M.WorkPhone,''))=10 THEN M.WorkPhone  
				 --END AS MemberPhone
		   ,NULL                  AS PlanID
		   ,P.ProviderNumber      AS PCPID
		   ,P.FirstName           AS PCPFirst
		   ,P.LastName            AS PCPLast
		   ,NULL                  AS PCPMiddle
		   ,O.Address1            AS PCPAddress
		   ,O.Address2            AS PCPAddress2
		   ,O.City                AS PCPCity
		   ,O.State               AS PCPState
		   ,O.Zip                 AS PCPZip
		   ,pc.[Provider Office Phone]        AS PCPPhone
		   ,pc.[Provider Office Fax]          AS PCPFax  
           ,CASE WHEN COALESCE(Lem.Language,'')='SPA' THEN 'Spanish'
                 ELSE 'English' END    AS MemberLanguage   
		   
		   	FROM Peak.PeakMemberHistory HX
		INNER JOIN syn.MemberCoverages MC ON HX.MemberID = MC.MemberNumber
		INNER JOIN syn.BenefitCoverages BC ON MC.MemberCoverageID = BC.EntityId
		INNER JOIN syn.Members M ON MC.MemberId = M.MemberID
		INNER JOIN syn.MemberProviderMap MPM ON M.MemberID = MPM.MEmberID
		INNER JOIN syn.Providers P ON MPM.ProviderId = P.ProviderID
		INNER JOIN syn.Offices O ON MPM.OfficeID = O.OfficeID
		INNER JOIN syn.RiskGroups RG ON MPM.RiskGroupID = RG.RiskGroupID
		INNER JOIN syn.SubscriberContracts SC ON M.MemberID = SC.MemberID
		INNER JOIN syn.Groups G ON SC.GroupID = G.GroupID
		INNER JOIN syn.LanguageEntityMap LEM ON M.MemberID = LEM.EntityID
		LEFT JOIN  providercontact pc ON pc.ProviderID=mpm.ProviderId AND mpm.OfficeID=pc.OfficeID
		WHERE 1 = 1
		AND BC.CoverageEntityType = 'BAS'
		AND BC.EntityTypeID='3'
		AND BC.EffectiveDate  <= CONVERT(DATE,  CONVERT(VARCHAR(10), @TODAY, 101) )  
		AND CONVERT(DATE, BC.ExpirationDate) = CONVERT(DATE, '9999-12-31')
		AND CONVERT(DATE, MPM.ExpirationDate) = CONVERT(DATE, '9999-12-31')
		AND G.LOB = 'MCR'
		AND RG.RiskGroupNumber = 'JJJ'
        AND COALESCE(LEM.EntityType,'') IN ( 'MEM'    ,'')
		AND COALESCE(Lem.LanguageUse,'') IN ('Primary','')
        AND (COALESCE(M.CellPhone,'') NOT LIKE '999%' OR COALESCE(M.HomePhone,'') NOT LIKE '999%' OR COALESCE(M.WorkPhone,'') NOT LIKE '999%' )
        AND (CONVERT(BIGINT, CASE WHEN ISNUMERIC(M.CellPhone) = 1
                                 THEN M.CellPhone
                                 ELSE '0000000000'
                            END) > 0
						OR
		    CONVERT(BIGINT, CASE WHEN ISNUMERIC(M.HomePhone) = 1
                                 THEN M.HomePhone
                                 ELSE '0000000000'
                            END) > 0
							OR
		    CONVERT(BIGINT, CASE WHEN ISNUMERIC(M.WorkPhone) = 1
                                 THEN M.WorkPhone
                                 ELSE '0000000000'
                            END) > 0)
		AND HX.DatePulled >= CONVERT(DATE, CONVERT(VARCHAR(10), @PeakEligibilityDateBegin, 101) );



            IF ( XACT_STATE() = 1
                 AND @localTran = 0
               )
                COMMIT TRANSACTION;
        END TRY

        BEGIN CATCH
            IF ( @localTran = 0 )
                ROLLBACK TRANSACTION;
            ELSE
                IF ( XACT_STATE() <> -1 )
                    ROLLBACK TRANSACTION @Mark;


            DECLARE @ErrorMessage NVARCHAR(4000);
            DECLARE @ErrorSeverity INT;
            DECLARE @ErrorState INT;
 
            SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                    @ErrorSeverity = ERROR_SEVERITY() ,
                    @ErrorState = ERROR_STATE();

            RAISERROR ( @ErrorMessage, @ErrorSeverity, @ErrorState);	
        END CATCH;

    END;





