#!/bin/bash

# Calculate the location of this script.
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


#########################################################
# prep install.properties file
#########################################################
INSTALL_PROPS_TEMP=./templatefiles/install.properties.template
FINAL_INSTALL_PROPS_FILE=install.properties

GETHOST=`hostname -f`
GETSHORT=`hostname --short`
GETDOMAIN=`hostname --domain`
GETIP=`hostname --all-ip-addresses |sed 's/^[ \t]*//;s/[ \t]*$//'`
GETDNSIP=`awk '/nameserver/{print $2}' /etc/resolv.conf`

# create the new file from template
cp $INSTALL_PROPS_TEMP ./$FINAL_INSTALL_PROPS_FILE

# update the new file with the varaibles in install.properties file
sed -i.bak -e "s/NAMED_HOSTNAME_VALUE/$GETHOST/g" ./$FINAL_INSTALL_PROPS_FILE
sed -i.bak -e "s/NAMED_SHORTNAME_VALUE/$GETSHORT/g" ./$FINAL_INSTALL_PROPS_FILE
sed -i.bak -e "s/NAMED_IP_VALUE/$GETIP/g" ./$FINAL_INSTALL_PROPS_FILE
sed -i.bak -e "s/DOMAIN_NAME_VALUE/$GETDOMAIN/g" ./$FINAL_INSTALL_PROPS_FILE
sed -i.bak -e "s/CDSW_SHORTNAME_VALUE/$GETSHORT/g" ./$FINAL_INSTALL_PROPS_FILE
sed -i.bak -e "s/CDSW_IP_VALUE/$GETIP/g" ./$FINAL_INSTALL_PROPS_FILE
sed -i.bak -e "s/PRIMARY_DNSHOST_IP_VALUE/$GETDNSIP/g" ./$FINAL_INSTALL_PROPS_FILE

#########################################################

# Load variables from install.properties file for code below:
. $dir/../install.properties


#########################################################
# prep named.conf.local file 
#########################################################
NAMED_CONF_LOCAL_TEMP=./templatefiles/named.conf.local.template

FINAL_NAMED_CONF_LOCAL_FILE=named.conf.local

# create the new file from template
cp $NAMED_CONF_LOCAL_TEMP ./files/$FINAL_NAMED_CONF_LOCAL_FILE

# update the new file with the varaibles defined in install.properties file
sed -i.bak -e "s/DOMAIN_NAME_VALUE/$DOMAIN_NAME/g" ./files/$FINAL_NAMED_CONF_LOCAL_FILE
sed -i.bak -e "s/ZONE_VALUE/$ZONE_VALUE/g" ./files/$FINAL_NAMED_CONF_LOCAL_FILE
sed -i.bak -e "s/FIRST_OCTET_VALUE/$FIRST_OCTET/g" ./files/$FINAL_NAMED_CONF_LOCAL_FILE
sed -i.bak -e "s/SECOND_OCTET_VALUE/$SECOND_OCTET/g" ./files/$FINAL_NAMED_CONF_LOCAL_FILE
sed -i.bak -e "s/THIRD_OCTET_VALUE/$THIRD_OCTET/g" ./files/$FINAL_NAMED_CONF_LOCAL_FILE

#########################################################
# prep db.internal file
#########################################################
DB_INTERNAL_TEMP=./templatefiles/db.internal.template
FINAL_DB_INTERNAL_FILE=db.internal

# create the new file from template
cp $DB_INTERNAL_TEMP ./files/$FINAL_DB_INTERNAL_FILE

# update the new file with the varaibles defined in install.properties file
sed -i.bak -e "s/DOMAIN_NAME_VALUE/$DOMAIN_NAME/g" ./files/$FINAL_DB_INTERNAL_FILE
sed -i.bak -e "s/NAMED_HOSTNAME_VALUE/$NAMED_HOSTNAME/g" ./files/$FINAL_DB_INTERNAL_FILE
sed -i.bak -e "s/NAMED_SHORTNAME_VALUE/$NAMED_SHORTNAME/g" ./files/$FINAL_DB_INTERNAL_FILE
sed -i.bak -e "s/NAMED_IP_VALUE/$NAMED_IP/g" ./files/$FINAL_DB_INTERNAL_FILE
sed -i.bak -e "s/CDSW_SHORT_HOSTNAME_VALUE/$CDSW_SHORT_HOSTNAME/g" ./files/$FINAL_DB_INTERNAL_FILE
sed -i.bak -e "s/CDSW_INTERNAL_IP_VALUE/$CDSW_INTERNAL_IP/g" ./files/$FINAL_DB_INTERNAL_FILE

#########################################################
# prep db.reverse file
#########################################################
DB_REVERSE_TEMP=./templatefiles/db.reverse.template
FINAL_DB_REVERSE_FILE=db.reverse

# create the new file from template
cp $DB_REVERSE_TEMP ./files/$FINAL_DB_REVERSE_FILE

# update the new file with the varaibles defined in install.properties file
sed -i.bak -e "s/ZONE_VALUE/$ZONE_VALUE/g" ./files/$FINAL_DB_REVERSE_FILE
sed -i.bak -e "s/DOMAIN_NAME_VALUE/$DOMAIN_NAME/g" ./files/$FINAL_DB_REVERSE_FILE
sed -i.bak -e "s/NAMED_HOSTNAME_VALUE/$NAMED_HOSTNAME/g" ./files/$FINAL_DB_REVERSE_FILE
sed -i.bak -e "s/LAST_OCTET_VALUE/$LAST_OCTET/g" ./files/$FINAL_DB_REVERSE_FILE

#########################################################
# prep named.conf file
#########################################################
NAMED_CONF_TEMP=./templatefiles/named.conf.template
FINAL_NAMED_CONF_FILE=named.conf

# create the new file from template
cp $NAMED_CONF_TEMP ./files/$FINAL_NAMED_CONF_FILE

# update the new file with the varaibles defined in install.properties file
sed -i.bak -e "s/FIRST_OCTET_VALUE/$FIRST_OCTET/g" ./files/$FINAL_NAMED_CONF_FILE
sed -i.bak -e "s/SECOND_OCTET_VALUE/$SECOND_OCTET/g" ./files/$FINAL_NAMED_CONF_FILE
sed -i.bak -e "s/THIRD_OCTET_VALUE/$THIRD_OCTET/g" ./files/$FINAL_NAMED_CONF_FILE
sed -i.bak -e "s/PRIMARY_DNSHOST_IP_VALUE/$PRIMARY_DNSHOST_IP/g" ./files/$FINAL_NAMED_CONF_FILE
sed -i.bak -e "s/NAMED_IP_VALUE/$NAMED_IP/g" ./files/$FINAL_NAMED_CONF_FILE


########################################################
########################################################
# cleanup the .bak files temp files it created
rm $dir/../files/*.bak
rm $dir/../*.bak

echo "COMPLETED copy of properties to files"


########################################################