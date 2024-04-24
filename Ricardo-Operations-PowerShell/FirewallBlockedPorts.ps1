# http://9to5it.com/windows-firewall-is-my-port-being-blocked/
# Checking Windows Firewall for blocked ports

#Enable Dropped Packets Logging
#Start >> Control Panel >> Administrative Tools >> Windows Firewall with Advanced Settings
#From the Actions pane (right-pane) click on Properties
#Select the appropriate firewall profile (Domain, Private or Public). Alternatively, enable logging on all three profiles
#Click the Customise button under the Logging section
#Change the Log Dropped Packets option to Yes
#Take note of the file path to where the logs will be stored
#Click OK to enable logging (see screenshot below)
#Navigate to the logging file path (as per file location in Logging settings above)
#Check the log file for any blocked ports


#To get a list of the Windows Firewall blocked ports and active ports run:
netsh firewall show state

#To get a list of the Windows Firewall configuration run:
netsh firewall show config

netstat -ano | findstr -i SYN_SENT

#LINUX
netstat -ano | grep -i SYN_SENT
