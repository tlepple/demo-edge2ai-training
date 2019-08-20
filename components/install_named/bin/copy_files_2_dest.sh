#!/bin/bash


#########################################################
# BEGIN
#########################################################
log "Begin copy_files_2_dest.sh"


#########################################################
# identify network and fix items
#########################################################

log "Identify Active NIC and fix issues..."

# set some ip and dns variables:
GETIP=`hostname --all-ip-addresses |sed 's/^[ \t]*//;s/[ \t]*$//'`
GETDNSIP=`awk '/nameserver/{print $2}' /etc/resolv.conf`

# identify the value set for active nic
ACTIVE_NIC=$(ifconfig -a | grep "UP,BROADCAST,RUNNING" | awk '{print $1}' | sed 's/.$//')
NIC_FILENAME="ifcfg-"$ACTIVE_NIC

# backup orig files
/bin/cp /etc/sysconfig/network-scripts/$NIC_FILENAME /etc/sysconfig/network-scripts/orig.$NIC_FILENAME

if [ $ACTIVE_NIC != 'eth0' ]; then
    # commands here for non standard nic... ie: ens3
    echo "DNS1="$GETIP >> /etc/sysconfig/network-scripts/$NIC_FILENAME
    echo "DNS2="$GETDNSIP >> /etc/sysconfig/network-scripts/$NIC_FILENAME
    /bin/cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/orig.ifcfg-eth0
#    yes | /bin/rm -i /etc/sysconfig/network-scripts/ifcfg-eth0
    /bin/rm -f /etc/sysconfig/network-scripts/ifcfg-eth0
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
else
    # commands here for standard nic... ie: eth0
    echo "DNS1="$GETIP >> /etc/sysconfig/network-scripts/$NIC_FILENAME
    echo "DNS2="$GETDNSIP >> /etc/sysconfig/network-scripts/$NIC_FILENAME

fi

log "Completed active network fixes"

#########################################################
# backup some orig files
#########################################################
log "Begin backups of orig files"


# make direcotry
mkdir -p /etc/named/zones

# make a backup of orig files
/bin/cp /etc/named.conf /etc/orig.named.conf

#  copy files to DNS directory locations
/bin/cp $dir/../files/named.conf /etc/named.conf
/bin/cp $dir/../files/named.conf.local /etc/named/named.conf.local
/bin/cp $dir/../files/db.internal /etc/named/zones/db.internal
/bin/cp $dir/../files/db.reverse /etc/named/zones/db.reverse


# change owner and permssions
chown root:named /etc/named.conf
chown root:named /etc/named/zones/
chown root:named /etc/named/named.conf.local
chown root:named /etc/named/zones/db.internal
chown root:named /etc/named/zones/db.reverse
chmod 640 /etc/named.conf
chmod 640 /etc/named/named.conf.local
chmod 640 /etc/named/zones/db.internal
chmod 640 /etc/named/zones/db.reverse

log "end backup of files"

#########################################################
# restart some services
#########################################################
log "restarting network"
sleep 2s

# restart local network
systemctl restart network

sleep 5s

# restart chronyd --> restarting network sometimes affects ntp
log "restarting chronyd"
systemctl restart chronyd

sleep 5s

# restart named
log "restart named"
systemctl restart named

# ensure named will run on a reboot
systemctl enable named

log "services have been restarted"

log "Completed copy_files_2_dest.sh"
