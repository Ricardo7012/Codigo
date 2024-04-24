DROP TABLE IF EXISTS #Temp834
DROP TABLE IF EXISTS #IdMax

CREATE TABLE #Temp834
    (
       DhcsFileName VARCHAR(34)
       ,DetailID INT
       ,HeaderID INT
       ,DetailCIN VARCHAR(9)
       ,FileDate VARCHAR(10)
       ,SegmentNumber VARCHAR(2)
       ,EffectiveDate VARCHAR(10)
       ,TermDate VARCHAR(10)
       ,HealthPlanCode VARCHAR(3)
       ,HCPStatusCode VARCHAR(2)
       ,MedicarePartA VARCHAR(1) 
       ,MedicarePartB VARCHAR(1)
       ,MedicarePartD VARCHAR(1)
       ,SegmentAidCode VARCHAR(2)
       ,SpecialAidCode1AidCode VARCHAR(2)
       ,SpecialAidCode2AidCode VARCHAR(2)
       ,SpecialAidCode3AidCode VARCHAR(2)
       ,CapitatedAidCode VARCHAR(2)
	   ,SOCSpendDown VARCHAR(10)
	        )

CREATE TABLE #IdMax
    (
       DetailCIN VARCHAR(9)
       ,ID INT
       )


INSERT INTO #Temp834
       SELECT DhcsFileName
                ,DetailID
                ,HeaderID
                ,DetailCIN
                ,CONVERT(varchar,DetailDhcsFileDate,101) as FileDate
          ,SegmentNumber
          ,CONVERT(varchar,StartDate,101) as EffectiveDate
          ,CONVERT(varchar,EndDate,101) as TermDate
          ,HealthPlanCode
          ,HCPStatusCode
                ,MedicarePartA
                ,MedicarePartB
                ,MedicarePartD
                ,SegmentAidCode
                ,SpecialAidCode1AidCode
                ,SpecialAidCode2AidCode
                ,SpecialAidCode3AidCode
                ,CapitatedAidCode
				,SOCSpendDown
    FROM [MARS\OLYMPUS].EDI834Audit.rpt.vw_Process834_CurrentDetails A WITH(NOLOCK)
    LEFT JOIN [EDIMS].[EdiManagementHub].[mem].[CinExclusion] B WITH(NOLOCK) ON A.DetailCIN=B.CIN
    WHERE SegmentNumber= '10'
          AND B.CIN IS NULL


INSERT INTO #IdMax
              SELECT DetailCIN
                 ,MAX(DetailID) as ID
              FROM #Temp834
        GROUP BY DetailCIN




DROP TABLE IF EXISTS #TEMP834MEMBERSHIP

Select Line_of_Business =
CASE WHEN HealthPlanCode LIKE '8%' THEN 'CCI834' ELSE 'MED834' END
	,HealthPlanCode
	,Count(DISTINCT i.DetailCIN) Membership
INTO #TEMP834MEMBERSHIP
FROM #Temp834 t 
INNER JOIN #IdMax as i on t.DetailID=i.ID
WHERE SegmentNumber='10'
	AND HCPStatusCode IN ('01','S1','51','41','61')
	AND EffectiveDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
	AND HealthPlanCode IN ('305','306','810','812')
	Group By HealthPlanCode

INSERT INTO #TEMP834MEMBERSHIP
Select Line_of_Business = 
CASE WHEN CapitatedAidCode IN ('13','23','53','63') THEN 'LTC834'
     WHEN CapitatedAidCode IN ('17','27','37','67','1Y','6W') THEN 'SOC834'
	 END
	 ,HealthPlanCode
	 ,Count(DISTINCT i.DetailCIN) Membership
FROM #Temp834 t
INNER JOIN #IdMax as i on t.DetailID=i.ID
WHERE CapitatedAidCode In ('17','27','37','67','1Y','6W','13','23','53','63')
	AND EffectiveDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
	AND HCPStatusCode IN ('01','S1','51','41','61')
	OR (CapitatedAidCode In ('17','27','37','67','1Y','6W','13','23','53','63')
	AND EffectiveDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
	AND HCPStatusCode IN ('01','S1','51') AND SocSpendDown IS NOT NULL)
	AND SegmentNumber='10'
	AND HealthPlanCode IN ('305','306','810','812')
Group By CASE WHEN CapitatedAidCode IN ('13','23','53','63') THEN 'LTC834'
     WHEN CapitatedAidCode IN ('17','27','37','67','1Y','6W') THEN 'SOC834'
	 END
	 ,HealthPlanCode


INSERT INTO #TEMP834MEMBERSHIP
Select Line_of_Business = 'MMD834'
	,HealthPlanCode
	,Count(DISTINCT i.DetailCIN) Membership
FROM #Temp834 t 
INNER JOIN #IdMax as i on t.DetailID=i.ID
WHERE 
EffectiveDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
	AND HealthPlanCode IN ('305','306')
	AND HCPStatusCode IN ('01','S1','51','41','61')
	AND (MedicarePartA IN ('1','2','3','5','7')
	OR MedicarePartB IN ('1','2','3','5','7'))
Group By HealthPlanCode


INSERT INTO #TEMP834MEMBERSHIP
Select Line_of_Business = 'FKP834'
	,HealthPlanCode
	,Count(DISTINCT i.DetailCIN) Membership
FROM #Temp834 t  
INNER JOIN #IdMax as i on t.DetailID=i.ID
WHERE 
EffectiveDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
	AND HCPStatusCode IN ('01','S1','51','41','61')
	AND CapitatedAidCode IN ('2P','2R','2S','2T','2U','40','42','43','45','49','4E','4H','4L','4M','5K')
	AND HealthPlanCode IN ('305','306','810','812')
GROUP BY HealthPlanCode

Select * FROM #TEMP834MEMBERSHIP
DROP TABLE #TEMP834MEMBERSHIP
DROP TABLE #Temp834
DROP TABLE #IdMax
















