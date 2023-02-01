use HSP_Supplemental
exec [EDI].[usp_InboundReconciliationHSPGetData] NULL,NULL,'D'
select * from [dbo].[EDI_FilesInSFTPNotInHSP]
select * from [dbo].[EDI_InvalidOpenFilesInHSP]
select * from [dbo].[EDI_SubmitterSummaryRecon]
select * from [dbo].[EDI_SummaryRecon]
select * from [dbo].[EDI_ValidFilesInHSP]

--HSP1S1B
--HSP2X1A
--HSP3S1A
--HSP4S1A

