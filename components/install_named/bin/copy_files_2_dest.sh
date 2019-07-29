#!/bin/bash

# Calculate the location of this script.
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# make direcotry
mkdir -p /etc/named/zones

# make a backup of orig files
yes | cp /etc/named.conf /etc/orig.named.conf
yes | cp /etc/named/named.conf.local /etc/named/orig.named.conf.local
yes | cp /etc/named/zones/db.internal /etc/named/zones/orig.db.internal
yes | cp /etc/named/zones/db.reverse /etc/named/zones/orig.db.reverse
yes | cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/orig.ifcfg-eth0

#  copy files to DNS directory locations
yes | cp $dir/../files/named.conf /etc/named.conf
yes | cp $dir/../files/named.conf.local /etc/named/named.conf.local
yes | cp $dir/../files/db.internal /etc/named/zones/db.internal
yes | cp $dir/../files/db.reverse /etc/named/zones/db.reverse

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

sleep 2s

# restart local network
systemctl restart network

sleep 5s

# restart chronyd --> restarting network sometimes affects ntp
systemctl restart chronyd

sleep 5s

# restart named
systemctl restart named
