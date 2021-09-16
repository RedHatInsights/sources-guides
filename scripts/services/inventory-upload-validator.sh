#!/bin/bash --login

echo "Starting Topological Inventory Inventory Upload Validator"
source config.sh
source init-common.sh

cd ${TOPOLOGICAL_INVENTORY_SOURCES_SYNC_DIR}
bin/setup
bin/topological-inventory-inventory-upload-validator --queue-host=${QUEUE_HOST} --queue-port=${QUEUE_PORT}
