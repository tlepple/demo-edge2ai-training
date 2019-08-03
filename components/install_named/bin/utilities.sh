#!/bin/bash

#########################################################
# untility functions
#########################################################
# logging function
log() {
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*"
    echo -e "[$(date)] [$BASH_SOURCE: $BASH_LINENO] : $*" >> test-setup.log
}

# get the directory currently running in
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

