#! /bin/bash

#########################################################
# load utility functions
#########################################################
. utilities.sh

log "BEGIN temp-fix-nic-bug.sh"
#########################################################
# prep named conf files for run time
#########################################################


log "delete network conf file"
yes | /bin/rm -i /etc/sysconfig/network-scripts/ifcfg-eth0
for PATH_DHCLIENT_PID in /var/run/dhclient*
 do
 export PATH_DHCLIENT_PID
 echo "PID=" $PATH_DHCLIENT_PID
 dhclient -r
 # Making sure it really truly stopped
 PIDVAL=`cat $PATH_DHCLIENT_PID`
 kill $PIDVAL 
 /bin/rm -f $PATH_DHCLIENT_PID
 done

log "COMPLETED temp-fix-nic-bug.sh"
