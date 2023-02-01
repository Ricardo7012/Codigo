Function hspRestore{

    Param(
        [string] $TrgServer, 
        [string] $SrcServer, 
        [string] $TrgDB,   
        [string] $SrcDB,
        [string] $DBColor  
    )

Process {

    ######################################################################
    # Parameters
    ######################################################################
    
    If($TrgServer -eq "HSP3S1A" -and $SrcServer -eq "HSP3S1A")
        {
            $Pattern = "\\hsp3m1\hsp\$SrcDB\Documents"
            $Replacement = "\\hsp3m1\hsp\$TrgDB\Documents"
            $SAdGrp = "HSP3"
            $TAdGrp = "HSP3"
            $Disk1 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Disk2 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Primary = "E:\MSSQL\Data\$TrgDB.MDF"
            $Secondary = "E:\MSSQL\Data\$TrgDB.NDF"
            $Log = "L:\MSSQL\Data\"+$TrgDB+"_Log.LDF"
            $Owner = "HSP_dbo"
        }

    ElseIf($TrgServer -eq "HSP3S1A" -and $SrcServer -eq "HSP2S1A")
        {
            $Pattern = "\\hsp2m1\hsp\$SrcDB\Documents"
            $Replacement = "\\hsp3m1\hsp\$TrgDB\Documents"
            $SAdGrp = "HSP2"
            $TAdGrp = "HSP3"
            $Disk1 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Disk2 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Primary = "E:\MSSQL\Data\$TrgDB.MDF"
            $Secondary = "E:\MSSQL\Data\$TrgDB.NDF"
            $Log = "L:\MSSQL\Data\"+$TrgDB+"_Log.LDF"
            $Owner = "HSP_dbo"
        }

    ElseIf($TrgServer -eq "HSP2S1A" -and $SrcServer -eq "HSP1S1A")
        {
            $Pattern = "\\hsp3m1\hsp\$SrcDB\Documents"
            $Replacement = "\\hsp2m1\hsp\$TrgDB\Documents"
            $SAdGrp = "HSP1"
            $TAdGrp = "HSP2"
            $Disk1 = "E:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Disk2 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Primary = "E:\MSSQL\Data\$TrgDB.MDF"
            $Secondary = "E:\MSSQL\Data\$TrgDB.NDF"
            $Log = "L:\MSSQL\Data\"+$TrgDB+"_Log.LDF"
            $Owner = "HSP_dbo"
        }
    
    ElseIf($TrgServer -eq "HSP2S1A" -and $SrcServer -eq "HSP3S1A")
        {
            $Pattern = "\\hsp3m1\hsp\$SrcDB\Documents"
            $Replacement = "\\hsp2m1\hsp\$TrgDB\Documents" 
            $SAdGrp = "HSP3"
            $TAdGrp = "HSP2"
            $Disk1 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Disk2 = "F:\MSSQL\Adhoc\${TrgDB}_adhoc.bak"
            $Primary = "E:\MSSQL\Data\$TrgDB.MDF"
            $Secondary = "E:\MSSQL\Data\$TrgDB.NDF"
            $Log = "L:\MSSQL\Data\"+$TrgDB+"_Log.LDF"
            $Owner = "HSP_dbo"
        }
        
     ElseIf($TrgServer -eq "HSP3S1A" -and $SrcServer -eq "HSP1S1A" -and $TrgDB -ne "HSP_CT")
        {
            $Pattern = "\\hsp3m1\hsp\$SrcDB\Documents"
            $Replacement = "\\hsp3m1\hsp\$TrgDB\Documents" 
            $SAdGrp = "HSP1"
            $TAdGrp = "HSP3"
            $Disk1 = "E:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Disk2 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Primary = "E:\MSSQL\Data\$TrgDB.MDF"
            $Secondary = "E:\MSSQL\Data\$TrgDB.NDF"
            $Log = "L:\MSSQL\Data\"+$TrgDB+"_Log.LDF"
            $Owner = "HSP_dbo"
        }

     ElseIf($TrgServer -eq "HSP3S1A" -and $SrcServer -eq "HSP1S1A" -and $TrgDB -eq "HSP_CT")
        {
            $Pattern = "\\hsp3m1\hsp\$SrcDB\Documents"
            $Replacement = "\\hsp3m1\hsp\$TrgDB\Documents" 
            $SAdGrp = "HSP1"
            $TAdGrp = "HSP3"
            $Disk1 = "E:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Disk2 = "F:\MSSQL\Adhoc\${SrcDB}_adhoc.bak"
            $Primary = "G:\MSSQL\Data\$TrgDB.MDF"
            $Secondary = "G:\MSSQL\Data\$TrgDB.NDF"
            $Log = "J:\MSSQL\Data\"+$TrgDB+"_Log.LDF"
            $Owner = "HSP_dbo"
        }


           
    $QueryTimeout = 0
    $ErrorLog = "\\iehpshare\CSR\Error Log\hspRestoreLog.txt" 

######################################################################
# Adhoc Backup of Source DB
######################################################################
                Try{
                        $conn = new-object System.Data.SqlClient.SQLConnection
                        $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $SrcServer,"Master",$ConnectionTimeout
                        $conn.ConnectionString=$ConnectionString

                        $Qry0 = "BACKUP DATABASE [$SrcDB]
	                            TO DISK = '$Disk1' 
	                            WITH	SKIP,  
			                            COMPRESSION,  
			                            STATS = 10, 
			                            CHECKSUM;"

                        $cmd = New-Object system.Data.SqlClient.SqlCommand($Qry0,$conn) 
                        $cmd.CommandTimeout=$QueryTimeout

                        $cmd.Connection.Open()
                        $cmd.ExecuteNonQuery()

                        $cmd.Connection.Close()
                    }

                Catch{
                        "Oh Snap! The backup process failed. $(get-date -f yyyy-MM-dd)" | Add-Content $ErrorLog
                        Return
                    }


######################################################################
# Zip and Move Backup
######################################################################

                        If ($TrgServer -ne $SrcServer) {

                                If (-not (Test-Path "$env:ProgramFiles\7-Zip\7z.exe")) {Throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
                                Set-Alias zip "$env:ProgramFiles\7-Zip\7z.exe"  

                                $inFile = "\\$SrcServer\Adhoc\${SrcDB}_adhoc.bak"
                                $outFile = "\\$SrcServer\Adhoc\${SrcDB}_adhoc.zip"
                                $zipFile = "\\$TrgServer\Adhoc\${SrcDB}_adhoc.zip"
                                $zipOut = "\\$TrgServer\Adhoc\"
        
                                zip a -tzip $outFile $inFile

                                If (Test-Path -Path "$inFile"){
                                
                                    Remove-Item -Path $inFile
                                    }

                                If (Test-Path -Path "$outFile"){
                            
                                    Move-Item -Path $outFile -Destination $zipOut
                                    }

                                zip e -tzip $zipFile -o"$zipOut" -y

                                If (Test-Path -Path "$zipFile"){

                                    Remove-Item -Path $zipFile
                                    }

                        }


######################################################################
# Restore DB
######################################################################

                Try{
                        $conn = new-object System.Data.SqlClient.SQLConnection
                        $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $TrgServer,"Master",$ConnectionTimeout
                        $conn.ConnectionString=$ConnectionString

                        $Qry1 = "DECLARE @kill VARCHAR(MAX) = '';
                                  SELECT  @kill = @kill + 'BEGIN TRY KILL ' + CONVERT(VARCHAR(5), spid) + ';'
                                  + ' END TRY BEGIN CATCH END CATCH ;'
                                  FROM    master..sysprocesses
                                  WHERE   dbid = DB_ID('$TrgDB');
                                  EXEC (@kill);
                    
                                  RESTORE DATABASE  [$TrgDB] 
	                              FROM DISK = '$Disk2'
	                              WITH 
		                              MOVE 'HSP' TO N'$Primary',
		                              MOVE 'SECONDARY' TO N'$Secondary',
		                              MOVE 'HSP_log' TO N'$Log',
		                              REPLACE,
		                              RECOVERY;"

                        $Qry2 = "ALTER DATABASE ${TrgDB} SET RECOVERY SIMPLE;"

                        $cmd = New-Object system.Data.SqlClient.SqlCommand($Qry1,$conn) 
                        $cmd.CommandTimeout=$QueryTimeout

                        $cmd.Connection.Open()
                        $cmd.ExecuteNonQuery()

                        $cmd.CommandText = $Qry2
                        $cmd.ExecuteNonQuery()

                        $cmd.Connection.Close()

                        }

                Catch{
                        
                        "Oh Snap! The restore process failed. $(get-date -f yyyy-MM-dd)" | Add-Content $ErrorLog
                        Return

                      }


######################################################################
# Update File Paths
######################################################################

            Try{
                        $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $TrgServer, $TrgDB, $ConnectionTimeout
                        $conn.ConnectionString=$ConnectionString

                        $Qry3 = "DBCC shrinkfile (HSP_log, 2048)"


                        $Qry4 = " 
                        IF EXISTS (SELECT 1 FROM SystemOptions)
                        BEGIN 
                        UPDATE  SystemOptions
                        SET     ItemValue ='${Server}'
                        WHERE   ItemType = 'HSPLicensingSERVER'
                        END;

                        IF EXISTS (SELECT 1 FROM FeatureLinks)
                        BEGIN 
                        UPDATE  FeatureLinks
                        SET     LinkURL = REPLACE(LinkURL, '${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM SystemOptions)
                        BEGIN 
                        UPDATE  SystemOptions
                        SET     ItemValue = REPLACE(ItemValue, '${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM Documents)
                        BEGIN 
                        UPDATE  Documents
                        SET     Location = REPLACE(Location, '${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM ReferenceCodes)
                        BEGIN 
                        UPDATE  ReferenceCodes
                        SET     Description = REPLACE(Description,'${Pattern}','${Replacement}')
                        WHERE   Type = 'PermissionedDirectory'
                        END;

                        IF EXISTS (SELECT 1 FROM UserReports)
                        BEGIN 
                        UPDATE  UserReports
                        SET     ReportPath = REPLACE(ReportPath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM OutputBatches)
                        BEGIN 
                        UPDATE  OutputBatches
                        SET     FileLocation = REPLACE(FileLocation,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM EDIXacts)
                        BEGIN 
                        UPDATE  EDIXacts
                        SET     SourceDataLocation = REPLACE(SourceDataLocation,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM InputBatches)
                        BEGIN 
                        UPDATE  InputBatches
                        SET     DoneDirectory = REPLACE(DoneDirectory,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM ImportLocations)
                        BEGIN 
                        UPDATE  ImportLocations
                        SET     LocationPath = REPLACE(LocationPath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM BasePlans)
                        BEGIN 
                        UPDATE  BasePlans
                        SET     SOBReportPath = REPLACE(SOBReportPath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM LetterTemplates)
                        BEGIN 
                        UPDATE  LetterTemplates
                        SET     TemplatePath = REPLACE(TemplatePath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM Questionnaires)
                        BEGIN 
                        UPDATE  Questionnaires
                        SET     ReportPath = REPLACE(ReportPath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM InterchangeInfo)
                        BEGIN 
                        UPDATE  InterchangeInfo
                        SET     PathForInput = REPLACE(PathForInput,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM InterchangeInfo)
                        BEGIN 
                        UPDATE  InterchangeInfo
                        SET     PathForOutput = REPLACE(PathForOutput,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM ImportLocations)
                        BEGIN
                        UPDATE  ImportLocations
                        SET     ArchivePath = REPLACE(ArchivePath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM ImportLocations)
                        BEGIN
                        UPDATE  ImportLocations
                        SET     FTPPath = REPLACE(FTPPath, '${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM EDIFIles)
                        BEGIN
                        UPDATE  EDIFIles
                        SET     DayPath = REPLACE(DayPath, '${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM EDIFIles)
                        BEGIN
                        UPDATE  EDIFiles
                        SET     DonePath = REPLACE(DonePath, '${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM EDIFIles)
                        BEGIN
                        UPDATE  EDIFiles
                        SET     InputPath = REPLACE(InputPath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM EDIFIles)
                        BEGIN
                        UPDATE  EDIFIles
                        SET     OutputPath = REPLACE(OutputPath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM BasePlansHistory)
                        BEGIN
                        UPDATE  BasePlansHistory
                        SET     SOBReportPath = REPLACE(SOBReportPath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM BatchLoadHistory)
                        BEGIN
                        UPDATE  BatchLoadHistory
                        SET     ErrorLogFilePath = REPLACE(ErrorLogFilePath,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM BatchLoadHistory)
                        BEGIN
                        UPDATE  BatchLoadHistory
                        SET     FilePath = REPLACE(FilePath, '${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM ContactSteps)
                        BEGIN
                        UPDATE  ContactSteps
                        SET     CrystalTemplate = REPLACE(CrystalTemplate,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM BillPackages)
                        BEGIN
                        UPDATE  BillPackages
                        SET     CrystalTemplate = REPLACE(CrystalTemplate,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM LettersOfAgreement)
                        BEGIN
                        UPDATE  LettersOfAgreement
                        SET     CrystalTemplate = REPLACE(CrystalTemplate,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM ExtractedDataMaster)
                        BEGIN
                        UPDATE  ExtractedDataMaster
                        SET     CrystalTemplate = REPLACE(CrystalTemplate,'${Pattern}','${Replacement}')
                        END;

                        IF EXISTS (SELECT 1 FROM ScannedImages)
                        BEGIN
                        UPDATE  ScannedImages	
                        SET     ImagePath = replace(ImagePath, '${Pattern}','${Replacement}')
                        END;"

                        $Qry5 = "sp_changedbowner $Owner"

                        $cmd = New-Object system.Data.SqlClient.SqlCommand($Qry3,$conn) 
                        $cmd.CommandTimeout=$QueryTimeout

                        $cmd.Connection.Open()
                        $cmd.ExecuteNonQuery()

                        $cmd.CommandText = $Qry4
                        $cmd.ExecuteNonQuery()

                        $cmd.CommandText = $Qry5
                        $cmd.ExecuteNonQuery()

                        $cmd.Connection.Close()

                        }

                Catch{
                        
                        "Oh Snap! The update file paths process failed. $(get-date -f yyyy-MM-dd)" | Add-Content $ErrorLog
                        Return

                      }

######################################################################
# Reset Licensing
######################################################################

                Try{
                        $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $TrgServer, "HSPLicensing", $ConnectionTimeout
                        $conn.ConnectionString=$ConnectionString

                        $Qry6 = "DELETE FROM HSPLicensing.dbo.Seats WHERE databasename = '${TrgDB}'"

                        $cmd = New-Object system.Data.SqlClient.SqlCommand($Qry6,$conn) 
                        $cmd.CommandTimeout=$QueryTimeout

                        $cmd.Connection.Open()
                        $cmd.ExecuteNonQuery()
                        $cmd.Connection.Close()

                                        }

                Catch{
                        
                        "Oh Snap! The reset licensing process failed. $(get-date -f yyyy-MM-dd)" | Add-Content $ErrorLog
                        Return

                      }

######################################################################
# For Arch Dev Weenies
######################################################################
                
                If($TrgDB -eq "HSP_IT_SB2"){

                        Try{

                            $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $TrgServer, $TrgDB, $ConnectionTimeout
                            $conn.ConnectionString=$ConnectionString
                
                            $Qry7 = "UPDATE SystemOptions 
                                    SET ItemValue = 'ON'
                                    WHERE ItemType = 'ApplicationKeys'"

                            $cmd = New-Object system.Data.SqlClient.SqlCommand($Qry7,$conn) 
                            $cmd.CommandTimeout=$QueryTimeout

                            $cmd.Connection.Open()
                            $cmd.ExecuteNonQuery()
                            $cmd.Connection.Close()
                            }

                       Catch{
                        
                        "Oh Snap! The application key process failed. $(get-date -f yyyy-MM-dd)" | Add-Content $ErrorLog
                        Return

                      }
                
                }

######################################################################
# Update SQL Permissions
######################################################################

                Try{
                        $ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $TrgServer, $TrgDB, $ConnectionTimeout
                        $conn.ConnectionString=$ConnectionString

                        If ($TrgServer -ne $SrcServer) {
                                $Qry8 = "IF EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${SAdGrp}Admins')
                                        BEGIN 
                                        DROP USER [IEHP\${SAdGrp}Admins]
                                        END;
                                  
                                        IF EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${SAdGrp}BackupOperator')
                                        BEGIN 
                                        DROP USER [IEHP\${SAdGrp}BackupOperator]
                                        END;
                                   
                                        IF EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${SAdGrp}DataReader')
                                        BEGIN 
                                        DROP USER [IEHP\${SAdGrp}DataReader]
                                        END;
                                     
                                        IF EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${SAdGrp}DataWriter') 
                                        BEGIN
                                        DROP USER [IEHP\${SAdGrp}DataWriter]
                                        END;
                                      
                                        IF EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${SAdGrp}DBOwner')
                                        BEGIN 
                                        DROP USER [IEHP\${SAdGrp}DBOwner]
                                        END;
                                       
                                        IF EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${SAdGrp}DDLAdmins')
                                        BEGIN 
                                        DROP USER [IEHP\${SAdGrp}DDLAdmins]
                                        END;
                                       
                                        IF NOT EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${TAdGrp}Admins')
                                        BEGIN
                                        CREATE USER [IEHP\${TAdGrp}Admins] FOR LOGIN [IEHP\${TAdGrp}Admins]
                                        ALTER SERVER ROLE [sysadmin] ADD MEMBER [IEHP\${TAdGrp}Admins]
                                        END;
                                        
                                        IF NOT EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${TAdGrp}BackupOperator')
                                        BEGIN
                                        CREATE USER [IEHP\${TAdGrp}BackupOperator] FOR LOGIN [IEHP\${TAdGrp}BackupOperator]
                                        ALTER ROLE [db_backupoperator] ADD MEMBER [IEHP\${TAdGrp}BackupOperator]
                                        END;
                                        
                                        IF NOT EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${TAdGrp}DataReader')
                                        BEGIN
                                        CREATE USER [IEHP\${TAdGrp}DataReader] FOR LOGIN [IEHP\${TAdGrp}DataReader]
                                        ALTER ROLE [db_datareader] ADD MEMBER [IEHP\${TAdGrp}DataReader]
                                        END;

                                        IF NOT EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${TAdGrp}DataWriter')
                                        BEGIN
                                        CREATE USER [IEHP\${TAdGrp}DataWriter] FOR LOGIN [IEHP\${TAdGrp}DataWriter]
                                        ALTER ROLE [db_dataWriter] ADD MEMBER [IEHP\${TAdGrp}DataWriter]
                                        END;
                                        
                                        IF NOT EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${TAdGrp}DBOwner')
                                        BEGIN
                                        CREATE USER [IEHP\${TAdGrp}DBOwner] FOR LOGIN [IEHP\${TAdGrp}DBOwner]
                                        ALTER ROLE [db_Owner] ADD MEMBER [IEHP\${TAdGrp}DBOwner]
                                        END;
                                        
                                        IF NOT EXISTS (select * from sys.database_principals WHERE NAME = 'IEHP\${TAdGrp}DDLAdmins')
                                        BEGIN
                                        CREATE USER [IEHP\${TAdGrp}DDLAdmins] FOR LOGIN [IEHP\${TAdGrp}DDLAdmins]
                                        ALTER ROLE [db_ddladmin] ADD MEMBER [IEHP\${TAdGrp}DDLAdmins]
                                        END;"
                                                                             
                                        $cmd = New-Object system.Data.SqlClient.SqlCommand($Qry8,$conn) 
                                        $cmd.CommandTimeout=$QueryTimeout

                                        $cmd.Connection.Open()
                                        $cmd.ExecuteNonQuery()

                                        $cmd.Connection.Close()
                                }

                         
                        }

                Catch{
                        
                        "Oh Snap! The update SQL permissions process failed. $(get-date -f yyyy-MM-dd)" | Add-Content $ErrorLog
                        Return

                      }

######################################################################
# Clean Up Files
######################################################################
                
                If (Test-Path -Path "\\$TrgServer\Adhoc\${SrcDB}_adhoc.bak"){

                    Remove-Item -Path \\$TrgServer\Adhoc\${SrcDB}_adhoc.bak
                }

######################################################################
# Move Files on Image Server
######################################################################
       
        robocopy $Pattern $Replacement /e /xo

        }
}
