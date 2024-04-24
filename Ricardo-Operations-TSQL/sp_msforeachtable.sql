USE [CorepointQueuesAndLogs]
GO

--TRUNCATE TABLE [payloadhistory].[20170606_01039]

--EXEC sp_help sp_msforeachtable

USE [CorepointQueuesAndLogs]
 GO
 EXEC sp_msforeachtable
	 @command1 ='EXEC sp_spaceused ''?'''
	--,@whereand = ' And Object_id In (Select Object_id From sys.objects Where schema_id = 7 AND TYPE = ''U'')'
	

--TEST
--Select * From sys.objects Where schema_id = 7 AND TYPE = 'U'

----FIND OBJECTS
--Select * From sys.objects order by name 

----FIND SCHEMA
--SELECT  * FROM    sys.schemas s 
--        INNER JOIN sys.sysusers u
--            ON u.uid = s.principal_id