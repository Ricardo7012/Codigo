cd \
clear-host
hostname
Get-Date

#chkdsk G: /f /r /x
# https://www.easeus.com/computer-instruction/use-chkdsk-to-fix-the-corruption-problem-windows-10.html#:~:text=Step%201.%20Press%20the%20%22Windows%22%20key%20and%20type,%2Ff%20is%20running%20to%20fix%20any%20found%20errors%3B

# "e" means the drive letter of the partition you want to repair;
# chkdsk /f is running to fix any found errors;
# chkdsk /r is running to locate for bad sectors and recover any readable information;
# chkdsk /x is running to force the volume you're about to check to be dismounted before the utility begins a scan.
sfc /scannow
Get-Date