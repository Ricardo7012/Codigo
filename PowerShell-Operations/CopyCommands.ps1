cls
cd \
Get-Date

#New-Item -Path F:\Movies -ItemType Directory
#New-Item -Path F:\Music -ItemType Directory
#New-Item -Path F:\MyDocuments -ItemType Directory
#New-Item -Path F:\PCRecovery -ItemType Directory
#New-Item -Path F:\Pictures -ItemType Directory
#New-Item -Path F:\Video -ItemType Directory


#Copy-Item "E:\Movies\*.avi" "F:\Movies" -Force -Recurse -Verbose
#Copy-Item G:\Music F:\Music -Force -Recurse -Verbose
#Copy-Item G:\MyDocuments F:\MyDocuments -Force -Recurse -Verbose
#Copy-Item G:\PCRecovery F:\PCRecovery -Force -Recurse -Verbose
#Copy-Item G:\Pictures F:\Pictures -Force -Recurse -Verbose
#Copy-Item G:\Video F:\Video -Force -Recurse -Verbose

Get-Date

cls
cd E:\Movies

Get-Date
Get-ChildItem *.mpg -recurse | Copy-Item -destination F:\Movies -Verbose -Force #-WhatIf

Get-Date
Get-ChildItem *.mp4 -recurse | Copy-Item -destination F:\Movies -Verbose -Force #-WhatIf

Get-Date
Get-ChildItem *.mkv -recurse | Copy-Item -destination F:\Movies -Verbose -Force #-WhatIf

Get-Date
Get-ChildItem *.avi -recurse | Copy-Item -destination F:\Movies -Verbose -Force #-WhatIf

cls
Get-Date
Robocopy "E:\Movies" "F:\Movies" /E /COPYALL /XO /R:2 /W:5 /V /TS /BYTES /ETA
