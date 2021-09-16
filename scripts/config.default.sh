#!/usr/bin/env bash
#
# Create config.sh and write into it:
# ```
# root_dir="<your_dir>"
# source config.default.sh
# ```

# You can redefine services started by default
# in your config.sh
# See start_by_default()
source repositories.sh

# Required values:
#
# root_dir - Root directory for cloned repositories
#   created by install script install.sh
#
# MY_GITHUB_NAME - Your Github account name used for cloning
#
# MY_GITHUB_TOKEN - Get Github API token, needed for Github API requests.
#   read only access is enough.
#   https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line
#
# ACCOUNT_NUMBER - Account number is used to http auth header.
#   It equals Tenant.external_tenant db value.
#   If you log in to CI/QA/Prod server, you can see account number in dropbox under user name.
REQUIRED_VARIABLES=(root_dir MY_GITHUB_NAME MY_GITHUB_TOKEN ACCOUNT_NUMBER)
VAR_MISSING=false

for REQUIRED_VAR in "${REQUIRED_VARIABLES[@]}"
do
	if [[ -z "`eval echo \\$$REQUIRED_VAR`" ]]
	then
    echo "Please specify $REQUIRED_VAR variable in config.sh"
    VAR_MISSING=true
	fi
done

if $VAR_MISSING
then
  exit 1
fi

# LOG_DIR - When set, contains the name of the directory under which per-service log files will be saved.
#	The directory will be created if it does not exist.
#	When not set or zero length, logging information will not be captured.
: ${LOG_DIR:=""}
export LOG_DIR

# Variable for HTTP request header x-rh-identity.
# Requests authenticated against Tenant.external_tenant
export X_RH_IDENTITY=$(echo "{\"identity\":{\"account_number\":\"${GITHUB_NAME}\"}}" | base64)

if [[ "$(uname)" == "Darwin" ]]; then
  export MAC_OS=true
else
  export MAC_OS=false
fi

# Kafka queue
# Get latest release URL at https://kafka.apache.org/quickstart
: ${KAFKA_INSTALL_URL:="http://mirror.dkm.cz/apache/kafka/2.4.0/kafka_2.12-2.4.0.tgz"}
# Directory below is created automatically by script install.sh
: ${KAFKA_DIR:="$root_dir/kafka"}
: ${QUEUE_HOST:="localhost"} # used by openshift-operations
: ${QUEUE_PORT:="9092"}
export KAFKA_INSTALL_URL KAFKA_DIR QUEUE_HOST QUEUE_PORT

# Disable prometheus
export METRICS_PORT=0

# RVM ruby version & gemset
# Optional, if you're using RVM
: ${RVM_RUBY_VERSION_TP_INV:="2.5.3"}
: ${RVM_GEMSET_NAME_TP_INV:="tp-inv"}
export RVM_RUBY_VERSION_TP_INV RVM_GEMSET_NAME_TP_INV

# Uncomment if you want to disable tenancy
# export BYPASS_TENANCY=1

# Uncommenting causes Sources API RBAC disabled (default access: org-admin)
# export BYPASS_RBAC=true

# Topological Inventory Persister
export PERSISTER_DIR="$root_dir/topological_inventory-persister"

# Topological Inventory Sources Sync
export TOPOLOGICAL_INVENTORY_SYNC_DIR="$root_dir/topological_inventory-sync"

# Ingress API service (Persister <-> Collectors)
export INGRESS_API_DIR="$root_dir/topological_inventory-ingress_api"
export INGRESS_API="http://localhost:9292"
export TOPOLOGICAL_INVENTORY_INGRESS_API_HOST="http://localhost"
export TOPOLOGICAL_INVENTORY_INGRESS_API_PORT="9292"

# Topological API service
export TOPOLOGICAL_API_DIR="$root_dir/topological_inventory-api"
export TOPOLOGICAL_INVENTORY_HOST="http://localhost" # used by openshift operations
export TOPOLOGICAL_INVENTORY_PORT=3001
export TOPOLOGICAL_INVENTORY_URL="http://localhost:3001"
# - Used by api scripts
export TOPOLOGICAL_INVENTORY_API_BASE_PATH="api/topological-inventory/v3.0"

# Sources API service
export SOURCES_API_DIR="$root_dir/sources-api"
export SOURCES_SCHEME="http"
export SOURCES_HOST="localhost"
export SOURCES_PORT="3002"
# - Used by api scripts
export SOURCES_API_BASE_PATH="api/sources/v3.0"

# Sources monitor (availability check)
export SOURCES_MONITOR_DIR="$root_dir/sources-monitor"

# Sources SuperKey Worker service
export SOURCES_SUPERKEY_WORKER_DIR="$root_dir/sources-superkey-worker"

# Mock Source
: ${MOCK_SOURCE_DIR:="$root_dir/topological_inventory-mock_source"}
: ${MOCK_SOURCE_UID:="5eebe172-7baa-4280-823f-19e597d091e9"}  # random value for dev
: ${MOCK_SOURCE_CONFIG:="simple"}
: ${MOCK_SOURCE_DATA:="small"}
export MOCK_SOURCE_DIR MOCK_SOURCE_UID MOCK_SOURCE_CONFIG MOCK_SOURCE_DATA

