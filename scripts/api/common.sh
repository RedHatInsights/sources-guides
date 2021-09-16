#!/usr/bin/env bash

source "config.sh"

plain_rh_identity="{\"identity\":{\"account_number\":\"${ACCOUNT_NUMBER}\",\"user\": {\"is_org_admin\":true}}, \"internal\": {\"org_id\": \"000001\"}}"

export X_RH_IDENTITY=`api/gen_identity.sh`

# Usage: topological_api_get <path>
# Example: topological_api_get "source_types?filter[name]=mock"
function topological_api_get {
    if [[ -z $2 ]]; then
        api_path=${TOPOLOGICAL_INVENTORY_API_BASE_PATH}
    else
        api_path=$2
    fi
    curl -H "x-rh-identity: ${X_RH_IDENTITY}" \
         --silent \
        "${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/${api_path}/$1"
}

# Usage: api_post <path> <data>
# Example: api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
function topological_api_post {
    curl --request POST \
         --header "Content-Type: application/json" \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --data "$2" \
         --silent \
         "${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/${TOPOLOGICAL_INVENTORY_API_BASE_PATH}/$1"
}

# Usage: api_post <path> <data>
# Example: api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
function topological_api_patch {
    curl --request PATCH \
         --header "Content-Type: application/json" \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --data "$2" \
         --silent \
         "${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/${TOPOLOGICAL_INVENTORY_API_BASE_PATH}/$1"
}

# Usage: api_delete <path>
# Example: api_delete "sources/1"
function topological_api_delete {
    curl --request DELETE \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --silent \
         "${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/${TOPOLOGICAL_INVENTORY_API_BASE_PATH}/$1"
}

# Usage: api_get <path>
# Example: api_get "source_types?filter[name]=mock"
function sources_api_get {
    if [[ -z $2 ]]; then
        api_path=${SOURCES_API_BASE_PATH}
    else
        api_path=$2
    fi
    if [[ -z $SOURCES_PSK ]]; then
        curl -H "x-rh-identity: ${X_RH_IDENTITY}" \
             --silent \
            "${SOURCES_HOST}:${SOURCES_PORT}/${api_path}/$1"
    else
        curl -H "x-rh-sources-account-number: ${ACCOUNT_NUMBER}" \
             -H "x-rh-sources-psk: ${SOURCES_PSK}" \
             --silent \
            "${SOURCES_HOST}:${SOURCES_PORT}/${api_path}/$1"
    fi
}

# Usage: api_post <path> <data>
# Example: api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
function sources_api_post {
    if [[ -z $SOURCES_PSK ]]; then
        curl --request POST \
             --header "Content-Type: application/json" \
             --header "x-rh-identity: ${X_RH_IDENTITY}" \
             --data "$2" \
             --silent \
             "${SOURCES_HOST}:${SOURCES_PORT}/${SOURCES_API_BASE_PATH}/$1"
    else
        curl --request POST \
             --header "Content-Type: application/json" \
             --header "x-rh-sources-account-number: ${ACCOUNT_NUMBER}" \
             --header "x-rh-sources-psk: ${SOURCES_PSK}" \
             --data "$2" \
             --silent \
             "${SOURCES_HOST}:${SOURCES_PORT}/${SOURCES_API_BASE_PATH}/$1"
    fi
}

# Usage: api_post <path> <data>
# Example: api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
function sources_api_patch {
  echo "1: ($1)"
  echo "2: ($2)"
  if [[ -z $SOURCES_PSK ]]; then
       curl --request PATCH \
         --header "Content-Type: application/json" \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --data "$2" \
         --silent \
         "${SOURCES_HOST}:${SOURCES_PORT}/${SOURCES_API_BASE_PATH}/$1"
  else
       curl --request PATCH \
             --header "Content-Type: application/json" \
             --header "x-rh-sources-account-number: ${ACCOUNT_NUMBER}" \
             --header "x-rh-sources-psk: ${SOURCES_PSK}" \
             --data "$2" \
             --silent \
             "${SOURCES_HOST}:${SOURCES_PORT}/${SOURCES_API_BASE_PATH}/$1"
  fi
}

# Usage: api_delete <path>
# Example: api_delete "sources/1"
function sources_api_delete {
    if [[ -z $SOURCES_PSK ]]; then
        curl --request DELETE \
             --header "x-rh-identity: ${X_RH_IDENTITY}" \
             --silent \
             "${SOURCES_HOST}:${SOURCES_PORT}/${SOURCES_API_BASE_PATH}/$1"
    else
        curl --request DELETE \
             --header "x-rh-sources-account-number: ${ACCOUNT_NUMBER}" \
             --header "x-rh-sources-psk: ${SOURCES_PSK}" \
             --silent \
             "${SOURCES_HOST}:${SOURCES_PORT}/${SOURCES_API_BASE_PATH}/$1"
    fi
}

######################################
# @param api_get response
function records_count {
    local cnt=`echo $1 | jq '.meta.count'`
    echo ${cnt}
}
