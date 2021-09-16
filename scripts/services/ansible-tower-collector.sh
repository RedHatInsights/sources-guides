#!/bin/bash --login
echo "Starting Ansible Tower collector"
source config.sh
source init-common.sh

cd $ANSIBLE_TOWER_DIR

# Single-source
 bin/ansible_tower-collector --source $ANSIBLE_TOWER_SOURCE_UID --scheme $ANSIBLE_TOWER_SCHEME --host $ANSIBLE_TOWER_HOST --user $ANSIBLE_TOWER_USER --password $ANSIBLE_TOWER_PASSWORD --metrics-port $METRICS_PORT
# Single-source on-premise
#bin/ansible_tower-collector --source $ANSIBLE_TOWER_SOURCE_UID --receptor-node node-a --account-number $ACCOUNT_NUMBER --metrics-port $METRICS_PORT
# Multi-source
# bin/ansible_tower-collector --config example-dev --metrics-port $METRICS_PORT
