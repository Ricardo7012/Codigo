USE [HSP_Supplemental]
GO

/****** Object:  View [Peak].[vw_PeakMaxMCAlert]    Script Date: 2/21/2018 3:17:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [Peak].[vw_PeakMaxMCAlert]
AS
	SELECT	LEFT(MFET.MemberID, 12) AS MemberID
		  , 'PEAK' AS AlertType
		  , DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) AS EffDate
		  , CONVERT(DATETIME, CONVERT(VARCHAR(8), EOMONTH(DATEADD(M, 3,
															  GETDATE())), 112)) AS TrmDate
		  , 'Mbr is part of the Peak Home Assessment Project for CY '
			+ CONVERT(VARCHAR(4), DATEPART(YEAR, GETDATE())) AS AlertText
		  , GETDATE() AS CreateDate
	FROM	Peak.PeakMemberHistory MFET
	WHERE	CONVERT(VARCHAR(10),MFET.DatePulled,101) = CONVERT(VARCHAR(10),GETDATE(),101)
			AND MFET.PlanID = 'H5355';
	



GO


