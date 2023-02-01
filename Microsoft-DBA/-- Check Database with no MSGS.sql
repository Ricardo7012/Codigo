-- Check Database with no MSGS

-- DBCC CHECKDB     
--	[ ( database_name | database_id | 0         
--	[ , NOINDEX         | , { REPAIR_ALLOW_DATA_LOSS | REPAIR_FAST | REPAIR_REBUILD } ]     
--	) ]     
--	[ WITH         
--		{             
--			[ ALL_ERRORMSGS ]             
--			[ , EXTENDED_LOGICAL_CHECKS ]             
--			[ , NO_INFOMSGS ]             
--			[ , TABLOCK ]             
--			[ , ESTIMATEONLY ]             
--			[ , { PHYSICAL_ONLY | DATA_PURITY } ]             
--			[ , MAXDOP = number_of_processors ]         
--		}     
--	] 
-- ]


DECLARE @DatabaseName varchar(30)

SET @DatabaseName = 'ezPay'

DBCC CHECKDB (@DatabaseName) WITH NO_INFOMSGS