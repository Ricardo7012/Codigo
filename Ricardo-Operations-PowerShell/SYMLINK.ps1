#cls
#fsutil reparsepoint query "C:\Program Files" | find "Symbolic Link" >nul || echo "symbolic link found" || echo "No symbolic link"

cls
cd \
cd 'C:\Program Files\Microsoft SQL Server\130'
dir | select Name, LinkType, Target, LinkStatus, LinkTarget, Fullname


#dir 'C:\Program Files\' /al /s | findstr "<SYMLINKD>"

cls
cd \
cd "C:\Program Files\Microsoft SQL Server\100\" 

dir 'C:\Program Files\Microsoft SQL Server' -recurse -force | ?{$_.LinkType} | select FullName, LinkType, Target

dir 'c:\Temp' -recurse -force | ?{$_.LinkType} | select FullName,LinkType,Target

dir 

$Path="C:\Program Files\Microsoft SQL Server\100\"

#param([string]$Path)
if (-not (Test-Path $Path -PathType 'Container'))
{
  throw "$($Path) is not a valid folder"
}
$Current=Get-Item .
function Test-ReparsePoint($File) {
  if ([bool]($File.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
    $File
  } else {
    $FALSE
  }
  return
}
cd $Path
# Recurse through all files and folders, suppressing error messages.
# Return any file/folder that is actually a symbolic link.
ls -Force -Recurse -ErrorAction SilentlyContinue | ? { Test-ReparsePoint($_) }
cd $Current

