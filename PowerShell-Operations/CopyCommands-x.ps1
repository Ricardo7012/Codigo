Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
Get-ExecutionPolicy 

cls
cd \
Get-Date

New-Item -Path F:\Movies -ItemType Directory
New-Item -Path F:\Music -ItemType Directory
New-Item -Path F:\MyDocuments -ItemType Directory
New-Item -Path F:\PCRecovery -ItemType Directory
New-Item -Path F:\Pictures -ItemType Directory
New-Item -Path F:\Video -ItemType Directory


Copy-Item "G:\Movies\Movies(DC-Marvel)\Animation" "F:\Movies\Movies(DC-Marvel)\Animation" -Force -Recurse -Verbose

#Copy-Item G:\Music F:\Music -Force -Recurse -Verbose
#Copy-Item G:\MyDocuments F:\MyDocuments -Force -Recurse -Verbose
#Copy-Item G:\PCRecovery F:\PCRecovery -Force -Recurse -Verbose
#Copy-Item G:\Pictures F:\Pictures -Force -Recurse -Verbose
#Copy-Item G:\Video F:\Video -Force -Recurse -Verbose

Get-Date
