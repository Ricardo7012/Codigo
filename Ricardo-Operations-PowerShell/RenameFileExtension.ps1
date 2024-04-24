
#Navigate to the folder with the files to rename.
Dir 

#This example changes any file extension to ".archive":
Dir | Rename-Item -NewName { [io.path]::ChangeExtension($_.name, "archive") }

Dir
