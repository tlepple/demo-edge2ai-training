#!/bin/bash

#########################################################
# add aws internal time server for chronyd
#########################################################
INTERNAL_TIME_SERVER=169.254.169.123 # Amazon Time Sync Service

# Set up chronyd with the internal time server
if ! grep -q "${INTERNAL_TIME_SERVER}" /etc/chrony.conf; then
  echo "server ${INTERNAL_TIME_SERVER} prefer iburst" >> /etc/chrony.conf
  systemctl restart chronyd.service
fi

#########################################################
# Install bind and utilities
#########################################################
yum install -y bind bind-utils


#########################################################
# prep named conf files for run time
#########################################################
cd ./components/install_named

#echo "pwd-->" `pwd`

echo "preparing conf files for DNS..."
. bin/prepare_named_setup.sh

echo "running copy commands..."
. bin/copy_files_2_dest.sh

