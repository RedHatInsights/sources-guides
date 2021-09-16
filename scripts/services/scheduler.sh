#!/bin/bash --login
# Usage ./ansible-tower-operations.sh
echo "Starting Ansible Tower Operations worker"
source config.sh
source init-common.sh

#export PATH_PREFIX="/api"

cd ${SCHEDULER_DIR}

# No args, used ENV vars:

# - QUEUE_HOST + QUEUE_PORT (path to kafka)
# - METRICS_PORT - Prometheus configuration, 0 to disable
bin/topological_inventory-scheduler
