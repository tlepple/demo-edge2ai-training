#!/bin/bash
 
#########################################################
# BEGIN
#########################################################


CDSW_ROLE_STATE=`curl -u "admin:admin" -k -s GET http://$PRIVATE_IP:7180/api/v19/clusters/OneNodeCluster/services/cdsw/roles | jq -r '.items[0].roleState'`
#########################################################
# BEGIN
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

check_role_state
