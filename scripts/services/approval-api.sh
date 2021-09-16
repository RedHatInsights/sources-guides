#!/bin/bash --login
echo "Approval API"
source config.sh
source init-common.sh

cd $APPROVAL_API_DIR
env QUEUE_NAME="platform.approval" BYPASS_RBAC=1 AUTO_APPROVAL="y" PATH_PREFIX="api" APP_NAME="approval" PORT=${APPROVAL_API_SERVICE_PORT} rails s --binding 0.0.0.0
