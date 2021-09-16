#!/bin/bash --login

echo "Starting Sources SuperKey Worker"
source config.sh
source init-common.sh

cd $SOURCES_SUPERKEY_WORKER_DIR
echo $SOURCES_SUPERKEY_WORKER_DIR

go build
# - QUEUE_HOST + QUEUE_PORT (path to kafka)
# - SOURCES_SCHEME + SOURCES_HOST + SOURCES_PORT (path to Sources API svc)
# - METRICS_PORT - Prometheus configuration, 0 to disable
./sources-superkey-worker
