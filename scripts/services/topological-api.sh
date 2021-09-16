#!/bin/bash --login
echo "Starting Topological Inventory API"
source config.sh
source init-common.sh

cd $TOPOLOGICAL_API_DIR
env SOURCES_SCHEME=${SOURCES_SCHEME} SOURCES_HOST=${SOURCES_HOST} SOURCES_PORT=${SOURCES_PORT} PORT=$TOPOLOGICAL_INVENTORY_API_SERVICE_PORT PATH_PREFIX="api" APP_NAME="topological-inventory" rails s --binding 0.0.0.0
