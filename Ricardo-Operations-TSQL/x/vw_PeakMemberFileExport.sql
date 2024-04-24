USE [HSP_Supplemental]
GO

/****** Object:  View [Peak].[vw_PeakMemberFileExport]    Script Date: 2/21/2018 3:17:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






 ALTER VIEW [Peak].[vw_PeakMemberFileExport]

	   AS
	   
	             SELECT DISTINCT
                            HX.MemberID ,
                            HX.HICN ,
                            CONVERT(VARCHAR(50), FORMAT(HX.MemberDOB,
                                                        'M/d/yyyy H:mm:ss')) AS MemberDOB,
                            HX.MemberFirst ,
                            HX.MemberLast ,
                            HX.MemberMiddle ,
                            HX.Gender ,
                            HX.MemberAddress ,
                            HX.MemberAddress2 ,
                            HX.MemberCity ,
                            HX.MemberState ,
                            HX.MemberZip ,
                            HX.MemberPhone ,
                            HX.PlanID ,
                            HX.PCPID ,
                            HX.PCPFirst ,
                            HX.PCPLast ,
                            HX.PCPMiddle ,
                            HX.PCPAddress ,
                            HX.PCPAddress2 ,
                            HX.PCPCity ,
                            HX.PCPState ,
                            HX.PCPZIP ,
                            HX.PCPPhone ,
                            HX.PCPFax ,
                            --HX.PeakRequested ,
                            HX.MemberLanguage ,
                            HX.MemberAlternate
                    FROM    Peak.PeakMemberHistory HX
                    WHERE  ( CONVERT(BIGINT, CASE WHEN ISNUMERIC(HX.MemberPhone) = 1
                                                     THEN HX.MemberPhone
                                                     ELSE '0000000000'
                                                END) > 1
												OR
							CONVERT(BIGINT, CASE WHEN ISNUMERIC(HX.MemberAlternate) = 1
                                                     THEN HX.MemberAlternate
                                                     ELSE '0000000000'
                                                END)>1)
                            AND HX.PlanID = 'H5355'
							AND HX.DatePulled =CONVERT(DATE, GETDATE());






GO


