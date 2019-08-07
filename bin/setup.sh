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

echo "is this DNS dir --> "`pwd`
# run the install of bind
#./bin/setup.sh

#sleep 20 

# return to starting dir
echo "ending dir is --> "`pwd`
cd $dir
log "Completed install of DNS"

echo "current dir at the end of this script--> "`pwd`
echo "current value of dir variable is -->"$dir


#########################################################
# Install component "forkedOneNode"
#########################################################
log "Begin install of forkedOneNode"


cd $dir/../components/install_forkedOneNode

echo "is this forkedOneNode dir --> "`pwd`
# run the install of forkedOneNode
./setup.sh aws cdsw_template.json /dev/xvdc

#sleep 20

# return to starting dir
echo "ending dir of this stage is --> "`pwd`
cd $dir
log "Completed install of forkedOneNode"

echo "current dir at the end of this stage --> "`pwd`
echo "current value of dir variable is -->"$dir

