#!/bin/bash

# Install bind and utilities
yum install -y bind bind-utils


#########################################################
# prep named conf files for run time
#########################################################
cd ../components/install_named

#echo "pwd-->" `pwd`

echo "preparing conf files for DNS..."
. bin/prepare_named_setup.sh

echo "running copy commands..."
. bin/copy_files_2_dest.sh
