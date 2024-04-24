#! /usr/bin/bash
# script: logger_v2.sh
# 1. A standard logging procedure and logging format for Data Lake operations
# 2. The log file location is provided by the calling script via the Variable LOG_FILE_LOCATION
# 3. It is based on logger.sh file
#
# Developed By: Haijin Li
# Date Created: 20210126
# Date Last Modified:
#
# 
# chmod 764
#

############################
# Script for logging
############################
readonly script_log=$LOG_FILE_PATH

touch $script_log

function DATE_TIME() {
   echo $(date +"%Y-%m-%d %H:%M:%S")
}

function SCRIPTENTRY() {
   local script_name=$(basename "$0")
   local script_name="${script_name%.*}"
   echo "$(DATE_TIME) DEBUG  >> $script_name $FUNCNAME" >>$script_log
}

function SCRIPTEXIT() {
   local script_name=$(basename "$0")
   local script_name="${script_name%.*}"
   echo "$(DATE_TIME) DEBUG  << $script_name $FUNCNAME" >>$script_log
}

function ENTRY() {
   local cfn="${FUNCNAME[1]}"
   echo "$(DATE_TIME) DEBUG  > $cfn $FUNCNAME" >>$script_log
}

function EXIT() {
   local cfn="${FUNCNAME[1]}"
   echo "$(DATE_TIME) DEBUG  < $cfn $FUNCNAME" >>$script_log
}

function INFO() {
   local msg="$1"
   echo "$(DATE_TIME) INFO  $msg" >>$script_log
}

function DEBUG() {
   local msg="$1"
   echo "$(DATE_TIME) DEBUG  $msg" >>$script_log
}

function ERROR() {
   local msg="$1"
   echo "$(DATE_TIME) ERROR  $msg" >>$script_log
}
