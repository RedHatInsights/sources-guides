#!/bin/bash --login

operation=$1

if [ "$operation" == "topo" ]; then
  oc project topological-inventory-qa

  for i in $(oc get is | grep topological-inventory- | awk '{print $1}'); do
  oc import-image docker-registry.default.svc:5000/topological-inventory-qa/$i:qa; done
elif [ "${operation}" == "sources" ]; then
  oc project sources-qa

  for i in $(oc get is | grep sources- | awk '{print $1}'); do
  oc import-image docker-registry.default.svc:5000/sources-qa/$i:qa; done
else
  echo "Usage: ./deploy-qa.sh [topo|sources]"
fi
