#!/bin/bash --login
# Usage ./azure-operations.sh
echo "Starting Azure Operations worker"
source config.sh
source init-common.sh

#export PATH_PREFIX="/api"

cd ${AZURE_DIR}

# No args, used ENV vars:

# - QUEUE_HOST + QUEUE_PORT (path to kafka)
# - SOURCES_SCHEME + SOURCES_HOST + SOURCES_PORT (path to Sources API svc)
# - TOPOLOGICAL_INVENTORY_API_SERVICE_HOST + TOPOLOGICAL_INVENTORY_API_SERVICE_PORT (path to Topological Inventory API)
# - METRICS_PORT - Prometheus configuration, 0 to disable
bin/azure-operations

