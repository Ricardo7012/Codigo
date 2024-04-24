#!/bin/bash
# .Objective
# CDP Linux Host setup script #1
#
# .DESCRIPTION
# sudo ./cdp_host_setup1.sh 03 true
#
# .PARAMETER
# $1: the two-digit number of the hostname, like 01, 02, ..., 12.
# $2: Is it production? true or false
#
# .CHANGE LOG
# Developed By: Haijin Li
# Date Created: 20210821
# Update yyyymmdd:
#
# chmod 764 ./cdp_host_setup1.sh
#
# PROFILE
# /home/dlakadmin/

##########################################################
# Script Options
##########################################################
set -o nounset
set -o pipefail
set -o errexit

##########################################################
# Main Workflow
##########################################################
LOG_FILE_DIR=.
LOG_FILE_PATH=$LOG_FILE_DIR/$(basename "$0").log # the log is always named with the script name

#initialize local variables
msg=''
linecount=0

if [[ "$2" = true ]]; then
    HOST_FILE_PATH=/etc/hosts
    NETWORK_FILE_PATH=/etc/sysconfig/network
    SELINUX_FILE_PATH=/etc/selinux/config
    CHRONYD_FILE_PATH=/etc/chrony.conf
else
    HOST_FILE_PATH=../tmp8/hosts
    NETWORK_FILE_PATH=../tmp8/network
    SELINUX_FILE_PATH=../tmp8/config
    CHRONYD_FILE_PATH=../tmp8/chrony.conf
fi

#echo $LOG_FILE_PATH # debugging
source ./logger_v2.sh

SCRIPTENTRY # log the start of script execution

logger -s "################################################"
logger -s "Running cdp_host_setup1.sh"
logger -s "################################################"

INFO "Setting up $1"

# NO need to set hostname because it is done already

linecount=$(wc <$HOST_FILE_PATH -l)
if [[ "$linecount" -ge 12 ]]; then
    msg="hosts file has been updated already"
    ERROR "$msg"
    echo $msg
    exit 11
fi

INFO "Apending entries to $HOST_FILE_PATH file"

echo "172.18.205.68 PVLAKCDP01.iehp.local PVLAKCDP01
172.18.205.69 PVLAKCDP02.iehp.local PVLAKCDP02
172.18.205.70 PVLAKCDP03.iehp.local PVLAKCDP03
172.18.205.71 PVLAKCDP04.iehp.local PVLAKCDP04
172.18.205.72 PVLAKCDP05.iehp.local PVLAKCDP05
172.18.205.73 PVLAKCDP06.iehp.local PVLAKCDP06
172.18.205.74 PVLAKCDP07.iehp.local PVLAKCDP07
172.18.205.75 PVLAKCDP08.iehp.local PVLAKCDP08
172.18.205.76 PVLAKCDP09.iehp.local PVLAKCDP09
172.18.205.77 PVLAKCDP10.iehp.local PVLAKCDP10
172.18.205.78 PVLAKCDP11.iehp.local PVLAKCDP11
172.18.205.79 PVLAKCDP12.iehp.local PVLAKCDP12" >>$HOST_FILE_PATH

INFO "Logging $HOST_FILE_PATH content"
cat $HOST_FILE_PATH >>$LOG_FILE_PATH
echo "" >>$LOG_FILE_PATH

linecount=$(wc <$NETWORK_FILE_PATH -l)
if [[ "$linecount" -ge 2 ]]; then
    msg="network file has been updated already"
    ERROR "$msg"
    echo $msg
    exit 12
fi

echo "HOSTNAME=PVLAKCDP${1}.iehp.local" >>$NETWORK_FILE_PATH
INFO "Logging $NETWORK_FILE_PATH content"
cat $NETWORK_FILE_PATH >>$LOG_FILE_PATH
echo "" >>$LOG_FILE_PATH

INFO "logging the output of hostname"
hostname | tee -a $LOG_FILE_PATH

INFO "Logging the output of uname -a"
uname -a | tee -a $LOG_FILE_PATH

INFO "Logging the output of /sbin/ifconfig, getting the ip of ens160"
/sbin/ifconfig | tee -a $LOG_FILE_PATH

INFO 'Logging the output of host -v -t A $(hostname)'
host -v -t A $(hostname) | tee -a $LOG_FILE_PATH

INFO 'Logging the content of iptable and saving it to ./firewall.rules'
sudo iptables-save >>$LOG_FILE_PATH
sudo iptables-save >./firewall.rules

INFO 'Disabling and Stopping the firewall and logging its status'
sudo systemctl disable firewalld | tee -a $LOG_FILE_PATH
sudo systemctl stop firewalld | tee -a $LOG_FILE_PATH
systemctl status firewalld --no-pager >>$LOG_FILE_PATH || true
systemctl status firewalld || true

INFO 'logging the output of getenforce'
getenforce | tee -a $LOG_FILE_PATH

INFO "Updating $SELINUX_FILE_PATH, Changing the line SELINUX=enforcing to SELINUX=permissive, and logging the file content"
sed -i '/SELINUX=enforcing/c\SELINUX=permissive' $SELINUX_FILE_PATH
cat $SELINUX_FILE_PATH >>$LOG_FILE_PATH

INFO 'Logging the output of setenforce 0'
setenforce 0 >>$LOG_FILE_PATH

INFO 'logging the output of getenforce, confirming the current setting'
getenforce | tee -a $LOG_FILE_PATH

#NTP should be active via Chronyd
#INFO 'Logging the status of Chronyd'
#systemctl status Chronyd --no-pager >>$LOG_FILE_PATH || true
#systemctl status Chronyd || true

#INFO "Logging the content of $CHRONYD_FILE_PATH"
#cat $CHRONYD_FILE_PATH >>$LOG_FILE_PATH

logger -s "################################################"
logger -s "cdp_host_setup1.sh Completed."
logger -s "################################################"

SCRIPTEXIT
