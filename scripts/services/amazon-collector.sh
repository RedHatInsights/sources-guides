#!/bin/bash --login
echo "Starting Amazon source collector"
source config.sh
source init-common.sh

cd $AMAZON_DIR
# Single Source
bin/amazon-collector --source=${AMAZON_SOURCE_UID} --access-key-id=${AMAZON_ACCESS_KEY_ID} --secret-access-key=${AMAZON_SECRET_ACCESS_KEY} --metrics-port ${METRICS_PORT}
# Multi Source
# bin/amazon-collector --config example-dev --metrics-port $METRICS_PORT
