#!/bin/bash --login

echo "Starting Topological Inventory Sources Sync"
source config.sh
source init-common.sh

cd ${TOPOLOGICAL_INVENTORY_SYNC_DIR}

sleep 5 # Waiting for API init
bin/topological-inventory-sources-sync
