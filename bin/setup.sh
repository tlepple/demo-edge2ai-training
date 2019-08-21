#!/bin/bash

#########################################################
# Input parameters
#########################################################

case "$1" in
        aws)
           # echo "server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4" >> /etc/chrony.conf
           # systemctl restart chronyd
            ;;
        azure)
           # umount /mnt/resource
           # mount /dev/sdb1 /opt
            ;;
        gcp)
            ;;
        *)
            echo $"Usage: $0 {aws|azure|gcp} template-file [docker-device]"
            echo $"example: ./setup.sh azure default_template.json"
            echo $"example: ./setup.sh aws cdsw_template.json /dev/xvdb"
            exit 1
esac

CLOUD_PROVIDER=$1

CLUSTER_TEMPLATE=$2
# ugly, but for now the docker device has to be put by the user
BLOCK_DEVICE_LOCATION=$3

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
# Load util functions.
#. $dir/bin/utils.sh
#########################################################
# check cdsw status
#########################################################

check_cdsw(){
  echo "Checking CDSW status (for 10 min max)"
  counter=0
  while [ $counter -lt 600 ]; do
      
    STATUS_CHECK=`cdsw status | tail -1`
    if [ "$STATUS_CHECK" != 'Cloudera Data Science Workbench is ready!' ]; then
      echo "CDSW Status --> "$STATUS_CHECK
      echo "sleeping for 20s"
      echo;
      sleep 20s
      let counter=counter+20
    else
      echo "CDSW is ready!!!!"
      return
    fi
  done
  echo "CDSW is not ready after 10 minutes.  Exiting...";
  exit 1
  
}

#########################################################
# check the role state from api
#########################################################

check_role_state(){
  echo "Checking CDSW role state (for 5 min max)"
  counter=0
  while [ $counter -lt 300 ]; do
    CDSW_ROLE_STATE=`curl -u "admin:admin" -k -s GET http://$PRIVATE_IP:7180/api/v19/clusters/OneNodeCluster/services/cdsw/roles | jq -r '.items[0].roleState'`

    if [ "$CDSW_ROLE_STATE" != 'STOPPED' ]; then
       echo "CDSW Status --> "$CDSW_ROLE_STATE
       echo "sleeping for 20s"
       echo;
       sleep 20s
       let counter=counter+20
    else
       echo "CDSW is STOPPED"
       return  
    fi
  done
  echo "CDSW did not stop after 5 minutes.  Exiting...";
  exit 1

  
}



#########################################################
# BEGIN
#########################################################
log "BEGIN setup.sh"

#####################################################
# first check if JQ is installed
#####################################################
log "Installing jq"

jq_v=`jq --version 2>&1`
if [[ $jq_v = *"command not found"* ]]; then
  if [[ $machine = "Mac" ]]; then
    sudo curl -L -s -o jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64"
  else
    sudo curl -L -s -o jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
  fi 
  sudo chmod +x ./jq
  sudo cp jq /usr/bin
else
  log "jq already installed. Skipping"
fi

jq_v=`jq --version 2>&1`
if [[ $jq_v = *"command not found"* ]]; then
  log "error installing jq. Please see README and install manually"
  echo "Error installing jq. Please see README and install manually"
  exit 1 
fi  


#########################################################
# Install component "forkedOneNode"
#########################################################
log "Begin install of forkedOneNode"


cd $dir/../components/install_forkedOneNode

#echo "is this forkedOneNode dir --> "`pwd`
# run the install of forkedOneNode

#need to pass in some variables
#./setup.sh aws cdsw_template.json /dev/xvdc
./setup.sh $CLOUD_PROVIDER $CLUSTER_TEMPLATE $BLOCK_DEVICE_LOCATION

# return to starting dir
#echo "ending dir of this stage is --> "`pwd`
cd $dir
log "Completed install of forkedOneNode"


#########################################################
# Install component "Supeset"
#########################################################
# Check CDSW again...  Runs long sometimes

log "check status of cdsw before starting superset install"

#echo "current dir before status check --> "`pwd`
#check cdsw status
check_cdsw

# Check CDSW again...  Runs long sometimes
echo
echo
echo "Full Output of CDSW status..."
echo
echo
cdsw status
echo
echo

#check cdsw status again
#check_cdsw

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
# Install component "DNS"
#########################################################
#log "Begin install of DNS"

# stop cdsw
PRIVATE_IP=`hostname --all-ip-addresses |  awk '{print $1;}'`
curl -X POST -u "admin:admin" "http://$PRIVATE_IP:7180/api/v19/clusters/OneNodeCluster/services/cdsw/commands/stop"

# check that cdsw is stopped before proceeding
check_role_state

#cd $dir/../components/install_named

#echo "is this DNS dir --> "`pwd`
# run the install of bind
./bin/setup.sh


# restart cdsw
curl -X POST -u "admin:admin" "http://$PRIVATE_IP:7180/api/v19/clusters/OneNodeCluster/services/cdsw/commands/start"

#check cdsw status
check_cdsw

# Check CDSW again...  Runs long sometimes
echo
echo
echo "Full Output of CDSW status..."
echo
echo
cdsw status
echo
echo

#check cdsw status again
check_cdsw

# return to starting dir
#echo "ending dir is --> "`pwd`
#cd $dir
#log "Completed install of DNS"

#echo "current dir at the end of this script--> "`pwd`
#echo "current value of dir variable is -->"$dir

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
