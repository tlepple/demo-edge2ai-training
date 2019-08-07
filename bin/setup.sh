
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

cd $dir/components/install_named

# run the install
$dir/bin/setup.sh

sleep 20 

# return to starting dir
echo "ending dir is --> "`pwd`
cd $starting_dir
log "Completed install of DNS"

echo "current dir is --> "`pwd`




