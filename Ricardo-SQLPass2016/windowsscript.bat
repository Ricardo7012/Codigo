@echo off

echo RUNNING 1...
SQLCMD -S D7HBLUE01A667\maps -i "D:\DC14995\My Documents\My Projects\SQL\changePWD.sql" -b -o "D:\DC14995\My Documents\My Projects\SQL\1.log"
if not errorlevel 1 goto next2
echo == An error occurred 

:next2

echo RUNNING 2...
SQLCMD -S D7HBLUE01A667\sqlexpress -i "D:\DC14995\My Documents\My Projects\SQL\changePWD.sql" -b -o "D:\DC14995\My Documents\My Projects\SQL\2.log"
if not errorlevel 1 goto next3
echo == An error occurred 

:next3
echo COMPLETE!

for /f %i in (servers.txt) do SQLCMD -S%i -h-1 -s"," -W -i D:\myscript.sql >> D:\output.txt 
