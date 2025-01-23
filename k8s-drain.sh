#!/bin/bash

NODE_NAME=$1
ROLLOUT_CMD=$2

if [[ "$NODE_NAME" == "" ]]; then
  echo "
  USAGE: ./drain.sh <NODE_NAME>

  Drains a node from its Deployments/Stateful set pods.

  Examples:

    # List Deploy/Sts objects that have pods running on the given node
    ./drain.sh NODE_NAME

    # Perform the actual rollout restart
    ./drain.sh NODE_NAME restart

  Pre-requisite: Kubernetes 1.15.x or newer.
"
  exit 1
fi

function rollout_restart() {

  ## Object types to be processed
  ## This could be deployment ou satefulset.
  OBJTYPE=$1

  ## Loop through all objects of type $OBJTYPE.
  ## Splits their names and namespaces.
  for dp in $(kubectl get $OBJTYPE -A --no-headers | awk '{print $1 "|" $2}'); do
    NAMESPACE=$(echo $dp | sed 's/|.*//')
    DEPLOY=$(echo $dp | sed 's/.*|//')
    
    ## For each Deploy/Sts, acquire the SELECTOR used to select its pods.
    SELECTOR=$(kubectl get $OBJTYPE --no-headers -owide -n $NAMESPACE $DEPLOY -owide | awk '{print $8}')

    ## Using SELECTOR, list all pods from the Deploy/Sts running in the target node
    PODLIST=$(kubectl get pod -owide --no-headers -n $NAMESPACE -l "$SELECTOR" | grep $NODE_NAME | awk '{print $1}')

    ## If we have pods running in NODE_NAME, act accordingly
    if [[ "$PODLIST" != "" ]]; then
      echo "=== $OBJTYPE $NAMESPACE/$DEPLOY ==="
      echo $PODLIST | sed 's/ /\n/g'
      if [[ "$ROLLOUT_CMD" != "" ]]; then
        echo ">> Rollout restart..."
        set -x
        kubectl rollout $ROLLOUT_CMD -n $NAMESPACE $OBJTYPE/$DEPLOY
        set +x
      fi

      echo
    fi
  done
}

if [[ "$ROLLOUT_CMD" == "restart" ]]; then
  set -x
  kubectl cordon $NODE_NAME
  set +x
fi

rollout_restart deploy
rollout_restart sts
