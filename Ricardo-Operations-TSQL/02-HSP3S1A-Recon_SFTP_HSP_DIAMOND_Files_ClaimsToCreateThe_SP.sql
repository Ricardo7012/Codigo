USE HSP_Supplemental
--==============================================================================================================================================================================
-- RUN THIS QUERY IN HSP1S1B.HSP
--==============================================================================================================================================================================

--==============================================================================================================================================================================
DECLARE @FromDate Varchar(8), 
		@ToDate Varchar(8) 

--==============================================================================================================================================================================
set @FromDate = convert(varchar(8), dateadd(D,-2, getdate()),112) --'20180718'  -- For Daily is yesterday's date	-- day before yesterday 
set @ToDate = convert(varchar(8), dateadd(D,-1, getdate()),112) -- For Daily is yesterday's date		-- yesterday .. Sample  Today is the 18th,  from date will say 16, ToDate will be the 17
--==============================================================================================================================================================================

-- If want to run the report different than a daily schedule. Change the dates and un comment the 2 lines below.
--==============================================================================================================================================================================
set @FromDate = '20180723'  -- For Daily is yesterday's date	-- day before yesterday 
set @ToDate= '20180724'	 -- For Daily is yesterday's date		-- yesterday .. Sample  Today is the 18th,  from date will say 16, ToDate will be the 17
--==============================================================================================================================================================================


DECLARE @FromDateTime datetime   =  CONVERT(datetime,@FromDate) + '17:01:00.000',  
		@ToDateTime DateTime = CONVERT(datetime,@ToDate)  + '17:00:59.997'

--==============================================================================================================================================================================
--	           G E T T I N G    D A T A 
--==============================================================================================================================================================================
--==============================================================================================================================================================================
-- QUERY THAT GETS ALL THE FILES FROM SFTP_LOG FOR A DATETIME RANGE
--==============================================================================================================================================================================

drop table if exists #EDI_SFTPFiles
select LogTime, [Action],LoginName, [User], [File] as OrigFileName,
 case when CHARINDEX('.837',case when CHARINDEX('.pgp',[file])  > 0 	
				
							then substring ([file], 0, CHARINDEX('.pgp',[file]))
							else 
								[File]
							end)  > 0 

	then substring (case when CHARINDEX('.pgp',[file])  > 0 	
					then substring ([file], 0, CHARINDEX('.pgp',[file]))
					else 
						[File]
					end
					, 0, CHARINDEX('.837',case when CHARINDEX('.pgp',[file])  > 0 	
								then substring ([file], 0, CHARINDEX('.pgp',[file]))
								else 
									[File]
								end					
					))		
	
	else 
		case when CHARINDEX('.pgp',[file])  > 0 	
		then substring ([file], 0, CHARINDEX('.pgp',[file]))
		else 
			[File]
		end
	end as [FileName], Folder, CreateDate
into #EDI_SFTPFiles
FROM [VEGA].[EDI_Management].dbo.SFTP_Log with(nolock)
WHERE 1=1 
 AND LogTime >= @FromDateTime and  LogTime <= @ToDateTime
 AND [Action]='upload' 
 AND [File] Like '%HSP%'
 AND ( Folder like '%5010/HSP/Inbound%'  Or Folder like '%5010/Inbound%')

 --==============================================================================================================================================================================
-- QUERY THAT GETS ALL THE FILES FROM SFTP_LOG FOR A DATETIME RANGE AND WERE LOGGED INTO HSP ( ANY STATUS)CRT,INV,OPN,PWV,RLB,VLD
--==============================================================================================================================================================================
drop table if exists #EDI_HSPFiles
select edi.EDIFileID, ProcessedDate,ExternalFileName as OrigFileName, 
case when  CHARINDEX('HSP', ExternalFileName)>0 then 
	substring (ExternalFileName , 0, CHARINDEX('HSP', ExternalFileName) + 3) 
	else
		ExternalFileName
	end	as [FileName]
