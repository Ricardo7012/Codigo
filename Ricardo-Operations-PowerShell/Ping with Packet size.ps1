Clear-Host

$env:UserName
$env:UserDomain
$env:ComputerName

Get-Date -Format G
netsh interface ipv4 show interface  #<----  THIS GETS THE INDEX # FOR THE INTERFACE

ping -l 1472 -f dvsqlpol01 #<---- THIS IS 1500 MINUS 28, THERE IS ALWAYS 28 BYTES OF "OVERHEAD"

Write-Host -ForegroundColor green "*************************************************************************************************************************"
Get-NetAdapterAdvancedProperty -DisplayName "Jumbo Packet"
Write-Host -ForegroundColor green "*************************************************************************************************************************"

Invoke-Command -ComputerName HSP2S1A, HSP2S1B, HSP2S1C, HSP3S1A, HSP4S1A, HSP5S1A, DVSQLPOL01, DTSQLBKUPS, MOHSP1S1A, MOHSP1S1B {Get-NetAdapterAdvancedProperty  -DisplayName "Jumbo Packet"}

#Now that we know the exact size, we can set the MTU on the NIC using the index # that we grabbed earlier
netsh inteface ipv4 set interface "4" mtu=1472 store=persistent

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
