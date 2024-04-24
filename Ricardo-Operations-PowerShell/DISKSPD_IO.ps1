    CLS

    Write-Host -ForegroundColor Green "###################################################"
 hostname
    Write-Host -ForegroundColor Green "###################################################"

    fsutil fsinfo ntfsinfo C:\
    Write-Host -ForegroundColor Green "###################################################"


    #65336
CLS
cd \

## https://www.altaro.com/hyper-v/storage-performance-baseline-diskspd/
## -c150G – Create a file of the specified size. Size can be stated in bytes or KiBs, MiBs, GiBs. Here – 150GB.
## -d300 – Duration of measurement period in seconds, not including cool-down or warm-up time (default = 10 seconds). Here – 5 minutes.
## -r – Random I/O access (override -s).
## -s – Sequential I/O access.
## -w40 – Percentage of write requests to issue (default = 0, 100% read). Here 40% of IO operations are Writes, remaining 60% are Reads. This is a usual load for my SQL Server OLTP databases.
## -t8 – The number of threads per file. Here – 8. One thread per available core.
## -o32 – The number of outstanding I/O requests per target per thread. In other words, it is a queue depth. Here – 32.
## -b46K – Block size in bytes or KiBs, MiBs, or GiBs. Here – 64KB.
## -Sh – Disable both software caching and hardware write caching.
## -L – Measure latency statistics.
## D:\SpeedTest\testfile.dat – My target file used for testing (created with -c).

.\diskspd.exe -c100G -t2 -si4K -b4K -d30 -L -o1 -w100 -D -h C:\temp\testfile.dat > 4K_Sequential_Write_2Threads_1OutstandingIO.txt
.\diskspd.exe -t2 -si64K -b64K -d30 -L -o1 -w100 -D -h C:\temp\testfile.dat > 64KB_Sequential_Write_2Threads_1OutstandingIO.txt
.\diskspd.exe -r -t2 -b8K -d30 -L -o1 -w0 -D -h C:\temp\testfile.dat > 8KB_Random_Read_2Threads_1OutstandingIO.txt
.\diskspd.exe -r -t2 -b128K -d30 -L -o1 -w0 -D -h C:\temp\testfile.dat > 128KB_Random_Read_2Threads_1OutstandingIO.txt
## BRENT
## -b2M – Use a 2 MB I/O size. For this test, we wanted to simulate SQL Server read ahead performance.
## -d60 – Run for 60 seconds. I’m lazy and don’t like to wait.
## -o32 – 32 outstanding I/O requests. This is your queue depth 32.
## -h – This disables both hardware and software buffering. SQL Server does this, so we want to be the same.
## -L – Grab disk latency numbers. You know, just because.
## -t56 – Use 56 threads per file. We only have one file, but we have 56 cores.
## -W – Warm up the workload for 5 seconds.
## -w0 – No writes, just reads. We’re pretending this is a data warehouse.
## D:\temp\test.dat – our sample file. You could create a sample file (or files) by runningdiskspd with the -c<size> flag.
## > output.txt – I used output redirection to send the output to a file instead of my screen.
## 
.\diskspd.exe -b2M -d60 -o32 -h -L -t56 -W -w0 C:\temp\testfile.dat > diskspd_output.txt
