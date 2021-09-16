#!/bin/bash --login

# Usage:
# You have to be logged in to openshift and switched to your project [namespace]
#
# Then find-source.sh <source-id>

source_id=$1

maps=$(oc get configmaps -l tp-inventory/collectors-config-map --no-headers | awk '{print $1}')

for map in ${maps[@]}
do
  found=$(oc describe configmap ${map} | grep ":source_id: '${source_id}'")
  if [[ -n $found ]]; then
    echo ${map}
  fi
done
