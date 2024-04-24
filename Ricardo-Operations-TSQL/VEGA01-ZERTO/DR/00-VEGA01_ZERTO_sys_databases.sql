/***********************************************************************
SYS.DATABASES STATUS
************************************************************************/
USE MASTER
GO

SELECT 
name
, user_access_desc
, state_desc
, log_reuse_wait_desc
FROM sys.databases
--where state_desc = 'suspect'
where state_desc <> 'online'

