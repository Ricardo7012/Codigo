Clear-Host

##ping -l 1472 -f dvsqlpol01

Write-Host -ForegroundColor green "*************************************************************************************************************************"
#Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet"
Write-Host -ForegroundColor green "*************************************************************************************************************************"

Invoke-Command -ComputerName `
    DVSQLCDR01, `
    DVSQLCP01, `
    DVSQLDMI01, `
    DVSQLEDI03, `
    DVSQLEDI04, `
    DVSQLEM, `
    DVSQLFIN01, `
    DVSQLNUANCE01, `
    DVSQLPOL01, `
    DVSQLSIS01, `
    DVSQLSRS01, `
    DVSQLSTRAD, `
    DVSQLSYMED01, `
    HSP2S1A, `
    HSP2S1B, `
    HSP2S1C, `
    HSP3S1A, `
    HSP4S1A, `
    HSP5S1A, `
    IEHPDWDEV, `
    JIVESQLDEV, `
    JOBSCHEDAPPDEV, `
    MDSDQSDEV, `
    MOHSP1S1A, `
    MOHSP1S1B, `
    MOHSP1S1C, `
    QVDMEM01, `
    QVEDWSQL01, `
    QVMEDIHSP01, `
    QVSQLDMI01, `
    QVSQLEDI01, `
    QVSQLEDI04, `
    QVSQLEM01, `
    QVSQLLIT01, `
    QVSQLSTRAD, `
    SPDBQA1, `
    VEGADEV, `
    VEGATST, `
    WEBSTRATPPSTST `
{Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet" } | `
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
