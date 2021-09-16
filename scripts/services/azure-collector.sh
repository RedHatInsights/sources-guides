#!/bin/bash --login
echo "Starting Azure source collector"
source config.sh
source init-common.sh

cd ${AZURE_DIR}
# Single Source
bin/azure-collector --source=${AZURE_SOURCE_UID} --client-id=${AZURE_CLIENT_ID} --client-secret=${AZURE_CLIENT_SECRET} --tenant-id=${AZURE_TENANT_ID} --metrics-port ${METRICS_PORT}
# Multi Source
#bin/azure-collector --config example-dev --metrics-port $METRICS_PORT
