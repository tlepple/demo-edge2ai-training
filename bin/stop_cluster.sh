#!/bin/bash

starting_dir=`pwd`

export PRIVATE_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load util functions.
. $starting_dir/bin/utils.sh


#stop all cluster services:
stop_cluster_services

#check all services are stopped
all_services_status_eq
echo
echo "sleeping for 20s"
sleep 20s

while [ ${ARRAY_EQ} != 'YES' ]; do
    all_services_status_eq
    echo;
    echo "sleeping for 20s"
    echo;
    sleep 20s
done

echo "All Services Stopped!!!"

#check cdsw has stopped all pods
check_role_state
echo

# stop CM Service:
stop_cm_service
echo


# all services should be stopped here:
echo "Everything stopped.  It is safe to shutdown cloud instance..."
