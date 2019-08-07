#!/bin/bash

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
./setup.sh aws cdsw_template.json /dev/xvdb

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
