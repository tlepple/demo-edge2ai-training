#!/bin/bash
 
#########################################################
# Utilities to check things out:
#########################################################

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
  return
  
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
  return

  
}

#########################################################
# Start CM Service
#########################################################

start_cm_service() {
    # get the current status
    get_cm_status

    if [ ${CM_STATUS} == 'STOPPED' ]; then
        echo "Starting CM Service"
        curl -X POST -u "admin:admin" "http://${PRIVATE_IP}:7180/api/v19/cm/service/commands/start"
    fi

    # check for 5 min if status is started
    echo "Check to see if CM is started (for 5 min max)"
    counter=0

    while [ $counter -lt 300 ]; do
        get_cm_status
        if [ ${CM_STATUS} != 'STARTED' ]; then
            echo "CM Current Status is --> " ${CM_STATUS}
            echo "sleeping for 20s"
            echo;
            sleep 20s
            let counter=counter+20
        else
            echo "CM is ready!!!"
           return
        fi
    done  
    return

}

#########################################################
# Stop CM Service
#########################################################

stop_cm_service() {
    # get the current status
    get_cm_status

    if [ ${CM_STATUS} == 'STARTED' ]; then
        echo "Stopping CM Service"
        curl -X POST -u "admin:admin" "http://${PRIVATE_IP}:7180/api/v19/cm/service/commands/stop"
    fi

    # check for 5 min if status is started
    echo "Check to see if CM is stopped (for 5 min max)"
    counter=0

    while [ $counter -lt 300 ]; do
        get_cm_status
        if [ ${CM_STATUS} != 'STOPPED' ]; then
            echo "CM Current Status is --> " ${CM_STATUS}
            echo "sleeping for 20s"
            echo;
            sleep 20s
            let counter=counter+20
        else
            echo "CM is stopped!"
           return
        fi
    done
    return

}

#########################################################
# Start All Cluster Services
#########################################################

start_cluster_services() {
    get_cluster_name
    get_cluster_entity_status

    if [ ${CLUSTER_ENTITY_STATUS} == 'STOPPED' ]; then
        echo "Starting Cluster Services..."
        curl -X POST -u "admin:admin" "http://${PRIVATE_IP}:7180/api/v19/clusters/${CLUSTER_NAME}/commands/start"
    fi

  return

}

#########################################################
# Stop All Cluster Services
#########################################################

stop_cluster_services() {
    get_cluster_name
    get_cluster_entity_status
    if [ ${CLUSTER_ENTITY_STATUS} == 'GOOD_HEALTH' ]; then
        echo "Stopping Cluster Services..."
        curl -X POST -u "admin:admin" "http://${PRIVATE_IP}:7180/api/v19/clusters/${CLUSTER_NAME}/commands/stop"
    fi

    return

}

#########################################################
# Get CM Status
#########################################################

get_cm_status () {
    CM_STATUS=`curl -X  GET -u "admin:admin" -k -s "http://${PRIVATE_IP}:7180/api/v19/cm/service" | jq -r '.serviceState'`
}

#########################################################
# Get Cluster Name
#########################################################

get_cluster_name () {
    CLUSTER_NAME=`curl -X  GET -u "admin:admin" -k -s "http://${PRIVATE_IP}:7180/api/v19/clusters" | jq -r '.items[].name'`
}

#########################################################
# Get Service State
#########################################################

get_service_state(){
    get_cluster_name
    
    CURRENT_SERVICE_STATE=`curl -u "admin:admin" -k -s GET http://${PRIVATE_IP}:7180/api/v19/clusters/${CLUSTER_NAME}/services/$1 | jq -r '.serviceState'`
}

#########################################################
# Get Installed Services
#########################################################

get_installed_services() {
    get_cluster_name
    
    INSTALLED_SERVICES=`curl -X GET -u "admin:admin" -k -s "http://${PRIVATE_IP}:7180/api/v19/clusters/${CLUSTER_NAME}/services" | jq -r '.items[].name'`
}

#########################################################
# Get Cluster Entity Status 
#########################################################

get_cluster_entity_status() {
    get_cluster_name
    
    CLUSTER_ENTITY_STATUS=`curl -X GET -u "admin:admin" -k -s "http://${PRIVATE_IP}:7180/api/v19/clusters/${CLUSTER_NAME}" | jq -r '.entityStatus'`
}

#########################################################
# Is Array Equal function 
#########################################################

isarray.equal () {
    local placeholder="$1"
    local num=0
    while (( $# )); do
        if [[ "$1" != "$placeholder" ]]; then
            num=1
#            echo 'Bad' && break
            ARRAY_EQ='NO' && break
        fi
        shift
    done
#    [[ "$num" -ne 1 ]] && echo 'Okay'
    [[ "$num" -ne 1 ]] && ARRAY_EQ='YES'
}

#########################################################
# All Service Status Equal
#########################################################

all_services_status_eq () {
    get_installed_services

    args=()

    for value in ${INSTALLED_SERVICES}; do

       get_service_state ${value}
       echo "       "  ${value} " service state is --> " ${CURRENT_SERVICE_STATE}

       args+=(${CURRENT_SERVICE_STATE})
   done

    echo "args array values --> " "${args[@]}"
    isarray.equal "${args[@]}"

    echo "Is Array Equal ? --> " ${ARRAY_EQ}
}
