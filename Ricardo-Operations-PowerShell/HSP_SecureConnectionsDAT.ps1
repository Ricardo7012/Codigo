$Src = "\\iehpshare\CSR\Technical\Upgrade10_6\SecureConnections.dat" 
$DesktopPath = [Environment]::GetFolderPath("Desktop") 

Copy-Item $Src $DesktopPath
$file = $DesktopPath + "\SecureConnections.dat" 

Do { Sleep -seconds 1
   
    } Until (Test-Path $file)

#Move secureconnections.dat file to directories
    Copy-Item -literalPath $file  -destination "C:\Program Files (x86)\HSP\HSP10060" -Force

    If(Test-Path "C:\Program Files\HSP\HSP10060"){
        Copy-Item -literalPath $file  -destination "C:\Program Files\HSP\HSP10060" -Force
    }
       
    Remove-Item $file


#Remove older directories

If(Test-Path "C:\Program Files (x86)\HSP\HSP10052"){
    Remove-Item "C:\Program Files (x86)\HSP\HSP10052" -Recurse -Force
}

If(Test-Path "C:\Program Files (x86)\HSP\HSP10051"){
    Remove-Item "C:\Program Files (x86)\HSP\HSP10051" -Recurse -Force
}

If(Test-Path "C:\Program Files (x86)\HSP\HSP10050"){
    Remove-Item "C:\Program Files (x86)\HSP\HSP10050" -Recurse -Force
}

If(Test-Path "C:\Program Files (x86)\HSP\HSP10043"){
    Remove-Item "C:\Program Files (x86)\HSP\HSP10043" -Recurse -Force
}

If(Test-Path "C:\Windows\SysWOW64\SecureConnections.dat"){
    Remove-Item "C:\Windows\SysWOW64\SecureConnections.dat" -Recurse -Force
}

If(Test-Path "C:\Windows\System32\SecureConnections.dat"){
    Remove-Item "C:\Windows\System32\SecureConnections.dat" -Recurse -Force
}