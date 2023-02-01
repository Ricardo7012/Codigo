## https://www.mssqltips.com/sqlservertip/2726/using-a-powershell-script-to-delete-old-files-for-sql-server/

cls
#----enter path---#
$targetpath = "\\dtsqlbkups\qvsqllit01backups\NonProduction\"

#----enter the days---#
$days = 7

#----extension of the file to delete---#
$Extension = "*.trn"
$Now = Get-Date

$LastWrite = $Now.AddDays(-$days)

 try
 {
     #----- get files based on lastwrite filter in the specified folder ---#
    $Files = Get-Childitem $targetpath -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}

    foreach ($File in $Files)
        {
        if ($File -ne $NULL)
            {
            Write-Host "File: " $File.FullName
            Remove-Item $File.FullName -Force | out-null 
            }
        }
 }
catch
 {
    $output = $_.ErrorDetails
    throw $output
 }