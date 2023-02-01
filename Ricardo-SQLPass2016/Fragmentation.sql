SELECT * FROM sysfiles

-- check the fragmentation of the production table
SELECT [avg_fragmentation_in_percent] FROM sys.dm_db_index_physical_stats (
    DB_ID ('BreezeDEV'), OBJECT_ID ('dbo.PPS_ENUM_DATA_HOSTS'), 1, NULL, 'LIMITED');
GO 

USE BreezeDEV; 
GO 

DBCC SHOWCONTIG ('dbo.DBNAME') 

--TO RETURN INFORMATION FOR ALL THE TABLES AND INDEXES, USE:
SELECT * FROM 
	sys.dm_db_index_physical_stats (NULL, NULL, NULL, NULL, NULL) 
WHERE 
	avg_fragmentation_in_percent > 30;

SELECT * FROM 
	sys.dm_db_index_physical_stats (DB_ID(N'DBNAME'), OBJECT_ID(N''), NULL, NULL , 'DETAILED');

SELECT 
	object_id, index_id, avg_fragmentation_in_percent, page_count 
FROM 
	sys.dm_db_index_physical_stats(DB_ID('')
	, OBJECT_ID('dbo.'), NULL, NULL, NULL);

SELECT *
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('test_contig'), NULL, NULL , 'DETAILED')


-- CHECK THE FRAGMENTATION OF TABLE GREATER THAN 30%
SELECT 
	OBJECT_NAME(i.OBJECT_ID) AS TableName
	,i.name AS IndexName
	,indexstats.avg_fragmentation_in_percent
FROM 
	sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') indexstats
	INNER JOIN 
		sys.indexes i ON i.OBJECT_ID = indexstats.OBJECT_ID
	AND 
		i.index_id = indexstats.index_id
WHERE 
	indexstats.avg_fragmentation_in_percent > 30
ORDER BY TableName 

GO
--OLD WAY -- SQL 2000
--DBCC SHOWCONTIG ('TABLENAME') 
--GO

select * from sys.dm_exec_query_optimizer_info 
select * from sys.dm_exec_query_stats  --- total worker time - 
sp_spaceused
