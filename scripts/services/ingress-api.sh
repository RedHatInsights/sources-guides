#!/bin/bash --login
echo "Starting Ingress API Server..."

source config.sh
source init-common.sh

cd $INGRESS_API_DIR
env QUEUE_HOST=${QUEUE_HOST} QUEUE_PORT=${QUEUE_PORT} rails s -p 9292

