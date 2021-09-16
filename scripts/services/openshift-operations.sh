#!/bin/bash --login
# Usage ./openshift-operations.sh
echo "Starting Openshift Operations worker"
source config.sh
source init-common.sh

export PATH_PREFIX="/api"

cd $OPENSHIFT_DIR

# No args, used ENV vars:

# - QUEUE_HOST + QUEUE_PORT (path to kafka)
# - SOURCES_HOST + SOURCES_PORT (path to Sources API svc)
# - METRICS_PORT - Prometheus configuration, 0 to disable
bin/openshift-operations 

