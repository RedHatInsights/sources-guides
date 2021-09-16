#!/bin/bash --login

echo "Starting Topological Inventory Inventory Upload"
source config.sh
source init-common.sh

cd ${TOPOLOGICAL_INVENTORY_SOURCES_SYNC_DIR}
bin/setup
bin/topological-inventory-inventory-upload --queue-host=${QUEUE_HOST} --queue-port=${QUEUE_PORT}
