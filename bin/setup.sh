#!/bin/bash

#########################################################
# Input parameters
#########################################################

case "$1" in
        aws)
           # echo "server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4" >> /etc/chrony.conf
           # systemctl restart chronyd
            ;;
        azure)
           # umount /mnt/resource
           # mount /dev/sdb1 /opt
            ;;
        gcp)
            ;;
        *)
            echo $"Usage: $0 {aws|azure|gcp} template-file [docker-device]"
            echo $"example: ./setup.sh azure default_template.json"
            echo $"example: ./setup.sh aws cdsw_template.json /dev/xvdb"
            exit 1
esac

CLOUD_PROVIDER=$1

CLUSTER_TEMPLATE=$2
# ugly, but for now the docker device has to be put by the user
BLOCK_DEVICE_LOCATION=$3

#########################################################
# utility functions
#########################################################
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

starting_dir=`pwd`

# logging function
log() {
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*"
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*" >> $starting_dir/setup-all.log
}

#########################################################
# BEGIN
#########################################################
log "BEGIN setup.sh"

#########################################################
# Install component "DNS"
#########################################################
log "Begin install of DNS"

cd $dir/../components/install_named

#echo "is this DNS dir --> "`pwd`
# run the install of bind
./bin/setup.sh

#sleep 20 

# return to starting dir
#echo "ending dir is --> "`pwd`
cd $dir
log "Completed install of DNS"

#echo "current dir at the end of this script--> "`pwd`
#echo "current value of dir variable is -->"$dir


#########################################################
# Install component "forkedOneNode"
#########################################################
log "Begin install of forkedOneNode"


cd $dir/../components/install_forkedOneNode

#echo "is this forkedOneNode dir --> "`pwd`
# run the install of forkedOneNode

#need to pass in some variables
#./setup.sh aws cdsw_template.json /dev/xvdc
./setup.sh $CLOUD_PROVIDER $CLUSTER_TEMPLATE $BLOCK_DEVICE_LOCATION

#sleep 20

# return to starting dir
#echo "ending dir of this stage is --> "`pwd`
cd $dir
log "Completed install of forkedOneNode"

#echo "current dir at the end of this stage --> "`pwd`
#echo "current value of dir variable is -->"$dir

#########################################################
# Install component "Supeset"
#########################################################
# Check CDSW again...  Runs long sometimes

log "check status of cdsw before starting superset install"

#echo "current dir before status check --> "`pwd`
#check cdsw status
./cdsw_status-testing.sh

# Check CDSW again...  Runs long sometimes
echo
echo
echo "Full Output of CDSW status..."
echo
echo
cdsw status
echo
echo

#check cdsw status again
./cdsw_status-testing.sh

# change to dir for superset
cd $dir/../components/install_superset
echo "current dir at this stage --> "`pwd`
./bin/setup.sh

# return to starting dir
echo "ending dir at install of superset is --> "`pwd`
cd $dir
log "Completed install of Superset"

echo "current dir at the end of this script--> "`pwd`
echo "current value of dir variable is -->"$dir

#########################################################
# Print services URLs
#########################################################
log "echo services URLs"

# run the echo serivces
./echo_service_conns.sh

echo "change to original directory at start of scripts"
cd $starting_dir
echo "here is my final pwd -->" `pwd`

echo
echo "---------------------------------------------------------------------------"
log "COMPLETED ALL SETUP!!!"
echo "---------------------------------------------------------------------------"
echo
