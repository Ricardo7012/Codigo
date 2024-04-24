Clear-Host

##ping -l 1472 -f dvsqlpol01

Write-Host -ForegroundColor green "*************************************************************************************************************************"
#Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet"
Write-Host -ForegroundColor green "*************************************************************************************************************************"

Invoke-Command -ComputerName `
    EDWETL01, `
    EDWSQL02, `
    HSP1S1A, `
    HSP1S1B, `
    HSP1S1C, `
    IEHPFINTS, `
    IEHPMDS, `
    JIVESQL, `
    JOBSCHEDSQL, `
    MARS, `
    PVDMEM01, `
    PVMOVEITSQL01, `
    PVSQLCDR01, `
    PVSQLEDI01, `
    PVSQLEDI02, `
    PVSQLEDI03, `
    PVSQLEDI04, `
    PVSQLEM01, `
    PVSQLEOM01, `
    PVSQLFIN01, `
    PVSQLFIN02, `
    PVSQLHAR01, `
    PVSQLHED01, `
    PVSQLIDR01, `
    PVSQLMLS01, `
    PVSQLNUANCE01, `
    PVSQLNUANCE02, `
    PVSQLODS01, `
    PVSQLPHA01, `
    PVSQLPOL01, `
    PVSQLSAS01, `
    PVSQLSIS01, `
    PVSQLSIS02, `
    PVSQLSRS01, `
    PVSQLSTRAD, `
    PVSQLSW01, `
    PVSQLSYMED01, `
    PVSQLTFS01, `
    PVVERSQL01, `
    RSDCPBRS, `
    SPDB1, `
    SWSQL, `
    TITAN, `
    VEGA01, `
    VENUS, `
    WEBSTRATPPS `
{Get-NetAdapterAdvancedProperty  -DisplayName "Jumbo Packet"}  | `
Sort-Object DisplayValue | Format-Table -Property PSComputerName, Name, DisplayName, DisplayValue, RegistryKeyword, RegistryValue 

### ping -l 8000 -f 10.0.0.1
### -l 8000 tells ping to send an 8000 byte payload.
### -f tells ping to set the don’t fragment bit (DF).
#PS C:\> ping /?
#
#
#Usage: ping [-t] [-a] [-n count] [-l size] [-f] [-i TTL] [-v TOS]
#            [-r count] [-s count] [[-j host-list] | [-k host-list]]
#            [-w timeout] [-R] [-S srcaddr] [-c compartment] [-p]
#            [-4] [-6] target_name
#
#Options:
#    -t             Ping the specified host until stopped.
#                   To see statistics and continue - type Control-Break;
#                   To stop - type Control-C.
#    -a             Resolve addresses to hostnames.
#    -n count       Number of echo requests to send.
#    -l size        Send buffer size.
#    -f             Set Don't Fragment flag in packet (IPv4-only).
#    -i TTL         Time To Live.
#    -v TOS         Type Of Service (IPv4-only. This setting has been deprecated
#                   and has no effect on the type of service field in the IP
#                   Header).
#    -r count       Record route for count hops (IPv4-only).
#    -s count       Timestamp for count hops (IPv4-only).
#    -j host-list   Loose source route along host-list (IPv4-only).
#    -k host-list   Strict source route along host-list (IPv4-only).
#    -w timeout     Timeout in milliseconds to wait for each reply.
#    -R             Use routing header to test reverse route also (IPv6-only).
#                   Per RFC 5095 the use of this routing header has been
#                   deprecated. Some systems may drop echo requests if
#                   this header is used.
#    -S srcaddr     Source address to use.
#    -c compartment Routing compartment identifier.
#    -p             Ping a Hyper-V Network Virtualization provider address.
#    -4             Force using IPv4.
#    -6             Force using IPv6.
#