,NumberOfXacts as CountOfClaims, 
	case FileStatus  when
		'VLD' then 'VALID' 
	when 'OPN' then 'OPEN'
	when 'INV' then 'INVALID'
	else FileStatus  --  CRT,PWV,RLB
	end as FileStatus
,ic.InterchangeName
into #EDI_HSPFiles
from HSP_IT_SB2.dbo.EDIFILES edi with(nolock)   
left join HSP_IT_SB2.[dbo].[InterchangeInfo] ic with(nolock) on ic.InterchangeId = edi.InterchangeID
where 1=1
and FileType ='INP'   -- INP and OUT
and convert(varchar(8),processedDate ,112) >= @FromDate -- and  convert(varchar(8),processedDate,112) <= @ToDate)
and ExternalFileName like '%HSP%'  -- keep this filter to see only the records that says HSP


--==============================================================================================================================================================================
--- 1.- GET ALL FILES THAT EXISTS IN SFTP THAT DOESN'T EXISTS IN HSP AS LOADED (Excel Sheet: Files In SFTP NotInHSP)
--==============================================================================================================================================================================
-- get the files
drop table if exists #AreInSFTP_Not_HSP
select DISTINCT sf.OrigFileName , sf.[FileName] , sf.loginname, sf.LogTime as SFTPLogTime, sf.Folder, sf.[Action],sf.CreateDate, sf.[user]
into #AreInSFTP_Not_HSP
from #EDI_SFTPFiles sf
left join #EDI_HSPFiles hs on hs.[FileName] = sf.[FileName]
where hs.[FileName] is null

--==============================================================================================================================================================================
---2.- FROM THE RECORDS THAT MATCHED SFTP_LOG AND HSP - GET THE ONES THAT ARE (INVALID OR OPEN)  AND HAVE NEVER BEEN VALID (Excel Sheet: Invalid Files In HSP)
--==============================================================================================================================================================================
-- get the files
drop table if exists #InvOpen_NeverVal
select DISTINCT sf.LogTime as SFTPLogTime ,sf.[Action], sf.LoginName, sf.[User], sf.origFileName, sf.[FileName], sf.folder, hs.FileStatus, hs.InterchangeName, hs.ProcessedDate, hs.CountOfClaims
into #InvOpen_NeverVal
from #EDI_SFTPFiles sf
join #EDI_HSPFiles hs on hs.[FileName] = sf.[FileName]
LEFT JOIN (select sf.[FileName]
		from #EDI_SFTPFiles sf
		join #EDI_HSPFiles hs on hs.[FileName] = sf.[FileName]
		where 1=1
		and hs.[FileStatus] in ('VALID')
		) NE	 ON NE.[FileName] = SF.[FileName]
where 1=1
and hs.[FileStatus] in ('INVALID','OPEN')
AND NE.[FileName] IS NULL


--==============================================================================================================================================================================
---3.- FROM THE RECORDS THAT MATCHED SFTP_LOG AND HSP - GET THE VALID (Excel Sheet: Files Valid In HSP)
--==============================================================================================================================================================================
-- get the files
drop table if exists #ValidFiles
select DISTINCT sf.LogTime as SFTPLogTime ,sf.[Action], sf.LoginName, sf.[User], sf.origFileName, sf.[FileName], sf.folder, hs.FileStatus, hs.InterchangeName, hs.ProcessedDate, hs.CountOfClaims, hs.origFileName as HSPOrigFileName
into #ValidFiles
from #EDI_SFTPFiles sf
join #EDI_HSPFiles hs on hs.[FileName] = sf.[FileName]
WHERE 1=1
	and hs.[FileStatus] in ('VALID')


--==============================================================================================================================================================================
---4.- GET ALL THE CLAIMS FROM THE FILES THAT ARE IN HSP REGARDLESS THE FILE STATUS 
--==============================================================================================================================================================================

-- Get all the claims that exists in HSP
drop table if exists #ClaimInHSP

