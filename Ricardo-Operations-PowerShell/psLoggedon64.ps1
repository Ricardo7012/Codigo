CLS
cd \
whoami
C:\Users\i4682\Documents\Ricardo\PsLoggedon64.exe \\hsp3s1a

Write-Host -ForegroundColor Green "*****************************"


Import-Csv 'C:\Users\i4682\Documents\Ricardo\servers.csv' | % {
    $computer = $_.computers
    . 'C:\Users\i4682\Documents\Ricardo\PsLoggedon64.exe' \\$Computer '
    }
    {
            New-Object psobject -prop @{
                Computer = $computer
                Time = $Matches.time.Trim()
                User = $Matches.user.Trim()
            }
            Write-Host $computer
            write-host $Matches
        } | ? user -notmatch '^Connecting$|^Users$|^NT$'
} | epcsv 'C:\Users\i4682\Documents\Ricardo\LoggedON.csv' -not


Write-Host -ForegroundColor Green "*****************************"
