----------------
--INSTRUCTIONS
----------------

-- By running this script:

--1.	It creates a database called PolybaseDMVs_v2.
--2.	It runs each one of the DMV’s mentioned above for the last 20 “external queries” executed on that instance and it will create and populate a table for each DMV. If needed we can edit to collect more than just as 20 queries.
--3.	In the end customer just need to backup this database and upload it for us: --backup database PolybaseDMVs_v2 to disk='<path>\PolybaseDMVs_v2.bak' with init, format, compression
--a.	If possible, customer should also upload PolyBase logs. 
--4.	After we have the backup, customer can go ahead and delete this database.

       --EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'PolybaseDMVs_v2'
       --GO
       --use [PolybaseDMVs_v2];
       --GO
       --use [master];
       --GO
       --USE [master]
       --GO
       --ALTER DATABASE [PolybaseDMVs_v2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
       --GO
       --USE [master]
       --GO
       --/****** Object:  Database [PolybaseDMVs_v2]    Script Date: 3/19/2020 7:02:06 AM ******/
       --DROP DATABASE [PolybaseDMVs_v2]
       --GO

----------------
--RELEASE NOTES:
----------------
---------
-- v2:
---------
	--I realize there was a “bug” on first version. I was only considering execution_id and not sql_handle when select from sys.dm_exec_distributed_requests.
	--There are some “external queries” that can generate more than one execution_id (for example an external query with an execution plan that needs to get data from 2 different tables on external side and then join them locally), and this could cause some missing data.
	
	--Solution: Now we are getting top 20 most recent SQL handles and get all execution_id's for those queries.


CREATE DATABASE PolybaseDMVs_v2
-- ON  PRIMARY 
--( NAME = N'PolybaseDMVs_v2', FILENAME = N'<path>\PolybaseDMVs_v2.mdf')
-- LOG ON 
--( NAME = N'PolybaseDMVs_v2_log', FILENAME = N'<path>\PolybaseDMVs_v2.ldf')

go
USE PolybaseDMVs_v2
go

-- Get last 20 "external queries" executed on this instance:
select *
into PolybaseDMVs_v2.dbo.dm_exec_distributed_requests
from sys.dm_exec_distributed_requests  dr  
      cross apply sys.dm_exec_sql_text(sql_handle) st  
where st.text not like '%CREATE FUNCTION%'
and sql_handle in (

	select top 20 sql_handle from (
		select sql_handle,  max(start_time) as start_time
		from sys.dm_exec_distributed_requests  dr  
			  cross apply sys.dm_exec_sql_text(sql_handle) st  
		where st.text not like '%CREATE FUNCTION%'
		group by sql_handle) q
	order by start_time desc
)
order by start_time desc;  

-- Full DSQL Plan steps: Shows where each operation was performed. Create temporary objects, --move data from extern data source and then perform aggregations.
select * 
into PolybaseDMVs_v2.dbo.dm_exec_distributed_request_steps
from sys.dm_exec_distributed_request_steps
where execution_id in (
	select distinct execution_id
	from PolybaseDMVs_v2.dbo.dm_exec_distributed_requests
)
 
-- Steps executed by the Engine Service: Holds information about all SQL query distribution as part of a SQL step in the query. This view shows the data for the last 1000 requests; active requests always have the data present in this view.
 
select * 
into PolybaseDMVs_v2.dbo.dm_exec_distributed_sql_requests 
from sys.dm_exec_distributed_sql_requests 
where execution_id in (
	select distinct execution_id
	from PolybaseDMVs_v2.dbo.dm_exec_distributed_requests
)
 
-- Steps executed by DMS in the form of DMS plans: Holds information about all workers completing DMS steps.This view shows the data for the last 1000 requests and active requests; active requests always have the data present in this view.
select * 
into PolybaseDMVs_v2.dbo.dm_exec_dms_workers 
from sys.dm_exec_dms_workers 
where execution_id in (
	select distinct execution_id
	from PolybaseDMVs_v2.dbo.dm_exec_distributed_requests
)
 
-- Queries sent to external backends: Returns information about the workload per worker, on each compute node.
 
--Query sys.dm_exec_external_work to identify the work spun up to communicate with the external data source (e.g. Hadoop or external SQL Server).
select * 
into PolybaseDMVs_v2.dbo.dm_exec_external_work 
from sys.dm_exec_external_work 
where execution_id in (
	select distinct execution_id
	from PolybaseDMVs_v2.dbo.dm_exec_distributed_requests
)
 
-- Get all past Polybase errors
select * 
into PolybaseDMVs_v2.dbo.dm_exec_compute_node_errors
from sys.dm_exec_compute_node_errors

go

-----------------
-- How to query?
-----------------

-- Once we restore this backup file, run the queries on this order (feel free to add filters as per your need):

-- select * from PolybaseDMVs_v2.dbo.dm_exec_distributed_requests order by start_time desc, execution_id desc
-- select * from PolybaseDMVs_v2.dbo.dm_exec_distributed_request_steps order by start_time desc, execution_id desc, step_index asc
-- select * from PolybaseDMVs_v2.dbo.dm_exec_distributed_sql_requests  order by start_time desc, execution_id desc, step_index asc
-- select * from PolybaseDMVs_v2.dbo.dm_exec_dms_workers  order by start_time desc, execution_id desc, step_index asc
-- select * from PolybaseDMVs_v2.dbo.dm_exec_external_work order by start_time desc, execution_id desc, step_index asc
-- select top 1000 * from PolybaseDMVs_v2.dbo.dm_exec_compute_node_errors order by execution_id desc

------------
----BACKUP
------------

	--backup database PolybaseDMVs_v2 to disk='<path>\PolybaseDMVs_v2.bak' with init, format, compression

---------------------
----DROP DATABASE
---------------------


	--EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'PolybaseDMVs_v2'
	--GO
	--use [PolybaseDMVs_v2];
	--GO
	--use [master];
	--GO
	--USE [master]
	--GO
	--ALTER DATABASE [PolybaseDMVs_v2] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
	--GO
	--USE [master]
	--GO
	--/****** Object:  Database [PolybaseDMVs_v2]    Script Date: 3/19/2020 7:02:06 AM ******/
	--DROP DATABASE [PolybaseDMVs_v2]
	--GO