select distinct f.[FileName],c.ExternalClaimNumber,ClaimNumber
into #ClaimInHSP
from #EDI_HSPFiles f
join HSP_IT_SB2.dbo.EDIXacts l with(nolock) on l.EDIFileID = f.EDIFileID
join HSP_IT_SB2.dbo.Claims c with(nolock) on c.ClaimId = l.ClaimID

------==============================================================================================================================================================================
-----				RECONCILIATION
------==============================================================================================================================================================================

--Queries to get Excel Sheet: Summary Reconciliation sheet. E to I columns 
-- Excel Sheet: Summary Reconciliation sheet. F
drop table if exists #SFTPCounts
select [user] as TP, count(distinct [fileName]) as FileCountSFTP
into #SFTPCounts
from #EDI_SFTPFiles
group by [user]

-- Excel Sheet: Summary Reconciliation sheet. G
drop table if exists #NeverLoadedToHSP
select  sf.[user] as TP, count(DISTINCT SF.[FILENAME]) NeverLoadedToHSP 
into #NeverLoadedToHSP
from #AreInSFTP_Not_HSP sf
group by  [user]

-- Excel Sheet: Summary Reconciliation sheet. H
drop table if exists #InvalidOpenNeverValid
select   sf.[user] as TP,  count(DISTINCT SF.[FILENAME]) as [InvalidOpenNeverValid] 
into #InvalidOpenNeverValid
from #InvOpen_NeverVal sf
group by sf.[user]

-- Excel Sheet: Summary Reconciliation sheet. I
drop table if exists #Valid
select sf.[user] as TP, count(distinct sf.[FileName]) as Valid
into #Valid
from #ValidFiles sf
group by sf.[user]


------==============================================================================================================================================================================
-- Get claims count from the files not found in HSP
------==============================================================================================================================================================================
-- Get all the claims  found in ClaimMaster from the SFTP files
drop table if exists #SFTP_ClaimsFoundInCM
select distinct sf.[FileName],min(sf.LogTime) as SFTPLogTime, dv.clearinghouseid as dcn
into #SFTP_ClaimsFoundInCM
from #EDI_SFTPFiles sf
join (
	select distinct clearinghouseid, 
		case when CHARINDEX('.837', [filename]) > 0 
		then	substring ( [filename] , 0, CHARINDEX('.837', [filename]) )
		else [filename]
		end  as [filename]
		from vega.encounter.[dbo].[EDI_DailyValidation_Claims]) dv on dv.[filename] = sf.[FileName]
group by sf.FileName, dv.clearinghouseId


--group by OrigFileName, [FileName],SFTPlogtime
drop table if exists #ClaimsCountAreInSFTP_Not_HSP
select h.OrigFileName, h.[FileName],h.SFTPlogtime, 	
	 count(distinct cm.dcn) as claimCount
	 into #ClaimsCountAreInSFTP_Not_HSP
from #AreInSFTP_Not_HSP h
join #SFTP_ClaimsFoundInCM cm on cm.[FileName] = h.[filename]
group by h.OrigFileName, h.[FileName],h.SFTPlogtime

------==============================================================================================================================================================================
-- Get claims count from the INVALID files 
------==============================================================================================================================================================================
drop table if exists #ClaimsCountInvOpen_NeverVal
select h.OrigFileName, h.[FileName],h.SFTPlogtime, 	
	 count(distinct cm.dcn) as claimCount
into #ClaimsCountInvOpen_NeverVal
from #InvOpen_NeverVal h
join #SFTP_ClaimsFoundInCM cm on cm.[FileName] = h.[filename]
group by h.OrigFileName, h.[FileName],h.SFTPlogtime


------==============================================================================================================================================================================
-- From a given files, identify the claims loaded in claim master that doesn't exist in HSP
------==============================================================================================================================================================================
-- Get the files from SFTP for a date range 
-- join those files with claim master, get record count and details of DCN
-- Get all the claims that exists in ClaimMaster and doesn't exist in HSP based on FileName and DCN
------==============================================================================================================================================================================
---- Get the files from SFTP that are valid in HSP 
drop table if exists #FilesToCheck
select sf.[user] as TradingPartner, sf.[filename], min(Logtime) as SFTPLogTime
into #FilesToCheck
from #EDI_SFTPFiles sf
join #EDI_HSPFiles hs on hs.[FileName] = sf.[FileName]
WHERE 1=1
	and hs.[FileStatus] in ('VALID')
