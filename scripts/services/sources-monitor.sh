#!/bin/bash

source config.sh
source init-common.sh

cd $SOURCES_MONITOR_DIR

operation=$1
if [[ ${operation} == "available" ]]; then
  echo "Unavailability check starting for available sources..."
  bin/availability_checker available
elif [[ ${operation} == "unavailable" ]]; then
  echo "Unavailability check starting for unavailable sources..."
  bin/availability_checker unavailable
else
  echo "Usage: sources-monitor.sh [available|unavailable]"
fi

