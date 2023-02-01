/****** Object: StoredProcedure [dbo].[adminDefragIndexesDaily] Script Date: 06/12/2008 08:31:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[adminDefragIndexesDaily]
AS
--******************************************************************************************--
-- CREATED BY:                                                             --
-- CREATED ON:        5 JUN 2008                                                                --
----------------------------------------------------------------------------------------------
-- VARIABLES:        TO DEFRAG INDEXES WITH > 15% FRAGMENTATION.                                --
------------------- THIS VARIABLE CAN BE CHANGED, BUT, THE STORED PROCEDURE WILL            --
------------------- HAVE TO BE ALTERED AS THE VALUES ARE HARD CODED. THESE ARE THE            --
------------------- NORM IN VALIDATING THE PERFORMANCE OF INDEXES ON A TRANSACTIONAL        --
------------------- ENVIRONMENT.                                                            --
--******************************************************************************************--
-- MODIFICATION:    12 JUN 2008                                                                --
-------------------    TO ADD THE BEGIN AND END TIME TO EACH OF THE DEFRAGS SO WE CAN KEEP        --
-------------------    BETTER TRACK OF THE TIME THAT THEY CONSUME. THIS WILL ALLOW US TO        --
------------------- MODIFY THE SCRIPTS ACCORDINGLY AS THEY GET INCREASINGLY LONGER            --
------------------- IN ADDITION, I AM ADDING A LOGGING TABLE TO KEEP THE DATA IN FOR        --
------------------- REFERENCE. ADDED SYSADMIN CONTEXT FOR ENSURING SECURITY AS WELL.        --
--******************************************************************************************--
-- PURPOSE:            THE PROCEDURE IS TO PROVIDE DAILY MAINTENANCE FOR                        --
        ----------- INDEXES ON . THIS IS A CUSTOM PROCEDURE DESIGNED TO                --
        ----------- OPTIMIZE THE EDI PROCESS DUE TO THE AMOUNT OF INSERTS,                    --
        ----------- AND DELETES IN THE TABLES.                                                --
--******************************************************************************************--



BEGIN TRY
SET NOCOUNT ON



DECLARE @SQL VARCHAR(500);
DECLARE @MINDEFRAGID INT; 
DECLARE @MAXDEFRAGID INT;
DECLARE @tableHTML NVARCHAR(MAX) ;
DECLARE @Emailrecipients VARCHAR(100)
DECLARE @EmailSubject VARCHAR(100)
DECLARE @BeginTime smalldatetime
DECLARE @EndTime smalldatetime
DECLARE @ObjectName VARCHAR(128)
DECLARE @DBName VARCHAR(128)
DECLARE @ERROR INT
DECLARE @ERRORMESSAGE VARCHAR(500)

-- SET ENVIRONMENT VARIABLES WHERE THEY CAN BE STATIC.
SET @EmailSubject = 'SUCCESSFULLY DEFRAGMENTED INDEXES ON [ServerName].'
SET @Emailrecipients = 'email@zzz.com'
SELECT @DBName = db_name(db_id())

IF IS_SRVROLEMEMBER('sysadmin') <> 1
    BEGIN
            PRINT 'YOU ARE NOT A MEMBER OF THE SYSADMIN FIXED SERVER ROLE. YOU ARE THEREFORE UNABLE TO RUN THIS PROCEDURE.'
            PRINT 'PLEASE CONTACT YOUR HANDI DANDI DBA TO ASSIST WITH RUNNING THIS PROCEDURE.'
            SET @EmailSubject = 'Security violation on ' + @@SERVERNAME + '.'
            SET @ERRORMESSAGE = 'UNAUTHORIZED ACCESS TO ' + OBJECT_NAME(@@PROCID)
    -- SEND MAIL TO DBA IF THERE IS A FAILURE
        EXEC msdb.dbo.sp_send_dbmail 
            @recipients = @Emailrecipients,
            @subject = @EmailSubject,
            @body = @ERRORMESSAGE;
    -- RAISE ERROR IN THE LOG
            RETURN
    END

-- CREATE TABLE TO DISPLAY AND PARSE DBCC SHOWCONTIG RESULTS.
CREATE TABLE #adminShowContigResults
(
objectName varchar(128) not null,
objectID int not null,
indexName varchar(128) not null,
indexID tinyint not null,
level smallint not null,
pages int not null,
rows bigint not null,
minimumRecordSize int not null,
maximumRecordSize int not null,
averageRecordSize decimal(15,3) not null,
forwardedRecords int not null,
extents int not null,
extentSwitches int not null,
averageFreeBytes decimal(15,3) not null,
averagePageDensity decimal(15,3) not null,
scanDensity decimal(15,3) not null,
bestCount int not null,
actualCount int not null,
logicalFragmentation decimal(15,3) not null,
extentFragmentation decimal(15,3) not NULL

)

-- CREATE A TABLE THAT WILL DISPLAY ALL OF THE ITEMS THAT WILL NEED DEFRAGGED.
-- THIS WILL ALSO BE USED IN ANY MESSAGE THAT IS SENT OUT.
CREATE TABLE #defrag
(defragid int identity(1,1) not null,
objectName varchar(128) not null,
pages int not null,
rows bigint not null,
extents int not null,
scanDensity decimal(15,3) not null,
logicalFragmentation decimal(15,3) not null,
newFragmentationLevel decimal(15,3) NULL,
beginTime SMALLDATETIME NULL,
endTime SMALLDATETIME NULL,
)

-- INSERT DATA FROM DBCC SHOWCONTIG TO DISPLAY AND PARSE ALL FRAGMENTATION LEVELS.
INSERT INTO #adminShowContigResults(objectName, objectID, indexName, indexID, level, pages, rows, minimumRecordSize, maximumRecordSize, averageRecordSize, forwardedRecords, extents, extentSwitches, averageFreeBytes, averagePageDensity, scanDensity, bestCount, actualCount, logicalFragmentation, extentFragmentation)
EXEC ('DBCC SHOWCONTIG() WITH TABLERESULTS')

-- DISPLAY ALL OF THE ITEMS THAT WILL NEED DEFRAGGED AND FOR MESSAGING.
INSERT INTO #defrag (objectName, pages, rows, extents, scanDensity, logicalFragmentation)
SELECT objectName, pages, rows, extents, scanDensity, logicalFragmentation
FROM #adminShowContigResults
WHERE rows > 100 
AND extents > 20 
AND averagePageDensity < 85 
AND logicalFragmentation > 15 
AND extentFragmentation > 15
ORDER BY rows

SELECT @MINDEFRAGID = MIN(defragid) FROM #defrag
SELECT @MAXDEFRAGID = MAX(defragid) FROM #defrag

IF @MINDEFRAGID IS NULL
    BEGIN

        SET @tableHTML = N'<STYLE TYPE="text/css">TD{font-family: calibri; font-size: 10pt;}</STYLE>' + 
        N'<b><font face="calibri" size="2">This report represents index(s) which have an average fragmentation > than 15 percent. These index(s) have been targeted for maintenance.</font></b><br><br>' +
        N'<table border="1" cellpadding="2" cellspacing="2" border="1">' +
        N'<tr><th><font face="calibri" size="2">MESSAGE</font></th><th>' +
        CAST ((SELECT td = 'THERE ARE NO TABLES IN THE DATABASE TO DEFRAG' 
        FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
        N'</table>' ;

        EXEC msdb.dbo.sp_send_dbmail 
            @recipients = @Emailrecipients,
            @subject = @EmailSubject,
            @body = @tableHTML,
            @body_format = 'HTML' ;
    END

ELSE
    BEGIN 

        WHILE (@MINDEFRAGID <= @MAXDEFRAGID)
            BEGIN 
                SELECT @ObjectName = objectName FROM #defrag
                WHERE defragid = @MINDEFRAGID

                SET @SQL = 'dbcc indexdefrag(' + @DBName + ',' + @ObjectName + ') WITH NO_INFOMSGS'

                SELECT @BeginTime = CONVERT(VARCHAR(19), GETDATE(), 120)
                
                EXEC (@SQL)
                
                SELECT @EndTime = CONVERT(VARCHAR(19), GETDATE(), 120)
                
                TRUNCATE TABLE #adminShowContigResults

                SET @SQL = 'DBCC SHOWCONTIG(' + char(39) + 'dbo.'+ @ObjectName + char(39) + ') WITH TABLERESULTS'

                INSERT INTO #adminShowContigResults(objectName, objectID, indexName, indexID, level, pages, rows, minimumRecordSize, maximumRecordSize, averageRecordSize, forwardedRecords, extents, extentSwitches, averageFreeBytes, averagePageDensity, scanDensity, bestCount, actualCount, logicalFragmentation, extentFragmentation)
                    
                EXEC (@SQL)
                

                UPDATE #defrag
                    SET newFragmentationLevel = s.logicalFragmentation,
                        beginTime = @BeginTime,
                        endTime = @EndTime
                FROM #defrag d JOIN #adminShowContigResults s ON
                    d.objectName = s.objectName

                PRINT 'SUCCESSFULLY DEFRAGGED ' + @ObjectName + '.'

                SET @MINDEFRAGID = (SELECT MIN(defragid)
                FROM #defrag
                WHERE defragid > @MINDEFRAGID)
            END

        SET @tableHTML = N'<STYLE TYPE="text/css">TD{font-family: calibri; font-size: 10pt;}</STYLE>' + 
        N'<b><font face="calibri" size="2">This report represents index(s) which have an average fragmentation > than 15 percent. These index(s) have been targeted for maintenance.</font></b><br><br>' +
        N'<table border="1" cellpadding="2" cellspacing="2" border="1">' +
        N'<tr><th><font face="calibri" size="2">Object Name</font></th><th><font face="calibri" size="2">Pages</font></th><th><font face="calibri" size="2">Rows</font></th><th><font face="calibri" size="2">Extents</font></th><th><font face="calibri" size="2">Scan Density</font></th><th><font face="calibri" size="2">Logical Fragmentation</font></th><th><font face="calibri" size="2">New Fragmentation Level</font></th><th><font face="calibri" size="2">BEGIN TIME</font></th><th><font face="calibri" size="2">END TIME</font></th>' +
        CAST ((SELECT td = objectName, '', 
        td = pages, '', 
        td = rows, '',
        td = extents, '',
        td = scanDensity, '',
        td = logicalFragmentation, '', 
        td = newFragmentationLevel, '',
        td = beginTime, '',
        td = endTime 
        FROM #defrag
        FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
        N'</table>' ;

        EXEC msdb.dbo.sp_send_dbmail 
            @recipients = @Emailrecipients,
            @subject = @EmailSubject,
            @body = @tableHTML,
            @body_format = 'HTML' ;
    END

DROP TABLE #defrag
DROP TABLE #adminShowContigResults

END TRY
BEGIN CATCH
    -- SET VARIABLES FOR ERROR HANDLING
    SET @ERROR = ERROR_NUMBER()
    SET @ERRORMESSAGE = 'MSG ' + CAST(ERROR_NUMBER() AS VARCHAR) + ', ' + ISNULL(ERROR_MESSAGE(),'')
    SET @EmailSubject = 'FAILED TO DEFRAGMENT INDEXES ON S01GIS2.'
    -- SEND MAIL TO DBA IF THERE IS A FAILURE
        EXEC msdb.dbo.sp_send_dbmail 
            @recipients = @Emailrecipients,
            @subject = @EmailSubject,
            @body = @ERRORMESSAGE;
    -- RAISE ERROR IN THE LOG
    RAISERROR(@ERRORMESSAGE,16,1) WITH NOWAIT

END CATCH