group by sf.[user], sf.[filename]

drop table if exists #EDI_HSPFiles

drop table if exists #HSPValidFilesClaimsInCM
select distinct h.*,cm.DCN
into #HSPValidFilesClaimsInCM
from #FilesToCheck h
join #SFTP_ClaimsFoundInCM cm on cm.[FileName] = h.[filename]

drop table if exists #FilesToCheck

-- getting data  from Diamond
drop table if exists #Diamond_Claims
select distinct sf.[FileName],min(sf.LogTime) as SFTPLogTime, dv.CADCN as dcn
into #Diamond_Claims
from #EDI_SFTPFiles sf
join (
	select distinct CADCN, 
		case when CHARINDEX('.837', CASOURCE) > 0 
		then	substring ( CASOURCE , 0, CHARINDEX('.837', CASOURCE) )
		else CASOURCE
		end  as [FileName]
		from [VEGA].Diam_725.diamond.[vw_Diamond.JEDIHSM0_ISG]) dv on dv.[filename] = sf.[FileName]
group by sf.FileName, dv.CADCN

drop table if exists #EDI_SFTPFiles
--==============================================================================================================================================================================
--	           D IS P L A Y     D A T A 
--==============================================================================================================================================================================

--------==============================================================================================================================================================================
-- Display files and claims count
--------==============================================================================================================================================================================

--------==============================================================================================================================================================================
---- Excel Sheet: Files In SFTP NotInHSP 
--------==============================================================================================================================================================================
truncate table HSP_Supplemental.dbo.EDI_FilesInSFTPNotInHSP -- clear the data 

insert into  HSP_Supplemental.dbo.EDI_FilesInSFTPNotInHSP (
       [OrigFileName]
      ,[FileName]
      ,[SFTPLogTime]
      ,[Folder]
      ,[Submitter]
      ,[RawFileClaimCount])

select distinct  f.OrigFileName,f.[FileName], f.SFTPLogTime, f.Folder, f.[user] as [Submitter],  
	isnull(c.ClaimCount,0) as ClaimCount -- either null or zero claimscount then set to NULL which means File need to be loaded into Claim Master Table
from #AreInSFTP_Not_HSP f
left join #ClaimsCountAreInSFTP_Not_HSP c on c.[FileName] = f.[FileName]

--------==============================================================================================================================================================================
---- Excel Sheet: Invalid_Open-Files In HSP Excel Sheet
--------==============================================================================================================================================================================
truncate table [HSP_Supplemental].[dbo].[EDI_InvalidOpenFilesInHSP]

insert into [HSP_Supplemental].[dbo].[EDI_InvalidOpenFilesInHSP] (
       [OrigFileName]
      ,[FileName]
      ,[SFTPLogTime]
      ,[Folder]
      ,[Submitter]
      ,[FileStatus]
      ,[HSPProcessedDate]
      ,[HSPLogClaimCount]
      ,[RawFileClaimCount])
select distinct f.OrigFileName,f.[FileName], f.SFTPLogTime, f.Folder, f.[user] as [Submitter], f.FileStatus,  f.ProcessedDate
,CountOfClaims as HSPLogClaimsCount,
 isnull(c.ClaimCount,0) as ClaimCount -- either null or zero claimscount then set to NULL which means File need to be loaded into Claim Master Table
from #InvOpen_NeverVal f
left join #ClaimsCountInvOpen_NeverVal c on c.[FileName] = f.[FileName]


--------==============================================================================================================================================================================
---- Excel Sheet: Valid Files In HSP
--------==============================================================================================================================================================================
truncate table [HSP_Supplemental].[dbo].[EDI_ValidFilesInHSP]

