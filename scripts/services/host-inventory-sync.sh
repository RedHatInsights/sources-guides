#!/bin/bash

source config.sh
source init-common.sh

cd $TOPOLOGICAL_INVENTORY_SYNC_DIR

# - QUEUE_HOST + QUEUE_PORT (path to kafka)
# - TOPOLOGICAL_INVENTORY_API_SERVICE_HOST + TOPOLOGICAL_INVENTORY_API_SERVICE_PORT (path to Topological Inventory API)
# - TOPOLOGICAL_INVENTORY_INGRESS_API_SERVICE_HOST + TOPOLOGICAL_INVENTORY_INGRESS_API_SERVICE_PORT (path to Topological Inventory API)
# - METRICS_PORT
env HOST_INVENTORY_API="http://localhost:3009" PATH_PREFIX="api" APP_NAME="topological-inventory" bin/topological-inventory-host-inventory-sync
