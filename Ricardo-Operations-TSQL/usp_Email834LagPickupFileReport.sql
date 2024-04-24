
CREATE or alter    PROCEDURE [dbo].[usp_Email834LagPickupFileReport]
AS
/* ============================================================================
 Author:     Mitchell Guzman
 Create date: 05/13/2021
 Description: 
 
 Example:
 EXEC 
  
				History
 Name			Date			Comments
 ==============================================================================
 
 ==============================================================================*/
BEGIN
    SET NOCOUNT ON;

     DECLARE @ErrorMessage		VARCHAR(MAX)
			,@ErrorProcedure	VARCHAR(255)
			,@ErrorSeverity		INT
			,@ErrorState		INT
			,@ErrorLineNumber	INT
			,@To				VARCHAR(100) 
			,@Subject			VARCHAR(1000)
			,@ReportURL			VARCHAR(2000)
			,@tableHTML			VARCHAR(MAX) 
			,@StartDate			DATE
			,@Enddate			DATE
			,@Today				DATE	= GETDATE()
			,@ROWHTML			VARCHAR(MAX)
			,@ROWSHTML			VARCHAR(MAX) = ''
			,@ROWHTMLTML1		VARCHAR(MAX) 
			,@ROWHTMLTML2		VARCHAR(MAX)
			,@ROWS				INT
			,@ROWS1				INT
			,@Start1			INT = 1
			,@Start				INT = 1
			,@REPORTDATE		VARCHAR(100)
			,@EMAIL				VARCHAR(255)
			,@Submitter			VARCHAR(255)
			,@CC				VARCHAR(255)

			DROP TABLE IF EXISTS #tmpWork;
			DROP TABLE IF EXISTS #tmpSubmitter

		CREATE TABLE #tmpWork 
		(
		 IDS			INT IDENTITY(1,1)
		 ,ID			BIGINT
		 ,LogTime		DATETIME
		 ,Action		VARCHAR(20)
		 ,LoginName		VARCHAR(20)
		 ,[User]		VARCHAR(50)
		 ,FileName		VARCHAR(50)
		 ,Folder		VARCHAR(255)
		 ,Error			VARCHAR(MAX)
		 ,CreateDate	DATETIME
		 ,DaysApartNWH	INT
		 ,SubmitterName VARCHAR(255)
		 ,SubmitterID	VARCHAR(50)

		)

		CREATE TABLE #tmpSubmitter
		(
		 ID				INT IDENTITY(1,1)
		 ,SubmitterName VARCHAR(255)
		 ,SubmitterID	VARCHAR(50)
		 ,Email			VARCHAR(256)
		 ,ContactID		INT
		)
	BEGIN TRY

		------------------------------------------------------------------------------
		DROP TABLE IF EXISTS #FilesUploaded;
		DROP TABLE IF EXISTS #FilesDownloaded;
		DROP TABLE IF EXISTS #tmpHold
		------------------------------------------------------------------------------
		IF @StartDate IS NULL
			SET @StartDate = GETDATE() - 120;
		IF @Enddate IS NULL
			SET @Enddate = @Today;

		SELECT ID,
			   LogTime,
			   Action,
			   LoginName,
			   [User],
			   [File],
			   Folder,
			   Error,
			   CreateDate
		  INTO #FilesUploaded
		  FROM dbo.SFTP_Log WITH (NOLOCK)
		 WHERE CONVERT(DATE, LogTime) BETWEEN @StartDate AND @Enddate
		   AND Folder LIKE '%elig%'
		   AND LoginName                      = 'archdev'
		   AND Action                         = 'upload'
		   AND RIGHT([File], 4)               = '.pgp'
		   AND Folder NOT LIKE '/%Test%'
		   AND Folder NOT LIKE '/dev%'
		  --AND DATEDIFF(DAY, LogTime, @Today) > = 3;
		------------------------------------------------------------------------------
		 SELECT [File]
		  INTO #FilesDownloaded
		  FROM dbo.SFTP_Log WITH (NOLOCK)
		  WHERE CONVERT(DATE, LogTime) BETWEEN @StartDate AND @Enddate
		   AND Folder LIKE '%elig%'
		   AND LoginName <> 'archdev'
		   AND Action    = 'Download';
		------------------------------------------------------------------------------
		-- Build the data we need for the report for all submitters
		-------------------------------------------------------------------------------
		SELECT  DISTINCT ID,
		LogTime,
		Action,
		LoginName,
		[User],
		F.[File],
		Folder,
		Error,
		CreateDate,
		DATEDIFF(DD,CONVERT(DATE, LogTime),CONVERT(DATE, @Today)) AS DaysApartNWH,
		C.EntityName AS SubmitterName,
		SUBSTRING (F.[file] ,2 ,3 )	AS SubmitterID	INTO #tmpHold				
		FROM      #FilesUploaded F WITH (NOLOCK)
		JOIN  [Diamond].[dbo].[tblContacts] c ON c.Entity =  SUBSTRING (F.[file] ,2 ,3 )
		LEFT JOIN #FilesDownloaded d ON d.[File] = F.[File]
		WHERE d.[File] IS NULL
		AND IntActive LIKE '0'  
		AND ContactPosition LIKE 'Eligibility'
		AND EMail IS NOT NULL 
		ORDER BY SubmitterName
			
		------------------------------------------------------------------------------
		INSERT INTO #tmpSubmitter (SubmitterName,SubmitterID,Email)
		SELECT z.SubmitterName,z.SubmitterID,z.EMail
		FROM
		(
			SELECT DISTINCT W.SubmitterName,W.SubmitterID,C.EMail,ContactID, RANK() OVER  (PARTITION BY W.SubmitterName ORDER BY ContactID DESC) AS Rank  
			FROM #tmpHold W WITH (NOLOCK)
			JOIN [Diamond].[dbo].[tblContacts] c ON c.Entity =  W.SubmitterID
			WHERE  IntActive LIKE '0'  
			AND ContactPosition LIKE 'Eligibility'
			AND EMail IS NOT NULL 
		) AS Z
		WHERE Rank = 1
		 ---------------------------------------------------------------------------------------
		SELECT @ROWS1 = COUNT(*)
		FROM #tmpSubmitter 
		---------------------------------------------------------------------------------------
		IF @ROWS1 = 0 
			RETURN
		---------------------------------------------------------------------------------------
		--loop thru all the submitters for this daily report
		---------------------------------------------------------------------------------------
		WHILE @Start1 <= @ROWS1
		  BEGIN
			SELECT @EMAIL = W.Email, @Submitter = W.SubmitterName
			FROM #tmpSubmitter w
			WHERE ID = @Start1 
			---------------------------------------------------------------------------------------
			TRUNCATE TABLE #tmpWork
			
			---------------------------------------------------------------------------------------
			INSERT INTO #tmpWork 
			(
			 ID		
			 ,LogTime	
			 ,Action
			 ,LoginName	
			 ,[User]		
			 ,[FileName]		
			 ,Folder		
			 ,Error			
			 ,CreateDate	
			 ,DaysApartNWH	
			 ,SubmitterName 
			 ,SubmitterID	
			 )		 		
			SELECT ID		
			 ,LogTime	
			 ,Action
			 ,LoginName	
			 ,[User]		
			 ,[File]	
			 ,Folder		
			 ,Error			
			 ,CreateDate	
			 ,DaysApartNWH	
			 ,SubmitterName 
			 ,SubmitterID	
			 FROM #tmpHold
			WHERE SubmitterName = @Submitter
			-- AND DaysApartNWH > 2
			---------------------------------------------------------------------------------------				
			SET @Start1 = @Start1 + 1
			------------------------------------------------------------------------------
			-- Build the TO and subject for the email
			-------------------------------------------------------------------------------
			SELECT 	 @TO = 'Rivera-N@iehp.org'-- @EMAIL
					,@CC = 'guzman-m@iehp.org'
					,@Subject = '834 Eligability File  ' + CONVERT(VARCHAR(20),@Today,100)
			--------------------------------------------------------------------------------
			-- create our HTML body with the embeded url
			---------------------------------------------------------------------------------
			SET @ROWHTMLTML1 = '<tr>
								<td style="width: 14.2857%;">~l</td>
								<td style="width: 14.2857%;">~s</td>
								<td style="width: 14.2857%;">~i</td>
								<td style="width: 14.2857%;">~f</td>
								<td style="width: 14.2857%;">~n</td>
								<td style="width: 14.2857%;"><span style="color: #ff0000;">~d</span></td>
								</tr>
								'
		

			SET  @ROWHTML = @ROWHTMLTML1 

			SET @tableHTML = '<table style="width: 100%; border-collapse: collapse; background-color: #1c6ea4;" border="1">
								<h><b>
								Please download your 834 files
							  </h3></b>
								<tbody>
								<tr>
								<td style="width: 100%; text-align: center;">
								<h3><span style="color: #ffffff;">834 Lag Report as of ~m</span></h3></td>
								</tr>
								</tbody>
								</table>
								<table style="border-collapse: collapse; width: 100%;" border="1">
								<tbody>
								<tr style="background-color: #1c6ea4;">
								<td style="width: 14.2857%;"><span style="color: #ffffff;">Log Time</span></td>
								<td style="width: 14.2857%;"><span style="color: #ffffff;">Submitter Name</span></td>
								<td style="width: 14.2857%;"><span style="color: #ffffff;">Submitter ID</span></td>
								<td style="width: 14.2857%;"><span style="color: #ffffff;">Folder</span></td>
								<td style="width: 14.2857%;"><span style="color: #ffffff;">File Name</span></td>
								<td style="width: 14.2857%;"><span style="color: #ffffff;">Days</span></td>
								</tr>
								~r
								</tbody>
								</table>'
		
			 --------------------------------------------------------------------------------
			 --Create the grid data and surrond it with HTML
			 -------------------------------------------------------------------------------
			 SELECT  @ROWS = COUNT(*)
			FROM #tmpWork WITH (NOLOCK)

			 IF @ROWS > 0
			   BEGIN

				 WHILE @Start <= @ROWS
				   BEGIN
							SET @ROWHTML = @ROWHTMLTML1

							SELECT @ROWSHTML = @ROWSHTML +  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@ROWHTML,'~l',CONVERT(VARCHAR(50),LogTime,120)),'~s',SubmitterName),'~i',SubmitterID),'~f',Folder),'~n',[FileName]),'~d',DaysApartNWH)
							FROM #tmpWork w
							WHERE IDS = @Start 
					
							SET @Start = @Start + 1
				   END
			
				SET @tableHTML = REPLACE(@tableHTML,'~R',@ROWSHTML)
				SET @tableHTML = REPLACE(@tableHTML,'~M',CONVERT(VARCHAR(20),@Today,100))
				
				SET @Start = 1
				--------------------------------------------------------------------------------
				-- email our email wth the embeded email
				-------------------------------------------------------------------------------
				EXEC msdb.dbo.sp_send_dbmail
					@profile_name = 'DBMail Profile'
					,@recipients= @TO  
					,@copy_recipients = @CC
					,@subject = @Subject  
					,@body = @tableHTML  
					,@body_format = 'HTML' ;  
				--select @tableHTML
				SELECT @tableHTML = '', @ROWSHTML = ''
			  END
		 END
		  
		DROP TABLE IF EXISTS #FilesUploaded;
		DROP TABLE IF EXISTS #FilesDownloaded;
		DROP TABLE IF EXISTS #tmpWork;

	END TRY

    BEGIN CATCH																				   
 
         SELECT  @ErrorMessage		= ERROR_MESSAGE()
				,@ErrorSeverity		= ERROR_SEVERITY()
				,@ErrorProcedure	= ERROR_PROCEDURE()
				,@ErrorState		= ERROR_STATE()
				,@ErrorLineNumber	= ERROR_LINE()

		SET @ErrorMessage = 'Procedure: ' + @ErrorProcedure + ' ' + @ErrorMessage + ' At LineNumber: ' + CONVERT(VARCHAR(20),@ErrorMessage)

        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
 
    END CATCH
END