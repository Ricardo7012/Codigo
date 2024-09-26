cd \
cd C:\Windows\SystemApps> 
taskkill /f /im SearchApp.exe
# move Microsoft.Windows.Search_cw5n1h2txyewy Microsoft.Windows.Search_cw5n1h2txyewy.old

## REVERSE IT 

## Start-Process -FilePath "C:\Windows\SystemApps\SearchApp.exe"

Start-Process -FilePath .\Windows\SystemApps\searchapp.exe

Add-AppxPackage -Path "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -Register
