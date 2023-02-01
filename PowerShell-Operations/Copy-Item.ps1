Get-ExecutionPolicy
Set-ExecutionPolicy Unrestricted -Force

Write-Host -ForegroundColor Green "###################################################"
"{0:N2} MB PROD" -f ((Get-ChildItem \\PVFILSRV01\pvfilsrv\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)

Write-Host -ForegroundColor Green "###################################################"
Remove-Item E:\dvfilsrv\DEV -Recurse -Force
Remove-Item E:\dvfilsrv\MO -Recurse -Force
Remove-Item E:\dvfilsrv\QA -Recurse -Force

Write-Host -ForegroundColor Green "###################################################"
New-Item -ItemType Directory -Force -Path E:\dvfilsrv\DEV
New-Item -ItemType Directory -Force -Path E:\dvfilsrv\MO
New-Item -ItemType Directory -Force -Path E:\dvfilsrv\QA

Write-Host -ForegroundColor Green "###################################################"
Copy-Item -Path \\PVFILSRV01\pvfilsrv\* -Destination E:\dvfilsrv\DEV\ -Recurse 
Copy-Item -Path \\PVFILSRV01\pvfilsrv\* -Destination E:\dvfilsrv\MO\ -Recurse 
Copy-Item -Path \\PVFILSRV01\pvfilsrv\* -Destination E:\dvfilsrv\QA\ -Recurse 

Write-Host -ForegroundColor Green "###################################################"
"{0:N2} MB" -f ((Get-ChildItem E:\dvfilsrv\DEV\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
"{0:N2} MB" -f ((Get-ChildItem E:\dvfilsrv\MO\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
"{0:N2} MB" -f ((Get-ChildItem E:\dvfilsrv\QA\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
"{0:N2} MB TOTAL" -f ((Get-ChildItem E:\dvfilsrv\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
