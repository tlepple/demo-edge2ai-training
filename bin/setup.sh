#!/bin/bash

#########################################################
# untility functions
#########################################################
# logging function
log() {
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*"
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*" >> setup.log
}

# get the directory currently running in
orig_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#########################################################
# Begin
#########################################################

log "BEGIN setup.sh"

log "Install Component Named"

cd ../components/install_named/bin

. setup.sh

. $orig_dir
log "Completed setup.sh"