insert into [HSP_Supplemental].[dbo].[EDI_ValidFilesInHSP] (
	   [SFTPLogTime]
      ,[SFTPSubmitter]      
      ,[HSPFileName]
      ,[HSPProcessedDate]
      ,[HSPLogClaimCount]
      ,[HSPLoadClaimCount]
      ,[HSPEmptyDCNClaimCount]
      ,[DiamondClaimCount]
      ,[RawFileClaimCount]
	  ,[SFTPFileName]
      ,[SFTPFolder])

select distinct v.SFTPLogTime,v.[user] as  Submitter, v.HSPOrigFileName as HSPFileName,v.ProcessedDate, v.CountOfClaims as HSPLogCLaimsCount
,case when cc.HSPClaimCount is null then  0
	else  cc.HSPClaimCount 
	end as HSPLoadClaimsCount
,case when dcn.HSPEmptyDCNClaimCount is null then  0
	else  dcn.HSPEmptyDCNClaimCount
	end as HSPEmptyDCNClaimCount
,case when dc.DiamondClaimCount is null then  0
	else  dc.DiamondClaimCount 
	end as DiamondClaimsCount,
isnull(c.ClaimCount,0) as ClaimCount -- either null or zero claimscount then set to NULL which means File need to be loaded into Claim Master Table
,v.[FileName], v.Folder
from #ValidFiles v
left join (
		select [filename], count(distinct dcn) as ClaimCount
		from #HSPValidFilesClaimsInCM
		group by [filename]) c on c.[FileName] = v.[Filename]
left join(
		select [FileName], count(distinct ClaimNumber)as HSPClaimCount
		from #ClaimInHSP
		where isnull(ExternalClaimNumber ,'') <>''
		group by [FileName]	)cc on cc.[FileName ] = v.[FileName]
left join(
		select [FileName], count(distinct dcn) as DiamondClaimCount
		from #Diamond_Claims
		group by [FileName]	)dc on dc.[FileName ] = v.[FileName]

left join (
		select [FileName], count(distinct ClaimNumber) as HSPEmptyDCNClaimCount
		from #ClaimInHSP
		where isnull(ExternalClaimNumber ,'') =''
		group by [FileName]) dcn on dcn.[FileName ] = v.[FileName]

drop table if exists #Diamond_Claims
drop table if exists #ClaimInHSP
drop table if exists #AreInSFTP_Not_HSP
--------==============================================================================================================================================================================
---- Excel Sheet: Summary Reconciliation  B4 to C7
--------==============================================================================================================================================================================
-- Get totals
--Excel Sheet: Summary Reconciliation sheet. B4
truncate table [HSP_Supplemental].[dbo].[EDI_ValidFilesInHSP]

insert into [HSP_Supplemental].[dbo].[EDI_ValidFilesInHSP]
  ([Description]
      ,[FileCount]
      ,[ClaimCount])
