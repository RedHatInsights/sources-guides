#!/bin/bash --login
echo "Starting Orchestrator"
source config.sh
source init-common.sh

cd ${ORCHESTRATOR_DIR}

#oc login -u developer -p developer $OPENSHIFT_HOST:$OPENSHIFT_PORT;
#export OPENSHIFT_TOKEN=$(oc sa get-token -n management-infra management-admin)

export IMAGE_NAMESPACE=tp-inv
export KUBERNETES_SERVICE_HOST=192.168.42.45
export KUBERNETES_SERVICE_PORT=8443
export MY_NAMESPACE=tp-inv

./bin/topological_inventory-orchestrator --collector-image-tag latest --config=default --metrics-port ${METRICS_PORT} --sources-api ${SOURCES_SCHEME}://${SOURCES_HOST}:${SOURCES_PORT}/${SOURCES_API_BASE_PATH} --topology-api ${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/#{TOPOLOGICAL_INVENTORY_API_BASE_PATH}
