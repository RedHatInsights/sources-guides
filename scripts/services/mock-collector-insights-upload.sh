#!/bin/bash --login
echo "Starting MockSource -> InsightsUpload (file) generator"
source config.sh
source init-common.sh

cd $MOCK_SOURCE_DIR
bin/mock-collector-insights-upload --source $MOCK_SOURCE_UID --config $MOCK_SOURCE_CONFIG --data $MOCK_SOURCE_DATA \
--insights-upload-api="http://localhost:8888" --insights-upload-base-path="api/ingress/v1/upload" \
--tenant=$ACCOUNT_NUMBER
