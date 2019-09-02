#!/bin/bash

starting_dir=`pwd`

export PRIVATE_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load util functions.
. $starting_dir/bin/utils.sh


# start CM Service:
start_cm_service

# Start all cluster services:
start_cluster_services

#check all services are started
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

echo "All Services Started!!!"

#check that CDSW is ready   
check_cdsw

#echo services connections
. ${starting_dir}/bin/echo_service_conns.sh