# Openshift
: ${OPENSHIFT_DIR:="$root_dir/topological_inventory-openshift"}
: ${OPENSHIFT_SOURCE_UID:="31b5338b-685d-4056-ba39-d00b4d7f19cc"}  # random value for dev
: ${OPENSHIFT_SCHEME:="https"}
: ${OPENSHIFT_HOST:="openshift.example.com"}
: ${OPENSHIFT_PORT:="80"}
: ${OPENSHIFT_USER:="XXX"}
: ${OPENSHIFT_PASSWORD:="XXX"}
: ${OPENSHIFT_API_PATH:="/api"} # kubernetes API
export OPENSHIFT_DIR OPENSHIFT_SOURCE_UID OPENSHIFT_SCHEME OPENSHIFT_HOST OPENSHIFT_PORT
export OPENSHIFT_USER OPENSHIFT_PASSWORD OPENSHIFT_API_PATH

# Amazon
: ${AMAZON_DIR:="$root_dir/topological_inventory-amazon"}
: ${AMAZON_SOURCE_UID:="592ba27a-2b89-11e9-b210-d663bd873d93"} # random value for dev
: ${AMAZON_ACCESS_KEY_ID:="XXX"}
: ${AMAZON_SECRET_ACCESS_KEY:="XXX"}
export AMAZON_DIR AMAZON_SOURCE_UID AMAZON_ACCESS_KEY_ID AMAZON_SECRET_ACCESS_KEY

# Ansible Tower
: ${ANSIBLE_TOWER_DIR:="$root_dir/topological_inventory-ansible_tower"}
: ${ANSIBLE_TOWER_SOURCE_UID:="23d05717-ad56-4eec-8c34-cc0322e2c411"}  # random value for dev
: ${ANSIBLE_TOWER_SCHEME:="https"}
: ${ANSIBLE_TOWER_HOST:="tower.example.com"}
: ${ANSIBLE_TOWER_USER:="XXX"}
: ${ANSIBLE_TOWER_PASSWORD:="XXX"}
export ANSIBLE_TOWER_DIR ANSIBLE_TOWER_SOURCE_UID ANSIBLE_TOWER_SCHEME ANSIBLE_TOWER_HOST
export ANSIBLE_TOWER_USER ANSIBLE_TOWER_PASSWORD

# Azure
: ${AZURE_DIR:="$root_dir/topological_inventory-azure"}
: ${AZURE_SOURCE_UID:="4af9131d-d200-4516-950e-83f9926462a9"}
: ${AZURE_CLIENT_ID:="XXX"}
: ${AZURE_CLIENT_SECRET:="XXX"}
: ${AZURE_TENANT_ID:="XXX"}
export AZURE_DIR AZURE_SOURCE_UID AZURE_CLIENT_ID AZURE_CLIENT_SECRET AZURE_TENANT_ID

# UI
export INSIGHTS_PROXY_DIR="$root_dir/insights-proxy"
export SPANDX_CONFIG_PATH="$root_dir/scripts/insights-proxy/insights-proxy.config.js"

export SOURCES_UI_DIR="$root_dir/sources-ui"

# Orchestrator
export ORCHESTRATOR_DIR="$root_dir/topological_inventory-orchestrator"

# Scheduler
export SCHEDULER_DIR="$root_dir/topological_inventory-scheduler"

# Satellite
: ${SATELLITE_DIR:="$root_dir/sources-satellite"}
: ${SATELLITE_SOURCE_UID:="f3224fd3-bdc2-4c48-b8a7-3a35111d5808"}
: ${SATELLITE_SCHEME:="https"}
: ${SATELLITE_HOST:="satellite.example.com"}
export SATELLITE_DIR SATELLITE_SOURCE_UID SATELLITE_SCHEME SATELLITE_HOST

# Google Cloud Engine
: ${GOOGLE_DIR:="$root_dir/topological_inventory-google"}
: ${GOOGLE_SOURCE_UID:="1a8ec418-468a-4ea9-8f07-16ffca9b765d"}
: ${GOOGLE_PROJECT_ID:="XXX"}
: ${GOOGLE_AUTH_JSON:="{}"}
export GOOGLE_DIR GOOGLE_SOURCE_UID GOOGLE_PROJECT_ID GOOGLE_AUTH_JSON

# Haberdasher
: ${HABERDASHER_STDERR_EMITTER:="stderr"}
: ${HABERDASHER_KAFKA_EMITTER:="kafka"}
: ${HABERDASHER_EMITTER:="stderr"}
: ${HABERDASHER_KAFKA_BOOTSTRAP:="${QUEUE_HOST}:${QUEUE_PORT}"}
: ${HABERDASHER_KAFKA_TOPIC:="platform.logging.service"}
: ${HABERDASHER_PATH:=""}

export HABERDASHER_STDERR_EMITTER HABERDASHER_KAFKA_EMITTER HABERDASHER_EMITTER
export HABERDASHER_KAFKA_BOOTSTRAP HABERDASHER_KAFKA_TOPIC HABERDASHER_PATH
