#!/bin/bash --login

source config.sh
source init-common.sh

echo "Starting Persister"
cd $PERSISTER_DIR

# Env variables:
# - QUEUE_HOST + QUEUE_PORT (path to kafka)
# - METRICS_PORT - Prometheus configuration, 0 to disable
bin/topological_inventory-persister

