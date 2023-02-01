#METHOD #1
New-Item -Path C:\test1 -Type directory

#METHOD #2
[system.io.directory]::CreateDirectory("C:\test2")


#METHOD #3
$fso = new-object -ComObject scripting.filesystemobject
$fso.CreateFolder("C:\test3")

#METHOD #4
md c:\test4
