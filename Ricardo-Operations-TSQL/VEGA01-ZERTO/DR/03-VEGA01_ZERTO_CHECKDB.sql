
/***********************************************************************
OPTIONAL --DBCC CHECK - YOU MAY LEAVE THIS RUNNING AND CONTINUE DR STEPS
************************************************************************/
USE master
go
EXECUTE dbo.DatabaseIntegrityCheck
@Databases = 'ALL_DATABASES',
@CheckCommands = 'CHECKDB',
@ExtendedLogicalChecks = 'Y'
