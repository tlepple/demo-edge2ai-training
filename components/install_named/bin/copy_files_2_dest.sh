#!/bin/bash

# Calculate the location of this script.
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# make direcotry
mkdir -p /etc/named/zones

# make a backup of orig files
/bin/cp /etc/named.conf /etc/orig.named.conf
/bin/cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/orig.ifcfg-eth0

#  copy files to DNS directory locations
/bin/cp $dir/../files/named.conf /etc/named.conf
/bin/cp $dir/../files/named.conf.local /etc/named/named.conf.local
/bin/cp $dir/../files/db.internal /etc/named/zones/db.internal
/bin/cp $dir/../files/db.reverse /etc/named/zones/db.reverse

echo "copied files to final destination"

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

# copy dns to nic file --> /etc/sysconfig/network-scripts/ifcfg-eth0
GETIP=`hostname --all-ip-addresses |sed 's/^[ \t]*//;s/[ \t]*$//'`
GETDNSIP=`awk '/nameserver/{print $2}' /etc/resolv.conf`
echo "DNS1="$GETIP >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "DNS2="$GETDNSIP >> /etc/sysconfig/network-scripts/ifcfg-eth0

echo "restarting some services..."
sleep 2s

# restart local network
systemctl restart network

sleep 5s

# restart chronyd --> restarting network sometimes affects ntp
systemctl restart chronyd

sleep 5s

# restart named
systemctl restart named

echo "services have been restarted"
