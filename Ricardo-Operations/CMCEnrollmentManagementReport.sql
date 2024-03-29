SELECT  
CONVERT(varchar(10),CAST([ReqReceiveDate] as DATE),101) as SubmissionDAte,
COUNT([CIN]) as TotalSubmitted, 
st.TotalReceivedFromState,
CONVERT(DECIMAL(5,2),CONVERT(DECIMAL(5,2),st.TotalReceivedFromState)/CONVERT(DECIMAL(5,2),COUNT([CIN])))  as PercentageReceived,
st.Enrolled,
st.Rejected, 
CASE WHEN st.MinReceivedDate = st.MaxReceivedDate THEN st.MaxReceivedDate
WHEN (st.MinReceivedDate != st.MaxReceivedDate)  THEN st.MinReceivedDate + ' - ' + st.MaxReceivedDate  END as ReceivedDate
FROM [CRM].[dbo].[vw_DCEligibility] sub
LEFT JOIN (
			SELECT
			SUM(TotalReceivedFromState) TotalReceivedFromState,
			SUM(Enrolled) as Enrolled,
			SUM(Rejected) as Rejected,
			SubmissionDate,
			CAST(MIN(ReceivedDate) as varchar) as MinReceivedDate,
			CAST(MAX(ReceivedDate) as varchar) as MaxReceivedDate
			FROM
				(
				SELECT 
				COUNT([CIN]) as TotalReceivedFromState,
				CASE WHEN DispositionFlag = 'S' THEN COUNT(CIn) END AS Enrolled,
				CASE WHEN DispositionFlag = 'R' THEN COUNT(CIn) END as Rejected, 
				CONVERT(varchar(10),CAST([ReqRecDate] as date), 101) SubmissionDate,
				CONVERT(varchar(10),CASt(FileProcessDate as DATE), 101) as ReceivedDate --MIN(CASt(FileProcessDate as DATE)) MinReceivedDate, MAX(CASt(FileProcessDate as DATE)) MaxReceivedDate
				FROM [CRM].[dbo].[DualChoiceDisposition]
				GROUP BY 
				CONVERT(varchar(10),CAST([ReqRecDate] as date), 101),DispositionFlag, CONVERT(varchar(10),CASt(FileProcessDate as DATE), 101)
				)r 
			GROUP BY 
			SubmissionDate
			)st ON st.SubmissionDate = CAST([ReqReceiveDate] as DATE)
GROUP BY 
CONVERT(varchar(10),CAST([ReqReceiveDate] as DATE),101), 
TotalReceivedFromState,
st.Enrolled,
st.Rejected,
CASE WHEN st.MinReceivedDate = st.MaxReceivedDate THEN st.MaxReceivedDate
WHEN (st.MinReceivedDate != st.MaxReceivedDate)  THEN st.MinReceivedDate + ' - ' + st.MaxReceivedDate  END
ORDER BY SubmissionDate







