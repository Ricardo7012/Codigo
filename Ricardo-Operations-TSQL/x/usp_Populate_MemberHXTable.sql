USE [HSP_Supplemental]
GO
/****** Object:  StoredProcedure [Peak].[usp_Populate_MemberHXTable]    Script Date: 2/21/2018 3:16:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Peak].[usp_Populate_MemberHXTable] 
(
--	@HSPDatabaseName VARCHAR(30),
	@PeakMemberDate VARCHAR (10)
--	@StagingDatabaseName VARCHAR(30)
)
AS

BEGIN
/*===========================================
Author  : Daniel Castro
Create Date : 2/22/2017
Description : Updates the Peak HX table 
This SPROC uses several CTE's to insert new 
the data.
* Synonym:        Synonym created for using HSP_IT_SB database objects as syn.objectname on 07/21/2017 -Sacha
Modification History:
02/01/2018 Hima Changed code to pull provider phone and fax from provider office mapping custom attributes
=============================================*/
--DECLARE
--    @HSPDatabaseName VARCHAR(30) ='HSP_IT_SB',
--	@PeakMemberDate VARCHAR (10) ='2016/01/01',
--	@StagingDatabaseName VARCHAR(30) ='HSP_Supplemental'

IF OBJECT_ID('tempdb..#PeakMMRMembers') IS NOT NULL
		DROP TABLE #PeakMMRMembers   

         --   DECLARE @PeakMemberDate Varchar(10) = @PeakMemberDate
	  		DECLARE @PeakMemberDateBegin DATE
			SELECT @PeakMemberDateBegin= DATEADD(M, -1,DATEADD(D, 1,EOMONTH(@PeakMemberDate)));
			DECLARE @MonthPull VARCHAR(3)
			SET @MonthPull = CONVERT(VARCHAR(3), GETDATE())
			DECLARE @Today DATE = GETDATE()
         
				   
		;WITH CTE1 AS
			(	SELECT  DISTINCT MC.MemberNumber
        	FROM syn.MemberCoverages MC 
        	INNER JOIN
        	syn.BenefitCoverages BC ON MC.MemberCoverageID = BC.EntityId
        	WHERE BC.CoverageEntityType = 'BAS'
			AND BC.EntityTypeID='3'
        	AND MC.BasePlanID = '3'
        	GROUP BY MC.MemberNumber
        	HAVING CONVERT(DATE, MIN(EffectiveDate)) >= CONVERT(DATE,@PeakMemberDateBegin) )

			SELECT DISTINCT                                       
			LEFT(MC.MEMBERNUMBER,12) AS SUBID                --1
		   , @MonthPull  AS MonthPull    
		   ,M.HICN AS HICNumber
		    ,'' AS GerinetRequested
		   ,'' AS Notes 
		INTO #PeakMMRMembers                                --3
		FROM syn.MemberCoverages MC
		INNER JOIN CTE1 CTE ON MC.MemberNumber = CTE.MemberNumber
		INNER JOIN syn.BenefitCoverages BC ON MC.MemberCoverageID = BC.EntityId
		INNER JOIN syn.Members M ON MC.MemberID = M.MemberID
		INNER JOIN syn.MemberProviderMap MPM ON M.MemberID = MPM.MemberID
		INNER JOIN syn.RiskGroups RG ON MPM.RiskGroupID = RG.RiskGroupId
		INNER JOIN syn.SubscriberContracts SC ON M.MemberID = SC.MemberID
		INNER JOIN syn.Groups G ON SC.GroupID = G.GroupID
		WHERE BC.CoverageEntityType = 'BAS'
		AND  BC.EntityTypeId='3'
		AND RIGHT(MC.MEMBERNUMBER, 2) = '00'
		AND CONVERT(DATE, BC.EffectiveDate) >= CONVERT(DATE, @PeakMemberDateBegin )
		AND CONVERT(DATE, BC.ExpirationDate) >= CONVERT(DATE, '9999-12-31') 
	   	AND RG.RISKGROUPNUMBER = 'JJJ'                       
		AND G.LOB = 'MCR' ;         
  
      WITH  CTE_001_qry_Pull_New_MMR_Mems_003
                 AS ( SELECT DISTINCT
                            NMMR.MonthPull AS MonthPull ,
                            M.MiddleName AS AAMI ,
                            NMMR.HICNumber AS HICNumber ,
                            M.LastName AS AALASTNM ,
                            M.FirstName AS AAFNAME ,
                            M.DateOfBirth AS AADOB ,
                            M.Address1 AS AAADDR1 ,
                            M.Address2 AS AAADDR2 ,
                            M.City AS AACITY ,
                            M.State AS AASTATE ,
                            M.Zip AS AAZIP ,
                            CASE WHEN (M.CellPhone IS NOT NULL AND LEN(M.CellPhone)=10 AND M.CellPhone NOT IN ('9999999999','0000000000') ) THEN M.CellPhone
							    ELSE M.HomePhone END AS AAHPHON ,
                            CASE WHEN (M.CellPhone IS NOT NULL AND LEN(M.CellPhone)=10 AND M.CellPhone NOT IN ('9999999999','0000000000') )
							     AND (M.Homephone IS NOT NULL AND LEN(M.Homephone)=10 AND M.Homephone NOT IN ('9999999999','0000000000') ) THEN M.HomePhone
								 ELSE M.WorkPhone END AS AABPHON ,
                            LEFT(MC.MemberNumber,12) AS AASUBNO ,
                            MPM.ProviderId AS ABPCP,
							MPM.OfficeID AS OfficeID,
							MPM.ExpirationDate AS MPMExpirationDate,
                            CASE WHEN COALESCE(Lem.Language,'')='SPA' THEN 'Spanish'
                                 ELSE 'English'
                            END AS Expr1,
                            (CASE WHEN BC.ExpirationDate='12/31/9999' THEN 'A'
		                          WHEN BC.ExpirationDate<>'12/31/9999' AND COALESCE(bc.TerminationReason,'') IN ('05','41','55','59','61','P4') THEN 'H'
				                  WHEN BC.ExpirationDate<>'12/31/9999' AND COALESCE(bc.TerminationReason,'') NOT IN ('05','41','55','59','61','P4') THEN 'D' END ) AS ABESTAT,
                            NMMR.GerinetRequested AS GerinetRequested ,
                            M.Gender AS AASEX ,
                            'H5355' AS [PLAN],
                            NMMR.Notes AS Notes
                   FROM     #PeakMMRMembers NMMR
                            INNER JOIN syn.MemberCoverages MC ON NMMR.SUBID = LEFT(MC.MemberNumber,12)
                            INNER JOIN syn.BenefitCoverages BC ON MC.MemberCoverageID = BC.EntityId
                            INNER JOIN syn.Members M ON MC.MemberId = M.MemberID
                            LEFT JOIN  syn.LanguageEntityMap LEM ON M.MemberID = LEM.EntityID
                            INNER JOIN syn.SubscriberContracts SC ON M.MemberID = SC.MemberId
                            INNER JOIN syn.Groups G ON SC.GroupId = G.GroupId
                            INNER JOIN syn.MemberProviderMap MPM ON M.MemberID = MPM.MEmberID
                   WHERE    BC.CoverageEntityType = 'BAS'
				            AND BC.EntityTypeID='3'
                            AND RIGHT(MC.MemberNumber, 2) = '00'
                            AND BC.EffectiveDate <= CONVERT(DATE, @Today)
                            AND CONVERT(DATE, BC.ExpirationDate) = '9999-12-31'
                            AND CONVERT(DATE, MPM.ExpirationDate) = '9999-12-31'
                            AND G.LOB = 'MCR'                       
                            AND NMMR.MonthPull = CONVERT(VARCHAR(3), @Today, 0)
                            AND COALESCE(M.HomePhone,'') NOT LIKE '999%'
                            AND COALESCE(LEM.EntityType,'') IN ( 'MEM'    ,'')
							AND COALESCE(Lem.LanguageUse,'') IN ('Primary','')
                 ),
	        providercontact AS
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
			),
            CTE_002_qry_GerinetMemFile_000
                     AS ( SELECT DISTINCT
                            CTE1.AASUBNO AS MemberID ,
                            CTE1.HICNumber AS HICN ,
                            CTE1.AADOB AS MemberDOB ,
                            CTE1.AAFNAME AS MemberFirst ,
                            CTE1.AALASTNM AS MemberLast ,
                            CTE1.AAMI AS MemberMiddle ,
                            CTE1.AASEX AS Gender ,
                            CTE1.Expr1 AS MemberLanguage ,
                            CTE1.AAADDR1 AS MemberAddress ,
                            CTE1.AAADDR2 AS MemberAddress2 ,
                            CTE1.AACITY AS MemberCity ,
                            CTE1.AASTATE AS MemberState ,
                            LEFT(CTE1.AAZIP, 5) AS MemberZIP ,
                            CTE1.AAHPHON AS MemberPhone ,
                            CTE1.AABPHON AS MemberAlternate ,
                            CTE1.[PLAN] AS PlanID ,
                            P.Providernumber AS PCPID ,
                            P.FirstName AS PCPFirst ,
                            P.LastName AS PCPLast ,
                            '' AS PCPMiddle ,
                            O.Address1 AS PCPAddress ,
                            O.Address2 AS PCPAddress2 ,
                            O.City AS PCPCity ,
                            O.State AS PCPState ,
                            O.Zip AS PCPZIP ,
                            Pc.[Provider Office Phone] AS PCPPhone ,
                            PC.[Provider Office Fax] AS PCPFax ,
                            P.LastName + ', ' + P.FirstName + ', M.D' AS [PCP FULL Name] ,
                            CTE1.GerinetRequested AS MemRequestContact
                   FROM     CTE_001_qry_Pull_New_MMR_Mems_003 CTE1
                            INNER JOIN syn.Providers P ON CTE1.ABPCP = P.ProviderID
                            INNER JOIN syn.Offices O ON CTE1.OfficeID = O.OfficeID
							INNER JOIN providercontact pc ON pc.OfficeID = CTE1.OfficeID AND pc.ProviderID = CTE1.ABPCP
                   WHERE    CONVERT(DATE, CTE1.MPMExpirationDate) = '9999-12-31'
                            AND (COALESCE(CTE1.AAHPHON,'') NOT LIKE '999%' OR COALESCE(CTE1.AABPHON,'') NOT LIKE '999%' )
                            AND (CONVERT(BIGINT, CASE WHEN ISNUMERIC(CTE1.AAHPHON) = 1
                                                     THEN CTE1.AAHPHON
                                                     ELSE '0000000000'
                                                END) > 0
												OR
								 CONVERT(BIGINT, CASE WHEN ISNUMERIC(CTE1.AABPHON) = 1
                                                     THEN CTE1.AABPHON
                                                     ELSE '0000000000'
                                                END) > 0)
                 )

			INSERT  INTO Peak.PeakMemberHistory
                ( VendorAssigned ,
                  DatePulled ,
                  MemberID ,
                  HICN ,
                  MemberDOB ,
                  MemberFirst ,
                  MemberLast ,
                  MemberMiddle ,
                  Gender ,
                  MemberLanguage ,
                  MemberAddress ,
                  MemberAddress2 ,
                  MemberCity ,
                  MemberState ,
                  MemberZip ,
                  MemberPhone ,
                  MemberAlternate ,
                  PlanID ,
                  PCPID ,
                  PCPFirst ,
                  PCPLast ,
                  PCPMiddle ,
                  PCPAddress ,
                  PCPAddress2 ,
                  PCPCity ,
                  PCPState ,
                  PCPZIP ,
                  PCPPhone ,
                  PCPFax ,
                  PeakRequested ,
                  PCPFullName ,
                  Project 
                )
                SELECT  'Peak' AS VendorAssigned ,
                        @Today AS DatePulled ,
                        CTE2.MemberID +'00' AS MemberID ,
                        CTE2.HICN AS HICN ,
                        CTE2.MemberDOB AS MemberDOB ,
                        CTE2.MemberFirst AS MemberFirst ,
                        CTE2.MemberLast AS MemberLast ,
                        CTE2.MemberMiddle AS MemberMiddle ,
                        CTE2.Gender AS Gender ,
                        CTE2.MemberLanguage AS MemberLanguage ,
                        CTE2.MemberAddress AS MemberAddress ,
                        CTE2.MemberAddress2 AS MemberAddress2 ,
                        CTE2.MemberCity AS MemberCity ,
                        CTE2.MemberState AS MemberState ,
                        CTE2.MemberZIP AS MemberZIP ,
                        CTE2.MemberPhone AS MemberPhone ,
                        CTE2.MemberAlternate AS MemberAlternate ,
                        CTE2.PlanID AS PlanID ,
                        CTE2.PCPID AS PCPID ,
                        CTE2.PCPFirst AS PCPFirst ,
                        CTE2.PCPLast AS PCPLast ,
                        CTE2.PCPMiddle AS PCPMiddle ,
                        CTE2.PCPAddress AS PCPAddress ,
                        CTE2.PCPAddress2 AS PCPAddress2 ,
                        CTE2.PCPCity AS PCPCity ,
                        CTE2.PCPState AS PCPState ,
                        CTE2.PCPZIP AS PCPZIP ,
                        CTE2.PCPPhone AS PCPPhone ,
                        CTE2.PCPFax AS PCPFax ,
                        CTE2.MemRequestContact AS PeakRequested ,
                        CTE2.[PCP FULL Name] AS PCPFullName ,
                        'Standard' AS Project
                FROM    CTE_002_qry_GerinetMemFile_000 CTE2
                WHERE   1 = 1
                        AND ( COALESCE(CTE2.MemberPhone,'') NOT LIKE '9999%' OR COALESCE(CTE2.MemberAlternate,'') NOT LIKE '9999%')
                        AND (CONVERT(BIGINT, CASE WHEN ISNUMERIC(CTE2.MemberPhone) = 1
                                                 THEN CTE2.MemberPhone
                                                 ELSE '0000000000'
                                            END) > 1
											OR
							 CONVERT(BIGINT, CASE WHEN ISNUMERIC(CTE2.MemberAlternate) = 1
                                                 THEN CTE2.MemberAlternate
                                                 ELSE '0000000000'
                                            END) > 1)
				        AND NOT EXISTS (SELECT 1 FROM Peak.PeakMemberHistory AS HX WHERE CTE2.MemberID=LEFT(HX.MemberID,12) AND COALESCE(HX.HICN,'')=COALESCE(CTE2.HICN,'')  )	
							;

END
