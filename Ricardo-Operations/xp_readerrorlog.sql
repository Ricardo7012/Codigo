-- LOCATION 
USE MASTER
GO
EXEC xp_readerrorlog 0, 1, N'Logging SQL Server messages in file'
GO


DECLARE @InstanceName nvarchar(4000),
        @LogType int,
        @ArchiveID int,
        @Filter1Text nvarchar(4000),
        @Filter2Text nvarchar(4000),
        @FirstEntry datetime,
        @LastEntry datetime

Select  @InstanceName=NULL,          -- Don't know 
        @LogType = 1,                -- File Type (1 = ERRORLOG OR 2 = SQLAgent)
        @ArchiveID=0,                -- File Extension (0 = Current i.e. ERRORLOG or SQLAgent.out, 1 = ERRORLOG.1 or SQLAgent.1 and so on)
        @Filter1Text='availability group failed over',      -- First Text Filter
        @Filter2Text=NULL,           -- Second Text Filter
        @FirstEntry=NULL,            -- Start Date
        @LastEntry=NULL              -- End Date

EXEC master.dbo.xp_readerrorlog @ArchiveID, @LogType, @Filter1Text, @Filter2Text, @FirstEntry, @LastEntry, N'desc', @InstanceName 

EXEC sys.xp_readerrorlog 0, 1, '', NULL, NULL, NULL, 'DESC'
--Value of error log file you want to read: 0 = current, 
--1 Archive #1, 2 = Archive #2, etc... 
--2.Log file type: 1 or NULL = error log, 2 = SQL Agent log 
--3.Search string 1: String one you want to search for 
--4.Search string 2: String two you want to search for to further refine the results 
--5.Search from start time   
--6.Search to end time  
--7.Sort order for results: N'asc' = ascending, N'desc' = descending

EXEC sp_readerrorlog 0, 1, 'availability group failed over', ''

--1.Value of error log file you want to read: 0 = current, 1 = Archive #1, 2 = Archive #2, etc... 
--2.Log file type: 1 or NULL = error log, 2 = SQL Agent log 
--3.Search string 1: String one you want to search for 
--4.Search string 2: String two you want to search for to further refine the results
