-- http://dba.stackexchange.com/questions/119736/is-database-mail-worth-the-risk-a-standard-practice

EXECUTE msdb.dbo.sysmail_help_status_sp ;

SELECT TOP 20 *
FROM [msdb].[dbo].[sysmail_allitems]
ORDER BY [send_request_date] DESC

SELECT TOP 20 *
FROM [msdb].[dbo].[sysmail_sentitems]
ORDER BY [send_request_date] DESC

SELECT TOP 20 *
FROM [msdb].[dbo].[sysmail_faileditems]
ORDER BY [send_request_date] DESC


DECLARE @sql1 varchar(1000)
DECLARE @sql2 varchar(1000) 
SET @sql2 = 'exec uu_SendEMailRequests @profile_name=''HSP_DBMAIL_DEV''
exec uu_SendBillingWizardEmailRequests @Profile_Name=''HSP_DBMAIL_DEV''
exec uu_SendMemberEmailRequests @profile_name = ''HSP_DBMAIL_DEV''
exec uu_SendVendorEmailRequests @profile_name = ''HSP_DBMAIL_DEV''
exec uu_SendCheckRunEmailRequests @profile_name = ''HSP_DBMAIL_DEV'''

SELECT @sql1 = 'USE [?]
IF ''?'' <> ''master'' AND ''?'' <> ''model'' AND ''?'' <> ''DWBI5'' AND ''?'' <> ''HSP_SUPPLEMENTAL'' AND ''?'' <> ''IEHP_HSPRPTDEV'' AND ''?'' <> ''msdb'' AND ''?'' <> ''tempdb'' AND ''?'' <> ''HSPLicensing'' AND ''?'' <> ''LiteSpeedLocal'' 
BEGIN
--PRINT ''?''
USE [?] 
' + @sql2 + 
'END'
EXEC sp_msforeachdb @sql1 

--PRINT @SQL1
--PRINT @SQL2