select  'FileCountSFTP' AS [Description],( select sum (case when sf.FileCountSFTP is null	 
	then 0
	else sf.FileCountSFTP
	end) 
	From #SFTPCounts SF )as [FileCount]
	--testing 
	,(select count(1) 
	  from #SFTP_ClaimsFoundInCM)as  ClaimCount	 	
	  
union all
--Excel Sheet: Summary Reconciliation sheet. B5	
	select  'NeverLoadedToHSP' AS Descripton,
	case when (select sum(case when hs.NeverLoadedToHSP is null	
	then 0
	else hs.NeverLoadedToHSP
	end)
	from #NeverLoadedToHSP hs) is null then 0
	else
	(select sum(case when hs.NeverLoadedToHSP is null	
	then 0
	else hs.NeverLoadedToHSP
	end)
	from #NeverLoadedToHSP hs) end FileCount
	,  (select case when (select sum(claimCount)
		from #ClaimsCountAreInSFTP_Not_HSP) is Null then 0
		else
		(select sum(claimCount)
		from #ClaimsCountAreInSFTP_Not_HSP)
		end) as ClaimCount
		
union all 
--Excel Sheet: Summary Reconciliation sheet. B6	
	
	select  'InvalidOpenNeverValidHSP' AS Descripton,	
	case when
	(select sum(case when hs.InvalidOpenNeverValid is null	
	then 0
	else hs.InvalidOpenNeverValid
	end)
	from #InvalidOpenNeverValid hs)  is null then 0
	else 
	(select sum(case when hs.InvalidOpenNeverValid is null	
	then 0
	else hs.InvalidOpenNeverValid
	end)
	from #InvalidOpenNeverValid hs)  end FileCount

	,  (select case when (select sum(claimCount)
		from #ClaimsCountInvOpen_NeverVal) is Null then 0
		else
		(select sum(claimCount)
		from #ClaimsCountInvOpen_NeverVal)
		end) as ClaimCount
	 
union all 
--Excel Sheet: Summary Reconciliation sheet. B7
select  'ValidHSP' AS Descripton, (select sum(case when  va.Valid is null	
	then 0
	else  va.Valid
	end)
	from #Valid va
	) as FileCount
	,(select count(1) from #HSPValidFilesClaimsInCM ) CMCount
Union all
select   'From Date ' +  convert(varchar(35),@FromDateTime)  AS Descripton, 0 as FileCount,	0 as CMCount	
Union all
select   'To Date ' +  convert(varchar(35),@ToDateTime)  AS Descripton, 0 as FileCount,	0 as CMCount	



--------==============================================================================================================================================================================z
--Excel Sheet: Summary Reconciliation sheet. (by Trading Partner)
--------==============================================================================================================================================================================
truncate table  [HSP_Supplemental].[dbo].[EDI_SubmitterSummaryRecon]

insert into  [HSP_Supplemental].[dbo].[EDI_SubmitterSummaryRecon](
  [Submitter]
      ,[RecCountSFTP]
      ,[NeverLoadedToHSP]
      ,[InvalidOpenNeverValid]
      ,[Valid]
)
Select SF.TP as TradingPartner
,case when sf.FileCountSFTP is null	 -- F
	then 0
	else sf.FileCountSFTP
	end as RecCountSFTP
,case when hs.NeverLoadedToHSP is null	--G
	then 0
	else hs.NeverLoadedToHSP
	end as NeverLoadedToHSP
,case when inv.InvalidOpenNeverValid is null	--H
	then 0
	else inv.InvalidOpenNeverValid
	end as InvalidOpenNeverValid
,case when  va.Valid is null	--I
	then 0
	else  va.Valid
	end as  Valid
From #SFTPCounts SF
left join #NeverLoadedToHSP hs on hs.TP= SF.TP
left join #InvalidOpenNeverValid inv on inv.TP  = sf.tp
left join #Valid va on va.tp = sf.TP

union all 
Select 'Grant Total' 
,sum (case when sf.FileCountSFTP is null	
	then 0
	else sf.FileCountSFTP
	end) as SUM_RecCountSFTP
,sum(case when hs.NeverLoadedToHSP is null	
	then 0
	else hs.NeverLoadedToHSP
	end) as SUM_NeverLoadedToHSP

,sum(case when inv.InvalidOpenNeverValid is null	
	then 0
	else inv.InvalidOpenNeverValid
	end) as SUM_InvalidOpenNeverValid
,sum(case when  va.Valid is null	
	then 0
	else  va.Valid
	end) as  SUM_Valid
From #SFTPCounts SF
left join #NeverLoadedToHSP hs on hs.TP= SF.TP
left join #InvalidOpenNeverValid inv on inv.TP  = sf.tp
left join #Valid va on va.tp = sf.TP


drop table if exists #Valid
drop table if exists #ValidFiles
drop table if exists #SFTPCounts
drop table if exists #SFTP_ClaimsFoundInCM
drop table if exists #NeverLoadedToHSP
drop table if exists #InvOpen_NeverVal
drop table if exists #InvalidOpenNeverValid
drop table if exists #HSPValidFilesClaimsInCM
drop table if exists #ClaimsCountInvOpen_NeverVal
drop table if exists #ClaimsCountAreInSFTP_Not_HSP