#!/bin/bash --login

source config.sh
source init-common.sh

echo "Starting insights proxy"

cd "$INSIGHTS_PROXY_DIR"
SPANDX_CONFIG=${SPANDX_CONFIG_PATH} bash "$INSIGHTS_PROXY_DIR/scripts/run.sh"