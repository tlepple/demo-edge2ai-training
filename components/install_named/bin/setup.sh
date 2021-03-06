#!/bin/bash

#########################################################
# utility functions
#########################################################
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

log_dir=`pwd`

# logging function
log() {
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*"
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*" >> $log_dir/setup.log
}

#########################################################
# BEGIN
#########################################################
log "BEGIN setup.sh"

#########################################################
# add aws internal time server for chronyd
#########################################################
log "add aws internal time server for chronyd"

INTERNAL_TIME_SERVER=169.254.169.123 # Amazon Time Sync Service

# Set up chronyd with the internal time server
if ! grep -q "${INTERNAL_TIME_SERVER}" /etc/chrony.conf; then
  echo "server ${INTERNAL_TIME_SERVER} prefer iburst" >> /etc/chrony.conf
  systemctl restart chronyd.service
fi

#########################################################
# Install bind and utilities
#########################################################
log "install bind and bind-utils"
yum install -y bind bind-utils


#########################################################
# prep named conf files for run time
#########################################################
log "prep conf files for run time"

log "preparing conf files for DNS..."
. $dir/prepare_named_setup.sh

log "running copy commands..."
. $dir/copy_files_2_dest.sh


log "COMPLETED setup.sh"
