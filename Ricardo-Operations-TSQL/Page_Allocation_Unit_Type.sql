--https://blog.purestorage.com/purely-technical/deduplication-compression-and-sql-server-databases-part-2/

SELECT count(*) as pages,
	dpa.allocation_unit_type_desc 
FROM 
	sys.dm_db_database_page_allocations(DB_ID('HSP_Support'),OBJECT_ID('[dbo].[AuditTrail]'), 1,NULL, 'Detailed') dpa
GROUP BY 
	dpa.allocation_unit_type_desc 
