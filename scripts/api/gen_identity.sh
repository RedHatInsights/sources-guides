#!/usr/bin/env bash

# This script will generate an x_rh_identity string, based on the user's config.sh
# settings, and echo the result to stdout.
#
# The string can then be used by development test scripts to access the API.
# See scripts/api/sources/dev_example.sh

source "config.sh"

plain_rh_identity="{\"identity\":{\"account_number\":\"${ACCOUNT_NUMBER}\",\"user\": {\"is_org_admin\":true}}, \"internal\": {\"org_id\": \"000001\"}}"

# base64 can split output to more lines, forbid it with one of following
# depends on base64 version:
if base64 --wrap=0 < /dev/null 2> /dev/null > /dev/null
then
    export X_RH_IDENTITY=$(echo ${plain_rh_identity} | base64 --wrap=0)
elif base64 --break=0 < /dev/null 2> /dev/null > /dev/null
then
    export X_RH_IDENTITY=$(echo ${plain_rh_identity} | base64 --break=0)
else
    export X_RH_IDENTITY=$(echo ${plain_rh_identity} | base64)
fi

echo $X_RH_IDENTITY
