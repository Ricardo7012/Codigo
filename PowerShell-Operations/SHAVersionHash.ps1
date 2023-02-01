cls 
cd \
Get-Date

#SOURCE
Write-Host -ForegroundColor Green "*****************************************************************************"
Write-Host -ForegroundColor Green "SOURCE"
Write-Host -ForegroundColor Green "*****************************************************************************"
Get-ChildItem -Path "E:\Movies\Movies(Favorites)\Star Trek Series\Star Trek V, The Final Frontier (1989)\Star Trek V, The Final Frontier (1989).mpg" | 
ForEach{
    [PSCustomObject] @{
        FileName      = $PSItem.FullName
        LastWriteTIme = $PSItem.LastWriteTime
        ShaVersion    = (Get-FileHash -Path $PSItem.FullName).Algorithm 
        Hash          = (Get-FileHash -Path $PSItem.FullName).Hash 
    }
}
# Results

#DESTINATION
Write-Host -ForegroundColor Green "*****************************************************************************"
Write-Host -ForegroundColor Green "DESTINATION"
Write-Host -ForegroundColor Green "*****************************************************************************"
Get-ChildItem -Path "F:\Movies\Star Trek V, The Final Frontier (1989).mpg" | 
ForEach{
    [PSCustomObject] @{
        FileName      = $PSItem.FullName
        LastWriteTIme = $PSItem.LastWriteTime
        ShaVersion    = (Get-FileHash -Path $PSItem.FullName).Algorithm 
        Hash          = (Get-FileHash -Path $PSItem.FullName).Hash 
    }
}
# Results

#https://www.ccleaner.com/recuva
#https://dmde.com/
#https://recoverit.wondershare.com/data-recovery.html
# https://www.maketecheasier.com/corrupted-windows-files/
#https://www.videolan.org/vlc/download-windows.en-GB.html
#http://grauonline.de/cms2/?page_id=5#download
#

Get-WindowsUpdateLog DISM.exe /Online /Cleanup-image /Restorehealthsfc /scannow