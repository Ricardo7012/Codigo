cls
gwmi win32_service | where {$_.DisplayName -match “SQL”} | select name, startname


## <--- Configure here
$accountToAdd = "IEHP\PREDSVC01"
## ---> End of Config
$sidstr = $null


try {
       $ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
       $sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
       $sidstr = $sid.Value.ToString()
} catch {
       $sidstr = $null
}
Write-Host "Account: $($accountToAdd)" -ForegroundColor Green
if( [string]::IsNullOrEmpty($sidstr) ) {
       Write-Host "Account not found!" -ForegroundColor Red
       #exit -1
}

Write-Host "Account SID: $($sidstr)" -ForegroundColor Green
$tmp = ""
$tmp = [System.IO.Path]::GetTempFileName()
Write-Host "Export current Local Security Policy" -ForegroundColor Green
secedit.exe /export /cfg "$($tmp)" 
$c = ""
$c = Get-Content -Path $tmp
$currentSetting = ""
foreach($s in $c) {
       if( $s -like "SeServiceLogonRight*") {
             $x = $s.split("=",[System.StringSplitOptions]::RemoveEmptyEntries)
             $currentSetting = $x[1].Trim()
       }
}


if( $currentSetting -notlike "*$($sidstr)*" ) {
       Write-Host "Logon as a service""" -ForegroundColor Green
       
       if( [string]::IsNullOrEmpty($currentSetting) ) {
             $currentSetting = "*$($sidstr)"
       } else {
             $currentSetting = "*$($sidstr),$($currentSetting)"
       }
       
       Write-Host "$currentSetting"
       
       $outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeServiceLogonRight = $($currentSetting)
"@
       
       $tmp2 = ""
       $tmp2 = [System.IO.Path]::GetTempFileName()
       
       
       Write-Host "Import new settings to Local Security Policy" -ForegroundColor Green
       $outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force
       #notepad.exe $tmp2
       Push-Location (Split-Path $tmp2)
       
       try {
             secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS 
             write-host "secedit.exe /configure /db ""secedit.sdb"" /cfg ""$($tmp2)"" /areas USER_RIGHTS "
       } finally {  
             Pop-Location
       }
} else {
       Write-Host "NO ACTIONS REQUIRED! Account already in ""Logon as a service""" -ForegroundColor Green
}
Write-Host "Done." -ForegroundColor Green 

# REBOOT COMPUTER